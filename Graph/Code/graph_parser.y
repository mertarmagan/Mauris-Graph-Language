%token SPACE
%token ASSIGN
%token CHECKEQUAL
%token PLUS
%token RDIR
%token COLON
%token HYPHEN
%token MINUS
%token MUL
%token DIV
%token AT
%token COMMA
%token DOT
%token HASHTAG
%token ANGLEOPENING
%token ANGLECLOSING
%token NOT
%token CONCAT
%token LPARAN
%token RPARAN
%token CURLYOPENING
%token CURLYCLOSING
%token SQUAREOPENING
%token SQUARECLOSING
%token ENDSTATEMENT
%token AND
%token OR
%token DIGIT
%token LETTER
%token NEWLINE
%token NONSTAR
%token NONSTARNONDIV
%token NONNEWLINE
%token STRINGLITERAL
%token ID
%token INT
%token FLOAT
%token COMMENT
%token VERTEXSIGN
%token EDGESIGN
%token DGRAPHSIGN
%token UDGRAPHSIGN


%union 
{
  char ctf; 
  char * string;
  int integer;
}

%type <string> ID
%type <string> STRINGLITERAL
%type <integer> INT

%left PLUS MINUS 
%left STAR DIV

%{ 
    #include <iostream> 
	#include <string>
	using namespace std;
 	 // forward declarations
 	 extern int yylineno;
 	 void yyerror(string);
 	 int yylex(void);
 	 int numoferr; 
%}
 
%%
program:	graph_list

graph_list: graph graph_list
			|

graph:	ud_graph
		| d_graph
		| ID ASSIGN ID COLON CURLYOPENING conn_list CURLYCLOSING {yyerror("Check graph sign keyword!");}
		| ID ASSIGN ID CURLYOPENING conn_list CURLYCLOSING {yyerror("Missing colon in graph definition!");}

ud_graph:	ID ASSIGN UDGRAPHSIGN COLON CURLYOPENING ud_conn_list CURLYCLOSING
			| ID ASSIGN UDGRAPHSIGN COLON CURLYOPENING ud_conn_list {yyerror("Missing closing curly '}' bracket in undirected graph!");}
			| ID ASSIGN UDGRAPHSIGN COLON ud_conn_list CURLYCLOSING {yyerror("Missing opening curly '{' bracket for undirected graph!");}

d_graph:	ID ASSIGN DGRAPHSIGN COLON CURLYOPENING d_conn_list CURLYCLOSING
			| ID ASSIGN DGRAPHSIGN COLON CURLYOPENING d_conn_list {yyerror("Missing closing curly bracket for directed graph'}' ");}
			| ID ASSIGN DGRAPHSIGN COLON d_conn_list: CURLYCLOSING {yyerror("Missing opening curly bracket for directed graph'{' ");} 	

conn_list:	ud_conn_list
			| d_conn_list

ud_conn_list:	vertex HYPHEN edge HYPHEN vertex ud_conn_list_tail
				| edge {yyerror("Missing vertices");}			 			

ud_conn_list_tail:	HASHTAG ud_conn_list ud_conn_list_tail
					|

d_conn_list:	vertex HYPHEN edge RDIR vertex d_conn_list_tail
				| edge {yyerror("Missing vertices");}

d_conn_list_tail:	HASHTAG d_conn_list d_conn_list_tail
					|


vertex:		VERTEXSIGN SQUAREOPENING property SQUARECLOSING
			| VERTEXSIGN property SQUARECLOSING {yyerror("Missing opening square paranthesis in vertex");}
			| VERTEXSIGN SQUAREOPENING property {yyerror("Missing closing square paranthesis in vertex");}
			| ID SQUAREOPENING property SQUARECLOSING {yyerror("Wrong vertex sign error.");}

edge:		EDGESIGN SQUAREOPENING property SQUARECLOSING
			| EDGESIGN property SQUARECLOSING {yyerror("Missing opening square paranthesis in edge");}
			| EDGESIGN SQUAREOPENING property {yyerror("Missing closing square paranthesis in edge");}
			| ID SQUAREOPENING property SQUARECLOSING {yyerror("Wrong edge sign error.");}

property:	LPARAN STRINGLITERAL COMMA type RPARAN property_tail
			| LPARAN STRINGLITERAL type RPARAN {yyerror("Missing comma");}
			|

property_tail:	COMMA LPARAN STRINGLITERAL COMMA type RPARAN property_tail
				|

type:	primitive
		| list 
		| set
		| map

primitive:	INT
			| FLOAT
			| STRINGLITERAL	

list:	ANGLEOPENING primitive list_tail

list_tail:	COMMA primitive list_tail
			|  ANGLECLOSING

set:	CURLYOPENING primitive set_tail

set_tail:	COMMA primitive set_tail
			| CURLYCLOSING

map:	SQUAREOPENING map_body map_tail

map_body:	STRINGLITERAL COLON primitive
			| STRINGLITERAL COLON list
			| STRINGLITERAL COLON set

map_tail:	COMMA map_body map_tail
			| SQUARECLOSING



%%
// report errors
extern int yylineno;
void yyerror(string s) 
{
	numoferr++;
	cout << "error at line " << yylineno << ": " << s << endl;
}
int main()
{
	numoferr=0;
	yyparse();
	if(numoferr>0) {
		cout << "Parsing completed with " << numoferr << " errors" <<endl;
	} else {
		cout << "Parsing completed without any errors." <<endl;
	}
	return 0;
}