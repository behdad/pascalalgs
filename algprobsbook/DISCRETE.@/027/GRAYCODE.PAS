{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
September '1999
Problem 27 O(N) Recursive Method
}
program
  GrayCode;

const
  MaxL = 30;

var
  K, LL, LLL, LLLL : Longint;
  S : array [1 .. MaxL] of Byte;
  TT : Longint;
  Time : Longint absolute $40:$6C;
  F : Text;

procedure ReadInput;
begin
  Write('(K, L) : '); Readln(K, LL);  LLL := Trunc(Ln(K - 1) / Ln(2)) + 1;
  Assign(F, 'output.txt');
  ReWrite(F);
  if LL > LLL then LLLL := LL else LLLL := LLL;
end;

function  Max (A, B : Integer) : Integer;
begin if A >= B then Max := A else Max := B; end;

procedure Gray (K : Longint; L, D, A, B : Integer);
var I : Integer;
begin
  if (K = 1) or (L = 0) then begin
    if A + B = 0 then begin
      for I := LLLL downto 1 do Write(F, S[I]);
      Writeln(F);
    end;
  end
  else
    if Odd(K) then Gray(K + 1, L, D, A + D, B + 1 - D)
    else
      for I := 0 to 1 do begin
        S[L] := I + (1 - 2 * I) * D;
        Gray(K div 2, L - 1, I, A * (1 - I), B * I);
      end;
end;

begin
  ReadInput;
  TT := Time;
  Gray(K, LLL, 0, 0, 0);
  Writeln((Time - TT) / 18.2 : 0 : 2);
  Close(F);
end.
