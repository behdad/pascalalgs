{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
August '1999
Problem 10  O(N) Dynamic Method
}
program
  MaximumSumSubSequence;

var
  I, J, BI, BJ : Integer;
  R, S, BS : Real;
  F : Text;

begin
  Assign(F, 'input.txt');
  Reset(F);
  BS := -1E30;
  I := 1;
  J := 0;
  while not Eof(F) do
  begin
    Inc(J);
    Readln(F, R);
    if S < 0 then
    begin
      I := J;
      S := 0;
    end;
    S := S + R;
    if S > BS then
    begin BI := I; BJ := J; BS := S; end;
  end;
  Close(F);

  Writeln(BI, ' ', BJ, ' ', BS : 0 : 3);
end.