let file = "day01.in"

let string_of_inventory inventory =
  inventory
  |> List.map string_of_int
  |> String.concat " "

let print_inventories inventories =
  inventories
  |> List.map string_of_inventory
  |> String.concat " "
  |> print_string

let rec read_inventory ic =
  try
      let line = input_line ic in
      if line = "" then []
      else int_of_string line :: read_inventory ic
  with End_of_file -> []

let rec read_inventories ic =
  try
      let inventory = read_inventory ic in
      if inventory = [] then []
      else inventory :: read_inventories ic
  with e ->
    raise e

let read_input file =
  let ic = open_in file in
  try
      read_inventories ic
  with e ->
    close_in_noerr ic;
    raise e

let part_1 inventories =
  inventories
  |> List.map (fun a -> List.fold_left ( + ) 0 a)
  |> List.fold_left max 0

let part_2 inventories =
  inventories
  |> List.map (fun a -> List.fold_left ( + ) 0 a)
  |> List.sort (fun a b -> b - a)
  |> (fun lst -> match lst with a :: b :: c :: _ -> a + b + c | _ -> 0)

let () =
  let inventories = read_input file in
  Printf.printf "%d\n" (part_1 inventories);
  Printf.printf "%d\n" (part_2 inventories)
