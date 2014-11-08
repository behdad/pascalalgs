{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
September '1999
Problem 24  O(N2) The Only Method!
}
program
  EdgeDisjointCycles;

const
  MaxN = 100;

var
  N, E, N1, E1 : Integer;
  G, V : array [1 .. MaxN, 1 .. MaxN] of Integer;
  D, Pat : array [1 .. MaxN] of Integer;
  M, M1 : array [1 .. MaxN] of Boolean;
  I, J, K, P, Q, R, S : Integer;
  Fl : Boolean;
  F, FO : Text;

procedure ReadInput;
begin
  Assign(F, 'input.txt');
  Reset(F);
  Assign(FO, 'output.txt');
  Rewrite(FO);
  Readln(F, N); N1 := N;
  for I := 2 to N do
  begin
    for J := 1 to I - 1 do
    begin
      Read(F, G[I, J]); G[J, I] := G[I, J];
      if G[I, J] = 1 then
      begin
        Inc(D[I]); Inc(D[J]); Inc(E); Inc(E1);
        if E >= N + 4 then
        begin Close(F); Exit; end;
      end;
    end;
    Readln(F);
  end;
  Writeln(#7'Number of Edges Must Be Greater than or Equal to V + 4.');
  Halt;
end;

procedure WriteOutput;
begin
  Close(FO);
end;

procedure WritePath (A, B : Integer);
begin
  G[A, B] := 0; G[B, A] := 0;
  if V[A, B] = 0 then
    Write(FO, A, ' ')
  else
  begin
    WritePath(A, V[A, B]);
    WritePath(V[A, B], B);
  end;
end;

function  Dfs (V, P : Integer) : Integer;
var
  I, J : Integer;
begin
  Dfs := 0;
  M[V] := True;
  for I := 1 to N do
    if M1[I] and (G[V, I] = 1) then
      if not M[I] then
      begin
        J := Dfs(I, V);
        Dfs := J;
        if J < 0 then Exit else
        if J > 0 then
        begin
          WritePath(I, V);
          if V = J then
            Dfs := -J;
          Exit;
        end;
      end
      else
        if I <> P then
        begin
          WritePath(I, V);
          Dfs := I;
          Exit;
        end;
end;

procedure FindAnotherCycle;
var
  I : Integer;
begin
  FillChar(M, SizeOf(M), 0);
  for I := 1 to N do
    if not M[I] then
      if Dfs(I, 0) <> 0 then
        Exit;
end;

procedure FindCycle3 (A, B, C : Integer);
begin
  WritePath(A, B);
  WritePath(B, C);
  WritePath(C, A);
  Writeln(FO);
  FindAnotherCycle;
  WriteOutput;
  Halt;
end;

procedure FindCycle4 (A, B, C, D : Integer);
begin
  WritePath(A, B);
  WritePath(B, C);
  WritePath(C, D);
  WritePath(D, A);
  Writeln(FO);
  FindAnotherCycle;
  WriteOutput;
  Halt;
end;

procedure FindMinCycle;
var
  I, J, K, L : Integer;
begin
  for I := 1 to N do if M1[I] then
    for J := 1 to N do if M1[J] and (G[I, J] = 1) then
      for K := 1 to N do if M1[K] and (K <> I) and (G[J, K] = 1) then
      begin
        if G[K, I] = 1 then
        begin
          FindCycle3(I, J, K)
        end
        else
          for L := 1 to N do if M1[L] and (L <> J) and (G[K, L] = 1) and (G[L, I] = 1) then
            FindCycle4(I, J, K, L);
      end;
end;

procedure ReduceGraph;
begin
  repeat
    Fl := True;
    for I := 1 to N do
      if D[I] = 1 then
      begin
        Fl := False;
        Break;
      end;
    if not Fl then
    begin
      for J := 1 to N do
        if G[I, J] = 1 then
          Break;
      G[I, J] := 0; G[J, I] := 0; Dec(D[I]); Dec(D[J]); Dec(E1); Dec(N1);
    end;
  until Fl;
  for I := 1 to N do
    if D[I] > 2 then
      M1[I] := True;

  for I := 1 to N do
    if D[I] = 2 then
    begin
      for J := 1 to N - 1 do if G[I, J] = 1 then Break; P := J;
      for J := P + 1 to N do if G[I, J] = 1 then Break; Q := J;
      if G[P, Q] = 1 then
      begin
        FindCycle3(I, P, Q);
        FindAnotherCycle;
        WriteOutput;
        Halt;
      end;

      G[P, I] := 0; G[I, P] := 0; G[Q, I] := 0; G[I, Q] := 0;
      G[P, Q] := 1; G[Q, P] := 1; V[P, Q] := I; V[Q, P] := I;
    end;
end;

begin
  ReadInput;
  ReduceGraph;
  FindMinCycle;
  WriteOutput;
end.
