module SCTypes where

import Data.List
import qualified Data.Map as Map
import qualified Data.Set as Set

import AbsLatte

data VarT = BoolT | IntT | NoneT | StrT | VoidT deriving Eq

instance Show VarT where
    show BoolT = "bool"
    show IntT = "int"
    show StrT = "string"
    show VoidT = "void"
    show _ = "None"
    
getVarTFromType :: Show a => Type' a -> VarT
getVarTFromType (Int _) = IntT
getVarTFromType (Str _) = StrT
getVarTFromType (Bool _) = BoolT
getVarTFromType (Void _) = VoidT
getVarTFromType _ = NoneT

type ArgsT = [VarT]
type RetT = VarT
type FunT = (RetT, ArgsT)

data VarV = BoolV Bool | IntV Integer | StrV String | VoidV
instance Show VarV where
    show (BoolV v) = show v
    show (IntV v) = show v
    show (StrV v) = v
    show VoidV = error "Attempt to print void value"

type FunId = Ident
type VarId = Ident

type FunEnv = Map.Map FunId FunT
type VarEnv = Map.Map VarId VarT
type LocalStore = Set.Set VarId

data SCState = SCState {
    fEnv :: FunEnv,
    localStore :: LocalStore,
    vEnv :: VarEnv,
    retT :: RetT,
    returned :: Bool
}

type IntBinFun = Integer -> Integer -> Integer
type IntRelFun = Integer -> Integer -> Bool
type GenRelFun = Maybe VarV -> Maybe VarV -> Bool
type BoolBinFun = Bool -> Bool -> Bool

showIdent :: Ident -> String
showIdent (Ident id) = id

data SCError 
    = AndParamsTypeMismatchError VarT VarT
    | AssTypeMismatchError
    | DoubleFunDeclError FunId
    | FunArgsCountMismatchError
    | FunArgsTypeMismatchError VarT VarT
    | InvalidBoolNegError
    | InvalidIntNegError
    | ItemInitTypeMismatchError VarT VarT
    | MainTypeMismatchError
    | MultipleVarDeclError VarId
    | NonBoolConditionError
    | NonEmptyMainArgsError
    | NonIntegerDecrParamError VarId
    | NonIntegerIncrParamError VarId
    | NonIntegerMinusParamError VarT VarT
    | NonIntegerMulParamError VarT VarT
    | NonVoidRetVoidFunError
    | NoReturnError FunId
    | OrParamsTypeMismatchError VarT VarT
    | PlusParamsTypeMismatchError VarT VarT
    | RelParamsTypeMismatchError VarT VarT
    | RetTypeMismatchError VarT VarT
    | UndeclaredFunError FunId
    | UndeclaredVarError VarId
    | VarTypeMismatchError
    | VoidRetNonVoidFunError VarT
    | ZeroDivisionError

instance Show SCError where
    show (AndParamsTypeMismatchError g1 g2) = "Both conjunction parameters have to be boolean, got: " ++ show g1 ++ ", " ++ show g2
    show AssTypeMismatchError = "The type of assignment expression does not match the type of variable"
    show (DoubleFunDeclError funId) = "Multiple declarations of function " ++ showIdent funId
    show FunArgsCountMismatchError = "Unexpected number of arguments in function call"
    show (FunArgsTypeMismatchError e g) = "Invalid argument type in function call, expected: " ++ show e ++ " got: " ++ show g
    show InvalidBoolNegError = "Non-boolean type of boolean negation parameter"
    show InvalidIntNegError = "Non-integer type of arithmetic negation parameter"
    show (ItemInitTypeMismatchError e g) = "The type of expression does not match the type of variable, expected: " ++ show e ++ " got: " ++ show g
    show MainTypeMismatchError = "The return type of main function has to be integer"
    show (MultipleVarDeclError v) = "Multiple variable " ++ showIdent v ++ " declaration in local scope"
    show NonBoolConditionError = "Non-boolean type of condition expression"
    show NonEmptyMainArgsError = "Unexpected parameters in main function declaration"
    show (NonIntegerDecrParamError v) = "Non-integer type of decremented variable " ++ showIdent v
    show (NonIntegerIncrParamError v) = "Non-integer type of incremented variable " ++ showIdent v
    show (NonIntegerMinusParamError g1 g2) = "Both subtraction parameters have to be integer, got :" ++ show g1 ++ ", " ++ show g2
    show (NonIntegerMulParamError g1 g2) = "Both multiplication parameters have to be integer, got :" ++ show g1 ++ ", " ++ show g2
    show NonVoidRetVoidFunError = "Non-void return from void type function"
    show (NoReturnError f) = "Missing return statement in function " ++ showIdent f
    show (OrParamsTypeMismatchError g1 g2) = "Both disjunction parameters have to be boolean, got: " ++ show g1 ++ ", " ++ show g2
    show (PlusParamsTypeMismatchError g1 g2) = "Invalid types of parameters used with `+` operator, got: " ++ show g1 ++ ", " ++ show g2
    show (RelParamsTypeMismatchError g1 g2) = "Invalid types of parameters used with relational operator, got: " ++ show g1 ++ ", " ++ show g2
    show (RetTypeMismatchError e g) = "Invalid expression type returned from a function, expected: " ++ show e ++ ", got: " ++ show g
    show (UndeclaredFunError f) = "Use of undeclared function " ++ showIdent f
    show (UndeclaredVarError v) = "Use of undeclared variable " ++ showIdent v
    show VarTypeMismatchError = "Invalid variable type"
    show (VoidRetNonVoidFunError g) = "Void return from " ++ show g ++ " type function"
    show ZeroDivisionError = "Division by zero"