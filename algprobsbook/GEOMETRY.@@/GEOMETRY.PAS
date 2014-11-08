unit
  Geometry;

interface

const
   MaxPoint = 100;
   MaxVer = 100;
   Epsilon = 1e-7;

type
  TReal = extended;
  TAngle = extended;

  TPoint = record
    x, y: TReal;
  end;

  TLine = record
    a, b, c: TReal;
  end;

  TSeg = record
    p1, p2: TPoint;
  end;

  TArrayPoint = array[0..MaxPoint] of TPoint;

  TPolygon = record
    size: integer;
    P: TArrayPoint;
  end;

  TGraph = record
    n: integer;
    A: array[1..MaxVer, 1..MaxVer] of byte;
  end;

  TArrPolyg = array[1..30] of TPolygon;

  function Compare(x, y: TReal): Integer;

  function InRange(a, x, y: TReal): Boolean;

  function Distance(p1, p2: TPoint): TReal;

  function Angle(p1, p2, p3: TPoint): TAngle;

  procedure Shift(p1, p2, p3: TPoint; var p: TPoint);

  function TurnComp(p1, p2, p3: TPoint): integer;

  function Area(Polygon : TPolyGon): TReal;

  procedure FindLine(p1, p2: TPoint; var L: TLine);

  function IsIntersect(s1, s2: TSeg): boolean;

  function IntersectSeg(s1, s2: TSeg; var p1, p2: TPoint): byte;

  function Intersect(s1, s2: TSeg; var p1: TPoint): boolean;

  function IsEqualPoint(p1, p2: TPoint): boolean;

  procedure AmoodNesf(p1, p2: TPoint; var L: TLine);

  function DotProd(v1, v2: TPoint): TReal;

  function ExternProd(v1, v2: TPoint): TReal;

  procedure Minus(p1, p2: TPoint; var v: TPoint);

  function IsOn(p1, p2, p3: TPoint): boolean;

  procedure ConvexHull(P: TArrayPoint; var C: TPolygon);

  procedure Rotate(p1, p2: TPoint; alpha: TAngle; var p: TPoint);

  procedure FindFace(G: TGraph; P: TArrayPoint; var Pol: TArrPolyg);

implementation

procedure Swap (var X, Y : TReal);
var
  TeReal : TReal;
begin
  TeReal := X;
  X := Y;
  Y := TeReal;
end;

function Compare;
begin
  if Abs(X - Y) < Epsilon then
    Compare := 0
  else
    if X > Y then
      Compare := 1
    else
      Compare := -1;
end;

function InRange;
begin
  if X > Y then
    Swap(X, Y);
  InRange := Compare(A, X) or Compare(Y, A) <> -1;
end;

function  Distance;
begin
  Distance := Sqrt(Sqr(P1.X - P2.X) + Sqr(P1.Y - P2.Y));
end;

function  Angle;
begin
end;

procedure Shift;
begin
end;

function  TurnComp;
var
  V2, V3 : TPoint;
begin
  Minus(P2, P1, V2);
  Minus(P3, P1, V3);
  TurnComp := Compare(ExternProd(V2, V3), 0);
end;

function  Area;
begin
end;

procedure FindLine;
begin
  L.A := P1.Y - P2.Y;
  L.B := P2.X - P1.X;
  L.C := - P1.X * L.A - P1.Y * L.B;
end;

function  IsIntersect;
begin
  IsIntersect :=
    (    InRange(S1.P1.X, S2.P1.X, S2.P2.X) or
         InRange(S1.P2.X, S2.P1.X, S2.P2.X)    ) and
    (    InRange(S1.P1.Y, S2.P1.Y, S2.P2.Y) or
         InRange(S1.P2.Y, S2.P1.Y, S2.P2.Y)    ) and
    (    InRange(S2.P1.X, S1.P1.X, S1.P2.X) or
         InRange(S2.P2.X, S1.P1.X, S1.P2.X)    ) and
    (    InRange(S2.P1.Y, S1.P1.Y, S1.P2.Y) or
         InRange(S2.P2.Y, S1.P1.Y, S1.P2.Y)    ) and
    (    TurnComp(S1.P1, S1.P2, S2.P1) *
         TurnComp(S1.P1, S1.P2, S2.P2) <= 0    ) and
    (    TurnComp(S2.P1, S2.P2, S1.P1) *
         TurnComp(S2.P1, S2.P2, S1.P2) <= 0    );
end;

function  IntersectSeg;
begin
end;

function  Intersect;
var
  L1, L2 : TLine;
  V1, V2 : TPoint;
begin
  Minus(S1.P1, S1.P2, V1);
  Minus(S2.P1, S2.P2, V2);
  if Compare(ExternProd(V1, V2), 0) <> 0 then
  begin
    FindLine(S1.P1, S1.P2, L1);
    FindLine(S2.P1, S2.P2, L2);
    P1.X := (L1.C * L2.B - L1.B * L2.C) / (L1.C * L2.B - L1.B * L2.C);
    P1.Y := (L1.A * L2.B - L1.B * L2.A) / (L1.A * L2.B - L1.B * L2.A);
    Intersect := True;
  end
  else
    Intersect := False;
end;

function  IsEqualPoint;
begin
end;

procedure AmoodNesf;
begin
end;

function  DotProd;
begin
  DotProd := V1.X * V2.X + V1.Y * V2.Y;
end;

function  ExternProd;
begin
  ExternProd := V1.X * V2.Y - V1.Y * V2.X;
end;

procedure Minus;
begin
  V.X := P2.X - P1.X;
  V.Y := P2.Y - P1.Y;
end;

function  IsOn;
begin
end;

procedure ConvexHull;
begin
end;

procedure Rotate;
begin
end;

procedure FindFace;
begin
end;

begin
end.
