{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 16384,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
September '1999
Problem 45  O(N3) Matching Method
}
program
  DrawingGraphWithVerticalAndHorizontalLines;

const
  MaxN = 100 + 1;
  MaxFaces = MaxN div 2 + 5;

var
  Mm, M, N, K : Integer;
  A : array [1 .. MaxFaces, 0 .. MaxN] of Integer;
  G : array [1 .. MaxN, 1 .. MaxN] of Integer;
  Routed : array [1 .. MaxFaces] of Boolean;
  Mark : array [1 .. MaxN] of Boolean;
  Map, Deg : array [0 .. MaxN] of Integer;
  M1, M2 : array [1 .. MaxN] of Integer;
  I, J, P, Q, Pp : Integer;
  Fl : Boolean;
  F : Text;

procedure NoSolution;
begin
  Assign(F, 'output.txt');
  ReWrite(F);
  Writeln(F, 'Drawing is not possible');
  Close(F);
  Halt;
end;

procedure ReadInput;
begin
  Assign(F, 'input.txt');
  Reset(F);
  Readln(F, N, Mm);
  for I := 1 to Mm do
  begin
    Read(F, J);
    while J <> 0 do
    begin
      Inc(Deg[J]);
      Inc(A[I, 0]); A[I, A[I, 0]] := J;
      Read(F, J);
    end;
    A[I, A[I, 0] + 1] := A[I, 1];
    Readln(F);
  end;
end;

procedure MakeGraph;
begin
  M := 0;
  for I := 1 to Mm do
  begin
    Inc(M); P := M;
    if I = 1 then Inc(M, 4);
    Inc(M, A[I, 0] - 1 - 4); Q := M;
    for J := P to Q do
    begin
      for K := 1 to A[I, 0] do
        if Deg[A[I, K]] > 2 then
          G[J, A[I, K]] := 1;
      Map[J] := I;
    end;
  end;
  if M <> N then NoSolution;
end;

function  ADfs (V : Integer) : Boolean;
var
  I : Integer;
begin
  Mark[V] := True;
  for I := 1 to N do
    if (G[V, I] > 0) and ((M2[I] = 0) or not Mark[M2[I]] and ADfs(M2[I])) then
    begin
      M2[I] := V;
      M1[V] := I;
      ADfs := True;
      Exit;
    end;
  ADfs := False;
end;

procedure BipMatch;
begin
  K := 0;
  repeat
    Fl := True;
    FillChar(Mark, SizeOf(Mark), 0);
    for I := 1 to M do
      if not Mark[I] and (M1[I] = 0) and ADfs(I) then
      begin
        Inc(K);
        Fl := False;
      end;
  until Fl;
  if K <> N - 4 then NoSolution;
end;

procedure SetEdge (I, J, K : Integer);
begin
  if G[I, J] + K = 3 then
    NoSolution;
  G[I, J] := K; G[J, I] := K;
end;

procedure Route;
begin
  FillChar(G, SizeOf(G), 0);
  G[A[1, 1], A[1, 2]] := 1;
  K := 0;
  repeat
    Fl := False;
    for I := 1 to Mm do
      if not Routed[I] then
      begin
        for J := 1 to A[I, 0] do
          if G[A[I, J], A[I, J + 1]] <> 0 then
          begin
            Fl := True;
            Break;
          end;
        if Fl then
          Break;
      end;
    if not Fl then Break;
    Routed[I] := True;
    Inc(K);
    Q := G[A[I, J], A[I, J + 1]];
    for Pp := J to J + A[I, 0] do
    begin
      P := (Pp - 1) mod A[I, 0] + 1;
      SetEdge(A[I, P], A[I, P + 1], Q);
      if Map[M2[A[I, P + 1]]] <> I then
        Q := 3 - Q;
    end;
  until K = Mm;
end;

procedure WriteOutput;
begin
  Assign(F, 'output.txt');
  ReWrite(F);
  Writeln(F, 'Drawing is possible');
  for I := 1 to N do
    for J := 1 to I - 1 do
      if G[I, J] <> 0 then
        Writeln(F, J, ' ', I, ' ', Chr(Ord('H') + (G[I, J] - 1) * (Ord('V') - Ord('H'))));
  Close(F);
end;

begin
  ReadInput;
  MakeGraph;
  BipMatch;
  Route;
  WriteOutput;
end.
