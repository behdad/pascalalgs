{
 Convex Hull - Shortest Polygon

 Jordan Gift Wrapping Algorithm  O(N.K)

 Input:
  N: Number of points
  P[I]: Coordinates of point I

 Output:
  K: Number of points on ConvexHull
  C: Index of points in ConvexHull

 Note:
  It finds the shortest ConvexHull (In case of many points on a line)

 Reference:
  Creative

 By Behdad
}
program
  ConvexHullJordan;

const
  MaxN = 1000 + 2;

type
  Point = record
    X, Y : Integer;
  end;

var
  N, K : Integer;
  P : array [1 .. MaxN] of Point;
  C : array [1 .. MaxN] of Integer;

  Mark : array [1 .. MaxN] of Boolean;

function Left (var A, B, C : Point) : Longint;
begin
  Left := (Longint(A.X)-B.X)*(Longint(C.Y)-B.Y) -
          (Longint(A.Y)-B.Y)*(Longint(C.X)-B.X);
end;

function D (var A, B : Point) : Extended;
begin
  D := Sqrt(Sqr(Longint(A.X) - B.X) + Sqr(Longint(A.Y) - B.Y));
end;

procedure ConvexHull;
var
  I, J: Integer;
begin
  FillChar(Mark, SizeOf(Mark), 0);
  C[1] := 1;
  for I := 1 to N do
    if P[I].Y < P[C[1]].Y then
      C[1] := I
    else
    if (P[I].Y = P[C[1]].Y) and (P[I].X < P[C[1]].X) then
      C[1] := I;
  Mark[C[1]] := True;
  K := 1;
  repeat
    J := C[1];
    for I := 1 to N do
      if (not Mark[I]) then
        if Left(P[J], P[C[K]], P[I]) < 0 then
          J := I
        else
          if (Left(P[J], P[C[K]], P[I]) = 0) and (D(P[C[K]], P[I]) > D(P[C[K]], P[J])) then
            J := I;
    Inc(K);
    C[K] := J;
  until C[K] = C[1];
end;

begin
  ConvexHull;
end.
