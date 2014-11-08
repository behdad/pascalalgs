{$A+,B-,D+,E+,F-,G+,I-,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 65520,0,0}
{by Behdad Esfahbod  6th IOI  Sweden  Day1 Problem 5 Generator}
program
  MapFoldGenerator;

uses
  FoldUnit;

const
  InF  = 'input.txt';
  OutF = 'output.txt';

var
  M, N : Integer;
  M2 : TMap;
  I, J, L : Integer;
  S, T : string;
  D, W : Char;
  F : Text;

begin
  Assign(F, InF);
  Reset(F);
  Readln(F, M, N);
  Readln(F, T);
  Close(F);
  Assign(F, OutF);
  Reset(F);
  if IOResult <> 0 then
  begin
    Writeln(#7'Error by opening the output file.');
    Halt;
  end;
  Readln(F, S);
  for I := 1 to M do
    for J := 1 to N do
      M2[I, J] := Chr((I - 1) * N + J - 1 + Ord('A'));
{proc Fold(M1:TMap;var M2:TMap;B1,A1:Int;var B2,A2:Int;L:Int;D,W:Char);}
  I := 0;
  while S[4 * I + 1] in ['V', 'H'] do
  begin
    D := S[4 * I + 1];
    Val(S[4 * I + 2], L, J);
    W := S[4 * I + 3];
    if ((D = 'W') and ((not (W in ['L', 'U'])) or (L >= M))) or
       ((D = 'V') and ((not (W in ['L', 'R'])) or (L >= N))) or (J <> 0)
    then
    begin
      Writeln(#7'The move ', I + 1, ' is invalid.');
      Halt;
    end;
    Fold(M2, M2, M, N, M, N, L, D, W);
    Inc(I);
  end;
  if (M <> 1) or (N <> 1) then
    Writeln(#7'The result map is not 1 * 1.')
  else
  if M2[1, 1] <> T then
    Writeln(#7'The result map is not same as then required map.')
  else
    Writeln('The answer is correct');
  Close(F);
end.