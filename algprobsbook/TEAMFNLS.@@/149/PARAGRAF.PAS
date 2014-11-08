{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
April '2000
Problem 149  O(N2) Dynamic Method
}
program
  Paragraph;

uses
  Graph;

const
  MaxN=200;

type
  List  = array [1 .. MaxN + 1] of Extended;
  List2 = array [1 .. MaxN + 1] of Integer;

var
  Word, P : List;
  Count : List2;
  N, I, J, Lines : Integer;
  L, S, Sigma : Extended;

procedure ReadInput;
begin
  Assign(Input, 'input.txt');
  Reset(Input);
  Readln(N);
  Readln(L);
  Readln(S);
  Readln(Sigma);
  for I := 1 to N do
    Readln(Word[I]);
  Close(Input);
  Assign(Input, '');
  Reset(Input);
end;

procedure WriteOutput;
begin
  Assign(Output, 'output.txt');
  Rewrite(Output);
  Writeln(P[1] : 0 : 4);
  Writeln(Lines);
  Close(Output);
end;

procedure Paragraf (N2 : Integer);

function M (const N2 : Integer) : Integer;
var
  I : Integer;
  T : Extended;

begin
  I := 1;
  T := Word[N2];
  while (T <= L) and (I + N2 - 1 <= N) do
  begin
    T := T + Sigma + Word[N2 + I];
    Inc(I);
  end;
  Dec(I);
  M := I;
end;

function Min (const A, B : Extended; var C, D, E : Integer) : Extended;
begin
  if A <= B then
  begin
    Min := A;
    E := C;
  end
  else
  begin
    Min := B;
    E := D;
  end;
end;

function P2 (const A, B : Integer) : Extended;
var
  I : Integer;
  T : Extended;
begin
  T := L;
  for I := A to A + B - 1 do
    T := T - Word[I];
  P2 := (B - 1) * Sqr(T / (B - 1) - S);
  if A + B - 1 = N then
  begin
    T := Word[A];
    for I := A + 1 to A + B - 1 do
      T := T + Word[I] + S;
    if T < L then
      P2 := 0;
  end;
end;

begin
  P[N + 1] := 0;
  Count[N + 1] := 0;
  P[N] := 0;
  Count[N] := 1;
  for I := N - 1 downto 1 do
  begin
    P[I] := N * L;
    for J := 2 to M(I) do
      P[I] := Min(P[I], P[I + J] + P2(I,J), Count[I], J, Count[I]);
  end;
end;

procedure Calculate;
var
  grDriver, grMode: Integer;
  Ss, T : Extended;
begin
  grDriver := Detect;
  InitGraph(grDriver, grMode,'');
  SetLineStyle(0, 0, ThickWidth);
  I := 1;
  Lines := 0;
  while I <= N do
  begin
    inc(Lines);
    T := 0;
    for J := 1 to Count[I] do
      T := T + Word[I + J - 1];
    if Count[I] <> 1 then Ss := (L - T) / (Count[I] - 1);
    if (I + Count[I] > N) and (Ss > S) then Ss := S;
    T := 0;
    for J := 1 to Count[I] do
    begin
      line(20 + trunc(T),20 + Lines * 10,20 + trunc(T + Word[I + J - 1] - 1),20 + Lines * 10);
      T := T + Word[I + J - 1] + Ss;
    end;
    I := I + Count[I];
  end;
  SetLineStyle(0, 0, NormWidth);
  Setcolor(12);
  Rectangle(17,21,trunc(L+24),25 + Lines * 10);
  Readln;
  Closegraph;
end;

begin
  ReadInput;
  Paragraf(1);
  Calculate;
  WriteOutput;
end.