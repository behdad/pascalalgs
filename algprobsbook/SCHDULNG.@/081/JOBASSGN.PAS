{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q+,R+,S+,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
April '2000
Problem 81  O(N2) Dynamic, Greedy Mehod
}
program
  JobAssignment;

const
  MaxN = 100;

type
  TJob = record
    S, F, B, Map : Longint;
  end;

var
  N : Integer;
  Job : array [0 .. MaxN] of TJob;
  D1 : array [0 .. MaxN] of Longint;
  P1 : array [0 .. MaxN] of Integer;
  D2 : array [-1 .. MaxN, -1 .. MaxN] of Longint;
  P2 : array [0 .. MaxN, 0 .. MaxN] of Integer;
  Ans : array [1 .. MaxN] of Integer;
  X : Longint;

  I, J, K, L, P : Integer;

procedure ReadInput;
begin
  Assign(Input, 'input.txt');
  Reset(Input);
  Readln(N);
  for I := 1 to N do
    with Job[I] do
      Readln(S, F, B);
  Close(Input);
end;

procedure Sort(l, r: Integer);
var
  i, j, x: integer;
begin
  i := l; j := r; x := job[(l+r) DIV 2].f;
  repeat
    while job[i].f < x do i := i + 1;
    while x < job[j].f do j := j - 1;
    if i <= j then
    begin
      job[0] := job[i]; job[i] := job[j]; job[j] := job[0];
      i := i + 1; j := j - 1;
    end;
  until i > j;
  if l < j then Sort(l, j);
  if i < r then Sort(i, r);
end;

procedure Dynamic1;
begin
  for I := 1 to N do
    with Job[I] do
    begin
      for J := I - 1 downto 0 do
        if (Job[J].F <= S) and (D1[I] <= D1[J]) then
        begin
          D1[I] := D1[J];
          P1[I] := J;
        end;
      Inc(D1[I], B);
    end;
end;

procedure WriteOutput1;
begin
  Assign(Output, 'jobs1.out');
  Rewrite(Output);
  X := -1;
  for I := 1 to N do
    if X < D1[I] then
    begin
      X := D1[I];
      J := I;
    end;
  Write('Selected jobs:');
  while J <> 0 do
  begin
    Write(' ', Job[J].Map);
    J := P1[J];
  end;
  Writeln;
  Writeln('Total benefit = ', X);
  Close(Output);
end;

procedure Dynamic2;
begin
  for I := 0 to N do
    for J := 0 to N do
    begin
      P2[I, J] := -1;
      if (I > J) then
      begin
        D2[I, J] := D2[I - 1, J];
        for K := I - 1 downto 0 do
          if Job[K].F <= Job[I].S then
            Break;
        if D2[I, J] < D2[K, J] + Job[I].B then
        begin
          D2[I, J] := D2[K, J] + Job[I].B;
          P2[I, J] := K;
        end;
      end
      else
      if (J > I) then
      begin
        D2[I, J] := D2[I, J - 1];
        for K := J - 1 downto 0 do
          if Job[K].F <= Job[J].S then
            Break;
        if D2[I, J] < D2[I, K] + Job[J].B then
        begin
          D2[I, J] := D2[I, K] + Job[J].B;
          P2[I, J] := K;
        end;
      end
      else
      begin
        D2[I, J] := D2[I - 1, J - 1];
        for K := I - 1 downto 0 do
          if Job[K].F <= Job[I].S then
            Break;
        if D2[I, J] < D2[K, J - 1] + Job[I].B then
        begin
          D2[I, J] := D2[K, J - 1] + Job[I].B;
          P2[I, J] := K;
        end;
      end;
    end;
end;

procedure WriteOutput2;
begin
  Assign(Output, 'jobs2.out');
  Rewrite(Output);
  I := N; J := N;
  while I + J > 0 do
  begin
    if I > J then
      if P2[I, J] = -1 then
        Dec(I)
      else
      begin
        Ans[I] := 1;
        I := P2[I, J];
      end
    else
    if J > I then
      if P2[I, J] = -1 then
        Dec(J)
      else
      begin
        Ans[J] := 2;
        J := P2[I, J];
      end
    else
      if P2[I, J] = -1 then
      begin
        Dec(I);
        Dec(J);
      end
      else
      begin
        Ans[I] := 1;
        I := P2[I, J];
        Dec(J);
      end
  end;
  for I := 1 to 2 do
  begin
    Write('Jobs to be executed on machine #', I, ':');
    for J := N downto 1 do
      if Ans[J] = I then
        Write(' ', Job[J].Map);
    Writeln;
  end;
  Writeln('Total benefit = ', D2[N, N]);
  Close(Output);
end;

procedure Greedy;
begin
  FillChar(Ans, SizeOf(Ans), 0);
  for J := 1 to N do D1[J] := MaxLongint;
  K := 0;
  for I := N downto 1 do
  begin
    for J := 1 to N do
      if Job[I].F <= D1[J] then
        Break;
    if J > K then
      K := J;
    Ans[I] := J;
    D1[J] := Job[I].S;
  end;
end;

procedure WriteOutput3;
begin
  Assign(Output, 'jobs3.out');
  Rewrite(Output);
  Writeln('Minimum number of machines = ', K);
  for J := 1 to K do
  begin
    Write('Jobs to be executed on machine #', J, ':');
    for I := 1 to N do
      if Ans[I] = J then
        Write(' ', Job[I].Map);
    Writeln;
  end;
  Close(Output);
end;

procedure Solve;
begin
  for I := 1 to N do
    Job[I].Map := I;
  Sort(1, N);
  FillChar(Job[0], SizeOf(Job[0]), 0);
  Dynamic1;
  WriteOutput1;
  Dynamic2;
  WriteOutput2;
  Greedy;
  WriteOutput3;
end;

begin
  ReadInput;
  Solve;
end.
