:- dynamic like/2.
:- dynamic notlike/2.

retractList([]).
retractList([H|T]) :- retractall(like(_,H)), retractList(T).

insert(H,T,[H|T]).

nonmember(A,[]).
nonmember(A,[H|T]) :- A \= H, nonmember(A,T).

uniq([H|T], R) :- (nonmember(H,T) -> R=[H|T];R=T).

say([]) :- write('You should better go to learn some biology or chemistry.').
say([R]) :- write('The best choise for you will be \''), write(R),write('\' language.').
say([R|T]) :- write('The best choise for you will be one of the following languages: '), write([R|T]).

answer([]) :- findall(Next, like(_, Next), L), uniq(L, R), say(R);say([]).
ask(QL) :- findall(Q,(like(Q,_),nonmember(Q,QL)), [QHead|QTail]),
                question(QHead, Text),
                write(Text),
                insert(QHead,QL,NewQL),
                nl,
                readln([Response]),
                ( (Response == yes ; Response == y) -> 
                    findall(Next,like(QHead, Next), L),
                    findall(Next1,(like(_, Next1),nonmember(Next1, L)), Ruha),
                    retractList(Ruha);
                    
                    findall(Next,like(QHead, Next), L),
                    retractList(L)
                ),
                ask(NewQL);answer([]).

main :-
        nl,
        write('Choose action:\n'),
        write('1. select prograaming language according to your personality\n'),
        write('2. exit\n'),
        write('>>> '), 
        readln([X]),
        switch(X) ; main.
 
switch(1):- consult('base.pl'), ask([]), main.
 
switch(2):-     write('Bye.\n'), halt, halt.

init :- [library(http/dcg_basics),library(dialect/sicstus)], consult('base.pl'), main.