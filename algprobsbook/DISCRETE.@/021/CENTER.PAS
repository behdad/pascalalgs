{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
August '1999
Problem 21  O(N3) Bfs Method
}
program
  GraphCenter;

const
  MaxN = 100;

var
  N, V, C, C2 : Integer;
  A : array [1 .. MaxN, 1 .. MaxN] of Integer;
  Q, P : array [1 .. MaxN] of Integer;
  M : array [1 .. MaxN] of Boolean;
  I, J, L, R : Integer;
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
end;

procedure Center;
begin
  C := MaxInt;
  for Q[1] := 1 to N do
  begin
    FillChar(M, SizeOf(M), 0);
    L := 1;
    R := 1;
    M[Q[1]] := True;
    P[Q[1]] := 0;
    while L <= R do
    begin
      for I := 1 to N do
        if (A[I, Q[L]] = 1) and not M[I] then
        begin
          Inc(R);
          Q[R] := I;
          M[I] := True;
          P[I] := P[Q[L]] + 1;
          C2 := P[I];
        end;
      Inc(L);
    end;
    if C2 < C then
    begin
      C := C2; V := Q[1];
    end;
  end;
end;

procedure WriteOutput;
begin
  Assign(F, 'output.txt');
  ReWrite(F);
  Writeln(F, V);
  Writeln(F, C);
  Close(F);
end;

begin
  ReadInput;
  Center;
  WriteOutput;
end.
