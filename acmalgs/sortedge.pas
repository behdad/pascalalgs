{
 Sort edges of a planar graph

 Quick Sort  O(E.LgN)

 Input:
  N: Number of vertices
  G[I]: List of vertices adjacent to I
  D[I]: Degree of vertex I
  P[I]: Position of Vertex P
 Output:
  G[I]: List of vertices adjacent to I in counter-clockwise order

 Notes:
   G should be planar with representation P

 By Ali
}
program
  Faces;

type
  Point = record
    x, y: Integer;
  end;

const
  MaxN = 100 + 1;

var
  N: Integer;
  G: array [1 .. MaxN, 0 .. MaxN] of Integer;
  D: array [1 .. MaxN] of Integer;
  P: array [1 .. MaxN] of Point;

  Tab: Array[1..MaxN] of Extended;
  Pair: Array[1..MaxN] of Integer;

function Comp(a, b: Extended): Integer;
begin
  if abs(a - b) < 1e-8 then Comp := 0
  else
    if a > b then  Comp := 1 else Comp := -1;
end;

function Angle(P, Q: Point): Extended;
var
  a: Extended;
begin
  Q.x := Q.x - P.x;  Q.y := Q.y - P.y;
  if Comp(Q.x, 0) = 0 then
    if Q.y > 0 then
      Angle := Pi / 2
    else
      Angle := 3 * Pi / 2
  else
  begin
    a := ArcTan(Q.y / Q.x);
    if Q.x < 0 then
      a := a + Pi;
    if a < 0 then
      a := a + 2 * Pi;
    Angle := a;
  end;
end;

procedure Swap(var a, b: Integer);
var
  c: Integer;
begin
  c := a; a := b; b := c;
end;

procedure Sort(l, r: Integer);
var
  i, j: integer;
  x, y: Extended;
begin
  i := l; j := r; x := Tab[(l+r) DIV 2];
  repeat
    while Tab[i] < x do i := i + 1;
    while x < Tab[j] do j := j - 1;
    if i <= j then
    begin
      y := Tab[i]; Tab[i] := Tab[j]; Tab[j] := y;
      Swap(Pair[i], Pair[j]);
      i := i + 1; j := j - 1;
    end;
  until i > j;
  if l < j then Sort(l, j);
  if i < r then Sort(i, r);
end;

procedure SortEdges;
var
  i, j: Integer;
begin
  for i := 1 to N do  begin
    for j := 1 to D[i] do  begin
      Pair[j] := G[i, j];
      Tab[j] := Angle(P[i], P[Pair[j]]);
    end;
    if D[i] > 1 then
      Sort(1, D[i]);
    for j := 1 to D[i] do  G[i, j] := Pair[j];
  end;
end;

begin
  SortEdges;
end.
