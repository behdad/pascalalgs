{
 Binary Search

 O(LgN)

 Input:
  X: Array of elements in ascending sorted order
  L: 1
  R: Number of elements
  Z: Key to find
 Output:
  Return Value: Index of Z in X (-1 = Not Found)

 Reference:
  Creative, p121

 By Ali
}
program
  BinarySearch;

const
  MaxN = 10000 + 2;

var
  X: array [1 .. MaxN] of Integer;

function BSearch(L, R: Integer; Z: Integer): Integer;
var
  Mid: Integer;
begin
  while L < R do
  begin
    Mid := (L + R) div 2;
    if Z > X[Mid] then  L := Mid + 1
    else
      R := Mid;
  end;
  if X[L] = Z then
    BSearch := L
  else
    BSearch := -1;
end;

begin
  Writeln(BSearch(1, 3, 7682));
end.
