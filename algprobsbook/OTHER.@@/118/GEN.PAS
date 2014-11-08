{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S+,T-,V+,X+,Y+}
{$M 16384,0,655360}
{By Behdad Esfahbod}
program
	RectangularCover;

const
	MaxNum  = 20 + 1;

type
  Arr1 = array [0 .. MaxNum, 0 .. MaxNum] of Integer;

var
  M, N, K, I, J : Integer;
  Mat : Arr1;

begin
  randomize;
  M:=Random(5)+20;
  N:=Random(5)+20;
  K:=RanDom(5)+1;
  RandSeed := 100 * M + 10 * N + K;
  Assign(Output, 'input.txt');
  ReWrite(Output);
  Writeln(M, ' ', N);
  for I := 1 to M do
  begin
  	for J := 1 to N do
      if Random(100) > K then
	    	Write('1 ')
      else
	    	Write('0 ');
    Writeln;
  end;
  Close(Output);
end.