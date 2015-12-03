unit uBaseTypes;

interface
uses Graphics;
 type
 TFloatArray = array of Double;
 TStringArray = array of string;
 TIntArray = array of integer;
 TIntArray4 = array [1..4] of integer;
 TBoolArray4=array [1..4] of boolean;
 TLevel7 =array [1..7] of double;
 TChartRect =record
 Top,Bottom,left,right:double;
 end;
 TDoublePoint = record
 DateTime:TDateTime;
 Y:double;
 end;
 TIntPoint = record
 DateTime:TDateTime;
 Index:integer;
 end;
 TBytePoint = record
 Prec:byte;
 Dig:byte;
 end;
//type
 TVSValues163= array [1..163] of double;
const
  CustomColor :array [0..15] of Tcolor = (clBlack,clBlue,clRed,clGreen, clMaroon,clTeal ,clFuchsia,clGray,clPurple,clDkGray,clYellow,$500080,$005080,$005050,$FF5000,clMoneyGreen);
 ColorExcelIndexToUp:array [0..15] of integer = (2,19,27,44,45,46,46,9,29,3,26,22,21,53,53,53);
 ColorExcelIndexToDown:array [0..15] of integer = (15,48,4,43,10,31,34,33,23,32,25,25,25,25,25,25);
 RomDigit: array [1..20] of string =('I','II','III','IV','V','VI','VII','VIII','IX','X','XI','XII','XIII','XIV','XV','XVI','XVII','XVIII','XIX','XX');
type
 TMyChartType = (chtAsIs,chtMovingArrage,chtArrage,chtMovingArrageForAll);
 TMyFieldType = (ftAsIs,ftMovingAverage,ftAverage,ftMovingAverageForAll);

type TValue_StartMeanEnd=record
     VStart,VMean,VEnd:double;
     end;

type TDPZValues =array[1..54]of array[1..7] of Double;
Type TColorTable= array of array of TColor;

type TDynValue= record
   Value:double;
   Valid:boolean;
   end;

type TDynArray=array of TDynValue;
type TDynData =array of TDynArray;

implementation

end.
