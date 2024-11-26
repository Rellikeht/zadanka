#!/usr/bin/env ocaml

type value_type = Int of int | Str of string

let flip f a b = f b a;;
let bind = Result.bind;;
let (>>=) = bind;;

let string_of_value_type value : string =
    match value with
    | Int i -> string_of_int i
    | Str s -> s
;;

type token_type =
    Plus |
    Minus |
    Mult |
    Div |
    LParen |
    RParen |
    Identifier |
    Number 

let string_of_token_type token : string =
    match token with
    | Plus -> "Plus"
    | Minus -> "Minus"
    | Mult -> "Mult"
    | Div -> "Div"
    | LParen -> "LParen"
    | RParen -> "RParen"
    | Identifier -> "Identifier"
    | Number -> "Number" 
;;

type token = {
    ttype: token_type;
    value: value_type;
    content: string
}

let string_of_token {ttype=t;value=v;content=c} : string =
    String.concat "" [
        string_of_token_type t;
        " ( ";
        string_of_value_type v;
        ", \"";
        c;
        "\" )"
    ]
;;

let simple_token c : (token, string) result =
    match c with
    | '+' -> Ok {ttype=Plus;value=Str "+";content="+"}
    | '-' -> Ok {ttype=Minus;value=Str "-";content="-"}
    | '*' -> Ok {ttype=Mult;value=Str "*";content="*"}
    | '/' -> Ok {ttype=Div;value=Str "/";content="/"}
    | '(' -> Ok {ttype=LParen;value=Str "(";content="("}
    | ')' -> Ok {ttype=RParen;value=Str ")";content=")"}
    | other -> Error (
        String.make 1 other |>
        String.cat "Invalid character: "
    )
;;

let is_digit = function '0' .. '9' -> true | _ -> false;;

let scan_line (input: string): (token list, string) result =
    let len = String.length input in
    let rec get_number (start: int) (i: int): token * int =
        if i < len && is_digit input.[i]
        then get_number start (i+1)
        else begin
            let sub = String.sub input start (i-start) in
            ({
                ttype=Number;
                value=Int (int_of_string sub);
                content=sub;
            }, i)
            end
    in
    let get_token (i: int): (token * int, string) result =
        if is_digit input.[i] then Ok (get_number i (i+1))
        else
            simple_token input.[i] >>=
            fun t -> Ok (t, i+1)
    in
    let rec get_tokens (i: int): (token list, string) result =
        if i >= len then Ok []
        else if input.[i] == ' ' then get_tokens (i+1)
        else
            get_token i >>=
            fun (tok, npos) -> (get_tokens npos) >>=
            fun l -> Ok (tok::l)
    in 
    get_tokens 0
;;

let scan_lines () : (token list, string) result =
    let rec pl (tokens: token list): (token list, string) result =
        try
            (read_line () |> scan_line) >>=
            (fun l -> Ok (List.append tokens l)) >>=
            pl
        with End_of_file -> Ok tokens
    in pl []
;;

match scan_lines () with
| Ok tokens -> 
    let _ =
        List.map
            (fun x -> string_of_token x |> print_endline)
            tokens
    in ()
| Error error -> begin
    print_endline error;
    exit 1
    end
;;
