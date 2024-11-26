open Scanner.Utils;;
open Scanner.Types;;

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
