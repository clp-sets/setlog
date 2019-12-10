
%%%%%%%% ATTN per versione setlog483 commentare le replace_rule br4, br5, br6

% Version 1.2-12

%release 0 
% - aggiunte alcune inference rules per vincoli insiemistici
%release 1 
% - aggiunte replace rules per dom/comp e pfun
%release 2 
% - aggiunte replace rules per drespf
%release 3 
% - aggiunte replace rules per inv-dom e inv-ran
%release 4 
% - modificate replace rules per inv-dom e inv-ran
%release 5
% - aggiunte replace rule per 'un' su cp 
%release 6
% - aggiunta replace rule per 'subset' su cp 
%release 7 
% - aggiunta replace rule per comp(R,S,T) e pfun(R) & pfun(S)
%release 8 
% - eliminata replace rule per comp(R,S,T) e pfun(T)
% - aggiunto pfun(Q) a constraint generato da regola br5
%release 9
% - aggiunta inference rule su numeri interi per espressioni del tipo X is Y + k
%release 10
% - corretto bug in inference_rule 'un-disj'
%release 11
% - eliminate regole br7, br7bis, br8 e br8bis
%release 12
% -aggiunta replace_rule r4 per ttrattamento caso A neq B & set(A) & set(B) 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% User-defined "filtering" rules
% for {log} version 4.8.2-2 or newer
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%           by Maximiliano Cristia' and  Gianfranco Rossi
%                          April 2014
%
%                     Revised March 2017
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

filter_on.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% General rules %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%% equivalence rules 

% equiv_rule(A,B), with A, B {log} predicates: if the input goal contains B then  
% then B matches with both filtering rules for A and filtering rules for B (since B => A)

:- op(700,xfx,[ein,enin]).

equiv_rule(e2,inters(X,Y,Z),dinters(X,Y,Z)).     % e2. dinters(X,Y,Z) => inters(X,Y,Z)   
equiv_rule(e3,ssubset(X,Y),dssubset(X,Y)).       % e3. dssubset(X,Y) => ssubset(X,Y)   
equiv_rule(e4,nsubset(X,Y),dnsubset(X,Y)).       % e4. dnsubset(X,Y) => nsubset(X,Y)   
equiv_rule(e5,X in Y,X ein Y).                   % e5. X ein Y => X in Y   
equiv_rule(e6,X nin Y,X enin Y).                 % e6. X enin Y => X nin Y  

%TO BE COMPLETED: esubset, einters, ...


%%%%%%%%%%%%%%%%%%%%%%%% replace rules

% replace_rule(
%     W: when,
%     C: atomic constraint
%     C_Conds: list of conditions for C
%     D: list of other atomic constraints to be checked
%     D_Conds: list of conditions for atomic constraints in D and C
%     AddC: constraint to be replaced to C)
        
%%%%% general

% t = X -replace-> X = t
replace_rule(br3,T=X,[var(X),nonvar(T)],[],[],X=T).

%%%%% sets

% inters(X,{...},t3) -replace-> inters({...},X,t3)
replace_rule(r3,inters(X,T2,T3),[var(X),nonvar(T2)],[],[],inters(T2,X,T3)).

% A neq B & set(A) & set(B) -replace-> (X in A & X nin B or X nin A & X in B) 
replace_rule(r4,A neq B,[var(A),var(B)],[set(A1),set(B1)],[A1==A,B1==B],(X in A & X nin B or X nin A & X in B)).
%
% A neq {...} & set(A) -replace-> (X in A & X nin {...} or X nin A & X in {...}) 
replace_rule(r4,A neq B,[var(A),B=_ with _],[set(A1)],[A1==A],(X in A & X nin B or X nin A & X in B)).
%
% {...} neq B & set(B) -replace-> (X in B & X nin {...} or X nin B & X in {...}) 
replace_rule(r4,A neq B,[var(B),A=_ with _],[set(B1)],[B1==B],(X in A & X nin B or X nin A & X in B)).

%%%%% relations/partial functions    

% dom(Rel,Dom) & pfun(Rel) -replace-> dompf(Rel,Dom)  & pfun(Rel)   
replace_rule(br4,dom(Rel,Dom),[var(Rel)],[pfun(Rel1)],[Rel1==Rel],dompf(Rel,Dom)).

% comp(R,S,Q) & pfun(R) & pfun(S) -replace-> comppf(R,S,Q) & pfun(Q) & pfun(R) & pfun(S)
replace_rule(br5,comp(R,S,Q),[var(R),var(S)],[pfun(R1),pfun(S1)],[R1==R,S1==S],comppf(R,S,Q) & pfun(Q)).

% dres(A,R,S) & pfun(R) -replace-> drespf(A,R,S) & pfun(R)  
replace_rule(br6,dres(A,R,S),[var(R)],[pfun(R1)],[R1==R],drespf(A,R,S)).

% rel(R) & pfun(R) -replace-> pfun(R) & pfun(R)    
replace_rule(br7,rel(R),[var(R)],[pfun(R1)],[R1==R],pfun(R)).

% inv(R,S) & dom(S,A) -replace-> delay(inv(R,S) & dom(S,A),false) & ran(R,A)  
%replace_rule(br7,inv(R,S),[var(S)],[dom(S1,A)],[S==S1],delay(inv(R,S),false) & delay(dom(S,A),false) & ran(R,A)).
%replace_rule(br7bis,dom(S,A),[],[delay(dom(S1,A1),_)],[S==S1,A==A1],a=a).

% inv(R,S) & ran(R,A) -replace-> delay(inv(R,S) & ran(R,A),false) & dom(S,A)  
%replace_rule(br8,inv(R,S),[var(R)],[ran(R1,A)],[R==R1],delay(inv(R,S),false) & delay(ran(R,A),false) & dom(S,A)).
%replace_rule(br8bis,ran(R,A),[],[delay(ran(R1,A1),_)],[R1==R,A1==A],a=a).

%un(S,T,cp(A,A)) -replace-> delay(un(S,T,cp(A,A)),false)
%un(S,cp(C,D),cp(A,A)) -replace-> delay(un(S,cp(C,D),cp(A,A)),false)
replace_rule(br9,un(S,T,CP2),[var(S),var(T),nonvar(CP2),CP2=cp(A,B),var(A),A==B],
             [],[],G=un(S,T,CP2) & delay(G,false) ).
replace_rule(br9bis,un(S,CP1,CP2),[var(S),nonvar(CP1),CP1=cp(C,D),var(C),var(D),nonvar(CP2),CP2=cp(A,B),var(A),A==B],
             [],[],G=un(S,CP1,CP2) & delay(G,false) ).

%subset(S,cp(A,A)) -replace-> delay(subset(S,cp(A,A)),false)
replace_rule(br10,subset(S,CP2),[var(S),nonvar(CP2),CP2=cp(A,B),var(A),A==B],
              [],[],G=subset(S,CP2) & delay(G,false) ).


%%%%% integer numbers

% X < Y -replace-> Y > X
replace_rule(br1,X < Y,[var(X),var(Y)],[],[],Y > X).

% X =< Y -replace-> Y >= X
replace_rule(br2,X =< Y,[var(X),var(Y)],[],[],Y >= X).

%TO BE COMPLETED


%%%%%%%%%%%%%%%%%%%%%%%% inference rules

% inference_rule(
%     W: when,
%     C: atomic constraint
%     C_Conds: list of conditions for C
%     D: list of other atomic constraints to be checked
%     D_Conds: list of conditions for atomic constraints in D and C
%     E: list of constraints in D to be NOT checked
%     AddC: constraint to be added)
        
%%%%% sets

%inters(X,Y,Z) & un(X,Y,Z)  -+->   X = Y & Y = Z
inference_rule('inters-un1',inters(X,Y,Z),[var(X),var(Y),var(Z)],[un(X1,Y1,Z1)],[X1==X,Y1==Y,Z1==Z],[],X = Y & Y = Z).
%inters(X,Y,Z) & un(Y,X,Z)  -+->   X = Y & Y = Z
inference_rule('inters-un2',inters(X,Y,Z),[var(X),var(Y),var(Z)],[un(Y1,X1,Z1)],[X1==X,Y1==Y,Z1==Z],[],X = Y & Y = Z).

%inters(X,Y,Z) & diff(X,Y,Z)    -+->  X = {}
inference_rule('inters-diff1',inters(X,Y,Z),[var(X),var(Y),var(Z)],[diff(X1,Y1,Z1)],[X1==X,Y1==Y,Z1==Z],[],X = {}).
%inters(X,Y,Z) & diff(Y,X,Z)    -+->  Y = {}
inference_rule('inters-diff2',inters(X,Y,Z),[var(X),var(Y),var(Z)],[diff(Y1,X1,Z1)],[X1==X,Y1==Y,Z1==Z],[],Y = {}).

% un(X,Y,Z) & disj(X,Z) -add-> X = {}
inference_rule('un-disj',un(X,Y,Z),[var(X),var(Y),var(Z)],[disj(X1,Z1)],[X1==X,Z1==Z],[], X = {}).

%%%%% lists

% length(L,N) & length(L,M) -add-> N = M
inference_rule('length-length',length(L,N),[var(L)],[length(L1,M)],[L1==L],[length(L,N)], N = M).

%%%%% integer numbers

% X > Y & Y > Z -add-> X > Z
inference_rule('gt-gt',X > Y,[var(X),var(Y)],[Y1 > Z],[Y1==Y,Z\==X],[X > Y], X > Z).
        
% X >= Y & Y >= X -add-> X = Y
inference_rule('ge-ge',X >= Y,[var(X),var(Y)],[Y1 >= X1],[Y1==Y,X1==X],[], X = Y).

% X is A - B & A > 0 & B > 0 & X > 0 -add-> A > B
inference_rule('minus-gt0-gt0',X is A - B,[var(X),var(A),var(B)],[A1 > 0, B1 > 0, X1 > 0],[A1==A,B1==B,X1==X],[], A > B).

% X is Y + k & Z is Y + k -add-> X = Z
inference_rule('sum-sum',X is Y + K,[var(X),var(Y),integer(K)],[Z is Y1 + K1],[var(Z),var(Y1),integer(K1),Y1==Y,K1==K],[X is Y+K], X = Z).


%%%%%%%%%%%%%%%%%%%%%%%% fail rules

% fail_rule(
%     W: when,
%     C: atomic constraint
%     C_Conds: list of conditions for C
%     D: list of other atomic constraints to be checked
%     D_Conds: list of conditions for atomic constraints in D and C
%     E: list of constraints in D to be NOT checked)

%%%%% integer numbers

% bf1. X > Y & Y > X
fail_rule('gt-gt',X > Y,[],[V > W],[V==Y,W==X],[]).
% it works also for X > X

% bf2. X >= Y & Y > X 
fail_rule('ge-gt',X >= Y,[],[V > W],[V==Y,W==X],[]).

%%%%% sets

% bf3. X in S & X nin S 
fail_rule('in-nin',X in S,[var(S)],[X1 nin S1],[X1==X,S1==S],[]).

% bf4. NotSubsetOfSingleton
% A neq {} & ssubset(A,{X})            
fail_rule('NotSubsetOfSingleton',ssubset(A,S),[nonvar(S),S={} with _X],[A1 neq E],[nonvar(E),E={},A1==A],[]).

%%%%% intervals (terminating, provided all variables have "not too big" domains)

% bf5. NatRangeNotEmpty
% X is Z+k & Y is Z+h & I=int(X,Y) & I={}  and k =< h, k, h integer constants
fail_rule('NatRangeNotEmpty',I=int(X,Y),[var(X),var(Y)],[X1 is Expr1,Y1 is Expr2,I1=E],[nonvar(Expr1),Expr1=(Z+A),integer(A),nonvar(Expr2),Expr2=(Z1+B),integer(B),A=<B,nonvar(E),E={},X1==X,Y1==Y,Z1==Z,I1==I],[]).

% f21. NatRangeNotEq3
% I=int(X,Y) & J=int(a,b) & I=J & X is Z+N & Y is Z+M & N is V*h & M =< P & P is W*h & W is V+k  
% and a,b,h,k integer constants >= 0 and it holds that b-a > k*h
%
fail_rule('NatRangeNotEq3',I=int(X,Y),
                  [var(I),var(X),var(Y)],
                  [X1 is Z+N, Y1 is Z1+M, N is V*H, P >= M, P1 is W*H, W is V1+K, J=int(A,B), I1=J1],
                  [integer(A),A>=0,integer(B),B>=0,var(J),
                   var(I1),var(J1),var(X1),var(Y1),
                   var(N),integer(H),H>=0,
                   var(P),var(M),var(P1),
                   var(W),integer(K),K>=0, B-A > K*H,
                   I==I1,J==J1,X==X1,Y==Y1,Z==Z1,P==P1,V==V1],[]).

% f22. NatRangeNotSubset
% I=int(X,Y) & J=int(Kn,Km) & essubset(J,I) & X is N+Za & Y is N+Zb & Za is M*Kp & Zb is Zc*Kp & Zc is M+Kq
% with Km-Kn > Kq*Kp
%
fail_rule('NatRangeNotSubset',I=int(X,Y),
                  [var(I),var(X),var(Y)],
                  [X1 is N+Za, Y1 is N1+Zb, Za1 is M*Kp, Zb1 is Zc*Kp, Zc1 is M1+Kq, J=int(Kn,Km), essubset(J1,I1)],
                  [integer(Kn),Kn>=0,integer(Km),Km>=0,var(J),
                   var(I1),var(J1),var(X1),var(Y1),
                   var(N),var(M),var(Za),var(Zb),var(Zc),
                   var(N1),var(M1),var(Za1),var(Zb1),var(Zc1),
                   integer(Kq),Kq>=0,integer(Kp),Kq>=0,Km-Kn > Kq*Kp,
                   I==I1,J==J1,X==X1,Y==Y1,N==N1,M==M1,Za=Za1,Zb==Zb1,Zc==Zc1],[]).

% f23. NatRangeNotEq
% I=int(X,Y) & J=int(Kn,Km) & I=J & X is N+Za & Y is N+Zb & Za is M*Kp & Zb is Zc*Kp & Zc is M+Kq 
% with Km-Kn > Kq*Kp
%
fail_rule('NatRangeNotEq',I=int(X,Y),
                  [var(I),var(X),var(Y)],
                  [X1 is N+Za, Y1 is N1+Zb, Za1 is M*Kp, Zb1 is Zc*Kp, Zc1 is M1+Kq, J=int(Kn,Km), I1=J1],
                  [integer(Kn),Kn>=0,integer(Km),Km>=0,var(J),
                   var(I1),var(J1),var(X1),var(Y1),
                   var(N),var(M),var(Za),var(Zb),var(Zc),
                   var(N1),var(M1),var(Za1),var(Zb1),var(Zc1),
                   integer(Kq),Kq>=0,integer(Kp),Kq>=0,Km-Kn > Kq*Kp,
                   I==I1,J==J1,X==X1,Y==Y1,N==N1,M==M1,Za=Za1,Zb==Zb1,Zc==Zc1],[]).

% f24. NatRangeNotEmpty3
% I=int(X,Y) & I={} & X is N+Za & Y is N+Zb &  Za is M*Kn & Zb is Zc*Kn & Zc is M+Km
%
fail_rule('NatRangeNotEmpty3',I=int(X,Y),
                  [var(I),var(X),var(Y)],
                  [X1 is N+Za, Y1 is N1+Zb, Za1 is M*Kn, Zb1 is Zc*Kn, Zc1 is M1+Km, I1=E],
                  [nonvar(E),E={},
                   integer(Kn),Kn>=0,integer(Km),Km>=0,
                   var(I1),var(X1),var(Y1),
                   var(N),var(M),var(Za),var(Zb),var(Zc),
                   var(N1),var(M1),var(Za1),var(Zb1),var(Zc1),
                   I==I1,X==X1,Y==Y1,N==N1,M==M1,Za=Za1,Zb==Zb1,Zc==Zc1],[]).

% f25. NatRangeNotEmpty4
% I=int(N,Y) & I={} & Y is N+M
%
fail_rule('NatRangeNotEmpty4',I=int(N,Y),
                  [var(I),var(N),var(Y)],
                  [Y1 is N1+M, I1=E],
                  [nonvar(E),E={},var(I1),var(Y1),var(N),var(N1),var(M),I==I1,Y==Y1,N==N1],[]).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% More specific rules %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Add here other more specific user-defined rewriting rules

 
%%%%%%%%%%%%%%%%%%%%%%%% for the TTF
 
:- (exists_file('TTF_rules.pl'),!,consult('TTF_rules.pl') 
    ; 
    true).