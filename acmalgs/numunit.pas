{
 Huge Integer Numbers

 By Mehran
}
unit numunit;
interface
const
  CBase = 10;
  MaxN = 100;
type
  TInt = longint;
  TDigit = integer;
  TWorkDigit = longint;
  TNumber = record
    n:integer;
    a:array [0..MaxN] of TDigit;
  end;

function compareNumber(const a, b:TNumber):integer; (* approved *)
procedure assignInt(var a:TNumber; n:TInt); (* approved *)
function zeroNumber(const a:TNumber):boolean; (* approved *)
function toIntNumber(const a:TNumber):TInt; (* approved *)

function addNumber(const a,b:TNumber; var res:TNumber):boolean; (* approved *)
function mulNumber(const a,b:TNumber; var res:TNumber):boolean; (* approved *)
function subNumber(const a,b:TNumber; var res:TNumber):boolean; (* approved *)
function divNumber(const a,b:TNumber; var d, m:TNumber):boolean;

function addIntNumber(const a:TNumber; b:TInt; var res:TNumber):boolean; (* approved *)
function mulIntNumber(const a:TNumber; b:TInt; var res:TNumber):boolean; (* approved *)
function subIntNumber(const a:TNumber; b:TInt; var res:TNumber):boolean; (* approved *)

function shlNumber(const a:TNumber; b:integer; var res:TNumber):boolean; (* approved *)
procedure shrNumber(const a:TNumber; b:integer; var res:TNumber); (* approved *)

function powNumber(const a:TNumber; pow:integer; var res:TNumber):boolean; (* approved *)
procedure sqrtNumber(const a:TNumber; var res:TNumber);

implementation
function maxInteger(a,b:integer):integer;
begin
  if a > b then maxInteger := a else maxInteger := b;
end;
function minInteger(a,b:integer):integer;
begin
  if a < b then minInteger := a else minInteger := b;
end;

function compareNumber(const a, b:TNumber):integer;
var
  i:integer;
begin
  if a.n <> b.n then
    compareNumber := a.n - b.n
  else begin
    i := a.n - 1;
    while i >= 0 do begin
      if a.a[i] <> b.a[i] then
        break;
      dec(i);
    end;
    compareNumber := a.a[i] - b.a[i];
  end;
end;

procedure assignInt(var a:TNumber; n:TInt);
begin
   a.n := 0;
   while n > 0 do begin
     a.a[a.n] := n mod CBase;
     n := n div CBase;
     inc(a.n);
   end;
   a.a[a.n] := 0;
end;

function zeroNumber(const a:TNumber):boolean;
begin
  zeroNumber := a.n = 0;
end;

function toIntNumber(const a:TNumber):TInt;
var
  return:TInt;
  i:integer;
begin
  return := 0;
  i := a.n;
  while i > 0 do begin
    dec(i);
    return := return * CBase + a.a[i];
  end;
  toIntNumber := return;
end;

function addNumber(const a,b:TNumber; var res:TNumber):boolean;
var
  i:integer;
  c:TDigit;
begin
  res.n := maxInteger(a.n,b.n);
  c := 0;
  i := 0;
  while i < res.n do begin
    inc(c,a.a[minInteger(i,a.n)] + b.a[minInteger(i,b.n)]);
    res.a[i] := c mod CBase;
    c := c div CBase;
    inc(i);
  end;
  if c <> 0 then begin
    res.a[res.n] := 1;
    inc(res.n);
  end;
  if res.n = maxN then
    addNumber := false
  else begin
    res.a[res.n] := 0;
    addNumber := true;
  end;
end;

function mulNumber(const a,b:TNumber; var res:TNumber):boolean;
var
  c:TWorkDigit; (* can be integer *)
  i,j,max:integer;
begin
  res.n := a.n + b.n - 1;
  if res.n >= maxN then begin
    mulNumber := false;
    exit;
  end;
  c := 0;
  for i := 0 to res.n-1 do begin
    for j := 0 to i do
      inc(c,TWorkDigit(a.a[minInteger(j,a.n)]) * b.a[minInteger(i-j,b.n)]);
    res.a[i] := c mod CBase;
    c := c div CBase;
  end;
  if c > 0 then begin
    res.a[res.n] := c;
    inc(res.n);
  end;
  if res.n = maxN then
    mulNumber := false
  else begin
    res.a[res.n] := 0;
    mulNumber := true;
  end;
end;

function subNumber(const a,b:TNumber; var res:TNumber):boolean;
var
  i:integer;
  c:TDigit;
begin
  res.n := maxInteger(a.n,b.n);
  c := 0;
  i := 0;
  while i < res.n do begin
    inc(c,a.a[minInteger(i,a.n)] - b.a[minInteger(i,b.n)]);
    if c < 0 then begin
      res.a[i] := c + CBase;
      c := -1;
    end else begin
      res.a[i] := c;
      c := 0;
    end;
    inc(i);
  end;
  if c = -1 then begin
    c := 1;
    i := 0;
    while i < res.n do begin
      res.a[i] := (CBase - 1) - res.a[i] + c;
      if res.a[i] = CBase then begin
        res.a[i] := 0;
        c := 1;
      end else
        c := 0;
      inc(i);
    end;
    subNumber := false
  end else begin
    subNumber := true;
  end;
  res.a[res.n] := 0;
  while (res.n > 0) and (res.a[res.n-1] = 0) do
    dec(res.n);
end;

function divNumber(const a,b:TNumber; var d, m:TNumber):boolean;
var
  i,j:integer;
  c:TWorkDigit;
  diff2,diff:TDigit;
begin
  if zeroNumber(b) then begin
    divNumber := false;
    exit;
  end;
  if a.n < b.n then begin
    assignInt(d,0);
    m := a;
  end;
  m := a;
  i := a.n - b.n + 1;
  d.n := i;
  d.a[i] := 0;
  while i > 0 do begin
    dec(i);
    d.a[i] := 0;
    for j := i+b.n downto i do begin
      diff := m.a[j] - b.a[j-i];
      if diff <> 0 then
        break;
    end;
    while diff >= 0 do begin
      diff := 0;
      c := 0;
      inc(d.a[i]);
      for j := i to i+b.n do begin
        inc(c,b.a[j-i]-m.a[j]);
        if c < 0 then begin
          m.a[j] := -c;
          c := 0;
        end else if c mod CBase = 0 then begin
          m.a[j] := 0;
          c := c div CBase;
        end else begin
          m.a[j] := CBase - c mod CBase;
          c := c div CBase + 1;
        end;
        diff2 := m.a[j] - b.a[j-i];
        if diff2 <> 0 then
          diff := diff2;
      end;
    end;
    while (m.n > 0) and (m.a[m.n-1] = 0) do
      dec(m.n);
  end;
  while (d.n > 0) and (d.a[d.n-1] = 0) do
    dec(d.n);
  divNumber := true;
end;

function addIntNumber(const a:TNumber; b:TInt; var res:TNumber):boolean;
var
  i:integer;
begin
  res.n := a.n;
  i := 0;
  while i < res.n do begin
    inc(b,a.a[i]);
    res.a[i] := b mod CBase;
    b := b div CBase;
    inc(i);
  end;
  while b > 0 do  begin
    res.a[res.n] := b mod CBase;
    b := b div CBase;
    inc(res.n);
    if res.n = maxN then begin
      addIntNumber := false;
      exit;
    end;
  end;
  res.a[res.n] := 0;
  addIntNumber := true;
end;

function mulIntNumber(const a:TNumber; b:TInt; var res:TNumber):boolean;
var
  i:integer;
  c:TInt;
begin
  res.n := a.n;
  c := 0;
  i := 0;
  while i < res.n do begin
    inc(c,b*a.a[i]);
    res.a[i] := c mod CBase;
    c := c div CBase;
    inc(i);
  end;
  while c > 0 do  begin
    res.a[res.n] := c mod CBase;
    c := c div CBase;
    inc(res.n);
    if res.n = maxN then begin
      mulIntNumber := false;
      exit;
    end;
  end;
  res.a[res.n] := 0;
  mulIntNumber := true;
end;

function subIntNumber(const a:TNumber; b:TInt; var res:TNumber):boolean;
var
  i:integer;
begin
  res.n := a.n;
  i := 0;
  while i < res.n do begin
    dec(b,a.a[i]);
    if b < 0 then begin
      res.a[i] := -b;
      b := 0;
    end else if b mod CBase = 0 then begin
      res.a[i] := 0;
      b := b div CBase;
    end else  begin
      res.a[i] := CBase - b mod CBase;
      b := b div CBase + 1;
    end;
    inc(i);
  end;
  if b > 0 then begin
    subIntNumber := false;
    exit;
  end;
  res.a[res.n] := 0;
  subIntNumber := true;
  while  (res.n > 0) and (res.a[res.n-1] = 0) do
    dec(res.n);
end;

function shlNumber(const a:TNumber; b:integer; var res:TNumber):boolean;
var
  i:integer;
begin
  res.n := a.n + b;
  if res.n >= Maxn then
    shlNumber := false
  else begin
    for i := 0 to a.n do
      res.a[i+b] := a.a[i];
    for i := 0 to b-1 do
      res.a[i] := 0;
    shlNumber := true;
  end;
end;

procedure shrNumber(const a:TNumber; b:integer; var res:TNumber);
var
  i:integer;
begin
  if b > a.n then
    b := a.n;
  res.n := a.n - b;
  for i := a.n downto b do
    res.a[i-b] := a.a[i];
end;

function powNumber(const a:TNumber; pow:integer; var res:TNumber):boolean;
var
  temp:TNumber;
  i:integer;
begin
  powNumber := true;
  i := $4000;
  assignInt(res,1);
  while i > 0 do begin
    if not mulNumber(res,res,temp) then begin
      powNumber := false;
      exit;
    end;
    res := temp;
    if i and pow > 0 then begin
      if not mulNumber(res,a,temp) then begin
        powNumber := false;
        exit;
      end;
      res := temp;
    end;
    i := i shr 1;
  end;
end;

procedure sqrtNumber(const a:TNumber; var res:TNumber);
var
  temp1,temp2,temp3:TNumber;
  i:integer;
begin
  if zeroNumber(a) then begin
    res := a;
    exit;
  end;
  res.n := a.n div 2 + 1;
  for i := 0 to res.n-1 do
    res.a[i] := CBase - 1;
  res.a[res.n] := 0;
  while true do begin
    mulNumber(res,res,temp1);
    if compareNumber(temp1,a) <= 0 then
      break;
    addNumber(temp1,a,temp2);
    mulIntNumber(res,2,temp1);
    divNumber(temp2,temp1,res,temp3);
  end;
end;

end.
