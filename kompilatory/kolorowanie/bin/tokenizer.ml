open Utils;;

let scan_lines () : (token list, string) result =
  let rec pl (i:int) (tokens: token list): (token list, string) result =
    try
      (read_line () |> scan_line i) >>=
      (fun l -> Ok (List.append tokens l)) >>=
      pl (i+1)
    with End_of_file -> Ok tokens
  in pl 0 []
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
