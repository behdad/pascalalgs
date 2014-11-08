{
 Maximum Network Flow

 LiftToFront Alg.  O(N3)

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
  Flow : Longint;

  H : array [1 .. MaxN] of Integer;
  E : array [1 .. MaxN] of Longint;
  LNext, LLast : array [0 .. MaxN] of Integer;

function  Min (A, B : Longint) : Longint;
begin
  if A <= B then Min := A else Min := B;
end;

function  CanPush (A, B : Integer) : Boolean;
begin
  CanPush := (C[A, B] > F[A, B]) and (H[A] > H[B]);
end;

procedure Push (A, B : Integer);
var
  Eps : Integer;
begin
  Eps := Min(E[A], C[A, B] - F[A, B]);
  Dec(E[A], Eps);
  Inc(F[A, B], Eps);
  F[B, A] := - F[A, B];
  Inc(E[B], Eps);
end;

procedure Lift(A : Integer);
var
  I : Integer;
begin
  if A in [S, T] then Exit;
  H[A] := 2 * N;
  for I := 1 to N do
    if (C[A, I] > F[A, I]) and (H[A] > H[I] + 1) then
      H[A] := H[I] + 1;
end;

procedure DisCharge (A : Integer);
var
  I : Integer;
begin
  while E[A] > 0 do
  begin
    Lift(A);
    for I := 1 to N do
      if CanPush(A, I) then
        Push(A, I);
  end;
end;

procedure InitializePreFlow;
var
  I, L : Integer;
begin
  H[S] := N;
  E[S] := MaxLongInt;
  L := 0;
  for I := 1 to N do
  begin
    if I <> S then
      Push(S, I);
    if not (I in [S, T]) then
    begin
      LLast[I] := L;
      LNext[L] := I;
      L := I;
    end;
  end;
end;

procedure MoveToFront (V : Integer);
begin
  LNext[LLast[V]] := LNext[V];
  LLast[LNext[LLast[V]]] := LLast[V];
  LNext[V] := LNext[0];
  LLast[LNext[V]] := V;
  LNext[0] := V;
  LLast[V] := 0;
end;

procedure LiftToFront;
var
  V, BH, I : Integer;
begin
  InitializePreFlow;
  V := LNext[0];
  while V <> 0 do
  begin
    BH := H[V];
    DisCharge(V);
    if BH <> H[V] then
      MoveToFront(V);
    V := LNext[V];
  end;
  Flow := 0;
  for I := 1 to N do
    Inc(Flow, F[S, I]);
end;

begin
  LiftToFront;
end.
