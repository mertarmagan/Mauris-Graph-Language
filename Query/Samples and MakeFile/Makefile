all: lexer parser
	g++ y.tab.c lex.yy.c -o query_parser

lexer: lexer.l
	lex lexer.l

parser: query_parser.y
	yacc -d query_parser.y

test1: QuerySampleProgram1.txt
	cat QuerySampleProgram1.txt | ./query_parser
test2: QuerySampleProgram2.txt
	cat QuerySampleProgram2.txt | ./query_parser
test3: QuerySampleProgram3.txt
	cat QuerySampleProgram3.txt | ./query_parser
test4: QuerySampleProgram4.txt
	cat QuerySampleProgram4.txt | ./query_parser
test5: QuerySampleProgram5.txt
	cat QuerySampleProgram5.txt | ./query_parser
test6: QueryProgramError1.txt
	cat QueryProgramError1.txt | ./query_parser
test7: QueryProgramError2.txt
	cat QueryProgramError2.txt | ./query_parser
test8: QueryProgramError3.txt
	cat QueryProgramError3.txt | ./query_parser
test9: QueryProgramError4.txt
	cat QueryProgramError4.txt | ./query_parser
test10:  QueryProgramError5.txt
	cat QueryProgramError5.txt | ./query_parser

clean:
	-rm -f y.tab.h
	-rm -f query_parser.c
	-rm -f y.tab.c
	-rm -f lex.yy.c
	-rm -f query_parser
