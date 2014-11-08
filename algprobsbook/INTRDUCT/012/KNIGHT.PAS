{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 65520,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
August '1999
Problem 12 O(E) Dfs Method
}
program
  KnightsPath;

const
  MaxN = 100;

const
  DX : array [1 .. 8] of Integer = (2, 1, -1, -2, -2, -1, 1, 2);
  DY : array [1 .. 8] of Integer = (1, 2, 2, 1, -1, -2, -2, -1);

var
  N, X, Y, U, V : Integer;
  A : array [-1 .. MaxN + 2, -1 .. MaxN + 2] of Byte;
  P : array [-1 .. MaxN + 2, -1 .. MaxN + 2] of Integer;
  I, J : Integer;
  F : Text;

procedure DFS (X, Y : Integer);
var
  I : Integer;
begin
  for I := 1 to 8 do
    if (P[X + DX[I], Y + DY[I]] = 0) and (A[X + DX[I], Y + DY[I]] = 0) then
    begin
      P[X + DX[I], Y + DY[I]] := 256 * X + Y;
      DFS(X + DX[I], Y + DY[I]);
    end;
end;

begin
  Assign(F, 'input.txt');
  Reset(F);
  Readln(F, N);
  FillChar(A, SizeOf(A), 1);
  for I := 1 to N do
  begin
    for J := 1 to N do
      Read(F, A[I, J]);
    Readln(F);
  end;
  Readln(F, X, Y);
  Readln(F, U, V);
  Close(F);

  P[U, V] := MaxInt;
  DFS(U, V);

  Assign(F, 'output.txt');
  ReWrite(F);
  I := X * 256 + Y;
  J := 1;
  while I <> 256 * U + V do
  begin
    I := P[I div 256, I mod 256];
    Inc(J);
  end;
  Writeln(F, J);
  I := X * 256 + Y;
  Writeln(F, I div 256, ' ', I mod 256);
  while I <> 256 * U + V do
  begin
    I := P[I div 256, I mod 256];
    Writeln(F, I div 256, ' ', I mod 256);
  end;
  Close(F);
end.