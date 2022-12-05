import Debug.Trace

file = "day04.in"

type Interval = (Int, Int)

splitInternal :: [String] -> String -> Char -> String -> [String]
splitInternal acc word _ [] = if word == "" then reverse acc else reverse (reverse word : acc)
splitInternal acc word delim (x : xs) = if x == delim
    then splitInternal (reverse word : acc) "" delim xs
    else splitInternal acc (x : word) delim xs

split :: Char -> String -> [String]
split = splitInternal [] ""

splitLines :: String -> [String]
splitLines = split '\n'

toInterval :: String -> Interval
toInterval str = if a < b then (a, b) else (b, a)
    where splitStr = split '-' str
          a = read $ head splitStr
          b = read $ head $ tail splitStr

toIntervals :: String -> [Interval]
toIntervals line =
    map toInterval $ split ',' line

readInput :: String -> IO [[Interval]]
readInput file = do
    contents <- readFile file
    return $ map toIntervals $ splitLines contents

isEnclosed :: [Interval] -> Bool
isEnclosed (x : y : []) =
    (fst x <= fst y && snd x >= snd y) || (fst y <= fst x && snd y >= snd x)

isOverlapping :: [Interval] -> Bool
isOverlapping (x : y : []) =
    (fst x <= fst y && snd x >= fst y) || (fst y <= fst x && snd y >= fst x) ||
    (fst x <= snd y && snd x >= snd y) || (fst y <= snd x && snd y >= snd x)

part1 :: [[Interval]] -> Int
part1 = length . filter isEnclosed

part2 :: [[Interval]] -> Int
part2 = length . filter isOverlapping

main :: IO ()
main = do
    input <- readInput file
    print $ part1 input
    print $ part2 input
