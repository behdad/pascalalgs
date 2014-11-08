{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
September '1999
Problem 38  O(N3) Bfs Method
}
program
  MinimumDiameterSpanningTree;

const
  MaxN = 100;

var
  N, E : Integer;
  A, T : array [1 .. MaxN, 0 .. MaxN] of Integer;
  M : array [1 .. MaxN] of Boolean;
  P, B, H : array [0 .. MaxN] of Integer;
  I, J, K, V, D : Integer;
  F : Text;

var
  Q : array [1 .. MaxN] of Integer;
  QL, QR : Integer;

function  EnQueue (V : Integer) : Integer;
begin
  Inc(QR);
  Q[QR] := V;
  EnQueue := Q[QR];
  M[V] := True;
end;

function  DeQueue : Integer;
begin
  DeQueue := Q[QL];
  Inc(QL);
end;

function  IsEmpty : Boolean;
begin
  IsEmpty := QL > Qr;
end;

function  Diameter (V : Integer) : Integer;
var
  I, J, D, Te : Integer;
begin
  D := 0;
  H[V] := 0;
  for I := 1 to T[V, 0] do
  begin
    Te := Diameter(T[V, I]);
    if Te > D then
      D := Te;
    if H[T[V, I]] + 1 > H[V] then
      H[V] := H[T[V, I]] + 1;
  end;
  for I := 1 to T[V, 0] do
    for J := 1 to I - 1 do
      if H[T[V, I]] + H[T[V, J]] + 2 > D then
        D := H[T[V, I]] + H[T[V, J]] + 2;
  Diameter := D;
end;

function  Bfs (V : Integer) : Integer;
var
  I, J : Integer;
begin
  FillChar(M, SizeOf(M), 0);
  FillChar(P, SizeOf(P), 0);
  FillChar(B, SizeOf(B), 0);
  FillChar(T, SizeOf(T), 0);
  QL := 1;
  QR := 0;
  EnQueue(V);
  while not IsEmpty do
  begin
    J := DeQueue;
    for I := 1 to N do
      if (A[I, J] = 1) and not M[I] then
      begin
        EnQueue(I);
        P[I] := J;
        Inc(T[J, 0]);
        T[J, T[J, 0]] := I;
        B[I] := B[J] + 1;
      end;
  end;
  Bfs := Diameter(V);
end;

procedure Solve;
begin
  D := MaxInt;
  for I := 1 to N do
  begin
    J := Bfs(I);
    if J < D then
    begin
      D := J;
      V := I;
    end;
  end;
  Bfs(V);
end;

procedure ReadInput;
begin
  Assign(F, 'input.txt');
  Reset(F);
  Readln(F, N, E);
  for I := 1 to E do
  begin
    Readln(F, J, K);
    A[J, K] := 1; A[K, J] := 1;
  end;
  Close(F);
end;

procedure WriteOutput;
begin
  Assign(F, 'output.txt');
  ReWrite(F);
  Writeln(F, N, ' ', D);
  for I := 1 to N do
    if P[I] <> 0 then
      Writeln(F, I, ' ', P[I]);
  Close(F);
end;

begin
  ReadInput;
  Solve;
  WriteOutput;
end.
