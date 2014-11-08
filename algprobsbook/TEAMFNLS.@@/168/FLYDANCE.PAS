{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
April '2000
Problem 168  O(N2) Dynamic Method
}
program
  FliesDance;

const
  MaxN = 240{100};

var
  N : Integer;
  P, Per : array [0 .. MaxN] of Integer;
  PN : Integer;
  D : array [0 .. 1, 0 .. MaxN] of Extended;
  DN : Integer;
  Pt : array [1 .. MaxN, 1 .. MaxN] of Byte;
  Ans : Extended;

  X, Y : Longint;
  I, J, K : Integer;

procedure ReadInput;
begin
  Readln(N);
end;

procedure WriteOutput;
var
  X : Extended;
begin
  Assign(Output, 'output.txt');
  Rewrite(Output);
  Writeln(N);
  for I := 1 to N do
    Writeln(I, ' ', Per[I]);
  Writeln(Ans : 0 : 0);
  Close(Output);
end;

procedure FindPrimes;
begin
  P[0] := 1;
  for I := 2 to N do
  begin
    for J := PN downto 0 do
      if I mod P[J] = 0 then
        Break;
    if J = 0 then
    begin
      Inc(PN);
      P[PN] := I;
    end;
  end;
end;

procedure Dynamic;
begin
  D[0, 0] := 1; D[1, 0] := 1;
  for I := 1 to N do
    D[DN, I] := 1;
  for I := 1 to PN do
  begin
    DN := 1 - DN;
    for J := 1 to N do
    begin
      Pt[I, J] := 0; D[DN, J] := D[1 - DN, J];
      K := 1; X := P[I];
      while X <= J do
      begin
        if D[DN, J] < D[1 - DN, J - X] * X then
        begin
          D[DN, J] := D[1 - DN, J - X] * X;
          Pt[I, J] := K;
        end;
        X := X * P[I]; Inc(K);
      end;
    end;
  end;
end;

procedure CalcPermutation;
begin
  for I := 1 to N do
    Per[I] := I + 1;
  Ans := 0;
  for I := 1 to N do
    if Ans < D[DN, I] then
    begin
      Ans := D[DN, I];
      J := I;
    end;
  for I := J + 1 to N do
    Per[I] := I;
  I := PN;
  while I > 0 do
  begin
    if (J > 1) and (Pt[I, J] <> 0) then
    begin
      Y := 1;
      for K := 1 to Pt[I, J] do
        Y := Y * P[I];
      Per[J] := J - Y + 1;
      J := J - Y;
    end;
    Dec(I);
  end;
  if N = 1 then
    Per[1] := 1;
end;

begin
  ReadInput;
  FindPrimes;
  Dynamic;
  CalcPermutation;
  WriteOutput;
end.
