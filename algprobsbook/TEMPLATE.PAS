{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q+,R+,S+,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
April '2000
Problem
}
program
  ;

const
  MaxN = ;

var
  N : Integer;
  A : array [1 .. MaxN, 1 .. MaxN] of Integer;

  I, J : Integer;

procedure ReadInput;
begin
  Assign(Input, 'input.txt');
  Reset(Input);

  Close(Input);
end;

procedure WriteOutput;
begin
  Assign(Output, 'output.txt');
  Rewrite(Output);

  Close(Output);
end;

begin
  ReadInput;

  WriteOutput;
end.
