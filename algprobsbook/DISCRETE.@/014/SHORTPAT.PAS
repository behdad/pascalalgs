{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
August '1999
Problem 14  O(N2) Bfs Algorithm
}
program
  ShortestPath;

const
  MaxN = 100;

var
  N, U, V : Integer;
  A : array [1 .. MaxN, 1 .. MaxN] of Integer;
  Q, P : array [1 .. MaxN] of Integer;
  M : array [1 .. MaxN] of Boolean;
  I, J, L, R : Integer;
  F : Text;

procedure ReadInput;
begin
  Assign(F, 'input.txt');
  Reset(F);
  Readln(F, N, U, V);
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

procedure Bfs;
begin
  L := 1;
  R := 1;
  Q[1] := V;
  M[V] := True;
  while L <= R do
  begin
    for I := 1 to N do
      if (A[I, Q[L]] = 1) and not M[I] then
      begin
        Inc(R);
        Q[R] := I;
        M[I] := True;
        P[I] := Q[L];
      end;
    Inc(L);
  end;
end;

procedure WriteOutput;
begin
  Assign(F, 'output.txt');
  ReWrite(F);
  I := U;
  J := 1;
  while I <> V do
  begin
    I := P[I];
    Inc(J);
  end;
  Writeln(F, J);
  I := U;
  Write(F, I, ' ');
  while I <> V do
  begin
    I := P[I];
    Write(F, I, ' ');
  end;
  Close(F);
end;

begin
  ReadInput;
  Bfs;
  WriteOutput;
end.