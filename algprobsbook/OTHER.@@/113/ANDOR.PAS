{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
April '2000
Problem 113  O(E) Dynamic Method
}
program
  AndOrGraph;

const
  MaxN = 100;

var
  N : Integer;
  G : array [1 .. MaxN, 0 .. MaxN] of Integer;
  D : array [0 .. MaxN] of Longint;
  W, P, T : array [1 .. MaxN] of Integer;
  S : string;

  I, J, K : Integer;

procedure ReadInput;
begin
  Assign(Input, 'input.txt');
  Reset(Input);
  Readln(N);
  for I := 1 to N do
  begin
    Readln(W[I], S);
    J := 1;
    while S[J] = ' ' do Inc(J);
    if UpCase(S[J]) = 'O' then
      T[I] := 0
    else
      T[I] := 1;
  end;
  for I := 1 to N - 1 do
  begin
    Readln(J, K);
    Inc(G[J, 0]);
    G[J, G[J, 0]] := K;
  end;
  Close(Input);
end;

procedure WritePath (V : Integer);
var
  I : Integer;
begin
  if V <> 1 then
    Write(', ', V);
  if (T[V] = 0) and (P[V] <> 0) then
    WritePath(P[V])
  else
    for I := 1 to G[V, 0] do
      WritePath(G[V, I]);
end;

procedure WriteOutput;
begin
  Assign(Output, 'output.txt');
  Rewrite(Output);
  Write('A minimum valid set is: 1');
  WritePath(1);
  Writeln;
  Writeln('Total weight = ', D[1]);
  Close(Output);
end;

procedure Dfs (V : Integer);
var
  I : Integer;
begin
  if T[V] = 0 then
    D[V] := MaxLongint div 2
  else
    D[V] := 0;
  P[V] := 0;
  for I := 1 to G[V, 0] do
  begin
    Dfs(G[V, I]);
    if T[V] = 1 then
      Inc(D[V], D[G[V, I]])
    else
      if D[V] > D[G[V, I]] then
      begin
        D[V] := D[G[V, I]];
        P[V] := G[V, I];
      end;
  end;
  if T[V] = 0 then
    D[V] := D[P[V]];
  Inc(D[V], W[V]);
end;

begin
  ReadInput;
  Dfs(1);
  WriteOutput;
end.
