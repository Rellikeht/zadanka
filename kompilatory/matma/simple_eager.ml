#!/usr/bin/env ocaml

type value_type = Int of int | Str of string

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

let simple_token c : token =
    match c with
    | '+' -> {ttype=Plus;value=Str "+";content="+"}
    | '-' -> {ttype=Minus;value=Str "-";content="-"}
    | '*' -> {ttype=Mult;value=Str "*";content="*"}
    | '/' -> {ttype=Div;value=Str "/";content="/"}
    | '(' -> {ttype=LParen;value=Str "(";content="("}
    | ')' -> {ttype=RParen;value=Str ")";content=")"}
    | other -> raise (Invalid_argument (String.make 1 other))
;;

let is_digit = function '0' .. '9' -> true | _ -> false;;

let scan_line (input: string): token list =
    let len = String.length input in
    let rec get_number (start: int) (i: int): token * int =
        if i < len && is_digit input.[i] then
            get_number start (i+1)
        else begin
            let sub = String.sub input start (i-start) in
            ({
                ttype=Number;
                value=Int (int_of_string sub);
                content=sub;
            }, i)
            end
    in
    let get_token (i: int): token * int =
        if is_digit input.[i] then get_number i (i+1)
        else (simple_token input.[i], i+1)
    in
    let rec get_tokens (i: int): token list =
        if i >= len then []
        else if input.[i] == ' ' then get_tokens (i+1)
        else begin
            let tok, npos = get_token i in
            tok::get_tokens npos
        end
    in 
    get_tokens 0
;;

let scan_lines () : token list =
    let rec pl (tokens: token list): token list =
        try
            List.append (read_line () |> scan_line) tokens |> pl
        with End_of_file -> tokens
    in pl []
;;

scan_lines () |> List.map (fun x -> x |> string_of_token |> print_endline)
