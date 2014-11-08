{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 16384,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
April '2000
Problem 73  O(N2) 2Sat Alg. Dfs Method
}
program
  SatisfiabilityGame;{QBF2}

const
  MaxN = 100;

var
  N, M : Integer;
  G : array [-MaxN .. MaxN, -MaxN .. MaxN] of Boolean;
  X : array [-MaxN .. MaxN] of Boolean;
  Mark, MarkBak : array [1 .. MaxN] of Boolean;

  I, J, K, T : Integer;

procedure ReadInput;
begin
  Assign(Input, 'input.txt');
  Reset(Input);
  Readln(N, M);
  for I := 1 to M do
  begin
    Read(J, K);
    G[J, K] := True;
    G[K, J] := True;
  end;
  Close(Input);
  Assign(Input, '');
  Reset(Input);
end;

function  Force (V : Integer) : Boolean;
var
  I : Integer;
begin
  if Mark[Abs(V)] then
  begin
    Force := X[V];
    Exit;
  end;
  if not Odd(V) and (Abs(V) <> K) then
  begin
    Force := False;
    Exit;
  end;
  Mark[Abs(V)] := True;
  X[V] := True;
  for I := -N to N do
    if G[-V, I] then
    begin
      if not Force(I) then
      begin
        Force := False;
        Exit;
      end;
    end;
  Force := True;
end;

function  RestoreMark : Boolean;
begin
  Mark := MarkBak;
  RestoreMark := True;
end;

function  QBFSatisfy : Boolean;
begin
  for K := 1 to N do
  begin
    MarkBak := Mark;
    if    (Odd(K) and (not Force(K) and (RestoreMark and not Force(-K)))) or
      (not Odd(K) and (not Force(K) or  (RestoreMark and not Force(-K)))) then
    begin
      QBFSatisfy := False;
      Exit;
    end;
  end;
  QBFSatisfy := True;
end;

procedure Play;
begin
  FillChar(Mark, SizeOf(Mark), 0);
  I := 1;
  while I <= N do
  begin
    if I mod 2 = J then
    begin
      K := J;
      MarkBak := Mark;
      if Force(I) xor Odd(J) then
      begin
        Mark := MarkBak;
        Force(-I);
        T := 0;
      end
      else
        T := 1;
      Writeln('X[', I, '] = ', T);
    end
    else
    begin
      Write('X[', I, '] = ? '); Readln(T);
      if (T <> 0) and (T <> 1) then begin Writeln('Error'); Halt; end;
      K := 0;
      if T = 1 then
        Force(I)
      else
        Force(-I);
    end;
    Inc(I);
  end;
end;

procedure Solve;
begin
  if QBFSatisfy then
  begin
    Writeln('The first player has a winning strategy.');
    J := 1;
  end
  else
  begin
    Writeln('The second player has a winning strategy.');
    J := 0;
  end;
  Play;
  Writeln('I won!');
end;

begin
  ReadInput;
  Solve;
end.
