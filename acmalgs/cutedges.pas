{
 Cut Edge

 DFS Method  O(N2)

 Input:
  G: Undirected Simple Graph
  N: Number of vertices,
 Output:
  EdgeNum: Nunmber of CutEdges
  EdgeList[i]: CutEdge I

 Reference:
  Creative, p224

 By Ali
}
program
  CutEdge;

const
  MaxN = 100 + 2;

var
  N: Integer;
  G: array[1 .. MaxN, 1 .. MaxN] of Integer;
  EdgeNum: Integer;
  EdgeList: array[1 .. MaxN * MaxN, 1 .. 2] of Integer;

  DfsNum: array[1 .. Maxn] of Integer;
  DfsN: Integer;

function Dfs(V: Integer; Parent: Integer) : Integer;
var
  I, J, Hi: Integer;
begin
  DfsNum[V] := DfsN;
  Dec(DfsN);
  Hi := DfsNum[V];
  for I := 1 to N do
    if (G[V, I] <> 0) and (I <> Parent) then
      if DfsNum[I] = 0 then
      begin
        J := Dfs(I, V);
        if J <= DfsNum[I] then
        begin
          Inc(EdgeNum);
          EdgeList[EdgeNum, 1] := V;
          EdgeList[EdgeNum, 2] := I;
        end;
        if Hi < J then
          Hi := J;
      end
      else
        if Hi < DfsNum[I] then
          Hi := DfsNum[I];
  Dfs := Hi;
end;

procedure CutEdges;
var
  I: Integer;
begin
  FillChar(DfsNum, SizeOf(DfsNum), 0);
  DfsN := N;
  EdgeNum := 0;
  for I := 1 to N do
    if DfsNum[I] = 0 then
      Dfs(I, 0); {I == Root of tree}
end;

begin
  CutEdges;
end.
