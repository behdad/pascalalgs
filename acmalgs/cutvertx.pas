{
 Cut Vertex

 DFS Method  O(N2)

 Input:
  G: Undirected Simple Graph
  N: Number of vertices,
 Output:
  IsCut[i]: Vertex i is a CutVertex.

 Reference:
  Creative, p224

 By Ali
}
program
  CutVertex;

const
  MaxN = 100 + 2;

var
  N: Integer;
  G: array[1 .. MaxN, 1 .. MaxN] of Integer;
  IsCut: array[1 .. MaxN] of Boolean;

var
  DfsNum: array[1..Maxn] of Integer;
  DfsN: Integer;

function BC(V: Integer; Parent: Integer) : Integer;
var
  I, J, ChNum, Hi: Integer;
begin
  DfsNum[V] := DfsN;
  Dec(DfsN);
  ChNum := 0;
  Hi := DFSNum[v];
  for I := 1 to N do
    if (G[V, I] <> 0) and (I <> Parent) then
      if DFSNum[I] = 0 then
      begin
        Inc(ChNum);
        J := BC(I, V);
        if J <= DfsNum[V] then
          if (Parent <> 0) or (ChNum > 1) then
            IsCut[V] := True;
        if Hi < J then
          Hi := J;
      end
      else
        if Hi < DfsNum[I] then
          Hi := DfsNum[I];
  BC := Hi;
end;

procedure CutVertices;
var
  I: Integer;
begin
  FillChar(DfsNum, SizeOf(DfsNum), 0);
  FillChar(IsCut, SizeOf(IsCut), 0);
  DfsN := N;
  for I := 1 to N do
    if DfsNum[I] = 0 then
      BC(I, 0); {I == The root of the DFS tree}
end;

begin
  CutVertices;
end.
