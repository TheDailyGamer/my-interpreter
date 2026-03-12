module Main where

import Lexer (alexScanTokens)
import Parser (parseRDF)
import Syntax
import qualified Data.Map as Map
import Data.List (sort, nub)
import System.Environment (getArgs)

-- This is Pass 2: The Resolver
resolvePrefixes :: [Statement] -> [Triple]
resolvePrefixes statements = 
    let 
        -- 1. Grab all prefix declarations and put them in a Map dictionary
        prefixMap = Map.fromList [ (prefix, fullUri) | PrefixDecl prefix fullUri <- statements ]
        
        -- 2. Grab all the raw triples that the parser expanded
        allTriples = concat [ triplesList | Triples triplesList <- statements ]

        -- 3. A helper function to swap out the prefix for the full URI
        swapValue (PrefixedName p n) = 
            case Map.lookup p prefixMap of
                Just fullUri -> URI (fullUri ++ n)
                Nothing      -> error ("Unknown prefix: " ++ p)
        swapValue other = other -- Leave Integers, Strings, and normal URIs alone

        -- 4. Apply the swap to every part of a Triple
        swapTriple (Triple s p o) = Triple (swapValue s) (swapValue p) (swapValue o)
        
    in map swapTriple allTriples

main :: IO ()
main = do
    -- 1. Get the filename from the command line
    args <- getArgs
    if null args
        then error "Please provide an input file!"
        else do
            let filename = head args
            
            -- 2. Read the actual file contents
            input <- readFile filename
            
            -- 3. Lex and Parse (Silently!)
            let tokens = alexScanTokens input
            let statements = parseRDF tokens
            
            -- 4. Resolve the @prefixes
            let finalTriples = resolvePrefixes statements

            -- 5. Sort and remove duplicates (nub removes duplicates, sort alphabetizes)
            let cleanTriples = sort (nub finalTriples)

            -- 6. Print strictly in Canonical N-Triples format
            mapM_ printCanonical cleanTriples

-- Helper function to format the output exactly as the spec demands
printCanonical :: Triple -> IO ()
printCanonical (Triple s p o) = putStrLn (formatValue s ++ " " ++ formatValue p ++ " " ++ formatValue o ++ " .")

formatValue :: RDFValue -> String
formatValue (URI u)           = "<" ++ u ++ ">"
formatValue (LiteralInt i)    = show i
formatValue (LiteralString s) = "\"" ++ s ++ "\""
formatValue (PrefixedName p n) = error "Wait, an unresolved prefix slipped through!"