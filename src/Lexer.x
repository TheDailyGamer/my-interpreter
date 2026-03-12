{
module Lexer where
import Tokens
}

%wrapper "basic"

tokens :-

  $white+                       ;
  "@prefix"                     { \s -> TokenPrefixKeyword }
  "@base"                       { \s -> TokenBaseKeyword }
  "."                           { \s -> TokenDot }
  ";"                           { \s -> TokenSemicolon }
  ","                           { \s -> TokenComma }
  ":"                           { \s -> TokenColon }
  
  -- Match URIs safely
  "<" [^>]* ">"                 { \s -> TokenURI (drop 1 (take (length s - 1) s)) }
  
  -- Match Prefixed Names (e.g., ont:name)
  [a-zA-Z] [a-zA-Z0-9_\-]* ":" [a-zA-Z] [a-zA-Z0-9_\-]* { \s -> 
      let (prefixPart, colonAndName) = break (==':') s 
      in TokenPrefixedName (prefixPart, drop 1 colonAndName) }

  -- Match Standalone IDs (e.g., ont)
  [a-zA-Z] [a-zA-Z0-9_\-]* { \s -> TokenID s }
  
  -- Match Integers
  [0-9]+                        { \s -> TokenLiteralInt (read s) }
  
  -- Match Strings in quotes
  \" [^\"]* \"                  { \s -> TokenLiteralString (drop 1 (take (length s - 1) s)) }