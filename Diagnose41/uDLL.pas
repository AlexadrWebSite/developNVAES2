unit uDLL;
//----------------------------------------------------------------------------------------
// Доступ к фунциям DLL okawsp6.dll - WaterStreamPro 6.0
// Автор: Семенихин А.В. semenikhinav@mail.ru
// Дата создания: 23/10/2015
//----------------------------------------------------------------------------------------

interface

function wspVPT(P:double;T:double):double;  stdcall; external 'okawsp6.dll'; // Voluem of water
function wspHPT(P:double;T:double):double; stdcall; external 'okawsp6.dll'; // Enthalpy of water
function wspTSP(P:double):double; stdcall; external 'okawsp6.dll'; // saturation T
function wspHSST(T:double):double; stdcall; external 'okawsp6.dll'; // Enthalpy of steam in saturation line
function wspHSWT(T:double):double; stdcall; external 'okawsp6.dll'; // Enthalpy of water in saturation line



implementation

end.
