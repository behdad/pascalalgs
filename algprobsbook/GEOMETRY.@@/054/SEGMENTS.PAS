{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 16384,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
April '2000
Problem 54  O(N2) Dfs Method
}
program
  FindingPathOnLineSegment;

const
  MaxN = 50;

type
  TSegment = record
    X1, Y1, X2, Y2 : Integer;
  end;

var
  N : Integer;
  S : array [1 .. MaxN] of TSegment;
  Mark : array [1 .. MaxN] of Boolean;
  SX, SY, TX, TY, LX, LY : Integer;

  I, J, X, Y : Integer;

procedure ReadInput;
begin
  Assign(Input, 'input.txt');
  Reset(Input);
  Readln(N);
  for I := 1 to N do
    with S[I] do
    begin
      Readln(X1, Y1, X2, Y2);
      if X1 > X2 then
      begin J := X1; X1 := X2; X2 := J; end;
      if Y1 > Y2 then
      begin J := Y1; Y1 := Y2; Y2 := J; end;
    end;
  Readln(TX, TY);
  Readln(SX, SY);
  Close(Input);
  Assign(Output, 'output.txt');
  Rewrite(Output);
end;

procedure CloseOutput;
begin
  Close(Output);
end;

function  InRange (A, B, C : Integer) : Boolean;
begin
  InRange := (A <= B) and (B <= C);
end;

function  G (I, J : Integer) : Boolean;
begin
  with S[I] do
    G := (X1 <= S[J].X2) and (S[J].X1 <= X2) and
         (Y1 <= S[J].Y2) and (S[J].Y1 <= Y2);
end;

function  Dfs (V : Integer) : Boolean;
var
  I : Integer;
begin
  with S[V] do
    if InRange(X1, TX, X2) and InRange(Y1, TY, Y2) then
    begin
      LX := TX; LY := TY;
      Writeln(TX, ' ', TY);
      Exit;
    end;
  Mark[V] := True;
  for I := 1 to V do
    if not Mark[I] and G(V, I) and Dfs(I) then
      with S[V] do
      begin
        if (X2 - X1) * (S[I].X2 - S[I].X1) +
           (Y2 - Y1) * (S[I].Y2 - S[I].Y1) = 0 then
        begin
          if X1 = X2 then X := X1 else X := S[I].X1;
          if Y1 = Y2 then Y := Y1 else Y := S[I].Y1;
          if (X <> LX) or (Y <> LY) then
            Writeln(X, ' ', Y);
          LX := X; LY := Y;
        end;
        Exit;
      end;
end;

procedure Solve;
begin
  for I := 1 to N do
    with S[I] do
      if InRange(X1, SX, X2) and InRange(Y1, SY, Y2) then
      begin
        if Dfs(I) then
        begin
          Writeln(SX, ' ', SY);
          Exit;
        end;
        Break;
      end;
  Writeln('No Solution');
end;

begin
  ReadInput;
  Solve;
  CloseOutput;
end.
