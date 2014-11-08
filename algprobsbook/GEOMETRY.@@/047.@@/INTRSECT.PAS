{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q+,R+,S+,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
April '2000
Problem 47  O(1) Box Intersect and Turn Left Alg.
}
program
  TwoSegmentsIntersectSegment;

const
  Epsilon = 1E-5;

type
  TPoint = record
    X, Y : Extended;
  end;
  TSegment = record
    P : array [1 .. 2] of TPoint;
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

function  InRange (A, I, J : Extended) : Boolean;
begin
  InRange := ((Comp(I, A) <= 0) and (Comp(A, J) <= 0)) or
             ((Comp(I, A) >= 0) and (Comp(A, J) >= 0));
end;

function  TurnComp (P1, P2, P3 : TPoint) : Integer;
var
  V2, V3 : TPoint;
begin
  Minus(P2, P1, V2);
  Minus(P3, P1, V3);
  TurnComp := Compare(ExternProd(V2, V3), 0);
end;

function  IsIntersect (S1, S2: TSegment) : Boolean;
begin
  IsIntersect :=
    (    InRange(S1.P[1].X, S2.P[1].X, S2.P[2].X) or
         InRange(S1.P[2].X, S2.P[1].X, S2.P[2].X)    ) and
    (    InRange(S1.P[1].Y, S2.P[1].Y, S2.P[2].Y) or
         InRange(S1.P[2].Y, S2.P[1].Y, S2.P[2].Y)    ) and
    (    InRange(S2.P[1].X, S1.P[1].X, S1.P[2].X) or
         InRange(S2.P[2].X, S1.P[1].X, S1.P[2].X)    ) and
    (    InRange(S2.P[1].Y, S1.P[1].Y, S1.P[2].Y) or
         InRange(S2.P[2].Y, S1.P[1].Y, S1.P[2].Y)    ) and
    (    TurnComp(S1.P[1], S1.P[2], S2.P[1]) *
         TurnComp(S1.P[1], S1.P[2], S2.P[2]) <= 0    ) and
    (    TurnComp(S2.P[1], S2.P[2], S1.P[1]) *
         TurnComp(S2.P[1], S2.P[2], S1.P[2]) <= 0    );
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


var
  A : array [1 .. MaxN, 1 .. MaxN] of Integer;

  I, J : Integer;

procedure ReadInput;
begin
  Assign(Input, 'input.txt');
  Reset(Input);

  Close(Input);
end;

procedure WriteOutput;
begin
  Assign(Output, 'output.txt');
  Rewrite(Output);

  Close(Output);
end;

begin
  ReadInput;

  WriteOutput;
end.
