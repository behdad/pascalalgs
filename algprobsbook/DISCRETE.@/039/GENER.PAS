var
  n, k, d, i, j: integer;
  infile: text;
begin
  assign(infile, 'input.txt');
  rewrite(infile);
  readln(n, k, d);
  randseed := 10*n+13*k+17*d;
  writeln(infile, n, ' ', k);
  for i := 2 to n do begin
    for j := 1 to i-1 do
      if random(100)<d then write(infile, 1, ' ')
      else write(infile, 0, ' ');
    writeln(infile);
  end;
  close(infile);
end.
