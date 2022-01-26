module SCTypes where

import Data.List
import qualified Data.Map as Map
import qualified Data.Set as Set

import AbsLatte

data VarT 
    = BoolT 
    | IntT 
    | NoneT 
    | StrT 
    | VoidT 
    | ArrayT Type
    | ClassT Ident
    deriving Eq

instance Show VarT where
    show BoolT = "bool"
    show IntT = "int"
    show StrT = "string"
    show VoidT = "void"
    show (ArrayT t) = "[" ++ (show (getVarTFromType t)) ++ "]"
    show (ClassT i) = show i
    show _ = "None"
    
getVarTFromType :: Type -> VarT
getVarTFromType (Int _) = IntT
getVarTFromType (Str _) = StrT
getVarTFromType (Bool _) = BoolT
getVarTFromType (Void _) = VoidT
getVarTFromType (Array _ t) = ArrayT t
getVarTFromType (ClsType _ i) = ClassT i
getVarTFromType _ = NoneT

data ClsT = ClsT {
    superName :: Maybe Ident,
    cVEnv :: VarEnv,
    cFEnv :: FunEnv
}

type ArgsT = [VarT]
type RetT = VarT
type FunT = (RetT, ArgsT)

data VarV = BoolV Bool | IntV Integer | StrV String | VoidV deriving Eq
instance Show VarV where
    show (BoolV v) = "Bool " ++ show v
    show (IntV v) = "Int " ++ show v
    show (StrV v) = "Str " ++ v
    show VoidV = error "Attempt to print void value"

type FunId = Ident
type VarId = Ident

type FunEnv = Map.Map FunId FunT
type VarEnv = Map.Map VarId VarT
type ClsEnv = Map.Map Ident ClsT
type LocalStore = Set.Set VarId

data SCState = SCState {
    cEnv :: ClsEnv,
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
    | VoidTypeComparisonError
    | ZeroDivisionError
    | DebugError (Maybe VarV) (Maybe VarV)
    | ArrayIndexTypeMismatchError
    | ArrTypeMismatchError VarT
    | UnknownClassInitError Ident
    | InvalidArrayAttrError Ident
    | UnknownClassAttributeError Ident Ident
    | UnknownClassNameError Ident
    | NonObjectTypeError VarT
    | NonMethodTypeError VarT
    | InvalidNullCastError
    | NonIterableForError VarT

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
    show VoidTypeComparisonError = "Attempt to compare void variables"
    show ZeroDivisionError = "Division by zero"
    show (DebugError v1 v2) = "DEBUG!!!! 1st: " ++ show v1 ++ " 2nd: " ++ show v2
    show ArrayIndexTypeMismatchError = "An index of an array must be an integer"
    show (ArrTypeMismatchError g) = "Subscripted value is not an array, got: " ++ show g
    show (UnknownClassInitError i) = "Initialization of an object of an unknown class: " ++ show i
    show (InvalidArrayAttrError i) = "An array has no attribute " ++ show i
    show (UnknownClassAttributeError c a) = "No " ++ show a ++ " attribute for class " ++ show c
    show (UnknownClassNameError i) = "Cannot find class " ++ show i
    show (NonObjectTypeError t) = "Variable of type " ++ show t ++ " cannot have attributes"
    show (NonMethodTypeError t) = "Type " ++ show t ++ " cannot have methods"
    show (InvalidNullCastError) = "Invalid usage of null typecast"
    show (NonIterableForError t) = "Non-iterable type " ++ show t ++ " in foreach loop"