{
 Minimum Average Weight Cycle

 Karp Algorithm  O(N3)

 Input:
  G: Directed weighted simple connected graph (No Edge = Infinity)
  N: Number of vertices
 Output:
  MAW: Average weight of minimum cycle
  CycleLen: Length of cycle
  Cycle: Vertices of cycle
  NoAnswer: Graph does not have directed cycle (NoAnswer->MAW = Infinity)

 Note:
  G should be connected

 Reference:
  CLR

 By Behdad
}
program
  MinimumAverageWeightCycle;

const
	MaxN = 100 + 2;
  Infinity = 10000;

var
	N: Integer;
  G, P, Ans: array [0 .. MaxN, 0 .. MaxN] of Integer;
  MAW : Extended;
  CycleLen: Integer;
  Cycle: array [1 .. MaxN] of Integer;
  NoAnswer : Boolean;


procedure MAWC;
var
  I, J, K, Q, L : Integer;
  S: Integer;
  T, T2: Extended;
  Flag : Boolean;
begin
  for I := 0 to N do
    for J := 0 to N do
      P[I, J] := Infinity;
  S := 1;
  P[S, 0] := 0;
  Ans[S, 0] := S;
  L := 0;
  repeat
    Inc(L);
    Flag := True;
    for I := 1 to N do
      for J := 1 to N do
        if (G[I, J] < Infinity) and (G[I, J] + P[I, L - 1] < P[J, L]) then
        begin
          P[J, L] := G[I, J] + P[I, L - 1];
          Ans[J, L] := I;
          Flag := False;
        end;
  until (L = N) or Flag;

  MAW := Infinity;
  for I := 1 to N do
    if (P[I, N] < Infinity) then
    begin
      T2 := (P[I, N] - P[I, 0]) / N;
      if P[I, 0] >= Infinity then
        T2 := 0;
      L := 0;
      for J := 1 to N - 1 do
        if P[I, J] < Infinity then
        begin
          T := (P[I, N] - P[I, J]) / (N - J);
          if T > T2 then
          begin
            T2 := T;
            L := J;
          end;
        end;
      if T2 < MAW then
      begin
		    MAW := T2;
        Q := I;
      end;
    end;

  FillChar(G[0], SizeOf(G[0]), 0);
  K := Q;
  I := 0;
  L := N;
  J := N;
  while J >= 0 do
  begin
    if G[0, K] = 1 then
    begin
      I := K;
      Break;
    end;
    G[0, K] := 1;
    K := Ans[K, J];
    Dec(J);
  end;
  if I <> 0 then
  begin
    K := Q;
    while K <> I do
    begin
      K := Ans[K, L];
      Dec(L);
    end;
  end;

  CycleLen := 0;
  NoAnswer := MAW >= Infinity;
  if not NoAnswer and (I <> 0) then
  begin
    J := 1;
    T := 0;
    repeat
      G[J, 0] := K;
      Inc(J);
      K := Ans[K, L];
      Dec(L);
    until K = I;
    G[J, 0] := G[1, 0];
    for I := J downto 2 do
    begin
      Inc(CycleLen);
      Cycle[CycleLen] := G[I, 0];
    end;
  end;
end;

begin
  MAWC;
end.
