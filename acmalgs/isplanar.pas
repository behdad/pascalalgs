{
 Planarity Check

 O(NE) Demoucron-Malgrange Alg.  Implementation O(N4)

 Input:
  G: UnDirected Simple Graph
  N: Number of vertices
 Output:

 Reference:
  West

 By Behdad
}
program
  PlanarityCheck;

const
  MaxN = 50 + 2;

type
  TSet = set of 0 .. MaxN;
  TBridge = record
    V, A, F : TSet; {Vertices, Adj. Vertices, Faces}
    D : Integer;    {Number of Faces}
  end;
  TVertex = record
    F : TSet;    {Faces}
    E : Boolean; {Embedded}
    B : Integer; {Bridge Number}
  end;

var
  N, BN, FN : Integer; {Number of Vertices, Bridges, Faces}
  G, H : array [1 .. MaxN, 1 .. MaxN] of Boolean;
  E : array [1 .. MaxN, 1 .. MaxN, 1 .. 2] of Integer;
  Br : array [1 .. MaxN] of TBridge;
  Vr : array [1 .. MaxN] of TVertex;

procedure NoSolution;
begin
  Writeln('Graph is not planar');
  Halt;
end;

procedure Found;
begin
  Writeln('Graph is planar');
end;

procedure EmbedEdge (I, J, Aa, Bb : Integer; Fl : Boolean);
begin
  G[I, J] := False; G[J, I] := G[I, J];
  H[I, J] := True ; H[J, I] := H[I, J];
  if Fl then
  begin E[I, J, 1] := Aa; E[I, J, 2] := Bb; E[J, I] := E[I, J]; end;
  with Vr[I] do begin E := True; F := F + [Aa, Bb]; B := 0; end;
  with Vr[J] do begin E := True; F := F + [Aa, Bb]; B := 0; end;
end;

procedure ChangeEdge (I, J, Aa, Bb : Integer);
begin
  if E[I, J, 1] = Aa then E[I, J, 1] := Bb else
  if E[I, J, 2] = Aa then E[I, J, 2] := Bb;
  E[J, I] := E[I, J];
  with Vr[I] do F := F - [Aa] + [Bb];
  with Vr[J] do F := F - [Aa] + [Bb];
end;

procedure UpdateBridges; forward;

procedure Initialize;
var
  I, J : Integer;
  Mark : array [1 .. MaxN] of Boolean;
  function Dfs (V, P : Integer) : Boolean;
  var
    I : Integer;
    Fl : Boolean;
  begin
    Mark[V] := True;
    for I := 1 to N do
      if G[V, I] then
      begin
        Fl := Mark[I];
        if (Mark[I] and (I <> P)) or (not Mark[I] and Dfs(I, V)) then
        begin
          if Fl then J := I;
          if J <> 0 then EmbedEdge(V, I, 1, 2, True);
          if not Fl and (I = J) then J := 0;
          Dfs := True;
          Exit;
        end;
      end;
    Dfs := False;
  end;

begin
  BN := 0;
  FillChar(Mark, SizeOf(Mark), 0);
  Dfs(1, 0);
  FN := 2;
  UpdateBridges;
end;

procedure UpdateBridgeFaces (B : Integer);
var
  I : Integer;
begin with Br[B] do begin
  F := [1 .. N];
  for I := 1 to N do if I in A then F := F * Vr[I].F;
  D := 0; for I := 1 to N do if I in F then Inc(D);
end; end;

procedure UpdateBridges;
var
  Mark : array [1 .. MaxN] of Boolean;
  procedure FindBridgeVertices (V : Integer);
  var
    I : Integer;
  begin
    Include(Br[BN].V, V);
    Vr[V].B := BN;
    Mark[V] := True;
    for I := 1 to N do
      if G[V, I] then
        if not Vr[I].E and not Mark[I] then
          FindBridgeVertices(I)
        else
          if Vr[I].E then
            Include(Br[BN].A, I);
  end;
var
  I, J : Integer;
begin
  FillChar(Mark, SizeOf(Mark), 0);
  for I := 1 to N do with Vr[I] do
    if not E and (B = 0) then
    begin
      Inc(BN);
      FillChar(Br[BN], SizeOf(Br[BN]), 0);
      FindBridgeVertices(I);
      UpdateBridgeFaces(BN);
    end;
end;

procedure RelaxBridge (B : Integer);
var
  Mark : array [1 .. MaxN] of Boolean;
  X, Y, J : Integer;
  function  FindPath (V : Integer) : Boolean;
  var
    I : Integer;
  begin
    Mark[V] := True;
    for I := 1 to N do
      if not Mark[I] and G[V, I] and ((I in Br[B].A) or
        ((I in Br[B].V) and FindPath(I))) then
      begin
        if not Mark[I] then Y := I;
        EmbedEdge(V, I, J, FN, True); FindPath := True;
        Exit;
      end;
    FindPath := False;
  end;
var
  I, X2 : Integer;
  S : TSet;
begin
  FillChar(Mark, SizeOf(Mark), 0);
  Inc(FN);
  for I := 1 to N do if I in Br[B].F then begin J := I; Break; end;
  for I := 1 to N do if I in Br[B].A then begin X := I; FindPath(X); Break; end;
  for I := 1 to N do if I in Br[B].V then Vr[I].B := 0;
  Br[B] := Br[BN]; Dec(BN);
  X2 := X;
  repeat
    for I := 1 to N do
      if H[X, I] and ((E[X, I, 1] = J) or (E[X, I, 2] = J)) then
        Break;
    ChangeEdge(X, I, J, FN);
    X := I;
  until X = Y;
  EmbedEdge(X2, Y, J, FN, False);
  for I := 1 to BN do if J in Br[I].F then UpdateBridgeFaces(I);
  UpdateBridges;
end;

procedure RelaxEdge (X, Y : Integer);
var
  I, J, X2 : Integer;
begin
  for J := FN downto 0 do
    if J in Vr[X].F * Vr[Y].F then
      Break;
  if J = 0 then NoSolution;
  Inc(FN);
  X2 := X;
  repeat
    for I := 1 to N do
      if H[X, I] and ((E[X, I, 1] = J) or (E[X, I, 2] = J)) then
        Break;
    ChangeEdge(X, I, J, FN);
    X := I;
  until X = Y;
  EmbedEdge(X2, Y, J, FN, True);
  for I := 1 to BN do if J in Br[I].F then UpdateBridgeFaces(I);
end;

procedure Planar;
var
  I, J : Integer;
  procedure FindMin (var I : Integer);
  var
    J : Integer;
  begin
    I := 1;
    for J := 1 to BN do
      if Br[I].D > Br[J].D then
        I := J;
    if BN = 0 then
      I := 0;
  end;

begin
  BN := 0;
  Initialize;
  repeat
    FindMin(I);
    if I <> 0 then
    begin
      if Br[I].D = 0 then NoSolution;
      RelaxBridge(I);
    end;
    for I := 1 to N do
      for J := 1 to I - 1 do
        if G[I, J] and Vr[I].E and Vr[J].E then
          RelaxEdge(I, J);
  until BN = 0;
end;

begin
  Planar;
  Found;
end.
