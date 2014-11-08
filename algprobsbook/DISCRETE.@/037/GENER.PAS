var
  infile : text;
  n, p, i, j: integer;
begin
  assign(infile, 'input.txt');
  rewrite(infile);
  readln(n, p);
  writeln(infile, n);
  randomize;
  for i := 1 to n do begin
    for j := 1 to n do begin
      if random(100) <= p then write(infile, random(100), ' ')
      else write(infile, 10000, ' ');
    end;
    writeln(infile);
  end;
  close(infile);
end.