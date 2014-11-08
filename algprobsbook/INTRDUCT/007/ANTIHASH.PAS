{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
August '1999
Problem 7  O(N3) Simulation Method
}
program
  AntiHash;

const
  MaxN = 50;

var
  N : Integer;
  A, B : array [0 .. MaxN - 1] of Integer;
  H, M : array [0 .. MaxN - 1] of Boolean;
  I, J, K : Integer;
  F : Text;

function  Hash (X : Integer) : Integer;
var
  I : Integer;

begin
  I := X mod N;
  while H[I] do
    I := (I + 1) mod N;
  Hash := I;
end;

begin
  Assign(F, 'input.txt');
  Reset(F);
  Readln(F, N);
  for I := 0 to N - 1 do
    Readln(F, A[I]);
  Close(F);

  for I := 0 to N - 1 do
    for J := 0 to N - 1 do
      if not M[J] and (Hash(A[J]) = J) then
      begin
        M[J] := True;
        B[I] := A[J];
        H[J] := True;
        Break;
      end;

  Assign(F, 'output.txt');
  ReWrite(F);
  for I := 0 to N - 1 do
    Writeln(F, B[I]);
  Close(F);
end.