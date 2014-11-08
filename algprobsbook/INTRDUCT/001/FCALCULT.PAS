{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
August '1999
Problem 1  O(N) Trivial Method
}
program
  FunctionValueCalculation;

const
  MaxN = 1000;

var
  N, I, J, K : Integer;
  F : array [1 .. MaxN] of Integer;

begin
  Readln(N);

  I := 0;
  J := 0;
  F[1] := 1;
  F[2] := 2;
  while I < N do
  begin
    Inc(J);
    for K := 1 to F[J] do
    begin
      Inc(I);
      F[I] := J;
      if I = N then Break;
    end;
  end;

  Writeln(F[N]);
end.
