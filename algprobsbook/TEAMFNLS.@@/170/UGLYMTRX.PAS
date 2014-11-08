{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 16384,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
April '2000
Problem 170  O(N4) Matching Method FordFulkerson Alg.
}
program
  UglyMatrix;

const
  MaxN = 100;

type
  TM = array [1 .. MaxN] of Integer;

var
  N, M : Integer;
  G : array [1 .. MaxN, 1 .. MaxN] of Integer;
  Mt : array [1 .. 2] of TM;
  Ans : array [1 .. MaxN] of TM;
  Mark : array [0 .. MaxN] of Boolean;

  I, J, K : Integer;

procedure ReadInput;
begin
  Assign(Input, 'input.txt');
  Reset(Input);
  Readln(N, M);
  for I := 1 to N do
  begin
    for J := 1 to M do
    begin
      Read(K);
      Inc(G[J, K]);
    end;
    Readln;
  end;
  Close(Input);
end;

procedure WriteOutput;
begin
  Assign(Output, 'output.txt');
  Rewrite(Output);
  for I := 1 to N do
  begin
    for J := 1 to M do
      Write(Ans[I, J], ' ');
    Writeln;
  end;
  Close(Output);
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
  Mark[V] := True;
  for I := 1 to M do
    if (G[V, I] <> 0) and not Mark[Mt[2, I]] and Dfs(Mt[2, I]) then
    begin
      Dfs := True;
      Mt[2, I] := V;
      Mt[1, V] := I;
      Exit;
    end;
  Dfs := False;
end;

procedure Matching;
var
  I : Integer;
begin
  FillChar(Mark, SizeOf(Mark), 0);
  FillChar(Mt, SizeOf(Mt), 0);
  for I := 1 to M do
    if (Mt[1, I] = 0) and Dfs(I) then
    begin
      FillChar(Mark, SizeOf(Mark), 0);
      I := 0;
    end;
end;

procedure BipartiteEdgeColor;
begin
  for I := 1 to N do
  begin
    Matching;
    Ans[I] := Mt[1];
    for J := 1 to M do
      Dec(G[J, Mt[1, J]]);
  end;
end;

begin
  ReadInput;
  BipartiteEdgeColor;
  WriteOutput;
end.
