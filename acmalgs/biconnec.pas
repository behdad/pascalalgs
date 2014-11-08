{
 BiConnected Components

 DFS Method  O(N2)

 Input:
  G: UnDirected simple graph
  N: Number of vertices
 Output:
  IsCut[I]: Vertex I is CutVertex
  CompNum: Number of components
  Comp[I]: Vertices in component I
  CompLen[I]: Size of component I

 Reference:
  Creative, p224

 By Ali
}
program
  BiConnectedComponents;

const
  MaxN = 100 + 2;

var
  N: Integer;
  G: array[1 .. MaxN, 1 .. MaxN] of Integer;
  IsCut: array[1 .. MaxN] of Boolean;
  CompNum: Integer;
  Comp: array[1 .. MaxN, 1 .. MaxN] of Integer;
  CompLen: array[1 .. MaxN] of Integer;

  DfsNum: array[1 .. Maxn] of Integer;
  DfsN: Integer;
  Stack: array[1 .. MaxN] of Integer;{** Must be changed to 2dim if we want
                                         to have the edges of a comp.}
  SN: Integer; {Size of stack}

procedure Push(V: Integer);
begin
  Inc(SN);
  Stack[SN] := V;
end;

function Pop: Integer;
begin
  if SN = 0 then
    Pop := -1
  else
  begin
    Pop := Stack[SN];
    Dec(SN);
  end;
end;

function BC(V: Integer; Parent: Integer) : Integer;
var
  I, J, Hi, ChNum: Integer;
begin
  DfsNum[V] := DfsN;
  Dec(DfsN);
  Push(V);
  ChNum := 0;
  Hi := DfsNum[v];
  for I := 1 to N do
    {** insert (v, i) into Stack, each edge will be inserted twice.}
    if (G[V, I] <> 0) and (I <> Parent) then
      if DfsNum[I] = 0 then
      begin
        Inc(ChNum);
        J := BC(I, V);
        if J <= DFSNum[V] then
        begin
          if (Parent <> 0) or (ChNum > 1) then
            IsCut[V] := True;
          Inc(CompNum);
          CompLen[CompNum] := 0;
          repeat
            Inc(CompLen[CompNum]);
            Comp[CompNum, CompLen[CompNum]] := Pop;
            {** and pop all edges }
          until Comp[CompNum, CompLen[CompNum]] = V;
          Push(V);
        end;
        if Hi < J then
          Hi := J;
      end
      else
        if Hi < DFSNum[I] then
          Hi := DFSNum[I];
  BC := Hi;
end;

procedure BiConnected;
var
  I: Integer;
begin
  FillChar(DfsNum, SizeOf(DfsNum), 0);
  FillChar(IsCut, SizeOf(IsCut), 0);
  SN := 0;
  CompNum := 0;
  DfsN := N;
  for I := 1 to N do
    if DfsNum[I] = 0 then
      BC(I, 0);  {I == The root of the DFS tree}
end;

begin
  BiConnected;
end.
