#!/usr/bin/env runhaskell

solve :: Int -> Int
solve limit = sum . takeWhile (<= limit) . filter (even) $ fibs
  where fibs = 0 : scanl (+) 1 fibs

main :: IO ()
main = print $ solve 4000000
