1 GOSUB 21000
2 RANDOMIZE TIMER
3 fon = 4: min = 3: gun = 3: bo = 200000: p = 45: z = 12: w = 1: dr = 0
5 DIM cs$(18), pl$(19, 19), mf(18), mm(18), mg(18), mo(18, 18), ca(18), pk$(17, 17), op$(34), j(18), dr$(60), gs(17, 17)
6 ca(1) = 150000: FOR i = 2 TO 17: j(i) = 17: NEXT i
10 '              THE BOSS 96

15 '########################################################### ADATOK
20 DATA "Panathinaikosz","FC Nantes","FC Porto","Dinamo Kijev"
30 DATA "Internationale","Chelsea","Rosenborg BK","Blackburn Rovers"
40 DATA "Rangers FC","Borussia Dortmund","Juventus","AFC Ajax","Real Madrid"
50 DATA "Grasshoppers","Ferencv ros"
70 REM ***********************Panathinaikosz
72 DATA "#Antonisz Likopolidisz -10","Jorgosz Kapuranisz - 8","Atanasziosz Kolitszidakisz -11"
74 DATA "Efsztratiosz Aposztolakisz -12","Jorgosz Georgiadisz - 9","Leonidasz Hrisztodolu -12"
76 DATA "Jannisz Kalitzakisz - 7","Jorgosz Alekszopulosz -11","Alekszandrosz Alekszudisz -12"
78 DATA "Alekszisz Alekszudisz - 6","Juan Jos‚ Gorelli -12","#Jorgosz Georgiadisz - 8"
80 DATA "Andreasz Lagonikakisz - 1","Szpiridon Marangos - 3","Jorgosz Donisz - 7"
82 DATA "Krzystof Warzyca - 4","Alekszandrosz Greatosz -10"
84 '************************* FC Nantes
86 DATA "#Dominique Casagrande - 5","David Marraud - 2","Eddy Capron - 4"
88 DATA "Eric Decroix - 3","Laurent Guyot - 2","Christophe Pignol - 5"
90 DATA "Bruno Carotti - 6","Benoit Cauet - 5","David Garcion - 6","Anthony Martins - 8"
92 DATA "Claude Makelele - 5","#Sebastien Le Paih - 7","Japhet N'Doram - 3"
94 DATA "Frederic Darocha - 3","Oliver Monterubio - 3","Reynald Pedros - 6"
96 DATA "Nicolas Quedec - 7"
98 '************************* FC Porto
100 DATA "#Silvino Louro - 5","Vitor Baia - 4","Ze Carlos Nascimento - 7"
102 DATA "Aloisio Pires Alvez - 4","Fernando Banderinha - 4","Jorge Paulo Costa - 8"
104 DATA "Paulo Lino Borges - 5","Emerson Moises Costa - 6","Russel Latapy - 3"
106 DATA "Lipcsei P‚ter - 6","Carlos Secretario - 7","#Jos‚ Domingos - 4"
108 DATA "Liubinko Drulovics - 4","Antonio Folha - 8","Grzegorz Mielczarski -  7"
110 DATA "Pimenta Edmilson -10","Rui Gil Soares de Barros - 5"
112 REM **********************Dinamo Kijev
114 DATA "#Andrej Kovtun - 4","Szergej Bezsenar - 3","Jurij Dimitrulin - 7","Alekszandr Golovko - 8"
116 DATA "Andrej Homin -10","Szergej Lezsencev - 9","Oleg Vascsuk -11","Juri Makszimov - 8","Szergej Kovalec - 5"
118 DATA "Vitalij Koszovszkij - 8","Dmitrij Mihajlenko - 9","#Szergej Mizin - 4","Pavel Skapenko - 8"
120 DATA "Szergej Konolavov - 7","Szergej Rebrov -10","Andrej Sevcsenko - 5","Szergej Szkacsenko - 9"
122 REM ********************** Internationale
124 DATA "#Gianluca Pagluica -12","Ronaldo -15","Romario-14","Youri Djorkaeff -11","Javier Zanetti -12"
126 DATA "Paul Winter - 9","Diego Simeone -10","Francesco Moriero - 6","Luigi Sartor -7","Taribo West -12"
128 DATA "Fabio Galante - 7","#Gigi Simoni - 8","Fresi -11","Ivan Zamorano -13","Guiseppe Bergoni -10"
130 DATA "Rivaldo -13","Bebeto -12"
132 REM ************************ Chelsea
134 DATA "#Paul Blake -12","David Matthews -12","Tim McCarthy -10","Thomas Grant -5","Andrew Dalson -7"
136 DATA "Adam Carter -11","Paul Gascoigne -14","Karl Lewis -14","Nick Vrenna -11","Jon Barry - 8"
138 DATA "Harold Miner -14","#Jarod Ivanec - 5","Alex Darton - 9","Frank Penny -11","Jay Patrick - 3"
140 DATA "Nick Avatar - 3","Harvey McManaman -12"
142 REM ************************ Rosenborg BK
144 DATA "#Ola Jamtfall -10","Otto Bragstad -11","Jan Halvorsen - 9","Olav Hjelde - 10","Erik Hoftun - 8"
146 DATA "Ola Einar Martinsen - 7","Espen Solheim -10","Arne Winsnes -13","Kent Bergersen - 3"
148 DATA "Brent Skammelsrud - 6","Tront Soltvet - 9","#Roar Strand - 8","Harald Brattbakk -10"
150 DATA "Tore Andre Flu -13","Vegard Seggem - 3","Steffen Iverson - 7"," Karl-Peter Stauvrik - 7"
152 REM **********************Blackburn
154 DATA "#Tim Lowes -11","Hanning Berg -10","Hendry Colin - 4","Jeffrey Kenna -10","Graeme le Saux - 1"
156 DATA "Nick Marker -11","Ian Pearce - 9","Mark Atkins - 5","David Batti - 8","Wayne Gill - 2","Robert Nimms - 1"
158 DATA "#Stuart Ripley - 8","Tim Sharwood - 7","Matthew Holms - 2","Chris Malone - 9","Alan Shearer -12"
160 DATA "Chris Shuton - 7"
162 REM *********************** Rangers FC
164 DATA "#Andrew Goram - 9","Alexander Cleland -11","Alan McLaren -10","Craig Moore - 9","Stephen Wright - 9"
166 DATA "David Robertson -11","Ian Durrant -10","Ian Ferguson - 9","Paul Gascoigne -14","Stuart McCall - 7"
168 DATA "Charles Miller -11","#Neil Murray - 7","Trevor Steven - 5","Gordon Durie - 7","Mark Hateley - 3"
170 DATA "Brian Laudrup -12","Alistair McCoist -15"
172 REM *********************** Borussia Dortmund
174 DATA "#Stefan Klos -10","Julio Ceasar - 7","Jrgen Kohler -12","Martin Kree - 3","Matthias Sammer -10"
176 DATA "Bodo Schmidt - 4","Patrick Berger - 9","Thomas Franck - 5","Steffen Freund - 9","Andreas M”ller -14"
178 DATA "Knut Reinhart - 8","#Ibrahim Tanko - 4","Michael Zork - 6","Heiko Herrlich -11","Lars Ricken -12"
180 DATA "Karlheinz Riedle -12","Stefan Reuter -10"
182 REM *********************** Juventus
184 DATA "#Angelo Peruzzi -10","Massimo Carrera - 8","Ciro Ferrara -10","Sergio Porrini - 9"
186 DATA "Moreno Torricelli - 6","Juan Pablo Sorin - 1","Alessio Tachinardi - 8"
188 DATA "Luca Fusi - 3","Roberto Baggio -12","Antonio Conte - 9","Didier Deschamps -12"
190 DATA "#Michelangelo Rampulla - 4","Angelo Di Livio -11","Alessandro Del Piero -14","Attilio Lombardo -13"
192 DATA "Fabrizio Ravanelli -13","Gianluca Vialli -12"
194 REM ************************* AFC Ajax
196 DATA "#Edwin Van Der Saar -13","Winston Bogarde -10","Danny Blind -11","Frank De Boer -15"
198 DATA "Marcio Santos - 5","Sonny Silooy - 2","Michael Reizinger -10","Arnold Scholten - 2"
200 DATA "Edgar Davids -15","Martin Reuser - 5","Ronald De Boer -14","George Finidi -10","#Fred Grim -10"
202 DATA "Nwanko Kanu -12","Patrick Kluivert -13","Jari Litmanen -11","Marc Overmars -14"
204 REM ************************* Real Madrid
206 DATA "#Francisco Buyo - 2","Manuel Sanchis - 5","Mikel Lasa - 6","Rafael Alkorta - 9"
208 DATA "Fernando Hierro -13","Oliver Nando - 8","Luis Milla - 7","Jos‚ Michel - 5","Fernando Redondo -10"
210 DATA "Luis Enrique -13","Michael Laudrup -15","#Jos‚ Canizares - 4","Ivan Zamorano -14"
212 DATA "Juan Esnaider - 4","Gonzalez Raul -10","Jos‚ Amavisca - 4","Chendo - 2"
214 REM ************************* Grasshoppers
216 DATA "#Pascal Zuberbchler -10","Harald G„mperle - 4","Mats Gren - 5","Pascal Thler - 9"
218 DATA "Ramon Vega -12","Alain Geiger - 9", "Marcel Koller - 4","Massimo Lombardo - 5","Johann Vogel - 9"
220 DATA "Murat Yakin -15","Alexandre Comisetti - 8","#Roberto B”ckli - 4","Ali Ibrahim - 8"
222 DATA "Jo‰l Magnin - 2","Nestor Subiat - 1","Eric Viscaal - 4","Duke Udi - 0"
300 RESTORE 72
302 FOR i = 1 TO 17: READ pk$(i, 2): pl$(i, 2) = pk$(i, 2): NEXT i
304 RESTORE 86
306 FOR i = 1 TO 17: READ pk$(i, 3): pl$(i, 3) = pk$(i, 3): NEXT i
308 RESTORE 100
310 FOR i = 1 TO 17: READ pk$(i, 4): pl$(i, 4) = pk$(i, 4): NEXT i
312 RESTORE 114
314 FOR i = 1 TO 17: READ pk$(i, 5): pl$(i, 5) = pk$(i, 5): NEXT i
316 RESTORE 124
318 FOR i = 1 TO 17: READ pk$(i, 6): pl$(i, 6) = pk$(i, 6): NEXT i
320 RESTORE 134
322 FOR i = 1 TO 17: READ pk$(i, 7): pl$(i, 7) = pk$(i, 7): NEXT i
324 RESTORE 144
326 FOR i = 1 TO 17: READ pk$(i, 8): pl$(i, 8) = pk$(i, 8): NEXT i
328 RESTORE 154
330 FOR i = 1 TO 17: READ pk$(i, 9): pl$(i, 9) = pk$(i, 9): NEXT i
332 RESTORE 164
334 FOR i = 1 TO 17: READ pk$(i, 10): pl$(i, 10) = pk$(i, 10): NEXT i
336 RESTORE 174
338 FOR i = 1 TO 17: READ pk$(i, 11): pl$(i, 11) = pk$(i, 11): NEXT i
340 RESTORE 184
342 FOR i = 1 TO 17: READ pk$(i, 12): pl$(i, 12) = pk$(i, 12): NEXT i
344 RESTORE 196
346 FOR i = 1 TO 17: READ pk$(i, 13): pl$(i, 13) = pk$(i, 13): NEXT i
347 RESTORE 226
348 FOR i = 1 TO 17: READ pk$(i, 14): pl$(i, 14) = pk$(i, 14): NEXT i
350 RESTORE 206
352 FOR i = 1 TO 17: READ pk$(i, 15): pl$(i, 15) = pk$(i, 15): NEXT i
354 RESTORE 214
356 FOR i = 1 TO 17: READ pk$(i, 16): pl$(i, 16) = pk$(i, 16): NEXT i
357 RESTORE 237
359 FOR i = 1 TO 17: READ pk$(i, 17): pl$(i, 17) = pk$(i, 17): NEXT i
360 cs$(1) = "Panathinaikosz"
362 cs$(2) = "FC Nantes"
364 cs$(3) = "FC Porto"
366 cs$(4) = "Dinamo kijev"
368 cs$(5) = "Internationale"
370 cs$(6) = "Chelsea"
372 cs$(7) = "Rosenborg BK"
374 cs$(8) = "Blackburn"
376 cs$(9) = "Rangers FC"
378 cs$(10) = "Borussia Dortmund"
379 cs$(11) = "Juventus"
380 cs$(12) = "AFC Ajax"
382 cs$(13) = "Real Madrid"
384 cs$(14) = "Grasshoppers"
386 cs$(15) = "Ferencv ros"
387 cs$(16) = "Fradidas"
388 GOTO 1000
457 FOR k = 2 TO 16
465 FOR i = 1 TO 16: r = LEN(pl$(i, k)): z = r - 4
470 mo(i, k) = VAL(RIGHT$(pl$(i, k), 2)): pl$(i, k) = LEFT$(pl$(i, k), z)
475 NEXT i
480 mf(k) = mo(2, k) + mo(3, k) + mo(4, k) + mo(5, k)
485 mm(k) = mo(6, k) + mo(7, k) + mo(8, k)
490 mg(k) = mo(9, k) + mo(10, k) + mo(11, k)
495 NEXT k
500 RETURN
999 pe(1) = 150000
1000 CLS : '######################################################### STARTING
1040 INPUT "What will be your teams name"; te$
1050 FOR i = 1 TO 16
1060 IF te$ = cs$(i) THEN v = 1: GOTO 7000
1070 NEXT i: GOTO 1075: IF l = 2 THEN 1130
1075 '######################################################### CSAPATALKOTAS
1080 CLS : INPUT "What's your goal keeper's name"; pl$(1, 1)
1090 pl$(1, 1) = "#" + pl$(1, 1): mo(1, 1) = INT(14 * RND(1) + 1)
1100 FOR i = 2 TO 12
1110 PRINT i; ".player"; : INPUT pl$(i, 1): mo(i, 1) = INT(14 * RND(1) + 1)
1120 NEXT i
1125 '#################################################### JATEK INDITASA
1130 CLS
1140 INPUT "Mennyibe kerlj”n a jegy"; ti: ne = 75000 / ti
1150 CLS
1160 PRINT "***************** "; te$; " *****************"
1170 PRINT "date:"; da$
1180 PRINT : PRINT "GK:"; pl$(1, 1); " -"; mo(1, 1)
1185 PRINT
1190 FOR i = 1 TO 12
1195 IF l = 2 THEN PRINT i; "."; pl$(i, 1) ELSE PRINT i; "."; pl$(i, 1); " -"; mo(i, 1)
1200 NEXT i
1202 PRINT : PRINT : PRINT
1206 IF fon = 1 AND min = 1 THEN mf(1) = mo(2, 1): mm(1) = mo(3, 1): mg(1) = mo(4, 1) + mo(5, 1) + mo(6, 1) + mo(7, 1) + mo(8, 1) + mo(9, 1) + mo(10, 1) + mo(11, 1)
1207 IF fon = 1 AND min = 2 THEN mf(1) = mo(2, 1): mm(1) = mo(3, 1) + mo(4, 1): mg(1) = mo(5, 1) + mo(6, 1) + mo(7, 1) + mo(8, 1) + mo(9, 1) + mo(10, 1) + mo(11, 1)
1208 IF fon = 1 AND min = 3 THEN mf(1) = mo(2, 1): mm(1) = mo(3, 1) + mo(4, 1) + mo(5, 1): mg(1) = mo(6, 1) + mo(7, 1) + mo(8, 1) + mo(9, 1) + mo(10, 1) + mo(11, 1)
1209 IF fon = 1 AND min = 4 THEN mf(1) = mo(2, 1): mm(1) = mo(3, 1) + mo(4, 1) + mo(5, 1) + mo(6, 1): mg(1) = mo(7, 1) + mo(8, 1) + mo(9, 1) + mo(10, 1) + mo(11, 1)
1210 IF fon = 1 AND min = 5 THEN mf(1) = mo(2, 1): mm(1) = mo(3, 1) + mo(4, 1) + mo(5, 1) + mo(6, 1) + mo(7, 1): mg(1) = mo(8, 1) + mo(9, 1) + mo(10, 1) + mo(11, 1)
1211 IF fon = 1 AND min = 6 THEN mf(1) = mo(2, 1): mm(1) = mo(3, 1) + mo(4, 1) + mo(5, 1) + mo(6, 1) + mo(7, 1) + mo(8, 1): mg(1) = mo(9, 1) + mo(10, 1) + mo(11, 1)
1212 IF fon = 1 AND min = 7 THEN mf(1) = mo(2, 1): mm(1) = mo(3, 1) + mo(4, 1) + mo(5, 1) + mo(6, 1) + mo(7, 1) + mo(8, 1) + mo(9, 1): mg(1) = mo(10, 1) + mo(11, 1)
1213 IF fon = 1 AND min = 8 THEN mf(1) = mo(2, 1): mm(1) = mo(3, 1) + mo(4, 1) + mo(5, 1) + mo(6, 1) + mo(7, 1) + mo(8, 1) + mo(9, 1) + mo(10, 1): mg(1) = mo(11, 1)
1214 IF fon = 2 AND min = 1 THEN mf(1) = mo(2, 1) + mo(3, 1): mm(1) = mo(4, 1): mg(1) = mo(5, 1) + mo(6, 1) + mo(7, 1) + mo(8, 1) + mo(9, 1) + mo(10, 1) + mo(11, 1)
1215 IF fon = 2 AND min = 2 THEN mf(1) = mo(2, 1) + mo(3, 1): mm(1) = mo(4, 1) + mo(5, 1): mg(1) = mo(6, 1) + mo(7, 1) + mo(8, 1) + mo(9, 1) + mo(10, 1) + mo(11, 1)
1216 IF fon = 2 AND min = 3 THEN mf(1) = mo(2, 1) + mo(3, 1): mm(1) = mo(4, 1) + mo(5, 1) + mo(6, 1) + mo(7, 1): mg(1) = mo(8, 1) + mo(9, 1) + mo(10, 1) + mo(11, 1)
1217 IF fon = 2 AND min = 4 THEN mf(1) = mo(2, 1) + mo(3, 1): mm(1) = mo(4, 1) + mo(5, 1) + mo(6, 1) + mo(7, 1) + mo(8, 1): mg(1) = mo(9, 1) + mo(10, 1) + mo(11, 1)
1218 IF fon = 2 AND min = 5 THEN mf(1) = mo(2, 1) + mo(3, 1): mm(1) = mo(4, 1) + mo(5, 1) + mo(6, 1) + mo(7, 1) + mo(8, 1): mg(1) = mo(9, 1) + mo(10, 1) + mo(11, 1)
1219 IF fon = 2 AND min = 6 THEN mf(1) = mo(2, 1) + mo(3, 1): mm(1) = mo(4, 1) + mo(5, 1) + mo(6, 1) + mo(7, 1) + mo(8, 1) + mo(9, 1): mg(1) = mo(10, 1) + mo(11, 1)
1220 IF fon = 2 AND min = 7 THEN mf(1) = mo(2, 1) + mo(3, 1): mm(1) = mo(4, 1) + mo(5, 1) + mo(6, 1) + mo(7, 1) + mo(8, 1) + mo(9, 1) + mo(10, 1): mg(1) = mo(11, 1)
1221 IF fon = 3 AND min = 1 THEN mf(1) = mo(2, 1) + mo(3, 1) + mo(4, 1): mm(1) = mo(5, 1): mg(1) = mo(6, 1) + mo(7, 1) + mo(8, 1) + mo(9, 1) + mo(10, 1) + mo(11, 1)
1222 IF fon = 3 AND min = 2 THEN mf(1) = mo(2, 1) + mo(3, 1) + mo(4, 1): mm(1) = mo(5, 1) + mo(6, 1): mg(1) = mo(7, 1) + mo(8, 1) + mo(9, 1) + mo(10, 1) + mo(11, 1)
1223 IF fon = 3 AND min = 3 THEN mf(1) = mo(2, 1) + mo(3, 1) + mo(4, 1): mm(1) = mo(5, 1) + mo(6, 1) + mo(7, 1): mg(1) = mo(8, 1) + mo(9, 1) + mo(10, 1) + mo(11, 1)
1224 IF fon = 3 AND min = 4 THEN mf(1) = mo(2, 1) + mo(3, 1) + mo(4, 1): mm(1) = mo(5, 1) + mo(6, 1) + mo(7, 1) + mo(8, 1): mg(1) = mo(9, 1) + mo(10, 1) + mo(11, 1)
1225 IF fon = 3 AND min = 5 THEN mf(1) = mo(2, 1) + mo(3, 1) + mo(4, 1): mm(1) = mo(5, 1) + mo(6, 1) + mo(7, 1) + mo(8, 1) + mo(9, 1): mg(1) = mo(10, 1) + mo(11, 1)
1226 IF fon = 3 AND min = 6 THEN mf(1) = mo(2, 1) + mo(3, 1) + mo(4, 1): mm(1) = mo(5, 1) + mo(6, 1) + mo(7, 1) + mo(8, 1) + mo(9, 1) + mo(10, 1): mg(1) = mo(11, 1)
1227 IF fon = 4 AND min = 1 THEN mf(1) = mo(2, 1) + mo(3, 1) + mo(4, 1) + mo(5, 1): mm(1) = mo(6, 1): mg(1) = mo(7, 1) + mo(8, 1) + mo(9, 1) + mo(10, 1) + mo(11, 1)
1228 IF fon = 4 AND min = 2 THEN mf(1) = mo(2, 1) + mo(3, 1) + mo(4, 1) + mo(5, 1): mm(1) = mo(6, 1) + mo(7, 1): mg(1) = mo(8, 1) + mo(9, 1) + mo(10, 1) + mo(11, 1)
1229 IF fon = 4 AND min = 3 THEN mf(1) = mo(2, 1) + mo(3, 1) + mo(4, 1) + mo(5, 1): mm(1) = mo(6, 1) + mo(7, 1) + mo(8, 1): mg(1) = mo(9, 1) + mo(10, 1) + mo(11, 1)
1230 IF fon = 4 AND min = 4 THEN mf(1) = mo(2, 1) + mo(3, 1) + mo(4, 1) + mo(5, 1): mm(1) = mo(6, 1) + mo(7, 1) + mo(8, 1) + mo(9, 1): mg(1) = mo(10, 1) + mo(11, 1)
1231 IF fon = 4 AND min = 5 THEN mf(1) = mo(2, 1) + mo(3, 1) + mo(4, 1) + mo(5, 1): mm(1) = mo(6, 1) + mo(7, 1) + mo(8, 1) + mo(9, 1) + mo(10, 1): mg(1) = mo(11, 1)
1232 IF fon = 5 AND min = 1 THEN mf(1) = mo(2, 1) + mo(3, 1) + mo(4, 1) + mo(5, 1) + mo(6, 1): mm(1) = mo(7, 1): mg(1) = mo(8, 1) + mo(9, 1) + mo(10, 1) + mo(11, 1)
1233 IF fon = 5 AND min = 2 THEN mf(1) = mo(2, 1) + mo(3, 1) + mo(4, 1) + mo(5, 1) + mo(6, 1): mm(1) = mo(7, 1) + mo(8, 1): mg(1) = mo(9, 1) + mo(10, 1) + mo(11, 1)
1234 IF fon = 5 AND min = 3 THEN mf(1) = mo(2, 1) + mo(3, 1) + mo(4, 1) + mo(5, 1) + mo(6, 1): mm(1) = mo(7, 1) + mo(8, 1) + mo(9, 1): mg(1) = mo(10, 1) + mo(11, 1)
1235 IF fon = 5 AND min = 4 THEN mf(1) = mo(2, 1) + mo(3, 1) + mo(4, 1) + mo(5, 1) + mo(6, 1): mm(1) = mo(7, 1) + mo(8, 1) + mo(9, 1) + mo(10, 1): mg(1) = mo(11, 1)
1236 IF fon = 6 AND min = 1 THEN mf(1) = mo(2, 1) + mo(3, 1) + mo(4, 1) + mo(5, 1) + mo(6, 1) + mo(7, 1): mm(1) = mo(8, 1): mg(1) = mo(9, 1) + mo(10, 1) + mo(11, 1)
1237 IF fon = 6 AND min = 2 THEN mf(1) = mo(2, 1) + mo(3, 1) + mo(4, 1) + mo(5, 1) + mo(6, 1) + mo(7, 1): mm(1) = mo(8, 1) + mo(9, 1): mg(1) = mo(10, 1) + mo(11, 1)
1238 IF fon = 6 AND min = 3 THEN mf(1) = mo(2, 1) + mo(3, 1) + mo(4, 1) + mo(5, 1) + mo(6, 1) + mo(7, 1): mm(1) = mo(8, 1) + mo(9, 1) + mo(10, 1): mg(1) = mo(11, 1)
1239 IF fon = 7 AND min = 1 THEN mf(1) = mo(2, 1) + mo(3, 1) + mo(4, 1) + mo(5, 1) + mo(6, 1) + mo(7, 1) + mo(8, 1): mm(1) = mo(9, 1): mg(1) = mo(10, 1) + mo(11, 1)
1240 IF fon = 7 AND min = 2 THEN mf(1) = mo(2, 1) + mo(3, 1) + mo(4, 1) + mo(5, 1) + mo(6, 1) + mo(7, 1) + mo(8, 1): mm(1) = mo(9, 1) + mo(10, 1): mg(1) = mo(11, 1)
1241 IF fon = 8 AND min = 1 THEN mf(1) = mo(2, 1) + mo(3, 1) + mo(4, 1) + mo(5, 1) + mo(6, 1) + mo(7, 1) + mo(8, 1) + mo(9, 1): mm(1) = mo(10, 1): mg(1) = mo(11, 1)
1242 FOR i = 1 TO 16: op$(i) = cs$(i): NEXT i
1243 FOR i = 18 TO 32: op$(i) = cs$(i - 17): NEXT i
1246 PRINT "[C]sere [F]el ll s [B]ank [M]enu [š]zlet [J] t‚k [K]ispad [S]ave"
1247 PRINT "P‚nz:"; ca(1)
1250 PRINT "Fel ll s:"; fon; "-"; min; "-"; gun; "Morale:"; mf(1); "-"; mm(1); "-"; mg(1)
1255 a$ = INKEY$: IF a$ = "" THEN 1255
1260 IF a$ = "c" THEN 1290
1265 IF a$ = "f" THEN 1305
1270 IF a$ = "b" THEN 1330
1275 IF a$ = "m" THEN 1370
1277 IF a$ = "s" THEN 21300
1280 IF a$ = "u" THEN 8000
1281 IF a$ = "j" THEN 4300
1282 IF a$ = "k" THEN 11000
1283 GOTO 1255
1285 '################################################################# CSERE
1290 INPUT "H nyas j t‚kost"; nu: j(1) = 12
1295 ce$ = pl$(nu, 1): pl$(nu, 1) = pl$(12, 1): pl$(12, 1) = ce$
1300 GOTO 1150
1305 '############################################################ FELALLAS
1310 INPUT "H ny t mad• legyen"; fon
1315 INPUT "H ny k”z‚pp ly s legyen"; min
1320 gun = 10 - fon - min
1325 GOTO 1150
1330 '################################################################## BANK
1335 CLS
1340 PRINT "Jelenlegi p‚nzed:"; "$ "; ca(1)
1345 PRINT "Felvehet“ ”sszeg:"; bo
1350 PRINT "M r felvett‚l:"; bd; " $-t"
1355 INPUT "Mennyit akarsz felvenni"; bn: IF bn > bo THEN PRINT "Az ”sszeg t£l sok!": SLEEP 2: GOTO 1335
1360 ca(1) = ca(1) + bn: bd = bd + bn: bo = bo - bn
1365 GOTO 1150
1370 '################################################################ MENš
1372 CLS
1375 IF i = 2 AND l = 2 THEN PRINT  ELSE PRINT "[1] Panathinaikosz "
1380 IF i = 3 AND l = 2 THEN PRINT  ELSE PRINT "[2] FC Nantes "
1385 IF i = 4 AND l = 2 THEN PRINT  ELSE PRINT "[3] FC Porto"
1390 IF i = 5 AND l = 2 THEN PRINT  ELSE PRINT "[4] Dinamo Kijev"
1395 IF i = 6 AND l = 2 THEN PRINT  ELSE PRINT "[5] Internazionale"
1400 IF i = 7 AND l = 2 THEN PRINT  ELSE PRINT "[6] Chelsea"
1405 IF i = 8 AND l = 2 THEN PRINT  ELSE PRINT "[7] Rosenborg BK"
1410 IF i = 9 AND l = 2 THEN PRINT  ELSE PRINT "[8] Blackburn Rovers"
1415 IF i = 10 AND l = 2 THEN PRINT  ELSE PRINT "[9] Rangers FC"
1420 IF i = 11 AND l = 2 THEN PRINT  ELSE PRINT "[0] Borussia Dortmund"
1425 IF i = 12 AND l = 2 THEN PRINT  ELSE PRINT "[Q] Juventus"
1430 IF i = 13 AND l = 2 THEN PRINT  ELSE PRINT "[W] AFC Ajax"
1435 IF i = 14 AND l = 2 THEN PRINT  ELSE PRINT "[E] Real Madrid"
1440 IF i = 15 AND l = 2 THEN PRINT  ELSE PRINT "[R] Grasshoppers"
1445 IF i = 16 AND l = 2 THEN PRINT  ELSE PRINT "[T] Ferencv ros": IF l = 2 THEN PRINT "[Y] Fradidas"
1450 PRINT "[D] Draft"
1455 PRINT "[U] Tabella"
1460 PRINT "[M] Meccsnapt r"
1465 PRINT "[K] Kil‚p‚s"
1470 a$ = INKEY$: IF a$ = "" THEN 1470
1475 IF a$ = "1" THEN 1550
1480 IF a$ = "2" THEN 1700
1482 IF a$ = "3" THEN 1800
1484 IF a$ = "4" THEN 1900
1486 IF a$ = "5" THEN 2000
1488 IF a$ = "6" THEN 2100
1490 IF a$ = "7" THEN 2200
1492 IF a$ = "8" THEN 2300
1494 IF a$ = "9" THEN 2400
1496 IF a$ = "0" THEN 2500
1498 IF a$ = "q" THEN 2600
1500 IF a$ = "w" THEN 2700
1502 IF a$ = "e" THEN 2800
1504 IF a$ = "r" THEN 2900
1506 IF a$ = "t" THEN 3000
1507 IF l = 2 AND a$ = "y" THEN 3020
1508 IF a$ = "m" THEN 3100
1513 IF a$ = "u" THEN 3250
1514 IF a$ = "k" THEN 1150
1515 IF a$ = "d" THEN 3410
1516 GOTO 1470
1549 '###################################################### Panathinaikosz
1550 c = 2
1687 GOSUB 10000: PRINT "Fel ll s:4-3-3 "; "Morale:"; mf(c); "-"; mm(c); "-"; mg(c)
1688 INPUT "Akar zletelni?"; q$
1689 IF q$ = "i" THEN 8000 ELSE 1699

1699 GOTO 1150
1700 '######################################################## FC Nantes
1701 c = 3
1708 GOSUB 10000: PRINT "P‚nz:"; ca(3)
1709 PRINT "Fel ll s:4-3-3"; "Morale:"; mf(3); "-"; mm(3); "-"; mg(3)
1798 a$ = INKEY$: IF a$ = "" THEN 1798
1799 GOTO 1150
1800 '####################################################### FC Porto
1801 c = 4
1808 GOSUB 10000: PRINT "P‚nz:"; ca(4)
1809 PRINT "Fel ll s:4-3-3"; "Morale:"; mf(4); "-"; mm(4); "-"; mg(4)
1898 a$ = INKEY$: IF a$ = "" THEN 1898:
1899 GOTO 1150
1900 '####################################################### Dinamo Kijev
1901 c = 5
1908 GOSUB 10000: PRINT "P‚nz:"; ca(5)
1909 PRINT "Fel ll s:4-3-3"; "Morale:"; mf(5); "-"; mm(5); "-"; mg(5)
1998 a$ = INKEY$: IF a$ = "" THEN 1998:
1999 GOTO 1150
2000 '##################################################### Internationale
2001 c = 6
2008 GOSUB 10000: PRINT "P‚nz:"; ca(6)
2009 PRINT "Fel ll s:4-3-3"; "Morale:"; mf(6); "-"; mm(6); "-"; mg(6)
2098 a$ = INKEY$: IF a$ = "" THEN 2098:
2099 GOTO 1150
2100 '################################################### Chelsea
2101 c = 7
2108 GOSUB 10000: PRINT "P‚nz:"; ca(c)
2109 PRINT "Fel ll s:4-3-3"; "Morale:"; mf(c); "-"; mm(c); "-"; mg(c)
2198 a$ = INKEY$: IF a$ = "" THEN 2198:
2199 GOTO 1150
2200 '###################################################### Rosenborg BK
2201 c = 8
2208 GOSUB 10000: PRINT "P‚nz:"; ca(c)
2209 PRINT "Fel ll s:4-3-3"; "Morale:"; mf(c); "-"; mm(c); "-"; mg(c)
2298 a$ = INKEY$: IF a$ = "" THEN 2298:
2299 GOTO 1150
2300 '########################################################Blackburn Rovers
2301 c = 9
2308 GOSUB 10000: PRINT "P‚nz:"; ca(2)
2309 PRINT "Fel ll s:4-3-3"; "Morale:"; mf(c); "-"; mm(c); "-"; mg(c)
2398 a$ = INKEY$: IF a$ = "" THEN 2398:
2399 GOTO 1150
2400 '###########################################################Rangers FC
2401 c = 10
2408 GOSUB 10000: PRINT "P‚nz:"; ca(c)
2409 PRINT "Fel ll s:4-3-3"; "Morale:"; mf(c); "-"; mm(c); "-"; mg(c)
2498 a$ = INKEY$: IF a$ = "" THEN 2498:
2499 GOTO 1150
2500 '#######################################################Borussia Dortmund
2501 c = 11
2508 GOSUB 10000: PRINT "P‚nz:"; ca(c)
2509 PRINT "Fel ll s:4-3-3"; "Morale:"; mf(c); "-"; mm(c); "-"; mg(c)
2598 a$ = INKEY$: IF a$ = "" THEN 2598:
2599 GOTO 1150
2600 '#######################################################Juventus
2601 c = 12
2608 GOSUB 10000: PRINT "P‚nz:"; ca(c)
2609 PRINT "Fel ll s:4-3-3"; "Morale:"; mf(c); "-"; mm(c); "-"; mg(c)
2698 a$ = INKEY$: IF a$ = "" THEN 2698:
2699 GOTO 1150
2700 '#######################################################AFC Ajax
2701 c = 13
2708 GOSUB 10000: PRINT "P‚nz:"; ca(c)
2709 PRINT "Fel ll s:4-3-3"; "Morale:"; mf(c); "-"; mm(c); "-"; mg(c)
2798 a$ = INKEY$: IF a$ = "" THEN 2798:
2799 GOTO 1150
2800 '####################################################Real Madrid
2801 c = 14
2808 GOSUB 10000: PRINT "P‚nz:"; ca(c)
2809 PRINT "Fel ll s:4-3-3"; "Morale:"; mf(c); "-"; mm(c); "-"; mg(c)
2898 a$ = INKEY$: IF a$ = "" THEN 2898:
2899 GOTO 1150
2900 '################################################### Grasshoppers
2901 c = 15
2908 GOSUB 10000: PRINT "P‚nz:"; ca(c)
2909 PRINT "Fel ll s:4-3-3"; "Morale:"; mf(c); "-"; mm(c); "-"; mg(c)
2998 a$ = INKEY$: IF a$ = "" THEN 2998:
2999 GOTO 1150
3000 '###################################################### Ferencv ros
3001 c = 16
3008 GOSUB 10000: PRINT "P‚nz:"; ca(c)
3009 PRINT "Fel ll s:4-3-3"; "Morale:"; mf(c); "-"; mm(c); "-"; mg(c)
3010 a$ = INKEY$: IF a$ = "" THEN 3010
3011 GOTO 1150
3020 '####################################################### Fradidas
3022 c = 17
3024 GOSUB 10000: PRINT "P‚nz:"; ca(c)
3026 PRINT "Fel ll s:4-3-3"; "Morale:"; mf(c); "-"; mm(c); "-"; mg(c)
3028 a$ = INKEY$: IF a$ = "" THEN 1898:
3030 GOTO 1150
3100 '##################################################### MECCSNAPTAR
3105 CLS
3110 PRINT "                                    M E C C S N A P T µ R"
3115 PRINT : PRINT : PRINT : IF l = 2 THEN 3200
3120 FOR i = 1 TO 16: op$(i) = cs$(i)
3125 PRINT i; ". vs. "; op$(i); TAB(40); i + 16; ". vs. "; op$(i + 16)
3130 NEXT i
3135 a$ = INKEY$: IF a$ = "" THEN 3135
3140 GOTO 1150
3200 FOR i = 1 TO 16: op$(i) = cs$(i)
3205 PRINT i; ". vs. "; op$(i); TAB(40); i + 14; ". vs. "; op$(i + 14)
3210 NEXT i
3235 a$ = INKEY$: IF a$ = "" THEN 3235
3240 GOTO 1150
3250 '########################################################### TABELLA
3255 CLS
3260 PRINT "                        T A B E L L A"
3265 PRINT : PRINT : PRINT "Csapat                   M  NY D  V  LG KG PONT ARNY"
3270 PRINT te$; TAB(25); w - 1; TAB(28); wm; TAB(31); dm; TAB(34); lm; TAB(37); lg; TAB(41); kg; TAB(44); po
3399 a$ = INKEY$: IF a$ = "" THEN 3399 ELSE GOTO 1150
3400 END
3410 '############################################################## DRAFT
3415 CLS
3420 FOR i = 1 TO 20: PRINT i; "."; dr$(i); TAB(40); i + 20; "."; dr$(i + 20): NEXT i
3425 PRINT : INPUT "Akar venni"; ve$: IF ve$ = "i" THEN 3430 ELSE 1150
3430 CLS
3435 FOR i = 1 TO 20: PRINT i; "."; dr$(i) + "000"; TAB(40); i + 20; "."; dr$(i + 20) + "000": NEXT i

3440 IF z(1) > 17 THEN PRINT "Sajnos tele a j t‚koskeret!": SLEEP 2: GOTO 1150
3445 PRINT "no.n‚v "; TAB(50); "m x. r $"
3450 FOR i = 1 TO 17:  PRINT i; ".j t‚kos:"; pl$(i, c); TAB(50); (mo(i, c) * 10000): NEXT i
3455 INPUT "h nyas j t‚kost"; nup
3460 INPUT "mennyit adsz ‚rte"; ar
3465 IF ar < mo(nup, c) * 10000 THEN PRINT "Sajnos az nem el‚g!": SLEEP 2: GOTO 1150
3470 PRINT "Rendben!": SLEEP 2: pl$(z + 1, 1) = pl$(nup, c): z(1) = z(1) + 1: z(c) = z(c) - 1: ca(1) = ca(1) - ar
3475 FOR i = nup TO 16: pl$(i, c) = pl$(i + 1, c): NEXT i: pl$(nup, c) = "": GOTO 1150
4300 '############################################################## MECCS
4302 FOR i = 1 TO 17
4304 NEXT i
4305 CLS
4307 PRINT "         Meccsnap:"; w
4309 PRINT te$; "        VS.      "; op$(w)
4310 PRINT : PRINT "Jegy r:100 $"; ti
4312 PRINT "V rhat• n‚z“sz m: 1000000 f‹"; ne
4313 SLEEP 5
4314 PRINT "                    KAPUSOK:"
4316 PRINT pl$(1, 1); TAB(35); pl$(1, w)
4318 PRINT "                    HTVDEK:"
4320 IF gun < 4 THEN FOR i = 2 TO gun + 1: PRINT pl$(i, 1); TAB(35); pl$(i, w + 1): NEXT i: FOR i = gun + 1 TO 5: PRINT TAB(35); pl$(i, w + 1): NEXT i
4322 IF gun = 4 THEN FOR i = 2 TO 5: PRINT pl$(i, 1); TAB(35); pl$(i, w + 1): NEXT i
4324 IF gun > 4 THEN FOR i = 2 TO 5: PRINT pl$(i, 1); TAB(35); pl$(i, w + 1): NEXT i: FOR i = 6 TO gun + 1: PRINT pl$(i, 1): NEXT i
4325 PRINT "                    K™ZPPLYSOK:"
4326 IF min < 3 THEN FOR i = 6 TO min + 1: PRINT pl$(i, 1); TAB(35); pl$(i, w + 1): NEXT i: FOR i = min + 1 TO 5: PRINT TAB(35); pl$(i, w + 1): NEXT i
4328 IF min = 3 THEN FOR i = 6 TO 8: PRINT pl$(i, 1); TAB(35); pl$(i, w + 1): NEXT i
4330 IF min > 3 THEN FOR i = 6 TO 8: PRINT pl$(i, 1); TAB(35); pl$(i, w + 1): NEXT i: FOR i = 6 TO min + 1: PRINT pl$(i, 1): NEXT i
4332 PRINT "                    CSATROK:"
4334 IF fon < 3 THEN FOR i = 9 TO fon + 1: PRINT pl$(i, 1); TAB(35); pl$(i, w + 1): NEXT i: FOR i = fon + 1 TO 5: PRINT TAB(35); pl$(i, w + 1): NEXT i
4336 IF fon = 3 THEN FOR i = 9 TO 11: PRINT pl$(i, 1); TAB(35); pl$(i, w + 1): NEXT i
4338 IF fon > 3 THEN FOR i = 9 TO 11: PRINT pl$(i, 1); TAB(35); pl$(i, w + 1): NEXT i: FOR i = 6 TO fon + 1: PRINT pl$(i, 1): NEXT i
4340 PRINT "                    CSERK:"
4342 FOR i = 12 TO 17: PRINT pl$(i, 1); TAB(35); pl$(i, w + 1): NEXT i
4344 a$ = INKEY$: IF a$ = "" THEN 4344
4349 CLS
4350 PRINT "    "; te$; ":"; tg; "       "; op$(w); ":"; og(o)
4355 PRINT "                                                                             "
4360 PRINT "ÚÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄ¿     "
4365 PRINT "ÃÄÙ                                ³                                 ÀÄ´     "
4370 PRINT "³                                  ³                                   ³     "
4380 PRINT "ÃÄÄÄÄÄÄÄÄ¿                         ³                          ÚÄÄÄÄÄÄÄÄ´     "
4385 PRINT "³        ³                    ÚÄÄÄÄÅÄÄÄÄ¿                     ³        ³     "
4390 PRINT "ÃÄÄÄÄÄ¿  ³                  ÚÄÙ    ³    ÀÄ¿                   ³  ÚÄÄÄÄÄ´     "
4395 PRINT "ÃÄ¿   ³  ³                  ³      ³      ³                   ³  ³   ÚÄ´     "
4400 PRINT "³°³   ³  ³                  ³      ş      ³                   ³  ³   ³°³     "
4405 PRINT "³°³   ³  ³                  ³      ³      ³                   ³  ³   ³°³     "
4410 PRINT "ÃÄÙ   ³  ³                  ÀÄ¿    ³    ÚÄÙ                   ³  ³   ÀÄ´     "
4415 PRINT "ÃÄÄÄÄÄÙ  ³                    ÀÄÄÄÄÅÄÄÄÄÙ                     ³  ÀÄÄÄÄÄ´     "
4420 PRINT "³        ³                         ³                          ³        ³     "
4425 PRINT "ÃÄÄÄÄÄÄÄÄÙ                         ³                          ÀÄÄÄÄÄÄÄÄ´     "
4430 PRINT "³                                  ³                                   ³     "
4435 PRINT "ÃÄ¿                                ³                                 ÚÄ´     "
4440 PRINT "ÀÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÙ     "
4455
4450 a = 6: '******************************************************* Feldob s
4452 FOR i = 1 TO a
4572 FOR j = 0 TO 500: NEXT j
4575 PRINT "   Ú¿  "
4580 PRINT "   ³³  "
4585 PRINT "   ³³  "
4590 PRINT "   ÀÙ  "
4592 FOR j = 0 TO 500: NEXT j
4595 PRINT "/ÄÄÄÄÄ\"
4600 PRINT "³¡r s ³"
4605 PRINT "³¡r s ³"
4610 PRINT "\ÄÄÄÄÄ/"
4612 FOR j = 0 TO 500: NEXT j
4615 PRINT "   Ú¿  "
4620 PRINT "   ³³  "
4625 PRINT "   ³³  "
4630 PRINT "   ÀÙ  "
4635 PRINT "/ÄÄÄÄÄ\"
4640 PRINT "³ fej ³"
4645 PRINT "³ fej ³"
4650 PRINT "\ÄÄÄÄÄ/"
4655 FOR j = 0 TO 500: NEXT j
4660 NEXT i: IF b = 2 THEN 4675
4665 a = INT(2 * RND(1)): b = 2
4670 GOTO 4452
4675 IF a = 1 THEN PRINT "A "; op$(w); " kezd!": at = 1 ELSE PRINT "A "; te$; " kezd!"; at = 0
4676 FOR i = 0 TO 10000: NEXT i
4677 TIME$ = "00:00:00": GOSUB 20000
4771 ato = INT(50 * RND(1)): att = INT(50 * RND(1)): GOSUB 20000
4772 mio = INT(50 * RND(1)): mit = INT(50 * RND(1)): GOSUB 20000
4773 deo = INT(50 * RND(1)): det = INT(50 * RND(1)): GOSUB 20000
4774 FOR i = 0 TO 4000: NEXT i: '********************** t mad s 1/1 f zis
4775 IF at = 1 AND (fm(o) + ato) > (fm(1) + att) THEN PRINT "Az ellenf‚l csat rsora  tt”ri a v‚delmet": GOSUB 20000: GOTO 4800
4780 IF at = 1 AND (fm(o) + ato) = (fm(1) + att) THEN 4771: GOSUB 20000
4785 IF at = 1 AND (fm(o) + ato) < (fm(1) + att) THEN PRINT "Az ellenf‚l csat rsora elakad a mi csat rsorunkban ": GOSUB 20000: GOTO 4787
4787 IF at = 0 AND (fm(1) + att) > (fm(o) / 2 + ato) THEN PRINT "A csat rsorunk  tt”ri az ellenf‚l csat rsor r": GOSUB 20000: GOTO 4850:
4790 IF at = 0 AND (fm(1) + att) = (fm(o) / 2 + ato) THEN 4771: GOSUB 20000
4795 IF at = 0 AND (fm(1) + att) < (fm(o) / 2 + ato) THEN PRINT "A csat rsorunk elakad az ellenf‚l csat rsor ban": GOSUB 20000: GOTO 4800:
4800 FOR i = 0 TO 4000: NEXT i: '******************** v‚delem 2/1
4805 ato = INT(50 * RND(1)): mit = INT(50 * RND(1)): GOSUB 20000
4810 IF (fm(o) + ato) > (mm(1) + mit) THEN PRINT "Az ellenf‚l csat rsor  tt”ri a csat rsorunkat": GOSUB 20000: GOTO 5000:
4815 IF (fm(o) + ato) = (mm(1) + mit) THEN 4805: GOSUB 20000
4820 IF (fm(o) + ato) < (mm(1) + mit) THEN PRINT "Az ellenf‚l csat rsora elakad a v‚delmnkben": GOSUB 20000: GOTO 5050:
4850 FOR i = 0 TO 4000: NEXT i: '********************* t mad s 1/1
4852 ato = INT(50 * RND(1)): att = INT(50 * RND(1)): GOSUB 20000
4855 IF (fm(1) + att) > (fm(o) / 2 + ato) THEN PRINT "A csat rsorunk  ttjut az ellenf‚l cs.-sor n": GOSUB 20000: GOTO 4950
4860 IF (fm(1) + att) = (fm(o) / 2 + ato) THEN 4852: GOSUB 20000
4865 IF (fm(1) + att) < (fm(o) / 2 + ato) THEN PRINT "A cs.-sorunkt•l elveszi a labd t az ellenf‚l cs.sora": GOSUB 20000: GOTO 4950:
4950 FOR i = 0 TO 4000: NEXT i: '********************* a j t‚kos  tt”ri a csat rsort
4952 mio = INT(50 * RND(1)): att = INT(50 * RND(1)): GOSUB 20000
4955 IF (fm(1) + att) > (mm(o) / 2 + mio) THEN 5350: GOSUB 20000
4960 IF (fm(1) + att) = (mm(o) / 2 + mio) THEN 4952: GOSUB 20000
4965 IF (fm(1) + att) < (mm(o) / 2 + mio) THEN 5400: GOSUB 20000
5000 FOR i = 0 TO 4000: NEXT i: '*********************** az ellenf‚l  tt”ri a k”z‚pp ly sokat
5005 deo = INT(50 * RND(1)): det = INT(50 * RND(1)): GOSUB 20000
5010 IF (fm(o) + ato) > (gm(1) + det) THEN 5450: GOSUB 20000
5015 IF (fm(o) + ato) = (gm(1) + det) THEN 5005: GOSUB 20000
5020 IF (fm(o) + ato) < (gm(1) + det) THEN 5500: GOSUB 20000
5050 FOR i = 0 TO 4000: NEXT i: '**** az ellenf‚l megakad a k”z‚pp ly sokban
5055 ato = INT(50 * RND(1)): mit = INT(50 * RND(1)): GOSUB 20000
5060 IF (mm(1) + mit) > (fm(o) + ato) THEN 5550: GOSUB 20000
5065 IF (mm(1) + mit) = (fm(o) + ato) THEN 5055: GOSUB 20000
5070 IF (mm(1) + mit) < (fm(o) + ato) THEN 4852: GOSUB 20000
5150 FOR i = 0 TO 4000: NEXT i: '********************* a j t‚kos megakad az ellenf‚l
5350 FOR i = 0 TO 4000: NEXT i: '********************* a j t‚kos  tt”ri a k”z‚pp ly sokat
5355 att = INT(50 * RND(1)): deo = INT(50 * RND(1)): GOSUB 20000
5360 IF (fm(1) + att) > (gm(o) + deo) THEN 5670: GOSUB 20000
5365 IF (fm(1) + att) = (gm(o) + deo) THEN 5355: GOSUB 20000
5370 IF (fm(1) + att) < (gm(o) + deo) THEN 5400: GOSUB 20000
5400 FOR i = 0 TO 4000: NEXT i: '********************* az ellenf‚l megakad a k”z‚pp ly sokban
5405 att = INT(50 * RND(1)): mio = INT(50 * RND(1)): GOSUB 20000
5410 'IF (mm(o) + mio) > (fm(1) + att) THEN 5005: GOSUB 20000
5415 IF (mm(o) + mio) = (fm(1) + att) THEN 5405: GOSUB 20000
5420 IF (mm(o) + mio) < (fm(1) + att) THEN 4852: GOSUB 20000
5450 FOR i = 0 TO 4000: NEXT i: '********************* az ellenf‚l  tt”ri a v‚delmet
5455 gkd = INT(50 * RND(1)): ato = INT(50 * RND(1)): GOSUB 20000
5460 IF (fm(o) + ato) > (mo(1, 1) + gkd) THEN 5650: GOSUB 20000
5465 IF (fm(o) + ato) = (mo(1, 1) + gkd) THEN 5455: GOSUB 20000
5470 IF (fm(o) + ato) < (mo(1, 1) + gkd) THEN 5700: GOSUB 20000
5500 FOR i = 0 TO 4000: NEXT i: '********************* az ellenf‚l megakad a v‚delmen
5505 gut = INT(50 * RND(1)): ato = INT(50 * RND(1)): GOSUB 20000
5510 IF (gm(1) + gut) > (fm(o) / 2 + ato) THEN 5800: GOSUB 20000
5515 IF (gm(1) + gut) = (fm(o) / 2 + ato) THEN 5505: GOSUB 20000
5520 IF (gm(1) + gut) < (fm(o) / 2 + ato) THEN 4855: GOSUB 20000
5550 FOR i = 0 TO 4000: NEXT i: '******a j t‚kos  tt”r a kp-kkel a csat rsoron
5555 mit = INT(50 * RND(1)): mio = INT(50 * RND(1)): GOSUB 20000
5560 IF (mm(1) + mit) > (mm(o) + mio) THEN 5575: GOSUB 20000
5565 IF (mm(1) + mit) = (mm(o) + mio) THEN 5555: GOSUB 20000
5570 IF (mm(1) + mit) < (mm(o) + mio) THEN 5400: GOSUB 20000
5575 FOR i = 0 TO 4000: NEXT i: '***** a j   kp-kal a kp-n
5580 mit = INT(50 * RND(1)): guo = INT(50 * RND(1)): GOSUB 20000
5585 IF (mm(1) + mit) > (gm(o) + guo) THEN 5600: GOSUB 20000
5590 IF (mm(1) + mit) = (gm(o) + guo) THEN 5505: GOSUB 20000
5596 IF (mm(1) + mit) < (gm(o) + guo) THEN 6000: GOSUB 20000
5600 '************** 'a j   kp-kal a go-t
5605 mit = INT(50 * RND(1)): gko = INT(50 * RND(1)): GOSUB 20000
5610 IF (mm(1) + mit) > (mo(1, w) + gko) THEN 5850: GOSUB 20000
5615 IF (mm(1) + mit) = (mo(1, w) + gko) THEN 5605: GOSUB 20000
5620 IF (mm(1) + mit) < (mo(1, w) + gko) THEN 6000: GOSUB 20000
5650 FOR i = 0 TO 4000: NEXT i: '********************* az ellenf‚l g•lt l“tt a csat rokkal
5655 og = og + 1: GOSUB 20000
5660 gs = INT(4 * RND(1)): PRINT ti; "... "; pl$(9 + gs, w + 1): kg = kg + 1: mo(9 + gs, w + 1) = mo(9 + gs, w + 1) + 1
5662 FOR i = 0 TO 20000: NEXT i: GOSUB 20000
5665 FOR i = 0 TO 4000: NEXT i:  GOSUB 20000
5670 FOR i = 0 TO 4000: NEXT i: '******************** a j t‚kos  tjutott az ellenf‚l v‚delm‚n
5675 att = INT(50 * RND(1)): gko = INT(50 * RND(1)): GOSUB 20000
5680 IF (fm(1) + att) > (mo(1, o) + gko) THEN 5750: GOSUB 20000
5685 IF (fm(1) + att) = (mo(1, o) + gko) THEN 5675: GOSUB 20000
5690 IF (fm(1) + att) < (mo(1, o) + gko) THEN 5800: GOSUB 20000
5700 FOR i = 0 TO 4000: NEXT i: '************* a g‚p kihagyja a kapura l”v‚st
5710 FOR i = 0 TO 4000: NEXT i: GOTO 5500: GOSUB 20000
5750 FOR i = 0 TO 4000: NEXT i: '******************* a j t‚kos g•lt l“tt a csat rsorral
5755 tg = tg + 1: GOSUB 20000
5760 gs = INT(fon * RND(1)): PRINT ti; "... "; pl$(min + gs, 1): lg = lg + 1: mo(min + gs, 1) = mo(min, gs + 1) + 1
5762 FOR i = 0 TO 20000: NEXT i: GOSUB 20000
5765 FOR i = 0 TO 4000: NEXT i:  GOSUB 20000
5800 FOR i = 0 TO 4000: NEXT i: '*********************** A v‚d“k  tjutnak a csat rokon
5805 gut = INT(50 * RND(1)): mio = INT(50 * RND(1)): GOSUB 20000
5810 IF (gm(1) + gut) > (mm(o) + mio) THEN 5900: GOSUB 20000
5815 IF (gm(1) + gut) = (mm(o) + mio) THEN 5805: GOSUB 20000
5820 IF (gm(1) + gut) < (mm(o) + mio) THEN 5405: GOSUB 20000
5850 FOR i = 0 TO 4000: NEXT i: '******** a kp-k golt lonek
5855 tg = tg + 1: GOSUB 20000
5860 gs = INT(min * RND(1)): PRINT ti; "..."; pl$(gun + 1 + gs, 1); "  from:"; te$: lg = lg + 1: mo(gun + 1 + gs, 1) = mo(gun + 1 + gs, 1) + 1
2865 FOR i = 0 TO 20000: NEXT i: GOSUB 20000
5870 FOR i = 0 TO 4000: NEXT i: GOSUB 20000
5900 FOR i = 0 TO 4000: NEXT i: '*********************** A v‚d“k  tjutnak a k”z‚pp‚ly sokon
5910 gut = INT(50 * RND(1)): guo = INT(50 * RND(1)): GOSUB 20000
5915 IF (gm(1) + gut) > (gm(o) + guo) THEN 5950: GOSUB 20000
5920 IF (gm(1) + gut) = (gm(o) + guo) THEN 5910: GOSUB 20000
5925 IF (gm(1) + gut) < (gm(o) + guo) THEN 6000: GOSUB 20000
5950 FOR i = 0 TO 4000: NEXT i: '*********************** A v‚d“k  tjutnak a v‚d“k”n
5955 gut = INT(50 * RND(1)): gko = INT(50 * RND(1)): GOSUB 20000
5960 IF (gm(1) + gut) > (gk(o) + guo) THEN 6050: GOSUB 20000
5965 IF (gm(1) + gut) = (gk(o) + guo) THEN 5955: GOSUB 20000
5970 IF (gm(1) + gut) < (gk(o) + guo) THEN 6100: GOSUB 20000
6000 FOR i = 0 TO 4000: NEXT i: '************************ A v‚d“k elakadnak a v‚d“kben
6005 guo = INT(50 * RND(1)): att = INT(50 * RND(1)): GOSUB 20000
6010 IF (gm(o) + guo) > (fm(1) + att) THEN 6150: GOSUB 20000
6015 IF (gm(o) + guo) = (fm(1) + att) THEN 6005: GOSUB 20000
6020 IF (gm(o) + guo) < (fm(1) + att) THEN 6200: GOSUB 20000
6050 FOR i = 0 TO 4000: NEXT i: '************************ A v‚d“k g•lt r£gnak
6055 tg = tg + 1: GOSUB 20000
6060 gs = INT(gun * RND(1)): PRINT ti; "... "; pl$(2 + gs, 1): lg = lg + 1: mo(2 + gs, 1) = mo(2 + gs, 1) + 1
6065 FOR i = 0 TO 20000: NEXT i: GOSUB 20000
6070 FOR i = 0 TO 4000: NEXT i:  GOSUB 20000
6100 FOR i = 0 TO 4000: NEXT i: GOTO 6005: GOSUB 20000
6150 FOR i = 0 TO 4000: NEXT i: '******************** A v‚d“k  tjutnak a csat rokon
6155 guo = INT(50 * RND(1)): mit = INT(50 * RND(1)): GOSUB 20000
6160 IF (gm(o) + guo) > (mm(1) + mit) THEN 6250: GOSUB 20000
6165 IF (gm(o) + guo) = (mm(1) + mit) THEN 6155: GOSUB 20000
6170 IF (gm(o) + guo) < (mm(1) + mit) THEN 4852: GOSUB 20000
6200 FOR i = 0 TO 4000: NEXT i: GOTO 4852: GOSUB 20000
6250 FOR i = 0 TO 4000: NEXT i: '******************* A V‚d“k  tjutnak a k”z‚pp ly sokon
6255 guo = INT(50 * RND(1)): gut = INT(50 * RND(1)): GOSUB 20000
6260 IF (gm(o) + guo) > (gm(1) + gut * 1.2) THEN 6300: GOSUB 20000
6265 IF (gm(o) + guo) = (gm(1) + gut * 1.2) THEN 6255: GOSUB 20000
6270 IF (gm(o) + guo) < (gm(1) + gut * 1.2) THEN 5500: GOSUB 20000
6300 FOR i = 0 TO 4000: NEXT i: '******************* A v‚d“k  tjutnak a v‚d“k”n
6305 guo = INT(50 * RND(1)): gkt = INT(50 * RND(1)): GOSUB 20000
6310 IF (gm(o) + guo) > (mo(1, 1) * 1.5 + gkt) THEN 6400: GOSUB 20000
6315 IF (gm(o) + guo) = (mo(1, 1) * 1.5 + gkt) THEN 6305: GOSUB 20000
6320 IF (gm(o) + guo) < (mo(1, 1) * 1.5 + gkt) THEN 5500: GOSUB 20000
6350 FOR i = 0 TO 4000: NEXT i: '******************* A v
6400 FOR i = 0 TO 4000: NEXT i: '******************* A V‚d“k g•lt r£gnak
6445 og = og + 1: GOSUB 20000
6450 gs = INT(4 * RND(1)): PRINT ti; "... "; pl$(5 - gs, w + 1): kg = kg + 1: mo(5 - gs, w + 1) = mo(5 - gs, w + 1) + 1
6455 FOR i = 0 TO 20000: NEXT i: GOSUB 20000
6460 FOR i = 0 TO 4000: NEXT i:  GOSUB 20000

6500 ' ******************* v‚geredm‚ny
6505 IF og > tg THEN 6600
6510 IF og = tg THEN p = 45: PRINT "Hosszabb¡t s!": TIME$ = "00:00:00": GOSUB 20000: GOTO 4350
6515 IF og < tg THEN 6650
6600 ' ******************* veres‚g
6605 CLS : PRINT : PRINT : PRINT : PRINT : PRINT : PRINT
6610 PRINT "          sajnos te most, "; da$; "- n(-‚n) veres‚get szenvedt‚l"
6620 FOR i = 0 TO 20000: NEXT i: og = 0: tg = 0: w = w + 1: ca(1) = ca(1) - ne * ti: lm = lm + 1
6625 GOTO 1150
6650 '******************** gy“zelem
6660 CLS : PRINT : PRINT : PRINT : PRINT : PRINT : PRINT : PRINT
6665 PRINT "                G Y ™ Z T  L !": bev = INT(ti * ne / 75)
6670 PRINT "          m‚ghozz "; tg; ":"; og; " ar nyban!": tg = 0: og = 0: ca(1) = ca(1) + bev: wm = wm + 1: po = po + 2
6680 FOR i = 0 TO 20000: NEXT i: w = w + 1
6685 GOTO 1150
7000 l = 2
7002 te$ = cs$(i)
7004 FOR j = 1 TO 17: pl$(j, 1) = pl$(j, i + 1): NEXT j
7006 FOR k = i + 1 TO 16: cs$(k) = cs$(k + 1): FOR p = 1 TO 17: pl$(p, k) = pl$(p, k + 1): NEXT p: NEXT k
7026 GOTO 1150
8000 '########################################################### ULZETELS
8005 CLS
8010 PRINT : PRINT : PRINT "[1] J t‚kos elad sa"
8015 PRINT "[2] J t‚kos v‚tele"
8020 PRINT "[3] J t‚kos cser‚je"
8025 PRINT "[4] Draft"
8030 a$ = INKEY$: IF a$ = "" THEN 8030
8035 IF a$ = "1" THEN 8100
8040 IF a$ = "2" THEN 8150
8045 IF a$ = "3" THEN 8200
8050 IF a$ = "4" THEN 8030 ELSE GOTO 8030
8100 '################################################### JTKOS ELADSA
8101 FOR i = 1 TO 17: IF pl$(i, 1) = "" THEN pl$(i, 1) = pl$(i + 1, 1): IF i = 17 THEN pl$(17, 1) = ""
8102 NEXT i
8103 FOR i = 1 TO 17: IF pl$(i, c) = "" THEN pl$(i, c) = pl$(i + 1, c): IF i = 17 THEN pl$(17, c) = ""
8104 NEXT i
8105 CLS
8110 PRINT "            J t‚kos elad sa": PRINT : PRINT
8112 PRINT "no.n‚v "; TAB(40); "m x. r $"
8115 FOR i = 1 TO 17:  PRINT i; ".j t‚kos:"; pl$(i, 1); TAB(40); (mo(i, 1) * 10000): NEXT i
8120 PRINT : PRINT : INPUT "H nyas j t‚kost"; nup
8125 INPUT "mennyi‚rt"; ar
8130 IF ar > mo(nup, 1) * 10000 THEN PRINT : PRINT "Annyit nem adok ‚rte!!": SLEEP 2: PRINT : GOTO 1150
8135 PRINT "rendben!": SLEEP 2: ca(1) = ca(1) + ar
8140 FOR i = nup TO 16: pl$(i, 1) = pl$(i + 1, 1): NEXT i: dr$(dr + 1) = pl$(nup, 1): dr = dr + 1: pl$(z, 1) = "": GOTO 1150
8150 '################################################ JTKOS VTELE
8151 FOR i = 1 TO 17: IF pl$(i, 1) = "" THEN pl$(i, 1) = pl$(i + 1, 1): IF i = 17 THEN pl$(17, 1) = ""
8152 NEXT i
8153 FOR i = 1 TO 17: IF pl$(i, c) = "" THEN pl$(i, c) = pl$(i + 1, c): IF i = 17 THEN pl$(17, c) = ""
8154 NEXT i
8155 IF z(1) > 17 THEN PRINT "Sajnos tele a j t‚koskeret!": SLEEP 2: GOTO 1150
8156 PRINT "no.n‚v "; TAB(50); "m x. r $"
8157 FOR i = 1 TO 17:  PRINT i; ".j t‚kos:"; pl$(i, c); TAB(50); (mo(i, c) * 10000): NEXT i
8158 INPUT "h nyas j t‚kost"; nup
8160 INPUT "mennyit adsz ‚rte"; ar
8165 IF ar < mo(nup, c) * 10000 THEN PRINT "Sajnos az nem el‚g!": SLEEP 2: GOTO 1150
8170 PRINT "Rendben!": SLEEP 2: pl$(z + 1, 1) = pl$(nup, c): z(1) = z(1) + 1: z(c) = z(c) - 1: ca(1) = ca(1) - ar
8175 FOR i = nup TO 16: pl$(i, c) = pl$(i + 1, c): NEXT i: pl$(nup, c) = "": GOTO 1150
8200 '######################################################## JTKOS CSERJE
8201 FOR i = 1 TO 17: IF pl$(i, 1) = "" THEN pl$(i, 1) = pl$(i + 1, 1): IF i = 17 THEN pl$(17, 1) = ""
8202 NEXT i
8203 FOR i = 1 TO 17: IF pl$(i, c) = "" THEN pl$(i, c) = pl$(i + 1, c): IF i = 17 THEN pl$(17, c) = ""
8204 NEXT i
8207 PRINT "no.n‚v "; TAB(40); "m x. r $"
8208 FOR i = 1 TO 17:  PRINT i; ".j t‚kos:"; pl$(i, 1); TAB(50); (mo(i, 1) * 10000): NEXT i
8209 INPUT "h ny j t‚kost k‚rsz (max.8)"; np
8210 INPUT "h ny j t‚kost adsz? (max.8)"; nt
8211 IF np > 17 - (z(1) - nt) THEN PRINT "T£l sok j t‚kost k‚rsz!": SLEEP 2: GOTO 1150
8212 IF nt > 17 - (z(c) - np) THEN PRINT "T£l sok j t‚kost adsz!": SLEEP 2: GOTO 1150
8215 FOR i = 1 TO np: PRINT "Ki az "; i; ".j t‚kos"; : INPUT np(i): moc = moc + mo(i, c): NEXT i
8220 FOR j = 1 TO nt: PRINT "Kire"; : INPUT nt(j): moa = moa + mo(j, 1): NEXT j
8225 IF moc > moa THEN PRINT "Ez ¡gy kev‚s!": SLEEP 2: GOTO 8500
8230 z(c) = z(c) - np + nt: z(1) = z(1) - nt + np
8235 IF nt < np THEN FOR i = 1 TO nt: qwe$ = pl$(nt(i), 1): pl$(nt(i), 1) = "": pl$(np(i), c) = qwe$: NEXT i: FOR k = i + 1 TO nt: pl$(k, c) = pl$(nt(k), 1): pl$(nt(k), 1) = "": NEXT k
8240 IF nt = np THEN FOR i = 1 TO nt: qwe$ = pl$(nt(i), 1): pl$(nt(i), 1) = "": pl$(np(i), c) = qwe$: NEXT i
8245 IF nt > np THEN FOR i = 1 TO np: qwe$ = pl$(nt(i), 1): pl$(nt(i), 1) = "": pl$(np(i), c) = qwe$: NEXT i: FOR k = i + 1 TO np: pl$(k, 1) = pl$(np(k), c): pl$(np(k), c) = "": NEXT k
8250 GOTO 1150
8500 INPUT "Adsz a j t‚kosok mell‚ p‚nzt"; qw$
8510 IF qw$ = "i" THEN 8515 ELSE 1150
8515 INPUT "Mennyit"; ar: IF ar / 10000 + moa >= moc THEN 8230 ELSE PRINT "Ez ¡gy kev‚s!": SLEEP 2: GOTO 1150
9999 END
10000 CLS
10160 PRINT "***************** "; cs$(c - 1); " *****************"
10170 PRINT "date:"; da$
10180 PRINT : PRINT "GK:"; pl$(1, c)
10185 PRINT
10190 FOR i = 2 TO 17
10195 PRINT i; "."; pl$(i, c)
10200 NEXT i
10205 PRINT
10210 RETURN
11000 CLS
11010 FOR i = 12 TO 17
11020 PRINT i; ". "; pl$(i, 1)
11030 NEXT i
11040 PRINT "[H]aszn lni [E]ladni [K]il‚p‚s"
11045 a$ = INKEY$: IF a$ = "" THEN 11045
11050 IF a$ = "h" THEN PRINT : INPUT "H nyas j t‚kost"; nup: pl$(18, 1) = pl$(12, 1): pl$(12, 1) = pl$(nup, 1): pl$(nup, 1) = pl$(18, 1): GOTO 1150
11055 IF a$ = "e" THEN PRINT : INPUT "H nyas j t‚kost"; nup: INPUT "Mennyi‚rt"; ar: IF ar > mo(nup, 1) THEN PRINT "Az t£l sok!" ELSE PRINT "Rendben!": dr$(x + 1) = pl$(nup, 1): ca(1) = ca(1) + ar: pl$(nup, 1) = ""
11060 IF a$ = "k" THEN 1150 ELSE GOTO 11040
19995 END
20000 CLS
20005 ti = VAL(RIGHT$(TIME$, 2)): PRINT "    "; te$; ":"; tg; "       "; op$(w); ":"; og
20006 IF ti >= p THEN 6500
20007
20008 PRINT "                              ID”:"; ti
20009 PRINT "ÚÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄ¿     "
20010 PRINT "ÃÄÙ                                ³                                 ÀÄ´     "
20015 PRINT "³                                  ³                                   ³     "
20020 PRINT "ÃÄÄÄÄÄÄÄÄ¿                         ³                          ÚÄÄÄÄÄÄÄÄ´     "
20025 PRINT "³        ³                    ÚÄÄÄÄÅÄÄÄÄ¿                     ³        ³     "
20030 PRINT "ÃÄÄÄÄÄ¿  ³                  ÚÄÙ    ³    ÀÄ¿                   ³  ÚÄÄÄÄÄ´     "
20035 PRINT "ÃÄ¿   ³  ³                  ³      ³      ³                   ³  ³   ÚÄ´     "
20040 PRINT "³°³   ³  ³                  ³      ş      ³                   ³  ³   ³°³     "
20055 PRINT "³°³   ³  ³                  ³      ³      ³                   ³  ³   ³°³     "
20060 PRINT "ÃÄÙ   ³  ³                  ÀÄ¿    ³    ÚÄÙ                   ³  ³   ÀÄ´     "
20065 PRINT "ÃÄÄÄÄÄÙ  ³                    ÀÄÄÄÄÅÄÄÄÄÙ                     ³  ÀÄÄÄÄÄ´     "
20070 PRINT "³        ³                         ³                          ³        ³     "
20075 PRINT "ÃÄÄÄÄÄÄÄÄÙ                         ³                          ÀÄÄÄÄÄÄÄÄ´     "
20080 PRINT "³                                  ³                                   ³     "
20085 PRINT "ÃÄ¿                                ³                                 ÚÄ´     "
20090 PRINT "ÀÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÙ     "
20095 RETURN
21000 CLS : PLAY "MBT180o0P2P8L8GGGL2E": FOR i = 0 TO 4000: NEXT i: PRINT "**********************"
21005 FOR i = 0 TO 8000: NEXT i: PLAY "o0P24P8L8FFFL2D "
21010 PRINT : PRINT : PRINT : PRINT : PRINT "T h E   b O s S   2"
21020 PRINT : PRINT "        v.3.2"
21030 SLEEP 3
21040 CLS
21070 TIME$ = "00:00:00"
21080 PRINT : PRINT "K‚rem ¡rj k be a szem‚lyi jelszavukat 4 mp-n bell"
21083 FOR i = 1 TO 5
21085 a$(i) = INKEY$: PRINT TAB(7); "Irjak be a jelszavukat!"; TAB(40); "ID™:"; TIME$: IF TIME$ = "00:00:04" THEN RETURN
21082 IF a$(i) = "" THEN 21085
21090 PRINT "ş";
21095 NEXT i
21100 pa$ = a$(1) + a$(2) + a$(3) + a$(4) + a$(5)
21190 IF pa$ = "load " THEN 21220 ELSE RETURN
21220 PLAY "MBT180o0P2P8L8GGGL2E"
21230 FOR i = 0 TO 4000: NEXT i: CLS
21250 IF pa$ = "load " THEN 21600
21260 RETURN
21300 CLS
21310 INPUT "Enter filename:"; n$
21315 OPEN n$ FOR OUTPUT AS #1
21317 FOR j = 1 TO 17: FOR i = 1 TO 17
21320 PRINT #1, ca(i)
21325 PRINT #1, cs$(i)
21330 PRINT #1, pl$(i, j)
21332 PRINT #1, mo(i, j)
21335 PRINT #1, ti
21340 PRINT #1, ne
21341 PRINT #1, fon
21342 PRINT #1, min
21343 PRINT #1, gun
21344 PRINT #1, fm(j)
21345 PRINT #1, mm(j)
21346 PRINT #1, gm(j)
21347 PRINT #1, te$
21357 NEXT i, j
21358 CLOSE
21359 GOTO 1150
21600 CLS
21610 INPUT "Enter filename:"; n$
21620 OPEN n$ FOR INPUT AS #1
21630 FOR j = 1 TO 17: FOR i = 1 TO 17
21640 INPUT #1, ca(i)
21650 INPUT #1, cs$(i)
21660 INPUT #1, pl$(i, j)
21665 INPUT #1, mo(i, j)
21670 INPUT #1, ti
21680 INPUT #1, ne
21681 INPUT #1, fon
21682 INPUT #1, min
21683 INPUT #1, gun
21684 INPUT #1, fm(j)
21685 INPUT #1, mm(j)
21686 INPUT #1, gm(j)
21687 INPUT #1, te$
21689 NEXT i, j
21690 CLOSE
21700 GOTO 1150

