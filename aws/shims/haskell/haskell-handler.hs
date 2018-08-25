import Data.List
import Data.Maybe

import Text.Read

import System.Environment

minus a@(x:xs) b@(y:ys) = case compare x y of
         LT -> x : minus  xs b
         EQ ->     minus  xs ys
         GT ->     minus  a  ys
minus a        b        = a

primesTo m =
  eratos [2..m] where
    eratos (p : xs)
      | p*p > m   = p : xs
      | otherwise = p : eratos (xs `minus` [p*p, p*p+p..m])

primes 0 = []
primes 1 = []
primes m = primesTo m

skipFirstAndLast [] = []
skipFirstAndLast [x] = []
skipFirstAndLast xs = tail (init xs)

main = do
  args <- getArgs
  putStrLn $ parse args

parse ["echo", body]       = skipFirstAndLast body
parse ["sieve", strNumber] = unwords $ map show $ primes $ fromMaybe 0 $ readMaybe strNumber
parse _                    = "Unknown command or arguments - supporting 'echo' or 'sieve' with one argument."