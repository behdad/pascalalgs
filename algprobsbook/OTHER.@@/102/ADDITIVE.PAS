{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 65520,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
April '2000
Problem 102  Backtrack Method with many Bounds
}
program
  AdditiveChain;

var
  N : Integer;
  BestL, Min : Integer;
  C, BestC : array [1 .. 50] of Word;
  I, J : Integer;

function LogCei (X : Real) : Integer;
begin
  LogCei := Trunc((Ln(X) / Ln(2)) + 1 - 1E-10);
end;

procedure BT (L : Integer);
var
  I, J : Integer;
begin
  if C[L - 1] = N then
  begin
    if L - 1 <= BestL then
    begin
      BestL := L - 1;
      BestC := C;
    end;
    Exit;
  end;
  if BestL = Min then Exit;
  for I := L - 1 downto 1 do
  begin
    if Longint(C[L - 1]) shl (BestL - L) < N then Exit;
    if C[I] <= C[L - 1] div 2 then
      Break;
    for J := I downto 1 do
    begin
      if C[I] + C[J] <= C[L - 1] then Break;
      if C[I] + C[J] > N then Continue;
      C[L] := C[I] + C[J];
      BT(L + 1);
    end;
  end;
end;

procedure Solve;
begin
  BestL := LogCei(N);
  Min := BestL;
  I := N;
  while I <> 0 do
  begin
    Inc(BestL, I mod 2);
    I := I div 2;
  end;
  C[1] := 1;
  C[2] := 2;
  C[3] := 3;
  if BestL > LogCei(N) + 1 then
    BT(4);
  C[3] := 4;
  BT(4);
end;

begin
  Assign(Input, 'input.txt');
  Reset(Input);
  Assign(Output, 'output.txt');
  Rewrite(Output);

  while not Eof do
  begin
    Readln(N);
    Solve;
    for I := 1 to BestL do
      Write(BestC[I], ' ');
    Writeln;
    Writeln;
  end;

  Close(Input);
  Close(Output);
end.
