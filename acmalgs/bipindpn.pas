{
 Bipartite Maximum Independent Set

 Matching Method  O(N3)

 Input:
  G: UnDirected Simple Bipartite Graph
  M, N: Number of vertices
 Output:
  I1[I]: Vertex I from first part is in the set
  I2[I]: Vertex I from second part is in the set
  IndSize: Size of independent set

 Reference:
  West

 By Behdad
}
program
  BipartiteMaximumIndependentSet;

const
  MaxNum = 100 + 2;

var
  M, N: Integer;
  G: array [1 .. MaxNum, 1 .. MaxNum] of Integer;
  Mark: array [1 .. MaxNum] of Boolean;
  M1, M2, I1, I2: array [1 .. MaxNum] of Integer;
  IndSize: Integer;

function  ADfs (V : Integer) : Boolean;
var
  I : Integer;
begin
  Mark[V] := True;
  for I := 1 to N do
    if (G[V, I] <> 0)
       and ((M2[I] = 0) or not Mark[M2[I]] and ADfs(M2[I])) then
    begin
      M2[I] := V;
      M1[V] := I;
      ADfs := True;
      Exit;
    end;
  ADfs := False;
end;

procedure BDfs (V : Integer);
var
  I : Integer;
begin
  Mark[V] := True;
  for I := 1 to N do
    if (G[V, I] = 1) and (I2[I] = 1) then
    begin
      I2[I] := 0; I1[M2[I]] := 1;
      BDfs(M2[I]);
    end;
end;

procedure BipIndependent;
var
  I: Integer;
  Fl: Boolean;
begin
  IndSize := M + N;
  FillChar(Mark, SizeOf(Mark), 0);
  repeat
    Fl := True;
    FillChar(Mark, SizeOf(Mark), 0);
    for I := 1 to M do
      if not Mark[I] and (M1[I] = 0) and ADfs(I) then
      begin
        Dec(IndSize);
        Fl := False;
      end;
  until Fl;
  FillChar(I1, SizeOf(I1), 0);
  FillChar(I2, SizeOf(I2), 0);
  FillChar(Mark, SizeOf(Mark), 0);
  for I := 1 to M do if M1[I] = 0 then I1[I] := 1;
  for I := 1 to N do I2[I] := 1;
  for I := 1 to M do
    if M1[I] = 0 then
      BDfs(I);
end;

begin
  BipIndependent;
end.
