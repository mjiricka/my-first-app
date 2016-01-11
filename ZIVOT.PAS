program Hra_Zivot;
uses CRT;
const colortext=black;
type pole = array[1..10,1..7] of char;
     retezec = string[37];
var A: pole;
    i, j: byte;

{soubory s procedurami a funkcemi}
{$I p-f2}
{$I p-f}

begin

     textmode(3);

     {plneni pole prazdnymi policky}
     for i:=1 to 10 do
       for j:=1 to 7 do A[i,j]:='n';

     intro(true, A);
     frames;
     head;
     wrgrad(A);
     menu(A);

end.