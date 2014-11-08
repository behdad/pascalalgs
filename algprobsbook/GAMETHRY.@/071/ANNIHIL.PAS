{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 16384,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
April '2000
Problem 71  O(N2) Dynamic Memoize Method Nim Value Calc.
}
program
  AnnihilationGame;

const
  MaxN = 100;

var
  N, E, M : Integer;
  G : array [1 .. MaxN, 1 .. MaxN] of Boolean;
  Nim : array [1 .. MaxN] of Integer;
  S, T, Mark : array [0 .. MaxN] of Boolean;

  I, J, K : Integer;

procedure ReadInput;
begin
  Assign(Input, 'input.txt');
  Reset(Input);
  Readln(N, E, M);
  for I := 1 to M do
  begin
    Read(J);
    S[J] := True;
  end;
  Readln;
  for I := 1 to E do
  begin
    Readln(J, K);
    G[J, K] := True;
  end;
  Close(Input);
  Assign(Input, '');
  Reset(Input);
end;

function  Min (A, B : Integer) : Integer;
begin
  if A <= B then Min := A else Min := B;
end;

function  NimValue (V : Integer) : Integer;
var
  I : Integer;
begin
  Mark[V] := True;
  for I := 1 to N do
    if G[V, I] and not Mark[I] then
      J := NimValue(I);
  FillChar(T, SizeOf(T), 0);
  for I := 1 to N do
    if G[V, I] then
      T[Nim[I]] := True;
  for I := 0 to N do
    if not T[I] then
      Break;
  Nim[V] := I;
end;

procedure CalcNimValues;
begin
  for I := 1 to N do
    NimValue(I);
end;

function  Finished : Boolean;
begin
  for I := 1 to N do
    if S[I] then
      for J := 1 to N do
        if G[I, J] then
        begin
          Finished := False;
          Exit;
        end;
  Finished := True;
end;

procedure Play;
begin
  while not Finished do
  begin
    if K = 0 then
    begin
      Write('You move a pebble from? ');
      Readln(I);
      Write('to? ');
      Readln(J);
      if (I < 1) or (I > N) or (J < 1) or (J > N) or
        not S[I] or not G[I, J] then begin Writeln('Error'); Halt; end;
      S[I] := not S[I];
      S[J] := not S[J];
      K := K xor Nim[I] xor Nim[J];
    end
    else
    begin
      for I := 1 to N do
        if S[I] then
        begin
          for J := 1 to N do
            if G[I, J] and (K = Nim[I] xor Nim[J]) then
            begin
              Writeln('I move a pebble from vertex #', I, ' to vertex #', J);
              S[I] := not S[I];
              S[J] := not S[J];
              K := K xor Nim[I] xor Nim[J];
            end;
          if K = 0 then
            Break;
        end;
    end;
  end;
end;

procedure Solve;
begin
  CalcNimValues;
  K := 0;
  for I := 1 to N do
    if S[I] then
      K := K xor Nim[I];
  if K <> 0 then
    Writeln('The first player has a winning strategy.')
  else
    Writeln('The second player has a winning strategy.');
  Play;
  Writeln('I won!');
end;

begin
  ReadInput;
  Solve;
end.
