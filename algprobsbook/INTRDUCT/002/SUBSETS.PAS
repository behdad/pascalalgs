{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
August '1999
Problem 2  O(2^N) Recursive Method
}
program
  SubsetGeneration;

const
  MaxN = 100;

var
  N, K : Integer;
  A : array [1 .. MaxN] of Integer;
  AN : Integer;

procedure KSubSets (I, K : Integer);
begin
  if K = 0 then
  begin
    for I := 1 to AN do
      Write(A[I], ' ');
    Writeln;
    Exit;
  end;
  if I > N then Exit;
  Inc(AN);
  A[AN] := I;
  KSubSets(I + 1, K - 1);
  Dec(AN);
  KSubSets(I + 1, K);
end;

procedure SubSets (I : Integer);
begin
  if I = N + 1 then
  begin
    for I := 1 to AN do
      Write(A[I], ' ');
    Writeln;
    Exit;
  end;
  Inc(AN);
  A[AN] := I;
  SubSets(I + 1);
  Dec(AN);
  SubSets(I + 1);
end;

procedure Swap(var I, J : Integer);
var T : Integer;
begin
  T     := A[I];
  A[I] := A[J];
  A[J] := T;
end;

procedure KPermutes (I, K : Integer);
var
  J : Integer;
begin
  if K + 1 = I then
  begin
    for I := 1 to K do
      Write(A[I], ' ');
    Writeln;
    Exit;
  end;
  for J := I to N do
  begin
    Swap(I, J);
    KPermutes(I + 1, K);
    Swap(I, J);
  end;
end;

begin
  Readln(N, K);

  KSubSets(1, K);
  Readln;
  SubSets(1);
  Readln;
  for AN := 1 to N do A[AN] := AN;
  KPermutes(1, K);
end.
