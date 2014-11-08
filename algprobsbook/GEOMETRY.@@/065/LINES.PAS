{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 1024,0,655360}
{
by Behdad Esfahbod
Algorithmic Problems Book
April '2000
Problem 65  O(N2)
}
program
  Lines;

uses
  Graph;

const
  MaxN = 50;

type
  LSeg = array[0 .. 1] of PointType;
  Arr = array [0 .. MaxN] of LSeg;

var
  N : Integer;
  GM, GD : integer;
  P : Arr;
  BestLine : LSeg;
  BestCross : Integer;
  I, J, K, L : integer;
  D1, D2 : Byte;
  TT1, T1, T2 : Integer;
  TT2 : Real;
  Cross : Integer;

procedure ReadInput;
begin
  Assign(Input, 'input.txt');
  Reset(Input);
  Readln(N);
  for I := 1 to N do
    Readln(P[I,0].X, P[I,0].Y, P[I,1].X, P[I,1].Y);
  Close(Input);
  Assign(Input, '');
  Reset(Input);
end;

function  F (L : Integer; D : Integer) : Integer;
begin
  if TT1 = 0 then
    F := P[L, D].X - P[I, D1].X
  else
    F := Trunc(TT2 * (P[L, D].X - P[I, D1].X)) + P[I, D1].Y;
end;

procedure Solve;
begin
  BestCross:=0;
  for I := 1 to N do
    for J := I to N do
      for K := 0 to 3 do
      begin
        D1 := K and 1;
        D2 := K shr 1;
        if I = J then
        begin
          D1 := 0;
          D2 := 1;
          K := 3;
        end;
        TT1 := P[J,D2].X - P[I,D1].X;
        if TT1 <> 0 then
          TT2 := (P[J,D2].Y - P[I,D1].Y) / TT1;
        Cross := 0;
        for L := 1 to N do
        begin
          if (L = I) or (L = J) then
          begin
            Inc(Cross);
            Continue;
          end;
          T1 := P[L, 0].Y - F(L, 0);
          T2 := P[L, 1].Y - F(L, 1);
          if (T1 < 0) and (T2 > 0) then Inc(Cross)
          else if (T1 > 0) and (T2 < 0) then Inc(Cross)
          else if (T1 = 0) or (T2 = 0) then Inc(Cross);
        end;
        if Cross > BestCross then
        begin
          BestCross := Cross;
          BestLine[0].X := I;
          BestLine[0].Y := D1;
          BestLine[1].X := J;
          BestLine[1].Y := D2;
        end;
      end;
end;

procedure Draw;
begin
  GM := Detect;
  InitGraph(Gm, Gd, '');
  Writeln(BestCross);
  for I := 1 to N do
    Line(P[I,0].X, P[I,0].Y, P[I,1].X, P[I,1].Y);
  SetColor(12);
  I := BestLine[0].X;
  D1 := BestLine[0].Y;
  J := BestLine[1].X;
  D2 := BestLine[1].Y;
  TT1 := (P[J, D2].X - P[I, D1].X);
  if TT1 <> 0 then
  begin
    TT2 := (P[J, D2].Y - P[I, D1].Y) / TT1;
    P[0, 0].X := 0;
    P[0, 1].X := 639;
    Line(0, F(0, 0), 639, F(0, 1));
  end
  else
    Line(P[J,D2].X,0,P[J,D2].X,479);
  Readln;
  CloseGraph;
end;

begin
  ReadInput;
  Solve;
  Draw;
end.