{
 Data Structures Abstract Interface Unit
 Copyright (C) September 2000, Behdad Esfahbod
 For licensing issues, read file named COPYING, or contact <behdad@bamdad.org>

 Operations:
   Create        Create an empty DS
   Search        Search DS for a key
   Insert        Insert a key into the DS
   Delete        Delete a key from the DS

 Functions:
   Empty         Is DS empty or not
   Size          Number of keys in DS
   ID            Name of DS that is under use

 Comments:
   DS always stands for "data structure".

   Written with an static generic pointer data type, every user must
     recompile for his/her own data type support.
}
unit
  DS;

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
    PDataStruct = ^ TDataStruct;
    TDataStruct = object
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
      procedure Insert (const K : TKey; const D : PData); virtual;
      {insert key K with data Data into DS
       returns true, if it was successful
               false, otherwise (maybe not enough memory)}
      function  Delete (const K : TKey) : PData; virtual;
      {delete key K from DS,
       returns pointer to data asociated with K, or
               nil if not found}
  end;

  {$ifdef debug}
  procedure Error (S : string);
  procedure Warning (S : string);
  {$endif}

implementation

constructor TDataStruct.Create;
begin
  N := 0;
end;

destructor TDataStruct.Done (FreeProc : PFreeProc);
begin
end;

function  TDataStruct.ID : string;
begin
  ID := 'Data Structure Abstract Model';
end;

function  TDataStruct.Empty : Boolean;
begin
  Empty := N = 0;
end;

function  TDataStruct.Size : Longint;
begin
  Size := N;
end;

function  TDataStruct.Search (const K : TKey) : PData;
begin
  {$ifdef debug}
  Warning('TDataStruct.Search: call to unoverriden method.');
  {$endif}
  Search := nil;
end;

procedure TDataStruct.Insert (const K : TKey; const D : PData);
begin
  {$ifdef debug}
  Warning('TDataStruct.Insert: call to unoverriden method.');
  {$endif}
  Inc(N);
end;

function  TDataStruct.Delete (const K : TKey) : PData;
begin
  {$ifdef debug}
  Warning('TDict.Delete: call to unoverriden method.');
  if N < 1 then
    Error('TDict.Delete: deleting key from an empty dictionary.');
  {$endif}
  Delete := nil;
  Dec(N);
end;

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
