{
 BinomialHeap Advanced Data Structure Unit
 Inherited from MergHeap unit
 Copyright (C) September 2000, Behdad Esfahbod
 For licensing issues, read file named COPYING, or contact <behdad@bamdad.org>

 Operations:                                                    Time Comp
   Create        Create an empty DS                             O(1)
   Search        Search DS for a key, return the data           O(N)
   SearchNode    Search DS for a key, return the node itself    O(N)
   Insert        Insert a key into the DS                       O(Lg(N))
   Delete        Delete a key from the DS                       O(N)
   DeleteNode    Delete a node from the DS                      O(Lg(N))
   ExtractMin    Delete minimum key from the DS                 O(Lg(N))
   Union         Unites two heaps into one                      O(Lg(N))
   DecreaseKey   Decrease a nodes key value                     O(Lg(N))

 Functions:
   Empty         Is DS empty or not                             O(1)
   Size          Number of keys in DS                           O(1)
   Minimum       Minimum key in DS                              O(Lg(N))

 Algorithms from Cormen, Leiserson, Rivest, "Introuction to Algorithms",
   MIT, 1990, Chapter 20.

 Comments:
   DS always stands for "data structure".

   All methods and functions space complexity is O(1).

   All time complexities are worst case.

 Also read header for MergHeap unit.
}
{$define debug}
unit
  BinHeap;

interface

  uses
    MergHeap;

  type
    PBinHeapNode = ^ TBinHeapNode;
    TBinHeapNode = object (TNode)
      {inherits key & data}
      Degree  : Integer;
      {# of childs, presented in left-most, right-sibling presentation}
      Parent  : PBinHeapNode;
      {pointer to parent, nil if not present}
      Child   : PBinHeapNode;
      {pointer to leftmost child, nil if not present (is a leaf)}
      Sibling : PBinHeapNode;
      {pointer to immediately right sibling, nil if not present}

      constructor Init (const K : TKey; const D : PData);
      {initialize the node with key k and data d}
      destructor Done (FreeProc : PFreeProc); virtual;
      {free all mem alocated by tree rooted at this node,
       a procedure can be included to free datas, function prototype
       is procedure name (p : pointer);
       or nil if no data free process needed
       also done frees the mem allocated by this node}
      function  Search (const K : TKey) : PNode; virtual;
      {search subBinHeap rooted at this node for key K,
       returns pointer to node contains key K, or
               nil if not found}
      function  DecreaseKey (const K : TKey) : PNode; virtual;
      {decreases the key value of this node
       returns to new node containing key k}
      function  BubbleUp : PNode; virtual;
      {bubbles up the key and data of this node, until parent is nil
       returns to new node containing key k}
      procedure Link (var P : TBinHeapNode); virtual;
      {makes this node first child of node P, nodes must have the same
       degree}
      procedure Swap (var P : TBinHeapNode); virtual;
      {swap key and data of this node with node p}
    end;

    PBinHeap = ^ TBinHeap;
    TBinHeap = object (THeap)
      {inherits n from tdict}
    private
      Head : PBinHeapNode;
      {pointer to head of root list}
      procedure Merge (var H : TBinHeap); virtual;
      {merges the root list of h into root list of this BinHeap
       sets head pointer of h to nil}
      function  DeleteRoot (var P : TBinHeapNode) : PData; virtual;
      {delete node P from DS that is a root node (parent = nil)
       returns pointer to data in node P}

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

{non method TBinHeapNode functions ******************************************}

function  AllocateNode (const K : TKey; const D : PData) : PBinHeapNode;
var
  P : PBinHeapNode;
begin
   New(P);
  {$ifdef debug}
  if P = nil then
    Error('BinHeap: AllocateNode: cannot allocate memory.');
  {$endif}
  P^.Init(K, D);
  AllocateNode := P;
end;

procedure DisposeNode (P : PBinHeapNode);
begin
  {$ifdef debug}
  if P = nil then
    Error('BinHeap: DisposeNode: disposing a nil pointer.');
  {$endif}
  Dispose(P);
end;

{TBinHeap methods *************************************************************}

constructor TBinHeap.Create;
begin
  inherited Create;
  Head := nil;
end;

destructor TBinHeap.Done (FreeProc : PFreeProc);
begin
  if Head <> nil then
    Head^.Done(FreeProc);
  Head := nil;
end;

function  TBinHeap.ID : string;
begin
  ID := 'Binary Heap';
end;

function  TBinHeap.Search (const K : TKey) : PData;
var
  P : PBinHeapNode;
begin
  P := PBinHeapNode(SearchNode(K));
  if P <> nil then
    Search := P^.Data
  else
    Search := nil;
end;

function  TBinHeap.SearchNode (const K : TKey) : PNode;
begin
  if Empty then
    SearchNode := nil
  else
    SearchNode := Head^.Search(K);
end;

procedure TBinHeap.Insert (const K : TKey; const D : PData);
var
  H : PBinHeap;
  X : PBinHeapNode;
begin
  New(H);
  H^.Create;
  X := AllocateNode(K, D);
  H^.Head := X;
  H^.N := 1;
  Union(H^);
end;

function  TBinHeap.Delete (const K : TKey) : PData;
var
  P : PNode;
begin
  P := SearchNode(K);
  if P <> nil then
    Delete := DeleteNode(P)
  else
    Delete := nil;
end;

function  TBinHeap.DeleteNode (const P : PNode) : PData;
var
  D : PNode;
  K : TKey;
begin
  {$ifdef debug}
  if P = nil then
    Error('THeap.DeleteNode: deleting a nil pointer to node.');
  {$endif}
  {replaced by a bubbleup() and a deleteroot(), due to exercise 20.2-6
   to do not need -infinity value
  {here i used low(tkey) as -infinity, so i assume that no low(tkey)
   is already inserted in DS
  PBinHeapNode(P)^.DecreaseKey(Low(TKey));
  DeleteNode := ExtractMin(K);}
  DeleteNode := DeleteRoot(PBinHeapNode(PBinHeapNode(P)^.BubbleUp)^);
end;

function  TBinHeap.DeleteRoot (var P : TBinHeapNode) : PData;
var
  X, Z, T : PBinHeapNode;
  Y : ^ PBinHeapNode;
  H : PBinHeap;
begin
  {$ifdef debug}
  if P.Parent <> nil then
    Error('TBinHeap.DeleteRoot: deleting a non root node.');
  {$endif}
  X := @P;
  DeleteRoot := X^.Data;
  New(H);
  H^.Create;
  H^.N := -1;
  Y := @Head;
  while Y^ <> X do
    Y := @(Y^^.Sibling);
  Y^ := X^.Sibling;
  Z := nil;
  T := X^.Child;
  X := T;
  while X <> nil do
  begin
    T := X^.Sibling;
    X^.Sibling := Z;
    X^.Parent := nil;
    Z := X;
    X := T;
  end;
  H^.Head := Z;
  Union(H^);
  DisposeNode(@P);
end;

function  TBinHeap.ExtractMin (var K : TKey) : PData;
var
  X, Z, T : PBinHeapNode;
  Y : ^ PBinHeapNode;
  H : PBinHeap;
begin
  {$ifdef debug}
  if Empty then
    Error('TBinHeap.ExtractMin: minimum of an empty BinHeap requested.');
  {$endif}
  X := PBinHeapNode(Minimum);
  K := X^.Key;
  ExtractMin := X^.Data;
  DeleteRoot(X^);
end;

procedure TBinHeap.DecreaseKey (const P : PNode; const K : TKey);
begin
  {$ifdef debug}
  if P = nil then
    Error('THeap.DecreaseKey: decreasing a nil pointer to node.');
  {$endif}
  PBinHeapNode(P)^.DecreaseKey(K);
end;

procedure TBinHeap.Merge (var H : TBinHeap);
var
  X : ^ PBinHeapNode;
  Y, T : PBinHeapNode;
begin
  X := @Head;
  Y := H.Head;
  Inc(N, H.N);
  H.N := 0;
  if Y = nil then
    Exit;
  if X^ = nil then
  begin
    X^ := Y;
    H.Head := nil;
    Exit;
  end;
  while (X^ <> nil) and (Y <> nil) do
  begin
    while (X^ <> nil) {c}and (X^^.Degree <= Y^.Degree) do
      X := @(X^^.Sibling);
    T := X^;
    X^ := Y;
    X := @Y^.Sibling;
    Y := T;
  end;
  if Y <> nil then
    X^ := Y;
  H.Head := nil;
end;

procedure TBinHeap.Union (var H : THeap);
var
  H2 : TBinHeap absolute H;
  PrevX, X, NextX : PBinHeapNode;
begin
  Merge(H2);
  if Head  <> nil then
  begin
    PrevX := nil;
    X := Head;
    NextX := X^.Sibling;
    while NextX <> nil do
    begin
      if (X^.Degree <> NextX^.Degree) or
        ((NextX^.Sibling <> nil) and (NextX^.Sibling^.Degree = X^.Degree)) then
      begin {cases 1 and 2}
        PrevX := X;
        X := NextX;
      end
      else
        if X^.Key <= NextX^.Key then
        begin {case 3}
          X^.Sibling := NextX^.Sibling;
          NextX^.Link(X^);
        end
        else
        begin {case 4}
          if PrevX = nil then
            Head := NextX
          else
            PrevX^.Sibling := NextX;
          X^.Link(NextX^);
          X := NextX;
        end;
      NextX := X^.Sibling;
    end;
  end;
  Dispose(PHeap(@H), Done(nil));
end;

function  TBinHeap.Minimum : PNode;
var
  X, Y : PBinHeapNode;
  Min : TKey;
begin
  {$ifdef debug}
  if Empty then
    Error('TBinHeap.Minimum: minimum of an empty BinHeap requested.');
  {$endif}
  {replaced by three different assignments, due to exercise 20.2-5 to do
   not need infinity value
  Y := nil;
  X := Head;
  {here first i used high(tkey) as infinity, so i assume that no high(tkey)
   is already inserted in DS, the problem is solved in exercise 20.2-5
  Min := High(TKey);}
  Y := Head;
  X := Head;
  Min := Y^.Key;
  while X <> nil do
  begin
    if X^.Key < Min then
    begin
      Min := X^.Key;
      Y := X;
    end;
    X := X^.Sibling;
  end;
  Minimum := Y;
end;

{TBinHeapNode methods *********************************************************}

constructor TBinHeapNode.Init (const K : TKey; const D : PData);
begin
  Parent  := nil;
  Child   := nil;
  Sibling := nil;
  Degree  := 0;
  inherited Init(K, D);
end;

destructor TBinHeapNode.Done (FreeProc : PFreeProc);
begin
  if FreeProc <> nil then
    FreeProc^(Data);
  if Child <> nil then
    Child^.Done(FreeProc);
  if Sibling <> nil then
    Sibling^.Done(FreeProc);
  DisposeNode(@Self);
end;

function  TBinHeapNode.Search (const K : TKey) : PNode;
var
  D : PNode;
begin
  D := nil;
  if K = Key then
    D := @Self;
  if (D = nil) and (K > Key) and (Child <> nil) then
    D := Child^.Search(K);
  if (D = nil) and (Sibling <> nil) then
    D := Sibling^.Search(K);
  Search := D;
end;

function  TBinHeapNode.DecreaseKey (const K : TKey) : PNode;
var
  P : PBinHeapNode;
begin
  {$ifdef debug}
  if K > Key then
    Error('TBinHeapNode.DecreaseKey: new key is greater than the old one.');
  {$endif}
  Key := K;
  P := @Self;
  while (P^.Parent <> nil) and (P^.Key < P^.Parent^.Key) do
  begin
    P^.Swap(P^.Parent^);
    P := P^.Parent;
  end;
  DecreaseKey := P;
end;

function  TBinHeapNode.BubbleUp : PNode;
var
  P : PBinHeapNode;
begin
  P := @Self;
  while P^.Parent <> nil do
  begin
    P^.Swap(P^.Parent^);
    P := P^.Parent;
  end;
  BubbleUp := P;
end;

procedure TBinHeapNode.Link (var P : TBinHeapNode);
begin
  Parent := @P;
  Sibling := P.Child;
  P.Child := @Self;
  Inc(P.Degree);
end;

procedure TBinHeapNode.Swap (var P : TBinHeapNode);
var
  T : TNode;
begin
  T.Key  := Key ; Key  := P.Key ; P.Key  := T.Key ;
  T.Data := Data; Data := P.Data; P.Data := T.Data;
end;


end.
