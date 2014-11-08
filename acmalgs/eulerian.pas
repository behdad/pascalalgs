{
 Eulerian Tour

 Flory Algorithm  O(N2)

 Input:
  G: Directed (not nessecerily simple) connected eulerian graph
  N: Number of vertices
 Output:
  CLength: Length of tour
  C: Eulerian tour

 Reference:
  West

 By Ali
}
program
  EulerianTour;

const
  MaxN = 50 + 2;

var
  N: Integer;
  G: array[1 .. MaxN, 1 .. MaxN] of Integer;
  CLength: Integer;
  C: array[1 .. MaxN * MaxN] of Integer;

  Lcl: Integer;
  Lc: array[1 .. MaxN] of Integer;
  Tb: array[1 .. MaxN * MaxN, 1 .. 2] of Integer;
  Mark, MMark: array[1 .. MaxN] of Boolean;
  MainV: Integer;

function DFS(v: Integer): boolean;
var
  i: Integer;
begin
  if Mark[v] and (v <> MainV) then
  begin
    DFS := false;
    exit;
  end;
  Mark[v] := true;
  Inc(Lcl);
  Lc[Lcl] := v;
  DFS := true;
  if (v = Mainv) and (Lcl > 1) then
    exit;
  for i := 1 to N do
    if G[v, i] > 0 then
    begin
      Dec(G[v, i]);
      { Dec(G[j, i]); // if graph is undirected!!!}
      if DFS(i) then
        exit;
      Inc(G[v, i]);
      { Inc(G[j, i]); // if graph is undirected!!!}
    end;
  Dec(Lcl);
  DFS := false;
end;

function FindACycle(v: Integer): Boolean;
var
  i, j: Integer;
begin
  FindACycle := false;
  if MMark[v] then
    exit;
  FillChar(Mark, SizeOf(Mark), 0);
  Lcl := 0;
  MainV := v;
  DFS(v);
  if Lcl < 2  then
  begin
    MMark[v] := true;
    exit;
  end;
  FindACycle := true;
end;


procedure Euler(v: Integer);
var
  i, j, k, u: Integer;
begin
  Tb[1, 1] := v;
  Tb[1, 2] := 0;
  FillChar(MMark, SizeOf(MMark), 0);
  if not FindACycle(v) then
  begin
    CLength := 0;
    exit;
  end;
  for i := 1 to Lcl do  begin
    Tb[i, 1] := Lc[i];
    Tb[i, 2] := i + 1;
  end;
  Tb[Lcl, 2] := 0;
  k := Lcl;
  u := 1;
  repeat
    while FindACycle(Tb[u, 1]) do  begin
      j := Tb[u, 2];
      Tb[u, 2] := k + 1;
      for i := 2 to Lcl do  begin
        Inc(k);
        Tb[k, 1] := Lc[i];
        Tb[k, 2] := k + 1;
      end;
      Tb[k, 2] := j;
    end;
    u := Tb[u, 2];
  until u = 0;
  u := 1;
  k := 0;
  repeat
    Inc(k);
    C[k] := Tb[u, 1];
    u := Tb[u, 2];
  until u = 0;
  CLength := k;
end;

begin
  Euler(1); {Starting vertex}
end.
