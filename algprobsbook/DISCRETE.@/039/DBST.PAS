{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 65520,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
August '1999
Problem 39  BackTrack Method
}
program
  DegreeBoundedSpanningTree;

const
  MaxN = 170 + 1;

var
  N, K : Integer;
  G : array [1 .. MaxN, 1 .. MaxN] of Integer;
  Mark : array [1 .. MaxN] of Boolean;
  Q, D, P, M : array [1 .. MaxN] of Integer;
  QU, QD : Integer;
  I, J : Integer;
  F : Text;
  TT, C : Longint;
  Time : Longint absolute $40:$6C;

procedure Sort(l, r: Integer);
var
  i, j, x, y: integer;
begin
  i := l; j := r; x := d[m[(l+r) DIV 2]];
  repeat
    while d[m[i]] < x do i := i + 1;
    while x < d[m[j]] do j := j - 1;
    if i <= j then
    begin
      y := m[i]; m[i] := m[j]; m[j] := y;
      i := i + 1; j := j - 1;
    end;
  until i > j;
  if l < j then Sort(l, j);
  if i < r then Sort(i, r);
end;

procedure ReadInput;
begin
  Assign(F, 'input.txt');
  Reset(F);
  Readln(F, N, K);
  for I := 2 to N do
  begin
    for J := 1 to I - 1 do
    begin
      Read(F, G[I, J]); G[J, I] := G[I, J];
      Inc(D[I], G[I, J]); Inc(D[J], G[J, I]);
    end;
    Readln(F);
  end;
  Close(F);
end;

procedure NoSolution;
begin
  Assign(F, 'output.txt');
  ReWrite(F);
  Writeln(F, 'No Solution');
  Close(F);
  Writeln((Time - TT) / 18.2 : 0 : 2, ' ', C);
end;

procedure Found;
begin
  Assign(F, 'output.txt');
  ReWrite(F);
  for I := 1 to N do
    if P[I] <> N + 1 then
      Writeln(F, M[P[I]], ' ', M[I]);
  Close(F);
  Writeln((Time - TT) / 18.2 : 0 : 2, ' ', C);
  Halt;
end;

procedure BT (KK, II : Integer);
var
  I, VV : Integer;
begin
  Inc(C);
  VV := Q[QD];

  if QU > QD then
  begin Inc(QD); BT(K - 1, 1); Dec(QD); end;

  if (II <= N) and (KK > 0) then
  begin
    if (P[II] = 0) and (G[M[VV], M[II]] > 0) then
    begin
      P[II] := VV;
      Inc(QU); Q[QU] := II;
      BT(KK - 1, II + 1);
      Dec(QU);
      P[II] := 0;
    end;

    BT(KK, II + 1);
  end;

  if QU = N then Found;
end;

procedure Solve;
begin
  P[1] := N + 1;
  for I := 1 to N do
    M[I] := I;
  QU := 1; QD := 1; Q[1] := 1;
  Sort(1, N);
  BT(K, 1);
end;

begin
  TT := Time;
  ReadInput;
  Solve;
  NoSolution;
end.
