{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 16384,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
April '2000
Problem 166  Backtrack Method
}
program
  MapFold;

uses
  FoldUnit;

type
  TMove = record
    L : Byte;
    D : string[2];
  end;
  TMoves = array [1 .. 10] of TMove;

var
  M, N : Integer;
  M1, M2 : TMap;
  Move : TMoves;
  MNum : Integer;
  I, J : Integer;

procedure ReadInput;
begin
  Assign(Input, 'input.txt');
  Reset(Input);
  Readln(M);
  Readln(N);
  Readln(M2[1,1]);
  M2[1,1,0] := Chr(M * N);
  for I := 1 to M do
    for J := 1 to N do
      M1[I, J] := Chr((I - 1) * N + J - 1 + Ord('A'));
  Close(Input);
end;

procedure NoSolution;
begin
  Assign(Output, 'output');
  ReWrite(Output);
  Writeln('No Solution');
  Close(Output);
end;

procedure Found;
begin
  Assign(Output, 'output.txt');
  ReWrite(Output);
  for I := 1 to MNum do
    with Move[I] do
      Write(D[1], L, D[2], ' ');
  Close(Output);
  Halt;
end;

function Inverse (S : string) : string;
var I, J : Integer;
    T : string;
begin
  T[0] := S[0];
  J := Length(S);
  for I := 1 to J do
      T[I] := S[J + 1 - I];
  Inverse := T;
end;

{proc Fold(M1:TMap;var M2:TMap;B1,A1:Int;var B2,A2:Int;L:Int;D,W:Char);}
procedure BackTrack (var M : TMap; A, B : Integer);
var I, C, D : Integer;
    Mp : TMap;
procedure Check;
begin
  if Mp[1, 1] = M2[1, 1] then
    Found;
end;

begin
  for I := 1 to A do
    for J := 1 to B do
      if (Pos(M[I, J], M2[1, 1]) = 0) and
         (Pos(Inverse(M[I, J]), M2[1, 1]) = 0) then
        Exit;
  Inc(MNum);
  for I := 1 to B - 1 do
  begin
    Move[MNum].L := I;
    Fold(M, Mp, A, B, C, D, I, 'V', 'L'); Move[MNum].D := 'VL';
    if (C = 1) and (D = 1) then Check else BackTrack(Mp, C, D);
    Fold(M, Mp, A, B, C, D, I, 'V', 'R'); Move[MNum].D := 'VR';
    if (C = 1) and (D = 1) then Check else BackTrack(Mp, C, D);
  end;
  for I := 1 to A - 1 do
  begin
    Move[MNum].L := I;
    Fold(M, Mp, A, B, C, D, I, 'H', 'L'); Move[MNum].D := 'HL';
    if (C = 1) and (D = 1) then Check else BackTrack(Mp, C, D);
    Fold(M, Mp, A, B, C, D, I, 'H', 'U'); Move[MNum].D := 'HU';
    if (C = 1) and (D = 1) then Check else BackTrack(Mp, C, D);
  end;
  Dec(MNum);
end;

begin
  ReadInput;
  BackTrack(M1, M, N);
  NoSolution;
end.