{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 16384,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
September '1999
Problem 41  O(N3) Dfs Method
}
program
  DirectingEdges;

const
  MaxN = 100;

var
  N, E : Integer;
  G : array [0 .. MaxN, 1 .. MaxN] of Integer;
  M : array[1 .. MaxN] of Boolean;
  D : array[1 .. MaxN] of Integer;
  I, J, K, L : Integer;
  Fl : Boolean;
  F : Text;

function Dfs (V : Integer) : Boolean;
var
  I : Integer;
begin
  M[V] := True;
  for I := 1 to N do
    if (G[V, I]  + G[I, V] = 1) and not M[I] then
      if Odd(D[I]) or Dfs(I) then
      begin
        Dec(D[V], G[V, I]); Dec(D[I], G[I, V]);
        G[V, I] := 1 - G[V, I]; G[I, V] := 1 - G[I, V];
        Inc(D[V], G[V, I]); Inc(D[I], G[I, V]);
        Dfs := True;
        Exit;
      end;
  Dfs := False;
end;

procedure Solve;
begin
  repeat
    Fl := True;
    for I := 1 to N do
      if Odd(D[I]) then
        Break;
    if I < N then
    begin
      Fl := False;
      FillChar(M, SizeOf(M), 0);
      Dfs(I);
    end;
  until Fl;
end;

procedure ReadInput;
begin
  Assign(F, 'input.txt');
  Reset(F);
  Readln(F, N, E);
  for I := 1 to E do
  begin
    Readln(F, J, K);
    G[J, K] := 1;
    Inc(D[J]);
  end;
  Close(F);
end;

procedure WriteOutput;
begin
  Assign(F, 'output.txt');
  ReWrite(F);
  Writeln(F, N, ' ', E);
  for I := 1 to N do
    for J := 1 to N do
      if G[I, J] > 0 then
        Writeln(F, I, ' ', J);
  Close(F);
end;

begin
  ReadInput;
  Solve;
  WriteOutput;
end.
