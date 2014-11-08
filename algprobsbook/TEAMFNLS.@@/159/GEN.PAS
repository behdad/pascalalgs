const
  max=200;
var
  f,g:text;
  l,t,i,j,k,m,n:integer;
  s:string;
  a:array[1..max] of integer;
procedure swap(i,j:integer);
var
  t:integer;
begin
  t:=a[i];a[i]:=a[j];a[j]:=t;
end;

begin
  assign(f,'input.txt');
  rewrite(f);
  readln(n, m);
  for i:=1 to n do
    a[i]:=i;
  randomize;
  writeln(f,n,' ',m);

  for i:=1 to n-1 do
  begin
    j:=random(n-i+1)+1;
    swap(i,j);
  end;
  l:=0;
  while l<m do
  begin
    j:=random(n - 2)+2;
    i:=random(j - 1)+1;
    k:=j+random(n-j)+1;
    begin
      t:=random(2);
      if t=0 then
        writeln(f,a[i],' ',a[j],' ',a[k])
      else
        writeln(f,a[k],' ',a[j],' ',a[i]);
      inc(l);
    end;
  end;


  close(f);
end.