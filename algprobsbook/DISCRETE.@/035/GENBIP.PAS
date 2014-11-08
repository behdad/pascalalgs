var
  infile: text;
  m, n, i, j, k, w: integer;
begin
  randomize;
  assign(infile, 'input.txt');
  rewrite(infile);
  readln(m, n, k, w);
  writeln(infile, m, ' ', n);
  for i := 1 to m do begin
    for j := 1 to n do begin
      if random(100) > k then write(infile, 0, ' ')
      else write(infile, random(w), ' ');
    end;
    writeln(infile);
  end;
  close(infile);
end.