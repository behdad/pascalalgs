{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 4096,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
August '1999
Problem 16  O(N2) Dfs Method
}
program
  CutVertexes;

const
  MaxN = 100;

var
  N : Integer;
  A : array [1 .. MaxN, 1 .. MaxN] of Integer;
  M : array [1 .. MaxN] of Boolean;
  S : array [1 .. MaxN] of Integer;
  I, J, D, Time : Integer;
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
  Assign(F, 'output.txt');
  ReWrite(F);
end;

function  Dfs (V, P : Integer) : Integer;
var
  I, Deg, L, T, Fl : Integer;
begin
  Fl := 0;
  M[V] := True;
  Inc(Time);
  S[V] := Time;
  L := S[V];
  Deg := 0;
  for I := 1 to N do
    if (A[I, V] = 1) then
    begin
      Inc(Fl);
      if not M[I] then
      begin
        Inc(Deg);
        T := Dfs(I, V);
        if T < L then
          L := T;
      end
      else
        if (I <> P) then
          if (S[I] < L) then
            L := S[I];
    end;
  if (L = S[V]) and (Fl > 1) then
    Writeln(F, V);
  Dfs := L;
  D := Deg;
end;

procedure CutVertex;
begin
  for I := 1 to N do
    if not M[I] then
      Dfs(I, 0);
end;

begin
  ReadInput;
  CutVertex;
  Close(F);
end.