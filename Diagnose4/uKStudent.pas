unit uKStudent;

interface
const 
 KStudent_0_95:array[0..53] of double=(
12.706,
4.302,
3.182,
2.776,
2.57,
2.446,
2.3646,
2.306,
2.2622,
2.2281,
2.201,
2.1788,
2.1604,
2.1448,
2.1314,
2.119,
2.1098,
2.1009,
2.093,
2.086,
2.0790,
2.0739,
2.0687,
2.0639,
2.0595,
2.059,
2.0518,
2.0484,
2.0452,
2.0423,
2.036,
2.0322,
2.0281,
2.0244,
2.0211,
2.018,
2.0154,
2.0129,
2.0106,
2.0086,
2.004,
2.0003,
1.997,
1.9944,
1.99,
1.9867,
1.984,
1.9719,
1.9759,
1.9719,
1.9695,
1.9679,
1.9659,
1.964
);
const 
 Count:array[0..53] of integer=(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,32,34,36,38,40,42,44,46,48,50,55,60,65,70,80,90,100,120,150,200,250,300,400,500);

 Function KStudent(CountPoint:integer):double;


implementation


Function KStudent(CountPoint:integer):double;
var i:integer;
begin
Result:=KStudent_0_95[53];
i:=0;
while (i<53) and (CountPoint>Count[i] )
 do inc(i);
result:=KStudent_0_95[i];
end;
end.