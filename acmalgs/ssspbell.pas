{
 Single Source Shortest Paths - With Negative Weight Edges

 BellmanFord Algorthm  O(N3)

 Input:
  G: Directed weighted graph (No Edge = Infinity)
  N: Number of vertices
  S: The source vertex
 Output:
  D[I]: Length of minimum path from S to I
  P[I]: Parent of vertex I in its path from S, P[S] = 0
  NoAnswer: Graph has cycle with negative length

 Note:
  Infinity should be less than the max value of its type

 Reference:
  CLR, p532

 By Ali
}
program
  BellmanFord;

const
  MaxN = 100 + 2;
  Infinity = 10000;

var
  N, S: Integer;
  G: array [1 .. MaxN, 1 .. MaxN] of Integer;
  D, P: Array[1..MaxN] of Integer;
  NoAnswer: Boolean;

procedure Relax(V, U: Integer);
begin
  if D[U] > D[V] + G[V, U] then
  begin
    D[U] := D[V] + G[V, U];
    P[U] := V;
  end;
end;

procedure SSSPNeg;
var
  I, J, K: Integer;
begin
  FillChar(P, SizeOf(P), 0);
  for i := 1 to N do
    D[I] := Infinity;
  D[S] := 0;
  for K := 1 to N - 1 do
    for I := 1 to N do
      for J := 1 to N do
        Relax(I, J);
  NoAnswer := False;
  for I := 1 to N do
    for J := 1 to N do
      if D[J] > D[I] + G[I, J] then
      begin
        NoAnswer := True;
        Exit;
      end;
end;

begin
  SSSPNeg;
end.
