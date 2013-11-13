/* 
############################################
# latin -> tengwar transscriber 0.8        #
############################################
# by Pécsi Sándor (xea@gentoo.hu)					 #
############################################

Megjegyzes:
 + A programban meg eleg sok helyen maradhatott hiba, amit nem vettem eszre, mind nyelvtani reszben, mind a kodban,
   ha rabukkansz valahol ilyenre, kerlek jelezd a fenti email cimre
 + A program a Tengwar Annatar betutipushoz ad kimenetet, nem a Dan Smith fele Tengwar Quenyahoz, de nagyjabol
 	 kompatibilis a ketto (meg ha nem is teljesen)

TODO:
 + Meg egy nagy halom betu beirasa (ritkabban hasznaltak)
 + Szamok tamogatasa
 + Tamogatas tobbfele beviteli mod (Sindarin, Quenya, Sotet nyelv, Angol, Magyar, stb)
 + Certhek tamogatasa
 + S-kampok tamogatasa

Changelog:

0.8
 + Hosszu betuk tamogatasa
 + Betut koveto 'y' keresese
0.7
 + Irasjelek tamogatasa
 + Tobbkarakteres betuk tamogatasa
0.6
 + Karakterosztalyok bevezetese
 * Megkulonboztetes maganhangzo-massalhangzo szerint
0.5
 + Egyszerusitett felulet a karakterkeresesre (bar meg igy is kicsit bonyolult)
0.4
 + Tobb szavas szovegek tamogatasa
0.3
 + Megelozo nazalis hangok (n, m) figyelese
0.2
 + Egy rakas betu tamogatasa hozzaadva
0.1
 + Elkeszult a program rendkivul egyszeru vaza, par betu tamogatasaval
*/

#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <stdlib.h>

void msh(char *orig, int *op, char *search, char *trans, int *tp, char * cl, int class, char *fmt, ...); 
char chk(char *orig, int *op, char *search, char *trans, int *tp); 
void mgh(char *str, int * ptr, char *class, int hossz, int a1, int a2, int a3, int a4);
char milyen(char betu);

int main(int argc, char ** argv)
{
	char *h; 		// ez az eredeti latin betus szoveg
	char *q; 		// ebbe irjuk bele a tengwar szoveget
	char pre, act, post, after, class;		// az eppen figyelt karakterek es a karakterforma osztalya
	int i, j, hossz = 0;
	class = pre = act = post = 0;
	j = 0;
	// az osszes argumentum felfuzese egyetlen stringbe
	for (i = (strcmp(argv[1], "-v") == 0)?2:1; i < argc; i++)
	{
		hossz += strlen(argv[i]);
		hossz = (i > 1)?(hossz+1):(hossz);
	}
	h = (char *) calloc(hossz, sizeof(char));
	for (i = (strcmp(argv[1], "-v") == 0)?2:1; i < argc; i++)
	{
		h = (i > 1)?(strcat(h, " ")):(h);
		h = strcat(h, argv[i]);
	}
	// memoriafoglalas az uj szovegnek
	q = (char *) calloc(hossz * 2, sizeof(char));
	// latin szoveg ellenorzese karakterenkent
	for (i = 0; i < strlen(h); i++)
	{
		// a figyelo valtozok feltoltese
		if (i > 0)
			pre = h[i - 1];
		if (i < (hossz - 2))
		{
			post = h[i + 1];
			after = h[i + 2];
		}
		else if (i < (hossz - 1))
		{
			post = h[i + 1];
			after = 0;
		}
		else 
		{
			post = 0;
			after = 0;
		}
		act = h[i];
		
		//printf ("--[h]: %d  [i]: %d [ac]: %c [po]: %c [af]: %c [j]: %d \n", hossz, i, act, post, after, j); // debug
		
		// kulonbozo karakterek es kapcsolatok keresese, kulon fuggveny a maganhangzoknak, kulon a massalhangzoknak
		if (chk(h, &i, " ", q, &j) == 1) { q[j] = 32; j++; class = 0; }
		else if (chk(h, &i, ",", q, &j) == 1) { q[j] = 61; j++; class = 0; }
		else if (chk(h, &i, ".", q, &j) == 1) { q[j] = 45; j++; class = 0; }
		else if (chk(h, &i, "!", q, &j) == 1) { q[j] = 193; j++; class = 0; }
		else if (chk(h, &i, "?", q, &j) == 1) { q[j] = 192; j++; class = 0; }
		else if (chk(h, &i, "(", q, &j) == 1) { q[j] = 155; j++; class = 0; }
		else if (chk(h, &i, ")", q, &j) == 1) { q[j] = 155; j++; class = 0; }
		else if (chk(h, &i, "c", q, &j) == 1) { msh(h, &i, "c", q, &j, &class, 2, "%d", 97); }
		else if (chk(h, &i, "k", q, &j) == 1) { msh(h, &i, "k", q, &j, &class, 2, "%d", 122); }
		else if (chk(h, &i, "th", q, &j) == 1) { msh(h, &i, "th", q, &j, &class, 3, "%d", 51); i++;}
		else if (chk(h, &i, "hw", q, &j) == 1) { msh(h, &i, "hw", q, &j, &class, 2, "%d", 99); i++;}
		else if (chk(h, &i, "h", q, &j) == 1) { msh(h, &i, "h", q, &j, &class, 3, "%d", 57); }
		else if (chk(h, &i, "t", q, &j) == 1) { msh(h, &i, "t", q, &j, &class, 2, "%d", 49); }
		else if (chk(h, &i, "mb", q, &j) == 1) { msh(h, &i, "mb", q, &j, &class, 1, "%d %d", 119, 80); }
		else if (chk(h, &i, "b", q, &j) == 1) { msh(h, &i, "b", q, &j, &class, 1, "%d", 119); }
		else if (chk(h, &i, "j", q, &j) == 1) { msh(h, &i, "j", q, &j, &class, 2, "%d", 104); }
		else if (chk(h, &i, "ngw", q, &j) == 1) { msh(h, &i, "ngw", q, &j, &class, 1, "%d %d", 120, 80); }
		else if (chk(h, &i, "ng", q, &j) == 1) { msh(h, &i, "ng", q, &j, &class, 1, "%d", 115); i++;}
		else if (chk(h, &i, "g", q, &j) == 1) { msh(h, &i, "g", q, &j, &class, 1, "%d", 120); }
		else if (chk(h, &i, "sh", q, &j) == 1) { msh(h, &i, "sh", q, &j, &class, 2, "%d", 65); i++;}
		else if (chk(h, &i, "f", q, &j) == 1) { msh(h, &i, "f", q, &j, &class, 3, "%d", 101);}
		else if (chk(h, &i, "hw", q, &j) == 1) { msh(h, &i, "hw", q, &j, &class, 2, "%d", 99); i++;}
		else if (chk(h, &i, "nt", q, &j) == 1) { msh(h, &i, "nt", q, &j, &class, 1, "%d", 52); i++;}
		else if (chk(h, &i, "nc", q, &j) == 1) { msh(h, &i, "nc", q, &j, &class, 1, "%d", 102); }
		else if (chk(h, &i, "nd", q, &j) == 1) { msh(h, &i, "nd", q, &j, &class, 1, "%d %d", 50, 80); }
		else if (chk(h, &i, "n", q, &j) == 1) { msh(h, &i, "n", q, &j, &class, 1, "%d", 53);}
		else if (chk(h, &i, "v", q, &j) == 1) { msh(h, &i, "v", q, &j, &class, 2, "%d", 121);}
		else if (chk(h, &i, "d", q, &j) == 1) { msh(h, &i, "d", q, &j, &class, 1, "%d", 50); }
		else if (chk(h, &i, "mp", q, &j) == 1) { msh(h, &i, "mp", q, &j, &class, 1, "%d %d", 114, 80); }
		else if (chk(h, &i, "p", q, &j) == 1) { msh(h, &i, "p", q, &j, &class, 2, "%d", 113); }
		else if (chk(h, &i, "m", q, &j) == 1) { msh(h, &i, "m", q, &j, &class, 1, "%d", 116);}
		else if (chk(h, &i, "rd", q, &j) == 1) { msh(h, &i, "rd", q, &j, &class, 2, "%d", 117); i++;}
		else if (chk(h, &i, "ld", q, &j) == 1) { msh(h, &i, "ld", q, &j, &class, 1, "%d", 109); i++;}
		else if (chk(h, &i, "s", q, &j) == 1) { msh(h, &i, "s", q, &j, &class, 2, "%d", 105); }
		else if (chk(h, &i, "z", q, &j) == 1) { msh(h, &i, "z", q, &j, &class, 2, "%d", 44); }
		else if ((chk(h, &i, "r", q, &j) == 1) && (milyen(post) == 1)) { msh(h, &i, "r", q, &j, &class, 2, "%d", 55);}
		else if ((chk(h, &i, "r", q, &j) == 1) && (milyen(post) == 0)) { msh(h, &i, "r", q, &j, &class, 2, "%d", 54);}
		else if (chk(h, &i, "ll", q, &j) == 1) { msh(h, &i, "ll", q, &j, &class, 1, "%d %d", 106, 176); }
		else if (chk(h, &i, "l", q, &j) == 1) { msh(h, &i, "l", q, &j, &class, 1, "%d", 106);}
		else if (chk(h, &i, "y", q, &j) == 1) { mgh(q, &j, &class, 1, 204, 205, 206, 207); }
		else if (chk(h, &i, "a", q, &j) == 1) { mgh(q, &j, &class, 1, 35, 69, 68, 67); }
		else if (chk(h, &i, "á", q, &j) == 1) { mgh(q, &j, &class, 2, 35, 69, 68, 67); }
		else if (chk(h, &i, "e", q, &j) == 1) { mgh(q, &j, &class, 1, 36, 82, 70, 86); }
		else if (chk(h, &i, "é", q, &j) == 1) { mgh(q, &j, &class, 2, 36, 82, 70, 86); }
		else if (chk(h, &i, "i", q, &j) == 1) { mgh(q, &j, &class, 1, 37, 84, 71, 66); }
		else if (chk(h, &i, "í", q, &j) == 1) { mgh(q, &j, &class, 2, 37, 84, 71, 66); }
		else if (chk(h, &i, "o", q, &j) == 1) { mgh(q, &j, &class, 1, 94, 89, 72, 78); }
		else if (chk(h, &i, "ó", q, &j) == 1) { mgh(q, &j, &class, 2, 94, 89, 72, 78); }
		else if (chk(h, &i, "u", q, &j) == 1) { mgh(q, &j, &class, 1, 38, 85, 74, 77); }
		else if (chk(h, &i, "ú", q, &j) == 1) { mgh(q, &j, &class, 2, 38, 85, 74, 77); }
		else q[j] = 32;
	}
	// hosszu szoveg, ha a -v parameterrel inditottunk
	if (strcmp(argv[1], "-v") == 0) 
	{
		printf("Eredeti szoveg: %s\n", h);
		printf("Eredeti szoveg hossza: %d\n", hossz);
		printf("Tengwar Annatar text: ");
	}
	printf("%s\n", q);
	if (strcmp(argv[1], "-v") == 0) printf("\n");
	free(h);
	free(q);
	return 1;
}

char chk(char *orig, int *op, char *search, char *trans, int *tp)
{
	// a fuggveny ellenorzi hogy a keresett betu egyezik-e az eppen vizsgalttal
	char stimmel = 1;
	int i = 0;
	stimmel = 1;
	for (i = (*op); i < ((*op) + strlen(search)); i++)
	{
		if (orig[i] != search[i - (*op)])
		{
			stimmel = 0;
		}
	}
	return stimmel;
}

char milyen(char betu)
{
	// ellenorzes, hogy az aktualis betunk maganhangzo-e
	int mi = -1;
	switch(betu)
	{
		case 'a':
		case 'á':
		case 'e':
		case 'é':
		case 'i':
		case 'í':
		case 'o':
		case 'ó':
		case 'ö':
		case 'u':
		case 'ú':
		case 'ü':
			mi = 1;
			break;
		default:
			mi = 0;
			break;
	}
	return mi;
}

void msh(char *orig, int *op, char *search, char *trans, int *tp, char * cl, int class, char *fmt, ...)
{
	 va_list ap;
	 char *p;
	 int ival;
	 int c = 0;
	 int k;
	 int stimmel = 0;
	 // dupla hangzo ellenorzes
	 if (*op >= strlen(search))
	 {
		 for (k = 0; k < strlen(search); k++)
		 {
				if (orig[*op - (strlen(search) - k)] == search[k])
				{
					stimmel++;
				}
		 }
		 if (stimmel == 0)
		 {
				//printf("nem dupla\n"); 
		 }
		 else if (stimmel == strlen(search))
		 {
			  // mi tortenik, ha valoban hosszu betu
				if (class == 1)
				{
					trans[*tp] = 58;
					(*tp)++;
				}
				else if (class == 2)
				{
					trans[*tp] = 59;
					(*tp)++;
				}
				else if (class == 3)
				{
					trans[*tp] = 58;
					(*tp)++;
				}
		 }
	 }
	 if (stimmel == 0)
	 {
	 va_start(ap, fmt);
	 for (p = fmt; *p; p++)
		 {
			 if (*p != '%') { ; }
			 else
			 {
				 ival = va_arg(ap, int);
				 trans[(*tp)] = ival;
				// printf("beirtam a %d helyre a %d karaktert\n", *tp, ival);
				 (*tp)++;
				 c++;
			 }
		 }
	 (*op) += c - 1;
	 *cl = class;
	 va_end(ap);
	 }
	 // ellenorzes, hogy y koveti-e a betunket
	 if (orig[*op] == 'y')
	 {
		 if (class == 1) { trans[*tp] = 204; (*tp)++; }
		 else if (class == 2) { trans[*tp] = 205; (*tp)++; }
		 else if (class == 3) { trans[*tp] = 206; (*tp)++; }
		 else if (class == 4) { trans[*tp] = 207; (*tp)++; }
	 }
}

void mgh(char *str, int * ptr, char *class, int hossz, int a1, int a2, int a3, int a4)
{
	if (*class == 0)
	{
		str[*ptr] = (hossz == 1)?96:126;
		(*ptr)++;
		*class = 5;
	}
	if (*class == 1)
	{
		if (hossz != 1)
		{
			str[*ptr] = 126;
			(*ptr)++;
			str[*ptr] = a4;
			(*ptr)++;
		}
		else
		{
			str[*ptr] = a1;
			(*ptr)++;
		}
	}
	else if (*class == 2)
	{
		if (hossz != 1) 
		{
			str[*ptr] = 126;
			(*ptr)++;
			str[*ptr] = a4;
			(*ptr)++;

		}
		else
		{
			str[*ptr] = a2;
			(*ptr)++;
		}
	}
	else if ((*class == 3) || (*class == 4))
	{
		if (hossz != 1) 
		{
			str[*ptr] = 126;
			(*ptr)++;
			str[*ptr] = a4;
			(*ptr)++;
		}
		else
		{
			str[*ptr] = a3;
			(*ptr)++;
		}
	}
	else if (*class == 5)
	{
		if (hossz != 1) 
		{
			str[*ptr] = 126;
			(*ptr)++;
		}
		str[*ptr] = a4;
		(*ptr)++;
	}
	if (a1 != 204) *class = 0;
	
}
