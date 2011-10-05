
(*
 *	Copyright (c) 2005, 2006 by Laboratoire Spécification et Vérification (LSV),
 *	UMR 8643 CNRS & ENS Cachan.
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
 * 
*)

open Error

type mon_op = M_MINUS | M_NOT | M_POST_INC | M_POST_DEC | M_PRE_INC | M_PRE_DEC
    (* Les opérations unaires:
     M_MINUS: calcule l'opposé -e de e;
     M_NOT: calcule la négation logique ~e de e;
     M_POST_INC: post-incrémentation e++;
     M_POST_DEC: post-décrémentation e--;
     M_PRE_INC: pré-incrémentation ++e;
     M_PRE_DEC: pré-décrémentation --e.
     *)
type bin_op = S_MUL | S_DIV | S_MOD | S_ADD | S_SUB | S_INDEX
    (* Les opérations binaires:
     S_MUL: multiplication entière;
     S_DIV: division entière (quotient);
     S_MOD: division entière (reste);
     S_ADD: addition entière;
     S_SUB: soustraction entière;
     S_INDEX: accès à un élément de tableau a[i].
     *)
type cmp_op = C_LT | C_LE | C_EQ
    (* Les opérations de comparaison:
     C_LT (less than): <;
     C_LE (less than or equal to): <=;
     C_EQ (equal): ==.
     *)

type loc_expr = locator * expr
and expr = VAR of string (* une variable --- toujours de type int. *)
    | CST of int (* une constante entiere. *)
    | STRING of string (* une constante chaine. *)
    | SET_VAR of string * loc_expr (* affectation x=e. *)
    | SET_ARRAY of string * loc_expr * loc_expr (* affectation x[e]=e'. *)
    | CALL of string * loc_expr list (* appel de fonction f(e1,...,en) *)
	(* operations arithmetiques: *)
    | OP1 of mon_op * loc_expr (* OP1(mop, e) dénote -e, ~e, e++, e--, ++e, ou --e. *)
    | OP2 of bin_op * loc_expr * loc_expr (* OP2(bop,e,e') dénote e*e', e/e', e%e',
					   e+e', e-e', ou e[e']. *)
    | CMP of cmp_op * loc_expr * loc_expr (* CMP(cop,e,e') vaut e<e', e<=e', ou e==e' *)
    | EIF of loc_expr * loc_expr * loc_expr (* EIF(e1,e2,e3) est e1?e2:e3 *)
    | ESEQ of loc_expr list (* e1, ..., en [sequence, analogue a e1;e2 au niveau code];
			     si n=0, represente skip. *)

type var_declaration =
    CDECL of locator * string (* declaration de variable de type int. *)
  | CFUN of locator * string * var_declaration list * loc_code
    (* fonction avec ses arguments, et son code. *)
and loc_code = locator * code
and code =
    CBLOCK of var_declaration list * loc_code list (* { declarations; code; } *)
  | CEXPR of loc_expr (* une expression e; vue comme instruction. *)
  | CIF of loc_expr * loc_code * loc_code (* if (e) c1; else c2; *)
  | CWHILE of loc_expr * loc_code (* while (e) c1; *)
  | CRETURN of loc_expr option (* return; ou return (e); *)
  | CTHROW of string * loc_expr (* throw nom_exception (e); *)
  | CTRY of (* try code [catch (nom_exception var) code]* [finally code]? *)
    loc_code * (* le code juste après "try" *)
    (string * string * loc_code) list * (* la liste des (nom_exception, var, code)
					 pour chaque clause catch, dans l'ordre. *)
    loc_code option (* la clause finally, si presente. *)

let cline = ref 1
let ccol = ref 0
let oldcline = ref 1
let oldccol = ref 0
let cfile = ref ""

let getloc () = (!cfile, !oldcline, !oldccol, !cline, !ccol)


let loc_of_expr (loc, _) = loc
let e_of_expr (_, e) = e

let index_prec  = 15 (* a[i] *)
let ptr_prec    = 15 (* a->f *)
let dot_prec    = 15 (* a.f *)
let bang_prec   = 14 (* !a *)
let tilde_prec  = 14 (* ~a *)
let incdec_prec = 14 (* ++a, a++, --a, a-- *)
let cast_prec   = 14 (* (T)a *)
let sizeof_prec = 14 (* sizeof T *)
let uplus_prec  = 14 (* +a *)
let uminus_prec = 14 (* -a *)
let star_prec   = 14 (* *a *)
let amper_prec  = 14 (* &a *)
let mul_prec    = 13 (* a*b *)
let div_prec    = 13 (* a/b *)
let mod_prec    = 13 (* a%b *)
let add_prec    = 12 (* a+b *)
let sub_prec    = 12 (* a-b *)
let shift_prec  = 11 (* a<<b, a>>b *)
let cmp_prec    = 10 (* a<b, a<=b, a>b, a>=b *)
let eq_prec     = 9 (* a==b, a!=b *)
let binand_prec = 8 (* a & b *)
let binxor_prec = 7 (* a ^ b *)
let binor_prec  = 6 (* a | b *)
let and_prec    = 5 (* a && b *)
let or_prec     = 4 (* a || b *)
let if_prec     = 3 (* a?b:c *)
let setop_prec  = 2 (* a += b, a *= b, ... *)
let comma_prec  = 1 (* a, b *)

let bufout_delim buf pri newpri s =
    if newpri<pri
	then Buffer.add_string buf s
    else ()

let bufout_open buf pri newpri = bufout_delim buf pri newpri "("
let bufout_close buf pri newpri = bufout_delim buf pri newpri ")"

let setop_text setop =
    match setop with
        S_MUL -> "*="
      | S_DIV -> "/="
      | S_MOD -> "%="
      | S_ADD -> "+="
      | S_SUB -> "-="
      | S_INDEX -> ""

let mop_text mop =
  match mop with
    M_MINUS -> "-"
  | M_NOT -> "~"
  | M_POST_INC | M_PRE_INC -> "++"
  | M_POST_DEC | M_PRE_DEC -> "--"

let mop_prec mop =
  match mop with
    M_MINUS -> uminus_prec
  | M_NOT -> tilde_prec
  | M_POST_INC | M_POST_DEC | M_PRE_INC | M_PRE_DEC -> incdec_prec

let op_text setop =
    match setop with
        S_MUL -> "*"
      | S_DIV -> "/"
      | S_MOD -> "%"
      | S_ADD -> "+"
      | S_SUB -> "-"
      | S_INDEX -> "["

let fin_op_text setop =
    match setop with
        S_MUL -> ""
      | S_DIV -> ""
      | S_MOD -> ""
      | S_ADD -> ""
      | S_SUB -> ""
      | S_INDEX -> "]"

let op_prec setop =
    match setop with
        S_MUL -> mul_prec
      | S_DIV -> div_prec
      | S_MOD -> mod_prec
      | S_ADD -> add_prec
      | S_SUB -> sub_prec
      | S_INDEX -> index_prec

let rec bufout_expr buf pri e =
    match e with
	VAR s -> Buffer.add_string buf s
      | CST n -> Buffer.add_string buf (string_of_int n)
      | STRING s ->
	  begin
	    Buffer.add_string buf "\"";
	    Buffer.add_string buf (String.escaped s);
	    Buffer.add_string buf "\""
	  end
      | SET_VAR (x, e) -> (bufout_open buf pri setop_prec;
			      Buffer.add_string buf x;
			      Buffer.add_string buf "=";
			      bufout_loc_expr buf setop_prec e;
			      bufout_close buf pri setop_prec)
      | SET_ARRAY (x, e, e') -> (bufout_open buf pri setop_prec;
				 Buffer.add_string buf x;
				 Buffer.add_string buf "[";
				 bufout_loc_expr buf index_prec e;
				 Buffer.add_string buf "]=";
				 bufout_loc_expr buf setop_prec e';
				 bufout_close buf pri setop_prec)
      | CALL (f, l) -> (bufout_open buf pri index_prec;
			Buffer.add_string buf f;
			Buffer.add_string buf "(";
			bufout_loc_expr_list buf l;
			Buffer.add_string buf ")";
			bufout_close buf pri index_prec)
      | OP1 (mop, e') ->
	  let newpri = mop_prec mop in
	  (bufout_open buf pri newpri;
	   (match mop with
	     M_MINUS | M_NOT | M_PRE_INC | M_PRE_DEC ->
	       (Buffer.add_string buf (mop_text mop);
		bufout_loc_expr buf newpri e')
	   | _ ->
	       (bufout_loc_expr buf newpri e';
		Buffer.add_string buf (mop_text mop)));
	   bufout_close buf pri newpri)
      | OP2 (setop, e, e') -> let newpri = op_prec setop in
	(bufout_open buf pri newpri;
	 bufout_loc_expr buf newpri e;
	 Buffer.add_string buf (op_text setop);
	 bufout_loc_expr buf newpri e';
	 Buffer.add_string buf (fin_op_text setop);
	 bufout_close buf pri newpri)
      | CMP (C_LT, e, e') -> (bufout_open buf pri cmp_prec;
			      bufout_loc_expr buf cmp_prec e;
			      Buffer.add_string buf "<";
			      bufout_loc_expr buf cmp_prec e';
			      bufout_close buf pri cmp_prec)
      | CMP (C_LE, e, e') -> (bufout_open buf pri cmp_prec;
			      bufout_loc_expr buf cmp_prec e;
			      Buffer.add_string buf "<=";
			      bufout_loc_expr buf cmp_prec e';
			      bufout_close buf pri cmp_prec)
      | CMP (C_EQ, e, e') -> (bufout_open buf pri eq_prec;
			      bufout_loc_expr buf eq_prec e;
			      Buffer.add_string buf "==";
			      bufout_loc_expr buf eq_prec e';
			      bufout_close buf pri eq_prec)
      | EIF (eb, et, ee) -> (bufout_open buf pri if_prec;
			     bufout_loc_expr buf if_prec eb;
			     Buffer.add_string buf "?";
			     bufout_loc_expr buf if_prec et;
			     Buffer.add_string buf ":";
			     bufout_loc_expr buf if_prec ee;
			     bufout_close buf pri if_prec)
      | ESEQ (e::l) -> (bufout_open buf pri comma_prec;
			bufout_loc_expr buf comma_prec e;
			List.iter (fun e' -> (Buffer.add_string buf ",";
					      bufout_loc_expr buf comma_prec e')) l;
			bufout_close buf pri comma_prec)
      | ESEQ [] -> ()
and bufout_loc_expr buf pri (_, e) =
  bufout_expr buf pri e
and bufout_loc_expr_list buf l =
    match l with
	[] -> ()
      | [a] -> bufout_loc_expr buf comma_prec a
      | a::l' -> (bufout_loc_expr buf comma_prec a;
		  Buffer.add_string buf ",";
		  bufout_loc_expr_list buf l')

let rec string_of_expr e =
  let buf = Buffer.create 128 in
  bufout_loc_expr buf comma_prec e;
  Buffer.contents buf

let rec string_of_loc_expr e =
  let buf = Buffer.create 128 in
  bufout_expr buf comma_prec e;
  Buffer.contents buf
