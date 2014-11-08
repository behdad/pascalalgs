{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
August '1999
Problem 8  O(N2) Dfs Method
}
program
  ClosedSet;

const
  MaxN = 50;

var
  N : Integer;
  A : array [1 .. MaxN, 1 .. MaxN] of Integer;
  M : array [1 .. MaxN] of Boolean;
  I, J : Integer;
  F : Text;

procedure Add (X : Integer);
var
  I : Integer;
begin
  M[X] := True;
  for I := 1 to N do
    if M[I] then
    begin
      if not M[A[X, I]] then
        Add(A[X, I]);
      if not M[A[I, X]] then
        Add(A[I, X]);
    end;
end;

begin
  Assign(F, 'input.txt');
  Reset(F);
  Readln(F, N);
  for I := 1 to N do
  begin
    for J := 1 to N do
      Read(F, A[I, J]);
    Readln(F);
  end;
  Read(F, I);
  while I <> 0 do
  begin
    Add(I);
    Read(F, I);
  end;
  Close(F);

  Assign(F, 'output.txt');
  ReWrite(F);
  for I := 1 to N do
    if M[I] then
      Writeln(F, I);
  Close(F);
end.