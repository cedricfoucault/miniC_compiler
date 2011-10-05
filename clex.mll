{

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

(* Analyse lexicale d'un sous-ensemble (tres) reduit de C.
 *)

open Cparse
open Error
open Ctab

let string_buf = Buffer.create 256

let string_iter f s = (* = String.iter; pas present en OCaml 2.04. *)
	let n = String.length s
	in for i=0 to n-1 do f (s.[i]) done

let count yytext =
	(oldcline := !cline; oldccol := !ccol;
	string_iter (fun c -> match c with
			'\n' -> (cline := !cline+1; ccol := 0)
                      (* | '\t' -> (ccol := !ccol + 8 - (!ccol mod 8)) *)
                      | _ -> ccol := !ccol+1) yytext)

let parse_hex yytext tend =
	let n = ref 0
	in let len = String.length yytext-tend
	in ((for i=2 to len-1 do
	     let c = yytext.[i] in
	     match c with
	         '0'..'9' -> n := 16 * !n + (int_of_char c - int_of_char '0')
               | 'a'..'f' -> n := 16 * !n + (int_of_char c + 10 - int_of_char 'a')
               | 'A'..'F' -> n := 16 * !n + (int_of_char c + 10 - int_of_char 'A')
	       | _ -> fatal (Some (!cfile, !cline, !ccol-len, !cline, !ccol))
			("invalid hexadecimal number " ^ yytext)
	     done);
	    !n)

let parse_oct yytext start tend =
	let n = ref 0
	in let len = String.length yytext-tend
	in ((for i=start to len-1 do
	     let c = yytext.[i] in
	     match c with
	         '0'..'7' -> n := 8 * !n + (int_of_char c - int_of_char '0')
	       | _ -> fatal (Some (!cfile, !cline, !ccol-len, !cline, !ccol))
			("invalid octal number " ^ yytext)
	     done);
	    !n)

let parse_dec yytext tend =
	let n = ref 0
	in let len = String.length yytext-tend
	in ((for i=0 to len-1 do
	     let c = yytext.[i] in
	     match c with
	         '0'..'9' -> n := 10 * !n + (int_of_char c - int_of_char '0')
	       | _ -> fatal (Some (!cfile, !cline, !ccol-len, !cline, !ccol))
			("invalid number " ^ yytext)
	    done);
	    !n)

}

let digit  = ['0'-'9']
let letter = ['a'-'z' 'A'-'Z' '_']
let hex    = ['a'-'f' 'A'-'F' '0'-'9']
let expo   = ['E' 'e'] ['+' '-']? digit+
let fs     = ['f' 'F' 'l' 'L']
let is     = ['u' 'U' 'l' 'L']*

rule ctoken = parse
    "/*" { count (Lexing.lexeme lexbuf); comment lexbuf; ctoken lexbuf }
  | "auto" { count (Lexing.lexeme lexbuf); AUTO }
  | "break" { count (Lexing.lexeme lexbuf); BREAK }
  | "case" { count (Lexing.lexeme lexbuf); CASE }
  | "char" { count (Lexing.lexeme lexbuf); CHAR }
  | "const"  { count (Lexing.lexeme lexbuf); CONST }
  | "continue" { count (Lexing.lexeme lexbuf); CONTINUE }
  | "default" { count (Lexing.lexeme lexbuf); DEFAULT }
  | "do" { count (Lexing.lexeme lexbuf); DO }
  | "double" { count (Lexing.lexeme lexbuf); DOUBLE }
  | "else" { count (Lexing.lexeme lexbuf); ELSE }
  | "enum" { count (Lexing.lexeme lexbuf); ENUM }
  | "extern" { count (Lexing.lexeme lexbuf); EXTERN }
  | "float" { count (Lexing.lexeme lexbuf); FLOATING }
  | "for" { count (Lexing.lexeme lexbuf); FOR }
  | "goto" { count (Lexing.lexeme lexbuf); GOTO }
  | "if" { count (Lexing.lexeme lexbuf); IF }
  | "int" { count (Lexing.lexeme lexbuf); INTEGER }
  | "long" { count (Lexing.lexeme lexbuf); LONG }
  | "register" { count (Lexing.lexeme lexbuf); REGISTER }
  | "return" { count (Lexing.lexeme lexbuf); RETURN }
  | "short" { count (Lexing.lexeme lexbuf); SHORT }
  | "signed" { count (Lexing.lexeme lexbuf); SIGNED }
  | "sizeof" { count (Lexing.lexeme lexbuf); SIZEOF }
  | "static" { count (Lexing.lexeme lexbuf); STATIC }
  | "struct" { count (Lexing.lexeme lexbuf); STRUCT }
  | "switch" { count (Lexing.lexeme lexbuf); SWITCH }
  | "typedef" { count (Lexing.lexeme lexbuf); TYPEDEF }
  | "union" { count (Lexing.lexeme lexbuf); UNION }
  | "unsigned" { count (Lexing.lexeme lexbuf); UNSIGNED }
  | "void" { count (Lexing.lexeme lexbuf); VOID }
  | "volatile" { count (Lexing.lexeme lexbuf); VOLATILE }
  | "while" { count (Lexing.lexeme lexbuf); WHILE }
  | "try" { count (Lexing.lexeme lexbuf); TRY }
  | "catch" { count (Lexing.lexeme lexbuf); CATCH }
  | "finally" { count (Lexing.lexeme lexbuf); FINALLY }
  | "throw" { count (Lexing.lexeme lexbuf); THROW }
  | letter (letter | digit)* { count (Lexing.lexeme lexbuf);
		let yytext = Lexing.lexeme lexbuf in
		    IDENTIFIER yytext
                    } 
  | '0' ['x' 'X'] hex+ { count (Lexing.lexeme lexbuf);
			CONSTANT (parse_hex (Lexing.lexeme lexbuf) 0) }
  | '0' ['x' 'X'] hex+ ['u' 'U'] { count (Lexing.lexeme lexbuf);
			CONSTANT (parse_hex (Lexing.lexeme lexbuf) 1) }
  | '0' ['x' 'X'] hex+ ['l' 'L'] { count (Lexing.lexeme lexbuf);
			CONSTANT (parse_hex (Lexing.lexeme lexbuf) 1) }
  | '0' ['x' 'X'] hex+ ['u' 'U'] ['l' 'L'] { count (Lexing.lexeme lexbuf);
			CONSTANT (parse_hex (Lexing.lexeme lexbuf) 2) }

 | '0' ['x' 'X'] hex+ ['u' 'U'] ['l' 'L'] ['l' 'L'] { count (Lexing.lexeme lexbuf);
			CONSTANT (parse_hex (Lexing.lexeme lexbuf) 3) }


  | '0' ['0'-'7']+ { count (Lexing.lexeme lexbuf);
			CONSTANT (parse_oct (Lexing.lexeme lexbuf) 1 0) }
  | '0' ['0'-'7']+ ['u' 'U'] { count (Lexing.lexeme lexbuf);
			CONSTANT (parse_oct (Lexing.lexeme lexbuf) 1 1) }
  | '0' ['0'-'7']+ ['l' 'L'] { count (Lexing.lexeme lexbuf);
			CONSTANT (parse_oct (Lexing.lexeme lexbuf) 1 1) }

  | '0' ['0'-'7']+ ['u' 'U'] ['l' 'L'] { count (Lexing.lexeme lexbuf);
			CONSTANT (parse_oct (Lexing.lexeme lexbuf) 1 2) }

  | '0' ['0'-'7']+ ['u' 'U'] ['l' 'L'] ['l' 'L'] { count (Lexing.lexeme lexbuf);
			CONSTANT (parse_oct (Lexing.lexeme lexbuf) 1 3) }

  | digit+ { count (Lexing.lexeme lexbuf);
			CONSTANT (parse_dec (Lexing.lexeme lexbuf) 0) }
  | digit+ ['u' 'U'] { count (Lexing.lexeme lexbuf);
			CONSTANT (parse_dec (Lexing.lexeme lexbuf) 1) }
  | digit+ ['l' 'L'] { count (Lexing.lexeme lexbuf);
			CONSTANT (parse_dec (Lexing.lexeme lexbuf) 1) }

  | digit+ ['l' 'L' ] ['l' 'L' ] { count (Lexing.lexeme lexbuf);
			CONSTANT (parse_dec (Lexing.lexeme lexbuf) 1) }

  | digit+ ['u' 'U'] ['l' 'L'] { count (Lexing.lexeme lexbuf);
			CONSTANT (parse_dec (Lexing.lexeme lexbuf) 2) }

  | digit+ ['u' 'U'] ['l' 'L'] ['l' 'L'] { count (Lexing.lexeme lexbuf);
			CONSTANT (parse_dec (Lexing.lexeme lexbuf) 3) }

  | '\'' [^ '\'' '\\'] '\'' { count (Lexing.lexeme lexbuf);
			CONSTANT (int_of_char (Lexing.lexeme_char lexbuf 1)) }
  | '\'' '\\' ['0'-'7'] ['0'-'7']? ['0'-'7']? '\'' { count (Lexing.lexeme lexbuf);
			CONSTANT (parse_oct (Lexing.lexeme lexbuf) 2 1) }
  | '\'' '\\' 'a' '\'' { count (Lexing.lexeme lexbuf);
			CONSTANT 7 (* bell, ^G *) }
  | '\'' '\\' 'b' '\'' { count (Lexing.lexeme lexbuf);
			CONSTANT (int_of_char '\b') }
  | '\'' '\\' 'f' '\'' { count (Lexing.lexeme lexbuf);
			CONSTANT 12 (* form feed, ^L *) }
  | '\'' '\\' 'n' '\'' { count (Lexing.lexeme lexbuf);
			CONSTANT (int_of_char '\n') }
  | '\'' '\\' 'r' '\'' { count (Lexing.lexeme lexbuf);
			CONSTANT (int_of_char '\r') }
  | '\'' '\\' 't' '\'' { count (Lexing.lexeme lexbuf);
			CONSTANT (int_of_char '\t')
				 (* bell, ^G *) }
  | '\'' '\\' 'v' '\'' { count (Lexing.lexeme lexbuf);
			CONSTANT 11 (* vertical tab, ^K *) }
  | '\'' '\\' _ '\'' { count (Lexing.lexeme lexbuf);
			CONSTANT (int_of_char (Lexing.lexeme_char lexbuf 2)) }
  | "\"" 
      { 
        count (Lexing.lexeme lexbuf); Buffer.reset string_buf;
        string lexbuf;
	STRING_LITERAL (Buffer.contents string_buf)
      }
  | "..." { count (Lexing.lexeme lexbuf); ELLIPSIS }
  | ">>=" { count (Lexing.lexeme lexbuf); RIGHT_ASSIGN }
  | "<<=" { count (Lexing.lexeme lexbuf); LEFT_ASSIGN }
  | "+="  { count (Lexing.lexeme lexbuf); ADD_ASSIGN }
  | "-="  { count (Lexing.lexeme lexbuf); SUB_ASSIGN }
  | "*="  { count (Lexing.lexeme lexbuf); MUL_ASSIGN }
  | "/="  { count (Lexing.lexeme lexbuf); DIV_ASSIGN }
  | "%="  { count (Lexing.lexeme lexbuf); MOD_ASSIGN }
  | "&="  { count (Lexing.lexeme lexbuf); AND_ASSIGN }
  | "^="  { count (Lexing.lexeme lexbuf); XOR_ASSIGN }
  | "|="  { count (Lexing.lexeme lexbuf); OR_ASSIGN }
  | ">>"  { count (Lexing.lexeme lexbuf); RIGHT_OP }
  | "<<"  { count (Lexing.lexeme lexbuf); LEFT_OP }
  | "++"  { count (Lexing.lexeme lexbuf); INC_OP }
  | "--"  { count (Lexing.lexeme lexbuf); DEC_OP }
  | "->"  { count (Lexing.lexeme lexbuf); PTR_OP }
  | "&&"  { count (Lexing.lexeme lexbuf); AND_OP }
  | "||"  { count (Lexing.lexeme lexbuf); OR_OP }
  | "<="  { count (Lexing.lexeme lexbuf); LE_OP }
  | ">="  { count (Lexing.lexeme lexbuf); GE_OP }
  | "=="  { count (Lexing.lexeme lexbuf); EQ_OP }
  | "!="  { count (Lexing.lexeme lexbuf); NE_OP }
  | ";"   { count (Lexing.lexeme lexbuf); SEMI_CHR }
  | ("{" | "<%") { count (Lexing.lexeme lexbuf); OPEN_BRACE_CHR }
  | ("}" | "%>") { count (Lexing.lexeme lexbuf); CLOSE_BRACE_CHR }
  | "," { count (Lexing.lexeme lexbuf); COMMA_CHR }
  | ":" { count (Lexing.lexeme lexbuf); COLON_CHR }
  | "=" { count (Lexing.lexeme lexbuf); EQ_CHR }
  | "(" { count (Lexing.lexeme lexbuf); OPEN_PAREN_CHR }
  | ")" { count (Lexing.lexeme lexbuf); CLOSE_PAREN_CHR }
  | ("[" | "<:") { count (Lexing.lexeme lexbuf); OPEN_BRACKET_CHR }
  | ("]" | ":>") { count (Lexing.lexeme lexbuf); CLOSE_BRACKET_CHR }
  | "." { count (Lexing.lexeme lexbuf); DOT_CHR }
  | "&" { count (Lexing.lexeme lexbuf); AND_CHR }
  | "|" { count (Lexing.lexeme lexbuf); OR_CHR }
  | "^" { count (Lexing.lexeme lexbuf); XOR_CHR }
  | "!" { count (Lexing.lexeme lexbuf); BANG_CHR }
  | "~" { count (Lexing.lexeme lexbuf); TILDE_CHR }
  | "+" { count (Lexing.lexeme lexbuf); ADD_CHR }
  | "-" { count (Lexing.lexeme lexbuf); SUB_CHR }
  | "*" { count (Lexing.lexeme lexbuf); STAR_CHR }
  | "/" { count (Lexing.lexeme lexbuf); DIV_CHR }
  | "%" { count (Lexing.lexeme lexbuf); MOD_CHR }
  | "<" { count (Lexing.lexeme lexbuf); OPEN_ANGLE_CHR }
  | ">" { count (Lexing.lexeme lexbuf); CLOSE_ANGLE_CHR }
  | "?" { count (Lexing.lexeme lexbuf); QUES_CHR }
  | '#' { count (Lexing.lexeme lexbuf); line lexbuf }
  | [' ' '\t' '\012' '\013' '\n' '\014']+ { count (Lexing.lexeme lexbuf); ctoken lexbuf }
  | _ { fatal (Some (!cfile, !cline, !ccol, !cline, !ccol+1))
	 ("bad character '" ^ (Lexing.lexeme lexbuf) ^ "'") }
  | eof { EOF }
and comment = parse
    "*/" { count (Lexing.lexeme lexbuf) }
  | [^ '*']* { count (Lexing.lexeme lexbuf); comment lexbuf }
  | eof { fatal (Some (!cfile, !cline, !ccol, !cline, !ccol)) "end of file reached inside comment" }
and string = parse
    '"' { () }
  | '\n'+ { string lexbuf }
  | '\\' ['0'-'7'] ['0'-'7']? ['0'-'7']? { Buffer.add_char string_buf (Char.chr (parse_oct (Lexing.lexeme lexbuf) 1 0)); string lexbuf }
  | '\\' 'a' { Buffer.add_char string_buf '\007'; string lexbuf }
  | '\\' 'b' { Buffer.add_char string_buf '\b'; string lexbuf }
  | '\\' 'f' { Buffer.add_char string_buf '\014'; string lexbuf }
  | '\\' 'n' { Buffer.add_char string_buf '\n'; string lexbuf }
  | '\\' 'r' { Buffer.add_char string_buf '\r'; string lexbuf }
  | '\\' 't' { Buffer.add_char string_buf '\t'; string lexbuf }
  | '\\' 'v' { Buffer.add_char string_buf '\013'; string lexbuf }
  | '\\' _ { Buffer.add_char string_buf (Lexing.lexeme_char lexbuf 1); string lexbuf }
  | [^ '\\' '\n' '"']+ { Buffer.add_string string_buf (Lexing.lexeme lexbuf); string lexbuf }
  | _ { Buffer.add_char string_buf (Lexing.lexeme_char lexbuf 0); string lexbuf }
  | eof { fatal (Some (!cfile, !cline, !ccol, !cline, !ccol)) "end of file reached inside string literal" }
and line = parse
    ['0'-'9']+ { cline := parse_dec (Lexing.lexeme lexbuf) 0 - 1; line2 lexbuf }
  | [' ' '\t']+ { count (Lexing.lexeme lexbuf); line lexbuf }
  | '\n' { count (Lexing.lexeme lexbuf); ctoken lexbuf }
  | "\"" { count (Lexing.lexeme lexbuf); Buffer.reset string_buf;
        string lexbuf;
	cfile := Buffer.contents string_buf;
	ctoken lexbuf
      }
  | eof { fatal (Some (!cfile, !cline, !ccol, !cline, !ccol)) "end of file reached inside # directive" }
and line2 = parse
    [' ' '\t']+ { count (Lexing.lexeme lexbuf); line2 lexbuf }
  | '\n' { count (Lexing.lexeme lexbuf); ctoken lexbuf }
  | "\"" { count (Lexing.lexeme lexbuf); Buffer.reset string_buf;
        string lexbuf;
	cfile := Buffer.contents string_buf;
	line3 lexbuf
      }
  | eof { fatal (Some (!cfile, !cline, !ccol, !cline, !ccol)) "end of file reached inside # directive" }
and line3 = parse
    '\n' { count (Lexing.lexeme lexbuf); ctoken lexbuf }
  |  _ { count (Lexing.lexeme lexbuf); line3 lexbuf }
  | eof  { fatal (Some (!cfile, !cline, !ccol, !cline, !ccol)) "end of file reached inside # directive" }
