average(Grades,Weights, Grade) :-
  average(Grades,Weights,0,0,Grade).

average([],_,SumGrades,SumWeights,Grade) :- Grade is SumGrades / SumWeights.
average([P|Ps], [W|Ws], SumGrades, SumWeights, Grade) :-
  NewSumGrades is SumGrades + (P*W),
  NewSumWeights is SumWeights + W,
  average(Ps,Ws,NewSumGrades,NewSumWeights,Grade).

get_weights([W1, W2, W3, W4]) :-
  weight(1,W1),
  weight(2,W2),
  weight(3,W3),
  weight(4,W4).

check_status(row(_,P1,P2,P3,P4,_), Average, "Aprovado") :- 
  get_weights(Ws),
  average([P1,P2,P3,P4], Ws, Average),
  Average >= 7.0.

check_status(row(_,P1,P2,P3,P4,PF), Grade, "Aprovado") :- 
  get_weights(Ws),
  average([P1,P2,P3,P4], Ws, PN),
  PN >= 4,
  Grade is (PN + PF) / 2,
  Grade >= 5.0.

check_status(row(_,P1,P2,P3,P4,PF), Grade, "Reprovado") :- 
  get_weights(Ws),
  average([P1,P2,P3,P4], Ws, PN),
  PN >= 4,
  Grade is (PN + PF) / 2.

check_status(row(_,P1,P2,P3,P4,_), Grade, "Reprovado") :- 
  get_weights(Ws),
  average([P1,P2,P3,P4], Ws, Grade).

check_approved(X) :-
  check_status(X,Grade,Status), print_status(X,Grade,Status).

print_status(row(Name,_,_,_,_,_), Grade,Status) :- 
  nl,
  print(Name),
  print(Grade),
  print(Status).

read_weight(P,W) :-
  write("Qual e o peso da prova "),
  write(P),
  write(" ? "),
  read(W).

read_file(File) :-
  write("Digite nome do arquivo csv entre aspas duplas: "),
  read(File).
  
main :- 
  read_file(File),
  csv_read_file(File, [_|T]),
  retractall(weight(_,_)),
  read_weight(1,W1), assert(weight(1,W1)),
  read_weight(2,W2), assert(weight(2,W2)),
  read_weight(3,W3), assert(weight(3,W3)),
  read_weight(4,W4), assert(weight(4,W4)),
  maplist(check_approved, T).
