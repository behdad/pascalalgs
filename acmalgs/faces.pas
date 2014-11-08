{
 Find Faces Of A Planar Graph

 Greedy Alg.  O(N3)

 Input:
  N: Number of vertices
  G[I]: List of vertices adjacent to I in counter-clockwise order
  D[I]: Degree of vertex I
  P[I]: Position of Vertex P
 Output:
  Edge[I][J]: Number of the face that lies to the left of edge (I,J)
  FaceNum: Number of faces, including the outer one
  FaceDeg[I]: Number of vertices on face I
  Face[I]: Vertices of face I

 Notes:
   G should represent a valid embedding of a planar connected graph
   A, B that FindFaces accepts represent these:
     A = Index of point with minimum X (and with minimum Y within them)
     B = The rightmost point that A is connected to
     These are used to set the face number of outer face of graph to 1
     Pass 0, 0 to ignore these
   Edge[I][J] <> Edge[J][I]
   FindOuterFaceEdge finds A and B for FindFaces

 By Behdad
}
program
  Faces;

const
  MaxN = 30 + 1;

var
  N: Integer;
  G, Edge: array [1 .. MaxN, 0 .. MaxN] of Integer;
  D, FaceDeg: array [1 .. MaxN] of Integer;
  Face: array [1 .. MaxN * 3, 0 .. MaxN * 6] of Integer;
  FaceNum: Integer;
  P: array [1 .. MaxN] of record X, Y: Integer; end;

procedure FindFace (A, B: Integer);
var
  I, S, T: Integer;
begin
  Inc(FaceNum);
  S := A;
  T := B;
  FaceDeg[FaceNum] := 0;
  Face[FaceNum, 0] := A;
  repeat
    Inc(FaceDeg[FaceNum]);
    Face[FaceNum, FaceDeg[FaceNum]] := B;
    Edge[A, B] := FaceNum;
    for I := 1 to D[b] do
      if A = G[B, I] then
        Break;
    A := B;
    B := G[B, I - 1];
  until (A = S) and (B = T);
end;

procedure FindFaces (A, B: Integer);
var
  I, J: Integer;
begin
  for I := 1 to N do
    G[I, 0] := G[I, D[I]];
  FillChar(Edge, SizeOf(Edge), 0);
  for I := 1 to N do
    for J := 1 to D[I] do
      Edge[I, G[I, J]] := -1;
  FaceNum := 0;
  if (A > 0) and (B > 0) then
    FindFace(B, A);
  for I := 1 to N do
    for J := 1 to N do
      if Edge[I, J] = -1 then
        FindFace(I, J);
end;

procedure FindOuterFaceEdge (var A, B: Integer);
var
  I, J: Integer;
begin
  A := 1;
  for I := 2 to N do
    if (P[I].X < P[A].X) or ((P[I].X = P[A].X) and (P[I].Y <= P[A].Y)) then
      A := I;
  B := G[A, 1];
  for I := 2 to D[A] do
  begin
    J := G[A, I];
    if (P[J].X-P[A].X) * (P[B].Y-P[A].Y) > (P[J].Y-P[A].Y) * (P[B].X-P[A].X) then
      B := J;
  end;
end;

var
  A, B: Integer;

begin
  FindOuterFaceEdge(A, B);
  FindFaces(A, B);
end.
