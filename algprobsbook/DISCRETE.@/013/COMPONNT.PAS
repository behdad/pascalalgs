{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
August '1999
Problem 13  O(N2) Dfs Algorithm
}
program
  ConnectedComponents;

const
  MaxN = 100;

var
  N : Integer;
  A : array [1 .. MaxN, 1 .. MaxN] of Integer;
  M : array [1 .. MaxN] of Boolean;
  I, J : Integer;
  F : Text;

procedure ReadInput;
begin
  Assign(F, 'input.txt');
  Reset(F);
  Readln(F, N);
  for I := 2 to N do
  begin
    for J := 1 to I - 1 do
    begin
      Read(F, A[I, J]); A[J, I] := A[I, J];
    end;
    Readln(F);
  end;
  Close(F);

  Assign(F, 'output.txt');
  ReWrite(F);
end;

procedure DFS (V : Integer);
var
  I : Integer;
begin
  M[V] := True;
  Write(F, V, ' ');
  for I := 1 to N do
    if (A[V, I] = 1) and not M[I] then
      DFS(I);
end;

procedure DfdAlg;
begin
  J := 0;
  for I := 1 to N do
    if not M[I] then
    begin
      Inc(J);
      DFS(I);
      Writeln(F);
    end;
  ReWrite(F);
  Writeln(F, J);
  FillChar(M, SizeOf(M), 0);
  for I := 1 to N do
    if not M[I] then
    begin
      DFS(I);
      Writeln(F);
    end;
end;

begin
  ReadInput;
  DfdAlg;
  Close(F);
end.