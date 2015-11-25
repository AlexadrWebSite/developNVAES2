unit uTCform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ComCtrls,uTC, ExtCtrls, StdCtrls, uCartogramM;

type
  TfTCform = class(TForm)
    pcTC: TPageControl;
    tsLoops: TTabSheet;
    tsKNITs: TTabSheet;
    sgLoops: TStringGrid;
    CartogramM: TCartogramM;
    rgKNIT: TRadioGroup;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure sgLoopsDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure sgLoopsSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure sgLoopsDblClick(Sender: TObject);
    procedure rgKNITClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ShowLoops(TC:TTC);
    procedure ShowTPKNIT(TC:TTC;TPIndex:integer);
  end;

var
  fTCform: TfTCform;
  fTC:TTC;
implementation

uses uGenTech, uParamInfo, uBuffer;

{$R *.dfm}

procedure TfTCform.FormCreate(Sender: TObject);
begin
with sgLoops do
  begin
    Cells[0,0]:='KKS';
    Cells[1,0]:='Наименование';
    Cells[2,0]:='Ед. изм.';
    Cells[3,0]:='Сред. зн.';
    Cells[4,0]:='Работоспособность';
    Cells[5,0]:='Достоверность';
    Cells[6,0]:='Примечание';
  end;
end;

procedure TfTCform.ShowLoops(TC: TTC);
var i,j,Count,k:integer;
begin
 fTC:=TC;
 Count:=0;
 for i:=1 to 4 do
 begin
  Count:=Count+TC.Loops[i].HotLeg.Count;
  Count:=Count+TC.Loops[i].ColdLeg.Count;
 end;
 sgLoops.RowCount:=1+Count;
 k:=1;
 for i:=1 to 4 do
   for j:=0 to TC.Loops[i].HotLeg.Count-1 do
   begin
    sgLoops.Cells[0,k]:=TC.Loops[i].HotLeg.TC[j].Description.KKS;
    sgLoops.Cells[1,k]:='Температура гор. петли '+inttoSTr(i);
    sgLoops.Cells[2,k]:='Гр. Цельсия';
    sgLoops.Cells[3,k]:=FloattoStrF( TC.Loops[i].HotLeg.TC[j].CalcValue.Mean,ffFixed,5,2);
    if TC.Loops[i].HotLeg.TC[j].Serviceable then
      sgLoops.Cells[4,k]:='Да' else sgLoops.Cells[4,k]:='Нет';
    if TC.Loops[i].HotLeg.TC[j].Valid then
      sgLoops.Cells[5,k]:='Да' else sgLoops.Cells[5,k]:='Нет';
      sgLoops.Cells[6,k]:=TC.Loops[i].HotLeg.TC[j].Note;
    if TC.Loops[i].HotLeg.TC[j].Description.ID=-1 then
      begin
       sgLoops.Cells[3,k]:=' - ';
       sgLoops.Cells[4,k]:=' - ';
       sgLoops.Cells[5,k]:=' - ';
       sgLoops.Cells[6,k]:='<Не найден параметр в посылке с сервера СВРК>';
      end;
    sgLoops.Objects[1,k]:=TC.Loops[i].HotLeg.TC[j];
    inc(k);  
   end;
 for i:=1 to 4 do
   for j:=0 to TC.Loops[i].ColdLeg.Count-1 do
   begin
    sgLoops.Cells[0,k]:=TC.Loops[i].ColdLeg.TC[j].Description.KKS;
    sgLoops.Cells[1,k]:='Температура хол. петли '+inttoSTr(i);
    sgLoops.Cells[2,k]:='Гр. Цельсия';
    sgLoops.Cells[3,k]:=FloattoStrF( TC.Loops[i].ColdLeg.TC[j].CalcValue.Mean,ffFixed,5,2);
    if TC.Loops[i].ColdLeg.TC[j].Serviceable then
      sgLoops.Cells[4,k]:='Да' else sgLoops.Cells[4,k]:='Нет';
    if TC.Loops[i].ColdLeg.TC[j].Valid then
      sgLoops.Cells[5,k]:='Да' else sgLoops.Cells[5,k]:='Нет';
      sgLoops.Cells[6,k]:=TC.Loops[i].ColdLeg.TC[j].Note;
    if TC.Loops[i].ColdLeg.TC[j].Description.ID=-1 then
      begin
       sgLoops.Cells[3,k]:=' - ';
       sgLoops.Cells[4,k]:=' - ';
       sgLoops.Cells[5,k]:=' - ';
       sgLoops.Cells[6,k]:='<Не найден параметр в посылке с сервера СВРК>';
      end;
    sgLoops.Objects[1,k]:=TC.Loops[i].ColdLeg.TC[j];      
    inc(k);
   end;

end;

procedure TfTCform.sgLoopsDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  case ARow<1 of
  False: begin
         if sgLoops.Cells[Acol,Arow]='Нет' then
         begin
          sgLoops.Canvas.Brush.Color:=clRed;
          sgLoops.Canvas.Rectangle(Rect);
          sgLoops.Canvas.FillRect(Rect);
          sgLoops.Canvas.TextRect(Rect,Rect.Left,Rect.Top,sgLoops.Cells[Acol,Arow]);

         end else
         begin
          sgLoops.Canvas.Brush.Color:=clWindow;
          sgLoops.Canvas.Rectangle(Rect);
          sgLoops.Canvas.FillRect(Rect);
          sgLoops.Canvas.TextRect(Rect,Rect.Left,Rect.Top,sgLoops.Cells[Acol,Arow]);

         end;
         if gdFocused in State then
            sgLoops.Canvas.DrawFocusRect(Rect);

      end;
  True: begin
          sgLoops.Canvas.Brush.Color:=clBtnFace;
          sgLoops.Canvas.Rectangle(Rect);
          sgLoops.Canvas.FillRect(Rect);
          sgLoops.Canvas.TextRect(Rect,Rect.Left,Rect.Top,sgLoops.Cells[Acol,Arow]);
        end;
 end;
end;

procedure TfTCform.sgLoopsSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
SgLoops.Tag:=Arow;
end;

procedure TfTCform.sgLoopsDblClick(Sender: TObject);
var Sensor:TParam;
begin
  if sgLoops.Tag>0 then
  if sgLoops.Objects[1,sgLoops.Tag]<>nil then
  begin
    Sensor:=sgLoops.Objects[1,sgLoops.Tag] as TParam;
    fParamInfo.Sensor:=Sensor;
    fParamInfo.ShowSensor(DateTimeToSTr(now));
    fParamInfo.ShowModal;
  end;end;

procedure TfTCform.ShowTPKNIT(TC:TTC; TPIndex: integer);
var i:integer;
    Min,Max:double;
begin
 for i:=0 to TC.CountKNIT-1 do
  begin
   case TPIndex of
   0:begin
       CartogramM.Value[TC.KNIT[i].NTVS]:=TC.KNIT[i].TPA.CalcValue.Mean;
       CartogramM.Text[TC.KNIT[i].NTVS]:=FloattoStrF(TC.KNIT[i].TPA.CalcValue.Mean,ffFixed,5,2);
       if TC.KNIT[i].TPA.Description.ID=-1 then CartogramM.Text[TC.KNIT[i].NTVS]:=' - ';
     end;
   1:begin
       CartogramM.Value[TC.KNIT[i].NTVS]:=TC.KNIT[i].TPB.CalcValue.Mean;
       CartogramM.Text[TC.KNIT[i].NTVS]:=FloattoStrF(TC.KNIT[i].TPB.CalcValue.Mean,ffFixed,5,2);
       if TC.KNIT[i].TPB.Description.ID=-1 then CartogramM.Text[TC.KNIT[i].NTVS]:=' - ';
     end;
   2:begin
       CartogramM.Value[TC.KNIT[i].NTVS]:=TC.KNIT[i].TP3.CalcValue.Mean;
       CartogramM.Text[TC.KNIT[i].NTVS]:=FloattoStrF(TC.KNIT[i].TP3.CalcValue.Mean,ffFixed,5,2);
       if TC.KNIT[i].TP3.Description.ID=-1 then CartogramM.Text[TC.KNIT[i].NTVS]:=' - ';
     end;
   3:begin
       CartogramM.Value[TC.KNIT[i].NTVS]:=TC.KNIT[i].TC.CalcValue.Mean;
       CartogramM.Text[TC.KNIT[i].NTVS]:=FloattoStrF(TC.KNIT[i].TC.CalcValue.Mean,ffFixed,5,2);
       if TC.KNIT[i].TC.Description.ID=-1 then CartogramM.Text[TC.KNIT[i].NTVS]:=' - ';
     end;
   end;
  end;
  case TPIndex of
  0: Min:=TC.KNIT[0].TPA.CalcValue.Mean;
  1: Min:=TC.KNIT[0].TPB.CalcValue.Mean;
  2: Min:=TC.KNIT[0].TP3.CalcValue.Mean;
  3: Min:=TC.KNIT[0].TC.CalcValue.Mean;
  end;
  Max:=Min;
  for i:=1 to 163 do
  if CartogramM.TVS[i].Assigned then
     begin
      if Min>CartogramM.Value[i] then Min:=CartogramM.Value[i];
      if Max<CartogramM.Value[i] then Max:=CartogramM.Value[i];
     end;
 CartogramM.RecalcColor;
 CartogramM.Refresh;
end;

procedure TfTCform.rgKNITClick(Sender: TObject);
begin
  ShowTPKNIT(fTC,fTCform.rgKNIT.ItemIndex);
end;

end.
