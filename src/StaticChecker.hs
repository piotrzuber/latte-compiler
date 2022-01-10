module StaticChecker where

import Control.Monad
import Control.Monad.Except
import Control.Monad.State
import qualified Data.Map as Map
import qualified Data.Set as Set
import System.Exit
import System.IO

import AbsLatte
import SCTypes

type SC = ExceptT String (State SCState)

getVarT :: BNFC'Position -> Ident -> SC VarT
getVarT pos ident = do
    state <- get
    case Map.lookup ident (vEnv state) of
        Just t -> return t
        Nothing -> throwSCError pos $ UndeclaredVarError ident

getFunT :: BNFC'Position -> Ident -> SC FunT
getFunT pos ident = do
    state <- get
    case Map.lookup ident (fEnv state) of
        Just t -> return t
        Nothing -> throwSCError pos $ UndeclaredFunError ident

prettifyPos :: BNFC'Position -> String
prettifyPos (Just (l, c)) = "line: " ++ show l ++ ", col: " ++ show c
prettifyPos pos = show pos

throwSCError :: BNFC'Position -> SCError -> SC b
throwSCError pos err = throwError $ "Static check error found at " ++ prettifyPos pos ++ ": " ++ show err

evalExp :: Expr -> SC (VarT, Maybe VarV)
evalExp (EVar pos ident) = do
    t <- getVarT pos ident
    return (t, Nothing)
evalExp (ELitInt _ i) = return (IntT, Just (IntV i))
evalExp (ELitTrue _) = return (BoolT, Just (BoolV True))
evalExp(ELitFalse _) = return (BoolT, Just (BoolV False))
evalExp (EApp pos ident args) = do
    (retT, argsT) <- getFunT pos ident
    assertArgsT pos argsT args
    return (retT, Nothing)
evalExp (EString _ s) = return (StrT, Just (StrV s))
evalExp (Neg pos exp) = do
    (expT, expV) <- evalExp exp
    unless (expT == IntT) $ throwSCError pos InvalidIntNegError
    case expV of
        Just (IntV i) -> return (IntT, Just (IntV (negate i)))
        _ -> return (IntT, Nothing)
evalExp (Not pos exp) = do
    (expT, expV) <- evalExp exp
    unless (expT == BoolT) $ throwSCError pos InvalidBoolNegError
    case expV of
        Just (BoolV b) -> return (BoolT, Just (BoolV (not b)))
        _ -> return (BoolT, Nothing)
evalExp (EMul _ lhs op rhs) = do
    let pos = hasPosition op
    (lhsT, lhsV) <- evalExp lhs
    (rhsT, rhsV) <- evalExp rhs
    unless (lhsT == IntT && rhsT == IntT) $ throwSCError pos $ NonIntegerMulParamError lhsT rhsT
    case op of
        Times _ -> return (IntT, integerBinaryOp (*) lhsV rhsV)
        Div pos -> case rhsV of
            Just (IntV 0) -> throwSCError pos ZeroDivisionError
            _ -> return (IntT, integerBinaryOp div lhsV rhsV)
        Mod pos -> case rhsV of
            Just (IntV 0) -> throwSCError pos ZeroDivisionError
            _ -> return (IntT, integerBinaryOp mod lhsV rhsV)
evalExp (EAdd _ lhs op rhs) = case op of
    Minus pos -> do
        (lhsT, lhsV) <- evalExp lhs
        (rhsT, rhsV) <- evalExp rhs
        if (lhsT == IntT && rhsT == IntT)
            then return (IntT, integerBinaryOp (-) lhsV rhsV)
            else throwSCError pos $ NonIntegerMinusParamError lhsT rhsT
    Plus pos -> do
        (lhsT, lhsV) <- evalExp lhs
        (rhsT, rhsV) <- evalExp rhs
        unless ((lhsT == IntT || lhsT == StrT) && (lhsT == rhsT)) $
            throwSCError pos $ PlusParamsTypeMismatchError lhsT rhsT
        case lhsT of
            IntT -> return (IntT, integerBinaryOp (+) lhsV rhsV)
            StrT -> case (lhsV, rhsV) of 
                (Just (StrV ls), Just (StrV rs)) -> return (StrT, Just (StrV (ls ++ rs)))
                _ -> return (StrT, Nothing)
            _ -> throwSCError pos $ PlusParamsTypeMismatchError lhsT rhsT
evalExp (ERel _ lhs op rhs) = do
    let pos = hasPosition op
    (lhsT, lhsV) <- evalExp lhs
    (rhsT, rhsV) <- evalExp rhs
    unless (lhsT == rhsT) $ throwSCError pos $ RelParamsTypeMismatchError lhsT rhsT
    when (lhsT == VoidT) $ throwSCError pos $ VoidTypeComparisonError
    case op of
        EQU _ -> return (BoolT, genericRelOp (==) lhsV rhsV)
        NE _ -> return (BoolT, genericRelOp (/=) lhsV rhsV)
        _ -> do
            unless (lhsT == IntT && rhsT == lhsT) $
                throwSCError pos $ RelParamsTypeMismatchError lhsT rhsT
            case op of
                LTH _ -> return (BoolT, integerRelOp (<) lhsV rhsV)
                LE _ -> return (BoolT, integerRelOp (<=) lhsV rhsV)
                GTH _ -> return (BoolT, integerRelOp (>) lhsV rhsV)
                GE _ -> return (BoolT, integerRelOp (<=) lhsV rhsV)
evalExp (EAnd pos lhs rhs) = do
    (lhsT, lhsV) <- evalExp lhs
    (rhsT, rhsV) <- evalExp rhs
    if (lhsT == BoolT && rhsT == lhsT) 
        then return (BoolT, booleanBinaryOp (&&) lhsV rhsV)
        else throwSCError pos $ AndParamsTypeMismatchError lhsT rhsT
evalExp (EOr pos lhs rhs) = do
    (lhsT, lhsV) <- evalExp lhs
    (rhsT, rhsV) <- evalExp rhs
    if (lhsT == BoolT && rhsT == lhsT)
        then return (BoolT, booleanBinaryOp (||) lhsV rhsV)
        else throwSCError pos $ OrParamsTypeMismatchError lhsT rhsT

assertArgsT :: BNFC'Position -> ArgsT -> [Expr] -> SC ()
assertArgsT pos [] [] = return ()
assertArgsT pos (tHead : tTail) (eHead : eTail) = do
    _ <- assertArgsT pos tTail eTail
    (eType, _) <- evalExp eHead
    unless (tHead == eType) $ throwSCError (hasPosition eHead) $ FunArgsTypeMismatchError tHead eType
assertArgsT pos _ _ = throwSCError pos FunArgsCountMismatchError

integerBinaryOp :: IntBinFun -> Maybe VarV -> Maybe VarV -> Maybe VarV
integerBinaryOp op lhs rhs = case (lhs, rhs) of
    (Just (IntV i1), Just (IntV i2)) -> Just (IntV (op i1 i2))
    _ -> Nothing

integerRelOp :: IntRelFun -> Maybe VarV -> Maybe VarV -> Maybe VarV
integerRelOp op lhs rhs = case (lhs, rhs) of
    (Just (IntV i1), Just (IntV i2)) -> Just (BoolV (op i1 i2))
    _ -> Nothing

genericRelOp :: GenRelFun -> Maybe VarV -> Maybe VarV -> Maybe VarV
genericRelOp op lhs rhs = case (lhs, rhs) of
    (Just _, Just _) -> Just (BoolV (op lhs rhs))
    _ -> Nothing

booleanBinaryOp :: BoolBinFun -> Maybe VarV -> Maybe VarV -> Maybe VarV
booleanBinaryOp op lhs rhs = case (lhs, rhs) of
    (Just (BoolV b1), Just (BoolV b2)) -> Just (BoolV (op b1 b2))
    _ -> Nothing

evalStmt :: Stmt -> SC ()
evalStmt (Empty _) = return ()
evalStmt (BStmt _ block) = do
    ret <- sandbox $ do
        evalBlockStmt block
        gets returned
    when ret $ modify (\s -> s {returned = True})
evalStmt (Decl pos t items) = evalItemList (getVarTFromType t) items
    where 
        evalItemList :: VarT -> [Item] -> SC ()
        evalItemList t [] = return ()
        evalItemList t (iHead : iTail) = evalItem t iHead >> evalItemList t iTail
            where
                evalItem :: VarT -> Item -> SC ()
                evalItem t (NoInit pos ident) = storeVar pos ident t
                evalItem t (Init pos ident exp) = do
                    (expT, _) <- evalExp exp
                    when (t /= expT) $ throwSCError pos $ ItemInitTypeMismatchError t expT
                    storeVar pos ident t
evalStmt (Ass pos ident exp) = do 
    varT <- getVarT pos ident
    (expT, _) <- evalExp exp
    when (varT /= expT) $ throwSCError pos AssTypeMismatchError
evalStmt (Incr pos ident) = do
    varT <- getVarT pos ident
    when (varT /= IntT) $ throwSCError pos $ NonIntegerIncrParamError ident
evalStmt (Decr pos ident) = do
    varT <- getVarT pos ident
    when (varT /= IntT) $ throwSCError pos $ NonIntegerDecrParamError ident
evalStmt (Ret pos exp) = do
    retT <- gets retT
    when (retT == VoidT) $ throwSCError pos NonVoidRetVoidFunError
    (expT, _) <- evalExp exp
    when (retT /= expT) $ throwSCError pos $ RetTypeMismatchError retT expT
    modify (\s -> s {returned = True})
evalStmt (VRet pos) = do
    retT <- gets retT
    when (retT /= VoidT) $ throwSCError pos $ VoidRetNonVoidFunError retT
    modify (\s -> s {returned = True})
evalStmt (Cond pos exp stmt) = do
    (expT, expV) <- evalExp exp
    when (BoolT /= expT) $ throwSCError pos NonBoolConditionError
    ret <- sandbox$ do
        evalStmt stmt
        gets returned
    when ((expV == Just (BoolV True)) && ret) $ modify (\s -> s {returned = True})
evalStmt (CondElse pos exp s1 s2) = do
    (expT, expV) <- evalExp exp
    when (BoolT /= expT) $ throwSCError pos NonBoolConditionError
    ret1 <- sandbox $ do
        evalStmt s1
        gets returned
    ret2 <- sandbox $ do
        evalStmt s2
        gets returned
    when (ret1 && ret2) $ modify (\s -> s {returned = True})
    when ((expV == Just (BoolV True)) && ret1) $ modify (\s -> s {returned = True})
    when ((expV == Just (BoolV False)) && ret2) $ modify (\s -> s {returned = True})
evalStmt (While pos exp stmt) = do
    (expT, expV) <- evalExp exp
    when (BoolT /= expT) $ throwSCError pos NonBoolConditionError
    ret <- sandbox $ do
        evalStmt stmt
        gets returned
    when ((expV == Just (BoolV True)) && ret) $ modify (\s -> s {returned = True})
evalStmt (SExp pos exp) = void $ evalExp exp

evalBlockStmt :: Block -> SC ()
evalBlockStmt (Block _ stmts) = evalStmtList stmts

evalStmtList :: [Stmt] -> SC ()
evalStmtList [] = return ()
evalStmtList (sHead : sTail) = evalStmt sHead >> evalStmtList sTail

sandbox :: SC a -> SC a
sandbox m = do
    stateBak <- get
    modify (\state -> state { localStore = Set.empty })
    res <- m
    put stateBak
    return res

storeVar :: BNFC'Position -> Ident -> VarT -> SC ()
storeVar pos ident t = do
    state <- get
    when (Set.member ident (localStore state)) $
        throwSCError pos $ MultipleVarDeclError ident
    when (t == NoneT || t == VoidT) $
        throwSCError pos $ VarTypeMismatchError
    put $ SCState (fEnv state) (Set.insert ident (localStore state)) (Map.insert ident t (vEnv state)) (retT state) (returned state)

evalTopDefList :: [TopDef] -> SC ()
evalTopDefList [] = return ()
evalTopDefList (dHead : dTail) = evalTopDef dHead >> evalTopDefList dTail
    where
        evalTopDef :: TopDef -> SC ()
        evalTopDef (FnDef pos t ident args block) = do
            let retT = getVarTFromType t
            sandbox $ do
                modify (\s -> s {retT = retT})
                evalArgs args
                evalBlockStmt block
                returned <- gets returned
                when (VoidT /= retT && not returned) $ throwSCError pos $ NoReturnError ident

evalArgs :: [Arg] -> SC ()
evalArgs [] = return ()
evalArgs (aHead : aTail) = evalArg aHead >> evalArgs aTail
    where
        evalArg :: Arg -> SC ()
        evalArg (Arg pos t ident) = do
            let varT = getVarTFromType t
            storeVar pos ident varT

storeFun :: FunId -> FunT -> SC ()
storeFun funId funT = do
    state <- get
    put $ SCState (Map.insert funId funT (fEnv state)) (localStore state) (vEnv state) (retT state) (returned state)

builtins :: [(FunId, FunT)]
builtins = [
        ((Ident "printInt"), (VoidT, [IntT])),
        ((Ident "printString"), (VoidT, [StrT])),
        ((Ident "error"), (VoidT, [])),
        ((Ident "readInt"), (IntT, [])),
        ((Ident "readString"), (StrT, []))
    ]

initBuiltins :: [(FunId, FunT)] -> SC ()
initBuiltins [] = return ()
initBuiltins ((funId, funT) : bTail) = storeFun funId funT >> initBuiltins bTail

evalFunDeclList :: [TopDef] -> SC ()
evalFunDeclList [] = return ()
evalFunDeclList (dHead : dTail) = evalFunDecl dHead >> evalFunDeclList dTail
    where
        evalFunDecl :: TopDef -> SC ()
        evalFunDecl (FnDef pos t funId args block) = do
            env <- get
            if Map.member funId (fEnv env)
                then throwSCError pos $ DoubleFunDeclError funId
                else do
                    let retT = getVarTFromType t
                    let argsT = map (\(Arg _ argT _) -> getVarTFromType argT) args
                    when (funId == Ident "main") $ do
                        when (retT /= IntT) $ throwSCError pos MainTypeMismatchError
                        when (argsT /= []) $ throwSCError pos NonEmptyMainArgsError
                    storeFun funId (retT, argsT)

evalProgram :: Program -> SC ()
evalProgram (Program pos defList) = do
    initBuiltins builtins
    evalFunDeclList defList
    evalTopDefList defList
    getFunT (Just (0, 0)) (Ident "main")
    return ()

exitWithErrorMsg :: String -> IO ()
exitWithErrorMsg msg = do
    hPutStrLn stderr "ERROR"
    hPutStrLn stderr "Static check finished with errors"
    hPutStrLn stderr msg
    exitFailure

runEvaluation :: Program -> IO ()
runEvaluation p = do
    let initState = SCState {
        fEnv = Map.empty,
        localStore = Set.empty,
        vEnv = Map.empty,
        retT = NoneT,
        returned = False
    }
    case evalState (runExceptT $ evalProgram p) initState of
        Left e -> exitWithErrorMsg e
        _ -> hPutStrLn stderr "OK"
