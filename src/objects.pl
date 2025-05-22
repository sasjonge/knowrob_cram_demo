:- use_module(library('semweb'), [ sw_register_computable/1,
                                   sw_register_prefix/2 ]).

% register the 'lpn' namespace and the computable relation defined in this file.
:- sw_register_prefix(lpn, 'http://knowrob.org/kb/lpn#').
:- sw_register_computable(lpn:jealous).

% define lpn:jealous as a computable predicate.
% @see https://lpn.swi-prolog.org/lpnpage.php?pagetype=html&pageid=lpn-htmlse1
lpn:jealous(X,Y) :-
	rdf_has(X, lpn:loves, Z),
	rdf_has(Y, lpn:loves, Z),
	X \== Y.
