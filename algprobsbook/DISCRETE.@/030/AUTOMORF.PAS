{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
September '1999
Problem 30  Backtrack Method
}
program
  GraphAutoMorphism;

const
  MaxN = 100;

var
  N : Integer;
  G : array [1 .. MaxN, 1 .. MaxN] of Integer;
  DOut, DIn, P : array [1 .. MaxN] of Integer;
  D2 : array [1 .. MaxN] of Longint;
  I, J, T, L : Integer;
  TT : Longint;
  Time : Longint absolute $40:$6C;
  F : Text;

procedure ReadInput;
begin
  Assign(F, 'input.txt');
  Reset(F);
  Readln(F, N);
  for I := 1 to N do
  begin
    for J := 1 to N do
    begin
      Read(F, G[I, J]);
      Inc(DOut[I], G[I, J]); Inc(DIn[J], G[I, J]);
    end;
    Readln(F);
  end;
  Close(F);
  Assign(F, 'output.txt');
  Rewrite(F);
end;

procedure Swap (A, B : Integer);
begin T := P[A]; P[A] := P[B]; P[B] := T; end;

procedure Found;
var
  A : Integer;

begin
  for I := 1 to N do
    Write(F, P[I], ' ');
  Writeln(F);
end;

procedure BT (V : Integer);
var
  K : Integer;
begin
  if V > N then begin Found; Exit; end;
  for K := V to N do if D2[P[V]] = D2[P[K]] then
    begin
      Swap(V, K);
      for L := 1 to V do if (G[L, V] <> G[P[L], P[V]]) or (G[V, L] <> G[P[V], P[L]]) then Break;
      if L = V then BT(V + 1);
      Swap(V, K);
    end;
end;

procedure Solve;
begin
  {$Q-}
  TT := Time;
  for I := 1 to N do
  begin
    Inc(D2[I], 32768 * (DOut[I] + 256 * DIn[I]));
    for J := 1 to N do
      Inc(D2[I], 17 * G[I, J] * (DOut[J] + 3 * DIn[J]) +
                 13 * G[J, I] * (5 * DOut[J] + DIn[J]) );
  end;
  for I := 1 to N do P[I] := I;
  TT := Time;
  BT(1);
  Writeln((Time - TT) / 18.2 : 0 : 2);
end;

begin
  ReadInput;
  Solve;
  Close(F);
end.
