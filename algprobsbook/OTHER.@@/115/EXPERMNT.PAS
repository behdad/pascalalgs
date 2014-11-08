{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
April '2000
Problem 115  O(NLgN) Greedy Method
}
program
  Experiments;

var
  N : Integer;

  Fl : Boolean;
  I, J, K : Integer;

procedure ReadInput;
begin
  Readln(N);
end;

procedure WriteOutput;
begin
  Assign(Output, 'output.txt');
  Rewrite(Output);
  J := N;
  while J <> 0 do
  begin
    Inc(K);
    J := J div 2;
  end;
  Writeln('The minimum number of experiments = ', K);
  J := 1;
  for K := 1 to K do
  begin
    Fl := False;
    Write('Experiment #', K, ':');
    for I := 1 to N do
      if I div J mod 2 = 1 then
      begin
        if Fl then
          Write(',');
        Write(' ', I);
        Fl := True;
      end;
    Writeln;
    J := J * 2;
  end;
  Close(Output);
end;

begin
  ReadInput;
  WriteOutput;
end.
