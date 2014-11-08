{
 Minimum Spanning Tree

 Prim Algorithm  O(N3)

 Input:
  G: UnDirected weighted graph (Infinity = No Edge)
  N: Number of vertices
 Output:
  Parent: Parent of each vertex in the MST, Parent[1] = 0
  NoAnswer: Has no spanning trees (== Not connected)

 Reference:
  CLR, p509

 By Ali
}
program
  MinimumSpanningTree;

const
  MaxN = 100 + 1;
  Infinity = 10000;

var
  N: Integer;
  G: array[1 .. MaxN, 1 .. MaxN] of Integer;
  Parent: array[1 .. MaxN] of Integer;
  NoAnswer: Boolean;

  Key: array[1 .. MaxN] of Integer;
  Mark: array[1 .. MaxN] of Boolean;

procedure MST;
var
  I, U, Step: Integer;
  Min: Integer;
begin
  for I := 1 to N do
    Key[I] := Infinity;
  FillChar(Mark, SizeOf(Mark), 0);
  Key[1] := 0;
  Parent[1] := 0;
  for Step := 1 to N do
  begin
    Min := Infinity;
    for I := 1 to N do
      if not Mark[i] and (Key[I] < Min) then
      begin
        U := I;
        Min := Key[I];
      end;
    if Min = Infinity then
    begin
      NoAnswer := True;
      Exit;
    end;
    Mark[U] := True;
    for I := 1 to N do
      if not Mark[I] and (Key[I] > G[U, I]) then
      begin
        Key[I] := G[U, I];
        Parent[I] := U;
      end;
  end;
  NoAnswer := False;
end;

begin
  MST;
end.
