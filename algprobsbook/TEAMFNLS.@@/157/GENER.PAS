var m, n, i, j, k : integer;
  a, p : array [1 .. 200] of integer;
begin
  randomize;
  readln(n, m);
  assign(output, 'input.txt');
  rewrite(output);
  for i := 1 to N do
  begin
    j := random(i) + 1;
    p[i] := p[j];
    p[j] := i;
  end;
  writeln(n, ' ', m);
  for i := 1 to m do
    writeln(p[2 * i], ' ', p[2 * i - 1]);
  close(output);
end.
