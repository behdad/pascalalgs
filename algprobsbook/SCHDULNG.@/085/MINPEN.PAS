{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
April '2000
Problem 85  O(N3) Weighted Matching Method Hungarian Alg.
}
program
  MinimumPenaltyScheduling;

const
  MaxN = 100;

var
  N, L : Integer;
  G : array [1 .. MaxN, 1 .. MaxN] of Integer;
  W, D : array [1 .. MaxN] of Integer;
  Mark : array [1 .. 2, 0 .. MaxN] of Boolean;
  C, Match : array [1 .. 2, 1 .. MaxN] of Integer; {Match}
  P : Longint;
  Size : Integer;

  I, J, E : Integer;

procedure ReadInput;
begin
  Assign(Input, 'input.txt');
  Reset(Input);
  Readln(Input, L, N);
  for I := 1 to N do
    Readln(W[I], D[I]);
  Close(Input);
end;

procedure WriteOutput;
begin
  Assign(Output, 'output.txt');
  Rewrite(Output);
  Writeln(P);
  for I := 1 to N do
    Writeln(L * Match[1, I]);
  Close(Output);
end;

function  Max (A, B : Integer) : Integer;
begin
  if A >= B then Max := A else Max := B;
end;

function  Min (A, B : Integer) : Integer;
begin
  if A <= B then Min := A else Min := B;
end;

function  Dfs (V : Integer) : Boolean;
var
  I : Integer;
begin
  if V = 0 then
  begin
    Dfs := True;
    Exit;
  end;
  Mark[1, V] := True;
  for I := 1 to N do
    if (C[1, V] + C[2, I] = G[V, I]) then
    begin
      Mark[2, I] := True;
      if not Mark[1, Match[2, I]] {c}and Dfs(Match[2, I]) then
      begin
        Match[2, I] := V;
        Match[1, V] := I;
        Dfs := True;
        Exit;
      end;
    end;
  Dfs := False;
end;

procedure Assignment;
begin
  for I := 1 to N do {Making graph}
    for J := 1 to N do
    begin
      G[I, J] := - Max(0, (J * L - D[I]) * W[I]);
      if C[1, I] < G[I, J] then
        C[1, I] := G[I, J];
    end;
  for i := 1 to n do c[1,i]:=4000;
  Size := N;
  repeat
    FillChar(Mark, SizeOf(Mark), 0);
    for I := 1 to N do
      if (Match[1, I] = 0) and Dfs(I) then
      begin
        Dec(Size);
        FillChar(Mark, SizeOf(Mark), 0);
        I := 0;
      end;
    {Update cover}
    E := MaxInt;
    for I := 1 to N do
      if Mark[1, I] then
        for J := 1 to N do
          if not Mark[2, J] then
            E := Min(E, C[1, I] + C[2, J] - G[I, J]);
    if E <> MaxInt then
      for I := 1 to N do
      begin
        if Mark[1, I] then Dec(C[1, I], E);
        if Mark[2, I] then Inc(C[2, I], E);
      end;
  until Size = 0;
  for I := 1 to N do
    Inc(P, G[I, Match[1, I]]);
  P := Abs(P);
end;

begin
  ReadInput;
  Assignment;
  WriteOutput;
end.
