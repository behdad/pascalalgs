{
 Union-Find Data Structure

 Operations:
  Init(N): Initialize list for use with N records
  Union(X, Y): Merge groups of X and Y
  Find(X): Return the group of a X

 Reference:
  Creative, p80-83

 By Ali
}
program
  UnionFind;

const
  MaxN = 10000 + 2;

var
  List: array[1 .. MaxN] of record
    P: Integer; {Parent (= 0 for roots)}
    S: Integer; {Size of group (= 0 for non-roots)}
  end;

procedure Init(N: Integer);
var
  i: Integer;
begin
  FillChar(List, SizeOf(List), 0);
  for i := 1 to N do
    List[i].S := 1;
end;

function Find(a: Integer): Integer;
var
  i, j: Integer;
begin
  i := a;
  while List[i].P <> 0 do
    i := List[i].p;
  while (a <> i) do
  begin
    j := List[a].P;
    List[a].P := i;
    a := j;
  end;
  Find := i;
end;

procedure Union(a, b: Integer);
var
  i, j: Integer;
begin
  a := Find(a);
  b := Find(b);
  if (a = b) then
    Exit;
  if List[b].S > List[a].S then
  begin
    i := a;  a := b;  b := i;
  end;
  Inc(List[a].S, List[b].S);
  List[b].S := 0;
  List[b].P := a;
end;

begin
  Init(2);
  Union(1, 2);
  Writeln(Find(2));
end.
