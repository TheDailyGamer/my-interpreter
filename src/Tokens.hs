module Tokens where

data Token
  = TokenURI String
  | TokenPrefixKeyword
  | TokenBaseKeyword
  | TokenID String
  | TokenPrefixedName (String, String)  -- <-- The parentheses are the magic fix!
  | TokenColon
  | TokenDot
  | TokenSemicolon
  | TokenComma
  | TokenLiteralInt Integer
  | TokenLiteralString String
  deriving (Show, Eq)