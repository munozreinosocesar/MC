%option noyywrap 

%{
#include <iostream>
#include <fstream>
#include <string.h>

using namespace std;

ifstream fichero;
ofstream fichero_salida;

int numeracion = 1;

string NextWord(const string& line, int& pos);

%}

DIGIT	[0-9]

%%

"<title>"(.|\n)*"</title>"  {
    /*
    for (int i=0; i<yyleng; ++i) {
        if (yytext[i] == '\n')
            yytext[i] = ' ';
    }

    fichero_salida << "# ";
    yyless(sizeof("<title>")-1);
    */
}

"<p"(.|\n)*"</p>"	{
    fichero_salida << "\n";

    int pos = 0;

    while (yytext[pos] != '>')
        ++pos;

    yyless(pos+1);
}

"</p>"	{
    fichero_salida << "\n";
}

"<strong>".*"</strong>"	{
    fichero_salida << "__";
    yyless(sizeof("<strong>")-1);
}

"<b>".*"</b>"   {
    fichero_salida << "__";
    yyless(sizeof("<b>")-1);
}

("</strong>"|"</b>")	{
    fichero_salida << "__";
}

"<em>".*"</em>"	{
    fichero_salida << "_";
    yyless(sizeof("<em>")-1);
}

"</em>"	{
    fichero_salida << "_";
}

(" "|\t)*"<h1".*">".*"</h1>"	{
    fichero_salida << "\n\n# ";
    int pos_final_decl = -1;

    // Detectamos final de declaración

    for (int i=0; i<yyleng && pos_final_decl < 0; ++i) {
        if (yytext[i] == '>')
            pos_final_decl = i;
    }

    for (int i=0; i<yyleng; ++i) {
	if (yytext[i] == '\n')
	    yytext[i] = ' ';
    }

    yyless(pos_final_decl+1);
}

(" "|\t)*"<h2".*">".*"</h2>"	{
    fichero_salida << "\n\n## ";
    int pos_final_decl = -1;

    // Detectamos final de declaración

    for (int i=0; i<yyleng && pos_final_decl < 0; ++i) {
        if (yytext[i] == '>')
            pos_final_decl = i;
    }

    for (int i=0; i<yyleng; ++i) {
        if (yytext[i] == '\n')
            yytext[i] = ' ';
    }

    yyless(pos_final_decl+1);
}

(" "|\t)*"<h3".*">".*"</h3>"	{
    fichero_salida << "\n\n### ";
    int pos_final_decl = -1;

    // Detectamos final de declaración

    for (int i=0; i<yyleng && pos_final_decl < 0; ++i) {
        if (yytext[i] == '>')
            pos_final_decl = i;
    }

    for (int i=0; i<yyleng; ++i) {
	if (yytext[i] == '\n')
	    yytext[i] = ' ';
    }

    yyless(pos_final_decl+1);
}

(" "|\t)*"<h4".*">".*"</h4>"	{
    fichero_salida << "\n\n#### ";
    int pos_final_decl = -1;

    // Detectamos final de declaración

    for (int i=0; i<yyleng && pos_final_decl < 0; ++i) {
        if (yytext[i] == '>')
            pos_final_decl = i;
    }

    for (int i=0; i<yyleng; ++i) {
	if (yytext[i] == '\n')
	    yytext[i] = ' ';
    }

    yyless(pos_final_decl+1);
}

(" "|\t)*"<h5".*">".*"</h5>"	{
    fichero_salida << "\n\n##### ";
    int pos_final_decl = -1;

    // Detectamos final de declaración

    for (int i=0; i<yyleng && pos_final_decl < 0; ++i) {
        if (yytext[i] == '>')
            pos_final_decl = i;
    }

    for (int i=0; i<yyleng; ++i) {
        if (yytext[i] == '\n')
            yytext[i] = ' ';
    }

    yyless(pos_final_decl+1);
}

(" "|\t)*"<h6".*">".*"</h6>"	{
    fichero_salida << "\n\n###### ";
    int pos_final_decl = -1;

    // Detectamos final de declaración

    for (int i=0; i<yyleng && pos_final_decl < 0; ++i) {
        if (yytext[i] == '>')
            pos_final_decl = i;
    }

    for (int i=0; i<yyleng; ++i) {
	if (yytext[i] == '\n')
	    yytext[i] = ' ';
    }

    yyless(pos_final_decl+1);
}

("<script"(.|\n)*"</script>")      {
    string data = yytext;
    int pos = 0;

    while (pos<yyleng) {
        if (NextWord(data, pos) == "</script>")
            yyless(pos);
    }
}

("<noscript"(.|\n)*"</noscript>")	    {
    string data = yytext;
    int pos = 0;

    while (pos<yyleng) {
        if (NextWord(data, pos) == "</noscript>")
            yyless(pos);
    }
}

"<style"(.|\n)*"</style>"    {
    string data = yytext;
    int pos = 0;

    while (pos<yyleng) {
        if (NextWord(data, pos) == "</style>")
            yyless(pos);
    }
}

"<nav "(.|\n)*"</nav>"    {
    string data = yytext;
    int pos = 0;

    while (pos<yyleng) {
        if (NextWord(data, pos) == "</nav>")
            yyless(pos);
    }
}

"<table "(.|\n)*"</table>"    {
    string data = yytext;
    int pos = 0;
    int final_pos = -1;

    while (pos<yyleng && final_pos < 0) {
        if (NextWord(data, pos) == "</table>")
            final_pos = pos;
    }

    for (int i=0; i<final_pos; ++i)
        fichero_salida << yytext[i];

    yyless(final_pos);
}

"<!--"(.|\n)*"-->"   {
    string data = yytext;
    int pos = 0;

    while (pos<yyleng) {
        if (NextWord(data, pos) == "-->")
            yyless(pos);
    }
}

"<li>"  {
    fichero_salida << "\n" << numeracion << ". ";
    ++numeracion;
}

"<ul>"|"</ul>" {
    fichero_salida << "\n";
    numeracion = 1;
}

"<a ".*">"   {
    int pos = 0;

    while (yytext[pos] != '>')
        ++pos;
    
    fichero_salida << "- ";
    yyless(pos+1);
}

"</h"{DIGIT}">"	{
    fichero_salida << "\n\n";
}

"<br>"  {
    fichero_salida << "\n";
}

"<!DOCTYPE html".*">"		        |
("<div".*">"|"</div>")              |
("<span".*">"|"</span>")            |
("<head>"|"</head>")		        |
("<header>"|"</header>")            |
"<html".*				            |
"</html>"				            |
("<body>"|"</body>")			    |
"<meta".*">"				        |
"<link".*">"				        |
"</a>"                              |
"</li>"                             |
\n                                  |
^(\t|" ")+                          |
" "*"<aside>"|"</aside>"            |
"<input ".*">".*                    |
"<hr>"\n                              

%%
int main(int argc, char **argv) {
    if (argc != 3) {
        cerr << "Syntax: " << argv[0] << " <fich_html> <output_md>.\n";
        exit(1);
    }
    
    fichero.open(argv[1]);
    fichero_salida.open(argv[2]);

    if (!fichero) {
        cerr << "Non-valid file name.\n";
        exit(2);
    }

    if (!fichero_salida) {
        cerr << "Non-valid output.\n";
        exit(2);
    }

    yyFlexLexer flujo(&fichero, &fichero_salida);
    flujo.yylex();

    fichero.close();
    fichero_salida.close();
    
    return 0;
}

string NextWord(const string& line, int& pos) {
    string word;
    bool fin = false;

    while (pos < line.size() && !fin) {
    	if (line[pos] != ' ' && line[pos] != '\n' && line[pos] != '\t') {
    	    word += line[pos];
    	    ++pos;
    	} else {
            ++pos;
    	    fin = true;
    	}
    }

    return word;
}