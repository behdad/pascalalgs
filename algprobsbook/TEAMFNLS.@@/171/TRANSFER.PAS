{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
April '2000
Problem 171  O(N3) BellmanFord Alg.
}
program
  TransferInWeightedGraph;

const
  MaxN = 100;

var
  N, M : Integer;
  G : array [0 .. MaxN, 0 .. MaxN] of Longint;
  S : array [0 .. MaxN] of Longint;
  NoSol : Boolean;

  I, J, K, L : Integer;

procedure ReadInput;
begin
  FillChar(G, SizeOf(G), 1);
  Assign(Input, 'input.txt');
  Reset(Input);
  Readln(N, M);
  for I := 1 to M do
  begin
    Readln(J, K, L);
    G[K, J] := L - 1;
  end;
  Close(Input);
end;

procedure WriteOutput;
begin
  Assign(Output, 'output.txt');
  Rewrite(Output);
  if NoSol then
    Writeln('NO SOLUTION')
  else
    for I := 1 to N do
      if S[I] <> 0 then
        Writeln(I, ' ', -S[I]);
  Close(Output);
end;

procedure BellmanFord;
begin
  FillChar(S, SizeOf(S), 1);
  for I := 1 to N do
    G[0, I] := 0;
  S[0] := 0;
  for K := 0 to N do
  begin
    NoSol := False;
    for I := 0 to N do
      for J := 0 to N do
        if S[I] > S[J] + G[J, I] then
        begin
          S[I] := S[J] + G[J, I];
          NoSol := True;
        end;
  end;
end;

begin
  ReadInput;
  BellmanFord;
  WriteOutput;
end.
