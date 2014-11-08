{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
April '2000
Problem 66  Winning Strategy
  N=(M+1)K => Second Pl. else First Pl.
  N=(M+1)K is the kernel of the game
}
program
  MatchesGame;

var
  N, M, T : Integer;

procedure ReadInput;
begin
  Write('Enter N ? ');
  Readln(N);
  Write('Enter m ? ');
  Readln(M);
end;

procedure Play (Nn : Integer);
begin
  while Nn > 0 do
  begin
    Writeln('Number of remaining matches = ', Nn);
    if Nn mod (M + 1) = 0 then
    begin
      Write('How many matches do you take? ');
      Readln(T);
      if (T < 1) or (T > M) then begin Writeln('Error'); Halt; end;
      Dec(Nn, T);
    end
    else
    begin
      Writeln('I take ', Nn mod (M + 1), ' match(es).');
      Dec(Nn, Nn mod (M + 1));
    end;
  end;
end;

procedure Solve;
begin
  if N mod (M + 1) <> 0 then
  begin
    Writeln('The first player has a winning strategy.');
    Writeln('I take ', N mod (M + 1), ' match(es).');
    Dec(N, N mod (M + 1));
  end
  else
    Writeln('The second player has a winning strategy.');
  Play(N);
  Writeln('I won!');
end;

begin
  ReadInput;
  Solve;
end.
