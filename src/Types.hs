module Types where

import Data.Set (Set)

-- URIs are just strings, but wrapping them in a 'newtype' prevents bugs 
-- (like accidentally passing a String literal where a URI is expected).
newtype URI = URI String
  deriving (Show, Eq, Ord)

-- Literals are strictly Strings or Integers.
data Literal
  = LInt Integer
  | LString String
  deriving (Show, Eq, Ord)

-- Objects can be URIs or Literals.
data Object
  = ObjURI URI
  | ObjLit Literal
  deriving (Show, Eq, Ord)

-- The Core Triple.
-- PRO TIP: Deriving 'Ord' here is a cheat code. Haskell will automatically 
-- sort lexicographically from left to right (Subject, then Predicate, then Object).
-- This gives you the exact output sorting required by the specification for free!
data Triple = Triple URI URI Object
  deriving (Show, Eq, Ord)

-- A Graph is a Set of Triples. Using a Set automatically handles Task 1's 
-- requirement to exclude duplicate triples.
type Graph = Set Triple