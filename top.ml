
(*
 *	Copyright (c) 2006 by Laboratoire Spécification et Vérification (LSV),
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

#load "error.cmo";;
#load "cparse.cmo";;
#load "ctab.cmo";;
#load "clex.cmo";;
#load "verbose.cmo";;
#load "genlab.cmo";;
#load "compile.cmo";;

open Cparse;; (* permet d'eviter que l'affichage de ast ne produise
	       des Cparse.CWHILE, et affichera a la place CWHILE
	       (par exemple). *)

let ast = ref ([] : Cparse.var_declaration list);;

#print_depth 100;;    (* a modifier si pas assez... *)
#print_length 10000;; (* a modifier si pas assez... *)

let rec teste nom_fichier = (* attention, le fichier n'est pas passe par le preprocesseur C, comme dans main.ml. *)
  let input = open_in nom_fichier in
  let lexbuf = Lexing.from_channel input in
  let c = Ctab.translation_unit Clex.ctoken lexbuf in
  let out = stdout in
  begin
    Error.flush_error ();
    ast := c;
    Printf.fprintf stderr "Regarder dans ast pour voir l'arbre de syntaxe abstraite.\n";
    flush stderr;
    Compile.compile out c;
    Error.flush_error ()
  end;;

