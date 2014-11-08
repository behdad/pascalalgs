{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
April '2000
Problem 70  O(LgN) Ternary Search
}
program
  CounterfeitCoin;

var
  N, L, R, St : Integer;
  S : string;

  Re : Extended;
  I, J : Integer;

procedure ReadInput;
begin
  Write('Enter n? ');
  Readln(N);
end;

procedure Solve;
begin
  St := 0;
  Re := N;
  while Re > 1 do
  begin
    Inc(St);
    Re := Re / 3;
  end;
  Writeln('Minimum number of comparisons = ', St);
  L := 1; R := N; St := 0;
  while L < R do
  begin
    Inc(St);
    Write(St, ': compare {', L);
    I := L;
    for I := L + 1 to L + (R - L) div 3 do
      Write(',', I);
    Inc(I);
    J := I;
    Write('} and {', I);
    for J := I + 1 to I + (R - L) div 3 do
      Write(',', J);
    Write('}. (<=>)? ');
    Readln(S);
    if (Length(S) > 1) or (S = '') then
    begin Writeln('Error'); Halt; end;
    case S[1] of
      '<' : R := L + (R - L) div 3;
      '>' : begin L := L + (R - L) div 3 + 1; R := J; end;
      '=' : L := J + 1;
    else
    begin Writeln('Error'); Halt; end;
    end;
  end;
  Writeln('Coin #', R, ' is counterfeit.');
end;

begin
  ReadInput;
  Solve;
end.
