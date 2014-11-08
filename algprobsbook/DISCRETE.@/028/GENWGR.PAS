var
  infile: text;
  n, e, i, j, k, a, b: integer;
  g:array[1..150, 1..150] of boolean;
begin
  randomize;
  assign(infile, 'input.txt');
  rewrite(infile);
  readln(n, e);
  writeln(infile, n, ' ', e);
  for i := 1 to e do begin
    a:=random(n)+1;b:=random(n-1)+1; if a=b then inc(b);
    if g[a,b] then begin dec(i); continue; end;
    g[a,b] := true;g[b,a] :=true;
    writeln(infile, a, ' ', b, ' ', random(100) + 1);
  end;
  close(infile);
end.