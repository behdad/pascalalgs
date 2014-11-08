{
 Single Source Shortest Paths - Without Negative Weight Edges

 Dijkstra Algorthm  O(N2)

 Input:
  G: Directed weighted graph (No Edge = Infinity)
  N: Number of vertices
  S: The source vertex
 Output:
  D[I]: Length of minimum path from S to I (No Path = Infinity)
  P[I]: Parent of vertex I in its path from S, P[S] = 0, (No Path->P[I]=0)

 Note:
  Infinity should be less than the max value of its type
  No negative edge

 Reference:
  CLR, p527

 By Ali
}

program
  Dijkstra;

const
  MaxN = 100 + 1;
  Infinity = 10000;

var
  N, S: Integer;
  G: array [1 .. MaxN, 1 .. MaxN] of Integer;
  D, P: Array[1..MaxN] of Integer;
  NoAnswer: Boolean;

  Mark: array[1 .. MaxN] of Boolean;

procedure Relax(V, U: Integer);
begin
  if D[U] > D[V] + G[V, U] then
  begin
    D[U] := D[V] + G[V, U];
    P[U] := V;
  end;
end;

procedure SSSP;
var
  I, U, Step: Integer;
  Min: Integer;
begin
  FillChar(Mark, SizeOf(Mark), 0);
  FillChar(P, SizeOf(P), 0);
  for I := 1 to N do
    D[I] := Infinity;
  D[S] := 0;
  for Step := 1 to N do
  begin
    Min := Infinity;
    for I := 1 to N do
      if not Mark[I] and (D[I] < Min) then
      begin
        U := I;
        Min := D[I];
      end;
    if Min = Infinity then
      Break;
    Mark[U] := True;
    for I := 1 to N do
      Relax(U, I);
  end;
end;

begin
  SSSP;
end.

