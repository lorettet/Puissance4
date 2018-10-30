%Tableau qui gère par colonnes le Puissance 4
% --> 7 Colonnes de 6 Lignes
initialiser([['_','_','_','_','_','_'],
	       ['_','_','_','_','_','_'],
	       ['_','_','_','_','_','_'],
	       ['_','_','_','_','_','_'],
	       ['_','_','_','_','_','_'],
	       ['_','_','_','_','_','_'],
		   ['_','_','_','_','_','_']]).

afficher(X):-afficherLigne(X,0).

%I = Ligne
afficherLigne(_,6).
afficherLigne(X,I):-afficherCellule(X,I,0), nl, I2 is I+1, afficherLigne(X,I2).

%I = Ligne // J = Colonne
afficherCellule(_,_,7).
afficherCellule(X,I,J):-nth0(J,X,A), nth0(I,A,B), write(B), write(' '),J2 is J+1, afficherCellule(X,I,J2).

lancer:- initialiser(X),afficher(X),!.

%%%%%% Verification win %%%%%%%
% winner si une colonne, un ligne ou une diagn=onal gagner
winner(B,P):- winnerVert(B,P),!.
winner(B,P):- winnerHor(_,_,B,P),!.
winner(B,P):- winnerDiagDes(_,_,B,P),!.
winner(B,P):- winnerDiagAsc(_,_,B,P),!.
winner(B,'Draw'):- fullBoard(B).

member(X, [X|_]).
member(X, [_|Q]):- member(X,Q).

% verifie si le board est plein
fullBoard([]).
fullBoard([T|Q]):- not(member('_',T)), fullBoard(Q).

% test chaque diagonal descendente
winnerDiagDes(ColNum,LigNum,Board,P):-  getDiagDes(Board,ColNum,LigNum,A,B,C,D),valAllEquals(A,B,C,D,P).

% A,B,C,D sont les 4 elems de la diagonal descendente commencant à ColNum, Lignum (point suppérieur gauche)
getDiagDes(Board,ColNum,LigNum,A,B,C,D) :- nth0(ColNum,Board,Col),nth0(LigNum,Col,A),
    										ColNum2 is ColNum+1, LigNum2 is LigNum+1, nth0(ColNum2,Board,Col2), nth0(LigNum2,Col2,B),
    										ColNum3 is ColNum2+1, LigNum3 is LigNum2+1, nth0(ColNum3,Board,Col3), nth0(LigNum3,Col3,C),
    										ColNum4 is ColNum3+1, LigNum4 is LigNum3+1, nth0(ColNum4,Board,Col4), nth0(LigNum4,Col4,D).

% test chaque diagonal ascendente
winnerDiagAsc(ColNum,LigNum,Board,P):- getDiagAsc(Board,ColNum,LigNum,A,B,C,D),valAllEquals(A,B,C,D,P).

% A,B,C,D sont les 4 elems de la diagonal ascendente commencant à ColNum, Lignum4 (point inférieur gauche)
getDiagAsc(Board,ColNum,LigNum4,A,B,C,D) :- nth0(ColNum,Board,Col),nth0(LigNum4,Col,A),
    										ColNum2 is ColNum+1, LigNum3 is LigNum4-1, nth0(ColNum2,Board,Col2), nth0(LigNum3,Col2,B),
    										ColNum3 is ColNum2+1, LigNum2 is LigNum3-1, nth0(ColNum3,Board,Col3), nth0(LigNum2,Col3,C),
    										ColNum4 is ColNum3+1, LigNum1 is LigNum2-1, nth0(ColNum4,Board,Col4), nth0(LigNum1,Col4,D).

% Verifie si les 4 element sont égaux
valAllEquals(A,B,C,D,P) :- A\=='_', A=P,A=B,B=C,C=D.

% test chaque ligne
winnerHor(ColNum,LigNum,Board,P) :- getHor(Board,ColNum,LigNum,A,B,C,D), valAllEquals(A,B,C,D,P),!.

% recupère les 4 jetons d'un ligne LigNum, commençant colonne ColNum
getHor(Board,ColNum,LigNum,A,B,C,D):-nth0(ColNum,Board,Col),nth0(LigNum,Col,A),
    										ColNum2 is ColNum+1, nth0(ColNum2,Board,Col2), nth0(LigNum,Col2,B),
    										ColNum3 is ColNum2+1, nth0(ColNum3,Board,Col3), nth0(LigNum,Col3,C),
    										ColNum4 is ColNum3+1, nth0(ColNum4,Board,Col4), nth0(LigNum,Col4,D).
    
% test chaque colonne
winnerVert([T|_],P):-vertwins(T,P).
winnerVert([_|Q],P):-winnerVert(Q,P).

% Conditions de réussite sur une colonne
vertwins(C,P):- C=[_,_,P,P,P,P], P \== '_'.
vertwins(C,P):- C=[_,P,P,P,P,_], P \== '_'.
vertwins(C,P):- C=[P,P,P,P,_,_], P \== '_'.

move(Board,NumC,NewBoard,Player):- nth0(NumC,Board,Colonne), getLineNumber(Colonne,0,I), I\=='-1', changeElem(Colonne, Player, I, NewColonne) , changeElem(Board, NewColonne, NumC, NewBoard).

changeElem([_|Q], Val, 0, [Val|Q]).
changeElem([H|Q1],Val,Index,[H|Q2]):- IndexI is Index-1, changeElem(Q1,Val,IndexI,Q2),!.

getLineNumber(['_'],FirstIndex,Index):- Index is FirstIndex, !. 
getLineNumber([X|_],FirstIndex,Index):- X\=='_', Index is FirstIndex-1, !.  
getLineNumber(['_'|Q],FirstIndex, Index):- IndexI is FirstIndex+1 , getLineNumber(Q,IndexI,Index).

outputWinner(P):-nl,write('Le joueur '),write(P),write(' gagne!').

endOfGame(B):-winner(B,'Draw'),write("Egalité!").
endOfGame(B):-winner(B,P),outputWinner(P).

%%%% IA Randoms VS IA Random %%%%
% IA 1 joue et donne la main à IA 2
playIARandVSIA2Rand(B):- endOfGame(B),!.
playIARandVSIA2Rand(B):- iaRandom(B,M),move(B,M,NewB,'x'),nl,afficher(NewB),playIA2RandVSIARand(NewB).
% IA 2 joue et donne la main ) IA 1
playIA2RandVSIARand(B):- endOfGame(B),!.
playIA2RandVSIARand(B):- iaRandom(B,Move),move(B,Move,NewB,'o'),nl,afficher(NewB),playIARandVSIA2Rand(NewB).

playIARandVSIARand:- initialiser(B),playIARandVSIA2Rand(B).

%%%% Joueur vs Joueur %%%
playPlayerVSPlayer(B,_,_):-winner(B,P),outputWinner(P),!.
playPlayerVSPlayer(B,P,P2):-player(B,Move), move(B,Move,NewB,P),nl,afficher(NewB),playPlayerVSPlayer(NewB,P2,P).

% lance une partie pvp
playPvP:-initialiser(B),playPlayerVSPlayer(B,'x','o').

%%%% Joueur vs IA Random %%%%
player(B,M):-read(M),moves(L,B),member(M,L),!.
player(B,M):-nl,write('Move impossible, play again'),player(B,M).

% donne un move aléatoire parmis les moves possibles
iaRandom(B,M):- moves(L,B), random_member(M,L).

% joue le tour du joueur et donne la main à l ia
playPlayerVSIARandom(B):-endOfGame(B).
playPlayerVSIARandom(B):- player(B,M),move(B,M,NewB,'x'),nl,afficher(NewB),playIARandomVSPlayer(NewB).
% joue le tour de l'ia et donne la main au joueur
playIARandomVSPlayer(B):- endOfGame(B).
playIARandomVSPlayer(B):- iaRandom(B,Move),move(B,Move,NewB,'o'),nl,afficher(NewB),playPlayerVSIARandom(NewB).

% lance une partie player vs ia random
playPvIARa:-initialiser(B),playPlayerVSIARandom(B).

% Better IA (TODO maxmin)
% On travaille sur des Record=[Move,Value]. Si NewValue > OldValue, alors on renvoie le nouveau record, sinon on renvoi l'ancien
update(_,NewValue,[OldMove,OldValue],[OldMove,OldValue]):-NewValue=<OldValue,!.
update(NewMove,NewValue,[_,OldValue],[NewMove,NewValue]):-NewValue>OldValue.

%TODO almost done, man maxmin
evaluateAndChoose(_,[],_,_,_,Record,Record).
evaluateAndChoose(Player,[Move|Moves],Board,D,MaxMin,Record,Best):-	
    move(Board,Move,Newboard,Player),
    %minmax(D,NewBoard,MaxMin,MoveX,Value),
    random(0,13,Value), % a retiré lorsquon mettera minmax
    update(Move,Value,Record,Record1),
    evaluateAndChoose(Player,Moves,Board,D,MaxMin,Record1,Best).

% renvoieun move garce à evaluate and choose
betterIA(B,M,Player):-moves(Moves,B),evaluateAndChoose(Player,Moves,B,4,1,[0,0],[M,_]).

% Better IA joue et renvoie la main a IA Random
playBetterIAVSIARand(B):-winner(B,P),outputWinner(P),!.
playBetterIAVSIARand(B):- betterIA(B,M,'x'),move(B,M,NewB,'x'),nl,afficher(NewB),playIARandVSBetterIA(NewB).
% IA Random joue et donne la main à Better IA
playIARandVSBetterIA(B):- winner(B,P),outputWinner(P),!.
playIARandVSBetterIA(B):- iaRandom(B,Move),move(B,Move,NewB,'o'),nl,afficher(NewB),playBetterIAVSIARand(NewB).

% lance une partie entre betterIA et IA Random
playBetIAVSIARa:- initialiser(B),playBetterIAVSIARand(B).


% Liste qui va stocker les numeros de colonne où le joueur peut jouer
possibleMove(NumC,B) :- nth0(NumC,B,Col),not(pleine(Col)).
moves(L,B) :- setof(X,possibleMove(X,B),L).

% evalue si une colonne est plein ou non
pleine([]).
pleine([T|Q]):-T\=='_',pleine(Q).

vert3(B,Player,Id, NumCol,NumL):- nth0(NumCol,B,Col), nth0(NumL,Col,Head),Head==Player,
                                        NumL0 is NumL-1, nth0(NumL0,Col,X0),X0=='_',
    									NumL1 is NumL+1, nth0(NumL1,Col,X1),X1==Player,
                                        NumL2 is NumL1+1, nth0(NumL2,Col,X2),X2==Player,
                                        (NumL2==5;(NumL3 is NumL2+1, nth0(NumL3,Col,X3),X3\==Player)),
                                        Id is 100+NumCol*10+NumL.

vert2(B,Player,Id, NumCol,NumL):- nth0(NumCol,B,Col), nth0(NumL,Col,Head),Head==Player,
                                        NumL0 is NumL-1, nth0(NumL0,Col,X0),X0=='_',
    									NumL1 is NumL+1, nth0(NumL1,Col,X1),X1==Player,
                                        (NumL1==5;(NumL2 is NumL1+1, nth0(NumL2,Col,X2),X2\==Player)),
                                        Id is 100+NumCol*10+NumL.

hor3Left(B,Player,Id,NumCol,NumL):- nth0(NumCol,B,Col), nth0(NumL,Col,Head),Head==Player,
                NumCol0 is NumCol-1, nth0(NumCol0,B,Col0), nth0(NumL,Col0,X0),X0=='_',
    			NumCol1 is NumCol+1, nth0(NumCol1,B,Col1), nth0(NumL,Col1,X1),X1==Player,
                NumCol2 is NumCol1+1, nth0(NumCol2,B,Col2), nth0(NumL,Col2,X2),X2==Player,
                (NumCol2==6;(NumCol3 is NumCol2+1, nth0(NumCol3,B,Col3), nth0(NumL,Col3,X3),X3\==Player)),
                Id is 200+NumCol*10+NumL.

hor3Right(B,Player,Id,NumCol,NumL):- nth0(NumCol,B,Col), nth0(NumL,Col,Head),Head==Player,
                (NumCol==0;(NumCol0 is NumCol-1, nth0(NumCol0,B,Col0), nth0(NumL,Col0,X0),X0\==Player)),
    			NumCol1 is NumCol+1, nth0(NumCol1,B,Col1), nth0(NumL,Col1,X1),X1==Player,
                NumCol2 is NumCol1+1, nth0(NumCol2,B,Col2), nth0(NumL,Col2,X2),X2==Player,
                (NumCol3 is NumCol2+1, nth0(NumCol3,B,Col3), nth0(NumL,Col3,X3),X3=='_'),
                Id is 200+NumCol*10+NumL.

hor2Left(B,Player,Id,NumCol,NumL):- nth0(NumCol,B,Col), nth0(NumL,Col,Head),Head==Player,
                NumCol0 is NumCol-1, nth0(NumCol0,B,Col0), nth0(NumL,Col0,X0),X0=='_',
    			NumCol1 is NumCol+1, nth0(NumCol1,B,Col1), nth0(NumL,Col1,X1),X1==Player,
                (NumCol1==6;(NumCol2 is NumCol1+1, nth0(NumCol2,B,Col2), nth0(NumL,Col2,X2),X2\==Player)),
                Id is 200+NumCol*10+NumL.

hor2Right(B,Player,Id,NumCol,NumL):- nth0(NumCol,B,Col), nth0(NumL,Col,Head),Head==Player,
                (NumCol==0;(NumCol0 is NumCol-1, nth0(NumCol0,B,Col0), nth0(NumL,Col0,X0),X0\==Player)),
    			NumCol1 is NumCol+1, nth0(NumCol1,B,Col1), nth0(NumL,Col1,X1),X1==Player,
                NumCol2 is NumCol1+1, nth0(NumCol2,B,Col2), nth0(NumL,Col2,X2),X2=='_',
                Id is 200+NumCol*10+NumL.

%Attention aux doublons !!!
diagDesc3Left(B,Player,Id,NumCol,NumL):- nth0(NumCol,B,Col), nth0(NumL,Col,Head),Head==Player,
               NumCol0 is NumCol-1, NumL0 is NumL-1, nth0(NumCol0,B,Col0), nth0(NumL0,Col0,X0),X0=='_',
    			NumCol1 is NumCol+1, NumL1 is NumL+1, nth0(NumCol1,B,Col1), nth0(NumL1,Col1,X1),X1==Player,
                NumCol2 is NumCol1+1, NumL2 is NumL1+1, nth0(NumCol2,B,Col2), nth0(NumL2,Col2,X2),X2==Player,
                ((NumCol2==6); (NumL2==5);(NumCol3 is NumCol2+1, NumL3 is NumL2+1, nth0(NumCol3,B,Col3), nth0(NumL3,Col3,X3),X3\==Player)),
                Id is 300+NumCol*10+NumL.

diagDesc3Right(B,Player,Id,NumCol,NumL):- nth0(NumCol,B,Col), nth0(NumL,Col,Head),Head==Player,
                ((NumCol==0); (NumL==0);(NumCol0 is NumCol-1, NumL0 is NumL-1, nth0(NumCol0,B,Col0), nth0(NumL0,Col0,X0),X0\==Player)),
    			NumCol1 is NumCol+1, NumL1 is NumL+1, nth0(NumCol1,B,Col1), nth0(NumL1,Col1,X1),X1==Player,
                NumCol2 is NumCol1+1, NumL2 is NumL1+1, nth0(NumCol2,B,Col2), nth0(NumL2,Col2,X2),X2==Player,
                NumCol3 is NumCol2+1, NumL3 is NumL2+1, nth0(NumCol3,B,Col3), nth0(NumL3,Col3,X3),X3=='_',
                Id is 300+NumCol*10+NumL.

diagDesc2Left(B,Player,Id,NumCol,NumL):- nth0(NumCol,B,Col), nth0(NumL,Col,Head),Head==Player,
                NumCol0 is NumCol-1, NumL0 is NumL-1, nth0(NumCol0,B,Col0), nth0(NumL0,Col0,X0),X0=='_',
    			NumCol1 is NumCol+1, NumL1 is NumL+1, nth0(NumCol1,B,Col1), nth0(NumL1,Col1,X1),X1==Player,
                ((NumCol1==6); (NumL1==5);(NumCol2 is NumCol1+1, NumL2 is NumL1+1, nth0(NumCol2,B,Col2), nth0(NumL2,Col2,X2),X2\==Player)),
                Id is 300+NumCol*10+NumL.

diagDesc2Right(B,Player,Id,NumCol,NumL):- nth0(NumCol,B,Col), nth0(NumL,Col,Head),Head==Player,
                ((NumCol==0); (NumL==0);(NumCol0 is NumCol-1, NumL0 is NumL-1, nth0(NumCol0,B,Col0), nth0(NumL0,Col0,X0),X0\==Player)),
    			NumCol1 is NumCol+1, NumL1 is NumL+1, nth0(NumCol1,B,Col1), nth0(NumL1,Col1,X1),X1==Player,
                NumCol2 is NumCol1+1, NumL2 is NumL1+1, nth0(NumCol2,B,Col2), nth0(NumL2,Col2,X2),X2=='_',
                Id is 300+NumCol*10+NumL.

diagMont3Left(B,Player,Id,NumCol,NumL):- nth0(NumCol,B,Col), nth0(NumL,Col,Head),Head==Player,
                NumCol0 is NumCol-1, NumL0 is NumL+1, nth0(NumCol0,B,Col0), nth0(NumL0,Col0,X0),X0=='_',
    			NumCol1 is NumCol+1, NumL1 is NumL-1, nth0(NumCol1,B,Col1), nth0(NumL1,Col1,X1),X1==Player,
                NumCol2 is NumCol1+1, NumL2 is NumL1-1, nth0(NumCol2,B,Col2), nth0(NumL2,Col2,X2),X2==Player,
                ((NumCol2==6); (NumL2==0);(NumCol3 is NumCol2+1, NumL3 is NumL2-1, nth0(NumCol3,B,Col3), nth0(NumL3,Col3,X3),X3\==Player)),
                Id is 400+NumCol*10+NumL.

diagMont3Right(B,Player,Id,NumCol,NumL):- nth0(NumCol,B,Col), nth0(NumL,Col,Head),Head==Player,
                ((NumCol==0); (NumL==5);(NumCol0 is NumCol-1, NumL0 is NumL+1, nth0(NumCol0,B,Col0), nth0(NumL0,Col0,X0),X0\==Player)),
    			NumCol1 is NumCol+1, NumL1 is NumL-1, nth0(NumCol1,B,Col1), nth0(NumL1,Col1,X1),X1==Player,
                NumCol2 is NumCol1+1, NumL2 is NumL1-1, nth0(NumCol2,B,Col2), nth0(NumL2,Col2,X2),X2==Player,
                NumCol3 is NumCol2+1, NumL3 is NumL2-1, nth0(NumCol3,B,Col3), nth0(NumL3,Col3,X3),X3=='_',
                Id is 400+NumCol*10+NumL.

diagMont2Left(B,Player,Id,NumCol,NumL):- nth0(NumCol,B,Col), nth0(NumL,Col,Head),Head==Player,
                NumCol0 is NumCol-1, NumL0 is NumL+1, nth0(NumCol0,B,Col0), nth0(NumL0,Col0,X0),X0=='_',
    			NumCol1 is NumCol+1, NumL1 is NumL-1, nth0(NumCol1,B,Col1), nth0(NumL1,Col1,X1),X1==Player,
                ((NumCol1==6); (NumL1==0);(NumCol2 is NumCol1+1, NumL2 is NumL1-1, nth0(NumCol2,B,Col2), nth0(NumL2,Col2,X2),X2\==Player)),
                Id is 400+NumCol*10+NumL.

diagMont2Right(B,Player,Id,NumCol,NumL):- nth0(NumCol,B,Col), nth0(NumL,Col,Head),Head==Player,
                ((NumCol==0); (NumL==5);(NumCol0 is NumCol-1, NumL0 is NumL+1, nth0(NumCol0,B,Col0), nth0(NumL0,Col0,X0),X0\==Player)),
    			NumCol1 is NumCol+1, NumL1 is NumL-1, nth0(NumCol1,B,Col1), nth0(NumL1,Col1,X1),X1==Player,
                NumCol2 is NumCol1+1, NumL2 is NumL1-1, nth0(NumCol2,B,Col2), nth0(NumL2,Col2,X2),X2=='_',
                Id is 400+NumCol*10+NumL.

% Série de 1 jeton avec 1 posibilité à droite
any1_right(B,Player,Id,NumCol,NumL) :- NumL\==5,nth0(NumCol,B,Col), nth0(NumL,Col,Head), Head==Player,
        (NumCol==6;(NumC0 is NumCol+1, nth0(NumC0,B,Col0),nth0(NumL,Col0,Down), Down\==Player)),
        NumL0 is NumL+1,nth0(NumL0,Col,Right),Right=='_',
        Id is 500+NumCol*10+NumL.
	
% Série de 1 jeton avec 1 posibilité à gauche
any1_left(B,Player,Id,NumCol,NumL) :- NumL\==0,nth0(NumCol,B,Col), nth0(NumL,Col,Head), Head==Player,
        (NumCol==6;(NumC0 is NumCol+1, nth0(NumC0,B,Col0),nth0(NumL,Col0,Down), Down\==Player)),
    	 NumL1 is NumL-1,nth0(NumL1,Col,Left), Left=='_',
        Id is 600+NumCol*10+NumL.
	
% Série de 1 jeton avec 1 posibilité à droite en haut
any1_upRight(B,Player,Id,NumCol,NumL) :- NumL\==5,nth0(NumCol,B,Col), nth0(NumL,Col,Head), Head==Player,
        (NumCol==6;(NumC0 is NumCol+1, nth0(NumC0,B,Col0),nth0(NumL,Col0,Down), Down\==Player)),
        NumL0 is NumL+1, NumC1 is NumCol-1, nth0(NumC1,B,Col1), nth0(NumL0,Col1, UpRight), UpRight=='_',
        ((NumCol==6);(NumL==0);(NumL1 is NumL-1, NumC2 is NumCol+1, nth0(NumC2,B,Col2), nth0(NumL1,Col2, DownLeft), DownLeft\==Player)),
    	Id is 700+NumCol*10+NumL.
	
% Série de 1 jeton avec 1 posibilité à gauche en haut
any1_upLeft(B,Player,Id,NumCol,NumL) :- NumL\==0,nth0(NumCol,B,Col), nth0(NumL,Col,Head), Head==Player,
        (NumCol==6;(NumC0 is NumCol+1, nth0(NumC0,B,Col0),nth0(NumL,Col0,Down), Down\==Player)),
        NumL0 is NumL-1, NumC1 is NumCol-1, nth0(NumC1,B,Col1), nth0(NumL0,Col1, UpLeft), UpLeft=='_',
        ((NumCol==6);(NumL==5);(NumL1 is NumL+1, NumC2 is NumCol+1, nth0(NumC2,B,Col2), nth0(NumL1,Col2, DownRight), DownRight\==Player)),
    	Id is 800+NumCol*10+NumL.
	
% Série de 1 jeton avec 1 posibilité à droite en bas
any1_downRight(B,Player,Id,NumCol,NumL) :- numL\==5,nth0(NumCol,B,Col), nth0(NumL,Col,Head), Head==Player,
        (NumCol==6;(NumC0 is NumCol+1, nth0(NumC0,B,Col0),nth0(NumL,Col0,Down), Down\==Player)),
    	(NumL1==5;(NumL1 is NumL+1, nth0(NumL1,Col0, DownRight), DownRight=='_')),
    	Id is 900+NumCol*10+NumL.
	
% Série de 1 jeton avec 1 posibilité à gauche en bas
any1_downLeft(B,Player,Id,NumCol,NumL) :- numL\==0,nth0(NumCol,B,Col), nth0(NumL,Col,Head), Head==Player,
        (NumCol==6;(NumC0 is NumCol+1, nth0(NumC0,B,Col0),nth0(NumL,Col0,Down), Down\==Player)),
    	NumL1 is NumL-1, nth0(NumL1,Col0, DownLeft), DownLeft=='_',
    	Id is 1000+NumCol*10+NumL.
	
% Série de 1 jeton avec 1 posibilité en haut
any1_up(B,Player,Id,NumCol,NumL) :- nth0(NumCol,B,Col), nth0(NumL,Col,Head), Head==Player,
        (NumCol==6;(NumC0 is NumCol+1, nth0(NumC0,B,Col0),nth0(NumL,Col0,Down), Down\==Player)),
    	NumC1 is NumCol-1, nth0(NumC1,B,Col1),nth0(NumL,Col1,Up), Up=='_',
    	Id is 1100+NumCol*10+NumL.

group3(B,Player,Id):- vert3(B,Player,Id,,).
group3(B,Player,Id):- hor3Left(B,Player,Id,,).
group3(B,Player,Id):- hor3Right(B,Player,Id,,).
group3(B,Player,Id):- diagDesc3Left(B,Player,Id,,).
group3(B,Player,Id):- diagDesc3Right(B,Player,Id,,).
group3(B,Player,Id):- diagMont3Left(B,Player,Id,,).
group3(B,Player,Id):- diagMont3Right(B,Player,Id,,).

countGroup3(B,Player,Nb) :- setof(X,group3(B,Player,X),L), length(L,Nb).

group2(B,Player,Id):- vert2(B,Player,Id,,).
group2(B,Player,Id):- hor2Left(B,Player,Id,,).
group2(B,Player,Id):- hor2Right(B,Player,Id,,).
group2(B,Player,Id):- diagDesc2Left(B,Player,Id,,).
group2(B,Player,Id):- diagDesc2Right(B,Player,Id,,).
group2(B,Player,Id):- diagMont2Left(B,Player,Id,,).
group2(B,Player,Id):- diagMont2Right(B,Player,Id,,).

countGroup2(B,Player,Nb) :- setof(X,group2(B,Player,X),L), length(L,Nb).

group1(B,Player,Id):- any1_right(B,Player,Id,,).
group1(B,Player,Id):- any1_left(B,Player,Id,,).
group1(B,Player,Id):- any1_upRight(B,Player,Id,,).
group1(B,Player,Id):- any1_upLeft(B,Player,Id,,).
group1(B,Player,Id):- any1_downRight(B,Player,Id,,).
group1(B,Player,Id):- any1_downLeft(B,Player,Id,,).
group1(B,Player,Id):- any1_up(B,Player,Id,,).

countGroup1(B,Player,Nb) :- setof(X,group1(B,Player,X),L), length(L,Nb).

value1(B,Player,Value) :- countGroup3(B,Player,NbGroup3), countGroup2(B,Player,NbGroup2), Value is NbGroup31000+NbGroup210.

% Verifie si on prochain coup peut etre gagnant, renvoie false sinon
winMove(_, _, [], _):-false.
winMove(Player, Board, [Move|_], Move):- move(Board,Move,NewB,Player),winner(NewB,Player),!.
winMove(Player, Board, [_|Moves], WinMove):- winMove(Player,Board,Moves,WinMove).

