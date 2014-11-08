{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
April '2000
Problem 78  Simulating;
}
program
  LinearPrinter;

const
  MaxL = 255;

var
  L : Integer;
  T : string;
  TP : Integer;
  S : string [MaxL div 2];
  SN : Integer;

  Time : Longint;
  I, J : Integer;

procedure ReadInput;
begin
  Assign(Input, 'input.txt');
  Reset(Input);
  Readln(T);
  Close(Input);
  Assign(Input, 'file.txt');
  Reset(Input);
end;

procedure WriteOutput;
begin
  Close(Input);
  Writeln(Time);
end;

procedure Simulate;
begin
  TP := -1;
  Time := -2;
  while not Eof do
  begin
    Readln(S);
    TP := (TP + 1) mod Length(T);
    Inc(Time);
    SN := Length(S);
    while SN > 0 do
    begin
      for I := 1 to Length(S) do
        if S[I] = T[(I + TP - 1) mod Length(T) + 1] then
        begin
          S[I] := #0;
          Dec(SN);
        end;
      Inc(Time);
      TP := (TP + 1) mod Length(T);
    end;
  end;
end;

begin
  ReadInput;
  Simulate;
  WriteOutput;
end.
