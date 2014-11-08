{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
September '1999
Problem 40  O(N3) Dynamic Method
}
program
  WeightBoundedMinimumDistance;

const
  MaxN = 100;

var
  N, E, U, V, W : Integer;
  G, D : array [0 .. MaxN, 1 .. MaxN] of Word;
  P : array [0 .. MaxN, 1 .. MaxN] of Byte;
  I, J, K, L : Integer;
  F : Text;

procedure Solve;
begin
  FillChar(D, SizeOf(D), 120);
  D[0, V] := 0;
  for K := 1 to N - 1 do
    for I := 1 to N do
      for J := 1 to N do
        if (G[J, I] > 0) and (D[K, I] > D[K - 1, J] + G[J, I]) then
        begin
          D[K, I] := D[K - 1, J] + G[J, I];
          P[K, I] := J;
        end;
end;

procedure ReadInput;
begin
  Assign(F, 'input.txt');
  Reset(F);
  Readln(F, N, E, U, V, W);
  for I := 1 to E do
  begin
    Readln(F, J, K, L);
    G[J, K] := L; G[K, J] := L;
  end;
  Close(F);
end;

procedure WriteOutput;
begin
  Assign(F, 'output.txt');
  ReWrite(F);
  J := U;
  for L := 1 to N do
    if D[L, U] <= W then Break;
  if L = N then
    Writeln(F, 'No Solution')
  else
    for K := L downto 0 do
    begin
      Write(F, J, ' ');
      J := P[K, J];
    end;
  Close(F);
end;

begin
  ReadInput;
  Solve;
  WriteOutput;
end.
