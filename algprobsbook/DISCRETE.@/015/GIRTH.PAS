{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
August '1999
Problem 15  O(N3) Bfs Method
}
program
  GirthOfGraph;

const
  MaxN = 100;

var
  N, V : Integer;
  A : array [1 .. MaxN, 1 .. MaxN] of Integer;
  Q, P, D, Gir : array [1 .. MaxN] of Integer;
  M : array [1 .. MaxN] of Boolean;
  I, J, K, L, R, G : Integer;
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

procedure Girth;
begin
  G := MaxInt;
  for V := 1 to N do
  begin
    FillChar(M, SizeOf(M), 0);
    L := 1; R := 1; Q[1] := V; M[V] := True; D[V] := 0;
    while L <= R do
    begin
      if D[Q[L]] > (G - 1) div 2 then Break;
      for I := 1 to N do
        if (A[I, Q[L]] = 1) then
          if not M[I] then
          begin
            Inc(R);
            Q[R] := I;
            M[I] := True;
            P[I] := Q[L];
            D[I] := D[Q[L]] + 1;
          end
          else
            if (D[Q[L]] + D[I] + 1 < G) and (I <> P[Q[L]]) then
            begin
              G := D[Q[L]] + D[I] + 1;
              K := Q[L];
              for J := D[Q[L]] + 1 downto 1 do
              begin
                Gir[J] := K;
                K := P[K];
              end;
              K := I;
              for J := D[Q[L]] + 2 to D[Q[L]] + 1 + D[I] do
              begin
                Gir[J] := K;
                K := P[K];
              end;
            end;
      Inc(L);
    end;
  end;
end;

procedure WriteOutput;
begin
  Assign(F, 'output.txt');
  ReWrite(F);
  Writeln(F, G);
  for I := 1 to G do
    Write(F, Gir[I], ' ');
  Close(F);
end;

begin
  ReadInput;
  Girth;
  WriteOutput;
end.
