{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
April '2000
Problem 112  O(N2) Greedy Method
}
program
  RoadsDirection;

var
  N : Integer;

  I, J : Integer;

procedure ReadInput;
begin
  Readln(N);
end;

procedure WriteEdge (I, J : Integer);
begin
  Writeln('From ', I, ' to ', J);
end;

procedure WriteOutput;
begin
  Assign(Output, 'output.txt');
  Rewrite(Output);
  if (N = 2) or (N = 4) then
    Writeln('NO SOLUTION')
  else
  begin
    if N > 1 then
      if Odd(N) then
      begin
        WriteEdge(1, 2);
        WriteEdge(2, 3);
        WriteEdge(3, 1);
        I := 3;
      end
      else
      begin {this part may be incorrect}
        WriteEdge(1, 2);
        WriteEdge(2, 3);
        WriteEdge(3, 4);
        WriteEdge(4, 1);
        WriteEdge(1, 3);
        WriteEdge(2, 4);
        WriteEdge(1, 5);
        WriteEdge(4, 5);
        WriteEdge(5, 2);
        WriteEdge(5, 3);
        WriteEdge(6, 1);
        WriteEdge(6, 4);
        WriteEdge(2, 6);
        WriteEdge(3, 6);
        I := 6;
      end;
    for I := I + 1 to N do
      if Odd(I) then
        for J := 1 to I - 2 do
          WriteEdge(I, J)
      else
      begin
        for J := 1 to I - 1 do
          WriteEdge(J, I);
        WriteEdge(I, I + 1);
      end;
  end;
  Close(Output);
end;

begin
  ReadInput;
  WriteOutput;
end.
