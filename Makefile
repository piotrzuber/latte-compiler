## File generated by the BNF Converter (bnfc 2.9.3).

# Makefile for building the parser and test program.

GHC        = ghc
HAPPY      = happy
HAPPY_OPTS = --array --info --ghc --coerce
ALEX       = alex
ALEX_OPTS  = --ghc

# List of goals not corresponding to file names.

.PHONY : all clean distclean

# Default goal.

all : TestLatte

# Rules for building the parser.

AbsLatte.hs LexLatte.x ParLatte.y PrintLatte.hs TestLatte.hs : Latte.cf
	bnfc --haskell --functor Latte.cf

%.hs : %.y
	${HAPPY} ${HAPPY_OPTS} $<

%.hs : %.x
	${ALEX} ${ALEX_OPTS} $<

TestLatte : AbsLatte.hs LexLatte.hs ParLatte.hs PrintLatte.hs TestLatte.hs
	${GHC} ${GHC_OPTS} $@

# Rules for cleaning generated files.

clean :
	-rm -f *.hi *.o *.log *.aux *.dvi

distclean : clean
	-rm -f AbsLatte.hs AbsLatte.hs.bak ComposOp.hs ComposOp.hs.bak DocLatte.txt DocLatte.txt.bak ErrM.hs ErrM.hs.bak LayoutLatte.hs LayoutLatte.hs.bak LexLatte.x LexLatte.x.bak ParLatte.y ParLatte.y.bak PrintLatte.hs PrintLatte.hs.bak SkelLatte.hs SkelLatte.hs.bak TestLatte.hs TestLatte.hs.bak XMLLatte.hs XMLLatte.hs.bak ASTLatte.agda ASTLatte.agda.bak ParserLatte.agda ParserLatte.agda.bak IOLib.agda IOLib.agda.bak Main.agda Main.agda.bak Latte.dtd Latte.dtd.bak TestLatte LexLatte.hs ParLatte.hs ParLatte.info ParDataLatte.hs Makefile


# EOF