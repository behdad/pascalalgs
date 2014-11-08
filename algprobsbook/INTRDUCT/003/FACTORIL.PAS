{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
August '1999
Problem 3  o(LgN) Trivial Method
}
program
  FacrorialBase;

var
  N : Integer;
  FI, FO : Text;
  B, C : Integer;

begin
  Assign(FI, 'input.txt');
  Reset(FI);
  Assign(FO, 'output.txt');
  Rewrite(FO);
  Readln(FI, N);
  while N > 0 do
  begin
    B := 1;
    Write(FO, N, ' =');
    while N > 0 do
    begin
      C := N mod (B + 1);
      N := (N - C) div (B + 1);
      Write(FO, ' ', C, ' * ', B, '!');
      if N <> 0 then
        Write(FO, ' +');
      Inc(B);
    end;
    Writeln(FO);
    Readln(FI, N);
  end;
  Close(FI);
  Close(FO);
end.