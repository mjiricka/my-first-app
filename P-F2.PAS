{*******************************************}
{VYKRESLENI MRIZKY}
{*******************************************}

procedure wrgrad(B: pole);
 var i, j: byte;

 begin
        textcolor(colortext);

        {pocty veku}
        window(50,5,53,25);

        for i:=10 downto 1 do begin
            writeln(i, '0');
            writeln;
        end;

        {tabulka}
        window(53,4,78,24);
        clrscr;

        {prvni radek}
	write(#218);
	for i:=1 to 6 do begin
            write(#196); write(#194);
	end;
	writeln(#196, #191);

	{stred}
	for j:=1 to 9 do begin

            {sudy radek}
    	    for i:=1 to 7 do begin
        	write(#179); write(' ');
   	    end;
    	    writeln(#179);

            {lichy radek}
	    write(#195);
 	    for i:=1 to 6 do begin
                write(#196); write(#197);
  	    end;
    	    writeln(#196, #180);
	end;

	{posledni 2 radky}
	for i:=1 to 7 do begin
            write(#179); write(' ');
   	end;
	writeln(#179);

	write(#192);
	for i:=1 to 6 do begin
            write(#196); write(#193);
	end;
	write(#196, #217);

        {Doplneni znacek}

        for i:=1 to 10 do
            for j:=1 to 7 do begin
                if not(B[i,j]='n') then begin
                  gotoxy(j*2,i*2);
                  if(B[i,j]='m') then textcolor(blue)
                    else textcolor(red);
                  write(#219);
                  textcolor(colortext);
                end;
            end;
        window(3,6,38,24); {navrat zpet do leveho okna}
 end;


procedure game(var B: pole); forward;
procedure head2(napis: retezec); forward;


{*******************************************}
{NACTENI POCATECNIHO POSTAVENI}
{*******************************************}

 procedure rdgrid(var B: pole);
 var choice, pohlavi: char;
     x, y, code: integer;
     x2: string[10];
 label 1 , 2, 3;

 begin
        head2('Pocatecni pozice hry zivot');
        repeat begin
          clrscr;

          1:  write('Zadejte poradi radku odshora: ');
              readln(x2);
              val(x2,x,code);
              if (not(code<>1) or ((x<1) or (x>10))) then begin
                 textcolor(red);
                 writeln('Hodnota je mimo mez! Opakujte.');
                 textcolor(colortext);
                 goto 1;
              end;

          2: write('Zadejte poradi sloupce zleva: ');
             readln(x2);
             val(x2,y,code);
             if (not(code<>1) or ((y<1) or (y>7))) then begin
                textcolor(red);
                writeln('Hodnota je mimo mez! Opakujte.');
                textcolor(colortext);
                goto 2;
             end;

          3: write('Bude to muz nebo zena? (m/z): '); readln(pohlavi);
             if ((pohlavi='m') or (pohlavi='z')) then A[x,y]:=pohlavi
               else begin
                 textcolor(red);
                 writeln('Kamen nemuze byt neco mezi muzem a  zenou, opakujte!');
                 textcolor(black);
                 goto 3;
               end;
             wrgrad(B);
             clrscr;
             write('Vlozit dalsi postavu? (a/n): '); read(choice); readln;
        end;
          until choice='n';

        game(B);
 end;


{*******************************************}
{GENERACE NAHODNEHO POSUNU}
{*******************************************}

function randomf(cis: integer): integer;
 begin
        if cis=1 then randomf:=2 {'odrazeni od kraje'}
          else if cis=7 then randomf:=6
                 else begin
                   {pro zvyseni variability kazda moznost 3x}
                   case random(9) of
                   0,3,6: randomf:=cis-1;
                   1,4,7: randomf:=cis;
                   2,5,8: randomf:=cis+1;
                 end;
          end;
 end;


{*******************************************}
{SIMULACE GENERACE}
{*******************************************}

procedure sim(var B: pole);
 var i, j, cis: byte;
     a_n: boolean;
     pohlavi: char;

 begin
        cis:=0;
        a_n:=false;

        clrscr;
        writeln('---stalo se---');

        {redukce postavicek na polovinu pri premnozeni}
        {spocitani poctu postav na hraci plose}
        for i:=1 to 10 do
            for j:=1 to 7 do
                if not(B[i,j]='n') then inc(cis);

        if cis>15 then begin
          cis:=0;
          for i:=1 to 10 do
              for j:=1 to 7 do
                  if not(B[i,j]='n') then if a_n=false then begin
                    B[i,j]:='n';
                    inc(cis);
                    a_n:=true;
                   end
                     else a_n:=false;
          writeln('-Radila nemoc! Pocet obeti: ',cis);
        end;
        if cis=0 then writeln('-Na mape jiz nikdo neni!');

        {prirozena smrt}
        for i:=1 to 7 do if not(B[1,i]='n') then begin
            if B[1,i]='m' then writeln('-Dedecek zemrel.')
                else writeln('-Babicka zemrela.');
            B[1,i]:='n';
        end;

        {nahodna smrt}
        i:=random(10)+1;
        j:=random(7)+1;

        if not(B[i,j]='n') then begin
           if B[i,j]='m' then write('-',10-i+1,'0ti lety muz zemrel ');
           if B[i,j]='z' then write('-',10-i+1,'0ti leta zena zemrela ');

           randomize;
           case random(4) of
             0: writeln('na infarkt.');
             1: writeln('pri autonehode.');
             2: writeln('na predavkovani  drogou.');
             3: writeln('behem         prestrelky v supermarketu.');
           end;

           B[i,j]:='n'; {vymazani z pole}
        end;

        {starnuti postavicek}
        for i:=1 to 10 do
            for j:=1 to 7 do begin
                if not(B[i,j]='n') then begin
                   cis:=randomf(j);
                   if not(B[i-1,cis]='n') then begin {oznameni o vrazde}
                      write('-',10-i+2,'0ti let');
                      if B[i,j]='m' then writeln('y muz zabil jinou postavu!')
                         else writeln('a zena zavrazdila jinou    postavu!');
                   end;
                   B[i-1,cis]:=B[i,j]; {prohozeni}
                   B[i,j]:='n';
            end;
        end;

        {pridani z jinych rodin}
        for i:=1 to 10 do begin

            if B[i,1]='m' then begin
               writeln('-',10-i+1,'0ti lety muz si vzal zenu z jine  rodiny.');
               B[i,2]:='z';
            end;

            if B[i,7]='m' then begin
               writeln('-',10-i+1,'0ti lety muz si vzal zenu z jine  rodiny.');
               B[i,6]:='z';
            end;

            if B[i,1]='z' then begin
               writeln('-',10-i+1,'0ti leta zena si vzala muze z     jine rodiny.');
               B[i,2]:='m';
            end;

            if B[i,7]='z' then begin
               writeln('-',10-i+1,'0ti leta zena si vzala muze z     jine rodiny.');
               B[i,6]:='m';
            end;

         end;

        {nemanzelske deti}
        i:=random(10)+1;
        j:=random(7)+1;

        if not(B[i,j]='n') then begin
           if B[i,j]='m' then begin
              writeln('-',10-i+1,'0ti lety muz ma nemanzelske       dite!');
              B[10,j]:='m';
           end;

        if B[i,j]='z' then begin
           writeln('-',10-i+1,'0ti leta zena ma nemanzelske      dite!');
           B[10,j]:='z';
           end;
        end;

        {rozeni deti}
        {vynulovani promenych pro dalsi pouziti}
        cis:=0;
        a_n:=false;
        for i:=1 to 9 do {vynechani 10ti letych deti}
            for j:=1 to 7 do begin
                a_n:=false; {pripraveni promenne a_n na dalsi test}
                if not(B[i,j]='n') then begin
                   if (((B[i,j]='m') and ((B[i,j-1]='z') or (B[i,j+1]='z'))) or
                   ((B[i,j]='z') and ((B[i,j-1]='m') or (B[i,j+1]='m')))) then begin
                     pohlavi:=B[i,j];

                     {testovani volne bunky pro zrozeni ditete}
                     for cis:=j to 7 do if B[10,cis]='n' then begin
                         B[10,cis]:=pohlavi;
                         a_n:=true;
                         break;
                     end;

                     if (a_n=false) then
                        for cis:=j downto 1 do
			    if B[10,cis]='n' then begin
                               B[10,cis]:=pohlavi;
                               a_n:=true;
                               break;
                            end;
                     if (a_n=true) then writeln('-Narodilo se dite!')
			else writeln('-Nezdarilo se zplodit dite!');

                     if j<>7 then j:=j+1; {preskoceni dalsi bunky}
                 end;
               end;
             end;
 
        writeln('-Postavy zestarly o 10 let.');
        write('--------------');
 end;


procedure frames; forward;
procedure head; forward;
procedure menu(var B: pole); forward;


{*******************************************}
{PRUBEH HRY}
{*******************************************}

procedure game(var B: pole);
 var choice: char;

 begin
        head2('Simulace generaci');

        {zobrazeni zpravy o posunu}
        writeln('Nyni zacne hra.');
        writeln('Pro posun mezi generacemi stisknete');
        writeln('libovolnou klavesu.');
        write('Pro konec pismeno q! ');
        readkey;

        head2('q - konec, ostatni - posun');
        clrscr;

        repeat begin
          sim(B);
          wrgrad(B);
          choice:=readkey;
        end;
          until (choice='q');

	{navrat do menu}
        frames;
        head;
        wrgrad(B);
        menu(B);

 end;
