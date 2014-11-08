{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
September '1999
Problem 37  O(N3) Karp's Algorithm
}
program
  MinimumAverageWeightCycle;

const
	MaxN = 100;
  NoEdge = 10000;

var
	N, S : Integer;
  G, P, Ans : array [0 .. MaxN, 0 .. MaxN] of Integer;
  I, J, K, Q, L : Integer;
  MAWC, T, T2 : Real;
  Flag : Boolean;
  F : Text;

procedure ReadInput;
begin
  Assign(F, 'input.txt');
  Reset(F);
  Readln(F, N);
  FillChar(P, SizeOf(P), 40);
  FillChar(G, SizeOf(G), 127);
  S := 1;
  P[S, 0] := 0;
  Ans[S, 0] := S;
  for I := 1 to N do
  begin
    for J := 1 to N do
     	Read(F, G[I, J]);
    Readln(F);
  end;
  Close(F);
end;

procedure WriteOutput;
begin
  Assign(F, 'output.txt');
  Rewrite(F);
  if MAWC >= 100 then
    Writeln(F, 'The Graph is Acyclic')
  else
  begin
    Writeln(F, MAWC : 0 : 2);
    if I <> 0 then
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
        Writeln(F, G[I, 0]);
        T := T + G[G[I, 0], G[I - 1, 0]];
      end;
      if T / (J - 1) <> MAWC then
      begin
        Writeln(F, 'Error : The Weight Of Cycle is ', T / (J - 1) : 0 : 2);
        Write(#7);
      end;
    end;
  end;
  Close(F);
end;

procedure MinAveWeiCycle;
begin
  L := 0;
  repeat
    Inc(L);
    Flag := True;
    for I := 1 to N do
    begin
      for J := 1 to I - 1 do
      begin
        if (G[I, J] + P[I, L - 1] < P[J, L]) then
        begin
          P[J, L] := G[I, J] + P[I, L - 1];
          Ans[J, L] := I;
          Flag := False;
        end;
        if (G[J, I] + P[J, L - 1] < P[I, L]) then
        begin
          P[I, L] := G[J, I] + P[J, L - 1];
          Ans[I, L] := J;
          Flag := False;
        end;
      end;
    end;
  until (L = N) or Flag;
  MAWC := NoEdge;
  for I := 1 to N do
  begin
    T2 := (P[I, N] - P[I, 0]) / N;
    L := 0;
    for J := 1 to N - 1 do
    begin
      T := (P[I, N] - P[I, J]) / (N - J);
      if T > T2 then
      begin
        T2 := T;
        L := J;
      end;
    end;
    if T2 < MAWC then
    begin
		  MAWC := T2;
      Q := I;
    end;
  end;

  FillChar(G[0], SizeOf(G[0]), 0);
  K := Q; I := 0; L := N; J := L;
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
end;

begin
  ReadInput;
  MinAveWeiCycle;
  WriteOutput;
end.
