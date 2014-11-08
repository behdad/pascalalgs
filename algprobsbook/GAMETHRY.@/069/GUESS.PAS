{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
April '2000
Problem 69  Straightforward
}
program
  GuessingTheNumberGame;

var
  N, St, W, B : Integer;
  G : array [0 .. 9999] of Boolean;
  Na, Ia : array [0 .. 9] of Integer;
  Ww, Bb, Nn, Ii, J : Integer;

  I : Integer;

function  Min (A, B : Integer) : Integer;
begin
  if A <= B then Min := A else Min := B;
end;

function  Valid (I : Integer) : Boolean;
begin
  Ww := 0; Bb := 0; Nn := N; Ii := I;
  FillChar(Na, SizeOf(Na), 0);
  FillChar(Ia, SizeOf(Ia), 0);
  for J := 1 to 4 do
  begin
    if Nn mod 10 = Ii mod 10 then
      Inc(Bb)
    else
    begin
      Inc(Na[Nn mod 10]);
      Inc(Ia[Ii mod 10]);
    end;
    Nn := Nn div 10;
    Ii := Ii div 10;
  end;
  for Ii := 1 to 9 do
    Inc(Ww, Min(Ia[Ii], Na[Ii]));
  Valid := (Ww = W) and (Bb = B);
end;

procedure Play;
begin
  for I := 1 to 9999 do
    if (I mod 10 <> I div 10 mod 10) and (I mod 10 <> I div 100 mod 10) and
       (I mod 10 <> I div 1000 mod 10) and (I div 10 mod 10 <> I div 100 mod 10) and
       (I div 10 mod 10 <> I div 1000 mod 10) and (I div 100 mod 10 <> I div 1000 mod 10) and
       (I mod 10 <> 0) and (I div 10 mod 10 <> 0) and (I div 100 mod 10 <> 0) and (I > 1000) then
      G[I] := True;
  repeat
    N := 0;
    for I := 1 to 9999 do
      if G[I] then
      begin
        N := I;
        Break;
      end;
    if N = 0 then
    begin Writeln('Error: No remaining states.'); Halt; end;
    Writeln(N);
    Write('White score: '); Readln(W);
    Write('Black score: '); Readln(B);
    if (W + B > 4) or (W < 0) or (W > 4) or (B < 0) or (B > 4) then
    begin Writeln('Error'); Halt; end;
    for I := 1 to 9999 do
      if G[I] and not Valid(I) then
        G[I] := False;
    Inc(St);
  until B = 4;
end;

begin
  Play;
  Writeln('Aha! I found ', N, ' in ', St, ' step(s).');
end.
