{
 Mergable Heap Data Structures Abstract Interface Unit
 Inherited from DS unit
 Copyright (C) August 2000, Behdad Esfahbod
 For licensing issues, read file named COPYING, or contact <behdad@bamdad.org>

 Operations:
   Create        Create an empty DS
   Search        Search DS for a key, return the data
   SearchNode    Search DS for a key, return the node itself
   Insert        Insert a key into the DS
   Delete        Delete a key from the DS
   DeleteNode    Delete a node from the DS
   ExtractMin    Delete minimum key from the DS
   Union         Unites two heaps into one
   DecreaseKey   Decrease a nodes key value

 Functions:
   Empty         Is DS empty or not
   Size          Number of keys in DS
   Minimum       Minimum key in DS

 Comments:
   DS always stands for "data structure".

   Written with an static generic pointer data type, every user must
     recompile for his/her own data type support.
}
{$define debug}
unit
  MergHeap;

interface

  type
    PKey = ^ TKey;
    TKey = Longint;
    {key type to identify datas}
    PData = Pointer;
    {pointer to data to insert}
    PFreeProc = ^ TFreeProc;
    TFreeProc = procedure (P : PData);
    {free procedure that frees a PData var}

  type
    PNode = ^ TNode;
    TNode = object
      Key  : TKey;
      Data : PData;
      constructor Init (const K : TKey; const D : PData);
      {initialize the node with key K and data D}
      destructor Done (FreeProc : PFreeProc); virtual;
      {free mem alocated by this node,
       a procedure can be included to free datas, function prototype
       is procedure name (p : pointer);
       or nil if no data free process needed
       also done frees the mem allocated by this node}
    end;

    PHeap = ^ THeap;
    THeap = object
      N : Longint;

      constructor Create;
      {create and initialize an empty DS}
      destructor Done (FreeProc : PFreeProc); virtual;
      {free all mem alocated by DS, a procedure can be included to free
       datas, function prototype is procedure name (p : pointer);
       or nil if no data free process needed}
      function  ID : string; virtual;
      {id string of DS under use}
      function  Empty : Boolean; virtual;
      {returns if the DS is empty or not}
      function  Size : Longint; virtual;
      {returns number of keys in DS}
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

  {$ifdef debug}
  procedure Error (S : string);
  procedure Warning (S : string);
  {$endif}

implementation

{THeap methods *************************************************************}

constructor THeap.Create;
begin
  N := 0;
end;

destructor THeap.Done (FreeProc : PFreeProc);
begin
end;

function  THeap.ID : string;
begin
  ID := 'Mergable Heap Abstract Model';
end;

function  THeap.Empty : Boolean;
begin
  Empty := N = 0;
end;

function  THeap.Size : Longint;
begin
  Size := N;
end;

function  THeap.Search (const K : TKey) : PData;
begin
  {$ifdef debug}
  Warning('THeap.SearchData: call to unoverriden method.');
  {$endif}
  Search := nil;
end;

function  THeap.SearchNode (const K : TKey) : PNode;
begin
  {$ifdef debug}
  Warning('THeap.SearchNode: call to unoverriden method.');
  {$endif}
  SearchNode := nil;
end;

procedure THeap.Insert (const K : TKey; const D : PData);
begin
  {$ifdef debug}
  Warning('THeap.Insert: call to unoverriden method.');
  {$endif}
  Inc(N);
end;

function  THeap.Delete (const K : TKey) : PData;
begin
  {$ifdef debug}
  Warning('THeap.DeleteKey: call to unoverriden method.');
  if N < 1 then
    Error('THeap.DeleteKey: deleting key from an empty dictionary.');
  {$endif}
  Delete := nil;
  Dec(N);
end;

function  THeap.DeleteNode (const P : PNode) : PData;
begin
  {$ifdef debug}
  Warning('THeap.DeleteNode: call to unoverriden method.');
  if N < 1 then
    Error('THeap.DeleteNode: deleting node from an empty dictionary.');
  if P = nil then
    Error('THeap.DeleteNode: deleting a nil pointer to node.');
  {$endif}
  DeleteNode := nil;
  Dec(N);
end;

function  THeap.ExtractMin (var K : TKey) : PData;
begin
  {$ifdef debug}
  Warning('THeap.ExtractMin: call to unoverriden method.');
  if N < 1 then
    Error('THeap.ExtractMin: deleting key from an empty dictionary.');
  {$endif}
  Dec(N);
end;

procedure THeap.DecreaseKey (const P : PNode; const K : TKey);
begin
  {$ifdef debug}
  Warning('THeap.DecreaseKey: call to unoverriden method.');
  if N < 1 then
    Error('THeap.ExtractMin: deleting key from an empty dictionary.');
  {$endif}
end;

procedure THeap.Union (var H : THeap);
begin
  {$ifdef debug}
  Warning('THeap.Union: call to unoverriden method.');
  {$endif}
  Inc(N, H.N);
  H.N := 0;
  Dispose(PHeap(@H), Done(nil));
end;

function  THeap.Minimum : PNode;
begin
  {$ifdef debug}
  Warning('THeap.Minimum: call to unoverriden method.');
  {$endif}
end;

{TNode methods *************************************************************}

constructor TNode.Init (const K : TKey; const D : PData);
begin
  Key  := K;
  Data := D;
end;

destructor TNode.Done (FreeProc : PFreeProc);
begin
  if FreeProc <> nil then
    FreeProc^(Data);
  Dispose(@Self);
end;

{non methods ***************************************************************}

{$ifdef debug}
procedure Error (S : string);
begin
  Writeln('Error: ', S);
  Halt(10);
end;

procedure Warning (S : string);
begin
  Writeln('Warning: ', S);
end;
{$endif}


end.
