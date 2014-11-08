{
 Maximum Weighted Bipartite Matching

 Hungarian Algorithm  O(N4) but acts like O(N3)

 Input:
  G: UnDirected Simple Bipartite Graph (No Edge = Infinity)
  N: Number of vertices of each part
 Output:
  Mt: Match of Each Vertex (Infinity = Not Matched)
  NoAnswer: Graph does not have complete matching

 Reference:
  West

 By Behdad
}
program
	WeightedBipartiteMatching;

const
	MaxN = 100 + 2;
  Infinity = 10000;

var
	N: Integer;
	G: array [1 .. MaxN, 1 ..	MaxN] of Integer;
  Mt : array [0 .. 1, 0 .. MaxN] of Integer;
  NoAnswer: Boolean;

  Color, P, Cover, Q : array [0 .. 1, 0 .. MaxN] of Integer;
  I, J, K, S, T : Integer;

procedure BFS (V : Integer);
var
  QL, QR: Integer;
begin
  QL := 1;
  QR := 1;
  Q[0, 1] :=  0;
  Q[1, 1] :=  V;
  Color[0, V] := 1;
	while QL <= QR do
  begin
    K := 1 - Q[0, QL];
  	J := Q[1, QL];
    Inc(QL);
    for I := 1 to N do
    begin
      if K = 1 then S := G[J, I] else S := G[I, J];
      if K = 1 then T := Cover[0, J] + Cover[1, I] else T := Cover[1, J] + Cover[0, I];
		  if (Color[K, I] = 0) and (S = T) and ((K = 1) or (Mt[0, I] = J)) then
      begin
        Color[K, I] := 1;
        P[K, I] := J;
    	  Inc(QR);
        Q[0, QR] := K;
        Q[1, QR] := I;
      end;
    end;
  end;
end;

procedure Assignment;
var
  Sum : Longint;
  Count : Integer;
  B : Boolean;
begin
  FillChar(Mt, SizeOf(Mt), 0);
  FillChar(Cover, SizeOf(Cover), 0);
  for I := 1 to N do
	  for J := 1 to N do
    	if G[I, J] > Cover[0, I] then
      	Cover[0, I] := G[I, J];
  repeat
    repeat
      FillChar(Color, SizeOf(Color), 0);
      FillChar(P, SizeOf(P), 0);
      B := False;
      for I := 1 to N do
	     if (Mt[0, I] = 0) and (Color[0, I] = 0) then
  	     BFS(I);
      for J := 1 to N do
        if (Mt[1, J] = 0) and (Color[1, J] = 1) then
        begin
          B := True;
          Break;
        end;
      if B then
      begin
        Dec(Count);
        K := 1;
        while True do
        begin
          if K = 1 then
          begin
					  Mt[1, J] := P[1, J];
            S := J;
          end
          else
            Mt[0, J] := S;
          if P[K, J] = 0 then
            Break;
          J := P[K, J];
          K := 1 - K;
        end;
      end;
    until not B;
    J :=  Infinity;
    for S := 1 to N do
    begin
    	if Color[0, S] = 0 then
        Continue;
    	for T := 1 to N do
        if (Color[1, T] = 0) and (Cover[0, S] + Cover[1, T] - G[S, T] < J) then
        	J := Cover[0, S] + Cover[1, T] - G[S, T];
    end;
    if J < Infinity then
    begin
    	for I := 1 to N do
      begin
      	if Color[0, I] = 1 then
          Dec(Cover[0, I], J);
      	if Color[1, I] = 1 then
          Inc(Cover[1, I], J);
      end;
    end;
  until Count = 0;
  NoAnswer := False;
  for I := 1 to N do
    if G[I, Mt[0, I]] >= Infinity then
    begin
      NoAnswer := True;
      Break;
    end;
end;

begin
  Assignment;
end.
