-- Membership predicate for vectors, and means to compute one.

data ElemIs : (Fin n) -> A -> (Vect A n) -> # where
   first : {x:A} -> {xs:Vect A n} -> 
       (ElemIs fO x (VCons x xs))
 | later : {x:A} -> {ys:Vect A n} -> 
           {y:A} -> {i:Fin n} ->
       (ElemIs i x ys) -> (ElemIs (fS i) x (VCons y ys));

elemIs : (i:Fin n) -> (xs:Vect A n) -> (ElemIs i (vlookup i xs) xs);
elemIs fO (VCons x xs) = first;
elemIs (fS k) (VCons x xs) = later (elemIs k xs);

isElemAuxO : {x:A} -> {xs: Vect A n} -> 
         (y:A) ->
         (eq: (Maybe (x=y))) ->
         (Maybe (ElemIs fO x (VCons y xs)));
isElemAuxO {x=y} y (Just (refl _)) = Just first;
isElemAuxO y Nothing = Nothing;

isElem : (eq:(a:A)->(b:A)->(Maybe (a=b)))->
     (i:Fin n) -> (x:A) -> (xs:Vect A n) -> (Maybe (ElemIs i x xs));
isElem eq i x VNil = Nothing;
isElem eq fO x (VCons y xs) = isElemAuxO y (eq x y);
isElem eq (fS i) x (VCons y xs) = mMap later (isElem eq i x xs);

-- try it on nats...

eqNat : (x:Nat) -> (y:Nat) -> (Maybe (x=y));
eqNat O O = Just (refl O);
eqNat (S x) (S y) = mMap eq_resp_S (eqNat x y);
eqNat _ _ = Nothing;

