unit uDescription;
//----------------------------------------------------------------------------------------
// �������� TDescription - ������, ������������ ����������
// 19.03.2015
// �����: ��������� �.�.
//----------------------------------------------------------------------------------------

interface

type
TDescription = class(TObject) // o������� ���������
private
 FKKS:string;
 FName:string;
 FMUnit:string;
 FID:integer;
public
  property KKS:string read FKKS write FKKS;
  property Name:string read FName write FName;
  property MUnit:string read FMUnit write FMUnit;
  property ID:integer read FID write FID;
  constructor Create;
  destructor Destroy;
end;


implementation
 { TDescription }

constructor TDescription.Create;
begin
 inherited create;
 FKKS:='';
 FName:='';
 FMUnit:='';
 FID:=-1;
end;

destructor TDescription.Destroy;
begin
 FKKS:='';
 FName:='';
 FMUnit:='';
 FID:=-1;
 inherited destroy;
end;

end.
