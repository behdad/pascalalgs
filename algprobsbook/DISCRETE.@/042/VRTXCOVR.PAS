{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 16384,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
September '1999
Problem 42  BackTrack Method with an Initial Greedy and a Dynamic Method Bound
}
program
  VertexCover;

const
  MaxN = 100;

var
  N, E : Integer;
  G, Dyn2 : array [1 .. MaxN, 1 .. MaxN] of Integer;
  A, BA, M : array[1 .. MaxN] of Boolean;
  L, BL : Integer;
  D, Ds, Map, Dyn : array[1 .. MaxN] of Integer;
  I, J, K, P, Q, R, S : Integer;
  Fl : Boolean;
  F : Text;
  C : Longint;
  TT : Longint;
  Time : Longint absolute $40:$6C;

procedure CalcDs;
var
  I, J : Integer;
begin
  FillChar(D, SizeOf(D), 0);
  for I := 1 to N do
    if not A[I] then
      for J := 1 to I - 1 do
        if not A[J] then
          if G[I, J] > 0 then
          begin
            Inc(D[I]); Inc(D[J]);
          end;
end;

procedure Greedy;
begin
  FillChar(A, SizeOf(A), 0);
  L := 0;
  repeat
    Fl := True;
    P := 0;
    for I := 1 to N do
      if not A[I] then
      for J := 1 to I - 1 do
        if not A[J] then
          if (G[I, J] = 1) and (P < D[I] + D[J] + 1) then
          begin
            Q := I; R := J; P := D[I] + D[J] - 1;
          end;
    if P <> 0 then
    begin
      Fl := False;
      if D[Q] < D[R] then begin S := Q; Q := R; R := S; end;
      Inc(L);
      A[Q] := True;
      if P > D[Q] then
      begin
        Inc(L);
        A[R] := True;
      end;
    end;
    CalcDs;
  until Fl;
end;

procedure Sort(l, r: Integer);
var
  i, j, x, y: integer;
begin
  i := l; j := r; x := ds[map[(l+r) DIV 2]];
  repeat
    while ds[map[i]] > x do i := i + 1;
    while x > ds[map[j]] do j := j - 1;
    if i <= j then
    begin
      y := map[i]; map[i] := map[j]; map[j] := y;
      i := i + 1; j := j - 1;
    end;
  until i > j;
  if l < j then Sort(l, j);
  if i < r then Sort(i, r);
end;

procedure BT (V : Integer);
var
  I : Integer;
  Fl : Boolean;
begin
  Inc(C);
  if V = N + 1 then
  begin
    BL := L; BA := A;
    Exit;
  end;
  Fl := True;
  for I := 1 to V - 1 do
    if not A[Map[I]] and (G[Map[V], Map[I]] <> 0) then
    begin
      Fl := False;
      Break;
    end;
  if Fl and (L + Dyn[V] < BL - 1) then BT(V + 1);
  if L + Dyn[V + 1] >= BL - 1 then Exit;
  Inc(L); A[Map[V]] := True;
  BT(V + 1);
  Dec(L); A[Map[V]] := False;
end;

procedure Dynamic;
begin
  for I := N downto 1 do
    for J := N downto I + 1 do
    begin
      Dyn2[I, J] := Dyn2[I + 1, J - 1] + G[I, J];
      if Dyn2[I, J] < Dyn2[I + 1, J] then
        Dyn2[I, J] := Dyn2[I + 1, J];
      if Dyn2[I, J] < Dyn2[I, J - 1] then
        Dyn2[I, J] := Dyn2[I, J - 1];
      for K := I + 1 to J - 1 do
      begin
        if G[Map[I], Map[K]] <> 0 then
          if Dyn2[I, J] < 1 + Dyn2[I + 1, K - 1] + Dyn2[K + 1, J] then
            Dyn2[I, J] := 1 + Dyn2[I + 1, K - 1] + Dyn2[K + 1, J];
        if G[Map[K], Map[J]] <> 0 then
          if Dyn2[I, J] < 1 + Dyn2[I, K - 1] + Dyn2[K + 1, J - 1] then
            Dyn2[I, J] := 1 + Dyn2[I, K - 1] + Dyn2[K + 1, J - 1];
      end;
    end;
  for I := 1 to N do
    Dyn[I] := Dyn2[I, N];
end;

procedure Solve;
begin
  for I := 1 to N do Map[I] := I;
  Sort(1, N);
  Greedy;
  BA := A; BL := L;
  Dynamic;
  FillChar(A, SizeOf(A), 0); L := 0;
  BT(1);
end;

procedure ReadInput;
begin
  TT := Time;
  Assign(F, 'input.txt');
  Reset(F);
  Readln(F, N, E);
  for I := 1 to E do
  begin
    Readln(F, J, K);
    G[J, K] := 1; G[K, J] := 1;
    Inc(D[J]); Inc(D[K]);
  end;
  Ds := D;
  Close(F);
end;

procedure WriteOutput;
begin
  Assign(F, 'output.txt');
  ReWrite(F);
  Writeln(F, BL);
  for I := 1 to N do
    if BA[I] then
      Write(F, I, ' ');
  Writeln(F);
  Close(F);
  Writeln((Time - TT) / 18.2 : 0 : 2, ' ', C);
end;

begin
  ReadInput;
  Solve;
  WriteOutput;
end.
