unit uArchive;
//----------------------------------------------------------------------------------------
// Unit для работы с архивом, в котором сохраняются результаты обработки
// Автор: Семенихин А.В. semenikhinav@mail.ru
// Дата создания: 13/10/2015
//----------------------------------------------------------------------------------------

interface

uses uTC,uGenTech,uDataModule,SysUtils;

 function FillNameTable(TC:TTC;GenTech:TGenTech):boolean;
 function Save(DateTime:TDateTime; Param:TParam):boolean;

implementation

function FillNameTable(TC:TTC;GenTech:TGenTech):boolean;
 var i,j:integer;
 begin
  Result:=False;
  with DataModule.ADOQueryArc.SQL do
  begin
   //сначала проверить наличие записей в таблице, если их нет, то добавить, иначе ничего не делать
     DataModule.ADOQueryArc.Active:=False;
     Clear;
     Add('SELECT ID_KKS_Name.ID FROM ID_KKS_Name;');
     DataModule.ADOQueryArc.Active:=True;
     if DataModule.ADOQueryArc.RecordCount<1 then
     begin
       // сначала горячие нитки
       for i:=1 to 4 do
        for j:=0 to TC.Loops[i].HotLeg.Count-1 do
        if TC.Loops[i].HotLeg.TC[j].Description.Id<>-1 then
         begin
         Clear;
         Add('INSERT INTO ID_KKS_Name VALUES ('+IntToStr(TC.Loops[i].HotLeg.TC[j].Description.Id )+
         ',"'+TC.Loops[i].HotLeg.TC[j].Description.KKS+
         '","'+TC.Loops[i].HotLeg.TC[j].Description.Name+
         '","'+TC.Loops[i].HotLeg.TC[j].Description.MUnit+'");');
         DataModule.ADOQueryArc.ExecSQL;
         end;
       // теперь холодные нитки
       for i:=1 to 4 do
        for j:=0 to TC.Loops[i].ColdLeg.Count-1 do
        if TC.Loops[i].ColdLeg.TC[j].Description.Id<>-1 then
         begin
         Clear;
         Add('INSERT INTO ID_KKS_Name VALUES ('+IntToStr(TC.Loops[i].ColdLeg.TC[j].Description.Id )+
         ',"'+TC.Loops[i].ColdLeg.TC[j].Description.KKS+
         '","'+TC.Loops[i].ColdLeg.TC[j].Description.Name+
         '","'+TC.Loops[i].ColdLeg.TC[j].Description.MUnit+'");');
         DataModule.ADOQueryArc.ExecSQL;
         end;
       // теперь ТП-1А КНИТ
       for i:=0 to TC.CountKNIT-1 do
       if TC.KNIT[i].TPA.Description.Id<>-1 then
       begin
         Clear;
         Add('INSERT INTO ID_KKS_Name VALUES ('+IntToStr(TC.KNIT[i].TPA.Description.Id )+
         ',"'+TC.KNIT[i].TPA.Description.KKS+
         '","'+TC.KNIT[i].TPA.Description.Name+
         '","'+TC.KNIT[i].TPA.Description.MUnit+'");');
         DataModule.ADOQueryArc.ExecSQL;
       end;
       // теперь ТП-1B КНИТ
       for i:=0 to TC.CountKNIT-1 do
       if TC.KNIT[i].TPB.Description.Id<>-1 then
       begin
         Clear;
         Add('INSERT INTO ID_KKS_Name VALUES ('+IntToStr(TC.KNIT[i].TPB.Description.Id )+
         ',"'+TC.KNIT[i].TPB.Description.KKS+
         '","'+TC.KNIT[i].TPB.Description.Name+
         '","'+TC.KNIT[i].TPB.Description.MUnit+'");');
         DataModule.ADOQueryArc.ExecSQL;
       end;
       // теперь ТП-3 КНИТ
       for i:=0 to TC.CountKNIT-1 do
       if TC.KNIT[i].TP3.Description.Id<>-1 then
       begin
         Clear;
         Add('INSERT INTO ID_KKS_Name VALUES ('+IntToStr(TC.KNIT[i].TP3.Description.Id )+
         ',"'+TC.KNIT[i].TP3.Description.KKS+
         '","'+TC.KNIT[i].TP3.Description.Name+
         '","'+TC.KNIT[i].TP3.Description.MUnit+'");');
         DataModule.ADOQueryArc.ExecSQL;
       end;
       // теперь ТC КНИТ
       for i:=0 to TC.CountKNIT-1 do
       if TC.KNIT[i].TC.Description.Id<>-1 then
       begin
         Clear;
         Add('INSERT INTO ID_KKS_Name VALUES ('+IntToStr(TC.KNIT[i].TC.Description.Id )+
         ',"'+TC.KNIT[i].TC.Description.KKS+
         '","'+TC.KNIT[i].TC.Description.Name+
         '","'+TC.KNIT[i].TC.Description.MUnit+'");');
         DataModule.ADOQueryArc.ExecSQL;
       end;
       //теперь ПТК-З
      for i:=1 to 6 do
       for j:=0 to GenTech.PTKZ[i].Count-1 do
       if GenTech.PTKZ[i].Params[j].Description.Id<>-1 then
        begin
         Clear;
         Add('INSERT INTO ID_KKS_Name VALUES ('+IntToStr(GenTech.PTKZ[i].Params[j].Description.Id )+
         ',"'+GenTech.PTKZ[i].Params[j].Description.KKS+
         '","'+GenTech.PTKZ[i].Params[j].Description.Name+
         '","'+GenTech.PTKZ[i].Params[j].Description.MUnit+'");');
         DataModule.ADOQueryArc.ExecSQL;
       end;
    end;
  end;
   DataModule.ADOQueryArc.Active:=False;
  Result:=True;
 end;
 function Save(DateTime:TDateTime; Param:TParam):boolean;
 begin
  Result:=False;
  if Param.Description.ID<>-1 then
  begin
   DataModule.ADOQueryArc.Active:=False;
   DataModule.ADOQueryArc.SQL.Clear;
   DataModule.ADOQueryArc.SQL.Add('Insert into Arc values ("'+
   DateTimeToStr(DateTime)+'", '+
   INtToStr( Param.Description.ID)+', '+
   FloatToStr(Param.CalcValue.Mean)+', '+
   FloatToStr(Param.CalcValue.MSE)+', '+
   FloatToStr(Param.CalcParamInfo.NomMin)+', '+
   FloatToStr(Param.CalcParamInfo.NomMax)+', '+
   BoolToStr( Param.Serviceable )+', '+
   BoolToStr( Param.Valid )+', '+
   '"'+Param.Note+'");');
   DataModule.ADOQueryArc.ExecSQL;
   Result:=True;
  end;
 end;

end.
