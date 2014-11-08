{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
April '2000
Problem 68  O(N2) Dynamic Method Nim Value Calc.
}
program
  PebblesGame;

const
  MaxN = 100;

type
  Arr = array [0 .. 1, 0 .. MaxN] of Integer;

var
  N, K, I, J, Fr : Integer;
  Cnt : Arr;
  T, My, You : Integer;

procedure ReadInput;
begin
  Write('Enter N > ');
  Readln(N);
  if not Odd(N) then
  begin
    Writeln('N must be an odd number.');
    Halt;
  end;
  Write('Enter K > ');
  Readln(K);
end;

function  Min (A, B : Integer) : Integer;
begin
  if A <= B then Min := A else Min := B;
end;

procedure  FillIn (N : Integer);
var I, J : Integer;
begin
  Cnt[0,0] := 1;
  Cnt[1,0] := 0;
  for I := 1 to N do
  begin
    Cnt[0,I] := 0;
    for J := Min(K,I) downto 1 do
    begin
      if Cnt[(N - I) mod 2,I - J] = 0 then
      begin
        Cnt[0,I] := J;
        Break;
      end;
    end;

    Cnt[1,I] := 0;
    for J := Min(K,I) downto 1 do
    begin
      if Cnt[(N - I + 1) mod 2 ,I - J] = 0 then
      begin
        Cnt[1,I] := J;
        Break;
      end;
    end;
  end;
end;

procedure Play (Nn, Fr : Integer);
begin
  My := 0;
  You := 0;
  while Nn > 0 do
  begin
    if NN <> N then Writeln('Number of remaining pebbles = ', Nn);
    if Fr = 2 then
    begin
      Write('How many pebbles do you take? ');
      Readln(T);
      if (T > K) or (T > Nn) then begin Writeln('Error'); Halt; end;
      Dec(Nn, T);
      Inc(You, T);
    end
    else
    begin
      if Cnt[My mod 2,Nn] = 0 then T := Min(random(K) + 1,Nn)
                              else T := Cnt[My mod 2,Nn];
      Writeln('I take ', T, ' pebbles,');
      Inc(My, T);
      Dec(Nn, T);
    end;
    Fr := 3 - Fr;
  end;
end;

procedure Solve;
begin
  FillIn(N);
  if Cnt[0,N] = 0 then T := 2 else T := 1;
  case T of
    1 : Writeln('The first player has a winning strategy.');
    2 : Writeln('The second player has a winning strategy.');
  end;
  Play(N,T);
  Writeln('Total number of your pebbles = ', You);
  Writeln('Total number of my pebbles = ', My);
  Writeln('I won!');
end;

begin
  ReadInput;
  Solve;
end.
