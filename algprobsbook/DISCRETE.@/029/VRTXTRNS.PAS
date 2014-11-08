{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
September '1999
Problem 29  Backtrack Method
}
program
  VertexTransitivity;

const
  MaxN = 100;

var
  N : Integer;
  G : array [1 .. MaxN, 1 .. MaxN] of Integer;
  M : array [1 .. MaxN, 1 .. MaxN] of Boolean;
  D, P : array [1 .. MaxN] of Integer;
  I, J, T, L : Integer;
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
      Read(F, G[I, J]); G[J, I] := G[I, J];
      Inc(D[I], G[I, J]); Inc(D[J], G[I, J]);
    end;
    Readln(F);
  end;
  Close(F);
end;

procedure NonVT;
begin
  Writeln('Graph is not vertex transitive.');
  Halt;
end;

procedure Swap (A, B : Integer);
begin T := P[A]; P[A] := P[B]; P[B] := T; end;

procedure Found;
var
  A : Integer;

begin
  Fl := True;
  for A := 1 to N do
    if P[P[A]] = A then
    begin M[A, P[A]] := True; M[P[A], A] := True; end;
end;

procedure BT (V : Integer);
var
  K : Integer;
begin
  if (V = I) or (V = J) then BT(V + 1);
  if V > N then begin Found; Exit; end;
  for K := N downto V do if (K <> I) and (K <> J) then
    begin
      Swap(V, K);
      for L := 1 to V do if G[L, V] <> G[P[L], P[V]] then Break;
      if L = V then BT(V + 1);
      Swap(V, K);
      if Fl then Exit;
    end;
end;

procedure Solve;
begin
  for I := 1 to N do if D[I] <> D[1] then NonVT;
  for I := 1 to N do P[I] := I;
  for I := 1 to N do
    for J := 1 to I - 1 do
      if not M[I, J] then
      begin
        Fl := False;
        Swap(I, J);
        BT(1);
        if not Fl then
          NonVT;
        Swap(I, J);
      end;
  Writeln('Graph is vertex transitive.');
end;

begin
  ReadInput;
  Solve;
end.
