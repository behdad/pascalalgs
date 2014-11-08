{
 System of Linear Equations

 Deletion Method  O(N3)

 Input:
   M: Number of Equations
   N: Number of Xs
   Dij: 1<=i<=M 1<=j<=N Coefficient of Xj in Equation i
   Di(n+1): Equation i's constant value
 Output:
   NoAnswer: System does not have unique answer
   XFound[i]: Xi is unique
   X[i]: Xi (has mean iff XFound[i])
   XFounds: Number of unique Xs (== N => System has unique solution)

 By Behdad
}
program
  EquationsSystem;

const
  MaxM = 100 + 2;
  MaxN = 100 + 2;
  Epsilon = 1E-6;

var
  M, N : Integer;
  D : array [1 .. MaxM, 1 .. MaxN + 1] of Real;
  X : array [1 .. MaxN + 1] of Extended;
  XFound : array [1 .. MaxN] of Boolean;
  XFounds : Integer;
  NoAnswer : Boolean;

function CheckZero (X : Real) : Real;
begin
  if Abs(X) <= Epsilon then
    CheckZero := 0
  else
    CheckZero := X;
end;

procedure IncreaseZeroCoefficients;
var
  I, J, P, Q: Integer;
  R: Real;
begin
  for I := 1 to M do
  begin
    for J := 1 to N + 1 do
      if not XFound[J] and (D[I, J] <> 0) then
        Break;
    if J <= N then
    begin
      for P := 1 to M do
        if (P <> I) and (D[P, J] <> 0) then
        begin
          R := CheckZero(D[P, J] / D[I, J]);
          if R <> 0 then
            for Q := 1 to N + 1 do
              if Q <> J then
                D[P, Q] := CheckZero(D[P, Q] - (D[I, Q] * R));
          D[P, J] := 0;
        end;
      XFound[J] := True;
    end;
  end;
end;

procedure ExtractUniques;
var
  I, J, P, Q : Integer;
begin
  for I := 1 to M do
  begin
    P := 0;
    for J := 1 to N do
      if (D[I, J] <> 0) then
      begin
        Inc(P);
        Q := J;
      end;
    if (P = 0) and (D[I, N + 1] <> 0) then
    begin
      NoAnswer := True;
      Exit;
    end
    else
    if P = 1 then
    begin
      X[Q] := D[I, N + 1] / D[I, Q];
      XFound[Q] := True;
      Inc(XFounds);
    end;
  end;
end;

procedure SolveSystem;
begin
  NoAnswer := False;
  XFounds := 0;
  FillChar(XFound, Sizeof(XFound), 0);
  IncreaseZeroCoefficients;
  FillChar(XFound, Sizeof(XFound), 0);
  ExtractUniques;
end;

begin
  SolveSystem;
end.
