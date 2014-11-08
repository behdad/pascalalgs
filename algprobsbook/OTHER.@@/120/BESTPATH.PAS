{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 16384,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
April '2000
Problem 120  O(N3) Floyd Alg.
}
program
  BestPath;

const
  MaxN = 100;

var
  N, M : Integer;
  G : array [1 .. MaxN, 1 .. MaxN] of Longint;
  P : array [1 .. MaxN, 1 .. MaxN] of Byte;

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
    G[J, K] := L;
  end;
  Close(Input);
end;

procedure WritePath (I, J : Integer);
begin
  if P[I, J] <> 0 then
  begin
    WritePath(I, P[I, J]);
    Write(P[I, J], ' ');
    WritePath(P[I, J], J);
  end;
end;

procedure WriteOutput;
begin
  Assign(Output, 'output.txt');
  Rewrite(Output);
  if G[1, 2] > 1000000 then
    Writeln('No Solution')
  else
  begin
    Writeln(G[1, 2]);
    Write(1, ' ');
    WritePath(1, 2);
    Writeln(2);
  end;
  Close(Output);
end;

procedure Floyd;
begin
  for K := 1 to N do
    for I := 1 to N do
      for J := 1 to N do
        if (G[I, J] > G[I, K]) and (G[I, J] > G[K, J]) then
        begin
          G[I, J] := G[I, K];
          if G[I, J] < G[K, J] then
            G[I, J] := G[K, J];
          P[I, J] := K;
        end;
end;

begin
  ReadInput;
  Floyd;
  WriteOutput;
end.
