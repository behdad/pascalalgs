var
  infile: text;
  n, i, j, k: integer;
begin
  randomize;
  assign(infile, 'input.txt');
  rewrite(infile);
  readln(n);
  writeln(infile, n);
  for i := 1 to n do begin
    for j := 1 to n do
      if (i=j)or(50<random(100)) then write(infile, 10000, ' ')
      else write(infile, random(100):5, ' ');
    writeln(infile);
  end;
  close(infile);
end.