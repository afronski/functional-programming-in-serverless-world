module Lambda where

import Prelude ((*), (>), (+), mod, (==), otherwise)
import Data.Array (filter, range)

isPrime :: Int -> Boolean
isPrime n = go 2
  where
    go d
      | d * d > n        = true
      | n `mod` d == 0 = false
      | otherwise      = go (d + 1)

primes :: Int -> Array Int
primes m =
  filter isPrime (range 2 m)

sieve :: Int -> Array Int
sieve 0 = []
sieve 1 = []
sieve m = primes m

echo :: String -> String
echo body = body