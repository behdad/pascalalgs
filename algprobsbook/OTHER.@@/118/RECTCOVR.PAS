{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 65520,0,200000}
{
by Behdad Esfahbod
Algorithmic Problems Book
April '2000
Problem 118  Backtrack Method with Many Bounds
}
program
  RectangularCover;

const
  MaxNum  = 20 + 1;
  MaxRect = MaxNum * MaxNum;

type
  Arr1 = array [0 .. MaxNum + 1, 0 .. MaxNum + 1] of Integer;
  Arr4 = array [0 .. MaxNum * MaxNum] of Record I, J : Integer; end;
  Arr6 = array [0 .. MaxRect] of Integer;
  Arr7 = array [0 .. MaxNum * MaxNum] of Integer;
  Arr2 = array [0 .. MaxRect, 1 .. 4] of Integer;
  PArr = ^ Arr3;
  Arr3 = array [1 .. MaxNum, 1 .. MaxNum, 1 .. MaxNum] of Integer;
  Arr5 = array [1 .. MaxRect] of Integer;

var
  M, N, RecN : Integer;
  Mat : Arr1;
  Index : Arr4;
  Ans, BestAns : Arr5;
  Mark : Arr6;
  Mark2 : Arr7;
  Num, BestNum : Integer;
  Rects : Arr2;
  InRectsN : Arr1;
  InRects  : PArr;
  I, J, P, Q, R, S, O : Integer;
  Flag, Flag2 : Boolean;

procedure ReadInput;
begin
  Assign(Input, 'input.txt');
  Reset(Input);
  ReadLn(M, N);
  for I := 1 to M do
    for J := 1 to N do
      Read(Mat[I, J]);
  Close(Input);
end;

procedure WriteOutput;
begin
  Assign(Output, 'output.txt');
  ReWrite(Output);
  if BestNum < MaxInt then
  begin
    Writeln(BestNum);
    for I := 1 to BestNum do
      Writeln(Rects[BestAns[I], 1], ' ', Rects[BestAns[I], 2], ' ',
              Rects[BestAns[I], 3], ' ', Rects[BestAns[I], 4]);
  end;
  Close(Output);
end;

procedure FindRects;
begin
  for I := 1 to M do
    for P := I to M do
    begin
      J := 1;
      while J <= N do
      begin
        Flag := False;
        for R := I to P do
          if Mat[R, J - 1] = 0 then
          begin Flag := True; Break; end;
        if not Flag then Continue;
        Q := J - 1;
        while Flag = True do
        begin
          Inc(Q);
          for R := I to P do
            if Mat[R, Q] = 0 then
            begin Flag := False; Break; end;
        end;
        Dec(Q);
        if Q >= J then
        begin
          Flag := False;
          for R := J to Q do
            if Mat[I - 1, R] = 0 then
            begin Flag := True; Break; end;
          if Flag then
          begin
            Flag := False;
            for R := J to Q do
              if Mat[P + 1, R] = 0 then
              begin Flag := True; Break; end;
            if Flag then
            begin Inc(RecN); Rects[RecN, 1] := I; Rects[RecN, 2] := J; Rects[RecN, 3] := P; Rects[RecN, 4] := Q; end;
          end;
        end;
        J := Q + 2;
      end;
    end;
end;

procedure SortRects;
procedure QSort(l, r: Integer);
function s(o : Integer) : Integer;
begin s := (rects[o,3] - rects[o,1]{ + 1}) * (rects[o,4] - rects[o,2]{ + 1}); end;

var
  i, j, x : integer;
begin
  i := l; j := r; x := s((l+r) DIV 2);
  repeat
    while s(i) > x do i := i + 1;
    while x > s(j) do j := j - 1;
    if i <= j then
    begin
      rects[0] := rects[i]; rects[i] := rects[j]; rects[j] := rects[0];
      i := i + 1; j := j - 1;
    end;
  until i > j;
  if l < j then QSort(l, j);
  if i < r then QSort(i, r);
end;
begin
  QSort(1, RecN);
end;

procedure AssignRects;
begin
   for P := 1 to RecN do
    for I := Rects[P, 1] to Rects[P, 3] do
      for J := Rects[P, 2] to Rects[P, 4] do
         begin Inc(InRectsN[I, J]); InRects^[I, J, InRectsN[I, J]] := P; end;
end;

procedure SortIndexes;
procedure QSort(l, r: Integer);
var
  i, j, x : integer;
begin
  i := l; j := r; x := InRectsN[Index[(l+r) DIV 2].I,Index[(l+r) DIV 2].J];
  repeat
    while InRectsN[Index[i].I,Index[i].J] > x do i := i + 1;
    while x > InRectsN[Index[j].I,Index[j].J] do j := j - 1;
    if i <= j then
    begin
      index[0] := index[i]; index[i] := index[j]; index[j] := index[0];
      i := i + 1; j := j - 1;
    end;
  until i > j;
  if l < j then QSort(l, j);
  if i < r then QSort(i, r);
end;

begin
  P := 0;
  for I := 1 to M do
    for J := 1 to N do
      if Mat[I, J] = 1 then begin Inc(P); Index[P].I := I; Index[P].J := J; end;
  QSort(1, P);
end;

procedure Init;
begin
  New(InRects);
  Mark2[0] := 0;
  RecN := 0;
  Num := 0;
  BestNum := MaxInt;
  FindRects;
  SortRects;
  AssignRects;
  SortIndexes;
end;

procedure Found;
begin
  BestNum := Num;
  Move(Ans, BestAns, Num shl 1 + 4);
end;

procedure BackTrack (L : Integer);
var
  I, TTTT : Integer;

procedure Put;
begin
  Ans[Num] := TTTT;
  for P := Rects[Ans[Num], 1] to Rects[Ans[Num], 3] do
    for Q := Rects[Ans[Num], 2] to Rects[Ans[Num], 4] do
      Dec(Mat[P, Q]);
end;

procedure Pick;
begin
  for P := Rects[Ans[Num], 1] to Rects[Ans[Num], 3] do
    for Q := Rects[Ans[Num], 2] to Rects[Ans[Num], 4] do
      Inc(Mat[P, Q]);
end;

function FindNextPoint : Boolean;
begin
  O := L - 1;
  while (Mat[Index[O].I, Index[O].J] <= 0) and (O > 0) do
    Dec(O);
  FindNextPoint := O > 0;
end;

begin {BackTrack}
  If Num < BestNum - 1 then
  begin
    Inc(Num);
    Mark2[L] := 1;
    for I := 1 to InRectsN[Index[L].I, Index[L].J] do
    begin
      TTTT := InRects^[Index[L].I, Index[L].J, I];
      if (Mark2[Mark[TTTT]] = 0) or (Mark[TTTT] = L) then
      begin
        Mark[TTTT] := L;
        Put;
        if FindNextPoint then
          BackTrack(O)
        else
        begin
          Found;
          Pick;
          Break;
        end;
        Pick;
      end;
    end;
    Mark2[L] :=0;
    Dec(Num);
  end
end;

procedure Solve;
begin
  Init;
  if P > 0 then
    BackTrack(P)
  else
    BestNum := 0;
end;

begin
  ReadInput;
  Solve;
  WriteOutput;
end.