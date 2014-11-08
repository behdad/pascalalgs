{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
September '1999
Problem 28  O(N2) Prim Alg.  O(ElgE) Kruskal Alg.
}
program
  MinimumSpanningTree;

const
  MaxN = 120;
  MaxE = 5000;

var
  N, E, L : Integer;
  G : array [1 .. MaxN, 1 .. MaxN] of Integer;
  H : array [0 .. MaxE, 1 .. 3] of Integer;
  M : array [1 .. MaxN] of Boolean;
  A : array [1 .. MaxN - 1, 1 .. 2] of Integer;
  D, P : array [0 .. MaxN] of Integer;
  I, J, K : Integer;
  TT : Longint;
  Time : Longint absolute $40:$6C;
  F : Text;

procedure ReadInput;
begin
  FillChar(G, SizeOf(G), 127);
  Assign(F, 'input.txt');
  Reset(F);
  Readln(F, N, E);
  for I := 1 to E do
  begin
    Readln(F, H[I, 1], H[I, 2], H[I, 3]);
    G[H[I, 1], H[I, 2]] := H[I, 3]; G[H[I, 2], H[I, 1]] := H[I, 3];
  end;
end;

procedure Prim;
  procedure Relax (V : Integer);
  var
    I : Integer;
  begin
    M[V] := True;
    for I := 1 to N do
      if (G[V, I] < D[I]) and not M[I] then
      begin
        D[I] := G[V, I];
        P[I] := V;
      end;
  end;

begin
  TT := Time;
  FillChar(M, SizeOf(M), 0); FillChar(D, SizeOf(D), 127);
  P[1] := 0; D[1] := 0; D[0] := MaxInt; L := 0;
  for K := 1 to N do
  begin
    J := 0;
    for I := 1 to N do if (D[I] < D[J]) and not M[I] then J := I;
    Inc(L, D[J]);
    Relax(J);
  end;
  Writeln('Prim''s Time : ', (Time - TT) / 18.2 : 0 : 2);

  Assign(F, 'mstp.txt');
  ReWrite(F);
  Writeln(F, L);
  for I := 1 to N do if P[I] <> 0 then Writeln(F, P[I], ' ', I);
  Close(F);
end;

procedure Kruskal;
  procedure Sort(l, r: Integer);
  var
    i, j, x : integer;
  begin
    i := l; j := r; x := h[(l+r) DIV 2,3];
    repeat
      while h[i,3] < x do i := i + 1;
      while x < h[j,3] do j := j - 1;
      if i <= j then
      begin
        h[0] := h[i]; h[i] := h[j]; h[j] := h[0];
        i := i + 1; j := j - 1;
      end;
    until i > j;
    if l < j then Sort(l, j);
    if i < r then Sort(i, r);
  end;

  function  Find (V : Integer) : Integer;
  var
    I, J: Integer;
  begin
    I := V;
    while D[I] <> I do I := D[I];
    Find := I;
    while D[V] <> V do begin J := D[V]; D[V] := I; V := J; end;
  end;

begin
  TT := Time;
  L := 0; Sort(1, E);
  for I := 1 to N do D[I] := I;
  J := 0;
  for I := 1 to E do if Find(H[I, 1]) <> Find(H[I, 2]) then
    begin
      Inc(J);
      A[J, 1] := H[I, 1]; A[J, 2] := H[I, 2];
      Inc(L, H[I, 3]);
      D[Find(H[I, 2])] := Find(H[I, 1]);
      if J = N - 1 then
        Break;
    end;
  Writeln('Kruskal''s Time : ', (Time - TT) / 18.2 : 0 : 2);

  Assign(F, 'mstk.txt');
  ReWrite(F);
  Writeln(F, L);
  for I := 1 to N - 1 do Writeln(F, A[I, 1], ' ', A[I, 2]);
  Close(F);
end;

begin
  ReadInput;
  Prim;
  Kruskal;
end.
