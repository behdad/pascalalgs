{
 Maximum Perfect Matching

 My Augmenting Path Alg.  O(N2.E) Implementation O(N4)
 but very near to O(N.E) Implementation O(N3)

 Input:
  G: UnDirected Simple Graph
  N: Number of vertices
 Output:
  Mt: Match of Each Vertex (0 if not matched)
  Matched: size of matching (number of matched edges)

 By Behdad
}

program
  PerfectMaximumMatching;

const
  MaxN = 100 + 2;

var
  N : Integer;
  G : array [1 .. MaxN, 1 .. MaxN] of Boolean;
  Mt : array [1 .. MaxN] of Integer;
  Mark : array [-1 .. MaxN] of Byte;
  Matched : Integer;

function  Max (A, B : Integer) : Integer;
begin
  if A >= B then Max := A else Max := B;
end;

function  MDfs (V : Integer) : Boolean;
var
  I : Integer;
begin
  if V = 0 then begin MDfs := True; Exit; end;
  Mark[V] := 1;
  for I := 1 to N do
    if G[V, I] and (Mark[Mt[I]] = 0) then
    begin
      Inc(Mark[I]);
      if MDfs(Mt[I]) then
      begin
        Dec(Mark[I]);
        Mt[V] := I;
        Mt[I] := V;
        MDfs := True;
        Exit;
      end;
      Dec(Mark[I]);
    end;
  MDfs := False;
end;

procedure AugmentingPath;
var
  I : Integer;
begin
  FillChar(Mark, SizeOf(Mark), 0);
  FillChar(Mt, SizeOf(Mark), 0);
  Mark[-1] := 1;
  for I := 1 to N do
  begin
    if Mt[I] = 0 then
    begin
      Mt[I] := -1;
      if MDfs(I) then
      begin
        Inc(Matched);
        FillChar(Mark, SizeOf(Mark), 0);
        Mark[-1] := 1;
        I := 0;
        Continue;
      end;
      Mt[I] := 0;
    end;
  end;
end;

begin
  AugmentingPath;
end.
