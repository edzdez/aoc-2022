let file = "day02.in"

type move = Rock | Paper | Scissors
type result = Lose | Draw | Win

let move_to_score mv =
    match mv with
    | Rock -> 1
    | Paper -> 2
    | Scissors -> 3

let list_char_of_string s =
  s |> String.to_seq |> List.of_seq

let move_of_elf_char c =
  match c with
  | 'A' -> Rock
  | 'B' -> Paper
  | 'C' -> Scissors
  | _ -> failwith "invalid elf strategy"

let move_of_player_char c =
  match c with
  | 'X' -> Rock
  | 'Y' -> Paper
  | 'Z' -> Scissors
  | _ -> failwith "invalid player strategy"

let result_of_char c =
  match c with
  | 'X' -> Lose
  | 'Y' -> Draw
  | 'Z' -> Win
  | _ -> failwith "invalid player strategy"

let parse_strategy strat =
  match list_char_of_string strat with
  | a :: _ :: b :: [] -> (move_of_elf_char a, b)
  | _ -> failwith "invalid input"

let rec read_strats ic =
  try
    let line = input_line ic in
    parse_strategy line :: read_strats ic
  with
  | End_of_file -> []
  | e -> raise e


let read_input file =
  let ic = open_in file in
  try
    read_strats ic
  with e ->
    close_in_noerr ic;
    raise e

let battle player_move elf_move =
  match (player_move, elf_move) with
  | (Rock, Paper) -> 0
  | (Rock, Scissors) -> 6
  | (Paper, Scissors) -> 0
  | (Paper, Rock) -> 6
  | (Scissors, Rock) -> 0
  | (Scissors, Paper) -> 6
  | _ -> 3

let to_score strategy =
  let (elf_move, player_move) = strategy in
  move_to_score player_move + battle player_move elf_move

let part_1 strategies =
  strategies
  |> List.map (fun strat -> (fst strat, move_of_player_char (snd strat)))
  |> List.map to_score
  |> List.fold_left ( + ) 0

let devise_move res elf_move =
  match res with
  | Lose -> (
    match elf_move with
    | Rock -> Scissors
    | Paper -> Rock
    | Scissors -> Paper
  )
  | Draw -> elf_move
  | Win -> (
    match elf_move with
    | Rock -> Paper
    | Paper -> Scissors
    | Scissors -> Rock
  )

let part_2 strategies =
  strategies
  |> List.map (fun strat ->
          let (elf_move, result_c) = strat in
          (elf_move, devise_move (result_of_char result_c) elf_move))
  |> List.map to_score
  |> List.fold_left ( + ) 0

let () =
  let strategies = read_input file in
  Printf.printf "%d\n" (part_1 strategies);
  Printf.printf "%d\n" (part_2 strategies)

