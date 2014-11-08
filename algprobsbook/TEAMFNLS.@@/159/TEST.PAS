uses crt;
var
  f,g:text;
  a,place:array[1..200] of integer;
  m,n:Integer;
  i,j,k,l:Integer;
begin
  assign(f,'input.txt');assign(g,'output.txt');reset(f);reset(g);
  readln(f,n,m);
  for i:=1 to n do
  begin
    read(g,a[i]);
    place[a[i]]:=i;
  end;
  for i:=1 to m do
  begin
    readln(f,j,k,l);
    if (place[k]<place[j]) and (place[k]<place[l]) then
    begin
      writeln('Error');
      exit;
    end;
    if (place[k]>place[j]) and (place[k]>place[l]) then
    begin
      writeln('Error');
      exit;
    end;
  end;
  clrscr;
  close(f);close(g);
  writeln('Ok');
end.