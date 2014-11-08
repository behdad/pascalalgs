{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-
,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
April '2000
Problem 134  O(N) Greedy Method
}
program
  Glasses;

const
  MaxN = 100;

var
  N, M : Integer;
  G : array [1 .. MaxN] of Integer;

  A, B, C, D : Integer;
  I : Integer;

procedure ReadInput;
begin
  Assign(Input, 'input.txt');
  Reset(Input);
  Readln(N);
  for I:=1 to N do G[I]:=0;
	Read(I);
  while I<>0 do
  begin
    Inc(M);
    G[I]:=1;
    Read(I);
  end;
  Close(Input);
  Assign(Output, 'output.txt');
  Rewrite(Output);
end;

procedure NoSolution;
begin
  Writeln('No Solution');
  Close(Output);
  Halt;
end;

procedure CloseOutput;
begin
  Writeln('0 0 0');
  Close(Output);
end;

function FindUp (I : Integer) : Integer;
var
  J : Integer;
begin
  FindUp := 0;
  for J := I + 1 to N do
		if G[J] = 0 then
    begin
      FindUp:=J;
      Break;
    end;
end;

function FindDown (I : Integer) : Integer;
var
  J : Integer;
begin
  FindDown := 0;
  for J:= I + 1 to N do
		if G[J] = 1 then
    begin
      FindDown := J;
      Break;
    end;
end;

procedure Reverse (A, B, C : Integer);
begin
  Writeln(A, ' ', B, ' ', C);
  M := M - G[A] - G[B] - G[C];
  G[A] :=1 - G[A]; G[B] :=1 - G[B]; G[C] :=1 - G[C];
  M := M + G[A] + G[B] + G[C];
end;

procedure Solve;
begin
  case N of
    1, 2 : NoSolution;
  	3 :	if M = 3 then Reverse(1, 2, 3) else
        if M > 0 then NoSolution;
  else
		while M > 0 do
      begin
        if M >= 3 then
        begin
          A := FindDown(0); B := FindDown(A); C := FindDown(B);
          Reverse(A,B,C);
        end
        else
        if M = 2 then
        begin
          A := FindUp(0); B := FindUp(A); C := FindDown(0); D := FindDown(C);
          Reverse(A,B,C); Reverse(A,B,D);
        end
        else
        begin
          A := FindUp(0); B := FindUp(A); C := FindUp(B); D := FindDown(0);
          Reverse(A,B,D); Reverse(A,C,D); Reverse(B,C,D);
        end;
      end;
  end;
end;

begin
  ReadInput;
  Solve;
  CloseOutput;
end.