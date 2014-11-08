unit geomunit;
interface
const
  MaxN = 100;
  Epsilon = 1e-6;
type
  TNumber = real;
  TAngle = TNumber;
  TPoint = record
    x,y:TNumber;
  end;
  TLine = record
    a,b,c:TNumber;
  end;
  TCircle = record
    o:TPoint;
    r2:TNumber;
  end;
  TPoly = record
    n:integer;
    p:array [1..MaxN] of TPoint;
  end;

  procedure addPoint(const o:TPoint;var p:TPoint); (* confirmed *)
  procedure subPoint(const o:TPoint;var p:TPoint); (* confirmed *)
  function lineValue(const l:TLine; const p:TPoint):TNumber; (* confirmed *)
  function circleValue(const c:TCircle; const p:TPoint):TNumber; (* confirmed *)
  function comp(const n1,n2:TNumber):integer; (* confirmed *)
  function normal(const l:TLine; var res:TLine):boolean; (* confirmed *)
  function sameLine(l1,l2:TLine):boolean; (* confirmed *)
  function getLine(const p1,p2:TPoint;var l:TLine):boolean; (* confirmed *)
  function intersection(const l1,l2:TLine;var p:TPoint):integer; (* confirmed *)
  function polygonArea(const p:TPoly):TNumber; (* confirmed *)
  function pointDist2(const p1,p2:TPoint):TNumber; (* confirmed *)
  function amoodMonasef(const p1,p2:TPoint;var l:TLine):boolean; (* confirmed *)
  procedure amoodBar(const l:TLine;const p:TPoint;var res:TLine); (* confirmed *)
  procedure movaziBa(const l:TLine;const p:TPoint;var res:TLine); (* confirmed *)
  procedure Rotate(const o, p: TPoint; alpha: TAngle; var res: TPoint); (* confirmed *)
  function lineAng(l: TLine): TAngle; (* confirmed *)
  function angle(const l1, l2: TLine): TAngle; (* confirmed *)
  function solve(a,b,c:TNumber;var x1,x2:TNumber):integer; (* confirmed *)
  function solvePrim(a,b,c:TNumber;var x1,x2:TNumber):integer; (* confirmed *)
  function circleCircle(c1,c2:TCircle; var p1, p2:TPoint):integer; (* confirmed *)
  function lineCircle(const l:TLine; const c:TCircle; var p1, p2:TPoint):integer; (* confirmed *)
  function momasCircle(const p:TPoint; const c:TCircle; var p1, p2:TPoint):integer; (* confirmed *)

implementation

procedure swapNumber(var a,b:TNumber);
var
  c:TNumber;
begin
  c := a;
  a := b;
  b := c;
end;

procedure addPoint(const o:TPoint;var p:TPoint);
begin
  p.x := p.x + o.x;
  p.y := p.y + o.y;
end;

procedure subPoint(const o:TPoint;var p:TPoint);
begin
  p.x := p.x - o.x;
  p.y := p.y - o.y;
end;

function lineValue(const l:TLine; const p:TPoint):TNumber;
begin
  lineValue := l.a*p.x+l.b*p.y+l.c;
end;

function circleValue(const c:TCircle; const p:TPoint):TNumber;
begin
  circleValue := sqr(p.x - c.o.x) + sqr(p.y - c.o.y) - c.r2;
end;

function comp(const n1,n2:TNumber):integer;
var
  diff:TNumber;
begin
  diff := n1 - n2;
  if abs(diff) < Epsilon then
    comp := 0
  else if diff < 0 then
    comp := -1
  else
    comp := 1;
end;

function samePoint(const p1,p2:TPoint):boolean;
begin
  samePoint := (comp(p1.x, p2.x) = 0) and (comp(p1.y, p2.y) = 0);
end;

function normal(const l:TLine; var res:TLine):boolean;
var
  denom:TNumber;
begin
  denom := sqrt(sqr(l.a) + sqr(l.b));
  if comp(denom,0) = 0 then
    normal := false
  else begin
    res.a := l.a / denom;
    res.b := l.b / denom;
    res.c := l.c / denom;
    normal := true;
  end;
end;

function sameLine(l1,l2:TLine):boolean;
begin
  if normal(l1,l1) and normal(l2,l2) then begin
    sameLine := (comp(l1.a,l2.a) = 0) and
                (comp(l1.b,l2.b) = 0) and
                (comp(l1.c,l2.c) = 0) or
                (comp(l1.a,-l2.a) = 0) and
                (comp(l1.b,-l2.b) = 0) and
                (comp(l1.c,-l2.c) = 0);
  end else begin
    sameLine := false;
  end;
end;

function getLine(const p1,p2:TPoint;var l:TLine):boolean;
begin
  if samePoint(p1,p2) then
    getLine := false
  else begin
    l.a := p1.y - p2.y;
    l.b := p2.x - p1.x;
    l.c := p1.x * p2.y - p2.x * p1.y;
    getLine := true;
  end;
end;

function intersection(const l1,l2:TLine;var p:TPoint):integer;
var
  denom:TNumber;
begin
  denom := l1.a * l2.b - l2.a * l1.b;
  if comp(denom,0) = 0 then begin
    if sameLine(l1,l2) then
      intersection := 2
    else
      intersection := 0;
  end else begin
    intersection := 1;
    p.x := (l1.b * l2.c - l2.b * l1.c) / denom;
    p.y := (l1.c * l2.a - l2.c * l1.a) / denom;
  end;
end;

function polygonArea(const p:TPoly):TNumber;
var
  x1,y1,x2,y2,x3,y3:TNumber;
  i:integer;
  return:TNumber;
begin
  with p do begin
    return := 0;
    x1 := p[1].x;
    y1 := p[1].y;
    x2 := p[2].x;
    y2 := p[2].y;
    for i := 3 to n do begin
      with p[i] do begin
        x3 := x;
        y3 := y;
      end;
      return := return + (y3-y1)*(x2-x1)-(y2-y1)*(x3-x1);
      x2 := x3;
      y2 := y3;
    end;
    return := abs(return / 2);
  end;
  polygonArea := return;
end;

function pointDist2(const p1,p2:TPoint):TNumber;
begin
  pointDist2 := sqr(p1.x-p2.x)+sqr(p1.y-p2.y);
end;
function amoodMonasef(const p1,p2:TPoint;var l:TLine):boolean;
begin
  l.a := p1.x - p2.x;
  l.b := p1.y - p2.y;
  l.c := (sqr(p2.x) + sqr(p2.y) - sqr(p1.x) - sqr(p1.y)) / 2;
  amoodMonasef := (comp(l.a,0) = 0) or (comp(l.b,0) = 0);
end;

procedure amoodBar(const l:TLine;const p:TPoint;var res:TLine);
begin
  res.a := -l.b;
  res.b := l.a;
  res.c := l.b * p.x - l.a * p.y;
end;

procedure movaziBa(const l:TLine;const p:TPoint;var res:TLine);
begin
  res.a := l.a;
  res.b := l.b;
  res.c := -l.a * p.x - l.b * p.y;
end;

procedure Rotate(const o, p: TPoint; alpha: TAngle; var res: TPoint);
var
  t: TPoint;
begin
  t.x := p.x - o.x;
  t.y := p.y - o.y;
  res.x := t.x * cos(alpha) - t.y * sin(alpha) + o.x;
  res.y := t.y * cos(alpha) + t.x * sin(alpha) + o.y;
end;

function lineAng(l: TLine): TAngle;
var
  A: TAngle;
begin
  if comp(l.b,0) = 0 then
    if l.a < 0 then  lineAng := Pi / 2
    else                 lineAng := 3 * Pi / 2
  else
  begin
    A := ArcTan(-l.a/l.b);
    if l.b < 0 then  A := A + Pi;
    if A < 0 then  A := A + 2 * Pi;
    lineAng := A;
  end;
end;

function angle(const l1, l2: TLine): TAngle;
var
  a: TAngle;
begin
  a := lineAng(l2) - lineAng(l1);
  if a < 0 then
    a := a + 2 * pi;
  angle := A;
end;

function solve(a,b,c:TNumber;var x1,x2:TNumber):integer;
var
  delta :TNumber;
begin
  delta := sqr(b) - 4 * a * c;
  case comp(delta,0) of
    -1:solve := 0;
    0: begin
      solve := 1;
      x1 := -b/(2*a);
      x2 := x1;
    end;
    1: begin
      solve := 2;
      delta := sqrt(delta);
      x1 := (-b+delta)/(2*a);
      x2 := (-b-delta)/(2*a);
    end;
  end;
end;

function solvePrim(a,b,c:TNumber;var x1,x2:TNumber):integer;
var
  delta :TNumber;
begin
  delta := sqr(b) - a * c;
  case comp(delta,0) of
    -1:solvePrim := 0;
    0: begin
      solvePrim := 1;
      x1 := -b/a;
      x2 := x1;
    end;
    1: begin
      solvePrim := 2;
      delta := sqrt(delta);
      x1 := (-b+delta)/a;
      x2 := (-b-delta)/a;
    end;
  end;
end;

function circleCircle(c1,c2:TCircle; var p1, p2:TPoint):integer;
var
  d2,v:TNumber;
  o:TPoint;
  return:integer;
begin
  o := c1.o;
  subPoint(o,c2.o);
  subPoint(o,c1.o);
  d2 := pointDist2(c1.o,c2.o);
  v := c1.r2 - c2.r2 + d2;
  return :=
  solvePrim(4*d2,-2*c2.o.x*v,sqr(v)-4*sqr(c2.o.y)*c1.r2,p1.x,p2.x);
  solvePrim(4*d2,-2*c2.o.y*v,sqr(v)-4*sqr(c2.o.x)*c1.r2,p2.y,p1.y);
  if (return > 1) and
     ((comp(circleValue(c1,p1),0)<>0) or (comp(circleValue(c2,p1),0)<>0)) then
    swapNumber(p1.x,p2.x);
  addPoint(o,p1);
  addPoint(o,p2);
  circleCircle := return;
end;

function lineCircle(const l:TLine; const c:TCircle; var p1, p2:TPoint):integer;
var
  x1,x2,y1,y2,v:TNumber;
  n,return:integer;
begin
  v := lineValue(l,c.o);
  return :=
  solvePrim(sqr(l.a)+sqr(l.b),l.a*v,sqr(v)-c.r2*sqr(l.b),p1.x,p2.x);
  solvePrim(sqr(l.a)+sqr(l.b),l.b*v,sqr(v)-c.r2*sqr(l.a),p2.y,p1.y);
  addPoint(c.o,p1);
  addPoint(c.o,p2);
  if (return > 1) and
     ((comp(linevalue(l,p1),0)<>0) or (comp(circlevalue(c,p1),0)<>0)) then
    swapNumber(p1.x,p2.x);
  lineCircle := return;
end;

function momasCircle(const p:TPoint; const c:TCircle; var p1, p2:TPoint):integer;
var
  c2:TCircle;
begin
  c2.o := p;
  c2.r2 := pointDist2(c.o,p)-c.r2;
  case comp(c2.r2,0) of
    -1:momasCircle := 0;
    0:begin
      momasCircle := 1;
      p1 := p;
    end;
    1:begin
      momasCircle := 2;
      circleCircle(c,c2,p1,p2);
    end;
  end;
end;

end.
