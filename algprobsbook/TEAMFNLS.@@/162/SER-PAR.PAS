{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 1024,0,0}
{
by Behdad Esfahbod
Algorithmic Problems Book
April '2000
Problem 162  Dfs Method  O(N2)
}
program
  SerialParallelCircuit;

const
  MaxN = 100 + 1;
  MaxE = 3 * MaxN div 2 + 1;

var
  N, E, S, T : Integer;
  G : array [1 .. MaxN, 1 .. 3] of Integer;
  R : array [1 .. MaxN, 1 .. MaxN] of Real;
  D : array [1 .. MaxN] of Integer;
  Stack : array [1 .. MaxE] of record
    Sr, Tr, Md, V1, V2, V3, V4 : Integer;
  end;
  StNum : Integer;
  IsTerm : array [1 .. MaxN] of Boolean;
  Mark : array [1 .. MaxN] of Integer;
  DfsN : Integer;

  I, J, K, P, Q : Integer;

procedure NoSolution;
begin
  Assign(Output, 'output.txt');
  Rewrite(Output);
  Writeln('Is not serial-parallel');
  Close(Output);
  Halt;
end;

procedure WriteAnswer;
begin
  Assign(Output, 'output.txt');
  Rewrite(Output);
  Writeln('Is serial-parallel');
  Writeln(R[S, T] : 0 : 2);
  Close(Output);
  Halt;
end;

procedure ReadInput;
begin
  Assign(Input, 'input.txt');
  Reset(Input);
  Readln(N, E, S, T);
  for I := 1 to E do
  begin
    Readln(P, Q);
    Inc(D[P]);
    Inc(D[Q]);
    if (D[P] > 3) or (D[Q] > 3) then
      NoSolution;
    G[P, D[P]] := Q;
    G[Q, D[Q]] := P;
  end;
  for I := 1 to N do
    if (D[I] = 1) and not (I in [S, T]) then
      NoSolution;
  if (D[S] = 3) or (D[T] = 3) then
    NoSolution;
  Close(Input);
end;

function  Min (A, B : Integer) : Integer;
begin
  if A <= B then Min := A else Min := B;
end;

var
  CE1, CE2, NTerm : Integer; {Cut Edge Vertices}

function  Dfs (V, P : Integer) : Integer;
var
  I, J, K : Integer;
begin
  Inc(DfsN);
  Mark[V] := DfsN;
  K := Mark[V];
  for I := 1 to D[V] do
    if Mark[G[V, I]] = 0 then
    begin
      if IsTerm[G[V, I]] then
        NTerm := G[V, I];
      J := Dfs(G[V, I], V);
      K := Min(K, J);
      if J > Mark[V] then
      begin
        CE1 := V;
        CE2 := G[V, I];
      end;
    end
    else
      if G[V, I] <> P then
        K := Min(K, Mark[G[V, I]]);
  Dfs := K;
end;

procedure Delete (I, J : Integer);
var
  K : Integer;
begin
  for K := 1 to D[I] - 1 do
    if G[I, K] = J then
    begin
      G[I, K] := G[I, D[I]];
      Break;
    end;
  Dec(D[I]);
end;

var
  Flag : Boolean;

procedure SetTerm (I : Integer);
begin
  if IsTerm[I] then
    NoSolution;
  IsTerm[I] := True;
end;

procedure CalcResistants;
var
  J, K : Real;
begin
  for I := StNum downto 1 do
    with Stack[I] do
    begin
      case Md of
        0: R[Sr, Tr] := 1;
        1: R[Sr, Tr] := 1 + R[V1, Tr];
        2: R[Sr, Tr] := R[Sr, V1] + R[V2, Tr];
        4:
        begin
          J := R[V1, V3] + R[V1, V4];
          K := R[V2, V3] + R[V2, V4];
          R[Sr, Tr] := J * K / (J + K);
        end;
      end;
      R[Tr, Sr] := R[Sr, Tr];
    end;
end;

procedure Solve;
begin
  SetTerm(S);
  SetTerm(T);
  DfsN := 0;
  Dfs(S, 0);
  if Mark[T] = 0 then
    NoSolution;
  repeat
    Flag := True;
    for I := 1 to N do
      if IsTerm[I] then
        if D[I] > 1 then
        begin
          CE1 := 0;
          DfsN := 0;
          FillChar(Mark, SizeOf(Mark), 0);
          Dfs(I, 0);
          if CE1 = 0 then
          begin
            Inc(StNum);
            with Stack[StNum] do
            begin
              Sr := I;
              Tr := NTerm;
              Md := 4;
              V1 := G[I, 1];
              V2 := G[I, 2];
              V3 := G[NTerm, 1];
              V4 := G[NTerm, 2];
            end;
            SetTerm(G[I, 1]);
            SetTerm(G[I, 2]);
            SetTerm(G[NTerm, 1]);
            SetTerm(G[NTerm, 2]);
            Delete(G[I, 1], I);
            Delete(G[I, 2], I);
            Delete(G[NTerm, 1], NTerm);
            Delete(G[NTerm, 2], NTerm);
            Dec(E, 4);
            IsTerm[I] := False;
            IsTerm[NTerm] := False;
            Flag := False;
          end
          else
          begin
            Inc(StNum);
            with Stack[StNum] do
            begin
              Sr := I;
              Tr := NTerm;
              Md := 2;
              V1 := CE1;
              V2 := CE2;
            end;
            SetTerm(CE1);
            SetTerm(CE2);
            Delete(CE1, CE2);
            Delete(CE2, CE1);
            Flag := False;
            Dec(E);
          end;
        end
        else
        begin
          Inc(StNum);
          DfsN := 0;
          FillChar(Mark, SizeOf(Mark), 0);
          Dfs(I, 0);
          with Stack[StNum] do
          begin
            Sr := I;
            Tr := NTerm;
            Md := 0;
          end;
          if IsTerm[G[I, 1]] xor (D[G[I, 1]] = 1) then
            NoSolution;
          IsTerm[I] := False;
          IsTerm[G[I, 1]] := False;
          Delete(G[I, 1], I);
          Delete(I, G[I, 1]);
          Dec(E);
          if D[G[I, 1]] > 1 then
            NoSolution;
          if D[G[I, 1]] > 0 then
          begin
            if IsTerm[G[G[I, 1], 1]] then
              NoSolution;
            with Stack[StNum] do
            begin
              Md := 1;
              V1 := G[G[I, 1], 1];
            end;
            Delete(G[I, 1], G[G[I, 1], 1]);
            Delete(G[G[I, 1], 1], G[I, 1]);
            if D[G[G[I, 1], 1]] = 0 then
              NoSolution;
            SetTerm(G[G[I, 1], 1]);
            Dec(E);
          end;
        end;
  until Flag;
  if E <> 0 then
    NoSolution;
  CalcResistants;
end;

begin
  ReadInput;
  Solve;
  WriteAnswer;
end.
