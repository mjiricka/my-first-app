{*******************************************}
{VYKRESLENI ROZDELENI OKNA}
{*******************************************}

procedure frames;
 var i: integer;

 begin
        window(1,1,80,25);
        textcolor(white);
        textbackground(3);
        clrscr;

        {rohy}
        gotoxy(2,1); write('╔');
        gotoxy(2,25); write('╚');
        gotoxy(79,1); write('╗');
        gotoxy(79,25); write('╝');

        {spojeni rohu}
        for i:=3 to 78 do begin
            gotoxy(i,1); write('═');
            gotoxy(i,3); write('═');
            gotoxy(i,25); write('═');
        end;

        for i:=2 to 24 do begin
            gotoxy(2,i); write('║');
            gotoxy(79,i); write('║');
        end;

        {predel v prostredni casti}
        for i:=4 to 24 do begin
            gotoxy(39,i); write('║');
        end;

        {dalsi deleni v levem okne}
        for i:=3 to 38 do begin
            gotoxy(i,5); write('═');
        end;

        {doladeni prechodu}
        gotoxy(2,3); write('╠');
        gotoxy(79,3); write('╣');
        gotoxy(39,3); write('╦');
        gotoxy(39,25); write('╩');
        gotoxy(2,5); write('╠');
        gotoxy(39,5); write('╣');
 end;


{*******************************************}
{VYPSANI NADPISU}
{*******************************************}

procedure head;

 begin
        textcolor(black);
        gotoxy(32,2); write('>>>hra ZIVOT<<<');
 end;


{*******************************************}
{VYPSANI NADPISU V LEVEM OKNE}
{*******************************************}

procedure head2(napis: retezec);
 var len: byte;

 begin
        window(3,4,38,4);
        clrscr;
        textcolor(colortext);

        {vypis zhruba do stredu}
        len:=length(napis);
        len:= len div 2;
        gotoxy(19-len,1);
        write(napis);

        window(3,6,38,24); {Navrat zpet do hlavni casti}
        clrscr;
 end;

{*******************************************}
{UKONCENI PROGRAMU}
{*******************************************}
procedure the_end;
 var i: integer;

 begin
        textcolor(white);
        textbackground(black);
        for i:=1 to 80 do begin
            window(1,1,i,25);
            clrscr;
            delay(5);
        end;
        gotoxy(37,11); write('BYE BYE');
        delay(500);
 end;


{*******************************************}
{NAPOVEDA}
{*******************************************}

procedure help (var B: pole);
 var h1, h2, h3: text;
     ch: char;
 label 2 , 3, 4, 5; {2: 1.strana, 3: 2.strana, atd...}

 begin
        2:  head2('q-konec -dolu 1/3');
            assign(h1, 'help1.dat'); reset(h1);
            while not eof(h1) do begin
	          read(h1, ch);
                  write(ch);
            end;
            close(h1);

            repeat
              case readkey of
                #080, #081: goto 3;
                'q': goto 5;
              end;
            until false;

        3:  head2('q-konec -nahoru -dolu 2/3');
            assign(h2, 'help2.dat'); reset(h2);
            while not eof(h2) do begin
                  read(h2, ch);
                  write(ch);
            end;
            close(h2);
            repeat
              case readkey of
                #072, #073: goto 2;
                #080, #081: goto 4;
                'q': goto 5;
              end;
            until false;

        4:  head2('q-konec -nahoru 3/3');
            assign(h3, 'help3.dat'); reset(h3);
            while not eof(h3) do begin
	          read(h3, ch);
                  write(ch);
            end;
            close(h3);
            repeat
              case readkey of
                #072, #073: goto 3;
                'q': goto 5;
              end;
            until false;

        5:  frames;
              head;
              wrgrad(B);
              menu(B);
 end;


{*******************************************}
{SMAZANI MRIZKY}
{*******************************************}

procedure delgrid(var B: pole);
 var i, j: integer;

 begin
        for i:=1 to 10 do
	    for j:=1 to 7 do
		B[i,j]:='n';
	frames;
        head;
        wrgrad(B);
        menu(B);
 end;

procedure intro(a: boolean; var B: pole); forward;


{*******************************************}
{MENU}
{*******************************************}

procedure menu(var B: pole); {pole vstupuje proto, aby se mohlo predat rdgrit}
 var choice: char;

 begin
 
        {vypsani nadpisu}
        head2('..::MENU::..');

        {vypsani voleb}
        write('1. Start hry', #10);
        write('2. Napoveda', #10);
        write('3. Intro', #10);
        write('4. Smazani mrizky', #10);
        write('5. Konec', #10);

        {vyber volby}
        write('Zadejte svoji volbu: ');
        choice:=readkey;

        {provedeni vyberu}
        case choice of
          '1': rdgrid(B);
          '2': help(B);
          '3': intro(false,B);
	  '4': delgrid(B);
          '5': the_end;
           else begin
             textcolor(red);
             write(#10);
             write('Neplatna volba.');
             readkey;
             menu(B);
           end;
        end;
 end;


{*******************************************}
{MODRA OBRAZOVKA NA ZACATKU}
{*******************************************}
{true = zobrazi se na cas, false = ukoncena klavesou}

procedure intro(a: boolean; var B: pole);
 var F: text;
     ch: char;

 begin
        window(1,1,80,25);
	textbackground(blue);
	textcolor(yellow);
        clrscr;
        gotoxy(10,5);
        write('Vitejte ve hre...', #10);

        gotoxy(50,22);
        write('by Martin Jiricka', #10);

        gotoxy(69,25);
        write('verze: 1.0a', #10);

        {napis Zivot}
        assign(F, 'zivot.dat');
	reset(F);
        window(21,7,59,18);
	while not eof(F) do begin
	  read(F, ch);
          write(ch);
        end;
        close(F);
        
        {prehrani muziky}
        sound(200); delay(200); nosound;
        sound(350); delay(200); nosound;
        sound(200); delay(200); nosound;
        sound(300); delay(200); nosound;
        sound(450); delay(600); nosound;
        sound(100); delay(200); nosound;
        sound(50);  delay(800); nosound;

        if a=true then delay(1000)
          else begin
            readkey;
            frames;
            head;
            wrgrad(B);
            menu(B);
        end;
 end;

