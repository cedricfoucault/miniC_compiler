
(*
 *	Copyright (c) 2005 by Laboratoire Spécification et Vérification (LSV),
 *	CNRS UMR 8643 & ENS Cachan.
 *	Written by Jean Goubault-Larrecq.  Derived from the csur project.
 *
 *	Permission is granted to anyone to use this software for any
 *	purpose on any computer system, and to redistribute it freely,
 *	subject to the following restrictions:
 *
 *	1. Neither the author nor its employer is responsible for the consequences of use of
 *		this software, no matter how awful, even if they arise
 *		from defects in it.
 *
 *	2. The origin of this software must not be misrepresented, either
 *		by explicit claim or by omission.
 *
 *	3. Altered versions must be plainly marked as such, and must not
 *		be misrepresented as being the original software.
 *
 *	4. This software is restricted to non-commercial use only.  Commercial
 *		use is subject to a specific license, obtainable from LSV.
 *)

open Cparse
open Verbose
open Compile
open Arg

let input = ref stdin;;
let c_prefix = ref "a.out";;
let c_S = ref false;;

let basename s =
    try String.sub s 0 (String.rindex s '.')
    with Not_found -> s;;

parse [("-v", Unit (fun () -> verbose:=1), "reports stuff");
       ("-v1", Unit (fun () -> verbose:=1), "reports stuff");
       ("-v2", Unit (fun () -> verbose:=2), "reports stuff, and stuff");
       ("-S", Unit (fun () -> c_S:=true), "output assembler dump")
	   (*
       ("--", Rest (fun s -> (rest := true;
			      incr argc;
			      argv := s:: !argv)),
	"pass remaining arguments as arguments to main()")
	    *)
	   ]
      (fun s -> (c_prefix := basename s;
		 input := (Unix.open_process_in ("cpp -DMCC \"" ^ (String.escaped s) ^ "\"") : in_channel)))
	   "compiles a C-- program";;

let lexbuf = Lexing.from_channel (!input) in
let c = Ctab.translation_unit Clex.ctoken lexbuf in
let out = if !c_S then stdout else open_out (!c_prefix ^ ".s") in
    begin
      Error.flush_error ();
      compile out c;
      Error.flush_error ();
      if !c_S
      then ()
      else (flush out;
	    close_out_noerr out;
	    ignore (Unix.system ("gcc -ggdb -o \"" ^ (String.escaped (!c_prefix))
	     ^ "\" \"" ^ (String.escaped (!c_prefix)) ^ ".s\" -lc -lm")))
    end;;

