{$A+,B-,D+,E+,F-,G+,I-,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 65520,0,0}
{by Behdad Esfahbod  6th IOI  Sweden  Day1 Problem 5 Fold Unit}
unit FoldUnit;{Folds a map}

interface

const
  MaxM = 8;
  MaxN = 4;
  MaxSurface = 16;

type
  TMap   = array [1 .. MaxM, 1 .. MaxN] of string[MaxSurface];

procedure Fold (M1 : TMap; var M2 : TMap; B1, A1 : Integer; var B2, A2 : Integer; L : Integer; D, W : Char);

implementation

procedure Fold;

function Inverse (S : string) : string;
var I, J : Integer;
    T : string;
begin
  T[0] := S[0];
  J := Length(S);
  for I := 1 to J do
      T[I] := S[J + 1 - I];
  Inverse := T;
end;

function Max(A, B : Integer) : Integer;
begin
  if A > B then Max := A else Max := B;
end;

var I, J, K : Integer;
begin
  if D = 'H' then
  begin
    A2 := A1;
    B2 := Max(L, B1 - L);
  end
  else
  begin
    B2 := B1;
    A2 := Max(L, A1 - L);
  end;
  if D = 'H' then
    if W = 'L' then
    begin
      for I := L + 1 to B1 do
        for J := 1 to A1 do
          M1[I, J] := Inverse(M1[I, J]);
      if L >= B1 / 2 then
      begin
        M2 := M1;
        for I := 2 * L - B1 + 1 to L do
          for J := 1 to A1 do
            M2[I, J] := M2[2 * L - I + 1, J] + M2[I, J];
      end
      else
      begin
        for I := 2 * L + 1 to B1 do
          for J := 1 to A1 do
            M2[B1 + 1 - I, J] := M1[I, J];
        for I := 1 to L do
          for J := 1 to A1 do
            M2[B1 - 2 * L + I, J] := M1[2 * L - I + 1, J] + M1[I, J];
      end;
    end
    else
    begin
      for I := 1 to L do
        for J := 1 to A1 do
          M1[I, J] := Inverse(M1[I, J]);
      if L >= B1 / 2 then
      begin
        for I := L + 1 to B1 do
          for J := 1 to A1 do
            M2[I - L, J] := M1[2 * L + 1 - I, J] + M1[I, J];
        for I := 1 to 2 * L - B1 do
          for J := 1 to A1 do
            M2[L - I + 1, J] := M1[I, J];
      end
      else
      begin
        for I := 1 to L do
          for J := 1 to A1 do
            M2[L + 1 - I, J] := M1[I, J] + M1[2 * L - I + 1, J];
        for I := 2 * L + 1 to B1 do
          for J := 1 to A1 do
            M2[I - L, J] := M1[I, J];
      end
    end
  else
    if W = 'R' then
    begin
      for I := L + 1 to A1 do
        for J := 1 to B1 do
          M1[J, I] := Inverse(M1[J, I]);
      if L >= A1 / 2 then
      begin
        M2 := M1;
        for I := 2 * L - A1 + 1 to L do
          for J := 1 to B1 do
            M2[J, I] := M2[J, 2 * L - I + 1] + M2[J, I];
      end
      else
      begin
        for I := 2 * L + 1 to A1 do
          for J := 1 to B1 do
            M2[J, A1 + 1 - I] := M1[J, I];
        for I := 1 to L do
          for J := 1 to B1 do
            M2[J, A1 - 2 * L + I] := M1[J, 2 * L - I + 1] + M1[J, I];
      end;
    end
    else
    begin
      for I := 1 to L do
        for J := 1 to B1 do
          M1[J, I] := Inverse(M1[J, I]);
      if L >= A1 / 2 then
      begin
        for I := L + 1 to A1 do
          for J := 1 to B1 do
            M2[J, I - L] := M1[J, 2 * L + 1 - I] + M1[J, I];
        for I := 1 to 2 * L - A1 do
          for J := 1 to B1 do
            M2[J, L - I + 1] := M1[J, I];
      end
      else
      begin
        for I := 1 to L do
          for J := 1 to B1 do
            M2[J, L + 1 - I] := M1[J, I] + M1[J, 2 * L - I + 1];
        for I := 2 * L + 1 to A1 do
          for J := 1 to B1 do
            M2[J, I - L] := M1[J, I];
    end;
  end;
end;

end.