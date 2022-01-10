module CompilerX86 where

import Control.Monad
import Control.Monad.Except
import Control.Monad.State
import qualified Data.Map as Map
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

compExp :: Expr -> CMonad Instruction
compExp (EVar pos ident) = pushVar pos ident 0
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

compFunApp :: Ident -> [Expr] -> Type -> CMonad Instruction
compFunApp (Ident ident) args retT = do
    compdArgs <- mapM compExp args
    let argsLen = List.length args
    let compdPopArgs = IBlock $ replicate argsLen $ getPopl $ show EBX
    let compdApp = IBlock [IBlock compdArgs, getCall ident, compdPopArgs]
    case retT of
        Void _ -> return compdApp
        _ -> return $ IBlock [compdApp, getPushl $ show EAX]

pushVar :: BNFC'Position -> Ident -> Integer -> CMonad Instruction
pushVar pos ident off = do
    s <- get
    let varOff = offset $ (varEnv s) Map.! ident
    return $ getPushl $ show (off + varOff) ++ "(" ++ show EBP ++ ")"

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
                getPopl $ show EBX, getPopl $ show EBX, getPushl $ show EAX]
        _ -> do
            compdExp1 <- compExp exp1
            compdExp2 <- compExp exp2
            compdOp <- compNumOp op
            return $ IBlock [compdExp1, compdExp2, compdOp]

compNumOp :: BinaryOp -> CMonad Instruction
compNumOp (BinAdd (Minus _)) = return $ IBlock [getPopl $ show EAX, getPopl $ show EBX, 
    getSubl (show EAX) (show EBX), getPushl $ show EBX]
compNumOp (BinAdd (Plus _)) = return $ IBlock [getPopl $ show EAX, getPopl $ show EBX, 
    getAddl (show EBX) (show EAX), getPushl $ show EAX]
compNumOp (BinMul (Div _)) = return $ IBlock [getPopl $ show EBX, getPopl $ show EAX,
    getMovl (show EAX) (show EDX), Indent "sar $31, %edx", getIdiv $ show EBX, getPushl $ show EAX]
compNumOp (BinMul (Mod _)) = return $ IBlock [getPopl $ show EBX, getPopl $ show EAX,
    getMovl (show EAX) (show EDX), Indent "sar $31, %edx", getIdiv $ show EBX, getPushl $ show EDX]
compNumOp (BinMul (Times _)) = return $ IBlock [getPopl $ show EAX, getPopl $ show EBX, 
    getImul (show EBX) (show EAX), getPushl $ show EAX]
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
evalExpType (EVar _ ident) = do
    s <- get
    return $ vType $ (varEnv s) Map.! ident
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

compStmt :: Stmt -> CMonad Instruction
compStmt (Empty _) = return EmptyIns
compStmt (BStmt _ (Block _ stmts)) = do
    s <- get
    compdBlock <- mapM compStmt stmts
    labelId <- nextLabelId
    put $ CState (varEnv s) (funRetEnv s) (strEnv s) (minStack s) (maxStack s) labelId
    return $ IBlock compdBlock
compStmt (Decl _ t items) = do 
    s <- get
    let stack = minStack s
    (compdItems, _) <- evalItemList t items stack
    return compdItems
compStmt (Ass _ ident exp) = do 
    t <- evalExpType exp
    compdIdent <- do
        s <- get
        let varOff = offset $ (varEnv s) Map.! ident
        let compdVar = show varOff ++ "(" ++ show EBP ++ ")"
        return $ IBlock [getLeal compdVar $ show EAX, getPushl $ show EAX]
    compdExp <- compExp exp
    return $ IBlock [compdIdent, compdExp, getPopl $ show EAX, getPopl $ show EBX, 
        getMovl (show EAX) ("(" ++ show EBX ++ ")")]
compStmt (Incr _ ident) = do
    compdIdent <- do
        s <- get
        let varOff = offset $ (varEnv s) Map.! ident
        let compdVar = show varOff ++ "(" ++ show EBP ++ ")"
        return $ IBlock [getLeal compdVar (show EAX), getPushl $ show EAX]
    return $ IBlock [compdIdent, getPopl $ show EAX, getIncl ("(" ++ show EAX ++ ")")]
compStmt (Decr _ ident) = do
    compdIdent <- do
        s <- get
        let varOff = offset $ (varEnv s) Map.! ident
        let compdVar = show varOff ++ "(" ++ show EBP ++ ")"
        return $ IBlock [getLeal compdVar (show EAX), getPushl $ show EAX]
    return $ IBlock [compdIdent, getPopl $ show EAX, getDecl ("(" ++ show EAX ++ ")")]
compStmt (Ret _ exp) = do
    compdExp <- compExp exp
    return $ IBlock [compdExp, getPopl $ show EAX, getLeave, getRet]
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
    s <- get
    put $ CState (Map.insert ident (getNewVar t (size - 4)) (varEnv s)) (funRetEnv s) (strEnv s) (min (size - 4) (minStack s)) (maxStack s) (label s)
    updatedState <- get
    let varOff = offset $ (varEnv updatedState) Map.! ident
    let compdVar = show varOff ++ "(" ++ show EBP ++ ")"
    return (IBlock [compdDecl, getPopl compdVar], size - 4)

getInitValue :: Type -> Expr
getInitValue (Str _) = EString Nothing ""
getInitValue _ = ELitInt Nothing 0

getNewVar :: Type -> Integer -> VarT
getNewVar t off = VarT {
    vType = t,
    offset = off
}

compTopDef :: TopDef -> CMonad Instruction
compTopDef (FnDef _ t i@(Ident ident) args b@(Block _ block)) = do
    let funL = NoIndent $ ident ++ ":"
    prepareArgs 4 $ reverse args
    s <- get
    compdBlock <- compFun b
    blockS <- get
    put $ CState (varEnv s) (funRetEnv s) (strEnv s) (minStack s) (maxStack s) (label blockS)
    if not $ null block then
        case last block of
            (Ret _ _)  -> return $ IBlock [funL, getPushl $ show EBP, getMovl (show ESP) (show EBP), compdBlock]
            (VRet _) -> return $ IBlock [funL, getPushl $ show EBP, getMovl (show ESP) (show EBP), compdBlock]
            _ -> return $ IBlock [funL, getPushl $ show EBP, getMovl (show ESP) (show EBP), compdBlock, getLeave]
    else
        return $ IBlock [funL, getPushl $ show EBP, getMovl (show ESP) (show EBP), compdBlock, getLeave]

prepareArgs :: Integer -> [Arg] -> CMonad Integer
prepareArgs s [] = return s
prepareArgs size ((Arg _ tHead iHead) : aTail) = do
    s <- get
    put $ CState (Map.insert iHead (getNewVar tHead (size + 4)) (varEnv s)) (funRetEnv s) (strEnv s) (minStack s) (maxStack s) (label s)
    prepareArgs (size + 4) aTail

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
    _ -> getVarsSize sTail size

compProg :: Program -> CMonad Instruction
compProg prog@(Program pos topDefs) = do
    mapM_ prepareFunction topDefs
    mapM_ prepareFunction builtins
    compdStrs <- prepareStrings prog
    compdTopDefs <- mapM compTopDef topDefs
    return $ IBlock [compdStrs, IBlock compdTopDefs]

prepareFunction :: TopDef -> CMonad ()
prepareFunction (FnDef _ t ident _ _ ) = do
    st <- get
    modify (\s -> s {funRetEnv = Map.insert ident t (funRetEnv st)})

builtins :: [TopDef]
builtins = [
    FnDef Nothing (Void Nothing) (Ident "error") [] (Block Nothing [Empty Nothing]),
    FnDef Nothing (Void Nothing) (Ident "printInt") [Arg Nothing (Int Nothing) (Ident "num")] (Block Nothing [Empty Nothing]),
    FnDef Nothing (Int Nothing) (Ident "readInt") [] (Block Nothing [Empty Nothing]),
    FnDef Nothing (Void Nothing) (Ident "printString") [Arg Nothing (Str Nothing) (Ident "str")] (Block Nothing [Empty Nothing]),
    FnDef Nothing (Str Nothing) (Ident "readString") [] (Block Nothing [Empty Nothing])]

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
getStringsTopDef (FnDef _ _ _ _ (Block _ stmts)) = concatMap getStringsStmt stmts

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
getStringsStmt _ = []

getStringsItem :: Item -> [String]
getStringsItem (NoInit _ _) = [""]
getStringsItem (Init _ _ exp) = getStringsExp exp

getStringsExp :: Expr -> [String]
getStringsExp (EString _ string) = [string]
getStringsExp (EAdd _ e1 (Plus _) e2) = getStringsExp e1 ++ getStringsExp e2
getStringsExp (EApp _ _ args) = concatMap getStringsExp args
getStringsExp _ = []

prepareString :: Integer -> String -> CMonad ()
prepareString label str = do
    st <- get
    modify (\s -> s {strEnv = Map.insert str ("LStr" ++ show label) (strEnv st)})
    return ()

declString :: String -> CMonad Instruction
declString string = do
    s <- get
    let stringL = (strEnv s) Map.! string
    return $ IBlock [NoIndent (stringL ++ ":"), NoIndent $ ".string " ++ show string]

compile :: Program -> String
compile p = let initState = CState {
    varEnv = Map.empty,
    funRetEnv = Map.empty,
    strEnv = Map.empty,
    minStack = 0,
    maxStack = 0,
    label = 0
} in getMainDecl ++ show (evalState (compProg p) initState)