{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q+,R+,S+,T-,V+,X+,Y+}
{$M 1024,0,655360}
{
by Behdad Esfahbod
Algorithmic Problems Book
April '2000
Problem 74  Simulating
}
program
  Mariage;

uses
  Graph;

const
  MaxN = 400;
  MaxM = 400;
  MaxK = 10000;
  MaxT = 600;
  dx : array [0 .. 4] of Integer = (0, 1, 0, -1, 0);
  dy : array [0 .. 4] of Integer = (0, 0, 1, 0, -1);
  Col : array [-1 .. 1] of Integer = (12, 10, 9);

type
  TP = array [1 .. MaxK] of record X, Y, L : Integer end;
  TR = array [0 .. MaxN + 1] of Integer;

var
  M, N, P, T : Integer;
  B : array [0 .. MaxM + 1] of ^ TR;
  Ps : ^ TP;
  Ans : array [-1 .. 1] of Integer;
  Parvaneh : Boolean;

  I, J, K, Time, D : Integer;

procedure ReadInput;
begin
  Assign(Input, 'input.txt');
  Reset(Input);
  Readln(M, N, P, T);
  Close(Input);
end;

procedure InitOutput;
var
  grDriver: Integer;
  grMode: Integer;
  ErrCode: Integer;
begin
  Assign(Output, 'output.txt');
  Rewrite(Output);
  grDriver := Detect;
  InitGraph(grDriver, grMode,'');
end;

procedure CloseOutput;
begin
  Close(Output);
  Assign(Input, '');
  Reset(Input);
  Readln;
  CloseGraph;
end;

procedure Simulate;
begin
  New(Ps);
  for I := 0 to M + 1 do
  begin
    GetMem(B[I], (N + 2) * SizeOf(B[I]^[0]));
    FillChar(B[I]^, (N + 2) * SizeOf(B[I]^[0]), 127);
  end;
  for I := 1 to M do
    for J := 1 to N do
      B[I]^[J] := 0;
  Randomize;
  for K := 1 to P do
    with Ps^[K] do
    begin
      X := Random(M) + 1;
      Y := Random(N) + 1;
      L := 0;
    end;
  for Time := 1 to T do
  begin
    for K := 1 to P do
      with Ps^[K] do
      begin
        repeat
          D := Random(5);
        until B[X + dx[D]]^[Y + dy[D]] <= P;
        Inc(X, dx[D]);
        Inc(Y, dy[D]);
      end;
    FillChar(Ans, SizeOf(Ans), 0);
    for I := 1 to M do
      for J := 1 to N do
        B[I]^[J] := 0;
    for K := 1 to P do
      with Ps^[K] do
        Inc(B[X]^[Y], L);
    Inc(B[1]^[1]);
    if not Parvaneh and (B[M]^[N] > 0) then
    begin
      Parvaneh := True;
      Col[0] := 11;
    end;
    if Parvaneh then
      B[M]^[N] := -1;
    for K := 1 to P do
      with Ps^[K] do
      begin
        if B[X]^[Y] > 0 then L :=  1 else
        if B[X]^[Y] < 0 then L := -1 else
                             L :=  0;
        Inc(Ans[L]);
      end;
    Write(Time, ':');
    K := 0;
    for I := -1 to 1 do
    begin
      J := Trunc((Ans[I] / P) * 100 + 0.5);
      Write(' ', J, '%');
      SetColor(Col[I]);
      J := Trunc(Ans[I] / P * 480 + 0.5);
      if J <> 0 then
        Line(Time, K, Time, K + J - 1);
      Inc(K, J);
    end;
    Writeln;
  end;
end;

begin
  ReadInput;
  InitOutput;
  Simulate;
  CloseOutput;
end.
