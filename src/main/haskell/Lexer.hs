--------------------------------------------------------------------
-- |
-- Module    :  Lexer
-- Copyright :  (c) Stephen Diehl 2013
-- License   :  MIT
-- Maintainer:  stephen.m.diehl@gmail.com
-- Stability :  experimental
-- Portability: non-portable
--
--------------------------------------------------------------------

module Lexer where

import Text.Parsec.String (Parser)
import Text.Parsec.Language (emptyDef)
import Text.Parsec.Prim

import qualified Text.Parsec.Token as Tok

ops = ["+","*","-","/",";", "==", "=",",","<",">","|",":"]
keywords = ["data", "def", "extern", "if", "then", "else", "end", "in",
            "binary", "unary", "let", "true", "false"
            ]

lascaLangDef = emptyDef {
               Tok.commentStart   = "{-"
             , Tok.commentEnd     = "-}"
             , Tok.commentLine = "--"
             , Tok.nestedComments = True
             , Tok.reservedOpNames = ops
             , Tok.reservedNames = keywords
             }

lexer :: Tok.TokenParser ()
lexer = Tok.makeTokenParser lascaLangDef


integer    = Tok.integer lexer
stringLiteral     = Tok.stringLiteral lexer
float      = Tok.float lexer
parens     = Tok.parens lexer
braces     = Tok.braces lexer
brackets     = Tok.brackets lexer
commaSep   = Tok.commaSep lexer
comma      = Tok.comma lexer
semiSep    = Tok.semiSep lexer
semi       = Tok.semi lexer
identifier = Tok.identifier lexer
whitespace = Tok.whiteSpace lexer
reserved   = Tok.reserved lexer
reservedOp = Tok.reservedOp lexer

operator :: Parser String
operator = do
  c <- Tok.opStart emptyDef
  cs <- many $ Tok.opLetter emptyDef
  return (c:cs)
