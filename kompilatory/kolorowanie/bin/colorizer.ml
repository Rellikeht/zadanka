open Scanner.Utils;;
open Scanner.Types;;

let rec repeat (str: string) (n: int) = 
  if n < 0 then raise (Invalid_argument "negative value")
  else if n == 0 then ""
  else String.cat str @@ repeat str (n-1)
;;

(* coloring *)

let colorize = function
  | String v ->
    String.cat "#string(to_string([```\"" @@
    String.cat v "\"```]))"
  | Comment v ->
    String.cat "#comment(to_string(```-- " @@
    String.cat v "```))"
    (* String.cat "#comment(to_string([-- " @@ *)
    (* String.cat v "]))" *)
  | Special v ->
    String.cat "#special(\"" @@
    String.cat (string_of_special v) "\")"
  | Operator v ->
    String.cat "#operator(\"" @@
    String.cat (string_of_operator v) "\")"
  | Int v ->
    String.cat "#int(\"" @@
    String.cat (string_of_int v) "\")"
  | Identifier v ->
    String.cat "#identifier(\"" @@
    String.cat v "\")"
  | other -> 
    String.cat "#keyword(\"" @@
    String.cat (token_kind_value other) "\")"
;;

let rec colorize_tokens
  ((line, char): (int * int))
  (tokens: token list):
  unit = match tokens with
  | [] -> ()
  | tok::rest ->
    let lines = tok.line - line in
    repeat " \\\n" lines |> print_string;
    if lines == 0
    then
      String.cat "#raw(\"" @@
      String.cat (repeat " " (tok.char - char)) @@
      "\")" |> print_string
    else
      String.cat "#raw(\"" @@
      String.cat (repeat " " tok.char) @@
      "\")" |> print_string;
    colorize tok.kind |> print_string;
    let len = String.length @@ token_kind_value tok.kind in
    colorize_tokens (tok.line, tok.char + len) rest
;;

(* printing *)

let before = {|
//#set page(
//  "a4", margin: (x: 1.6cm, y: 1.9cm), numbering: none,
//)
#set page(
  margin: (x: 1.6cm, y: 1.9cm), numbering: none,
  width: auto, height: auto,
)

#let to_string(content) = {
  if content.has("text") {
    content.text
  } else if content.has("children") {
    content.children.map(to_string).join("")
  } else if content.has("body") {
    to_string(content.body)
  } else if content == [ ] {
    " "
  }
}

#let comment(body) = text(raw(body), fill: rgb("#15b"))
#let special(body) = text(raw(body), fill: rgb("#700"))
#let operator(body) = text(raw(body), fill: rgb("#d00"))
#let int(body) = text(raw(body), fill: rgb("#02a"))
#let string(body) = text(raw(body), fill: rgb("#193"))
#let identifier(body) = text(raw(body), fill: rgb("#000"))
#let keyword(body) = text(raw(body), fill: rgb("#971"))

#box(
  stroke: (dash: "solid", paint: luma(160)),
  inset: (x: 1em, y: 1em), [
|};;

let after = {|
  ])
|};;

match scan_lines () with
| Ok tokens ->
  print_endline before;
  colorize_tokens (0, 0) tokens;
  print_endline after;
| Error error -> begin
  print_endline error;
  exit 1
  end
;;
