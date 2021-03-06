{-# LANGUAGE Strict #-}
module Type where

import Data.List

newtype TVar = TV String
  deriving (Eq, Ord)

instance Show TVar where
  show (TV s) = s

data Type
  = TVar !TVar
  | TypeIdent !String
  | TypeFunc Type Type
  | TypeApply Type [Type]
  deriving (Eq, Ord)

instance Show Type where
  show (TVar (TV n)) = n
  show (TypeIdent s) = s
  show (TypeFunc l r) = "(" ++ show l ++ " -> " ++ show r ++ ")"
  show (TypeApply t args) = "(" ++ show t ++ foldl (\acc a -> " " ++ acc ++ show a) "" args ++ ")"


infixr `TypeFunc`

data Scheme = Forall [TVar] Type
  deriving (Eq, Ord)

instance Show Scheme where
  show (Forall [] t) = show t
  show (Forall vars t) = "∀(" ++ intercalate "," typeVarNames ++ ") => " ++ show t
    where
      typeVarNames :: [String]
      typeVarNames = (map show vars)

typeInt :: Type
typeInt  = TypeIdent "Int"
typeFloat = TypeIdent "Float"
typeBool :: Type
typeBool = TypeIdent "Bool"

typeAny = TypeIdent "Any"
typeString = TypeIdent "String"
typeUnit = TypeIdent "Unit"
typeArray t = TypeApply (TypeIdent "Array") [t]
typeArrayInt = typeArray typeInt

isAny (TypeIdent "Any") = True
isAny _ = False