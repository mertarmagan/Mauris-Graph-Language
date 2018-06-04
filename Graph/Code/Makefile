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
test4: SampleProgramError1.txt
	cat SampleProgramError1.txt | ./graph_parser
test5: SampleProgramError2.txt
	cat SampleProgramError2.txt | ./graph_parser
test6: SampleProgramError3.txt
	cat SampleProgramError3.txt | ./graph_parser
test7: SampleProgramError4.txt
	cat SampleProgramError4.txt | ./graph_parser
test8: SampleProgramError5.txt
	cat SampleProgramError5.txt | ./graph_parser

clean:
	-rm -f y.tab.h
	-rm -f graph_parser.c
	-rm -f y.tab.c
	-rm -f lex.yy.c
	-rm -f graph_parser
