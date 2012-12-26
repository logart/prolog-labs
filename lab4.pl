:- dynamic like/2.
:- dynamic notlike/2.
%% like('exotic', 'C').
%% like('exotic', 'D').
%% like('increment', 'C++').
%% like('increment', 'D').
%% like('OO', 'A').

%% question('exotic', 'Do you like exotic languages?').
%% question('increment', 'Do you like incrementing?').
%% question('OO', 'Do you like OOP?').


%% notlike(A,B) :- \+ like(A,B).

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
                %% write([QHead|QTail]),
                %% nl,
                %% write(QL),
                %% nl,
                write(Text),
                insert(QHead,QL,NewQL),
                nl,
                readln([Response]),
                ( (Response == yes ; Response == y) -> 
                    findall(Next,like(QHead, Next), L),
                    findall(Next1,(like(_, Next1),nonmember(Next1, L)), Ruha),
                    %% write(L),nl,
                    %% write(Ruha),nl,
                    retractList(Ruha);
                    
                    findall(Next,like(QHead, Next), L),
                    %% write(L),nl,
                    retractList(L)
                ),
                ask(NewQL);answer([]).

main :-
        nl,
        write('Choose action:\n'),
        write('1. save current state\n'),
        write('2. find element\n'),
        write('3. add element\n'),
        write('4. remove element\n'),
        write('5. exit\n'),
        write('>>> '), 
        readln([X]),
        switch(X) ; main.
 
switch(1):- qsave_program('lab2.out',[class(development),op(save),autoload(true),goal(init)]), main.
 
switch(2):- ask([]), main.
 
switch(3):- write('Type parent\'s name: '), read_line_pls(P),
                        write('Type child\'s name: '), read_line_pls(C),
                        assert(parent(P,C)), main.
 
switch(4):- write('Type element\'s name: '), read_line_pls(A), retractall(parent(A,_)),retractall(parent(_,A)), main.
       
switch(5):-     write('Bye.\n'), halt, halt.

init :- [library(http/dcg_basics),library(dialect/sicstus)], consult('base.pl'), main.