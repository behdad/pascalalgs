{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
August '1999
Problem 5  O(LgN) Trivial Method
}
program
  WriteANumberWithLetters;

const
  MaxN = 9999;

var
  N : Integer;

const
  Yek : array [1 .. 9] of string[15] = ('yek','do','se','chahaar','panj',
    'shesh','haft','hasht','noh');
  Dah : array [1 .. 9] of string[15] = ('dah','bist','si','chehel','panjah',
    'shast','haftad','hashtad','navad');
  Sad : array [1 .. 9] of string[15] = ('sad','devist','sisad','chahaarsad',
   'paansad','sheshsad','haftsad','hashtsad','nohsad');
  Bist : array [11 .. 19] of string[15] = ('yaazdah','davaazdah','sizdah',
    'chahaardah','paanzdah','shanzdah','hefdah','hijdah','noozdah');

begin
  Readln(N);

  if N = 0 then
    Write('sefr');
  if N div 1000 > 1 then
  begin
    Write(Yek[N div 1000], ' hezaar ');
    N := N mod 1000;
    if N > 0 then
      Write('o ');
  end
  else
    N := N mod 1000;
  if N div 100 > 0 then
  begin
    Write(Sad[N div 100], ' ');
    N := N mod 100;
    if N > 0 then
      Write('o ');
  end;
  if (N >= 20) or (N = 10) then
  begin
    Write(Dah[N div 10], ' ');
    N := N mod 10;
    if N > 0 then
      Write('o ');
  end
  else
  if N >= 10 then
  begin
    Write(Bist[N]);
    N := 0;
  end;
  if N > 0 then
    Write(Yek[N]);
  Writeln;
end.