{$A+,B-,D+,E-,F-,G+,I-,L+,N+,O-,P-,Q+,R+,S+,T-,V+,X+,Y+}
{$M 16384,0,655360}
program
  TestHeap;

uses
  BinHeap, MergHeap;

var
  A : array [1 .. 16000] of Longint;
  Rand : Longint;
  I, J, K : Longint;
  N, M1, M2, TT : Longint;
  Time : ^ Longint;

function L2P (L : Longint) : Pointer;
var
  P : Pointer absolute L;
begin
  L2P := P;
end;

procedure Test (B : PHeap);
begin
  TT := Time^;
  Writeln;
  Writeln;
  Writeln(B^.ID, ' Data Structure:');
  Rand := RandSeed;
  for I := 1 to N do
  begin
    A[1] := Longint(Random(32000)) * $10000 + Random(64000) - 1000000000;
    A[2] := Longint(Random(32000)) * $10000 + Random(64000) - 1000000000;
    B^.Insert(A[1], L2P(A[2]));
    if I mod 1000 = 0 then
      Write('.');
  end;
  M2 := MemAvail;
  Writeln;
  Writeln('Insert:');
  Writeln('Memory Used        : ', M1 - M2);
  Writeln('Avg Mem. / Key     : ', (M1 - M2) / N : 0 : 2);
  TT := Time^ - TT;
  Writeln('Time Used          : ', (TT / 18.2) : 0 : 2);
  Writeln('Avg Time / 1000 Op.: ', (TT / 18.2 * 1000 / N) : 0 : 2);
  Writeln;
  Writeln('Minimum Key        : ', (B^.Minimum)^.Key);
  TT := Time^;
  RandSeed := Rand;
  for I := 1 to N do
  begin
    B^.ExtractMin(K);
    if I mod 1000 = 0 then
      Write('.');
  end;
  Writeln;
  TT := Time^ - TT;
  Writeln('DeleteMin:');
  Writeln('Time Used          : ', (TT / 18.2) : 0 : 2);
  Writeln('Avg Time / 1000 Op.: ', (TT / 18.2 * 1000 / N) : 0 : 2);
  B^.Done(nil);
  M2 := MemAvail;
  Writeln('Available Memory   : ', M2);
  if M1 - M2 <> 0 then
    Writeln(#7'Leaked Memory      : ', M1 - M2);
  TT := Time^ - TT;
end;

var
  H : PHeap;
  Rn : Longint;

begin
  Time := Ptr(Seg0040, $6C);
  Readln(N);
  Rn := RandSeed;

  RandSeed := Rn;
  H := New(PBinHeap, Create);
  M1 := MemAvail;
  Writeln('Available Memory   : ', M1);
  Test(H);
  Freemem(H, SizeOf(TBinHeap));

end.
