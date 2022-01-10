module InstructionsX86 where

import TypesX86
import AbsLatte

getBinOpArgs :: String -> String -> String
getBinOpArgs arg1 arg2 = arg1 ++ ", " ++ arg2

-- Memory Control

getPushl :: String -> Instruction
getPushl src = Indent $ "pushl " ++ src

getPopl :: String -> Instruction
getPopl dest = Indent $ "popl " ++ dest

getMovl :: String -> String -> Instruction
getMovl src dest = Indent $ "movl " ++ getBinOpArgs src dest 

getLeave :: Instruction
getLeave = Indent "leave"

-- Flow Control

getMainDecl :: String
getMainDecl = ".globl main\n\n"

showLabel :: Integer -> String
showLabel labelId = "L" ++ show labelId

showLabelDecl :: Integer -> String
showLabelDecl labelId = showLabel labelId ++ ":"

getLabelDecl :: Integer -> Instruction
getLabelDecl labelId = NoIndent $ showLabelDecl labelId

getTestl :: String -> String -> Instruction
getTestl src dest = Indent $ "testl " ++ getBinOpArgs src dest 

getCmpl :: String -> String -> Instruction
getCmpl src1 src2 = Indent $ "cmpl " ++ getBinOpArgs src1 src2
 
uncondJmp :: Integer -> Instruction
uncondJmp labelId = Indent $ "jmp " ++ showLabel labelId

condJmp :: Integer -> RelOp -> Instruction
condJmp labelId op = Indent $ jmpOp op ++ showLabel labelId
    where 
        jmpOp :: RelOp -> String
        jmpOp op = case op of
            EQU _ -> "jne "
            NE _ -> "je "
            GE _ -> "jl "
            GTH _ -> "jle "
            LE _ -> "jg "
            LTH _ -> "jge "

noZeroJmp :: Integer -> Instruction
noZeroJmp labelId = Indent $ "jnz " ++ showLabel labelId

getCall :: String -> Instruction
getCall op = Indent $ "call " ++ op

getRet :: Instruction
getRet = Indent "ret"

-- Arithmetic 

getAddl :: String -> String -> Instruction
getAddl src dest = Indent $ "addl " ++ getBinOpArgs src dest 

getSubl :: String -> String -> Instruction
getSubl src dest = Indent $ "subl " ++ getBinOpArgs src dest 

getImul :: String -> String -> Instruction
getImul src dest = Indent $ "imul " ++ getBinOpArgs src dest 

getLeal :: String -> String -> Instruction
getLeal src dest = Indent $ "leal " ++ getBinOpArgs src dest

getIdiv :: String -> Instruction
getIdiv src = Indent $ "idiv " ++ src

getIncl :: String -> Instruction
getIncl src = Indent $ "incl " ++ src

getDecl :: String -> Instruction
getDecl src = Indent $ "decl " ++ src

getNeg :: String -> Instruction
getNeg src = Indent $ "neg " ++ src