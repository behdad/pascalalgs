var
  i, j, n, e, d: integer;
  infile: text;
  ad: array[0..101,0..101] of integer;
begin
  assign(infile, 'input.txt');
  rewrite(infile);
  readln(n, d);
  randomize;
  for i := 1 to n do
    for j := 1 to i-1 do
      if random(100)<d then begin
        ad[i,j] := 1;
        ad[j,i] := 1;
        inc(e);
      end;
  writeln(infile, n, ' ', e);
  for i := 2 to n do
    for j := 1 to i-1 do if ad[i,j]=1 then
      writeln(infile, i, ' ', j);
  close(infile);
end.
