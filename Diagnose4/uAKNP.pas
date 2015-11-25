unit uAKNP;
//----------------------------------------------------------------------------------------
// Описание класса TAKNP  - обработка каналов АКНП
//
// Автор: Семенихин А.В. semenikhinav@mail.ru
// Дата создания: 18.11.2015
//----------------------------------------------------------------------------------------

interface

uses uGenTech,uBuffer,IniFiles,SysUtils;

type TAKNP = class(TObject)
     private
      FChannels:Array [1..8] of TParam;
    function GetChannels(i: integer): TParam;
    procedure SetChannels(i: integer; const Value: TParam);

     protected

     public
       property Channels[i:integer]:TParam read GetChannels write SetChannels;
       procedure LinkBuffer(Buffer: TBuffer);
       constructor Create(AKNPIni:TIniFile);
       destructor Destroy;
     published 

     end;

implementation

{ TAKNP }

constructor TAKNP.Create(AKNPIni:TIniFile);
var i:integer;
begin
 inherited Create;
 for i:=1 to 8 do
  begin
   FChannels[i]:=TParam.Create;
   FCHannels[i].Description.KKS:=AKNPIni.ReadString('Channels','KKS'+IntToStr(i),'');
   FCHannels[i].Description.Name:='Нейтронная мощность АКНП в канале '+IntToStr(i);
   FCHannels[i].Description.MUnit:='%';
  end;
end;

destructor TAKNP.Destroy;
var i:integer;
begin
 for i:=1 to 8 do
  FChannels[i].Destroy;
  inherited Destroy;

end;

function TAKNP.GetChannels(i: integer): TParam;
begin
 Result:=FChannels[i];
end;

procedure TAKNP.LinkBuffer(Buffer: TBuffer);
var i,j,k:integer;
begin
///------------ Hot Leg ---------------------
 for i:=1 to 8 do
 begin
    k:=0;
    while (k<Buffer.CountParam) and
    (FChannels[i].Description.KKS<>Buffer.CalcValues[k].KKS )do
    inc(k);
    if k<Buffer.CountParam then
    if FChannels[i].Description.KKS=Buffer.CalcValues[k].KKS then
     begin
      FChannels[i].Description.ID:=k;// ссылка на элемент в буфере
      FChannels[i].CalcValue:=Buffer.CalcValues[k];
     end;
   end;
end;

procedure TAKNP.SetChannels(i: integer; const Value: TParam);
begin
 FChannels[i]:=Value;
end;

end.
 