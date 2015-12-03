unit uSrvCoreTVS;
//----------------------------------------------------------------------------------------
// Описание класса TSrvCoreTVS - Описание размещения КНИТ в зоне
//
// Автор: Семенихин А.В. semenikhinav@mail.ru
// Дата создания: 23.06.2006
//----------------------------------------------------------------------------------------


interface
 uses uStringOperation, SysUtils,Dialogs;
type
TInfo_TVS=record
  NTvs,YCoord,XCoord,NSec,NTvsInSec,NOrb,NKni,NTp,NGrSuz,NSuz:integer;
 end;
const NilInfo_TVS:TInfo_TVS=(NTvs:-1;YCoord:-1;XCoord:-1;NSec:-1;NTvsInSec:-1;NOrb:-1;NKni:-1;NTp:-1;NGrSuz:-1;NSuz:-1);

type
TSrvCoreTVS = class(TObject)
private
 FItems:array of TInfo_TVS;
 FCount: integer;
 function GetItem(i: integer): TInfo_TVS;
protected

public
      property Count:integer  read FCount;
      property Item[i:integer]:TInfo_TVS  read GetItem ;
      function LoadFromMunit(FileName:string ):boolean;
      function SearchByNTp(NTp:integer):TInfo_TVS;
      function SearchByNTVS(NTVS:integer):TInfo_TVS;
      function SearchByNKNIT(NKNIT:integer):TInfo_TVS;

  constructor Create;
  destructor Destroy;
published
end;
implementation


{ TSrvCoreTVS }

constructor TSrvCoreTVS.Create;
begin
 inherited;
 FCount:=0;
 SetLength(FItems,0);
 Fitems:=nil;

end;

destructor TSrvCoreTVS.Destroy;
begin
  FCount:=0;
 SetLength(FItems,0);
 Fitems:=nil;
  inherited;

end;

function TSrvCoreTVS.GetItem(i: integer): TInfo_TVS;
begin
 Result:=FItems[i];
end;

function TSrvCoreTVS.LoadFromMunit(FileName: string): boolean;
var i,k:integer;
    Txt:TextFile;
    s,TempStr:string;
begin
try
 AssignFile(Txt,FileName);
 Reset(Txt);
 i:=0;
 While not EOF(Txt) do
  begin
   Readln( Txt);
   Inc(i);
   end;
 FCount:=i -3; // количество параметров
 CloseFile(Txt);
 SetLength(FItems,FCount);
 Reset(txt);
 for i:=0 to 2 do Readln(Txt); // пропустили 3 строки с названиями
 // считывание из файла
//NTvs          |YCoord        |XCoord        |NSec          |NTvsInSec     |NOrb          |NKni          |NTp           |NGrSuz        |NSuz          |
//1             |15            |24            |3             |13            |19            |              |              |              |              |


 for i:=0 to FCount-1 do
  begin
   ReadLn(Txt,s);
   GetFirstSubStr(TempStr,s,'|');
   if TempStr='              ' then FItems[i].NTvs:=-1 else
     FItems[i].NTvs:=StrToInt(TranslateToValidNumber(TempStr));

   GetFirstSubStr(TempStr,s,'|');
   if TempStr='              ' then FItems[i].YCoord:=-1 else
     FItems[i].YCoord:=StrToInt(TranslateToValidNumber(TempStr));

   GetFirstSubStr(TempStr,s,'|');
   if TempStr='              ' then FItems[i].XCoord:=-1 else
     FItems[i].XCoord:=StrToInt(TranslateToValidNumber(TempStr));

   GetFirstSubStr(TempStr,s,'|');
   if TempStr='              ' then FItems[i].NSec:=-1 else
     FItems[i].NSec:=StrToInt(TranslateToValidNumber(TempStr));

   GetFirstSubStr(TempStr,s,'|');
   if TempStr='              ' then FItems[i].NTvsInSec:=-1 else
     FItems[i].NTvsInSec:=StrToInt(TranslateToValidNumber(TempStr));

   GetFirstSubStr(TempStr,s,'|');
   if TempStr='              ' then FItems[i].NOrb:=-1 else
     FItems[i].NOrb:=StrToInt(TranslateToValidNumber(TempStr));

   GetFirstSubStr(TempStr,s,'|');
   if TempStr='              ' then FItems[i].NKni:=-1 else
     FItems[i].NKni:=StrToInt(TranslateToValidNumber(TempStr));

   GetFirstSubStr(TempStr,s,'|');
   if TempStr='              ' then FItems[i].NTp:=-1 else
     FItems[i].NTp:=StrToInt(TranslateToValidNumber(TempStr));

   GetFirstSubStr(TempStr,s,'|');
   if TempStr='              ' then FItems[i].NGrSuz:=-1 else
     FItems[i].NGrSuz:=StrToInt(TranslateToValidNumber(TempStr));

   GetFirstSubStr(TempStr,s,'|');
   if TempStr='              ' then FItems[i].NSuz:=-1 else
   FItems[i].NSuz:=StrToInt(TranslateToValidNumber(TempStr));
   end;
 CloseFile(Txt);
 Result:=True;
except
 MessageDlg('Ошибка при открытии файла '+FileName,mtInformation,[mbOk],0);
 CloseFile(Txt);
 Result:=False;
 Exit;
end;
end;

function TSrvCoreTVS.SearchByNKNIT(NKNIT: integer): TInfo_TVS;
var i:integer;
 Found:boolean;
begin
i:=0;
Found:=False;
while (i<FCount) and (not Found) do
 begin
 if FItems[i].NKni=NKNIT then
  begin
   Found:=True;
   Result:=FItems[i];
  end;
  inc(i);
 end;

end;

function TSrvCoreTVS.SearchByNTp(NTp: integer): TInfo_TVS;
var i:integer;
 Found:boolean;
begin
i:=0;
Found:=False;
Result:=NilInfo_TVS;
while (i<FCount) and (not Found) do
 begin
 if FItems[i].NTp=NTp then
  begin
   Found:=True;
   Result:=FItems[i];
  end;
  inc(i);
 end;
end;

function TSrvCoreTVS.SearchByNTVS(NTVS: integer): TInfo_TVS;
var i:integer;
 Found:boolean;
begin
i:=0;
Found:=False;
Result:=NilInfo_TVS;
while (i<FCount) and (not Found) do
 begin
 if FItems[i].NTvs=NTVS then
  begin
   Found:=True;
   Result:=FItems[i];
  end;
  inc(i);
 end;
end;

end.
