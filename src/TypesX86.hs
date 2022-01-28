module TypesX86 where

import qualified Data.Map as Map

import AbsLatte

data BinaryOp = BinAdd AddOp | BinMul MulOp | BinRel RelOp

data VarT = VarT {
    vType :: Type,
    offset :: Integer
} deriving (Eq, Show)

data ClsFunT = ClsFunT {
    clsFunRetT :: Type,
    vmid :: Maybe Integer,
    cls :: Ident
} deriving Show

type ClsFunEnv = Map.Map Ident ClsFunT

data ClsT = ClsT {
    super :: Maybe Ident,
    vEnv :: VarEnv,
    fEnv :: ClsFunEnv,
    nextVM :: Integer,
    align :: Integer
} deriving Show

type VarEnv = Map.Map Ident VarT
type FunRetEnv = Map.Map Ident Type
type StrEnv = Map.Map String String
type ClsEnv = Map.Map Ident ClsT

data CState = CState {
    clsEnv :: ClsEnv,
    varEnv :: VarEnv,
    funRetEnv :: FunRetEnv,
    strEnv :: StrEnv,
    minStack :: Integer,
    maxStack :: Integer,
    label :: Integer
}

data Instruction 
    = EmptyIns
    | IBlock [Instruction]
    | Indent String
    | NoIndent String
    | Noop

instance Show Instruction where
    show EmptyIns = ""
    show (IBlock ins) = stripInstructions $ unlines $ map (\i -> show i) ins
    show (Indent i) = "    " ++ i
    show (NoIndent i) = i

stripInstructions :: String -> String
stripInstructions [] = []
stripInstructions [c] = [c]
stripInstructions ('\n' : '\n' : tail) = '\n' : stripInstructions tail
stripInstructions (sHead : sTail) = sHead : (stripInstructions sTail)

data Register 
    = EAX
    | EBX
    | ECX
    | EDX
    | EBP
    | ESP
    deriving Eq

instance Show Register where
    show EAX = "%eax"
    show EBX = "%ebx"
    show ECX = "%ecx"
    show EDX = "%edx"
    show EBP = "%ebp"
    show ESP = "%esp"