{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q+,R+,S+,T-,V+,X+,Y+}
{$M 65520,0,655360}
{by Behdad Esfahbod  Geometry Exam}
program
  ProblemC;

type
  Real = Extended;

const
  MaxN = 50 + 1;
  MaxV = 1325 + 5;
  MaxD = 2 * MaxN + 3;
  Epsilon = 1E-5;

type
  TPoint = record X, Y : Extended; end;
  TGVertex = array [0 .. MaxD] of Integer; {TVertex[0] is Degree of the vertex}
  TSegment = record
    A, B, C : Extended;
    P : array [1 .. 2] of TPoint;
  end;

var
  N, K, V : Integer;
  Vs : array [1 .. MaxV] of TPoint;
  G : array [1 .. MaxV] of ^ TGVertex;
  E : array [1 .. MaxN, 0 .. MaxD] of Integer; {E[I, 0] is number of points on segment I}
  S : array [1 .. MaxN] of TSegment;
  Ans : Longint;

  P1, P2 : TPoint;
  I, J, I2, J2 : Integer;

function D (P1, P2 : TPoint) : Extended;
begin
  D := Sqrt(Sqr(P1.X - P2.X) + Sqr(P1.Y - P2.Y));
end;

function Comp (A, B : Extended) : Integer;
begin
  if Abs(A - B) < Epsilon then
    Comp := 0
  else
    if A < B then
      Comp := -1
    else
      Comp := 1;
end;

procedure ReadInput;
begin
  Assign(Input, 'input.txt');
  Reset(Input);
  Readln(N, K);
  for I := 1 to N do
    with S[I] do
    Readln(P[1].X, P[1].Y, P[2].X, P[2].Y);

  Close(Input);
end;

procedure WriteOutput;
begin
  Assign(Output, 'output.txt');
  ReWrite(Output);
  Writeln(Output, Ans);
  Close(Output);
end;

function  AddVertex (P : TPoint) : Integer;
var
  I : Integer;
begin
  for I := 1 to V + 1 do
    if (Comp(P.X, Vs[I].X) = 0) and (Comp(P.Y, Vs[I].Y) = 0) then
      Break;
  if I = V + 1 then
  begin
    Inc(V);
    New(G[V + 1]);
    G[V + 1]^[0] := 0;
    Vs[V] := P;
  end;
  AddVertex := I;
end;

function  InRange (A, I, J : Extended) : Boolean;
begin
  InRange := ((Comp(I, A) <= 0) and (Comp(A, J) <= 0)) or
             ((Comp(I, A) >= 0) and (Comp(A, J) >= 0));
end;

function  Min (A, B : Extended) : Extended;
begin
  if A <= B then Min := A else Min := B;
end;

function  Max (A, B : Extended) : Extended;
begin
  if A >= B then Max := A else Max := B;
end;

function  IntersectSeg (var Q, R : TSegment; var P1, P2 : TPoint) : Integer;
var
  INum : Integer;
  Z : Extended;
begin
  Z := Q.A * R.B - Q.B * R.A;
  if Z = 0 then
  begin
    if (Q.C * R.B = Q.B * R.C) and (Q.A * R.C = Q.C * R.A) and
      (InRange(Q.P[1].X, R.P[1].X, R.P[2].X) or InRange(Q.P[2].X, R.P[1].X, R.P[2].X) or
       InRange(R.P[1].X, Q.P[1].X, Q.P[2].X) or InRange(R.P[2].X, Q.P[1].X, Q.P[2].X)) and
      (InRange(Q.P[1].Y, R.P[1].Y, R.P[2].Y) or InRange(Q.P[2].Y, R.P[1].Y, R.P[2].Y) or
       InRange(R.P[1].Y, Q.P[1].Y, Q.P[2].Y) or InRange(R.P[2].Y, Q.P[1].Y, Q.P[2].Y))
     then
    begin
      IntersectSeg := 2;
      if Comp(Q.A, 0) = 0 then
      begin
        P1.X := Q.P[1].X;
        P1.Y := Min(Max(Q.P[1].Y, Q.P[2].Y), Max(R.P[1].Y, R.P[2].Y));
        P2.X := Q.P[1].X;
        P2.Y := Max(Min(Q.P[1].Y, Q.P[2].Y), Min(R.P[1].Y, R.P[2].Y));
      end
      else
        if Comp(Q.B / Q.A, 0) <= 0 then
        begin
          P1.X := Min(Max(Q.P[1].X, Q.P[2].X), Max(R.P[1].X, R.P[2].X));
          P1.Y := Min(Max(Q.P[1].Y, Q.P[2].Y), Max(R.P[1].Y, R.P[2].Y));
          P2.X := Max(Min(Q.P[1].X, Q.P[2].X), Min(R.P[1].X, R.P[2].X));
          P2.Y := Max(Min(Q.P[1].Y, Q.P[2].Y), Min(R.P[1].Y, R.P[2].Y));
        end
        else
        begin
          P1.X := Max(Min(Q.P[1].X, Q.P[2].X), Min(R.P[1].X, R.P[2].X));
          P1.Y := Min(Max(Q.P[1].Y, Q.P[2].Y), Max(R.P[1].Y, R.P[2].Y));
          P2.X := Min(Max(Q.P[1].X, Q.P[2].X), Max(R.P[1].X, R.P[2].X));
          P2.Y := Max(Min(Q.P[1].Y, Q.P[2].Y), Min(R.P[1].Y, R.P[2].Y));
        end;
    end
    else
      IntersectSeg := 0;
    Exit;
  end;
  P1.X := (Q.B * R.C - Q.C * R.B) / Z;
  P1.Y := (Q.C * R.A - Q.A * R.C) / Z;
  if not (InRange(P1.X, Q.P[1].X, Q.P[2].X) and InRange(P1.X, R.P[1].X, R.P[2].X)
      and InRange(P1.Y, Q.P[1].Y, Q.P[2].Y) and InRange(P1.Y, R.P[1].Y, R.P[2].Y)) then
  begin
    IntersectSeg := 0;
    Exit;
  end;
  IntersectSeg := 1;
end;

procedure FindLine (var S : TSegment);
begin
  with S do
  begin
    A := (P[1].Y - P[2].Y);
    B := (P[2].X - P[1].X);
    C := - (A * P[1].X + B * P[1].Y);
  end;
end;

procedure AddVertexToSegment (J, K : Integer);
var
  I : Integer;
begin
  for I := 1 to E[J, 0] + 1 do
    if E[J, I] = K then
      Break;
  if I = E[J, 0] + 1 then
  begin
    Inc(E[J, 0]);
    E[J, E[J, 0]] := K;
  end;
end;

procedure FindVertices;
var
  II : Integer;
begin
  for I := 1 to N do
    with S[I] do
    begin
      FindLine(S[I]);
      II := AddVertex(P[1]);
      AddVertexToSegment(I, II);
      II := AddVertex(P[2]);
      AddVertexToSegment(I, II);
    end;
  for I := 1 to N do
    for J := 1 to I - 1 do
    begin
      I2 := IntersectSeg(S[I], S[J], P1, P2);
      if I2 > 0 then
      begin
        II := AddVertex(P1);
        AddVertexToSegment(I, II);
        AddVertexToSegment(J, II);
        if I2 > 1 then
        begin
          II := AddVertex(P2);
          AddVertexToSegment(I, II);
          AddVertexToSegment(J, II);
        end;
      end;
    end;
end;

function  VComp (V1, V2 : TPoint) : Integer;
begin
  if Comp(V1.X, V2.X) = 0 then
    VComp := Comp(V1.Y, V2.Y)
  else
    VComp := Comp(V1.X, V2.X);
end;

procedure AddEdgeToVertex (A, B : Integer);
var
  I : Integer;
begin
  for I := 1 to G[A]^[0] + 1 do
    if G[A]^[I] = B then
      Break;
  if I = G[A]^[0] + 1 then
  begin
    Inc(G[A]^[0]);
    G[A]^[G[A]^[0]] := B;
  end;
end;

procedure MakeEdges;
begin
  for I := 1 to N do
  begin
    for J := 1 to E[I, 0] do
      for K := J + 1 to E[I, 0] do
        if VComp(Vs[E[I, J]], Vs[E[I, K]]) > 0 then
        begin
          I2 := E[I, J];
          E[I, J] := E[I, K];
          E[I, K] := I2;
        end;
    for J := 1 to E[I, 0] - 1 do
    begin
      AddEdgeToVertex(E[I, J], E[I, J + 1]);
      AddEdgeToVertex(E[I, J + 1], E[I, J]);
    end;
  end;
end;

function A (P1, P2 : TPoint) : Extended;
var
  An : Extended;
begin
  if Comp(P1.X, P2.X) = 0 then
    if Comp(P1.Y, P2.Y) <= 0 then
      An := Pi / 2
    else
      An := 3 * Pi / 2
  else
  begin
    An := ArcTan((P2.Y - P1.Y) / (P2.X - P1.X));
    if Comp(P1.X, P2.X) > 0 then
      An := An + Pi;
  end;
  if Comp(An, 0) < 0 then
    An := An + 2 * Pi;
  if Comp(An, Pi) >= 0 then
    An := An - 2 * Pi;
  A := An;
end;

procedure FindFace (A, Indb : Integer);
var
  Size, B, Ind, Ab, Bb, Ne, I, J : Integer;
  TT, TT2, TT3 : Extended;
begin
  Size := 0;
  Ind := Indb;
  B := G[A]^[Ind];
  Ab := A; Bb := B;
  repeat
    Ne := 1;
    TT := -1E10;
    for I := 1 to G[B]^[0] do if G[B]^[I] <> A then
    begin
      TT2 := ProblemC.A(Vs[B], Vs[G[B]^[I]]);
      TT3 :=    ProblemC.A(Vs[A], Vs[B]);
      TT2 := TT2 - TT3;
      if TT2 > TT then
      begin
        TT := TT2;
        Ne := I;
      end;
    end;
    Ind := Ne;
    A := B;
    B := G[B]^[Ind];
    G[A]^[Ind] := G[A]^[G[A]^[0]];
    Dec(G[A]^[0]);
    Inc(Size);
  until (A = Ab) and (B = Bb);
  if Size = K then
    Inc(Ans);
end;

procedure FindFaces;
begin
  for I := 1 to V do
    while G[I]^[0] > 0 do
      FindFace(I, 1);
end;

procedure Solve;
begin
  New(G[1]);
  G[1]^[0] := 0;
  FindVertices;
  MakeEdges;
  FindFaces;
end;

begin
  ReadInput;
  Solve;
  WriteOutput;
end.
