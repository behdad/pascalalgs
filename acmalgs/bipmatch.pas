{
 Maximum Bipartite Matching

 Augmenting Path Alg.  O(N2.E) Implementation O(N4)
 but very near to O(N.E) Implementation O(N3)

 Input:
  G: UnDirected Simple Bipartite Graph
  M, N: Number of vertices
 Output:
  Mt: Match of Each Vertex (0 if not matched)
  Matched: size of matching (number of matched edges)

 Reference:
  West

 By Behdad
}
program
  BipartiteMaximumMatching;

const
  MaxNum = 100 + 2;

var
  M, N : Integer;
  G : array [1 .. MaxNum, 1 .. MaxNum] of Integer;
  Mt : array [1 .. 2, 1 .. MaxNum] of Integer;
  Mark : array [0 .. MaxNum] of Boolean;
  Matched : Integer;

function  MDfs (V : Integer) : Boolean;
var
  I : Integer;
begin
  if V = 0 then begin MDfs := True; Exit; end;
  Mark[V] := True;
  for I := 1 to N do
    if (G[V, I] <> 0) and not Mark[Mt[2, I]] and MDfs(Mt[2, I]) then
    begin
      Mt[1, V] := I;
      Mt[2, I] := V;
      MDfs := True;
      Exit;
    end;
  MDfs := False;
end;

procedure AugmentingPath;
var
  I: Integer;
begin
  FillChar(Mark, SizeOf(Mark), 0);
  FillChar(Mt, SizeOf(Mark), 0);
  for I := 1 to M do
    if (Mt[1, I] = 0) and MDfs(I) then
    begin
      Inc(Matched);
      FillChar(Mark, SizeOf(Mark), 0);
      I := 0;
    end;
end;

begin
  AugmentingPath;
end.
