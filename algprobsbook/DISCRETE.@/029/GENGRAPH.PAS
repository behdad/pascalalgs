var
  infile: text;
  n, i, j, k: integer;
begin
  assign(infile, 'input.txt');
  rewrite(infile);
  readln(n, k);
  writeln(infile, n);
  for i := 2 to n do begin
    for j := 1 to i-1 do begin
      if random(100) > k then write(infile, 0, ' ')
      else write(infile, 1, ' ');
    end;
    writeln(infile);
  end;
  close(infile);
end.