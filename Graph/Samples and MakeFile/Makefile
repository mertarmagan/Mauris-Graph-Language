all: lexer parser
	g++ y.tab.c lex.yy.c -o graph_parser

lexer: lexer.l
	lex lexer.l

parser: graph_parser.y
	yacc -d graph_parser.y

test1: GraphSampleProgram1.txt
	cat GraphSampleProgram1.txt | ./graph_parser
test2: GraphSampleProgram2.txt
	cat GraphSampleProgram2.txt | ./graph_parser
test3: GraphSampleProgram3.txt
	cat GraphSampleProgram3.txt | ./graph_parser
test4: GraphProgramError1.txt
	cat GraphProgramError1.txt | ./graph_parser
test5: GraphProgramError2.txt
	cat GraphProgramError2.txt | ./graph_parser
test6: GraphProgramError3.txt
	cat GraphProgramError3.txt | ./graph_parser
test7: GraphProgramError4.txt
	cat GraphProgramError4.txt | ./graph_parser
test8: GraphProgramError5.txt
	cat GraphProgramError5.txt | ./graph_parser

clean:
	-rm -f y.tab.h
	-rm -f graph_parser.c
	-rm -f y.tab.c
	-rm -f lex.yy.c
	-rm -f graph_parser
