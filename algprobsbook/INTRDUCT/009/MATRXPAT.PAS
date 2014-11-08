{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
August '1999
Problem 9  O(N2) Dynamic Method - O(N3) BellmanFord Algorithm
}
program
  FindingAPathInMatrix;

const
  MaxN = 100;

var
  N : Integer;
  A, D, P : array [0 .. MaxN + 1, 0 .. MaxN + 1] of Integer;
  I, J : Integer;
  Fl : Boolean;
  F : Text;

begin
  Assign(F, 'input.txt');
  Reset(F);
  Readln(F, N);
  for I := 1 to N do
  begin
    for J := 1 to N do
      Read(F, A[I, J]);
    Readln(F);
  end;
  Close(F);

  FillChar(D, SizeOf(D), 100);
  D[N + 1, N] := 0;
  for I := N downto 1 do
    for J := N downto 1 do
    begin
      D[I, J] := A[I, J] + D[I + 1, J]; P[I, J] := 256 * (I + 1) + J;
      if D[I, J] > A[I, J] + D[I, J + 1] then
      begin
        D[I, J] := A[I, J] + D[I, J + 1]; P[I, J] := 256 * I + (J + 1);
      end;
    end;

  Assign(F, 'output1.txt');
  ReWrite(F);
  Writeln(F, D[1, 1]);
  I := 257;
  Writeln(F, I div 256, ' ', I mod 256);
  while I <> 257 * N do
  begin
    I := P[I div 256, I mod 256];
    Writeln(F, I div 256, ' ', I mod 256);
  end;
  Close(F);

  FillChar(D, SizeOf(D), 100);
  D[N, N] := A[N, N];
  repeat
    Fl := True;
    for I := N downto 1 do
      for J := N downto 1 do
      begin
        if D[I, J] > A[I, J] + D[I, J + 1] then
        begin
          D[I, J] := A[I, J] + D[I, J + 1]; P[I, J] := 256 * I + (J + 1);
          Fl := False;
        end;
        if D[I, J] > A[I, J] + D[I + 1, J] then
        begin
          D[I, J] := A[I, J] + D[I + 1, J]; P[I, J] := 256 * (I + 1) + J;
          Fl := False;
        end;
        if D[I, J] > A[I, J] + D[I, J - 1] then
        begin
          D[I, J] := A[I, J] + D[I, J - 1]; P[I, J] := 256 * I + (J - 1);
          Fl := False;
        end;
        if D[I, J] > A[I, J] + D[I - 1, J] then
        begin
          D[I, J] := A[I, J] + D[I - 1, J]; P[I, J] := 256 * (I - 1) + J;
          Fl := False;
        end;
      end;
  until Fl;

  Assign(F, 'output2.txt');
  ReWrite(F);
  Writeln(F, D[1, 1]);
  I := 257;
  Writeln(F, I div 256, ' ', I mod 256);
  while I <> 257 * N do
  begin
    I := P[I div 256, I mod 256];
    Writeln(F, I div 256, ' ', I mod 256);
  end;
  Close(F);
end.