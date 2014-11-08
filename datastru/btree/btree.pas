{
 BTree Advanced Data Structure Unit
 Inherited from Dict unit
 Copyright (C) September 2000, Behdad Esfahbod
 For licensing issues, read file named COPYING, or contact <behdad@bamdad.org>

 Operations:                                  I/O Comp.  Time Comp
   Create        Create an empty DS           0          O(1)
   Search        Search DS for a key          O(LgT(N))  O(LgT(N))
   Insert        Insert a key into the DS     O(LgT(N))  O(T.LgT(N))
   Delete        Delete a key from the DS     O(LgT(N))  O(T.LgT(N))

 Functions:
   Empty         Is DS empty or not           0          O(1)
   Size          Number of keys in DS         0          O(1)
   Minimum       Minimum key in DS            O(LgT(N))  O(LgT(N))
   Maximum       Maximum key in DS            O(LgT(N))  O(LgT(N))
   Height        Height of DS Tree            0          O(1)

 Algorithms from Cormen, Leiserson, Rivest, "Introuction to Algorithms",
   MIT, 1990, Chapter 19.

 Comments:
   DS always stands for "data structure".

   Written with an static branching number, every user must recompile for
     his/her own use.

   LgT(N) stands for Logarithm of N in base T.

   All methods and functions space complexity is O(1).

   All time complexities are worst case, not amortized,
     amortized time complexity instead of O(T.LgT(N)) is O(Lg(N)).

 Also read header for Dict unit.
}
unit
  BTree;

interface

  uses
    DS, Dict;

  const
    T = 60;
    {minimum number of childs, t >= 2}

  const
    {$ifopt r+}
    ExtraEntry = 1;
    {$else}
    ExtraEntry = 0;
    {$endif}
    {if range check is on, an extra entry per node is alocated because
     moving 0 bytes from an out of range place causes a range check error,
     it is not a bug (no bytes is moved) then if range check is off i ignore
     the extra entry}

  type
    PBTreeNode = ^ TBTreeNode;
    PChild     = PBTreeNode;
    TBTreeNode = object
      AllMark : record end;
      {all nodes start at this relative offset}
      N : Integer;
      {# of keys in node
      1 <= N <= 2t-1,       if node is root
      t-1 <= N <= 2t-1,     otherwise}
      Leaf : Boolean;
      {is the node a leaf or internal node}
      Key  : array [1 .. 2 * T - 1 + ExtraEntry] of TKey;
      {keys stored in node, # of keys = n}
      Data : array [1 .. 2 * T - 1 + ExtraEntry] of PData;
      {datas stored in node, data[i] has key key[i]}

      InterMark : record end;
      {leaf nodes end at this relative offset,
       and only internal nodes allocate members below}
      C    : array [1 .. 2 * T + ExtraEntry] of PChild;
      {pointers or pageid or object of childs, # of childs = n + 1,
       available iff node is not a leaf}

      constructor Init (IsLeaf : Boolean);
      {initialize the node with leaf state IsLeaf}
      destructor Done (FreeProc : PFreeProc);
      {free all mem alocated by tree rooted at this node,
       a procedure can be included to free datas, function prototype
       is procedure name (p : pointer);
       or nil if no data free process needed
       also done frees the mem allocated by this node}
      function  Full : Boolean;
      {returns if the node is full (n = 2t-1)}
      function  Poor : Boolean;
      {returns if the node is poor (with least possible childs)(n = t-1)}
      function  Search (const K : TKey) : PData;
      {search suBTree rooted at this node for key K,
       returns pointer to data asociated with K, or
               nil if not found}
      function  SearchIndex (const K : TKey; var X : PBTreeNode) : Integer;
      {search suBTree rooted at this node for key K,
       returns index of key, and sets pointer to node in X, or
               0, and sets X to nil if not found}
      function  BinSearch (const K : TKey) : Integer;
      {search node for key K,
       returns i, index of a key, such that key[i - 1] <= k and key[i] > k
               0, and sets X to nil if not found}
      procedure SplitChild (I : Integer);
      {split child at index i that is full (n = 2t-1) to two poor childs
       (n=t-1),
       this node must be not full (n < 2t-1), 1 <= i <= n + 1}
      procedure InsertNonFull (const K : TKey; const D : PData);
      {insert key K with data Data. this node must be not full (n < 2t-1)}
      procedure JoinChild (I : Integer);
      {join two children at index I and I+1 that are poor (n = t-1) to
       a full child (n=2t-1),
       this node must be not poor (n > t-1), 1 <= i <= n}
      function  DeleteNonPoor (const K : TKey) : PData;
      {insert key K with data Data. this node must be not full (n < 2t-1)}
      function  Minimum : TKey;
      {returns the minimum key in suBTree rooted at this node}
      function  Maximum : TKey;
      {returns the maximum key in suBTree rooted at this node}
      procedure RotateLeft (I : Integer);
      {add key[i] to node child i as last key, and move first key of
       child i+1 to key i, also move first child of child i+1 to be
       new last child of child i (rotate two nodes ccw),
       increases c[i]^.n and decreases c[i+1]^.n by one,
       child i must be not full and child i+1 must be not poor,
       1 <= i <= n}
      procedure RotateRight (I : Integer);
      {insert key[i] in child i+1, and move maximum key of child i to
       key i,
      {add key[i] to node child i+1 as first key, and move last key of
       child i to key i, also move last child of child i to be
       new first child of child i+1 (rotate two nodes cw),
       increases c[i+1]^.n and decreases c[i]^.n by one,
       child i+1 must be not full and child i must be not poor,
       1 <= i <= n}
    end;

    PBTree = ^ TBTree;
    TBTree = object (TDict)
      {inherits n from tdict}
    private
      Root : PBTreeNode;
      {root node}
      H : Integer;
      {height of the BTree}

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
      function  Height : Integer;
      {returns the height of BTree}
      function  Search (const K : TKey) : PData; virtual;
      {search DS for key K,
       returns pointer to data asociated with K, or
               nil if not found}
      procedure Insert (const K : TKey; const D : PData); virtual;
      {insert key K with data Data}
      function  Delete (const K : TKey) : PData; virtual;
      {delete key K from DS}
      function  Minimum : TKey; virtual;
      {returns the minimum key in DS, DS must be not empty}
      function  Maximum : TKey; virtual;
      {returns the maximum key in DS, DS must be not empty}
    end;

implementation

{non method TBTreeNode functions ********************************************}

const
  LeafLen : Integer = 0;
  {length of a leaf node in bytes, will be computed when program starts}

{$ifdef debug}
var
  IsRoot : Boolean;
{$endif}

function  AllocateNode (IsLeaf : Boolean) : PBTreeNode;
var
  P : PBTreeNode;
  Q, R : Pointer;
  L : Longint;
begin
  if not IsLeaf then
    New(P)
  else
    GetMem(P, LeafLen);
  {$ifdef debug}
  if P = nil then
    Error('BTree: AllocateNode: cannot allocate memory.');
  {$endif}
  P^.Init(IsLeaf);
  AllocateNode := P;
end;

procedure DisposeNode (P : PBTreeNode);
begin
  {$ifdef debug}
  if P = nil then
    Error('BTree: DisposeNode: disposing a nil pointer.');
  {$endif}
  if not P^.Leaf then
    Dispose(P)
  else
    FreeMem(P, LeafLen);
end;

{TBTree methods *************************************************************}

constructor TBTree.Create;
begin
  inherited Create;
  H := 1;
  Root := AllocateNode(True);
end;

destructor TBTree.Done (FreeProc : PFreeProc);
begin
  if Root <> nil then
    Root^.Done(FreeProc);
  Root := nil;
end;

function  TBTree.ID : string;
begin
  ID := 'BTree';
end;

function  TBTree.Height : Integer;
begin
  if Empty then
    Height := 0
  else
    Height := H;
end;

function  TBTree.Search (const K : TKey) : PData;
begin
  if Empty then
    Search := nil
  else
    Search := Root^.Search(K);
end;

procedure TBTree.Insert (const K : TKey; const D : PData);
var
  R, S : PBTreeNode;
begin
  R := Root;
  if R^.Full then
  begin
    Inc(H);
    S := AllocateNode(False);
    Root := S;
    with S^ do
    begin
      C[1] := R;
      SplitChild(1);
      InsertNonFull(K, D);
    end;
  end
  else
    R^.InsertNonFull(K, D);
  Inc(N);
end;

function  TBTree.Delete (const K : TKey) : PData;
var
  R : PBTreeNode;
  D : PData;
begin
  R := Root;
  {$ifdef debug}
  IsRoot := True;
  {$endif}
  D := R^.DeleteNonPoor(K);
  if (R^.N = 0) and not R^.Leaf then
  begin
    Dec(H);
    Root := R^.C[1];
    DisposeNode(R);
  end;
  if D <> nil then
    Dec(N);
  Delete := D;
end;

function  TBTree.Minimum : TKey;
begin
  {$ifdef debug}
  if Empty then
    Error('TBTree.Minimum: minimum of an empty BTree requested');
  {$endif}
  Minimum := Root^.Minimum;
end;

function  TBTree.Maximum : TKey;
begin
  {$ifdef debug}
  if Empty then
    Error('TBTree.Minimum: minimum of an empty BTree requested');
  {$endif}
  Maximum := Root^.Maximum;
end;

{TBTreeNode methods *********************************************************}

constructor TBTreeNode.Init;
begin
  N := 0;
  Leaf := IsLeaf;
end;

destructor TBTreeNode.Done (FreeProc : PFreeProc);
var
  I : Integer;
begin
  if FreeProc <> nil then
    for I := 1 to N do
      if Data[I] <> nil then
        FreeProc^(Data[I]);
  if not Leaf then
    for I := 1 to N + 1 do
      C[I]^.Done(FreeProc);
  DisposeNode(@Self);
end;

function  TBTreeNode.Full : Boolean;
begin
  Full := N >= 2 * T - 1;
end;

function  TBTreeNode.Poor : Boolean;
begin
  Poor := N <= T - 1;
end;

function  TBTreeNode.Search (const K : TKey) : PData;
var
  I : Integer;
begin
  {replaced by a binsearch(), because of efficiency
  I := 1;
  while (I <= N) and (K > Key[I]) do
    Inc(I);}
  I := BinSearch(K);
  if (I <= N) {c}and (K = Key[I]) then
    Search := Data[I]
  else
  if Leaf then
    Search := nil
  else
    Search := C[I]^.Search(K);
end;

function  TBTreeNode.SearchIndex (const K : TKey; var X : PBTreeNode) : Integer;
var
  I : Integer;
begin
  {replaced by a binsearch(), because of efficiency
  I := 1;
  while (I <= N) and (K > Key[I]) do
    Inc(I);}
  I := BinSearch(K);
  if (I <= N) {c}and (K = Key[I]) then
  begin
    X := @Self;
    SearchIndex := I;
  end
  else
  if Leaf then
  begin
    X := nil;
    SearchIndex := 0;
  end
  else
    SearchIndex := C[I]^.SearchIndex(K, X);
end;

function  TBTreeNode.BinSearch (const K : TKey) : Integer;
var
  I, J, M : Integer;
begin
  I := 1;
  J := N + 1;
  while (I < J) do
  begin
    M := (I + J) div 2;
    if K > Key[M] then
      I := M + 1
    else
      J := M;
  end;
  BinSearch := J;
end;

procedure TBTreeNode.SplitChild (I : Integer);
var
  Y, Z : PBTreeNode;
  J : Integer;
begin
  Y := C[I];
  {$ifdef debug}
  if Leaf then
    Error('TBTreeNode.SplitChild: leaf node');
  if (I < 1) or (I > N + 1) then
    Error('TBTreeNode.SplitChild: index out of range.');
  if not Y^.Full then
    Error('TBTreeNode.SplitChild: child node not full.');
  if Full then
    Error('TBTreeNode.SplitChild: node full.');
  {$endif}
  Z := AllocateNode(Y^.Leaf);
  with Z^ do
  begin
    N := T - 1;
    {replaced by two move()s, because of efficiency
    for J := 1 to T - 1 do
    begin
      Key[J]  := Y^.Key[J + T];
      Data[J] := Y^.Data[J + T];
    end;}
    Move(Y^.Key [1 + T], Key [1], (T - 1) * SizeOf(Key [1]));
    Move(Y^.Data[1 + T], Data[1], (T - 1) * SizeOf(Data[1]));

    if not {Y^.}Leaf then
      {replaced by a move(), because of efficiency
      for J := 1 to T do
        C[J] := Y^.C[J + T];}
      Move(Y^.C[1 + T], C[1], T * SizeOf(C[1]));
  end;
  Y^.N := T - 1;
  {replaced by a move(), because of efficiency
  for J := N + 1 downto I + 1 do
    C[J + 1] := C[J];}
  Move(C[I + 1], C[I + 2], (N - I + 1) * SizeOf(C[1]));
  C[I + 1] := Z;
  {replaced by two move()s, because of efficiency
  for J := N downto I do
  begin
    Key [J + 1] := Key [J];
    Data[J + 1] := Data[J];
  end;}
  Move(Key [I], Key [I + 1], (N - I + 1) * SizeOf(Key [1]));
  Move(Data[I], Data[I + 1], (N - I + 1) * SizeOf(Data[1]));
  Key [I] := Y^.Key [T];
  Data[I] := Y^.Data[T];
  Inc(N);
end;

procedure TBTreeNode.InsertNonFull(const K : TKey; const D : PData);
var
  I : Integer;
begin
  {$ifdef debug}
  if Full then
    Error('TBTreeNode.InsertNonFull: node full.');
  {$endif}
  {due to changes below, this line is replaced by a binsearch()
  I := N;}
  I := BinSearch(K);
  if Leaf then
  begin
    {replaced by a binsearch() and two move()s and a dec(), because of efficiency
    while (I >= 1) and (K < Key[I]) do
    begin
      Key [I + 1] := Key [I];
      Data[I + 1] := Data[I];
      Dec(I);
    end;}
    Move(Key [I], Key [I + 1], (N - I + 1) * SizeOf(Key [1]));
    Move(Data[I], Data[I + 1], (N - I + 1) * SizeOf(Data[1]));
    Dec(I);
    Key[I + 1]  := K;
    Data[I + 1] := D;
    Inc(N);
  end
  else
  begin
    {replaced by a binsearch(), because of efficiency
    while (I >= 1) and (K < Key[I]) do
      Dec(I);
    Inc(I);}
    if C[I]^.Full then
    begin
      SplitChild(I);
      if K > Key[I] then
        Inc(I);
    end;
    C[I]^.InsertNonFull(K, D);
  end;
end;

procedure TBTreeNode.JoinChild (I : Integer);
var
  Y, Z : PBTreeNode;
  J : Integer;
begin
  Y := C[I];
  Z := C[I + 1];
  {$ifdef debug}
  if Leaf then
    Error('TBTreeNode.JoinChild: leaf node');
  if (I < 1) or (I > N) then
    Error('TBTreeNode.JoinChild: index out of range.');
  if not (Y^.Poor and Z^.Poor) then
    Error('TBTreeNode.JoinChild: child node not poor.');
  if Poor and not IsRoot then
    Error('TBTreeNode.JoinChild: node poor.');
  {$endif}
  with Y^ do
  begin
    N := 2 * T - 1;
    {replaced by two move()s, because of efficiency
    for J := 1 to T - 1 do
    begin
      Key [J + T] := Z^.Key [J];
      Data[J + T] := Z^.Data[J];
    end;}
    Move(Z^.Key [1], Key [1 + T], (T - 1) * SizeOf(Key [1]));
    Move(Z^.Data[1], Data[1 + T], (T - 1) * SizeOf(Data[1]));

    if not {Z^.}Leaf then
      {replaced by a move(), because of efficiency
      for J := 1 to T do
        C[J + T] := Z^.C[J];}
      Move(Z^.C[1], C[1 + T], T * SizeOf(C[1]));
  end;
  DisposeNode(Z);
  {replaced by a move(), because of efficiency
  for J := I + 1 to N do
    C[J] := C[J + 1];}
  Move(C[I + 2], C[I + 1], (N - (I + 1) + 1) * SizeOf(C[1]));
  Y^.Key [T] := Key [I];
  Y^.Data[T] := Data[I];
  {replaced by two move()s, because of efficiency
  for J := I to N do
  begin
    Key [J] := Key [J + 1];
    Data[J] := Data[J + 1];
  end;}
  Move(Key [I + 1], Key [I], (N - I + 1) * SizeOf(Key [1]));
  Move(Data[I + 1], Data[I], (N - I + 1) * SizeOf(Data[1]));
  Dec(N);
end;

function  TBTreeNode.DeleteNonPoor (const K : TKey) : PData;
var
  I, J : Integer;
  S : TKey;
  Y : PBTreeNode;
begin
  {$ifdef debug}
  if Poor and not IsRoot then
    Error('TBTreeNode.DeleteNonPoor: node poor.');
  {$endif}
  {replaced by a binsearch(), because of efficiency
  I := 1;
  while (I <= N) and (K > Key[I]) do
    Inc(I);}
  I := BinSearch(K);
  if Leaf then
  begin
    if (I <= N) {c}and (K = Key[I]) then
    begin {case 1.}
      DeleteNonPoor := Data[I];
      {replaced by two move()s, because of efficiency
      for J := I to N - 1 do
      begin
        Key [J] := Key [J + 1];
        Data[J] := Data[J + 1];
      end;}
      Move(Key [I + 1], Key [I], ((N - 1) - I + 1) * SizeOf(Key [1]));
      Move(Data[I + 1], Data[I], ((N - 1) - I + 1) * SizeOf(Data[1]));
      Dec(N);
    end
    else
      DeleteNonPoor := nil;
  end
  else
  begin
    if (I <= N) {c}and (K = Key[I]) then
    begin {case 2.}
      if not C[I]^.Poor then
      begin {case 2.a.}
        DeleteNonPoor := Data[I];
        S := C[I]^.Maximum; {predecessor of k}
        Data[I] := C[I]^.DeleteNonPoor(S);
        Key [I] := S;
      end
      else
      if not C[I + 1]^.Poor then
      begin {case 2.b.}
        DeleteNonPoor := Data[I];
        S := C[I + 1]^.Minimum; {successor of k}
        Data[I] := C[I + 1]^.DeleteNonPoor(S);
        Key [I] := S;
      end
      else
      begin {case 2.c.}
        JoinChild(I);
        {$ifdef debug}
        IsRoot := False;
        {$endif}
        DeleteNonPoor := C[I]^.DeleteNonPoor(K);
      end;
    end
    else
    begin {case 3.}
      if C[I]^.Poor then
        {case 3.a}
        if (I <= N {< N + 1}) {c}and not C[I + 1]^.Poor then
        {case 3.a.i}
          RotateLeft(I)
        else
        if (I > 1) {c}and not C[I - 1]^.Poor then
        {case 3.a.ii}
          RotateRight(I - 1)
        else
        {case 3.b.}
        if I <= N {< N + 1} then
        {case 3.b.i}
          JoinChild(I)
        else
        if I > 1 then
        begin {case 3.b.ii}
          JoinChild(I - 1);
          Dec(I);
        end;
      {$ifdef debug}
      IsRoot := False;
      {$endif}
      DeleteNonPoor := C[I]^.DeleteNonPoor(K);
    end;
  end;
end;

function  TBTreeNode.Minimum : TKey;
begin
  if Leaf then
    Minimum := Key[1]
  else
    Minimum := C[1]^.Minimum;
end;

function  TBTreeNode.Maximum : TKey;
begin
  if Leaf then
    Maximum := Key[N]
  else
    Maximum := C[N + 1]^.Maximum;
end;

procedure TBTreeNode.RotateLeft (I : Integer);
var
  Y, Z : PBTreeNode;
  J : Integer;
begin
  Y := C[I];
  Z := C[I + 1];
  {$ifdef debug}
  if Leaf then
    Error('TBTreeNode.RotateLeft: leaf node');
  if (I < 1) or (I > N) then
    Error('TBTreeNode.RotateLeft: index out of range.');
  if Y^.Full then
    Error('TBTreeNode.RotateLeft: left child node full.');
  if Z^.Poor then
    Error('TBTreeNode.RotateLeft: right child node poor.');
  {$endif}
  J := Y^.N + 1;
  Y^.Key [J] := Key [I];
  Y^.Data[J] := Data[I];
  if not Y^.Leaf then
    Y^.C[J + 1] := Z^.C[1];
  Inc(Y^.N);
  Key [I] := Z^.Key [1];
  Data[I] := Z^.Data[1];
  with Z^ do
  begin
    {replaced by three move()s, because of efficiency
    for J := 1 to N - 1  do
    begin
      Key [J] := Key [J + 1];
      Data[J] := Data[J + 1];
    end;
    if not Leaf then
      for J := 1 to N  do
        C[J] := C[J + 1];}
    Move(Key [2], Key [1], (N - 1) * SizeOf(Key [1]));
    Move(Data[2], Data[1], (N - 1) * SizeOf(Data[1]));
    if not Leaf then
      Move(C[2], C[1], N * SizeOf(C[1]));
    Dec(N);
  end;
end;

procedure TBTreeNode.RotateRight (I : Integer);
var
  Y, Z : PBTreeNode;
  J : Integer;
begin
  Y := C[I];
  Z := C[I + 1];
  {$ifdef debug}
  if Leaf then
    Error('TBTreeNode.RotateRight: leaf node');
  if (I < 1) or (I > N) then
    Error('TBTreeNode.RotateRight: index out of range.');
  if Y^.Poor then
    Error('TBTreeNode.RotateRight: left child node poor.');
  if Z^.Full then
    Error('TBTreeNode.RotateRight: right child node full.');
  {$endif}
  with Z^ do
  begin
    {replaced by three move()s, because of efficiency
    for J := N downto 1  do
    begin
      Key [J + 1] := Key [J];
      Data[J + 1] := Data[J];
    end;
    if not Leaf then
      for J := N + 1 downto 1 do
        C[J + 1] := C[J];}
    Move(Key [1], Key [2], N * SizeOf(Key [1]));
    Move(Data[1], Data[2], N * SizeOf(Data[1]));
    if not Leaf then
      Move(C[1], C[2], (N + 1) * SizeOf(C[1]));
    Inc(N);
  end;
  J := Y^.N;
  Z^.Key [1] := Key [I];
  Z^.Data[1] := Data[I];
  if not Z^.Leaf then
    Z^.C[1] := Y^.C[J + 1];
  Key [I] := Y^.Key [J];
  Data[I] := Y^.Data[J];
  Dec(Y^.N);
end;

{Initializations ************************************************************}

var
  P : PBTreeNode;
  Q : Pointer;

begin
  Q := @P^.InterMark;
  LeafLen := Longint(Seg(Q^)) * $10 + Ofs(Q^);
  Q := @P^.AllMark;
  LeafLen := LeafLen - (Longint(Seg(Q^)) * $10 + Ofs(Q^));
end.
