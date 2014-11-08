{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 16384,0,100000}
{
by Behdad Esfahbod
Algorithmic Problems Book
April '2000
Problem 157  O(M2) Dynamic Method
}
program
  LahimKari;

uses
  Graph;

const
  MaxM = 100;

type
  TComponent = record
    S, F, E, R, P : Integer;
    D : array [0 .. MaxM] of Integer;
  end;

var
  N, M : Integer;
  A : array [0 .. MaxM, 1 .. 4] of Integer;
  Comp, Col : array [0 .. MaxM] of Integer;
  Component : array [1 .. MaxM] of TComponent;
  CNum : Integer;
  Stack : array [1 .. 2, 1 .. MaxM] of Integer;
  SN : array [1 .. 2] of Integer;
  Ans : Integer;

  I, J, K : Integer;

procedure ReadInput;
begin
  Assign(Input, 'input.txt');
  Reset(Input);
  Readln(N, M);
  for I := 1 to M do
  begin
    Readln(A[I, 1], A[I, 2]);
    A[I, 4] := I;
  end;
  Close(Input);
  for I := 1 to M do
    if A[I, 1] > A[I, 2] then
    begin
      J := A[I, 1]; A[I, 1] := A[I, 2]; A[I, 2] := J;
    end;
end;

procedure NoSolution;
begin
  Assign(Output, 'output.txt');
  Rewrite(Output);
  Writeln('No Solution');
  Close(Output);
  Halt;
end;

procedure WriteOutput;
begin
  Assign(Output, 'output.txt');
  Rewrite(Output);
  for I := 1 to M do
    Writeln(A[I, 1], ' ', A[I, 2], ' ', A[I, 3]);
  Writeln('Maximum absolute value of heights = ', Ans);
  Close(Output);
end;

procedure Sort(l, r: Integer);
var
  i, j, x: integer;
begin
  i := l; j := r; x := a[(l+r) DIV 2, 1];
  repeat
    while a[i, 1] < x do i := i + 1;
    while x < a[j, 1] do j := j - 1;
    if i <= j then
    begin
      a[0] := a[i]; a[i] := a[j]; a[j] := a[0];
      i := i + 1; j := j - 1;
    end;
  until i > j;
  if l < j then Sort(l, j);
  if i < r then Sort(i, r);
end;

function  Intersect (AS, AF, BS, BF : Integer) : Boolean;
begin
  Intersect := ((AS < BS) and (BS < AF) and (AF < BF)) or
               ((BS < AS) and (AS < BF) and (BF < AF));
end;

procedure Dfs (V, C : Integer);
var
  I : Integer;
begin
  Col[V] := C;
  Comp[V] := CNum;
  with Component[CNum] do
  begin
    if F < A[V, 2] then
      F := A[V, 2];
    if A[R, 1] < A[V, 1] then
      R := V;
  end;
  for I := 1 to M do
    if (I <> V) and Intersect(A[V, 1], A[V, 2], A[I, 1], A[I, 2]) then
      if Col[I] = 0 then
        Dfs(I, 3 - C)
      else
        if Col[I] = C then
          NoSolution;
end;

procedure FindComponents;
begin
  A[0, 1] := 0; A[0, 2] := 0;
  CNum := 0;
  for I := 1 to M do
    if Col[I] = 0 then
    begin
      Inc(CNum);
      with Component[CNum] do
      begin
        S := A[I, 1];
        F := 0; {Will be updated in dfs}
        E := I;
        R := 0; {Will be updated in dfs}
        P := 0;
        for J := CNum - 1 downto 1 do
          if S < Component[J].F then
          begin
            P := J;
            Break;
          end;
      end;
      Dfs(I, 1);
    end;
  for I := 1 to CNum do
  begin
    J := I;
    while (Component[J].P <> 0) and (Component[Component[J].P].R < Component[J].R) do
      with Component[J] do
      begin
        Component[P].R := R;
        J := P;
      end;
  end;
end;

function  Max (A, B : Integer) : Integer;
begin
  if A >= B then Max := A else Max := B;
end;

procedure Dynamic (V : Integer);
var
  H, I : Integer;

  procedure Pop (X : Integer);
  begin
    Dec(SN[X]);
  end;

  procedure Push (I : Integer);
  begin
    Inc(SN[Col[I]]);
    Stack[Col[I], SN[Col[I]]] := I;
  end;

begin {Dynamic}
  with Component[V] do
  begin
    for H := E to R do
      if Comp[H] <> V then
        Dynamic(Comp[H]);
    if E = R then
    begin
      for H := 0 to M do
        D[H] := 0;
      Exit;
    end;
    for H := 0 to M do
    begin
      SN[1] := 0; SN[2] := 0;
      I := E;
      D[H] := 0;
      while I <= R do
      begin
        while (SN[1] > 0) and (A[I, 1] > A[Stack[1, SN[1]], 2]) do Pop(1);
        while (SN[2] > 0) and (A[I, 1] > A[Stack[2, SN[2]], 2]) do Pop(2);
        if Comp[I] = V then
        begin
          Push(I);
          if SN[1] > H then
          begin
            D[H] := MaxInt div 2;
            Break;
          end;
          D[H] := Max(D[H], SN[2]);
        end
        else
        begin
          J := Component[Comp[I]].D[H - SN[1]];
          for K := 0 to M do
            if Component[Comp[I]].D[K] <= H - SN[1] then
            begin
              if (K > 0) and (K < J) then
                J := K;
              Break;
            end;
          if J >= MaxInt div 2 then
          begin
            D[H] := MaxInt div 2;
            Break;
          end;
          D[H] := Max(D[H], J + SN[2]);
          if D[H] >= MaxInt div 2 then
            Break;
          I := Component[Comp[I]].R;
        end;
        Inc(I);
      end;
      if (H > 0) and (D[H] < MaxInt div 2) and (D[H] = D[H - 1]) then
      begin
        for I := H + 1 to M do
          D[I] := D[H];
        Break;
      end;
    end;
  end;
end;

procedure FindMinHeight;
begin
  Ans := 0;
  for I := 1 to CNum do
    with Component[I] do
      if P = 0 then
      begin
        Dynamic(I);
        K := MaxInt div 2;
        for J := 0 to M do
        begin
          if J > K then
            Break;
          if K > Max(J, D[J]) then
            K := Max(J, D[J]);
        end;
        if Ans < K then
          Ans := K;
      end;
end;

procedure FindDir (V, H, Coef : Integer);
var
  I, J : Integer;
  W : array [1 .. 2] of Integer;

  procedure Pop (X : Integer);
  begin
    Dec(SN[X]);
    Dec(W[X]);
  end;

  procedure Push (I : Integer);
  var
    J : Integer;
  begin
    J := Col[I];
    if Coef = -1 then
      J := 3 - J;
    case Col[I] of
      1 : A[I, 3] := Coef *  (H - W[J]);
      2 : A[I, 3] := Coef * -(Component[V].D[H] - W[J]);
    end;
    Inc(W[J]);
    Inc(SN[J]);
    Stack[J, SN[J]] := I;
  end;

begin {FindDir}
  with Component[V] do
  begin
    W[1] := 0; W[2] := 0;
    while (H > 0) and (D[H] = D[H - 1]) do
      Dec(H);
    I := E;
    while I <= R do
    begin
      while (SN[1] > 0) and (A[I, 1] > A[Stack[1, SN[1]], 2]) do Pop(1);
      while (SN[2] > 0) and (A[I, 1] > A[Stack[2, SN[2]], 2]) do Pop(2);
      if Comp[I] = V then
        Push(I)
      else
      begin
        J := 1;
        if Coef = -1 then
          J := 2;
        if (H >= W[J]) and (Component[Comp[I]].D[H - W[J]] <= D[H] - W[3 - J]) then
          FindDir(Comp[I], H - W[J], Coef)
        else
          FindDir(Comp[I], D[H] - W[3 - J], - Coef);
        I := Component[Comp[I]].R;
      end;
      Inc(I);
    end;
    while (SN[1] > 0) and (F >= A[Stack[1, SN[1]], 2]) do Pop(1);
    while (SN[2] > 0) and (F >= A[Stack[2, SN[2]], 2]) do Pop(2);
  end;
end;

procedure FindDirections;
begin
  SN[1] := 0; SN[2] := 0;
  for I := 1 to CNum do
    with Component[I] do
      if P = 0 then
        FindDir(I, Ans, 1);
end;

procedure Solve;
begin
  Sort(1, M);
  FindComponents;
  FindMinHeight;
  FindDirections;
end;

procedure Draw;
var
  GD, GM : Integer;
begin
  GD := Detect;
  InitGraph(GD, GM, '');
  J := 640 div (N + 1);
  if J > 10 then
    SetLineStyle(0, 0, 3);
  for I := 1 to M do
  begin
    SetColor((A[I, 4] - 1) mod 16 + 1);
    Circle(A[I, 1] * J, 240, 2);
    Circle(A[I, 2] * J, 240, 2);
    Line(A[I, 1] * J, 240, A[I, 1] * J, 240 - A[I, 3] * J);
    Line(A[I, 1] * J, 240 - A[I, 3] * J, A[I, 2] * J, 240 - A[I, 3] * J);
    Line(A[I, 2] * J, 240, A[I, 2] * J, 240 - A[I, 3] * J);
  end;
  Assign(Output, '');
  Rewrite(Output);
  Writeln(Ans);
  Assign(Input, '');
  Reset(Input);
  Readln;
  CloseGraph;
end;

begin
  ReadInput;
  Solve;
  WriteOutput;
  Draw;
end.
