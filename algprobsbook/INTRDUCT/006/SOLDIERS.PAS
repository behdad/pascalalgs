{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
August '1999
Problem 6  O(N) Dynamic Method
}
program
  Soldiers;

const
  MaxN = 200;

var
  N : Integer;
  S : array [1 .. MaxN] of Boolean;
  D : array [0 .. MaxN] of Integer;
  I, L, LNum : Integer;
  Ch : Char;
  F : Text;

begin
  Assign(F, 'input.txt');
  Reset(F);
  Readln(F, N);
  for I := 1 to N do
  begin
    Read(F, Ch);
    if UpCase(Ch) = 'L' then S[I] := True else S[I] := False;
  end;
  Close(F);

  L := 0;
  D[0] := 0;
  for I := 1 to N do
  if S[I] then
  begin
    if D[L] + L < I - 1 then
      D[I] := 0
    else
      D[I] := D[L] - I + L + 2;
    Inc(LNum);
    L := I;
  end;

  Assign(F, 'output.txt');
  ReWrite(F);
  Writeln(F, 'Number of moves is equal to ', D[L] + L - LNum, '.');
  Close(F);
end.