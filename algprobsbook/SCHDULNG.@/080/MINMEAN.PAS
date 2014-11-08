{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 16384,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
April '2000
Problem 80  O(NLgN) Greedy Method
}
program
  MinimumMeanTime;

const
  MaxN = 100;

var
  N : Integer;
  T, Map : array [1 .. MaxN] of Integer;
  Mean : Extended;

  I : Integer;

procedure ReadInput;
begin
  Assign(Input, 'input.txt');
  Reset(Input);
  Readln(Input, N);
  for I := 1 to N do
    Readln(T[I]);
  Close(Input);
end;

procedure WriteOutput;
begin
  Assign(Output, 'output.txt');
  Rewrite(Output);
  Writeln(Mean : 0 : 1);
  for I := 1 to N do
    Write(Map[I], ' ');
  Close(Output);
end;

procedure Sort(l, r: Integer);
var
  i, j, x, y: integer;
begin
  i := l; j := r; x := t[map[(l+r) DIV 2]];
  repeat
    while t[map[i]] < x do i := i + 1;
    while x < t[map[j]] do j := j - 1;
    if i <= j then
    begin
      y := map[i]; map[i] := map[j]; map[j] := y;
      i := i + 1; j := j - 1;
    end;
  until i > j;
  if l < j then Sort(l, j);
  if i < r then Sort(i, r);
end;

procedure Greedy;
begin
  for I := 1 to N do
    Map[I] := I;
  Sort(1, N);
  for I := 1 to N do
    Mean := Mean + (N + 1 - I) * T[Map[I]];
  Mean := Mean / N;
end;

begin
  ReadInput;
  Greedy;
  WriteOutput;
end.
