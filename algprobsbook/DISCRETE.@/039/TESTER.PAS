var
  Fin, F : text;
  n, i, j, a, b, md,see : integer;
  D : array[1..100] of byte;
  ad, t: array[0..100,0..100] of byte;
  m:array [1 .. 100] of boolean;

procedure dfs(v:integer);
var i : integer;
begin
  inc(see);
  m[v] := true;
  for i := 1 to n do
    if (t[v, i]=1) and not m[i] then
      dfs(i);
end;

begin
  Assign(Fin, 'output.txt');
  Assign(F, 'input.txt');
  Reset(Fin);
  Reset(F);
  Readln(F, n, md);
  for i := 1 to n do
    for j := 1 to i-1 do begin
      read(f, ad[i,j]);
      ad[j,i] := ad[i,j];
    end;
  for i := 1 to n - 1 do begin
    Readln(Fin, a, b);
    if ad[a,b]=0 then begin
      Writeln('Error');
      Halt;
    end;
    Inc(D[a]);
    Inc(D[b]);
    t[a,b]:=1; t[b,a] :=1;
  end;
  for i := 1 to n do
    if (D[i] = 0) or (D[i] > md) then Writeln('Error');
  dfs(1);
  if see<>n then writeln('not a tree');
  if not seekeof(fin) then
    writeln('too many lines');
  Writeln('Checked');
end.
