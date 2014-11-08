{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 65520,0,655360}
{by Behdad Esfahbod  Geometry Exam}
program
  ProblemB;

type
  Real = Extended;

const
  MaxNum = 100;
  Epsilon = 1E-7;
  Pi = 3.1415926536;

type
  TPoly = array [0 .. MaxNum + 1] of record
    Len, Ang : Extended;
  end;
  TPoint = record
    X, Y : Extended;
  end;

var
  M, N : Integer;
  Ps : array [1 .. 2, 1 .. MaxNum] of ^ TPoly;
  Mt : array [1 .. 2, 1 .. MaxNum] of Integer;
  Ans : array [1 .. MaxNum] of Extended;

  T1, T2 : TPoly;
  P1, P2 : TPoint;
  X1, X2, Delta, Coef : Extended;
  I, J, K : Integer;

function D (P1, P2 : TPoint) : Extended;
begin
  D := Sqrt(Sqr(P1.X - P2.X) + Sqr(P1.Y - P2.Y));
end;

function Comp (A, B : Extended) : Extended;
begin
  if Abs(A - B) < Epsilon then
    Comp := 0
  else
    if A < B then
      Comp := -1
    else
      Comp := 1;
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
  A := An;
end;

procedure ReadInput;
begin
  Assign(Input, 'polyg.dat');
  Reset(Input);
  Readln(M, N);
  Delta := 2 * Pi / N;
  for I := 1 to M do
  begin
    for J := 1 to N do
      Read(T1[J].Len);
    Readln;
    T1[N + 1] := T1[1];
    X1 := Pi / 2;
    P1.X := 0; P1.Y := T1[1].Len;
    for J := 1 to N do
    begin
      X2 := X1;
      X1 := X1 - Delta;
      if Comp(X1, 0) < 0 then X1 := X1 + 2 * Pi;
      P2 := P1;
      P1.X := T1[J + 1].Len * Cos(X1);
      P1.Y := T1[J + 1].Len * Sin(X1);
      T2[J].Len := D(P2, P1);
      T2[J].Ang := A(P2, P1);
    end;
    T2[0] := T2[N];
    New(Ps[1, I]);
    Ps[1, I]^ := T2;
  end;
  for I := 1 to M do
  begin
    for J := 1 to N do
      Read(T1[J].Len, T1[J].Ang);
    Readln;
    T1[N + 1] := T1[1];
    P1.X := T1[1].Len;
    P1.Y := T1[1].Ang;
    for J := 1 to N do
    begin
      P2 := P1;
      P1.X := T1[J + 1].Len;
      P1.Y := T1[J + 1].Ang;
      T2[J].Len := D(P2, P1);
      T2[J].Ang := A(P2, P1);
    end;
    T2[0] := T2[N];
    New(Ps[2, I]);
    Ps[2, I]^ := T2;
  end;
  Close(Input);
end;

function ValidAng (X : Extended) : Extended;
begin
  if Comp(X, 2 * Pi) >= 0 then
    ValidAng := X - 2 * Pi
  else
    if Comp(X, 0) < 0 then
      ValidAng := X + 2 * Pi
    else
      ValidAng := X;
end;

function Same (var A, B : TPoly) : Boolean;
var
  I, J : Integer;
  Fl : Boolean;
begin
  for K := 0 to N - 1 do
  begin
    Fl := True;
    J := K;
    Delta := ValidAng(B[K].Ang - A[0].Ang);
    Coef := B[K].Len / A[0].Len;
    for I := 0 to N - 1 do
    begin
      if (Comp(A[I].Len * Coef, B[J].Len) <> 0) or
         (Comp(ValidAng(A[I].Ang + Delta), B[J].Ang) <> 0) then
      begin
        Fl := False;
        Break;
      end;
      J := (J + 1) mod N;
    end;
    if Fl then
    begin
      X1 := Delta;
      Same := True;
      Exit;
    end;
  end;
  Same := False;
end;

procedure Match;
begin
  for I := 1 to M do
    for J := 1 to M do
      if (Mt[2, J] = 0) and Same(Ps[1, I]^, Ps[2, J]^) then
      begin
        Ans[J] := X1 * 180 / Pi;
        if Comp(Ans[J], 0) = 0 then
          Ans[J] := 0.0;
        Mt[1, I] := J;
        Mt[2, J] := I;
        Break;
      end;
end;

procedure WriteOutput;
begin
  Assign(Output, 'polyg.out');
  ReWrite(Output);
  for J := 1 to M do
    Writeln(Mt[2, J], ' ', Ans[J] : 0 : 2);
  Close(Output);
end;

begin
  ReadInput;
  Match;
  WriteOutput;
end.
