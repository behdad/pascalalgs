var
  Inf:text;
  I,J,t,M,N,K,a1,a2,a3,a4:integer;
  A,B:array[1..40,1..40] of byte;
begin
  Assign(Inf,'input.txt');
  Reset(Inf);
  ReadLn(Inf,M,N);
  for i:=1 to m do
    for j:=1 to N do
      Read(Inf,A[I,j]);
  Close(Inf);

  Assign(Inf,'output.txt');
  Reset(Inf);
  ReadLn(Inf,K);
  WriteLn(K);
  for i:=1 to K do
  begin
    ReadLn(Inf,A1,A2,A3,A4);
    for J:=A1 to A3 do
      for T:=A2 to A4 do
      begin
        B[J,T]:=1;
      end;
  end;
  Close(Inf);
  for i:=1 to 40 do
    for J:=1 to 40 do
    begin
      if A[I,J]<>B[I,J] then
      begin
        WriteLn('Error');
        ReadLn;
        halt;
      end;
    end;
  WriteLn('OK');
end.
