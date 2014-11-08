{
 FibonacciHeap Advanced Data Structure Unit
 Inherited from MergHeap unit
 Copyright (C) September 2000, Behdad Esfahbod
 For licensing issues, read file named COPYING, or contact <behdad@bamdad.org>

 Operations:                                                    Time Comp
   Create        Create an empty DS                             O(1)
   Search        Search DS for a key, return the data           O(N)
   SearchNode    Search DS for a key, return the node itself    O(N)
   Insert        Insert a key into the DS                       O(1)
   Delete        Delete a key from the DS                       O(N)
   DeleteNode    Delete a node from the DS                      O(Lg(N))
   ExtractMin    Delete minimum key from the DS                 O(Lg(N))
   Union         Unites two heaps into one                      O(1)
   DecreaseKey   Decrease a nodes key value                     O(1)

 Functions:
   Empty         Is DS empty or not                             O(1)
   Size          Number of keys in DS                           O(1)
   Minimum       Minimum key in DS                              O(1)

 Algorithms from Cormen, Leiserson, Rivest, "Introuction to Algorithms",
   MIT, 1990, Chapter 21.

 Comments:
   DS always stands for "data structure".

   All methods and functions space complexity is except than
     consolidate() is O(Lg(N)) space.

   Time complexities are amortized, it means very of them are worst case
     but ALL of them are valid with and only with amortized analysis.

 Also read Miner for MergHeap unit.
}
{$define debug}
unit
  FibHeap;

interface

  uses
    MergHeap;

  type
    PFibHeapNode = ^ TFibHeapNode;
    TFibHeapNode = object (TNode)
      {inherits key & data}
      Degree  : Integer;
      {# of childs, presented in left-most, right-sibling presentation}
      Mark    : Boolean;
      {whether node has lost a child since the last time was made the
       child of another node}
      Parent  : PFibHeapNode;
      {pointer to parent, nil if not present}
      Child   : PFibHeapNode;
      {pointer to a child (any one of them), nil if not present (is a leaf)}
      Right, Left : PFibHeapNode;
      {pointer to immediately right and left siblings, equal to self if
       the node is the only child of its parent}

      constructor Init (const K : TKey; const D : PData);
      {initialize the node with key K and data D}
      destructor Done (FreeProc : PFreeProc); virtual;
      {free all mem alocated by tree rooted at this node,
       a procedure can be included to free datas, function prototype
       is procedure name (p : pointer);
       or nil if no data free process needed
       also done frees the mem allocated by this node}
      function  Search (const K : TKey) : PNode; virtual;
      {search suFibHeap rooted at this node for key K,
       returns pointer to node contains key K, or
               nil if not found}
      procedure Link (var P : TFibHeapNode); virtual;
      {makes this node a child of node P, nodes must have the same degree}
      procedure Merge (var P : TFibHeapNode); virtual;
      {merges root or child list of this node with root or child list of
       node P}
      procedure Extract; virtual;
      {extracts node from its root or child list, update list, and parents
       child pointer and degree if present
       dont change parent, child, left and right pointers
       dont update min pointer}
      procedure Isolate; virtual;
      {extracts node from its root or child list, update list, and parents
       child pointer and degree if present
       sets parent to nil and left and right to this node, dont change child
       dont update min pointer
       it means makes this node an isolate root list}
    end;

    PFibHeap = ^ TFibHeap;
    TFibHeap = object (THeap)
      {inherits n from tdict}
    private
      Min : PFibHeapNode;
      {pointer to minimum of root list}
      procedure Merge (var P : TFibHeapNode); virtual;
      {merges root list with root list that P is the minimum of that,
       doesnt change the Parent pointers of root list P
       if P is not minimum of its list, min pointer is not updated
       correctly, then a consolidate() must be called to update the min}
      function  DeleteRoot (var P : TFibHeapNode) : PData; virtual;
      {delete node P from DS that is a root node (parent = nil)
       returns pointer to data in node P}
      function  MaxDeg : Integer; virtual;
      {maximum degree of a node, equals to the gold ratio
       =Lg(N) in base (1+sqrt(5))/2}
      procedure Consolidate; virtual;
      {consolidates the heap, links equal degree nodes, until there are
       at most one node of degree i, for i = 1 to maxdeg
       also updates the min pointer}
      procedure Cut (var P : TFibHeapNode);
      {cuts the link between node P and its parent, making node a root
       must be not a root (parent <> nil)}
      procedure CascadingCut (var P : TFibHeapNode);
      {recursively update mark labels, so that if two childs of node P
       are deleted, cut it, then cascadingcut its parent}

    public
      {inherits empty() and size() from tdict}
      {all methods below are overrided}
      constructor Create;
      {create and initialize an empty DS}
      destructor Done (FreeProc : PFreeProc); virtual;
      {free all mem alocated by DS, a procedure can be included to free
       datas, function prototype is procedure name (p : pointer);
       or nil if no data free process needed}
      function  ID : string; virtual;
      {id string of DS under use}
      function  Search (const K : TKey) : PData; virtual;
      {search DS for key K,
       returns pointer to data asociated with K, or
               nil if not found}
      function  SearchNode (const K : TKey) : PNode; virtual;
      {search DS for key K,
       returns pointer to node contains key K, or
               nil if not found}
      procedure Insert (const K : TKey; const D : PData); virtual;
      {insert key K with data Data into DS
       returns true, if it was successful
               false, otherwise (maybe not enough memory)}
      function  Delete (const K : TKey) : PData; virtual;
      {delete key K from DS,
       returns pointer to data asociated with K, or
               nil if not found}
      function  DeleteNode (const P : PNode) : PData; virtual;
      {delete node P from DS,
       returns pointer to data in node P}
      function  ExtractMin (var K : TKey) : PData; virtual;
      {delete node with minimum key from DS,
       sets K to its key and returns pointer to its data}
      procedure DecreaseKey (const P : PNode; const K : TKey); virtual;
      {decreases the key value of node P}
      procedure Union (var H : THeap); virtual;
      {unites DS with H, and destructing the heap H}
      function  Minimum : PNode; virtual;
      {returns the minimum key in DS, DS must be not empty}
    end;

implementation

{non method TFibHeapNode functions ******************************************}

function  AllocateNode (const K : TKey; const D : PData) : PFibHeapNode;
var
  P : PFibHeapNode;
begin
   New(P);
  {$ifdef debug}
  if P = nil then
    Error('FibHeap: AllocateNode: cannot allocate memory.');
  {$endif}
  P^.Init(K, D);
  AllocateNode := P;
end;

procedure DisposeNode (P : PFibHeapNode);
begin
  {$ifdef debug}
  if P = nil then
    Error('FibHeap: DisposeNode: disposing a nil pointer.');
  {$endif}
  Dispose(P);
end;

{TFibHeap methods ***********************************************************}

constructor TFibHeap.Create;
begin
  inherited Create;
  Min := nil;
end;

destructor TFibHeap.Done (FreeProc : PFreeProc);
begin
  if Min <> nil then
    Min^.Done(FreeProc);
  Min := nil;
end;

function  TFibHeap.ID : string;
begin
  ID := 'Fibonacci Heap';
end;

function  TFibHeap.Search (const K : TKey) : PData;
var
  P : PFibHeapNode;
begin
  P := PFibHeapNode(SearchNode(K));
  if P <> nil then
    Search := P^.Data
  else
    Search := nil;
end;

function  TFibHeap.SearchNode (const K : TKey) : PNode;
begin
  if Empty then
    SearchNode := nil
  else
    SearchNode := Min^.Search(K);
end;

procedure TFibHeap.Insert (const K : TKey; const D : PData);
var
  X : PFibHeapNode;
begin
  X := AllocateNode(K, D);
  if Min = nil then
    Min := X
  else
  begin
    X^.Merge(Min^);
    if X^.Key < Min^.Key then
      Min := X;
  end;
  Inc(N);
end;

procedure TFibHeap.Merge (var P : TFibHeapNode);
begin
  if Min = nil then
    Min := @P
  else
  begin
    P.Merge(Min^);
    if P.Key < Min^.Key then
      Min := @P;
  end;
end;

function  TFibHeap.DeleteRoot (var P : TFibHeapNode) : PData;
var
  X, Z, T : PFibHeapNode;
  Y : ^ PFibHeapNode;
  H : PFibHeap;
begin
  {$ifdef debug}
  if P.Parent <> nil then
    Error('TFibHeap.DeleteRoot: deleting a non root node.');
  {$endif}
  X := @P;
  DeleteRoot := X^.Data;
  if Min = X then
  begin
    Min := X^.Right;
    if Min = X then
      Min := nil;
  end;
  X^.Extract;
  Z := X^.Child;
  X := Z;
  if X <> nil then
  begin
    repeat
      X^.Parent := nil;
      X := X^.Right;
    until X = Z;
    Merge(X^);
  end;
  Dec(N);
  DisposeNode(@P);
end;

function  TFibHeap.ExtractMin (var K : TKey) : PData;
var
  X, Z, T : PFibHeapNode;
  Y : ^ PFibHeapNode;
  H : PFibHeap;
begin
  {$ifdef debug}
  if Empty then
    Error('TFibHeap.ExtractMin: minimum of an empty FibHeap requested.');
  {$endif}
  X := Min;
  K := X^.Key;
  ExtractMin := X^.Data;
  DeleteRoot(X^);
  if Min <> nil then
    Consolidate;
end;

procedure TFibHeap.Union (var H : THeap);
var
  H2 : TFibHeap absolute H;
begin
  Inc(N, H2.N);
  if H2.Min <> nil then
    Merge(H2.Min^);
  H2.N := 0;
  H2.Min := nil;
  Dispose(PHeap(@H), Done(nil));
end;

procedure TFibHeap.Consolidate;
type
  TAuxArray = array [0 .. High(Word) div SizeOf(PFibHeapNode) - 1] of PFibHeapNode;
var
  Dn, D : Integer;
  S : Word;
  A : ^ TAuxArray;
  I : Integer;
  X, Y, Z, T : PFibHeapNode;
  EndFlag : Boolean;
begin
  Dn := MaxDeg;
  {allocating an extra cell in a to ensure that we allocate enough mem
   for the edge points}
  S := (1 + 1 + Dn) * SizeOf(A^[0]);
  GetMem(A, S);
  {replaced by a fillchar(), because of efficiency
  for I := 0 to D do
    A^[I] := nil;}
  FillChar(A^, S, 0);
  if Min <> nil then
  begin
    {for each node X in root list}
    X := Min;
    repeat
      with X^ do
      begin
        T := Right;
        D := Degree;
        Isolate;
      end;
      EndFlag := T = X;
      while A^[D] <> nil do
      begin
        Y := A^[D];
        if X^.Key > Y^.Key then
        {swapping x and y}
        begin Z := X; X := Y; Y := Z; end;
        Y^.Link(X^);
        A^[D] := nil;
        Inc(D);
      end;
      A^[D] := X;
      X := T;
    until EndFlag;
  end;
  Min := nil;
  for I := 0 to Dn do
    if A^[I] <> nil then
      Merge(A^[I]^);
  FreeMem(A, S);
end;

function  TFibHeap.Delete (const K : TKey) : PData;
var
  P : PNode;
begin
  P := SearchNode(K);
  if P <> nil then
    Delete := DeleteNode(P)
  else
    Delete := nil;
end;

function  TFibHeap.DeleteNode (const P : PNode) : PData;
var
  D : PNode;
  K : TKey;
begin
  {$ifdef debug}
  if P = nil then
    Error('TFibHeap.DeleteNode: deleting a nil pointer to node.');
  {$endif}
  {here i used low(tkey) as -infinity, so i assume that no low(tkey)
   is already inserted in DS}
  DecreaseKey(P, Low(TKey));
  DeleteNode := ExtractMin(K);
end;

procedure TFibHeap.DecreaseKey (const P : PNode; const K : TKey);
var
  X : PFibHeapNode absolute P;
  Y : PFibHeapNode;
begin
  {$ifdef debug}
  if P = nil then
    Error('TFibHeap.DecreaseKey: decreasing a nil pointer to node.');
  if K > X^.Key then
    Error('TFibHeap.DecreaseKey: new key is greater than the old one.');
  {$endif}
  X^.Key := K;
  Y := X^.Parent;
  if (Y <> nil) {c}and (X^.Key < Y^.Key) then
  begin
    Cut(X^);
    CascadingCut(Y^);
  end;
  if X^.Key < Min^.Key then
    Min := X;
end;

procedure TFibHeap.Cut (var P : TFibHeapNode);
begin
  with P do
    begin
    {$ifdef debug}
    if Parent = nil then
      Error('TFibHeapNode.Cut: cutting a root node.');
    {$endif}
    Isolate;
    Mark := False;
  end;
  Merge(P);
end;

procedure TFibHeap.CascadingCut (var P : TFibHeapNode);
var
  Z : PFibHeapNode;
begin
  Z := P.Parent;
  if Z <> nil then
    if not P.Mark then
      P.Mark := True
    else
    begin
      Cut(P);
      CascadingCut(Z^);
    end;
end;

function  TFibHeap.MaxDeg : Integer;
const
  Epsilon   = 1E-8;
  GoldRatio = 1.61803398874989485{(1+sqrt(5))/2};
begin
  {adding goldratio by epsilon to ensure that maxdeg is not less
   for the edge points}
  if Empty then
    MaxDeg := 0
  else
    MaxDeg := Trunc(Ln(N) / Ln(GoldRatio) + Epsilon);
end;

function  TFibHeap.Minimum : PNode;
begin
  {$ifdef debug}
  if Empty then
    Error('TFibHeap.Minimum: minimum of an empty FibHeap requested.');
  {$endif}
  Minimum := Min;
end;

{TFibHeapNode methods *******************************************************}

constructor TFibHeapNode.Init (const K : TKey; const D : PData);
begin
  Parent  := nil;
  Child   := nil;
  Right   := @Self;
  Left    := @Self;
  Mark    := False;
  Degree  := 0;
  inherited Init (K, D);
end;

destructor TFibHeapNode.Done (FreeProc : PFreeProc);
var
  X, Z, T : PFibHeapNode;
begin
  X := @Self;
  Z := X;
  repeat
    T := X^.Right;
    with X^ do
    begin
      if FreeProc <> nil then
        FreeProc^(Data);
      if Child <> nil then
        Child^.Done(FreeProc);
    end;
    DisposeNode(X);
    X := T;
  until X = Z;
end;

function  TFibHeapNode.Search (const K : TKey) : PNode;
var
  D : PNode;
  X : PFibHeapNode;
begin
  D := nil;
  X := @Self;
  repeat
    with X^ do
    begin
      if K = Key then
        D := X
      else
        if (K > Key) and (Child <> nil) then
          D := Child^.Search(K);
    end;
    X := X^.Right;
  until (X = @Self) or (D <> nil);
  Search := D;
end;

procedure TFibHeapNode.Link (var P : TFibHeapNode);
begin
  P.Isolate;
  Parent := @P;
  if P.Child = nil then
    P.Child := @Self
  else
    Merge(P.Child^);
  Inc(P.Degree);
end;

procedure TFibHeapNode.Merge (var P : TFibHeapNode);
var
  RR, LL : PFibHeapNode;
begin
  RR := Right;
  LL := P.Left;
  Right  := @P;
  P.Left := @Self;
  RR^.Left  := LL;
  LL^.Right := RR;
end;

procedure TFibHeapNode.Extract;
begin
  if (Parent <> nil) then
  begin
    Dec(Parent^.Degree);
    if Parent^.Child = @Self then
      if Right = @Self then
        Parent^.Child := nil
      else
        Parent^.Child := Right;
  end;
  Right^.Left := Left;
  Left^.Right := Right;
end;

procedure TFibHeapNode.Isolate;
begin
  Extract;
  Parent := nil;
  Left   := @Self;
  Right  := @Self;
end;


end.
