{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 16384,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
August '1999
Problem 19  O(N2) Dfs Method
}
program
  BiConnectedComponents;

const
  MaxN = 100;

var
  N : Integer;
  A : array [0 .. MaxN, 0 .. MaxN] of Integer;
  M, B : array [1 .. MaxN] of Boolean;
  S : array [1 .. MaxN] of Integer;
  St : array [1 .. MaxN * MaxN] of Integer;
  StNum : Integer;
  BCCNum : Integer;
  I, J, D, Time, Te : Integer;
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
    end;
    Readln(F);
  end;
  Close(F);
  Assign(F, 'output.txt');
  ReWrite(F);
end;

function  Dfs (V, P : Integer) : Integer;
var
  I, L, T : Integer;
begin
  M[V] := True;
  Inc(Time);
  S[V] := Time;
  L := S[V];
  for I := 1 to N do
    if (A[I, V] = 1) then
      if not M[I] then
      begin
        Inc(StNum);
        St[StNum] := I * 256 + V;
        T := Dfs(I, V);
        if T = S[I] then
        begin
          FillChar(B, SizeOf(B), 0);
          while St[StNum] <> I * 256 + V do
          begin
            B[St[StNum] mod 256] := True; B[St[StNum] div 256] := True;
            Dec(StNum);
          end;
          for Te := 1 to N do
            if B[Te] then
              Write(F, Te , ' ');
          Writeln(F);
          Writeln(F, V, ' ', I);
          Dec(StNum);
          Inc(BCCNum, 2);
        end;
        if T < L then
          L := T;
        B[V] := True; B[I] := True;
      end
      else
        if (I <> P) and (S[I] < L) then
          L := S[I];
  Dfs := L;
end;

procedure BiConnected;
begin
  for I := 1 to N do
    if not M[I] then
    begin
      Dfs(I, 0);
      if STNum > 0 then
        Inc(BCCNum);
      StNum := 0;
    end;
  ReWrite(F);
  FillChar(M, SizeOf(M), 0);
  Writeln(F, BCCNum);
  for I := 1 to N do
    if not M[I] then
    begin
      Dfs(I, 0);
      if STNum = 0 then
        Continue;
      Inc(BCCNum);
      FillChar(B, SizeOf(B), 0);
      while StNum > 0 do
      begin
        B[St[StNum] mod 256] := True; B[St[StNum] div 256] := True;
        Dec(StNum);
      end;
      for Te := 1 to N do
        if B[Te] then
          Write(F, Te , ' ');
      Writeln(F);
    end;
end;

begin
  ReadInput;
  BiConnected;
  Close(F);
end.
