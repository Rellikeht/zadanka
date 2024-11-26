#!/usr/bin/env ocaml

(* SEQUENCES *)

let rec ones (): int Seq.t =
    fun () -> Seq.Cons (1, ones ())
;;

let rec naturals (i: int): int Seq.t =
    fun () -> Seq.Cons (i, naturals (i+1))
;;

let rec take (n: int) (seq: int Seq.t): int list option =
    if n <= 0 then Some []
    else match seq () with
    | Seq.Cons (x, rest) ->
            Option.bind
                (take (n-1) rest)
                (fun l -> Some (x::l))
    | _ -> None
;;

(* ones () |> *)
naturals 0 |>
take 20 |>
(fun opt -> match opt with
    | None -> print_string "None"
    | Some list -> begin
        let _ = List.map
            (fun x -> print_int x; print_char ' ')
            list in ()
        end
)
;;
print_endline "";;

(* LISTS *)

(* let rec ones: int list = 1::ones;; *)

(* This fails *)
(* let rec naturals: int list = *)
(*     let rec nat (i: int): int list = *)
(*         i::nat (i+1) *)
(*     in nat 1 *)
(* ;; *)

(* List.hd naturals |> print_int;; *)
(* exit 0;; *)

(* let rec take (list: int list) (n: int): int list = *)
(*     if n == 0 then [] *)
(*     else (List.hd list)::take (List.tl list) (n-1) *)
(* ;; *)

(* naturals |> *)
(* (fun l -> take l 20) |> *)
(* List.map (fun x -> print_int x; print_char ' ') *)
(* ;; *)
(* print_endline "";; *)
