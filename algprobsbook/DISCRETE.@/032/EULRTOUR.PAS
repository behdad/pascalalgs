{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 65520,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
January '2000
Problem 32  O(E) Flory Alg.
}
program
  EulerianTour;

const
  MaxNum = 100;

var
  N : Integer;
  G, H : array [1 .. MaxNum, 0 .. MaxNum] of Integer;
  D : array [1 .. MaxNum] of Integer;
  Mark : array [1 .. MaxNum] of Boolean;
  I, J : Integer;
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
      if G[I, J] = 1 then
      begin
        Inc(D[I]); H[I, D[I]] := J;
        Inc(D[J]); H[J, D[J]] := I;
      end;
    end;
    Readln(F);
  end;
  Assign(F, 'output.txt');
  ReWrite(F);
  for I := 1 to N do
    if Odd(D[I]) then
		begin
		  Writeln(F, 'Graph is not eulerian.');
      Close(F);
			Halt;
		end;
end;

procedure FindOtherCycles (V : Integer);
var
  I : Integer;
begin
  while (D[V] > 0) do
  begin
    while (D[V] > 0) and (G[V, H[V, D[V]]] <> 1) do Dec(D[V]);
    if D[V] > 0 then
    begin
      G[V, H[V, D[V]]] := 2; G[H[V, D[V]], V] := 2;
      FindOtherCycles (H[V, D[V]]);
      Write(F, ' ', V);
    end;
  end;
end;

function FindCycle (V : Integer) : Boolean;
var
  I : Integer;
begin
  for I := D[V] downto 1 do
  begin
    if not Mark[H[V, I]] then
    begin
      G[V, H[V, I]] := 2; G[H[V, I], V] := 2;
      Mark[H[V, I]] := True;
      if (H[V, I] = 1) or FindCycle(H[V, I]) then
      begin
        FindCycle := True;
        Write(F, ' ', V);
        FindOtherCycles(V);
        Exit;
      end;
      G[V, H[V, I]] := 1; G[H[V, I], V] := 1;
    end;
  end;
  FindCycle := False;
end;

begin
  ReadInput;
  if N > 0 then Write(F, '1');
  FindCycle(1); {Find Main Cycle}
  Close(F);
end.
