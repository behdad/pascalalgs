{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
August '1999
Problem 22  O(N3)? Trivial Method
}
program
  BiPartiteSpanningSubGraph;

const
  MaxN = 100;

var
  N : Integer;
  A : array [1 .. MaxN, 1 .. MaxN] of Integer;
  P, D, Dp : array [1 .. MaxN] of Integer;
  I, J : Integer;
  Fl : Boolean;
  F : Text;

procedure ReadInput;
begin
  Assign(F, 'input.txt');
  Reset(F);
  Readln(F, N);
  for I := 2 to N do
  begin
    for J := 1 to I - 1 do
    begin
      Read(F, A[I, J]); A[J, I] := A[I, J];
      Inc(D[I], A[I, J]); Inc(D[J], A[I, J]);
    end;
    Readln(F);
  end;
  Close(F);
end;

procedure BipSpanTree;
begin
  repeat
    Fl := True;
    for I := 1 to N do
      if Dp[I] < D[I] / 2 then
      begin
        for J := 1 to N do
          if A[I, J] = 1 then
            if P[J] + P[I] = 1 then
              Dec(Dp[J])
            else
              Inc(Dp[J]);
        P[I] := 1 - P[I]; Dp[I] := D[I] - Dp[I];
        Fl := False;
      end;
  until Fl;
end;

procedure WriteOutput;
begin
  Assign(F, 'output.txt');
  ReWrite(F);
  Writeln(F, N);
  for I := 2 to N do
  begin
    for J := 1 to I - 1 do
      if P[I] + P[J] = 1 then
        Write(F, A[I, J], ' ')
      else
        Write(F, 0, ' ');
    Writeln(F);
  end;
  Close(F);
end;

begin
  ReadInput;
  BipSpanTree;
  WriteOutput;
end.
