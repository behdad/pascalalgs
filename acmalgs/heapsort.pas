{
 Heap Sort Algorithm

 O(NLgN)
 Input:
  A: array of integer
  N: number of integers
 Output:
  Ascending Sorted list
 Notes:
  Heap is MaxTop

 Reference:
  FCS

 By Behdad
}
program
  HeapSort;

const
  MaxN = 32000;

var
  N : Integer;
  A : array [1 .. MaxN] of Integer;
  HSize : Integer;

function  BubbleUp (V : Integer) : Integer;
var
  Te : Integer;
begin
  while (V > 1) and (A[V] > A[V div 2]) do
  begin
    Te := A[V]; A[V] := A[V div 2]; A[V div 2] := Te;
    V := V div 2;
  end;
  BubbleUp := V;
end;

function  BubbleDown (V : Integer) : Integer;
var
  Te : Integer;
  C : Integer;
begin
  while 2 * V <= HSize do
  begin
    C := 2 * V;
    if (C < HSize) and (A[C] < A[C + 1]) then
      Inc(C);
    if A[V] < A[C] then
    begin
      Te := A[V]; A[V] := A[C]; A[C] := Te;
      V := C;
    end
    else
      Break;
  end;
  BubbleDown := V;
end;

function  Insert (K : Integer) : Integer;
begin
  Inc(HSize);
  A[HSize] := K;
  Insert := BubbleUp(HSize);
end;

function  Delete (V : Integer) : Integer;
begin
  Delete := A[V];
  A[V] := A[HSize];
  Dec(HSize);
  if BubbleUp(V) = V then
    BubbleDown(V);
end;

function  DeleteMax : Integer;
var
  Te : Integer;
begin
  DeleteMax := A[1];
  Te := A[1]; A[1] := A[HSize]; A[HSize] := Te;
  Dec(HSize);
  BubbleDown(1);
end;

function ChangeKey (V, K : Integer) : Integer;
begin
  A[V] := K;
  ChangeKey := BubbleDown(BubbleUp(V));
end;

procedure Heapify (Count : Integer);
var
  I : Integer;
begin
  HSize := Count;
  for I := N div 2 downto 1 do
    BubbleDown(I);
end;

procedure Sort (Count : Integer);
begin
  Heapify(Count);
  while HSize > 0 do
    DeleteMax;
end;

begin
  Sort(N);
end.
