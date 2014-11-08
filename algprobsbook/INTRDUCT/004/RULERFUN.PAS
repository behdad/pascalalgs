{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
August '1999
Problem 4  O(2^N) Recursive Method
}
program
  RulerFunction;

const
  MaxN = 10;

var
  N : Integer;
  A, B : array [0 .. MaxN] of Integer;
  I, P : Integer;
  F : Text;

function  Ruler (L, R, K, Add : Integer) : Integer;
var
  G, J : Integer;
begin
  if K = 0 then
  begin
    Ruler := 0;
    Exit;
  end;
  if L > R then
  begin
    G := Ruler(L, R, K - 1, 0);
    Write(F, K, ' ');
    Ruler := 2 * Ruler(L, R, K - 1, 0) + 1;
    Exit;
  end;
  G := 0;
  for P := L to R do
    if A[P] > A[G] then
      G := P;
  if A[G] = K then
  begin
    J := Ruler(L, G - 1, K - 1, Add);
    Write(F, K, ' ');
    B[G] := J + Add + 1;
    Ruler := J + 1 + Ruler(G + 1, R, K - 1, Add + J + 1);
  end
  else
  begin
    J := Ruler(L, R, K - 1, Add);
    Write(F, K, ' ');
    Ruler := J + 1 + Ruler(R + 1, R, K - 1, Add + J + 1);
  end;
end;

begin
  Assign(F, 'input.txt');
  Reset(F);
  Readln(F, N);
  for I := 1 to N do
    Read(F, A[I]);
  Close(F);
  Assign(F, 'output.txt');
  Rewrite(F);

  Ruler(1, N, N, 0);

  Writeln(F);
  for I := 1 to N do
    Write(F, B[I], ' ');
  Close(F);
end.
