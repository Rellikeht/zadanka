let (>>=) = Option.bind;;
let starts_with pref str = String.starts_with ~prefix:pref str;;

type ('a, 'b) temp_type =
  Good of 'a     |
  Bad of 'b      |
  Continue

(* type intorfloat = Int of int | Float of float *)

type operator = (* {{{*)
  Plus    |
  Minus   |
  Star    |
  Slash   |
  Caret   |
  Percent |
  Dots    |
  Less    |
  Leq     |
  Greater |
  Geq     |
  Equal   |
  Neq     |
  And     |
  Or      |
  Not     |
  Hash

let string_of_operator = function
  | Plus -> "+"
  | Minus -> "-"
  | Star -> "*"
  | Slash -> "/"
  | Caret -> "^"
  | Percent -> "%"
  | Dots -> ".."
  | Less -> "<"
  | Leq -> "<="
  | Greater -> ">"
  | Geq -> ">="
  | Equal -> "=="
  | Neq -> "~="
  | And -> "and"
  | Or -> "or"
  | Not -> "not"
  | Hash -> "#"
;;
(* }}}*)

type special =(* {{{*)
  Assign         |
  Dot            |
  Comma          |
  LSquare        |
  RSquare        |
  LCurly         |
  RCurly         |
  LParen         |
  RParen

let string_of_special = function
  | Assign -> "="
  | Dot -> "."
  | Comma -> ","
  | LSquare -> "["
  | RSquare -> "]"
  | LCurly -> "{"
  | RCurly -> "}"
  | LParen -> "("
  | RParen -> ")"
;; (* }}}*)

type token_kind =(* {{{*)
  Break                |
  Do                   |
  Else                 |
  Elseif               |
  End                  |
  False                |
  For                  |
  Function             |
  If                   |
  In                   |
  Local                |
  Nil                  |
  Repeat               |
  Return               |
  Then                 |
  True                 |
  Until                |
  While                |
  Operator of operator |
  Special of special   |
  Int of int           |
  (* Float of float       | *)
  String of string     |
  Comment of string     |
  Identifier of string

let string_of_token_kind = function
  | Break -> "Keyword break"
  | Do -> "Keyword do"
  | Else -> "Keyword else"
  | Elseif -> "Keyword elseif"
  | End -> "Keyword end"
  | False -> "Keyword false"
  | For -> "Keyword for"
  | Function -> "Keyword function"
  | If -> "Keyword if"
  | In -> "Keyword in"
  | Local -> "Keyword local"
  | Nil -> "Keyword nil"
  | Repeat -> "Keyword repeat"
  | Return -> "Keyword return"
  | Then -> "Keyword then"
  | True -> "Keyword true"
  | Until -> "Keyword until"
  | While -> "Keyword while"
  | Operator o ->
    string_of_operator o |> String.cat "Operator "
  | Special s ->
    string_of_special s |> String.cat "Special "
  | Int i ->
    string_of_int i |> String.cat "Int "
  (* | Float f -> *)
  (*   string_of_float f |> String.cat "Float " *)
  | String s -> String.cat "String \"" @@ String.cat s "\""
  | Comment s -> String.cat "Comment \"" @@ String.cat s "\""
  | Identifier i -> String.cat "Identifier " @@ String.cat i ""
;; (* }}}*)

type temp_value = token_kind * int * string
type temp_result = (temp_value, string) temp_type

let token_kind_value = function
  (* {{{*)
  | String v -> String.cat "\"" @@ String.cat v "\""
  | Comment v -> String.cat "-- " v
  | Break -> "break"
  | Do -> "do"
  | Else -> "else"
  | Elseif -> "elseif"
  | End -> "end"
  | False -> "false"
  | For -> "for"
  | Function -> "function"
  | If -> "if"
  | In -> "in"
  | Local -> "local"
  | Nil -> "nil"
  | Repeat -> "repeat"
  | Return -> "return"
  | Then -> "then"
  | True -> "true"
  | Until -> "until"
  | While -> "while"
  | Special v -> string_of_special v
  | Operator v -> string_of_operator v
  | Int v -> string_of_int v
  | Identifier v -> v
;;(* }}}*)

let parse_operator (str: string) (start: int): temp_result =
  (* {{{*)
  let len = String.length str - start in
  let result = match str.[start] with
    | '+' -> Some Plus
    | '-' -> Some Minus
    | '*' -> Some Star
    | '/' -> Some Slash
    | '^' -> Some Caret
    | '%' -> Some Percent
    | '#' -> Some Hash

    | '<' -> begin
      if len == 1 then Some Less
      else match str.[start+1] with
        | '=' -> Some Leq
        | _ -> Some Less
      end
    | '>' -> begin
      if len == 1 then Some Greater
      else match str.[start+1] with
        | '=' -> Some Geq
        | _ -> Some Greater
      end

    | '.' -> begin
      if len == 1 then None
      else match str.[start+1] with
        | '.' -> Some Dots
        | _ -> None
      end
    | '=' -> begin
      if len == 1 then None
      else match str.[start+1] with
        | '=' -> Some Equal
        | _ -> None
      end
    | '~' -> begin
      if len == 1 then None
      else match str.[start+1] with
        | '=' -> Some Neq
        | _ -> None
      end

    | _ -> begin
      if starts_with "and" str then Some And
      else if starts_with "or" str then Some Or
      else if starts_with "not" str then Some Not
      else None
      end

  in match result with
  | Some v ->
    let string_value = string_of_operator v in
    Good (Operator v, String.length string_value, string_value)
  | None -> Continue
;; (* }}}*)

let parse_special (str: string) (start: int): temp_result =
  (* {{{*)
  let value = match str.[start] with
  | '=' -> Some Assign
  | '.' -> Some Dot
  | ',' -> Some Comma
  | '[' -> Some LSquare
  | ']' -> Some RSquare
  | '{' -> Some LCurly
  | '}' -> Some RCurly
  | '(' -> Some LParen
  | ')' -> Some RParen
  | _ -> None
  in match value with
  | Some v -> Good (Special v, 1, string_of_special v)
  | None -> Continue
;; (* }}}*)

let parse_token_kind (str: string) (start: int): temp_result =
  (* {{{*)
  let sub = String.sub str start @@ String.length str - start in
  let value = 
    if starts_with "break" sub then Some Break
    else if starts_with "do" sub then Some Do
    else if starts_with "else" sub then Some Else
    else if starts_with "elseif" sub then Some Elseif
    else if starts_with "end" sub then Some End
    else if starts_with "false" sub then Some False
    else if starts_with "for" sub then Some For
    else if starts_with "function" sub then Some Function
    else if starts_with "if" sub then Some If
    else if starts_with "in" sub then Some In
    else if starts_with "local" sub then Some Local
    else if starts_with "nil" sub then Some Nil
    else if starts_with "repeat" sub then Some Repeat
    else if starts_with "return" sub then Some Return
    else if starts_with "then" sub then Some Then
    else if starts_with "true" sub then Some True
    else if starts_with "until" sub then Some Until
    else if starts_with "while" sub then Some While
    else None
  in match value with
  | Some v ->
    let string_value = token_kind_value v in
    Good (v, String.length string_value, string_value)
  | None -> Continue
;;(* }}}*)

type token = {(* {{{*)
  line: int;
  char: int;
  content: string;
  kind: token_kind;
}

let string_of_token {line;char;content;kind;} =
  String.concat "" [
    string_of_token_kind kind;
    " at: (";
    string_of_int line;
    ", ";
    char |> string_of_int;
    ") value: \"";
    content;
    "\"";
  ]
;;(* }}}*)
