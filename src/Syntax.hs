module Syntax where

data RDFValue 
    = URI String 
    | LiteralInt Integer 
    | LiteralString String
    | PrefixedName String String  -- Temporarily holds "ont" and "worksFor"
    deriving (Show, Eq, Ord)

data Triple = Triple RDFValue RDFValue RDFValue
    deriving (Show, Eq, Ord)

-- A statement is either a Prefix Dictionary entry, or a list of Triples
data Statement 
    = PrefixDecl String String 
    | Triples [Triple]
    deriving (Show, Eq)