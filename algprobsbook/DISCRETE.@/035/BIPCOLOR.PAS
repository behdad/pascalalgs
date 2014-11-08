{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 65520,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
September '1999
Problem 34  O(N^4) Matching Method
}
program
  BipartiteEdgeColoring;

const
  MaxNum = 100;

var
  M, N, K : Integer;
  G, H : array [0 .. MaxNum, 0 .. MaxNum] of Integer;
  Mark : array [1 .. MaxNum] of Boolean;
  M1, M2, D1, D2 : array [0 .. MaxNum] of Integer;
  I, J, C, Delta : Integer;
  Fl : Boolean;
  F : Text;
  TT : Longint;
  Time : Longint absolute $40:$6C;

procedure ReadInput;
begin
  Assign(F, 'input.txt');
  Reset(F);
  Readln(F, M, N);
  for I := 1 to M do
  begin
    for J := 1 to N do
    begin
      Read(F, G[I, J]);
      Inc(D1[I], G[I, J]); Inc(D2[J], G[I, J]);
    end;
    Readln(F);
  end;
  Assign(F, 'output.txt');
  ReWrite(F);
  if M > N then N := M;
  H := G;
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
  FillChar(M1, SizeOf(M1), 0); FillChar(M2, SizeOf(M2), 0);
  repeat
    Fl := True;
    FillChar(Mark, SizeOf(Mark), 0);
    for I := 1 to N do
      if not Mark[I] and (M1[I] = 0) and ADfs(I) then
        Fl := False;
  until Fl;
end;

procedure BipColor;
begin
  for I := 1 to N do
    if D1[I] > Delta then
      Delta := D1[I];
  for I := 1 to N do
    if D2[I] > Delta then
      Delta := D2[I];
  I := N; J := N;
  while (I > 0) or (J > 0) do
  begin
    while D1[I] = Delta do Dec(I);
    while D2[J] = Delta do Dec(J);
    Inc(G[I, J]); Inc(D1[I]); Inc(D2[J]);
  end;
  for C := Delta downto 1 do
  begin
    BipMatch;
    for I := 1 to N do
      if M1[I] > 0 then
      begin
        Dec(G[I, M1[I]]);
        if H[I, M1[I]] > 0 then
          Writeln(F, I, ' ', M1[I], ' ', C);
      end;
  end;
end;

begin
  ReadInput;
  TT := Time;
  BipColor;
  Writeln((Time - TT) / 18.2 : 0 : 2);
  Close(F);
end.
