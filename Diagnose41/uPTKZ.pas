unit uPTKZ;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids,uGenTech;

type
  TfPTKZ = class(TForm)
    StringGrid: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure StringGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure StringGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure StringGridDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fPTKZ: TfPTKZ;

implementation

uses uParamInfo;

{$R *.dfm}

procedure TfPTKZ.FormCreate(Sender: TObject);
begin
with StringGrid do
begin
 Cells[0,0]:='Код KKS';
 Cells[1,0]:='Имя параметра';
 Cells[2,0]:='Ед. изм.';
 Cells[3,0]:='Знач';
 Cells[4,0]:='СКО';
 Cells[5,0]:='Работосп-ть';
 Cells[6,0]:='|| знач.1';
 Cells[7,0]:='Дост. 1';
 Cells[8,0]:='|| знач.2';
 Cells[9,0]:='Дост. 2';
 Cells[10,0]:='|| знач.3';
 Cells[11,0]:='Дост. 3';
 Cells[12,0]:='Достоверность';
 Cells[13,0]:='Примечание';
end;
end;

procedure TfPTKZ.StringGridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
case ARow<1 of
False: begin
       if StringGrid.Cells[Acol,Arow]='Нет' then
       begin
        StringGrid.Canvas.Brush.Color:=clRed;
        StringGrid.Canvas.Rectangle(Rect);
        StringGrid.Canvas.FillRect(Rect);
        StringGrid.Canvas.TextRect(Rect,Rect.Left,Rect.Top,StringGrid.Cells[Acol,Arow]);

       end else
       begin
        StringGrid.Canvas.Brush.Color:=clWindow;
        StringGrid.Canvas.Rectangle(Rect);
        StringGrid.Canvas.FillRect(Rect);
        StringGrid.Canvas.TextRect(Rect,Rect.Left,Rect.Top,StringGrid.Cells[Acol,Arow]);

       end;
       if gdFocused in State then
          StringGrid.Canvas.DrawFocusRect(Rect);

    end;
True: begin
        StringGrid.Canvas.Brush.Color:=clBtnFace;
         StringGrid.Canvas.Rectangle(Rect);
        StringGrid.Canvas.FillRect(Rect);

        StringGrid.Canvas.TextRect(Rect,Rect.Left,Rect.Top,StringGrid.Cells[Acol,Arow]);
end;end;

end;

procedure TfPTKZ.StringGridSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
StringGrid.Tag:=Arow;
end;

procedure TfPTKZ.StringGridDblClick(Sender: TObject);
var Sensor:TParam;
begin
  if StringGrid.Tag>0 then
  if StringGrid.Objects[1,StringGrid.Tag]<>nil then
  begin
    Sensor:=StringGrid.Objects[1,stringgrid.Tag] as TParam;
    fParamInfo.Sensor:=Sensor;
    fParamInfo.showSensor(DateTimeToSTr(now));
    fParamInfo.ShowModal;
  end;
end;

end.
