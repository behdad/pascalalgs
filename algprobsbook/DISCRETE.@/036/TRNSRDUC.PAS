{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 16384,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
September '1999
Problem 36  O(N3) StronglyConnectedComponents Method
}
program
  TransitiveReduction;

const
  MaxN = 100;

var
  N, E : Integer;
  A, B, C : array [0 .. MaxN, 0 .. MaxN] of Integer;
  M : array [1 .. MaxN] of Boolean;
  Map, Comp : array [1 .. MaxN] of Integer;
  I, J, K, D, Time, X, Y : Integer;
  F : Text;

procedure ReadInput;
begin
  Assign(F, 'input.txt');
  Reset(F);
  Readln(F, N, E);
  for I := 1 to E do
  begin
    Readln(F, X, Y); A[X, Y] := 1;
  end;
  Close(F);
end;

procedure Dfs1 (V : Integer);
var
  I : Integer;
begin
  M[V] := True;
  for I := 1 to N do
    if (A[V, I] = 1) and not M[I] then
      Dfs1(I);
  Inc(Time);
  Map[N + 1 - Time] := V;
end;

procedure Dfs2 (V : Integer);
var
  I : Integer;
begin
  Inc(B[B[0, 0], 0]);
  B[B[0, 0], B[B[0, 0], 0]] := V;
  M[V] := True;
  for I := 1 to N do
    if (A[I, V] = 1) and not M[I] then
      Dfs2(I);
end;

procedure StConnected;
begin
  for I := 1 to N do
    if not M[I] then
      Dfs1(I);

  FillChar(M, SizeOf(M), 0);
  for I := 1 to N do
    if not M[Map[I]] then
    begin
      Inc(B[0, 0]);
      Dfs2(Map[I]);
    end;
end;

procedure MakeDag;
begin
  E := 0;
  for I := 1 to B[0, 0] do
    for J := 1 to B[I, 0] do
      Comp[B[I, J]] := I;
  for I := 1 to N do
    for J := 1 to N do
      if A[I, J] = 1 then
        C[Comp[I], Comp[J]] := 1;
end;

procedure ReduceDag;
begin
  for I := 1 to N do
    C[I, I] := 0;
  for K := 1 to N do
    for I := 1 to N do
      for J := 1 to N do
        if (C[I, K] > 0) and (C[K, J] > 0) and (C[I, J] < C[I, K] + C[K, J]) then
          C[I, J] := C[I, K] + C[K, J];
  for I := 1 to N do
    for J := 1 to N do
      if C[I, J] > 1 then
        C[I, J] := 0;
end;

procedure CalcEdges;
begin
  for I := 1 to N do
    for J := 1 to N do
      if C[I, J] = 1 then Inc(E);
  for I := 1 to B[0, 0] do
    if B[I, 0] > 1 then
      Inc(E, B[I, 0]);
end;

procedure Reduce;
begin
  MakeDag;
  ReduceDag;
  CalcEdges;
end;

procedure WriteOutput;
begin
  Assign(F, 'output.txt');
  ReWrite(F);
  Writeln(F, N, ' ', E);
  for I := 1 to N do
    for J := 1 to N do
      if C[I, J] = 1 then
        Writeln(F, B[I, 1], ' ', B[J, 1]);
  for I := 1 to B[0, 0] do
  begin
    for J := 1 to B[I, 0] - 1 do
      Writeln(F, B[I, J], ' ', B[I, J + 1]);
    if B[I, 0] > 1 then
      Writeln(F, B[I, B[I, 0]], ' ', B[I, 1]);
  end;
  Close(F);
end;

begin
  ReadInput;
  StConnected;
  Reduce;
  WriteOutput;
end.
