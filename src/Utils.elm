module Utils exposing (..)

replace : List a -> Int -> a -> List a
replace lst k item = case lst of
  hd :: tl ->
    if k == 0 then item :: tl
    else hd :: replace tl (k - 1) item
  [] ->
    lst
