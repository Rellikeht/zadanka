(* {{{*)
(* let token_kind_length = function *)
(*   | String v -> 2 + String.length v *)
(*   | other -> *)
(*     let value = match other with *)
(*       | Break -> "break" *)
(*       | Do -> "do" *)
(*       | Else -> "else" *)
(*       | Elseif -> "elseif" *)
(*       | End -> "end" *)
(*       | False -> "false" *)
(*       | For -> "for" *)
(*       | Function -> "function" *)
(*       | If -> "if" *)
(*       | In -> "in" *)
(*       | Local -> "local" *)
(*       | Nil -> "nil" *)
(*       | Repeat -> "repeat" *)
(*       | Return -> "return" *)
(*       | Then -> "then" *)
(*       | True -> "true" *)
(*       | Until -> "until" *)
(*       | While -> "while" *)
(*       | Special v -> string_of_special v *)
(*       | Operator v -> string_of_operator v *)
(*       | Int v -> string_of_int v *)
(*       | Identifier v -> v *)
(*     in String.length value *)
(* ;; *)
(* }}}*)

(*============================================================*)

(* {{{*)
(* let (<=>) (v1: ('b, 'd) result) (v2: 'a option) : ('c, 'd) result = *)
(*   match v2 with *)
(*   | Some v -> Ok v *)
(*   | None -> v1 *)
(* ;; *)

(* let result_of_option ev = function *)
(*   | Some v -> Ok v *)
(*   | None -> Error ev *)
(* ;; *)
(* }}}*)

(*============================================================*)

(* {{{*)
(* let rec get_int (input: string) (start: int) (i: int): int * int = *)
(*   let len = String.length input in *)
(*   if i < len && is_digit input.[i] *)
(*   then get_int input start (i+1) *)
(*   else begin *)
(*     let sub = String.sub input start (i-start) in *)
(*     (int_of_string sub, i) *)
(*     end *)
(* ;; *)

(* let get_identifier (input: string) (start: int): (string * int, string) result = *)
(*   let len = String.length input in *)
(*   if is_start input.[start] |> not *)
(*   then Error "TODO No identifier here" *)
(*   else *)
(*     let rec gid i = *)
(*       if i == len || is_identifier input.[i] |> not *)
(*       then let sub = (String.sub input start (i-start), i) in sub *)
(*       else gid (i+1) *)
(*     in Ok (gid (start+1)) *)
(* ;; *)

(* let get_string (input: string): (token_kind, string) result = *)
(*   if is_quote input.[0] *)
(*   then *)
(*     let len = String.length input in *)
(*     let rec pstr i = *)
(*       if i >= len then Error "Unfclosed string" *)
(*       else match input.[i] with *)
(*         | '\\' -> pstr (i+2) *)
(*         | '\'' | '"' -> *)
(*           let sub = String.sub input 1 (i-1) in *)
(*           Ok (String sub) *)
(*         | _ -> pstr (i+1) *)
(*     in pstr 1 *)
(*   else Error "" *)
(* ;; *)

(* let scan_line (lnum: int) (input: string): (token list, string) result = *)
(*   let len = String.length input in *)

(*   let get_token_kind (i: int): (token_kind * int, string) result = *)
(*     if is_digit input.[i] *)
(*     then let v, j = get_int input i (i+1) in Ok (Int v, j) *)
(*     else *)
(*       let sub = String.sub input i (len-i) in *)
(*       let tkind = *) 
(*         get_string sub <=> *)
(*         parse_token_kind sub <=> *)
(*         parse_operator sub <=> *)
(*         parse_special sub *)
(*       in *)
(*       let tkind = match tkind with *)
(*         | Ok v -> Ok (v, i + (token_kind_value v |> String.length)) *)
(*         | Error e -> Error e *)
(*       in *)
(*       if is_ok tkind then tkind *)
(*       else *)
(*         let id = get_identifier input i in *)
(*         id >>= (fun (s, i) -> Ok (Identifier s, i)) *)
(*   (1* let id = wrap_length id in *1) *)
(*   (1* id *1) *)
(*   in *)

(*   let gen_token = function *)
(*   | Ok (kind, i) -> Ok ({ *)
(*       char=i; *)
(*       line=lnum; *)
(*       content=token_kind_value kind; *)
(*       kind=kind; *)
(*     }, i) *)
(*   | Error e -> Error e *)
(*   in *)

(*   let rec get_tokens (i: int): (token list, string) result = *)
(*     if i == len then Ok [] *)
(*     else if input.[i] == ' ' then get_tokens (i+1) *)
(*     else *)
(*       gen_token (get_token_kind i) >>= *)
(*       fun (tok, npos) -> (get_tokens npos) >>= *)
(*       fun l -> Ok (tok::l) *)
(*   in *) 
(*   get_tokens 0 *)
(* ;; *)
(* }}}*)

(*============================================================*)

let parse_operator (str: string): token_kind option =(* {{{*)
  let len = String.length str in
  let result = match str.[0] with
    | '+' -> Some Plus
    | '-' -> Some Minus
    | '*' -> Some Star
    | '/' -> Some Slash
    | '^' -> Some Caret
    | '%' -> Some Percent
    | '#' -> Some Hash

    | '<' -> begin
      if len == 1 then Some Less
      else match str.[1] with
        | '=' -> Some Leq
        | _ -> Some Less
      end
    | '>' -> begin
      if len == 1 then Some Greater
      else match str.[1] with
        | '=' -> Some Geq
        | _ -> Some Greater
      end

    | '.' -> begin
      if len == 1 then None
      else match str.[1] with
        | '.' -> Some Dots
        | _ -> None
      end
    | '=' -> begin
      if len == 1 then None
      else match str.[1] with
        | '=' -> Some Equal
        | _ -> None
      end
    | '~' -> begin
      if len == 1 then None
      else match str.[1] with
        | '=' -> Some Neq
        | _ -> None
      end

    | _ -> begin
      if String.starts_with ~prefix:"and" str then Some And
      else if String.starts_with ~prefix:"or" str then Some Or
      else if String.starts_with ~prefix:"not" str then Some Not
      else None
      end
  in result >>= (fun x -> Some (Operator x))
;; (* }}}*)

let parse_special = function(* {{{*)
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
;;
let parse_special str = str.[0] |> parse_special;;
let parse_special str: token_kind option =
  String.sub str 0 1 |>
  parse_special >>=
  (fun x -> Some (Special x))
;; (* }}}*)

let parse_token_kind str =(* {{{*)
  if String.starts_with ~prefix:"break" str then Some Break
  else if String.starts_with ~prefix:"do" str then Some Do
  else if String.starts_with ~prefix:"else" str then Some Else
  else if String.starts_with ~prefix:"elseif" str then Some Elseif
  else if String.starts_with ~prefix:"end" str then Some End
  else if String.starts_with ~prefix:"false" str then Some False
  else if String.starts_with ~prefix:"for" str then Some For
  else if String.starts_with ~prefix:"function" str then Some Function
  else if String.starts_with ~prefix:"if" str then Some If
  else if String.starts_with ~prefix:"in" str then Some In
  else if String.starts_with ~prefix:"local" str then Some Local
  else if String.starts_with ~prefix:"nil" str then Some Nil
  else if String.starts_with ~prefix:"repeat" str then Some Repeat
  else if String.starts_with ~prefix:"return" str then Some Return
  else if String.starts_with ~prefix:"then" str then Some Then
  else if String.starts_with ~prefix:"true" str then Some True
  else if String.starts_with ~prefix:"until" str then Some Until
  else if String.starts_with ~prefix:"while" str then Some While
  else None
;;(* }}}*)

(*============================================================*)
(*============================================================*)
(*============================================================*)

let scan_line (lnum: int) (input: string): (token list, string) result =
  let len = String.length input in

  let get_token_kind (start: int): (temp_value * int, string) result =
    (* {{{*)
    let tkind = 
      parse_int input start <=>
      parse_string input start <=>
      parse_token_kind input start <=>
      parse_operator input start <=>
      parse_special input start <=>
      parse_identifier input start
    in
    match tkind with
    | Good (kind, len, value) -> Ok ((kind, len, value), start)
    | Bad e -> Error e
    | Continue -> Error (
      String.cat
      "Unfinished something at line "
      (string_of_int lnum)
    )
  in (* }}}*)

  let gen_token
  (value: (temp_value * int, string) result):
  (token * int, string) result =
(* {{{*)
  match value with
  | Ok ((kind, len, value), start) -> Ok ({
      char=start;
      line=lnum;
      content=value;
      kind=kind;
    }, start+len)
  | Error e -> Error e
  in (* }}}*)

  let rec get_tokens (i: int): (token list, string) result =
    (* {{{*)
    if i == len then Ok []
    else if input.[i] == ' ' then get_tokens (i+1)
    else
      gen_token (get_token_kind i) >>=
      fun (tok, npos) -> (get_tokens npos) >>=
      fun l -> Ok (tok::l)
  in (* }}}*)

  get_tokens 0
;;
