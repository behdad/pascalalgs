{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
August '1999
Problem 11  o(N!) Recursive Method
}
program
  QueensInChessBoard;

const
  MaxN = 10;

var
  N : Integer;
  A : array [1 .. MaxN] of Integer;
  M1 : array [1 .. MaxN] of Boolean;
  M2 : array [1 - MaxN .. MaxN - 1] of Boolean;
  M3 : array [1 + 1 .. MaxN + MaxN] of Boolean;
  I : Integer;
  F : Text;

procedure Found;
var
  I, J : Integer;
begin
  for I := 1 to N do
  begin
    for J := 1 to A[I] - 1 do
      Write(F, '. ');
    Write(F, 'Q ');
    for J := A[I] + 1 to N do
      Write(F, '. ');
    Writeln(F);
  end;
  Writeln(F);
end;

procedure BT (K : Integer);
var
  I : Integer;
begin
  if K = N + 1 then
  begin Found; Exit; end;
  for I := 1 to N do
  if not (M1[I] or M2[K - I] or M3[K + I]) then
  begin
    M1[I] := True ; M2[K - I] := True ; M3[K + I] := True ;
    A[K] := I;
    BT(K + 1);
    M1[I] := False; M2[K - I] := False; M3[K + I] := False;
  end;
end;

begin
  Readln(N);

  Assign(F, 'output.txt');
  ReWrite(F);
  BT(1);
  Close(F);
end.