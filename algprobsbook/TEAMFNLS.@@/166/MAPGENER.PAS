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
  AnsF = 'answer.txt';

var
  M, N, M1, N1 : Integer;
  M2 : TMap;
  I, J, L, W : Integer;
  Ch : Char;
  F : Text;

begin
  Readln(M, N);
  M1 := M;
  N1 := N;
  if M * N = 0 then
    Halt(1);
{  RandSeed := M * (10 + N);}
  Randomize;
  Assign(F, OutF);
  ReWrite(F);
  Close(F);
  for I := 1 to M do
    for J := 1 to N do
      M2[I, J] := Chr((I - 1) * N + J - 1 + Ord('A'));
{proc Fold(M1:TMap;var M2:TMap;B1,A1:Int;var B2,A2:Int;L:Int;D,W:Char);}
  Assign(F, AnsF);
  ReWrite(F);
  while (M > 1) or (N > 1) do
  begin
    W := Random(2);
    if Random(2) = 0 then
    begin
      if M > 1 then
      begin
        L := Random(M - 1) + 1;
        if W = 0 then Ch := 'L' else Ch := 'U';
        Fold(M2, M2, M, N, M, N, L, 'H', Ch);
        Write(F, 'H', L, Ch, ' ');
      end;
    end
    else
    begin
      if N > 1 then
      begin
        L := Random(N - 1) + 1;
        if W = 0 then Ch := 'L' else Ch := 'R';
        Fold(M2, M2, M, N, M, N, L, 'V', Ch);
        Write(F, 'V', L, Ch, ' ');
      end;
    end
  end;
  Close(F);
  Assign(F, InF);
  ReWrite(F);
  Writeln(F, M1, ' ', N1);
  Writeln(F, M2[1, 1]);
  Close(F);
end.