{
 String Matching - All Matches

 K.M.P. Algorithm  O(N)

 Input:
  S: Haystack string
  Q: Needle string
  SL, QL: The length of two strings above
 Output:
  Pos: Index of all occurences of Q in S
  PosNum: Number of occurences of Q in S

 Reference:
  Creative, p154

 By Ali
}
program
  StringAllMatch;

const
  MaxL = 1000 + 1;

var
  S, Q: array[1 .. MaxL] of Char;
  SL, QL: Integer;
  Pos: array[1 .. MaxL] of Integer;
  PosNum: Integer;

  Next: array[1 .. MaxL] of Integer;

procedure ComputeNext;
var
  i, j: Integer;
begin
  Next[1] := -1;
  Next[2] := 0;
  for i := 3 to QL + 1 do
  begin
    j := Next[i - 1] + 1;
    while (j > 0) and (Q[i - 1] <> Q[j]) do
      j := Next[j] + 1;
    Next[i] := j;
  end;
end;

procedure AllKMP;
var
  i, j: Integer;
begin
  ComputeNext;
  PosNum := 0;
  j := 1;  i := 1;
  while (i <= SL) do
  begin
    if S[i] = Q[j] then  begin
      Inc(i);
      Inc(j);
    end
    else  begin
      j := Next[j] + 1;
      if j = 0 then  begin
        j := 1;
        Inc(i);
      end;
    end;
    if j = QL + 1 then
    begin
      Inc(PosNum);
      Pos[PosNum] :=  i - QL;
      j := Next[j] + 1;
      if j = 0 then  begin
        j := 1;
        Inc(i);
      end;
    end;
  end;
end;

begin
  AllKMP;
end.
