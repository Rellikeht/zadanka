open Types;;
(* reexport *)
(* type token = Types.token *)
(* let string_of_token = string_of_token;; *)

(* helpers {{{*)

let is_some = Option.is_some;;
let is_none = Option.is_none;;
let is_ok = Result.is_ok;;
let is_error = Result.is_error;;
let flip f a b = f b a;;

let bind = Result.bind;;
let (>>=) = bind;;

let (<=>) (v1: temp_result) (v2: temp_result): temp_result =
  match v1 with
  | Good v -> Good v
  | Bad e -> Bad e
  | Continue -> v2
;;

(* }}}*)

(* checkers {{{*)

let is_digit = function '0' .. '9' -> true | _ -> false;;
let is_start = function
  | 'a' .. 'z' | 'A' .. 'Z' | '_' -> true
  | _ -> false
;;
let is_identifier c = is_start c || is_digit c ;;
let is_quote = function '\'' | '"' -> true | _ -> false;;

(* }}}*)

let parse_int (input: string) (start: int): temp_result =
(* {{{*)
  if is_digit input.[start] |> not then Continue
  else
    let len = String.length input in
    let rec parse i = 
      if i < len && is_digit input.[i]
      then parse (i+1)
      else 
        let sub = String.sub input start (i-start) in
        (int_of_string sub, i, sub)
    in
    let v, i, sub = parse (start+1) in
    Good (Int v, i-start, sub)
;;(* }}}*)

let parse_identifier (input: string) (start: int): temp_result =
(* {{{*)
  let len = String.length input in
  if is_start input.[start] |> not
  then Bad "TODO No identifier here"
  else
    let rec gid i =
      if i == len || (is_identifier input.[i] |> not)
      then (String.sub input start (i-start), i)
      else gid (i+1)
    in
    let (name, i) = (gid (start+1)) in
    Good (
      Identifier name,
      i - start,
      name
    )
;;(* }}}*)

let parse_string (input: string) (start: int): temp_result =
(* {{{*)
  if is_quote input.[start]
  then
    let len = String.length input in
    let rec pstr i =
      if i >= len then Bad "Unclosed string"
      else match input.[i] with
        | '\\' -> pstr (i+2)
        | '\'' | '"' ->
          let sub = String.sub input (start+1) (i-start-1) in
          Good (sub, i+1)
        | _ -> pstr (i+1)
    in
    let result = pstr (start+1) in
    match result with
    | Good (value, i) -> Good (String value, i-start, value)
    | Bad e -> Bad e
    | Continue -> Continue
  else Continue
;;(* }}}*)

let parse_comment (input: string) (start: int): temp_result =
(* {{{*)
  let len = String.length input in
  if start > (len-2) then Continue
  else if input.[start] == '-' && input.[start+1] == '-'
  then
    let sub = String.sub input (start+2) (len-start-2) in
    Good (Comment sub, len-start, sub)
  else Continue
;;(* }}}*)

let scan_line
(lnum: int)
(input: string):
(token list, string) result =
  let len = String.length input in

  let get_token (start: int): (token * int, string) temp_type =
    (* {{{*)
    let tkind = 
      parse_int input start <=>
      parse_string input start <=>
      parse_token_kind input start <=>
      parse_comment input start <=>
      parse_operator input start <=>
      parse_special input start <=>
      parse_identifier input start
    in
    match tkind with
    | Good (kind, len, value) -> Good ({
      char=start;
      line=lnum;
      content=value;
      kind=kind;
    }, start+len)
    | Bad e -> Bad e
    | Continue -> Bad "Something gone wrong"
  in (* }}}*)

  let rec get_tokens (i: int): (token list, string) result =
    (* {{{*)
    if i == len then Ok []

    (* whitespace *)
    else if input.[i] == ' ' || input.[i] == '\t'
    then get_tokens (i+1)

    (* (1* comments *1) *)
    (* else if i < len-1 && *)
    (*   input.[i] == '-' && *)
    (*   input.[i+1] == '-' then Ok [] *)

    else
      match get_token i with
      | Bad e -> Error e
      | Continue -> Ok []
      | Good (token, new_pos) -> match get_tokens new_pos with
        | Ok list -> Ok (token::list)
        | Error e -> Error e
  in (* }}}*)

  get_tokens 0
;;

let scan_lines () : (token list, string) result =
(* {{{*)
  let rec pl (i:int) (tokens: token list): (token list, string) result =
    try
      (read_line () |> scan_line i) >>=
      (fun l -> Ok (List.append tokens l)) >>=
      pl (i+1)
    with End_of_file -> Ok tokens
  in pl 0 []
;;(* }}}*)
