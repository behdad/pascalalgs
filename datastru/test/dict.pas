{
 Dictionary Data Structures Abstract Interface Unit
 Inherited from DS unit
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
   Minimum       Minimum key in DS
   Maximum       Maximum key in DS

 Comments:
   DS always stands for "data structure".

   Written with an static generic pointer data type, every user must
     recompile for his/her own data type support.

 Also read header for DS unit.
}
unit
  Dict;

interface

  uses
    DS;

  type
    PDict = ^ TDict;
    TDict = object (TDataStruct)
      {inherits n from tdatastruct}

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
      function  Minimum : TKey; virtual;
      {returns the minimum key in DS, DS must be not empty}
      function  Maximum : TKey; virtual;
      {returns the maximum key in DS, DS must be not empty}
   end;

  {$ifdef debug}
  procedure Error (S : string);
  procedure Warning (S : string);
  {$endif}

implementation

constructor TDict.Create;
begin
  N := 0;
end;

destructor TDict.Done (FreeProc : PFreeProc);
begin
end;

function  TDict.ID : string;
begin
  ID := 'Dictionary Abstract Model';
end;

function  TDict.Empty : Boolean;
begin
  Empty := N = 0;
end;

function  TDict.Size : Longint;
begin
  Size := N;
end;

function  TDict.Search (const K : TKey) : PData;
begin
  {$ifdef debug}
  Warning('TDict.Search: call to unoverriden method.');
  {$endif}
  Search := nil;
end;

procedure TDict.Insert (const K : TKey; const D : PData);
begin
  {$ifdef debug}
  Warning('TDict.Insert: call to unoverriden method.');
  {$endif}
  Inc(N);
end;

function  TDict.Delete (const K : TKey) : PData;
begin
  {$ifdef debug}
  Warning('TDict.Delete: call to unoverriden method.');
  if N < 1 then
    Error('TDict.Delete: deleting key from an empty dictionary.');
  {$endif}
  Delete := nil;
  Dec(N);
end;

function  TDict.Minimum : TKey;
begin
  {$ifdef debug}
  Warning('TDict.Minimum: call to unoverriden method.');
  {$endif}
end;

function  TDict.Maximum : TKey;
begin
  {$ifdef debug}
  Warning('TDict.Maximum: call to unoverriden method.');
  {$endif}
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
