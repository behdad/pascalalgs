var
  Fin, F : text;
	V : array[1..100] of byte;
  n, i, j, a, b, e : integer;

begin
  Assign(Fin, 'input.txt');
  Assign(F, 'output.txt');
  Reset(Fin);
  Reset(F);
  Readln(F, n);
  for i := 1 to n do begin
    Read(F, j);
    V[j] := 1;
  end;
  Readln(Fin, n, e);
  for i := 1 to e do begin
    Readln(Fin, a, b);
    if (V[a] = 0) and (V[b] = 0) then Writeln(#7'Error ', a, ' ', b);
  end;
  Writeln('Ok');
end.


