module P001 where

solve :: Int -> Int
solve input = sum [ x | x <- [1..(input-1)], x `mod` 3 == 0 || x `mod` 5 == 0 ]
