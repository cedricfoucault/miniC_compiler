#	Copyright (c) 2005 by Laboratoire Spécification et Vérification (LSV),
#	CNRS UMR 8643 & ENS Cachan.
#	Written by Jean Goubault-Larrecq.  Derived from the csur project.
#
#	Permission is granted to anyone to use this software for any
#	purpose on any computer system, and to redistribute it freely,
#	subject to the following restrictions:
#
#	1. Neither the author nor its employer is responsible for the consequences of use of
#		this software, no matter how awful, even if they arise
#		from defects in it.
#
#	2. The origin of this software must not be misrepresented, either
#		by explicit claim or by omission.
#
#	3. Altered versions must be plainly marked as such, and must not
#		be misrepresented as being the original software.
#
#	4. This software is restricted to non-commercial use only.  Commercial
#		use is subject to a specific license, obtainable from LSV.

%.cmx: %.ml
	ocamlopt -c $<

%.cmo: %.ml
	ocamlc -c -g $<

%.cmi: %.mli
	ocamlc -c $<

.PHONY: all projet.tgz

# Compilation parameters:
CAMLOBJS=error.cmo cparse.cmo  \
	 ctab.cmo clex.cmo verbose.cmo genlab.cmo compile.cmo \
         main.cmo
CAMLSRC=$(addsuffix .ml,$(basename $(CAMLOBJS)))
PJ=ProjetMiniC2
FILES=clex.ml clex.mll compile.mli cparse.ml ctab.ml ctab.mli ctab.mly\
	depend error.ml genlab.ml main.ml Makefile\
	verbose.ml top.ml

all: mcc

projet: projet.tgz

mcc: $(CAMLOBJS)
	ocamlc -custom -o mcc unix.cma -cclib -lunix $(CAMLOBJS)

clean:
	-rm mcc *.cmi *.cmo

cleanall: clean
	-rm ctab.ml ctab.mli clex.ml projet.tgz
	-rm -rf Test/
	-rm -rf ProjetMiniC2/

test: projet.tgz
	-mkdir Test
	-rm -rf Test/*
	cp projet.tgz Test/
	(cd Test/; tar -xvzf projet.tgz; cd ProjetMiniC2/; cp ~/Papers/compile.ml .; make; cp mcc ~/bin)

projet.tgz:
	-mkdir $(PJ)
	cp $(FILES) $(PJ)
	-mkdir $(PJ)/Exemples
	cp Exemples/*.c Exemples/*.s Exemples/exc? $(PJ)/Exemples
	tar -cvzf $@ $(PJ)

ctab.ml: ctab.mly
	ocamlyacc -v ctab.mly

clex.ml: clex.mll
	ocamllex clex.mll

compile.cmi: compile.mli
compile.cmo: compile.ml compile.cmi

depend: Makefile
	ocamldep *.mli *.ml >depend

include depend

