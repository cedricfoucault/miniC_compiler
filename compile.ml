open Cparse
open Genlab
open Printf

let str_decl = ref ([] : (string * string) list)
(* couples (s, label) where s is a string constant that has been stored at the address specified by label *)

type register = EAX | EBX | ECX | EDX | EBP | ESP

let str_of_reg = function
| EAX -> "%eax"
| EBX -> "%ebx"
| ECX -> "%ecx"
| EDX -> "%edx"
| EBP -> "%ebp"
| ESP -> "%esp"

type obj = 
| Reg of register  (* register *)
| Const of int (* constant (in C-- all values are integers) *)
| Global of string (* global variable *)
| Local of int  (* local variable (pushed on the call stack) *)
| Elem of register * register (* Elem (r1, r2) represents 1 element of an array where the r1 points to the first element of the array r2 contains the index i of the element *)

let eax = Reg(EAX) and ebx = Reg(EBX) and ecx = Reg(ECX) and edx = Reg(EDX) and ebp = Reg(EBP) and esp = Reg(ESP)

let str_of_obj = function
(* we access each object via a different addressing mode *)
| Reg r -> str_of_reg r (* register addressing mode *)
| Const x -> Printf.sprintf "$%d" x (* immediate addressing mode *)
| Global s -> s (* absolute/direct addressing mode *)
| Local offset -> Printf.sprintf "%d(%%ebp)" offset (* base plus offset *)
| Elem (r1, r2) -> (* indexed addressing mode *)
  let s1 = str_of_reg r1 and s2 = str_of_reg r2 in
  Printf.sprintf "(%s, %s, 4)" s1 s2

let mov_ out source dest =
  let s1 = str_of_obj source and s2 = str_of_obj dest in
  Printf.fprintf out "    movl    %s, %s\n" s1 s2
let leal_ out source dest =
  let s1 = str_of_obj source and s2 = str_of_obj dest in
  Printf.fprintf out "    leal    %s, %s\n" s1 s2
let add_ out source dest =
  let s1 = str_of_obj source and s2 = str_of_obj dest in
  Printf.fprintf out "    addl    %s, %s\n" s1 s2
let sub_ out source dest =
  let s1 = str_of_obj source and s2 = str_of_obj dest in
  Printf.fprintf out "    subl    %s, %s\n" s1 s2
let imul_ out source dest =
  let s1 = str_of_obj source and s2 = str_of_obj dest in
  Printf.fprintf out "    imull   %s, %s\n" s1 s2
let inc_ out dest =
  let s = str_of_obj dest in
  Printf.fprintf out "    incl    %s\n" s
let dec_ out dest =
  let s = str_of_obj dest in
  Printf.fprintf out "    decl    %s\n" s
let neg_ out dest =
  let s = str_of_obj dest in
  Printf.fprintf out "    negl    %s\n" s
let push_ out source =
  let s = str_of_obj source in
  Printf.fprintf out "    pushl   %s\n" s
let pop_ out dest =
  let s = str_of_obj dest in
  Printf.fprintf out "    popl    %s\n" s
let cmp_ out source dest =
  let s1 = str_of_obj source and s2 = str_of_obj dest in
  Printf.fprintf out "    cmpl    %s, %s\n" s1 s2
let call_ out addr =
  let s = str_of_obj addr in
  Printf.fprintf out "    call    %s\n" s
let jmp_ out addr =
  let s = str_of_obj addr in
  Printf.fprintf out "    jmp     %s\n" s
let je_ out addr =
  let s =  str_of_obj addr in
  Printf.fprintf out "    je      %s\n" s
let jne_ out addr =
  let s =  str_of_obj addr in
  Printf.fprintf out "    jne     %s\n" s
let jle_ out addr =
  let s =  str_of_obj addr in
  Printf.fprintf out "    jle     %s\n" s
let jl_ out addr =
  let s =  str_of_obj addr in
  Printf.fprintf out "    jl      %s\n" s
let cltd_ out () = Printf.fprintf out "    cltd\n"
let idiv_ out dest =
  let s = str_of_obj dest in
  Printf.fprintf out "    idivl   %s\n" s
let leave_ out () = Printf.fprintf out "    leave\n"
let ret_ out () = Printf.fprintf out "    ret\n"

let rec compile_expr out func env e = 
(* type :: out_channel -> string -> (string * int) list -> Cparse.var_declaration list -> unit *)
  let mov = mov_ out and leal = leal_ out and add = add_ out and sub = sub_ out and imul = imul_ out and cmp = cmp_ out and jmp = jmp_ out and je = je_ out and jne = jne_ out and jle = jle_ out and jl = jl_ out and cltd = cltd_ out and idiv = idiv_ out and push = push_ out and pop = pop_ out and neg = neg_ out  and inc = inc_ out and dec = dec_ out and call = call_ out and print = Printf.fprintf out "%s:\n" in
  
  begin match (snd e) with
  | CST x ->
    (* integer constant x *)
    mov (Const(x)) eax;
  | STRING s ->
    (* string constant s evaluates as the address of its first character *)
    begin  
      let s_label = genlab func in
      str_decl := (s, s_label) :: !str_decl;
      leal (Global(s_label)) eax;
    end
  | VAR s ->
    (* variable x, where s == "x" *)
    let var = try Local (List.assoc s env) with Not_found -> Global (s) in
    mov var eax;
  | SET_VAR (s, exp) ->
    (* assignment x = exp, where s == "x" *)
    begin
      compile_expr out func env exp;
      let var = try Local (List.assoc s env) with Not_found -> Global (s) in
      mov eax var;
    end
  | SET_ARRAY (s, i, exp) -> 
    (* assignment t[i] = exp, where s == "t" *)
    begin
      (* save the value of i on the stack *)
      compile_expr out func env i;
      push eax;
      (* save the address of the array t on the stack *)
      let var = try Local (List.assoc s env) with Not_found -> Global (s) in
      push var;
      (* evaluate exp and put it in t[i] via ebx and ecx *)
      compile_expr out func env exp;
      pop ebx;
      pop ecx;
      mov eax (Elem(EBX, ECX));
    end
  | CALL (s, l_exp) ->
    (* function call f(p1, ..., pn) where s == "f" and l_exp == [p1,..., pn]*)
    begin
      (* push each function argument onto the stack *)
      let narg = List.length l_exp and lrev = List.rev l_exp in
      let evaluate_and_push exp =
        begin
          compile_expr out func env exp;
          push eax;
        end
      in
      List.iter evaluate_and_push lrev;
      (* call the function *)
      call (Global(s));
      (* free the arguments from the stack *)
      if narg <> 0 then add (Const(4 * narg)) esp;
    end
  | OP1 (op, exp) ->
    (* op is a unary operator applied to exp *)
    begin match op with
    | M_MINUS ->
      begin
        compile_expr out func env exp;
        neg eax;
      end
    | M_NOT ->
      begin 
        let yes_label = genlab func and end_label = genlab func in
        compile_expr out func env exp;
        cmp (Const(0)) eax;
        je (Global(yes_label));
        mov (Const(0)) eax;
        jmp (Global(end_label));
        print yes_label;
        mov (Const(1)) eax;
        print end_label;
      end
    | M_POST_INC ->
      begin match (snd exp) with
      | VAR s -> 
        begin
          let var = try Local(List.assoc s env) with Not_found -> Global(s)
          in
          mov var eax;
          inc var;
        end
      | _ -> failwith "Incompatible expression with \"++\" operator"
      end
    | M_POST_DEC ->
      begin match (snd exp) with
      | VAR s ->
        begin
          let var = try Local (List.assoc s env) with Not_found -> Global(s)
          in
          mov var eax;
          dec var;
        end
      | _ -> failwith "Incompatible expression with \"--\" operator"
      end
    | M_PRE_INC ->
      begin match (snd exp) with
      | VAR s ->
        begin
          let var = try Local (List.assoc s env) with Not_found -> Global(s)
          in
          inc var;
          mov var eax;
        end
      | _ -> failwith "Incompatible expression with \"++\" operator";
      end
    | M_PRE_DEC ->
      begin match (snd exp) with
      | VAR s ->
        begin
          let var = try Local (List.assoc s env) with Not_found -> Global(s)
          in
          dec var;
          mov var eax;
        end
      | _ -> failwith "Incompatible expression with \"--\" operator";
      end
    end
  | OP2 (op, e1, e2) ->
    (* op is an arithmetic binary operator applied to e1 and e2 *)
    begin match op with
    | S_MUL ->
      begin
        compile_expr out func env e1;
        push eax;
        compile_expr out func env e2;
        pop ebx;
        imul ebx eax;
      end
    | S_DIV ->
      begin
        compile_expr out func env e2;
        push eax;
        compile_expr out func env e1;
        pop ebx;
        cltd ();
        idiv ebx;
      end
    | S_MOD ->
      begin
        compile_expr out func env e2;
        push eax;
        compile_expr out func env e1;
        pop ebx;
        cltd ();
        idiv ebx;
        mov edx eax;
      end
    | S_ADD ->
      begin
        compile_expr out func env e1;
        push eax;
        compile_expr out func env e2;
        pop ebx;
        add ebx eax;
      end
    | S_SUB ->
      begin
        compile_expr out func env e2;
        push eax;
        compile_expr out func env e1;
        pop ebx;
        sub ebx eax;
      end
    | S_INDEX ->
      begin
        compile_expr out func env e1;
        push eax;
        compile_expr out func env e2;
        mov eax ecx;
        pop ebx;
        mov (Elem(EBX, ECX)) eax;
      end
    end
  | CMP (op, e1, e2) ->
    (* op is a comparison operator applied to e1 and e2 *)
    begin
      compile_expr out func env e2;
      push eax;
      compile_expr out func env e1;
      pop ebx;
      cmp ebx eax;
      let yes_label = genlab func and end_label = genlab func in
      begin match op with
      | C_LT -> jl (Global(yes_label))
      | C_LE -> jle (Global(yes_label))
      | C_EQ -> je (Global(yes_label))
      end;
      print "# no";
      mov (Const(0)) eax;
      jmp (Global(end_label));
      print "# yes";
      print yes_label;
      mov (Const(1)) eax;
      print "# end comparison";
      print end_label;
    end
  | EIF (e1, e2, e3) ->
    begin
      compile_expr out func env e1;
      print "# eif expression";
      let yes_label = genlab func and end_label = genlab func in
      cmp (Const(0)) eax;
      jne (Global(yes_label));
      print "# no";
      compile_expr out func env e3;
      jmp (Global(end_label));
      print "# yes";
      print yes_label;
      compile_expr out func env e2;
      print "# exit eif";
      print end_label;
    end
  | ESEQ l_exp -> List.iter (compile_expr out func env) l_exp;
  end

let rec compile_code out func env code =
(* type :: out_channel -> string -> (string * int) list ->   Cparse.var_declaration list -> unit *)
  let add = add_ out and sub = sub_ out and cmp = cmp_ out and jmp = jmp_ out         and jne = jne_ out and print = Printf.fprintf out "%s:\n" in
    
  begin match (snd code) with
  | CBLOCK (vars, blockcode) ->
    (* CBLOCK ~ { vars : variable declarations;
                 blockcode : sequence of instructions } *)
    begin
      (* allocate enough memory for all new local variables *)
      let nvar = List.length vars in
      if nvar <> 0 then sub (Const(4 * nvar)) esp;
      (* add the new variables to env *)
      let rec find_min_offset = function
      | [] -> 0
      | (_, offset) :: t -> min offset (find_min_offset t)
      in
      let min_offset = find_min_offset env in
      let rec add_vars acc i = function
      | [] -> acc
      | h :: t ->
        begin match h with
        | CDECL (_, s) ->  add_vars ((s, i - 4) :: acc) (i - 4) t
        | _ -> failwith "function declaration within a function"
        end
      in
      let new_env = add_vars env min_offset vars in
      (* compile the instructions *)
      List.iter (compile_code out func new_env) blockcode;
      (* free the local variables from the stack *)
      if nvar <> 0 then add (Const(4 * nvar)) esp;
    end
  | CEXPR expr -> compile_expr out func env expr;
  | CIF (expr, c1, c2) ->
    (* if (expr) c1; else c2; *)
    begin
      compile_expr out func env expr;
      cmp (Const(0)) eax;
      let yes_label = genlab func and end_label = genlab func in
      jne (Global(yes_label));
      print "# no";
      compile_code out func env c2;
      jmp (Global(end_label));
      print "# yes";
      print yes_label;
      compile_code out func env c1;
      print "# exit if";
      print end_label;
    end
  | CWHILE (expr, code) ->
    (* while (expr) code; *)
    begin
      let loop_label = genlab func and condition_label = genlab func in
      jmp (Global(condition_label));
      print "# loop iteration";
      print loop_label;
      compile_code out func env code;
      print "# condition";
      print condition_label;
      compile_expr out func env expr;
      cmp (Const(0)) eax;
      jne (Global(loop_label));
      print "# exit loop"
    end
  | CRETURN op ->
    begin
      begin match op with
      | Some exp -> compile_expr out func env exp
      | _ -> ()
      end;
      let epilogue = func ^ "_epilogue" in
      jmp (Global(epilogue)); (* label where the function epilogue is put *)
    end
  end

let compile out decl_list =
(* type :: out_channel -> Cparse.var_declaration list -> unit *)
  let mov = mov_ out and push = push_ out and leave = leave_ out and ret = ret_ out and print = Printf.fprintf out "%s:\n" and printn = Printf.fprintf out "%s\n" in 
  
  begin
    let rec get_var = function
    | [] -> []
    | h :: t ->
      match h with
      | CDECL (loc, str) -> (CDECL (loc, str)) :: (get_var t)
      | _ -> get_var t
    in
    let rec get_fun = function
    | [] -> []
    | h :: t -> 
      match h with
      | CFUN (loc, s, l, c) -> (CFUN (loc, s, l, c)) :: (get_fun t)
      | _ -> get_fun t
    in
    let var_list = get_var decl_list and fun_list = get_fun decl_list in
    (* compile global variable declarations *)
    if var_list = [] then () else begin
      printn "# global variables data segment";
      let compile_var = function
      | CDECL (_, name) -> 
        begin
          Printf.fprintf out "    .comm   %s, 4, 4\n" name;
        end
      | _ -> failwith "global variables declaration and functions mixed up"
      in
      List.iter compile_var var_list;
      printn "";
    end;
    (* compile functions *)
    if fun_list = [] then () else begin
      printn ".text";
      let compile_fun = function
      | CFUN (_, func, var_list, c) ->
        begin
          printn ("\n.globl " ^ func);
          printn ("    .type   " ^ func ^ ", @function");
          print func;
          (* function prologue *)
          print "# subroutine prologue";
          push ebp;
          mov esp ebp;
          (* function body *)
          print "# subroutine body";
          let rec find_args n acc l = match l with
          | [] -> acc
          | h :: t ->
            begin match h with
            | CDECL (_, s) -> find_args (n + 1) ((s, 4 * (n + 2)) :: acc) t
            | _ -> failwith "Invalid function arguments"
            end
          in
          let env = find_args 0 [] var_list in
          compile_code out func env c;
          print "# subroutine epilogue";
          print (func ^ "_epilogue");
          leave ();
          ret ();
        end
      | _ -> failwith "global variables declaration and functions mixed up"
      in
      List.iter compile_fun fun_list;
    end;
    (* compile string declarations *)
    if (!str_decl <> []) then print "\n# strings storage segment";
    let compile_str (str, label) = 
      begin
        print label;
        printn ("    .asciz  \"" ^ (String.escaped str) ^ "\"");
        printn "    .align  4";
      end
    in
    List.iter compile_str !str_decl;
  end
