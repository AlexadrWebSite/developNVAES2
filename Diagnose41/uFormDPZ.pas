unit uFormDPZ;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids;

type
  TfFormDPZ = class(TForm)
    sgDPZ: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure sgDPZDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fFormDPZ: TfFormDPZ;

implementation

{$R *.dfm}

procedure TfFormDPZ.FormCreate(Sender: TObject);
var i:integer;
begin
with sgDPZ do
begin
 Cells[0,0]:='Номер КНИТ';
 for i:=1 to 7 do
  Cells[i,0]:='Слой '+InttoStr(i);
 for i:=1 to 54 do
  Cells[0,i]:=InttoStr(i); 
end;
end;

procedure TfFormDPZ.sgDPZDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
 case ARow<1 of
 False: begin
       if sgDPZ.Cells[Acol,Arow]='Ok' then
       begin
        sgDPZ.Canvas.Brush.Color:=clGreen;
        sgDPZ.Canvas.Rectangle(Rect);
        sgDPZ.Canvas.FillRect(Rect);
        sgDPZ.Canvas.TextRect(Rect,Rect.Left,Rect.Top,sgDPZ.Cells[Acol,Arow]);

       end else
       begin
        sgDPZ.Canvas.Brush.Color:=clWindow;
        sgDPZ.Canvas.Rectangle(Rect);
        sgDPZ.Canvas.FillRect(Rect);
        sgDPZ.Canvas.TextRect(Rect,Rect.Left,Rect.Top,sgDPZ.Cells[Acol,Arow]);

       end;
       if gdFocused in State then
          sgDPZ.Canvas.DrawFocusRect(Rect);

    end;
 True: begin
        sgDPZ.Canvas.Brush.Color:=clBtnFace;
        sgDPZ.Canvas.Rectangle(Rect);
        sgDPZ.Canvas.FillRect(Rect);
        sgDPZ.Canvas.TextRect(Rect,Rect.Left,Rect.Top,sgDPZ.Cells[Acol,Arow]);
      end;
 end;
end;

end.
