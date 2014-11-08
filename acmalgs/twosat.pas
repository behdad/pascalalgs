{
 2Satisfiability Problem

 DFS Method  O(N3)

 Input:
  M: Number of clauses
  N: Number of Xs
  Pairs[I]: 1<=I<=M Literals of clause I, -x means ~x (not x)
 Output:
  Value[I]: Value of x[i] in a satisfiability condition
  NoAnswer: System is not satisfiable

 By Behdad
}
program
  TwoSat;

const
  MaxN = 100 + 2;
  MaxM = 100 + 2;

var
  M, N : Integer;
  Pairs : array [1 .. MaxM, 1 .. 2] of Integer;
  Value : array [1 .. MaxN] of Boolean;
  NoAnswer : Boolean;

  Mark, MarkBak: array [1 .. MaxN] of Boolean;

function  DFS (V : Integer) : Boolean;
var
  I, J : Integer;
begin
  if Mark[Abs(V)] then
  begin
    DFS := Value[Abs(V)] xor (V < 0);
    Exit;
  end;
  Mark [Abs(V)] := True;
  Value[Abs(V)] := (V > 0);
  for I := 1 to 2 do
    for J := 1 to M do
      if (Pairs[J, I] = -V) and not DFS(Pairs[J, 3 - I]) then
      begin
        DFS := False;
        Exit;
      end;
  DFS :=  True;
end;

procedure TwoSatisfy;
var
  I: Integer;
begin
  FillChar(Mark,SizeOf(Mark),0);
  MarkBak := Mark;
  NoAnswer := False;
  for I := 1 to N do
    if not Mark[I] then
      if not DFS(-I) then
      begin
        Mark := MarkBak;
        if not DFS(I) then
        begin
          NoAnswer := True;
          Break;
        end;
      end;
end;

begin
  TwoSatisfy;
end.
