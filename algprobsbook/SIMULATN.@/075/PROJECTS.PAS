{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
April '2000
Problem 74  Simulating
}
program
  ProjectsSimulation;

const
  MaxN = 20;
  MaxM = 20;
  MaxK = 20;

var
  N, M, K : Integer;
  T : array [1 .. MaxN] of Extended;
  TI : array [1 .. MaxK] of Extended;
  R : array [1 .. MaxN, 1 .. MaxN] of Boolean;
  DR : array [1 .. MaxK, 1 .. MaxN] of Integer;

  Mach : array [1 .. MaxM] of record
    Kk, Nn : Integer;
    Tt : Extended;
  end;
  DT : array [1 .. MaxK, 1 .. MaxN + 1] of Extended;
  DQ : array [1 .. MaxK * MaxN] of record
    Kk, Nn, Mm : Integer;
    Tt : Extended
  end;
  DN : Integer;

  I, J, P : Integer;
  Time, Time2 : Extended;

procedure ReadInput;
begin
  Assign(Input, 'input.txt');
  Reset(Input);
  Readln(N, M, K);
  for J := 1 to N do
  begin
    Read(T[J]);
    while not SeekEoln do
    begin
      Read(P);
      R[P, J] := True;
      Inc(DR[1, J]);
    end;
    Readln;
  end;
  for I := 1 to K do
  begin
    DR[I] := DR[1];
    Read(TI[I]);
  end;
  Close(Input);
end;

procedure WriteOutput;
begin
  Assign(Output, 'output.txt');
  Rewrite(Output);
  for I := 1 to M do
  begin
    Writeln('Machine #', I, ':');
    for J := 1 to K * N do
      with DQ[J] do
        if Mm = I then
          Writeln(' Starts job #', Nn, ' of project #', Kk, ' at time ', Tt : 0 : 1);
    Writeln;
  end;
  Writeln(Time : 0 : 1);
  Close(Output);
end;

procedure Simulate;
begin
  for I := 1 to K do
    for J := 1 to N do
      DT[I, J] := -1;
  while DN < K * N do
  begin
    Time := 1E30;
    for P := 1 to M do
      if Mach[P].Tt < Time then
        Time := Mach[P].Tt;
    if Time < Time2 then
      Time := Time2;
    Time2 := 0;
    for P := 1 to M do
      with Mach[P] do
        if (Tt <= Time) and (Nn <> 0) then
        begin
          for I := 1 to N do
            if R[Nn, I] then
              Dec(DR[Kk, I]);
          Nn := 0;
        end;
    for P := 1 to M do
      with Mach[P] do
        if (Tt <= Time) and (Nn = 0) then
        begin
          for I := 1 to K do
          begin
            for J := 1 to N + 1 do
              if (Time >= TI[I]) and (DT[I, J] < 0) and (DR[I, J] = 0) then
                Break;
            if J <= N then
              Break;
          end;
          if J <= N then
          begin
            DT[I, J] := Time + T[J];
            Tt := Time + T[J];
            Nn := J;
            Kk := I;
            Inc(DN);
            with DQ[DN] do
            begin
              Mm := P;
              Tt := Time;
              Nn := J;
              Kk := I;
            end;
          end
          else
            Time2 := 1E30;
            for I := 1 to M do
              with Mach[I] do
                if (Tt > Time) and (Tt < Time2) then
                  Time2 := Tt;
            for I := 1 to K do
              if (TI[I] > Time) and (TI[I] < Time2) then
                  Time2 := TI[I];
        end;
  end;
  for P := 1 to M do
    if Mach[P].Tt > Time then
      Time := Mach[P].Tt;
end;

begin
  ReadInput;
  Simulate;
  WriteOutput;
end.
