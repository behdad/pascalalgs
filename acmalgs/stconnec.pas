{
 Strongly Connected Components

 DFS Method  O(N2)

 Input:
  G: Directed simple graph
  N: Number of vertices
 Output:
  CompNum: Number of components.
  Comp[I]: Component number of vertex I.

 Reference:
  CLR, p489

 By Ali
}
program
  StronglyConnectedComponents;

const
  MaxN = 100 + 2;

var
  N: Integer;
  G: array[1 .. MaxN, 1 .. MaxN] of Integer;
  CompNum: Integer;
  Comp: array[1 .. MaxN] of Integer;

var
  Fin: array[1 .. MaxN] of Integer;
  DfsN: Integer;

procedure Dfs(V: Integer);
var
  I: Integer;
begin
  Comp[V] := 1;
  for I := 1 to N do
    if (Comp[I] = 0) and (G[V, I] <> 0) then
      Dfs(I);
  Fin[DfsN] := V;
  Dec(DfsN);
end;

procedure Dfs2(V: Integer);
var
  I: Integer;
begin
  Comp[V] := CompNum;
  for I := 1 to N do
    if (Comp[I] = 0) and (G[I, V] <> 0) then
      Dfs2(I);
end;

procedure StronglyConnected;
var
  I: Integer;
begin
  FillChar(Comp, SizeOf(Comp), 0);
  DfsN := N;
  for I := 1 to N do
    if Comp[I] = 0 then
      Dfs(I);
  FillChar(Comp, SizeOf(Comp), 0);
  CompNum := 0;
  for I := 1 to N do
    if Comp[Fin[I]] = 0 then
    begin
      Inc(CompNum);
      Dfs2(Fin[I]);
    end;
end;

begin
  StronglyConnected;
end.

