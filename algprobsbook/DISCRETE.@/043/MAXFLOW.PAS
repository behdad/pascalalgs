{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 65520,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
September '1999
Problem 43  O(FE) Ford-Folkerson Algorithm
}
program
  MaximumFlow;

const
  MaxN = 100;
  MaxE = 10000;

var
  N, M, S, T : Integer;
  G, H : array [1 .. MaxN, 1 .. MaxN] of Integer;
  E : array [1 .. MaxE, 1 .. 2] of Byte;
  Mark : array [1 .. MaxN] of Boolean;
  I, J, K, L : Integer;
  F : Text;

procedure ReadInput;
begin
  Assign(F, 'input.txt');
  Reset(F);
  Readln(F, N, M, S, T);
  for I := 1 to M do
  begin
    Readln(F, J, K, L);
    G[J, K] := L; E[I, 1] := J; E[I, 2] := K;
  end;
end;

function  ADfs (V : Integer; var MinDelta : Integer) : Boolean;
var
  I : Integer;
  MinDelta2 : Integer;
begin
  Mark[V] := True;
  for I := 1 to N do
  begin
    MinDelta2 := MinDelta;
    if G[V, I] - H[V, I] < MinDelta2 then
      MinDelta2 := G[V, I] - H[V, I];
    if (H[V, I] < G[V, I]) and ((I = T) or (not Mark[I] and ADfs(I, MinDelta2))) then
    begin
      Inc(H[V, I], MinDelta2);
      Dec(H[I, V], MinDelta2);
      ADfs := True;
      MinDelta := MinDelta2;
      Exit;
    end;
  end;
  ADfs := False;
end;

procedure MaxFlow;
var
  MD : Integer;
begin
  repeat
    FillChar(Mark, SizeOf(Mark), 0);
  until not ADfs(S, MD);
end;

procedure WriteOutput;
var
  W : Longint;
begin
  Assign(F, 'output.txt');
  ReWrite(F);
  W := 0;
  for I := 1 to N do
    Inc(W, H[S, I]);
  Writeln(F, W);
  for I := 1 to M do
    Writeln(F, H[E[I, 1], E[I, 2]]);
  Close(F);
end;

begin
  ReadInput;
  MaxFlow;
  WriteOutput;
end.
