{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
September '1999
Problem 31  O(N3) Floyd Method
}
program
  SemiConnectedGraph;

const
  MaxN = 100;

var
  N : Integer;
  G : array [1 .. MaxN, 1 .. MaxN] of Integer;
  I, J, K : Integer;
  F : Text;

procedure ReadInput;
begin
  Assign(F, 'input.txt');
  Reset(F);
  Readln(F, N);
  for I := 1 to N do
  begin
    for J := 1 to N do
    begin
      Read(F, G[I, J]);
      if (G[I, J] = 0) and (I <> J) then G[I, J] := 10000;
    end;
    Readln(F);
  end;
  Close(F);
end;

procedure NonSemiCon;
begin
  Writeln('Graph is not SemiConnected.');
  Halt;
end;

procedure SemiCon;
begin
  for K := 1 to N do
    for I := 1 to N do
      for J := 1 to N do
        if G[I, J] > G[I, K] + G[K, J] then
          G[I, J] := G[I, K] + G[K, J];
  for I := 1 to N do
    for J := 1 to N do
      if G[I, J] + G[J, I] = 20000 then
        NonSemiCon;
  Writeln('Graph is SemiConnected.');
end;

begin
  ReadInput;
  SemiCon;
end.
