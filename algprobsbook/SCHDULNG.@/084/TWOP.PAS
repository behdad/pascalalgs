{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 16384,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
April '2000
Problem 84  O(N3) Minumum Cut Method FordFulkerson Alg.
}
program
  ProjectOnTwoProcessors;

const
  MaxN = 100;
  MaxD = 100;

var
  N : Integer;
  G : array [1 .. MaxN + 2, 1 .. MaxN + 2] of Integer;
  F : array [1 .. MaxN + 2, 1 .. MaxN + 2] of Integer;
  Mark : array [1 .. MaxN + 2] of Boolean;
  Fl : Boolean;
  P : Longint;

  I, J : Integer;

procedure ReadInput;
begin
  Assign(Input, 'input.txt');
  Reset(Input);
  Readln(Input, N);
  for I := 1 to N do
  begin
    Readln(G[N + 1, I], G[N + 2, I]);
    G[I, N + 1] := G[N + 1, I]; G[I, N + 2] := G[N + 2, I];
  end;
  for I := 2 to N do
  begin
    for J := 1 to I - 1 do
    begin
      Read(G[I, J]);
      G[J, I] := G[I, J];
    end;
    Readln;
  end;
  Close(Input);
end;

procedure WriteOutput;
begin
  Assign(Output, 'output.txt');
  Rewrite(Output);
  Writeln(P);
  for I := 1 to N do
    Writeln(2 - Byte(Mark[I]));
  Close(Output);
end;

function  Min (A, B : Integer) : Integer;
begin
  if A <= B then Min := A else Min := B;
end;

function  Dfs (V, E : Integer) : Integer;
var
  I, Eps : Integer;
begin
  if V = N + 1 then
  begin
    Dfs := E;
    Exit;
  end;
  Mark[V] := True;
  for I := N + 1 downto 1 do
    if not Mark[I] and (F[V, I] < G[V, I]) then
    begin
      Eps := Dfs(I, Min(E, G[V, I] - F[V, I]));
      if Eps > 0 then
      begin
        Inc(F[V, I], Eps);
        F[I, V] := - F[V, I];
        Dfs := Eps;
        Exit;
      end;
    end;
  Dfs := 0;
end;

procedure MinCut;
begin
  while Dfs(N + 2, MaxInt) <> 0 do
    FillChar(Mark, SizeOf(Mark), 0);
  for I := 1 to N + 2 do
    for J := 1 to I - 1 do
      if Mark[I] xor Mark[J] then
        Inc(P, G[I, J]);
end;

begin
  ReadInput;
  MinCut;
  WriteOutput;
end.
