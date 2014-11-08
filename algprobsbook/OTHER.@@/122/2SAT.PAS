{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 16384,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
April '2000
Problem 122  O(N2) Dfs Method
}
program
  TwoSat;

const
  MaxN = 100;
  MaxM = 100;

var
  M, N : Integer;
  Pairs : array [1 .. MaxM, 1 .. 2] of Integer;
  Mark, MarkBak, Value : array [1 .. MaxN] of Boolean;
  Fl : Boolean;

  I : Integer;

procedure ReadInput;
begin
  Assign(Input, 'input.txt');
  Reset(Input);
  Readln(N, M);
  for I := 1 to M do
    Readln(Pairs[I, 1], Pairs[I, 2]);
  Close(Input);
end;

procedure WriteOutput;
begin
  Assign(Output, 'output.txt');
  Rewrite(Output);
  if Fl then
    Writeln('No Solution')
  else
    for I := 1 to N do
      Writeln(Integer(Value[I]));
  Close(Output);
end;

function  DFS (V : Integer) : Boolean;
var
  I, J : Integer;
begin
  if Mark[Abs(V)] then
  begin
    DFS := Value[Abs(V)] xor (V < 0);
    Exit;
  end;
  Mark [Abs(V)] := True;
  Value[Abs(V)] := (V > 0);
  for I := 1 to 2 do
    for J := 1 to M do
      if (Pairs[J, I] = -V) and not DFS(Pairs[J, 3 - I]) then
      begin
        DFS := False;
        Exit;
      end;
  DFS :=  True;
end;

procedure Solve;
begin
  FillChar(Mark,SizeOf(Mark),0);
  MarkBak := Mark;
  Fl := False;
  for I := 1 to N do
    if not Mark[I] then
      if not DFS(-I) then
      begin
        Mark := MarkBak;
        if not DFS(I) then
        begin
          Fl := True;
          Break;
        end;
      end;
end;

begin
  ReadInput;
  Solve;
  WriteOutput;
end.