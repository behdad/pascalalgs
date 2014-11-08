{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 1024,0,655360}
{
by Behdad Esfahbod
Algorithmic Problems Book
April '2000
Problem 83  O(D2N) Dynamic Method
}
program
  ThreeProcessors;

const
  MaxN = 30;
  MaxD = 100;

type
  TArr = array [0 .. MaxD, 0 .. MaxD] of Byte;

var
  N, D : Integer;
  Dy : array [0 .. MaxN] of ^ TArr;
  L, A : array [1 .. MaxN] of Integer;
  Fl : Boolean;
  I, J, K, S : Integer;
  F : Text;

procedure ReadInput;
begin
  Assign(F, 'input.txt');
  Reset(F);
  Readln(F, N, D);
  for I := 1 to N do
    Read(F, L[I]);
  Close(F);
end;

procedure WriteOutput;
begin
  Assign(F, 'output.txt');
  Rewrite(F);
  if Fl then
  begin
    for I := 1 to N do if A[I] = 1 then Write(F, I, ' ');
    Writeln(F);
    for I := 1 to N do if A[I] = 2 then Write(F, I, ' ');
    Writeln(F);
    for I := 1 to N do if A[I] = 3 then Write(F, I, ' ');
    Writeln(F);
  end
  else
    Writeln(F, 'No Solution');
  Close(F);
end;

procedure Dynamic;
begin
  for I := 0 to N do
  begin
    New(Dy[I]);
    FillChar(Dy[I]^, SizeOf(Dy[I]^), 0);
  end;
  Dy[0]^[0, 0] := 4;
  for I := 1 to N do
    for J := 0 to D do
      for K := 0 to D do
      begin
        if (L[I] <= J) and (Dy[I - 1]^[J - L[I], K] <> 0) then
          Dy[I]^[J, K] := 1 else
        if (L[I] <= K) and (Dy[I - 1]^[J, K - L[I]] <> 0) then
          Dy[I]^[J, K] := 2 else
        if (Dy[I - 1]^[J, K] <> 0) then
          Dy[I]^[J, K] := 3;
      end;
  S := 0;
  for I := 1 to N do Inc(S, L[I]);
  Fl := False;
  for J := D downto 0 do
  begin
    for K := J downto 0 do
    begin
      if J + K + D < S then
        Break;
      if Dy[N]^[J, K] <> 0 then
      begin
        Fl := True;
        Break;
      end;
    end;
    if Fl then
      Break;
  end;
  if Fl then
    for I := N downto 1 do
    begin
      A[I] := Dy[I]^[J, K];
      case Dy[I]^[J, K] of
        1 : Dec(J, L[I]);
        2 : Dec(K, L[I]);
      end;
    end;
end;

begin
  ReadInput;
  Dynamic;
  WriteOutput;
end.
