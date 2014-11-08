{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
April '2000
Problem 67  Winning Strategy
  N=2^K-1 => Second Pl. else First Pl.
  N=2^K-1 is the kernel of the game
}
program
  MaximumHalfGame;

var
  N, T : Integer;

procedure ReadInput;
begin
  Write('Enter N > ');
  Readln(N);
end;

function
  Is2PowerNDec (X : Integer) : Boolean;
begin
  Is2PowerNDec := Trunc(Ln(X) / Ln(2)) + 1 = Trunc(Ln(X + 1) / Ln(2));
end;

procedure Play;
begin
  while N > 0 do
  begin
    if Is2PowerNDec(N) then
    begin
      Write('How many matches do you take? ');
      Readln(T);
      if (T <> 1) and (T > N div 2) then begin Writeln('Error'); Halt; end;
    end
    else
    begin
      T := N - ((1 shl Trunc(Ln(N) / Ln(2))) - 1);
      Writeln('I take ', T, ' match(es).');
    end;
    Dec(N, T);
    if N <> 0 then
    begin
      Writeln('Number of remaining matches = ', N);
      Writeln;
    end;
  end;
end;

procedure Solve;
begin
  if Is2PowerNDec(N) then
    Writeln('The second player has a winning strategy.')
  else
    Writeln('The first player has a winning strategy.');
  Play;
  Writeln('I won!');
end;

begin
  ReadInput;
  Solve;
end.
