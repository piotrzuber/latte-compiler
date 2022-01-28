module CompilerX86 where

import Control.Monad
import Control.Monad.Except
import Control.Monad.State
import qualified Data.Map as Map
import Data.Maybe
import qualified Data.Set as Set
import qualified Data.List as List
import System.Exit
import System.IO

import InstructionsX86
import TypesX86
import AbsLatte

type CMonad = State CState

nextLabelId :: CMonad Integer
nextLabelId = do
    st <- get
    let labelId = label st
    modify (\s -> s {label = labelId + 1})
    return labelId

getVarT :: Ident -> CMonad Type
getVarT ident = do
    s <- get
    if Map.member ident (varEnv s) then
        return $ vType $ (varEnv s) Map.! ident
    else
        evalExpType (EProp Nothing (EVar Nothing (Ident "self")) ident)

getTypeSize :: Type -> Integer
getTypeSize (Array _ _) = 8
getTypeSize (Bool _) = 4
getTypeSize (ClsType _ _) = 4
getTypeSize (Int _) = 4
getTypeSize (Str _) = 4
getTypeSize _ = 0

getVarOff :: Ident -> CMonad Integer
getVarOff ident = do
    s <- get
    return $ offset $ case Map.lookup ident (varEnv s) of
        Just var -> var
        _ -> error "VarOff lookup error"

compExp :: Expr -> CMonad Instruction
compExp (EVar pos ident) = do
    t <- getVarT ident
    case t of
        Array _ _ -> do
            compdVar <- pushVar pos ident 0
            compdLen <- pushVar pos ident 4
            return $ IBlock [compdLen, compdVar]
        _ -> pushVar pos ident 0
compExp (ELitInt _ i) = return $ getPushl $ "$" ++ show i
compExp (ELitTrue _) = return $ getPushl "$1"
compExp (ELitFalse _) = return $ getPushl "$0"
compExp (EApp pos id@(Ident ident) args) = do
    retT <- evalRetType pos id
    compFunApp id args retT
compExp (EString _ str) = do 
    s <- get
    strLabel <- case Map.lookup str (strEnv s) of
        (Just label) -> return label
        _ -> error "No string label in env"
    return $ getPushl $ "$" ++ strLabel
compExp (Neg pos exp) = do
    compdExp <- compExp exp
    return $ IBlock [compdExp, getPopl $ show EAX, 
        getNeg $ show EAX, getPushl $ show EAX]
compExp (Not pos exp) = compBooleanExp $ Not pos exp 
compExp (EAdd _ exp1 op exp2) = compBinaryOp (BinAdd op) exp1 exp2
compExp (EMul _ exp1 op exp2) = compBinaryOp (BinMul op) exp1 exp2
compExp (ERel _ exp1 op exp2) = compBinaryOp (BinRel op) exp1 exp2
compExp (EAnd pos exp1 exp2) = compBooleanExp $ EAnd pos exp1 exp2
compExp (EOr pos exp1 exp2) = compBooleanExp $ EOr pos exp1 exp2
compExp (ENewArr _ t exp) = do
    compdExp <- compExp exp
    return $ IBlock [getPushl $ "$" ++ show (getTypeSize t), compdExp, getCall "calloc", getPopl $ show EDX, getPopl $ show ECX, getPushl $ show EDX, getPushl $ show EAX]
compExp (EArrGet _ e1 e2) = do
    compdArrGet <- compLValue $ EArrGet Nothing e1 e2
    return $ IBlock [compdArrGet, getPopl $ show EAX, getPushl $ "(" ++ show EAX ++ ")"]
compExp (ENewCls _ (ClsType _ name)) = do
    ct <- evalClassType name
    hasVT <- hasVTable name
    let v = if hasVT then "$" ++ getVTable name else "$0"
    return $ IBlock [getPushl "$4", getPushl $ "$" ++ show (align ct), getCall "calloc", getPopl $ show ECX, getPopl $ show ECX, getMovl v "(%eax)", getPushl $ show EAX]
compExp (EProp _ exp ident) = do
    t <- evalExpType exp
    case t of
        (Array _ _ ) -> do
            compdExp <- compLValue exp
            return $ IBlock [compdExp, getPopl $ show EAX, getPushl "4(%eax)"]
        _ -> do
            compdExp <- compLValue (EProp Nothing exp ident)
            return $ IBlock [compdExp, getPopl $ show EAX, getPushl $ "(" ++ show EAX ++ ")"]
compExp (EPropApp _ lval i@(Ident ident) args) = do
    compdLval <- compLValue lval
    lt <- evalExpType lval
    let cname = case lt of
            (ClsType _ cname) -> cname
            _ -> error "EPropApp cname type error"
    ct <- evalClassType cname
    let (ClsFunT rt vt (Ident cls)) = case Map.lookup i (fEnv ct) of
            (Just e) -> e
            _ -> error "EPropApp lookup error"
    let prepRegs = case rt of
            (Void _) -> [getPopl $ show ECX] 
            _ -> [getPopl $ show ECX, getPopl $ show ECX, getPushl $ show EAX]
    case vt of
        (Just vid) -> do
            compdFunApp <- compFunApp (Ident $ "*" ++ show (4 * vid) ++ "(%edx)") args rt
            return $ IBlock [compdLval, getPopl $ show EAX, getMovl "(%eax)" (show ECX), getMovl "(%ecx)" (show EDX), getPushl "(%eax)", compdFunApp, IBlock prepRegs]
        _ -> do
            compdFunApp <- compFunApp (Ident (cls ++ "$" ++ ident)) args rt
            return $ IBlock [compdLval, getPopl $ show EAX, getPushl "(%eax)", compdFunApp, IBlock prepRegs]
compExp (ENull _ ident) = return $ getPushl "$0"

hasVTable :: Ident -> CMonad Bool
hasVTable ident = do
    ct <- evalClassType ident
    return $ not $ null $ filter (\(ClsFunT _ vt _) -> isJust vt) $ Map.elems (fEnv ct)

getVTable :: Ident -> String
getVTable (Ident ident) = "." ++ ident ++ "_vtable"

initVTables :: CMonad Instruction
initVTables = do
    s <- get
    compdInit <- mapM initVTable $ Map.keys (clsEnv s)
    return $ IBlock compdInit

initVTable :: Ident -> CMonad Instruction
initVTable ident = do
    ct <- evalClassType ident
    let v = List.sort $ map castFunToVirtual [(fn, ft) | (fn, ft) <- Map.toList (fEnv ct), isJust (vmid ft)]
    let vs = foldl (\red (_, id) -> red ++ "," ++ id) "" v
    if not $ null vs then
        return $ NoIndent $ getVTable ident ++ ": .int " ++ tail vs
    else
        return EmptyIns

castFunToVirtual :: (Ident, ClsFunT) -> (Integer, String)
castFunToVirtual (fn, ft) = (fromJust (vmid ft), unwrapIdent (cls ft) ++ "$" ++ unwrapIdent fn)

unwrapIdent :: Ident -> String
unwrapIdent (Ident ident) = ident

compFunApp :: Ident -> [Expr] -> Type -> CMonad Instruction
compFunApp (Ident ident) args retT = do
    compdArgs <- mapM compExp args
    argsLen <- getArgsSize args
    let compdPopArgs = getAddl ("$" ++ (show (argsLen * 4))) (show ESP)
    let compdApp = IBlock [IBlock compdArgs, getCall ident, compdPopArgs]
    case retT of
        Array _ _ -> return $ IBlock [compdApp, getPushl $ show EDX, getPushl $ show EAX]
        Void _ -> return compdApp
        _ -> return $ IBlock [compdApp, getPushl $ show EAX]

getArgsSize :: [Expr] -> CMonad Integer
getArgsSize [] = return 0
getArgsSize (eHead:eTail) = do
    t <- evalExpType eHead
    tailSize <- getArgsSize eTail
    case t of 
        Array _ _ -> return $ 2 + tailSize
        _ -> return $ 1 + tailSize

pushVar :: BNFC'Position -> Ident -> Integer -> CMonad Instruction
pushVar pos ident off = do
    s <- get
    if Map.member ident (varEnv s) then do
        compdVar <- pushVarContent ident off
        return $ getPushl compdVar
    else 
        compExp (EProp Nothing (EVar Nothing (Ident "self")) ident)

pushVarContent :: Ident -> Integer -> CMonad String
pushVarContent ident off = do
    vo <- getVarOff ident
    return $ show (vo + off) ++ "(" ++ show EBP ++ ")"

compLValue :: Expr -> CMonad Instruction
compLValue (EVar _ ident) = do
    s <- get
    if Map.member ident (varEnv s) then do
        compdVarS <- pushVarContent ident 0
        return $ IBlock [getLeal compdVarS (show EAX), getPushl $ show EAX]
    else
        compLValue $ EProp Nothing (EVar Nothing (Ident "self")) ident
compLValue (EArrGet _ a i) = do
    compdArr <- compLValue a
    compdIdx <- compExp i
    return $ IBlock [compdArr, compdIdx, getPopl (show EAX), getPopl (show EDX), 
        getMovl ("(" ++ show EDX ++ ")") (show ECX), getLeal "(%ecx, %eax, 4)" (show EDX), getPushl $ show EDX]
compLValue (EProp _ exp ident) = do
    et <- evalExpType exp
    let cls = case et of
            (ClsType _ cls) -> cls
            _ -> error "EProp exp type error"
    compdExp <- compLValue exp
    ct <- evalClassType cls
    let varOff = offset $ case Map.lookup ident (vEnv ct) of
            Just vo -> vo
            _ -> error "Eprop lvalue lookup error"
    return $ IBlock [compdExp, getPopl (show EAX), getMovl ("(" ++ (show EAX) ++ ")") (show ECX),
        getLeal (show varOff ++ "(" ++ show ECX ++ ")") (show EAX), getPushl $ show EAX]
compLValue e@(EApp _ ident args) = compExp e

evalRetType :: BNFC'Position -> Ident -> CMonad Type
evalRetType pos ident = do
    s <- get
    case Map.lookup ident (funRetEnv s) of
        (Just t) -> return t
        Nothing -> error "Fun ident not found in env"

compBinaryOp :: BinaryOp -> Expr -> Expr -> CMonad Instruction
compBinaryOp op exp1 exp2 = do
    t <- evalExpType exp1
    case t of 
        (Str _) -> do
            compdExp1 <- compExp exp1
            compdExp2 <- compExp exp2
            return $ IBlock [compdExp2, compdExp1, getCall "concat",
                getPopl $ show ECX, getPopl $ show ECX, getPushl $ show EAX]
        _ -> do
            compdExp1 <- compExp exp1
            compdExp2 <- compExp exp2
            compdOp <- compNumOp op
            return $ IBlock [compdExp1, compdExp2, compdOp]

compNumOp :: BinaryOp -> CMonad Instruction
compNumOp (BinAdd (Minus _)) = return $ IBlock [getPopl $ show EAX, getPopl $ show ECX, 
    getSubl (show EAX) (show ECX), getPushl $ show ECX]
compNumOp (BinAdd (Plus _)) = return $ IBlock [getPopl $ show EAX, getPopl $ show ECX, 
    getAddl (show ECX) (show EAX), getPushl $ show EAX]
compNumOp (BinMul (Div _)) = return $ IBlock [getPopl $ show ECX, getPopl $ show EAX,
    getMovl (show EAX) (show EDX), Indent "sar $31, %edx", getIdiv $ show ECX, getPushl $ show EAX]
compNumOp (BinMul (Mod _)) = return $ IBlock [getPopl $ show ECX, getPopl $ show EAX,
    getMovl (show EAX) (show EDX), Indent "sar $31, %edx", getIdiv $ show ECX, getPushl $ show EDX]
compNumOp (BinMul (Times _)) = return $ IBlock [getPopl $ show EAX, getPopl $ show ECX, 
    getImul (show ECX) (show EAX), getPushl $ show EAX]
compNumOp (BinRel op) = do
    falseL <- nextLabelId
    trueL <- nextLabelId
    return $ IBlock [getPopl $ show EAX, getCmpl (show EAX) "0(%esp)", condJmp falseL op,
        getPushl "$1", uncondJmp trueL, getLabelDecl falseL, getPushl "$0",
        getLabelDecl trueL]

compBooleanExp :: Expr -> CMonad Instruction
compBooleanExp exp = do
    trueL <- nextLabelId
    falseL <- nextLabelId
    finallyL <- nextLabelId
    compdExp <- compBooleanExp_ exp trueL falseL
    return $ IBlock [compdExp, getLabelDecl trueL, getPushl "$1", 
        uncondJmp finallyL, getLabelDecl falseL, getPushl "$0", 
        getLabelDecl finallyL]
compBooleanExp_ :: Expr -> Integer -> Integer -> CMonad Instruction
compBooleanExp_ (EAnd _ exp1 exp2) trueL falseL = do
    auxL <- nextLabelId
    compdExp1 <- compBooleanExp_ exp1 auxL falseL
    compdExp2 <- compBooleanExp_ exp2 trueL falseL
    return $ IBlock [compdExp1, getLabelDecl auxL, compdExp2]
compBooleanExp_ (EOr _ exp1 exp2) trueL falseL = do
    auxL <- nextLabelId
    compdExp1 <- compBooleanExp_ exp1 trueL auxL
    compdExp2 <- compBooleanExp_ exp2 trueL falseL
    return $ IBlock [compdExp1, getLabelDecl auxL, compdExp2]
compBooleanExp_ rel@(ERel _ exp1 op exp2) trueL falseL = do
    compdExp <- compExp rel
    return $ IBlock [compdExp, getPopl $ show EAX, getTestl (show EAX) (show EAX), noZeroJmp trueL,
        uncondJmp falseL]
compBooleanExp_ (Not _ exp) trueL falseL = 
    compBooleanExp_ exp falseL trueL
compBooleanExp_ exp trueL falseL = do
    compdExp <- compExp exp
    return $ IBlock [compdExp, getPopl $ show EAX, getTestl (show EAX) (show EAX), noZeroJmp trueL,
        uncondJmp falseL]

evalExpType :: Expr -> CMonad Type
evalExpType (EVar _ ident) = getVarT ident
evalExpType (ELitInt _ _) = return $ Int Nothing
evalExpType (ELitTrue _) = return $ Bool Nothing
evalExpType (ELitFalse _) = return $ Bool Nothing
evalExpType (EApp pos ident _) = evalRetType pos ident
evalExpType (EString _ _) = return $ Str Nothing
evalExpType (Neg _ _) = return $ Int Nothing
evalExpType (Not _ _) = return $ Bool Nothing
evalExpType (EMul _ _ _ _) = return $ Int Nothing
evalExpType (EAdd _ _ (Plus _) exp) = evalExpType exp 
evalExpType (EAdd _ _ (Minus _) exp) = return $ Int Nothing
evalExpType (ERel _ _ _ _) = return $ Bool Nothing
evalExpType (EAnd _ _ _ ) = return $ Bool Nothing
evalExpType (EOr _ _ _ ) = return $ Bool Nothing
evalExpType (ENewArr _ t _) = return $ Array Nothing t
evalExpType (EArrGet _ exp _) = do
    t <- evalExpType exp
    case t of
        (Array _ at) -> return at
        _ -> error "EArrGet type error" 
evalExpType (ENewCls _ (ClsType _ ident)) = return $ ClsType Nothing ident
evalExpType (EProp _ exp ident) = do
    t <- evalExpType exp
    case t of
        (ClsType _ name) -> do
            ct <- evalClassType name
            return $ vType $ case Map.lookup ident (vEnv ct) of
                Just t' -> t'
                _ -> error "EProp lookup error"
        (Array _ _) -> return $ Int Nothing
evalExpType (EPropApp _ exp ident _) = do
    et <- evalExpType exp
    let name = case et of
            (ClsType _ name) -> name
            _ -> error "EPropApp type error"
    ct <- evalClassType name
    case Map.lookup ident (fEnv ct) of
        (Just t) -> return $ clsFunRetT t
        _ -> error "EPropApp lookup error"
evalExpType (ENull _ ident) = return $ ClsType Nothing ident

evalClassType :: Ident -> CMonad ClsT
evalClassType ident = do
    s <- get
    case Map.lookup ident (clsEnv s) of
        (Just ct) -> return ct
        _ -> error $ "evalClassType lookup error: " ++ unwrapIdent ident

compStmt :: Stmt -> CMonad Instruction
compStmt (Empty _) = return EmptyIns
compStmt (BStmt _ (Block _ stmts)) = do
    s <- get
    compdBlock <- mapM compStmt stmts
    labelId <- nextLabelId
    put $ CState (clsEnv s) (varEnv s) (funRetEnv s) (strEnv s) (minStack s) (maxStack s) labelId
    return $ IBlock compdBlock
compStmt (Decl _ t items) = do 
    s <- get
    let stack = minStack s
    (compdItems, _) <- evalItemList t items stack
    return compdItems
compStmt (Ass _ e1 e2) = do 
    t <- evalExpType e2
    compdE1 <- compLValue e1
    compdE2 <- compExp e2
    case t of
        (Array _ _) -> return $ IBlock [compdE1, compdE2, getPopl $ show EAX, getPopl $ show EDX,
            getPopl $ show ECX, getMovl (show EAX) ("(" ++ show ECX ++ ")"), getAddl "$4" (show ECX),
            getMovl (show EDX) ("(" ++ show ECX ++ ")")]
        _ -> return $ IBlock [compdE1, compdE2, getPopl $ show EAX, getPopl $ show ECX, 
            getMovl (show EAX) ("(" ++ show ECX ++ ")")]
compStmt (Incr _ exp) = do
    compdExp <- compLValue exp
    return $ IBlock [compdExp, getPopl $ show EAX, getIncl ("(" ++ show EAX ++ ")")]
compStmt (Decr _ exp) = do
    compdExp <- compLValue exp
    return $ IBlock [compdExp, getPopl $ show EAX, getDecl ("(" ++ show EAX ++ ")")]
compStmt (Ret _ exp) = do
    t <- evalExpType exp
    compdExp <- compExp exp
    case t of 
        (Array _ _) -> return $ IBlock [compdExp, getPopl $ show EAX, getPopl $ show EDX, getLeave, getRet]
        _ -> return $ IBlock [compdExp, getPopl $ show EAX, getLeave, getRet]
compStmt (VRet _) = return $ IBlock [getLeave, getRet]
compStmt (Cond _ exp stmt) = do
    trueL <- nextLabelId
    falseL <- nextLabelId
    compdExp <- compBooleanExp_ exp trueL falseL
    compdStmt <- compStmt (BStmt Nothing (Block Nothing [stmt]))
    return $ IBlock [compdExp, getLabelDecl trueL, compdStmt, 
        getLabelDecl falseL]
compStmt (CondElse _ exp s1 s2) = do
    trueL <- nextLabelId
    falseL <- nextLabelId
    finallyL <- nextLabelId
    compdExp <- compBooleanExp_ exp trueL falseL
    compdS1 <- compStmt (BStmt Nothing (Block Nothing [s1]))
    compdS2 <- compStmt (BStmt Nothing (Block Nothing [s2]))
    return $ IBlock [compdExp, getLabelDecl trueL, compdS1,
        uncondJmp finallyL, getLabelDecl falseL, compdS2, getLabelDecl finallyL]
compStmt (While _ exp stmt) = do
    condL <- nextLabelId
    loopL <- nextLabelId
    finallyL <- nextLabelId
    compdExp <- compBooleanExp_ exp loopL finallyL
    compdStmt <- compStmt (BStmt Nothing (Block Nothing [stmt]))
    return $ IBlock [getLabelDecl condL, compdExp, getLabelDecl loopL, 
        compdStmt, uncondJmp condL, getLabelDecl finallyL]
compStmt (SExp _ exp) = compExp exp
compStmt (For _ t i exp stmt) = do
    s <- get
    modify (\s -> s {maxStack = (maxStack s) + 1})
    compdBlock <- compStmt $ getForAbs t i exp stmt
    lid <- nextLabelId
    put s
    modify (\s -> s {label = lid})
    return compdBlock

getForAbs :: Type -> Ident -> Expr -> Stmt -> Stmt
getForAbs t i exp stmt = BStmt Nothing $ 
    Block Nothing [
        Decl Nothing (Int Nothing) [Init Nothing (getIterator i) (ELitInt Nothing 0)],
        While Nothing (ERel Nothing (EVar Nothing (getIterator i)) (LTH Nothing) (EProp Nothing exp (Ident "length"))) $ BStmt Nothing $ Block Nothing [
            Decl Nothing t [Init Nothing i (EArrGet Nothing exp (EVar Nothing (getIterator i)))],
            stmt,
            Incr Nothing (EVar Nothing (getIterator i))
            ]
        ]

getIterator :: Ident -> Ident
getIterator (Ident ident) = Ident ("iterator_" ++ ident)

evalItemList :: Type -> [Item] -> Integer -> CMonad (Instruction, Integer)
evalItemList _ [] stack = return (EmptyIns, stack)
evalItemList t (iHead : iTail) stack = do
    (compdItem, updatedS) <- evalItem t iHead stack
    (compdTail, newStack) <- evalItemList t iTail updatedS
    return (IBlock [compdItem, compdTail], newStack)

evalItem :: Type -> Item -> Integer -> CMonad (Instruction, Integer)
evalItem t item size = do
    compdDecl <- compExp $ case item of
        (Init _ _ exp) -> exp
        (NoInit _ _) -> getInitValue t
    ident <- case item of 
        (Init _ i _) -> return i
        (NoInit _ i) -> return i
    let sizeOfVar = getTypeSize t
    s <- get
    put $ CState (clsEnv s) (Map.insert ident (getNewVar t (size - sizeOfVar)) (varEnv s)) (funRetEnv s) (strEnv s) (min (size - sizeOfVar) (minStack s)) (maxStack s) (label s)
    updatedState <- get
    compdVar <- pushVarContent ident 0
    case t of
        (Array _ _) -> do
            compdLen <- pushVarContent ident 4
            return (IBlock [compdDecl, getPopl compdVar, getPopl compdLen], size - sizeOfVar)
        _ -> return (IBlock [compdDecl, getPopl compdVar], size - sizeOfVar)

getInitValue :: Type -> Expr
getInitValue (Array _ t) = ENewArr Nothing t (ELitInt Nothing 0)
getInitValue (Str _) = EString Nothing ""
getInitValue _ = ELitInt Nothing 0

getNewVar :: Type -> Integer -> VarT
getNewVar t off = VarT {
    vType = t,
    offset = off
}

compTopDef :: TopDef -> CMonad Instruction
compTopDef (TopFnDef _ (FnDef _ t i@(Ident ident) args b@(Block _ block))) = do
    let funL = NoIndent $ ident ++ ":"
    size <- prepareArgs 4 $ reverse args
    s <- get
    when (Map.member (Ident "self") (varEnv s)) (do
        let (VarT vt vo) = (varEnv s) Map.! (Ident "self")
        when (vo < 0) (
            modify (\s -> s {varEnv = Map.insert (Ident "self") (getNewVar vt (size + getTypeSize vt)) (varEnv s)})
            ))
    compdBlock <- compFun b
    blockS <- get
    put $ CState (clsEnv s) (varEnv s) (funRetEnv s) (strEnv s) (minStack s) (maxStack s) (label blockS)
    if not $ null block then
        case last block of
            (Ret _ _)  -> return $ IBlock [funL, getPushl $ show EBP, getMovl (show ESP) (show EBP), compdBlock]
            (VRet _) -> return $ IBlock [funL, getPushl $ show EBP, getMovl (show ESP) (show EBP), compdBlock]
            _ -> return $ IBlock [funL, getPushl $ show EBP, getMovl (show ESP) (show EBP), compdBlock, getLeave, getRet]
    else
        return $ IBlock [funL, getPushl $ show EBP, getMovl (show ESP) (show EBP), compdBlock, getLeave, getRet]
compTopDef (ClsDef _ i@(Ident cname) stmts) = do
    s <- get
    modify (\st -> st {varEnv = Map.insert (Ident "self") (getNewVar (ClsType Nothing i) (-1)) (varEnv s)})
    compdFnProps <- mapM compTopDef [TopFnDef Nothing $ clsFnDef cname fnDef | (FnProp _ fnDef) <- stmts]
    s2 <- get
    put $ CState (clsEnv s) (varEnv s) (funRetEnv s) (strEnv s) (minStack s) (maxStack s) (label s2)
    return $ IBlock compdFnProps
compTopDef (ClsExtDef _ cname _ stmts) = compTopDef (ClsDef Nothing cname stmts)

clsFnDef :: String -> FnDef -> FnDef
clsFnDef cname (FnDef _ rt (Ident fn) args block) =
    FnDef Nothing rt (Ident $ cname ++ "$" ++ fn) args block

prepareArgs :: Integer -> [Arg] -> CMonad Integer
prepareArgs s [] = return s
prepareArgs size ((Arg _ tHead iHead) : aTail) = do
    st <- get
    let s = getTypeSize tHead
    let ex = case tHead of
            Array _ _ -> 4
            _ -> 0
    let off = s + size - ex
    put $ CState (clsEnv st) (Map.insert iHead (getNewVar tHead off) (varEnv st)) (funRetEnv st) (strEnv st) (minStack st) (maxStack st) (label st)
    prepareArgs (size + s) aTail

compFun :: Block -> CMonad Instruction
compFun (Block _ stmts) = do
    stateBak <- get
    mem <- prepareStack stmts
    put stateBak
    compdStmts <- mapM compStmt stmts
    return $ IBlock (mem : compdStmts)

prepareStack :: [Stmt] -> CMonad Instruction
prepareStack stmts = do
    alloc <- getVarsSize stmts 0
    return $ getSubl ("$" ++ show (-alloc)) (show ESP)

getVarsSize :: [Stmt] -> Integer -> CMonad Integer
getVarsSize [] s = return s
getVarsSize (sHead : sTail) size = case sHead of
    (Decl _ t items) -> do
        (_, updatedS) <- evalItemList t items size
        getVarsSize sTail updatedS
    (Cond _ _ stmt) -> getVarsSize (stmt:sTail) size
    (CondElse _ _ stmt1 stmt2) -> getVarsSize (stmt1:stmt2:sTail) size
    (BStmt _ (Block _ stmts)) -> do
        updatedS <- getVarsSize stmts size
        getVarsSize sTail updatedS
    (While _ _ stmt) -> getVarsSize (stmt:sTail) size
    (For _ t ident _ stmt) -> do
        (_, updatedS) <- evalItemList t [NoInit Nothing ident] size
        (_, maxS) <- evalItemList (Int Nothing) [NoInit Nothing (Ident "dummy")] updatedS
        getVarsSize (stmt:sTail) maxS
    _ -> getVarsSize sTail size

compProg :: Program -> CMonad Instruction
compProg prog@(Program pos topDefs) = do
    mapM_ prepareFunction [fnDef | (TopFnDef _ fnDef) <- topDefs]
    mapM_ prepareFunction builtins
    prepareClasses prog
    initVTables
    compdStrs <- prepareStrings prog
    compdTopDefs <- mapM compTopDef topDefs
    compdVTables <- initVTables
    return $ IBlock [compdStrs, compdVTables, IBlock compdTopDefs]

prepareFunction :: FnDef -> CMonad ()
prepareFunction (FnDef _ t ident _ _ ) = do
    st <- get
    modify (\s -> s {funRetEnv = Map.insert ident t (funRetEnv st)})

builtins :: [FnDef]
builtins = [
    FnDef Nothing (Void Nothing) (Ident "error") [] (Block Nothing [Empty Nothing]),
    FnDef Nothing (Void Nothing) (Ident "printInt") [Arg Nothing (Int Nothing) (Ident "num")] (Block Nothing [Empty Nothing]),
    FnDef Nothing (Int Nothing) (Ident "readInt") [] (Block Nothing [Empty Nothing]),
    FnDef Nothing (Void Nothing) (Ident "printString") [Arg Nothing (Str Nothing) (Ident "str")] (Block Nothing [Empty Nothing]),
    FnDef Nothing (Str Nothing) (Ident "readString") [] (Block Nothing [Empty Nothing])]

prepareClasses :: Program -> CMonad ()
prepareClasses (Program _ topDefs) = do
    let extDefs = [(Just super, name, stmts) | (ClsExtDef _ name super stmts) <- topDefs]
    let clsDefs = [(Nothing, name, stmts) | (ClsDef _ name stmts) <- topDefs]
    let defs = extDefs ++ clsDefs
    mapM_ prepareClass defs
    s <- get
    let clsStmts = Map.fromList [(ident, stmts) | (_, ident, stmts) <- defs]
    let clsIdents = [ident | (_, ident, _) <- defs]
    let subClss = [ident | ident <- clsIdents, ident `notElem` [sident | ClsT {super = Just sident} <- Map.elems (clsEnv s)]]
    mapM_ (\i -> clsInit (Just i) Set.empty clsStmts) subClss

prepareClass :: (Maybe Ident, Ident, [ClsStmt]) -> CMonad ()
prepareClass (superi, ident, _) = do
    s <- get
    let cls = ClsT {
        super = superi,
        vEnv = Map.empty,
        fEnv = Map.empty,
        nextVM = (-1),
        align = 0
    }
    modify (\st -> st {clsEnv = Map.insert ident cls (clsEnv s)})

clsInit :: Maybe Ident -> Set.Set Ident -> Map.Map Ident [ClsStmt] -> CMonad (VarEnv, Integer)
clsInit Nothing  _ _ = return (Map.empty, 4)
clsInit (Just i) fset stmtsMap = do
    ct <- evalClassType i
    if nextVM ct >= 0 then 
        return (vEnv ct, align ct)
    else do
        let defs = case Map.lookup i stmtsMap of
                Just d -> d
                _ -> error "clsInit stmtsMap lookup error"
        let fs = [fnDef | (FnProp _ fnDef) <- defs]
        let vars = [ap | ap@(AttrProp _ _ _) <- defs]
        let fsetUpdate = Set.union fset $ Set.fromList [id | (FnDef _ _ id _ _) <- fs]
        (superE, superS) <- clsInit (super ct) fsetUpdate stmtsMap
        let (env, size) = foldl (\(e, s) (AttrProp _ t id) -> (Map.insert id (getNewVar t s) e, s + getTypeSize t)) (superE, superS) vars
        (superFE, superVi) <- case super ct of
            (Just super) -> do
                pct <- evalClassType super
                return (fEnv pct, nextVM pct)
            _ -> return (Map.empty, 0)
        let (fenv, virt) = foldl (\(fe, vi) (FnDef _ t fid _ _) -> 
                case Map.lookup fid fe of
                    Just ClsFunT {vmid = Just v} -> (Map.insert fid (ClsFunT t (Just v) i) fe, vi)
                    _ -> (Map.insert fid (ClsFunT t (Just vi) i) fe, vi + 1)) (superFE, superVi) fs
        st <- get
        let c' = ClsT {
            super = super ct,
            vEnv = env,
            fEnv = fenv,
            nextVM = virt,
            align = size
        }
        modify (\s -> s {clsEnv = Map.insert i c' (clsEnv st)})
        return (env, size)

prepareStrings :: Program -> CMonad Instruction
prepareStrings prog = do
    let strs = getStringsProgram prog
    foldM_ (\l str -> do
        prepareString l str
        return (l + 1)) 0 strs
    compdStrs <- mapM declString strs
    return $ IBlock compdStrs

getStringsProgram :: Program -> [String]
getStringsProgram (Program _ topDefs) = List.nub $ concatMap getStringsTopDef topDefs

getStringsTopDef :: TopDef -> [String]
getStringsTopDef (TopFnDef _ (FnDef _ _ _ _ (Block _ stmts))) = concatMap getStringsStmt stmts
getStringsTopDef (ClsDef _ _ stmts) = concatMap getStringsClsStmt stmts
getStringsTopDef (ClsExtDef _ _ _ stmts) = concatMap getStringsClsStmt stmts

getStringsClsStmt :: ClsStmt -> [String]
getStringsClsStmt (FnProp _ fnDef) = getStringsTopDef (TopFnDef Nothing fnDef)
getStringsClsStmt _ = []

getStringsStmt :: Stmt -> [String]
getStringsStmt (BStmt _ (Block _ stmts)) = concatMap getStringsStmt stmts
getStringsStmt (Decl _ (Str _) items) = concatMap getStringsItem items
getStringsStmt (Ass _ _ exp) = getStringsExp exp
getStringsStmt (Ret _ exp) = getStringsExp exp
getStringsStmt (Cond _ exp stmt) = getStringsExp exp ++ getStringsStmt stmt
getStringsStmt (CondElse _ exp s1 s2) = getStringsExp exp ++
    getStringsStmt s1 ++
    getStringsStmt s2
getStringsStmt (While _ exp stmt) = getStringsExp exp ++ getStringsStmt stmt
getStringsStmt (SExp _ exp) = getStringsExp exp
getStringsStmt (For _ _ _ exp stmt) = getStringsExp exp ++ getStringsStmt stmt
getStringsStmt _ = []

getStringsItem :: Item -> [String]
getStringsItem (NoInit _ _) = [""]
getStringsItem (Init _ _ exp) = getStringsExp exp

getStringsExp :: Expr -> [String]
getStringsExp (EString _ string) = [string]
getStringsExp (EAdd _ e1 (Plus _) e2) = getStringsExp e1 ++ getStringsExp e2
getStringsExp (EApp _ _ args) = concatMap getStringsExp args
getStringsExp (ERel _ e1 (EQU _) e2) = getStringsExp e1 ++ getStringsExp e2
getStringsExp _ = []

prepareString :: Integer -> String -> CMonad ()
prepareString label str = do
    st <- get
    modify (\s -> s {strEnv = Map.insert str ("LStr" ++ show label) (strEnv st)})
    return ()

declString :: String -> CMonad Instruction
declString string = do
    s <- get
    let stringL = case Map.lookup string (strEnv s) of
            (Just l) -> l
            _ -> error "declString lookup error"
    return $ IBlock [NoIndent (stringL ++ ":"), NoIndent $ ".string " ++ show string]

compile :: Program -> String
compile p = let initState = CState {
    clsEnv = Map.empty,
    varEnv = Map.empty,
    funRetEnv = Map.empty,
    strEnv = Map.empty,
    minStack = 0,
    maxStack = 0,
    label = 0
} in getMainDecl ++ show (evalState (compProg p) initState)