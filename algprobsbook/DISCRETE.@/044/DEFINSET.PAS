{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P+,Q-,R-,S-,T-,V+,X+,Y+}
{$M 65520,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
September '1999
Problem 44  BackTrack Method
}
program
  DefiningSet;

const
  MaxN = 30;

var
  N, M, Num : Integer;
  G, A : array [1 .. MaxN, 1 .. MaxN] of Integer;
  R, C : array [1 .. MaxN] of Longint;
  I, J, K, L : Integer;
  TT, Cc : Longint;
  Time : Longint absolute $40:$6C;
  Found : Boolean;
  F : Text;

procedure OnR (I, J : Integer);             begin Inc(R[I], Longint(1) shl J); end;
procedure OffR (I, J : Integer);            begin Dec(R[I], Longint(1) shl J); end;
function  StatR (I, J : Integer) : Boolean; begin StatR := R[I] and (Longint(1) shl J) <> 0; end;

procedure OnC (I, J : Integer);             begin Inc(C[I], Longint(1) shl J); end;
procedure OffC (I, J : Integer);            begin Dec(C[I], Longint(1) shl J); end;
function  StatC (I, J : Integer) : Boolean; begin StatC := C[I] and (Longint(1) shl J) <> 0; end;

procedure Put  (I, J, K : Integer);
begin G[I, J] := K; OnR(I, K); OnC(J, K); end;
procedure Pick (I, J : Integer);
begin OffR(I, G[I, J]); OffC(J, G[I, J]); G[I, J] := 0; end;

function  CanPut (I, J, K : Integer) : Boolean;
begin CanPut := not (StatR(I, K) or StatC(J, K)); end;
function  SelNum (I, J : Integer) : Integer;
var K, L : Integer; X : Longint;
begin
  L := 0; X := R[I] or C[J];
  for K := 1 to Num do begin X := X div 2; Inc(L, X mod 2); end;
  SelNum := Num - L;
end;

procedure ReadInput;
begin
  TT := Time;
  Assign(F, 'input.txt');
  Reset(F);
  Readln(F, M, N, K);
  Num := N; if M > N then Num := M;
  for I := 1 to K do
  begin
    Readln(F, J, K, L);
    Put(J, K, L);
  end;
end;

procedure FoundAns;
begin
  if not Found then
  begin
    Found := True;
    A := G;
  end
  else
  begin
    Assign(F, 'output.txt');
    ReWrite(F);
    Writeln(F, 'There is more than one solution:');
    for I := 1 to M do
    begin
      for J := 1 to N do
        Write(F, A[I, J], ' ');
      Writeln(F);
    end;
    Writeln(F);
    for I := 1 to M do
    begin
      for J := 1 to N do
        Write(F, G[I, J], ' ');
      Writeln(F);
    end;
    Close(F);
    Writeln(Cc);
    Writeln((Time - TT) / 18.2 : 0 : 2);
    Halt;
  end;
end;

procedure DelLeaves;
var
  Fl : Boolean;
begin
  repeat
    Fl := True;
    for I := 1 to M do
      for J := 1 to N do
        if (G[I, J] = 0) and (SelNum(I, J) = 1) then
        begin
          for K := 1 to Num do
            if CanPut(I, J, K) then
              Break;
          Put(I, J, K);
          Fl := False;
        end;
  until Fl;
end;

function  FindNext (var X2, Y2 : Integer) : Boolean;
var
  J, X, Y : Integer;
begin
  J := Num + 1;
  for X := 1 to M do
    for Y := 1 to N do
      if (G[X, Y] = 0) and (SelNum(X, Y) < J) then
      begin
        X2 := X; Y2 := Y; J := SelNum(X, Y);
        if J = 0 then begin FindNext := False; Exit; end;
      end;
  FindNext := True;
  if J = Num + 1 then
    X2 := 0;
end;

procedure BT (I, J : Integer);
var
  K, I2, J2 : Integer;
  X : Longint;
begin
  Inc(Cc);
  if I = 0 then begin FoundAns; Exit; end;
  X := R[I] or C[J];
  for K := 1 to Num do
  begin
    X := X div 2;
    if X mod 2 = 0 then
    begin
      Put (I, J, K);
      if FindNext(I2, J2) then
        BT(I2, J2);
      Pick(I, J);
    end;
  end;
end;

procedure DefSet;
var
  X, Y : Integer;
begin
  DelLeaves;
  if FindNext(X, Y) then
    BT(X, Y);
end;

procedure WriteOutput;
begin
  Assign(F, 'output.txt');
  ReWrite(F);
  if not Found then
    Writeln(F, 'Cannot be completed')
  else
  begin
    Writeln(F, 'Is a defining set:');
    for I := 1 to M do
    begin
      for J := 1 to N do
        Write(F, A[I, J] : 2, ' ');
      Writeln(F);
    end;
  end;
  Close(F);
  Writeln(Cc);
  Writeln((Time - TT) / 18.2 : 0 : 2);
end;

begin
  ReadInput;
  DefSet;
  WriteOutput;
end.
