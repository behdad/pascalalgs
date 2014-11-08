{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
April '2000
Problem 76  Simulating
}
program
  CarsCircle;

const
  Pi   = 2 * System.Pi;
  MaxN = 100;

type
  TCar = record
    V, V2 : Extended;
    P     : Extended;
    T, T2 : Extended;
  end;
  TCars = array [0 .. MaxN] of TCar;
  TTable = array [0 .. MaxN] of Integer;

var
  N : Integer;
  EndT : Extended;
  Time, MinTime, DT : Extended;
  Car : TCars;
  Table, Map, Map2 : TTable;
  I, J, P, Q : Integer;
  Te : Extended;

procedure ReadInput;
begin
  Assign(Input, 'input.txt');
  Reset(Input);
  Readln(N);
  for I := 1 to N do
    with Car[I] do
    begin
      Readln(P, V);
      P := P * Pi / 100;
      V := V * Pi / 100;
      V2 := V;
      Map[I] := I;
      Table[I] := I;
      T := -1;
    end;
  for I := 1 to N do
    for J := I + 1 to N do
      if Car[Table[I]].P > Car[Table[J]].P then
      begin
        Te := Car[Table[I]].P;
        Car[Table[I]].P := Car[Table[J]].P;
        Car[Table[J]].P := Te;
        P := Map[I];
        Map[I] := Map[J];
        Map[J] := P;
      end;
  for I := 1 to N do
    Map2[Map[I]] := I;
  Readln(EndT);
  Assign(Output, 'output.txt');
  ReWrite(Output);
end;

procedure CloseOutput;
begin
  Close(Input);
  Close(Output);
end;

procedure Simulate;
begin
  Time := 0;
  MinTime := 0;
  DT := 0;
  while True do
  begin
    for I := 1 to n do
      with Car[I] do
      begin
        P := P + V * DT;
        while P > Pi do P := P - Pi;
        while P < 0  do P := P + Pi;
        T2 := 1E30;
      end;
    Q := N;
    if Q < 3 then Dec(Q);
    for I := 1 to Q do
      with Car[Table[I]] do
        if P = Car[Table[I mod N + 1]].P then
        begin
          if V * Car[Table[I mod N + 1]].V < 0 then
          begin
            V2 := -V;
            Car[Table[I mod N + 1]].V2 := -Car[Table[I mod N + 1]].V;
          end
          else
          if Abs(V) > Abs(Car[Table[I mod N + 1]].V) then
            V2 := -V
          else
            Car[Table[I mod N + 1]].V2 := -Car[Table[I mod N + 1]].V;
        end;
    for I := 1 to Q do
      with Car[Table[I]] do
        if V > Car[Table[I mod N + 1]].V then
        begin
          Te := Car[Table[I mod N + 1]].P - P;
          if Te <= 0 then Te := Pi - Te;
          Te := Time + Te / (V - Car[Table[I mod N + 1]].V);
          if Te < T2 then T2 := Te;
          if Te < Car[Table[I mod N + 1]].T2 then Car[Table[I mod N + 1]].T2 := Te;
        end;
    if Time = EndT then
    begin
      for I := 1 to N do
        Writeln(Car[Map2[I]].P * 100 / Pi : 0 : 3);
      Writeln;
      if Eof then
        Break
      else
        Readln(EndT);
    end;
    MinTime := 1E30;
    for I := 1 to N do
    with Car[I] do
    begin
      if T2 < MinTime then MinTime := T2;
      T := T2;
      V := V2;
    end;
    if MinTime > EndT then MinTime := EndT;
    DT := MinTime - Time;
    Time := MinTime;
  end;
end;

begin
  ReadInput;
  Simulate;
  CloseOutput;
end.
