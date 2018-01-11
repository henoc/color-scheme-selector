module Utils exposing (..)

replace : List a -> Int -> a -> List a
replace lst k item = case lst of
  hd :: tl ->
    if k == 0 then item :: tl
    else hd :: replace tl (k - 1) item
  [] ->
    lst

insert : List a -> Int -> a -> List a
insert lst k item =
  if k == 0 then  item :: lst
  else case lst of
    hd :: tl -> hd :: insert tl (k - 1) item
    [] -> lst

remove : List a -> Int -> List a
remove lst k = case lst of
  hd :: tl ->
    if k == 0 then tl
    else hd :: remove tl (k - 1)
  [] -> lst

getAt : List a -> Int -> Maybe a
getAt lst k = case lst of
  hd :: tl ->
    if k == 0 then Just hd
    else getAt tl (k - 1)
  [] -> Nothing

index : List a -> List Int
index lst = List.range 0 (List.length lst - 1)
