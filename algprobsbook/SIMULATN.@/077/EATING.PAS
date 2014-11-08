{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
April '2000
Problem 77  Simulating
}
program
  Eating;

const
  MaxN = 100;

type
  TMan = record
    P : Integer;
    S : Integer;
    T : Longint;
    D : Integer;
    R : Integer;
    G : Integer;
  end;
  TMans = array [0 .. MaxN] of TMan;
  TTable = array [0 .. MaxN] of Byte;
  TF = array [0 .. MaxN] of Extended;

var
  M, N, K : Integer;
  T : Longint;
  Time, MinTime : Longint;
  Mans : TMans;
  Table, Dir, Map : TTable;
  MinF : TF;
  Ate : Integer;
  I, J, P, Q : Integer;
  F : Text;

procedure ReadInput;
begin
  Assign(F, 'input.txt');
  Reset(F);
  Readln(F, N, M, T, K);
  for I := 1 to M do
  begin
    Read(F, Mans[I].P);
    Map[Mans[I].P] := I;
  end;
  Close(F);
end;

procedure WriteOutput;
begin
  Assign(F, 'output.txt');
  ReWrite(F);
  for I :=1 to M do
    Writeln(F, MinF[I] : 0 : 5, ' ');
  Close(F);
end;

procedure Simulate;
begin
  for J := 1 to K do
  begin
    for I := 1 to N do
      Table[I] := 1;
    for I := 1 to M do
    with Mans[I] do
    begin
      S := 0;
      T := 0;
      R := 1;
    end;
    Ate := 0;
    Time := 0;
    MinTime := 0;
    while Ate < M do
    begin
      for I := 1 to N do
        if Table[I] = 1 then
          if  (Map[I] <> 0) and (Map[I mod N + 1] <> 0)
          and (Mans[Map[I]].R = 1) and (Mans[Map[I]].T = Time)
          and (Mans[Map[I mod N + 1]].R = 1)
          and (Mans[Map[I mod N + 1]].T = Time) then
          Dir[I] := Random(2) else Dir[I] := 2 else Dir[I] := 3;
      for I := 1 to M do
        if Mans[I].R = 1 then
          Mans[I].D := Random(2);
      for I := 1 to M do
        if Mans[I].T = Time then
          with Mans[I] do
          case S of
            0 : if (Table[(P + D + N - 2) mod N + 1] = 1) and
                   ((Dir[(P + D + N - 2) mod N + 1] + D = 1)
                or (Dir[(P + D + N - 2) mod N + 1] = 2)) then
                begin
                  Table[(P + D + N - 2) mod N + 1] := 0;
                  S := 1;
                  T := Time + 1;
                  G := D;
                end
                else
                  T := Time + 1;
            1 : begin
                D := 1 - G;
                if (Table[(P + D + N - 2) mod N + 1] = 1) and
                   (Dir[(P + D + N - 2) mod N + 1] + D = 1)
                or (Dir[(P + D + N - 2) mod N + 1] = 2) then
                begin
                  Table[(P + D + N - 2) mod N + 1] := 0;
                  S := 2;
                  T := Time + Eating.T - 1;
                  MinF[I] := (MinF[I] * (J - 1) + T + 1) / J;
                  Inc(Ate);
                end
                else
                begin
                  S := 0;
                  T := Time + 2;
                  Table[(P + G + N - 2) mod N + 1] := 1;
                  R := 1;
                end;
                end;
            2 : begin
                  S := 4;
                  T := MaxLongInt;
                  Table[P] := 1;
                  Table[(P + N - 2) mod N + 1] := 1;
                end;
          end;
      MinTime := MaxLongInt;
      for I := 1 to M do
        if Mans[I].T < MinTime then MinTime := Mans[I].T;
      Time := MinTime;
    end;
  end;
end;

begin
  ReadInput;
  Simulate;
  WriteOutput;
end.