const
  maxm=30; maxn=30;
  inf='input.txt';
var
  r:array[1..maxm,1..maxn,1..maxn] of boolean;
  a:array[1..maxm,1..maxn] of integer;
  f:text;
  m,n,i,j,k,c,l,p:integer;
begin
  randomize;
  assign(f,inf);
  rewrite(f);
  readln(m,n);
  for l:=1 to trunc((5*n*n*longint(n))/(7*m)) do begin
    i:=random(m)+1; j:=random(n)+1; c:=random(n)+1;
    if not r[i,j,c] then begin
      inc(k);
      a[i,j]:=c;
      for p:=1 to m do r[p,j,c]:=true;
      for p:=1 to n do r[i,p,c]:=true;
      for p:=1 to n do r[i,j,p]:=true;
    end;
  end;
  writeln(f,m,' ',n,' ',k);
  for i:=1 to m do
    for j:=1 to n do if a[i,j]>0 then
      writeln(f,i,' ',j,' ',a[i,j]);
  close(f);
end.