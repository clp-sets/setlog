
:- use_module(library(lists)).
:- if(current_prolog_flag(dialect, swi)).
	:- use_module(library(dialect/sicstus/timeout)).
:- elif(current_prolog_flag(dialect, sicstus)).
	:- use_module(library(timeout)).
:- endif.
:- use_module(library(clpfd)).
:- use_module(library(clpq)).

:- op(970,xfy,or).
:- op(950,xfy,&).
:- op(900,fy,[neg,naf]).
:- op(800,xf,!).
:- op(700,xfx,[in,neq,nin]).
:- op(670,xfx,\).
:- op(650,yfx,[with,mwith]).
:- op(150,fx,*).

:- initialization((
	logtalk_load(os(loader)),
	logtalk_load(setlog)
)).

:- if(current_prolog_flag(dialect, sicstus)).
	exists_file(File) :-
		os::file_exists(File).
:- endif.
