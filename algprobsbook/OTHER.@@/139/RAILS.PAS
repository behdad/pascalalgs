{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
April '2000
Problem 139  O(E) Bfs Method
}
program
  RailsNetwork;

const
  MaxN = 100;
  MaxE = 3 * MaxN;

var
  N, S, T : Integer;
  G : array [1 .. MaxN, 0 .. MaxN + 1] of Integer;
  D : array [1 .. MaxN] of Integer;
  Mark, P : array [1 .. MaxN, 1 .. MaxN] of Integer;
  Q : array [1 .. MaxE + 2, 1 .. 2] of Integer;
  QL, QR : Integer;

  I, J, K, U, V : Integer;

procedure ReadInput;
begin
  Assign(Input, 'input.txt');
  Reset(Input);
  Readln(N, T, S);
  for I := 1 to N do
  begin
    while not SeekEoln do
    begin
      Read(J);
      Inc(D[I]);
      G[I, D[I]] := J;
    end;
    G[I, 0] := G[I, D[I]];
    G[I, D[I] + 1] := G[I, 1];
    Readln;
  end;
end;

procedure WriteOutput;
begin
  Assign(Output, 'output.txt');
  Rewrite(Output);
  K := U;
  J := T;
  Writeln(Mark[K, J] + 1);
  Write(J);
  while J <> S do
  begin
    Write(' ', K);
    I := K;
    K := P[K, J];
    J := I;
  end;
  Writeln;
  Close(Output);
end;

procedure Bfs;
begin
  for I := 1 to D[S] do
  begin
    Inc(QR);
    Q[QR, 1] := S;
    Q[QR, 2] := G[S, I];
    Mark[S, I] := 1;
  end;
  while QL < QR do
  begin
    Inc(QL);
    U := Q[QL, 1];
    V := Q[QL, 2];
    if V = T then
      Break;
    for I := 1 to D[V] do
      if G[V, I] = U then
        Break;
    for J := -1 to 1 do
      if J <> 0 then
        if Mark[V, G[V, I + J]] = 0 then
        begin
          Mark[V, G[V, I + J]] := Mark[U, V] + 1;
          P[V, G[V, I + J]] := U;
          Inc(QR);
          Q[QR, 1] := V;
          Q[QR, 2] := G[V, I + J];
        end;
  end;
end;

begin
  ReadInput;
  Bfs;
  WriteOutput;
end.
