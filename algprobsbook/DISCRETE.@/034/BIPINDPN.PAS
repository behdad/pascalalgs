{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 65520,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
September '1999
Problem 34  O(N^3) Matching Method
}
program
  BipartiteMaximumIndependentSet;

const
  MaxNum = 100;

var
  M, N, K : Integer;
  G : array [1 .. MaxNum, 1 .. MaxNum] of Integer;
  Mark : array [1 .. MaxNum] of Boolean;
  M1, M2, I1, I2 : array [1 .. MaxNum] of Integer;
  I, J : Integer;
  Fl : Boolean;
  F : Text;

procedure ReadInput;
begin
  Assign(F, 'input.txt');
  Reset(F);
  Readln(F, M, N);
  for I := 1 to M do
  begin
    for J := 1 to N do
      Read(F, G[I, J]);
    Readln(F);
  end;
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
end;

procedure BDfs (V : Integer);
var
  I : Integer;
begin
  Mark[V] := True;
  for I := 1 to N do
    if (G[V, I] = 1) and (I2[I] = 1) then
    begin
      I2[I] := -1; I1[M2[I]] := 1;
      BDfs(M2[I]);
    end;
end;

procedure BipIndependent;
begin
  for I := 1 to M do if M1[I] = 0 then I1[I] := 1;
  for I := 1 to N do I2[I] := 1;
  FillChar(Mark, SizeOf(Mark), 0);
  for I := 1 to M do
    if M1[I] = 0 then
      BDfs(I);
end;

procedure WriteOutput;
begin
  Assign(F, 'output.txt');
  ReWrite(F);
  Writeln(F, N + M - K);
  for I := 1 to M do
    if I1[I] = 1 then
      Writeln(F, 1, ' ', I);
  for I := 1 to N do
    if I2[I] = 1 then
      Writeln(F, 2, ' ', I);
  Close(F);
end;

begin
  ReadInput;
  BipMatch;
  BipIndependent;
  WriteOutput;
end.
