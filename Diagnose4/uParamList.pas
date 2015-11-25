unit uParamList;

interface
uses Dialogs,SysUtils,uStringOperation;


type
TParamList = class(TObject)
private
 FKKS:array of string;
 FIndexes:array of integer;
 FCount:integer;
    function GetKKS(i: integer): string;
    procedure SetCount(const Value: integer);
    procedure SetKKS(i: integer; const Value: string);
    function GetIndex(i: integer): integer;
    procedure SetIndex(i: integer; const Value: integer);
protected

public

property KKS[i:integer]:string read GetKKS write SetKKS;
property Indexes[i:integer]:integer read GetIndex write SetIndex;
property Count:integer read FCount write SetCount;
procedure InitalizeIndexesByStr(IndexesString:string);
function LoadFromFile(FileName:string):boolean;
constructor Create;
destructor Destroy;
end;

implementation

{ TParamList }

constructor TParamList.Create;
begin
 inherited Create;
 FCount:=0;
 SetLength(FKKS,0);
 SetLength(FIndexes,0);
end;

destructor TParamList.Destroy;
begin
 SetLength(FKKS,0);
 SetLength(FIndexes,0); 
 inherited Destroy;
end;

function TParamList.GetIndex(i: integer): integer;
begin
  if (i>=0) and (i<FCount) then Result:=FIndexes[i] else
 MessageDlg('Обращение к элементу ('+inttoStr(i)+') массива индексов за границами массива [0..'+inttoStr(FCount)+']',mtInformation,[mbOk],0);
end;

function TParamList.GetKKS(i: integer): string;
begin
 if (i>=0) and (i<FCount) then Result:=FKKS[i] else
 MessageDlg('Обращение к элементу ('+inttoStr(i)+') массива кодов ККS за границами массива [0..'+inttoStr(FCount)+']',mtInformation,[mbOk],0);
end;

procedure TParamList.InitalizeIndexesByStr(IndexesString: string);
var i:integer;
  SubStr:string;
begin
 i:=0;
 while  GetFirstSubStr(SubStr,IndexesString,#9) do
  if (SubStr<>'') and (SubStr<>'-1') then
   begin
    FIndexes[i]:=StrToInt(SubStr);
    inc(i);
   end;
end;

function TParamList.LoadFromFile(FileName: string): boolean;
var Txt:TextFile;
  i:integer;
  KKS:string;
begin
 Result:=False;
 if FileExists(FileName) then
  begin
   // первый раз считали, что бы посчитать количество строк, т.е кодов KKS
   AssignFile(Txt, FileName);
   Reset(txt);
   i:=0;
   while not EOF(txt) do
   begin
    Readln(txt);
    inc(i);
   end;
   CloseFile(txt);
   // Установили количество кодов
   FCount:=i;
   SetLength(FKKS,FCount);
   SetLength(FIndexes,FCount); // зададим размер массива для кодов датчиков
   // Теперь считали коды KKS
   i:=0;
   AssignFile(Txt, FileName);
   Reset(txt);
   while not eof(txt) do
   begin
    readln(txt,kks);
    FKKS[i]:=KKS;
    inc(i);
   end;
   closeFile(txt);
   Result:=True;
  end;
end;

procedure TParamList.SetCount(const Value: integer);
begin
  FCount := Value;
  SetLength(FKKS,FCount);
  SetLength(FIndexes,FCount);
end;

procedure TParamList.SetIndex(i: integer; const Value: integer);
begin
 if (i>=0) and (i<FCount) then FIndexes[i]:=Value else
 MessageDlg('Обращение к элементу ('+inttoStr(i)+') массива индексов за границами массива [0..'+inttoStr(FCount)+']',mtInformation,[mbOk],0);
end;

procedure TParamList.SetKKS(i: integer; const Value: string);
begin
 if (i>=0) and (i<FCount) then FKKS[i]:=Value else
 MessageDlg('Обращение к элементу ('+inttoStr(i)+') массива кодов ККS за границами массива [0..'+inttoStr(FCount)+']',mtInformation,[mbOk],0);
end;

end.
