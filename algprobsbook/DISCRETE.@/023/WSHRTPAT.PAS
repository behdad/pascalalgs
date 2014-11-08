{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
September '1999
Problem 23  O(N2) Dijkstra Alg.  O(N3) BellmanFord Alg.  O(N3) FloydWarshal Alg.
}
program
  ShortestPathInWeightedGraph;

const
  MaxN = 178;

var
  N, V : Integer;
  G : array [1 .. MaxN, 1 .. MaxN] of Integer;
  A : array [1 .. MaxN] of Integer;
  M : array [1 .. MaxN] of Boolean;
  I, J, K : Integer;
  NegEdge, NegCycle : Boolean;
  TT : Longint;
  Time : Longint absolute $40:$6C;
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
      if G[I, J] < 0 then
        NegEdge := True;
    end;
    Readln(F);
  end;
  Close(F);
  Write('Enter V : '); Readln(V);
end;

procedure Dijkstra;
begin
  TT := Time;
  for I := 1 to N do
    A[I] := 10000;
  A[V] := 0;
  for K := 1 to N do
  begin
    J := 10001;
    for I := 1 to N do
      if (not M[I]) and (A[I] < J) then
      begin
        J := A[I];
        K := I;
      end;
    M[K] := True;
    for I := 1 to N do
      if A[I] > A[K] + G[K, I] then
        A[I] := A[K] + G[K, I];
  end;

  Writeln('Dijkstra''s Time : ', (Time - TT) / 18.2 : 0 : 2);

  Assign(F, 'ssspd.out');
  Rewrite(F);
  if NegEdge then
    Writeln(F, 'Graph has Negative Edge(s), Dijkstra Algorithm dosn''t work.')
  else
    for I := 1 to N do
      Writeln(F, A[I]);
  Close(F);
end;

procedure BellManFord;
begin
  TT := Time;
  for I := 1 to N do
    A[I] := 10000;
  A[V] := 0;
  for K := 1 to N do
  begin
    NegCycle := False;
    for I := 1 to N do
      for J := 1 to N do
        if A[J] > A[I] + G[I, J] then
        begin
          A[J] := A[I] + G[I, J];
          NegCycle := True;
        end;
  end;

  Writeln('BellmanFord''s Time : ', (Time - TT) / 18.2 : 0 : 2);

  Assign(F, 'ssspb.out');
  Rewrite(F);
  if NegCycle then
    Writeln(F, 'Graph has Negative Cycle(s), BellmanFord Algorithm dosn''t work.')
  else
    for I := 1 to N do
      Writeln(F, A[I]);
  Close(F);
end;

procedure FloydWarshal;
begin
  TT := Time;
  for I := 1 to N do
    G[I, I] := 0;
  for K := 1 to N do
    for I := 1 to N do
      for J := 1 to N do
        if G[I, J] > G[I, K] + G[K, J] then
          G[I, J] := G[I, K] + G[K, J];

  Writeln('FloydWarshal''s Time : ', (Time - TT) / 18.2 : 0 : 2);

  Assign(F, 'apsp.out');
  Rewrite(F);
  if NegCycle then
    Writeln(F, 'Graph has Negative Cycle(s), FloydWarshal Algorithm dosn''t work.')
  else
    for I := 1 to N do
    begin
      for J := 1 to N do
        Write(F, G[I, J] : 2, ' ');
      Writeln(F);
    end;
  Close(F);
end;

begin
  ReadInput;
  Dijkstra;
  BellmanFord;
  FloydWarshal;
end.
