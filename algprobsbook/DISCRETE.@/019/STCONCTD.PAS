{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 16384,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
August '1999
Problem 19  O(N2) 2Dfs Method
}
program
  StronglyConnectedComponents;

const
  MaxN = 100;

var
  N : Integer;
  A, B : array [0 .. MaxN, 0 .. MaxN] of Integer;
  M : array [1 .. MaxN] of Boolean;
  Map : array [1 .. MaxN] of Integer;
  I, J, D, Time : Integer;
  F : Text;

procedure ReadInput;
begin
  Assign(F, 'input.txt');
  Reset(F);
  Readln(F, N);
  for I := 1 to N do
  begin
    for J := 1 to N do
      Read(F, A[I, J]);
    Readln(F);
  end;
  Close(F);
end;

procedure Dfs1 (V : Integer);
var
  I : Integer;
begin
  M[V] := True;
  for I := 1 to N do
    if (A[V, I] = 1) and not M[I] then
      Dfs1(I);
  Inc(Time);
  Map[N + 1 - Time] := V;
end;

procedure Dfs2 (V : Integer);
var
  I : Integer;
begin
  Inc(B[B[0, 0], 0]);
  B[B[0, 0], B[B[0, 0], 0]] := V;
  M[V] := True;
  for I := 1 to N do
    if (A[I, V] = 1) and not M[I] then
      Dfs2(I);
end;

procedure StConnected;
begin
  for I := 1 to N do
    if not M[I] then
      Dfs1(I);

  FillChar(M, SizeOf(M), 0);
  for I := 1 to N do
    if not M[Map[I]] then
    begin
      Inc(B[0, 0]);
      Dfs2(Map[I]);
    end;
end;

procedure WriteOutput;
begin
  Assign(F, 'output.txt');
  ReWrite(F);
  Writeln(F, B[0, 0]);
  for I := 1 to B[0, 0] do
  begin
    for J := 1 to B[I, 0] do
      Write(F, B[I, J], ' ');
    Writeln(F);
  end;
  Close(F);
end;

begin
  ReadInput;
  StConnected;
  WriteOutput;
end.
