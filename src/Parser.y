{
module Parser where
import Tokens
import Syntax
}

%name parseRDF
%tokentype { Token }
%error { parseError }

%token
    uri     { TokenURI $$ }
    int     { TokenLiteralInt $$ }
    str     { TokenLiteralString $$ }
    prefix  { TokenPrefixKeyword }
    id      { TokenID $$ }
    pname   { TokenPrefixedName $$ }
    '.'     { TokenDot }
    ';'     { TokenSemicolon }
    ','     { TokenComma }
    ':'     { TokenColon }

%%

Program : Statements { $1 }

Statements : Statement Statements { $1 : $2 }
           |                      { [] }

-- A statement is either a Prefix, or a block of Subject-Predicate-Objects
Statement : prefix id ':' uri '.' { PrefixDecl $2 $4 }
          | Subject PredicateObjectList '.' { Triples (expand $1 $2) }

-- Your beautiful Shorthand Logic!
PredicateObjectList : Verb ObjectList ';' PredicateObjectList { ($1, $2) : $4 }
                    | Verb ObjectList                        { [($1, $2)] }

ObjectList : Object ',' ObjectList { $1 : $3 }
           | Object                { [$1] }

Subject : uri                  { URI $1 }
        | pname                { let (p, n) = $1 in PrefixedName p n }

Verb    : uri                  { URI $1 }
        | pname                { let (p, n) = $1 in PrefixedName p n }

Object  : uri                  { URI $1 }
        | pname                { let (p, n) = $1 in PrefixedName p n }
        | int                  { LiteralInt $1 }
        | str                  { LiteralString $1 }

{
parseError :: [Token] -> a
parseError _ = error "Parse error: Check your Turtle syntax!"

expand :: RDFValue -> [(RDFValue, [RDFValue])] -> [Triple]
expand sub pairs = [ Triple sub p obj | (p, objs) <- pairs, obj <- objs ]
}