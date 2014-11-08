{
 Quick Sort Algorithm

 O(NLgN)

 Input:
  A: Array of integer
  L, R: The range to be sorted
 Output:
  Ascending sorted list
 Notes:
  L must be <= R

 Reference:
  TAOCP

 By Knuth
}

procedure Sort(l, r: Integer);
var
  i, j, x, y: integer;
begin
  i := l; j := r; x := a[(l+r) DIV 2];
  repeat
    while a[i] < x do i := i + 1;
    while x < a[j] do j := j - 1;
    if i <= j then
    begin
      y := a[i]; a[i] := a[j]; a[j] := y;
      i := i + 1; j := j - 1;
    end;
  until i > j;
  if l < j then Sort(l, j);
  if i < r then Sort(i, r);
end;

