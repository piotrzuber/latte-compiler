# Makefile for building the compiler.

GHC        = ghc
SOURCE     = src

# List of goals not corresponding to file names.

.PHONY : all clean distclean

# Default goal.

all : latc

# Rules

latc : 
	cd ${SOURCE} && ${GHC} ${GHC_OPTS} Main -o ../latc && cd ..

tests:
	./test_bad.sh; ./test_good.sh

# Rules for cleaning generated files.

clean :
	rm -f latc

testclean:
	rm -f tests_bad.out tests_good.out tests.bad lattests/good/core*.s

distclean : clean
	rm -f AbsLatte.hs AbsLatte.hs.bak ComposOp.hs ComposOp.hs.bak DocLatte.txt DocLatte.txt.bak ErrM.hs ErrM.hs.bak LayoutLatte.hs LayoutLatte.hs.bak LexLatte.x LexLatte.x.bak ParLatte.y ParLatte.y.bak PrintLatte.hs PrintLatte.hs.bak SkelLatte.hs SkelLatte.hs.bak TestLatte.hs TestLatte.hs.bak XMLLatte.hs XMLLatte.hs.bak ASTLatte.agda ASTLatte.agda.bak ParserLatte.agda ParserLatte.agda.bak IOLib.agda IOLib.agda.bak Main.agda Main.agda.bak Latte.dtd Latte.dtd.bak TestLatte LexLatte.hs ParLatte.hs ParLatte.info ParDataLatte.hs Makefile


# EOF
