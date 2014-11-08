{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
September '1999
Problem 26  O(2^N) Recursive Method
}
program
  CubicGraph;

const
  MaxN = 20;

var
  N : Integer;
  S : string [MaxN];
  I, J : Integer;
  F : Text;

procedure Cube (K : Integer; Rev : Byte);
begin
  if K = 0 then
  begin
    Writeln(F, S);
    Exit;
  end;
  Inc(S[0]);
  S[Ord(S[0])] := Chr(Ord('0') + Rev    ); Cube(K - 1, 0);
  S[Ord(S[0])] := Chr(Ord('0') + 1 - Rev); Cube(K - 1, 1);
  Dec(S[0]);
end;

begin
  Readln(N);
  Assign(F, 'output.txt');
  ReWrite(F);
  Cube(N, 0);
  Close(F);
end.
