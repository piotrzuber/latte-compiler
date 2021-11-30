module Main where

import Control.Monad.Except
import Control.Monad.Trans.Except
import System.Environment
import System.Exit
import System.IO

import AbsLatte
import ErrM
import ParLatte

import StaticChecker ( runEvaluation )
import SCTypes

main :: IO ()
main = do
    args <- getArgs
    case args of 
        [] -> getContents >>= run
        fs -> mapM_ runFile fs

runFile :: String -> IO ()
runFile fName = readFile fName >>= run

run :: String -> IO ()
run code = 
    case pProgram (myLexer code) of
        (Bad e) -> exitWithErrorMsg $ "Parse error. " ++ e
        (Ok t) -> do
            tcResult <- runEvaluation t
            return ()

exitWithErrorMsg :: String -> IO ()
exitWithErrorMsg msg = do
    hPutStrLn stderr msg
    exitFailure