{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 65520,0,655360}
{
by Behdad Esfahbod
Algorithmic Problems Book
September '1999
Problem 25  O(N2) Dfs Method
}
program
  DiameterOfTree;

const
  MaxN = 10000;

type
  TArr = array [1 .. MaxN] of Integer;

var
  N, E : Integer;
  A : array [1 .. MaxN, 1 .. 2] of Integer;
  L : array [1 .. MaxN] of Integer;
  C1, C2, H : ^ TArr;
  I, J, K, X, Y, Z, D, D1, D2 : Integer;
  F : Text;

procedure ReadInput;
begin
  Assign(F, 'input.txt');
  Reset(F);
  Readln(F, N);
  GetMem(H, SizeOf(H^[1]) * N);
  GetMem(C1, SizeOf(C1^[1]) * N); GetMem(C2, SizeOf(C2^[1]) * N);
  for I := 1 to N - 1 do
    Readln(F, A[I, 1], A[I, 2]);
  Close(F);
end;

procedure Dfs (V : Integer);
begin
  L[V] := V; H^[V] := 0;
  for X := 1 to N - 1 do begin C1^[V] := X;
    for Y := 1 to 2 do begin C2^[V] := Y;
      if (A[X, Y] = V) and (L[A[X, 3 - Y]] = 0) then
      begin
        Dfs(A[X, 3 - Y]);
        K := A[C1^[V], 3 - C2^[V]];
        if H^[V] + H^[K] + 1 > D then
        begin D := H^[V] + H^[K] + 1; D1 := L[V]; D2 := L[K]; end;
        if H^[V] < H^[K] + 1 then
        begin H^[V] := H^[K] + 1; L[V] := L[K]; end;
      end;
      Y := C2^[V];
    end;
    X := C1^[V];
  end;
end;

procedure WriteOutput;
begin
  Assign(F, 'output.txt');
  ReWrite(F);
  Writeln(F, 'Diameter = ', D);
  Writeln(F, D1, ' ', D2);
  Close(F);
end;

begin
  ReadInput;
  Dfs(1);
  WriteOutput;
end.
