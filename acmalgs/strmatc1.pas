{
 String Matching - First Match

 K.M.P. Algorithm  O(N)

 Input:
  S: Haystack string
  Q: Needle string
  SL, QL: The length of two strings above
 Output:
  Return Value: Position of first match of Q in S, 0 = Not Found

 Reference:
  Creative, p154

 By Ali
}
program
  StringMatch;

const
  MaxL = 1000 + 1;

var
  S, Q: array[1 .. MaxL] of Char;
  SL, QL: Integer;

  Next: array[1 .. MaxL] of Integer;

procedure ComputeNext;
var
  i, j: Integer;
begin
  Next[1] := -1;
  Next[2] := 0;
  for i := 3 to QL do
  begin
    j := Next[i - 1] + 1;
    while (j > 0) and (Q[i - 1] <> Q[j]) do
      j := Next[j] + 1;
    Next[i] := j;
  end;
end;

function KMP: Integer;
var
  i, j, Start: Integer;
begin
  ComputeNext;
  j := 1;  i := 1; Start := 0;
  while (i <= SL) and (Start = 0) do
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
    if j = QL + 1 then  Start := i - QL;
  end;
  KMP := Start;
end;

begin
  Writeln(KMP);
end.
