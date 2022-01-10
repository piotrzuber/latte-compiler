module Main where

import Control.Monad.Except
import Control.Monad.Trans.Except
import System.Environment
import System.Exit
import System.IO
import System.Process
import System.FilePath

import AbsLatte
import ErrM
import ParLatte

import StaticChecker ( runEvaluation )
import CompilerX86 ( compile )
import SCTypes

main :: IO ()
main = do
    args <- getArgs
    case args of 
        [] -> exitWithErrorMsg "Provide input path."
        fs -> mapM_ runFile fs

runFile :: FilePath -> IO ()
runFile inputPath = readFile inputPath >>= run inputPath

run :: FilePath -> String -> IO ()
run inputPath code = 
    case pProgram (myLexer code) of
        (Bad e) -> exitWithErrorMsg $ "Parse error. " ++ e
        (Ok t) -> do
            tcResult <- runEvaluation t
            let compilationResult = compile t
            let codeOut = replaceExtension inputPath "s"
            let binOut = dropExtension inputPath
            putStrLn $ "Saving x86 AT&T output in " ++ codeOut
            writeFile codeOut compilationResult
            putStrLn $ "Compiling x86 AT&T code"
            putStrLn $ gppCmd codeOut binOut
            child <- runCommand $ gppCmd codeOut binOut
            waitForProcess child
            exitSuccess

gppCmd :: FilePath -> FilePath -> String 
gppCmd x86Path outPath= "gcc -m32 lib/runtime.o " ++ x86Path ++ " -o " ++ outPath

exitWithErrorMsg :: String -> IO ()
exitWithErrorMsg msg = do
    hPutStrLn stderr msg
    exitFailure