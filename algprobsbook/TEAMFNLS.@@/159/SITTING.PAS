{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 16384,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
April '2000
Problem 159 Backtrack Method
}
program
  Sitting;

const
  MaxNum = 200;

var
  N, M : Integer;
  CL, CW : array [0 .. MaxNum * 2] of record L, W, R : Integer; end;
  IndL, IndW : array [1 .. MaxNum + 1] of Integer;
  S, A : array [1 .. MaxNum] of Integer;
  Mark : array [1 .. MaxNum] of Boolean;

  T : Integer;
  H : Integer;
  I, J, K : Integer;
  CC : Longint;

procedure ReadInput;
begin
  Assign(Input, 'input.txt');
  Reset(Input);
  Readln(N, M);
  for I := 1 to M do
  begin
    with CL[2 * I - 1] do
      Readln(L, W, R);
    with CL[2 * I] do
    begin
      L := CL[2 * I - 1].R; W := CL[2 * I - 1].W; R := CL[2 * I - 1].L;
    end;
  end;
  M := M * 2;
  Close(Input);
end;

procedure NoSolution;
begin
  Assign(Output, 'output.txt');
  Rewrite(Output);
  Writeln('No Solution');
  Close(Output);
end;

procedure Sort(l, r: Integer);
var
  i, j, x: integer;
begin
  i := l; j := r; x := cl[(l+r) DIV 2].l;
  repeat
    while cl[i].l < x do i := i + 1;
    while x < cl[j].l do j := j - 1;
    if i <= j then
    begin
      cl[0] := cl[i]; cl[i] := cl[j]; cl[j] := cl[0];
      i := i + 1; j := j - 1;
    end;
  until i > j;
  if l < j then Sort(l, j);
  if i < r then Sort(i, r);
end;

procedure Sort2(l, r: Integer);
var
  i, j, x: integer;
begin
  i := l; j := r; x := cw[(l+r) DIV 2].w;
  repeat
    while cw[i].w < x do i := i + 1;
    while x < cw[j].w do j := j - 1;
    if i <= j then
    begin
      cw[0] := cw[i]; cw[i] := cw[j]; cw[j] := cw[0];
      i := i + 1; j := j - 1;
    end;
  until i > j;
  if l < j then Sort2(l, j);
  if i < r then Sort2(i, r);
end;

procedure Found;
begin
  Writeln(CC);
  Assign(Output, 'output.txt');
  Rewrite(Output);
  for I := 1 to N do
    Write(A[I], ' ');
  Close(Output);
  Halt;
end;

procedure Swap (I, J : Integer);
begin
  T := A[I]; A[I] := A[J]; A[J] := T;
end;

procedure Put (X : Integer);
begin
  for I := IndL[X] to IndL[X + 1] - 1 do
  begin
    Inc(S[CL[I].R]);
    Dec(S[CL[I].W]);
  end;
  for I := IndW[X] to IndW[X + 1] - 1 do
    if Mark[CW[I].L] then
      Dec(S[CW[I].R]);
  Mark[X] := True;
end;

procedure Pick (X : Integer);
begin
  Mark[X] := False;
  for I := IndL[X] to IndL[X + 1] - 1 do
  begin
    Dec(S[CL[I].R]);
    Inc(S[CL[I].W]);
  end;
  for I := IndW[X] to IndW[X + 1] - 1 do
    if Mark[CW[I].L] then
      Inc(S[CW[I].R]);
end;

procedure BT;
var
  I : Integer;
begin  Inc(CC);
  Inc(H);
  if H > N then
    Found;
  for I := H to N do
    if S[A[I]] = 0 then
    begin
      Swap(H, I);
      Put(A[H]);
      BT;
      Pick(A[H]);
      Swap(H, I);
    end;
  Dec(H);
end;

procedure Solve;
begin
  Sort(1, M);
  CW := CL;
  Sort2(1, M);
  for I := 1 to N + 1 do begin IndL[I] := M + 1; IndW[I] := M + 1; end;
  for I := M downto 1 do begin IndL[CL[I].L] := I; IndW[CW[I].W] := I; end;
  for I := N downto 1 do
  begin
    if IndL[I] = M + 1 then IndL[I] := IndL[I + 1];
    if IndW[I] = M + 1 then IndW[I] := IndW[I + 1];
  end;
  for I := 1 to N do A[I] := I;
  for I := 1 to M do if CL[I].L < CL[I].R then Inc(S[CL[I].W]);
  BT;
end;

begin
  ReadInput;
  Solve;
  NoSolution;
end.
