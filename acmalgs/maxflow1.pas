{
 Maximum Netword Flow

 Ford Fulkerson Alg.  O(N.E2) Implemantation O(N5)

 Input:
  N: Number of vertices
  C: Capacities (No restrictions)
  S, T: Source, Target(Sink)
 Output:
  F: Flow (SkewSymmetric: F[i, j] = - F[j, i])
  Flow: Maximum Flow

 Reference:
  CLR

 By Behdad
}
program
  MaximumFlow;

const
  MaxN = 100 + 2;

var
  N, S, T : Integer;
  C, F : array [1 .. MaxN, 1 .. MaxN] of Integer;
  Mark : array [1 .. MaxN] of Boolean;
  Flow : Longint;

function  Min (A, B : Integer) : Integer;
begin
  if A <= B then
    Min := A
  else
    Min := B;
end;

function  FDfs (V, LEpsilon : Integer) : Integer;
var
  I, Te : Integer;
begin
  if V = T then
  begin
    FDfs := LEpsilon;
    Exit;
  end;
  Mark[V] := True;
  for I := 1 to N do
    if (C[V, I] > F[V, I]) and not Mark[I] then
    begin
      Te := FDfs(I, Min(LEpsilon, C[V, I] - F[V, I]));
      if Te > 0 then
      begin
        F[V, I] := F[V, I] + Te;
        F[I, V] := - F[V, I];
        FDfs := Te;
        Exit;
      end;
    end;
  FDfs := 0;
end;

procedure FordFulkerson;
var
  Flow2 : Longint;
begin
  repeat
    FillChar(Mark, SizeOf(Mark), 0);
    Flow2 := Flow;
    Inc(Flow, FDfs(S, MaxInt));
  until Flow = Flow2;
end;

begin
  FordFulkerson;
end.
