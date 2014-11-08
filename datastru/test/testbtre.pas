{$M 16384,0,655360}
program
  Test;

uses
  BTree;
var
  B : TBTree;
  A : array [1 .. 16000] of Longint;

  Rand : Longint;
  I, J, K : Longint;
  N, M, M1, M2, TT : Longint;
  Time : Longint absolute $40:$6C;

function L2P (L : Longint) : Pointer;
var
  P : Pointer absolute L;
begin
  L2P := P;
end;

begin
  Readln(N, M);
  TT := Time;
  M1 := MemAvail;
  B.Create;
  Writeln;
  Writeln(B.ID, ' Data Structure:');
  Writeln('Available Memory   : ', M1);
  Rand := RandSeed;
  for I := 1 to N do
  begin
    A[1] := Longint(Random(32000)) * $10000 + Random(64000) - 1000000000;
    A[2] := Longint(Random(32000)) * $10000 + Random(64000) - 1000000000;
    B.Insert(A[1], L2P(A[2]));
    if I mod 1000 = 0 then
      Write('.');
  end;
  M2 := MemAvail;
  Writeln;
  Writeln('Insert:');
  Writeln('Memory Used        : ', M1 - M2);
  Writeln('Avg Mem. / Key     : ', (M1 - M2) / N : 0 : 2);
  TT := Time - TT;
  Writeln('Time Used          : ', (TT / 18.2) : 0 : 2);
  Writeln('Avg Time / 1000 Op.: ', (TT / 18.2 * 1000 / N) : 0 : 2);
  TT := Time;
  for I := 1 to M do
  begin
    A[1] := Longint(Random(32000)) * $10000 + Random(64000) - 1000000000;
    B.Search(A[1]);
    if I mod 1000 = 0 then
      Write('o');
  end;
  Writeln;
  TT := Time - TT;
  Writeln('Search:');
  Writeln('Time Used          : ', (TT / 18.2) : 0 : 2);
  Writeln('Avg Time / 1000 Op.: ', (TT / 18.2 * 1000 / M) : 0 : 2);
  Writeln('BTree:');
  Writeln('Height             : ', B.Height);
  Writeln('Minimum Key        : ', B.Minimum);
  Writeln('Maximum Key        : ', B.Maximum);
  TT := Time;
  for I := 1 to M do
  begin
    A[1] := Longint(Random(32000)) * $10000 + Random(64000) - 1000000000;
    if B.Delete(A[1]) <> nil then
      Writeln('Error');
    if I mod 1000 = 0 then
      Write('o');
  end;
  Writeln;
  RandSeed := Rand;
  for I := 1 to N do
  begin
    A[1] := Longint(Random(32000)) * $10000 + Random(64000) - 1000000000;
    A[2] := Longint(Random(32000)) * $10000 + Random(64000) - 1000000000;
    if B.Delete(A[1]) <> L2P(A[2]) then
    begin
      Writeln('Error ', I);
      Halt;
    end;
    if I mod 1000 = 0 then
      Write('.');
  end;
  Writeln;
  TT := Time - TT;
  Writeln('Delete:');
  Writeln('Time Used          : ', (TT / 18.2) : 0 : 2);
  Writeln('Avg Time / 1000 Op.: ', (TT / 18.2 * 1000 / (M + N)) : 0 : 2);
  B.Done(nil);
  M2 := MemAvail;
  Writeln('Available Memory   : ', M2);
  if M1 - M2 <> 0 then
    Writeln(#7'Leaked Memory      : ', M1 - M2);
  TT := Time - TT;
end.
