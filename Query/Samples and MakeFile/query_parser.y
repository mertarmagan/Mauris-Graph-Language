%token SPACE
%token ASSIGN
%token CHECKEQUAL
%token PLUS
%token COLON
%token MINUS
%token MUL
%token DIV
%token AT
%token COMMA
%token DOT
%token ANGLEOPENING
%token ANGLECLOSING
%token SQUAREOPENING
%token SQUARECLOSING
%token CURLYOPENING
%token CURLYCLOSING
%token NOT
%token CONCAT
%token LPARAN
%token RPARAN
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
%token QSIGN
%token QMARK
%token REGEX
%token EXIST
%token SAME
%token BOOL
%token ALTER

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
program: query_list

query_list: query query_list
			| arithmetic query_list
			|

query:	ID ASSIGN QSIGN COLON qtype AT ID
		| ID ASSIGN QSIGN COLON qtype AT {yyerror("You have to specify the graph name after '@'.");}
		| ID ASSIGN QSIGN COLON qtype ID {yyerror("Missing '@' sign before graph name.");}

qtype:	REGEX QMARK regular_expression
		| EXIST QMARK exist_expression
		| BOOL QMARK boolean_expression
		| SAME QMARK same_expression
		| REGEX QMARK boolean_expression {yyerror("Regular expression is expected for 'REGEX' attribute.");}	

same_expression:	STRINGLITERAL
					| ID {yyerror("String literal is expected for 'SAME' attribute.");}

boolean_expression:	LPARAN ID CHECKEQUAL primitive RPARAN boolean_expression_tail
					| LPARAN NOT ID RPARAN boolean_expression_tail
					| LPARAN ID AND ID RPARAN boolean_expression_tail
					| LPARAN ID OR ID RPARAN boolean_expression_tail
					| LPARAN EDGESIGN COMMA INT COMMA property RPARAN boolean_expression_tail
					| LPARAN VERTEXSIGN COMMA INT COMMA property RPARAN boolean_expression_tail
					| ID CHECKEQUAL primitive RPARAN boolean_expression_tail {yyerror("Missing left paranthesis '('.");}

boolean_expression_tail:	AND boolean_expression boolean_expression_tail
							| OR boolean_expression boolean_expression_tail
							|

exist_expression:	arithmetic
					| property
					| function
					| type

arithmetic:	INT arithmetic_tail
			| arithmetic arithmetic_tail

arithmetic_tail:	op INT arithmetic_tail
					| op arithmetic_tail
					| INT arithmetic_tail
					|

op: PLUS
	| MINUS
	| MUL
	| DIV

function:	ID LPARAN function_tail 

function_tail:	primitive function_tail
				| COMMA primitive function_tail
				| RPARAN
				| 	

regular_expression:	ID CONCAT ID regular_expression_tail 
					| ID ALTER ID regular_expression_tail
					| ID MUL regular_expression_tail
					| ID PLUS regular_expression_tail
					| LPARAN regular_expression RPARAN

regular_expression_tail:	regular_expression regular_expression_tail
							| CONCAT ID regular_expression_tail
							| ALTER ID regular_expression_tail
							| 


property:	LPARAN STRINGLITERAL COMMA type RPARAN
			| LPARAN STRINGLITERAL type RPARAN {yyerror("Missing comma ',' in property type.");}
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