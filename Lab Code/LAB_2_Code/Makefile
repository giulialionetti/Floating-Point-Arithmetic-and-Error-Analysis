.SUFFIXES: _cad _cad.o

CXX=g++

CADNAC=$(HOME)/cadna_c-3.1.11

CFLAGS= -g -O3  -m64 -frounding-math 

CXXFLAGS=  $(CFLAGS)
CPPFLAGS= -I$(CADNAC)/include 

LDFLAGS=   -m64  -frounding-math 
LDLIBS= -lstdc++ -lm
CADNALDFLAGS=-L$(CADNAC)/lib -lcadnaCdebug

EXAMPLES= \
rump rumpd rump_cad rumpd_cad \
hilbert hilbert_cad \
muller muller_cad \
newton newton_cad \
gauss gauss_cad \
jacobi jacobi_cad jacobi1_cad \
logistic logistic_cad

all : $(EXAMPLES)

################################
rump : rump.o

rump_cad : rump_cad.o 
	$(CXX) $< -o $@ $(CADNALDFLAGS) $(LDFLAGS)

################################
rumpd : rumpd.o

rumpd_cad : rumpd_cad.o 
	$(CXX) $< -o $@ $(CADNALDFLAGS) $(LDFLAGS)

################################
hilbert : hilbert.o

hilbert_cad : hilbert_cad.o 
	$(CXX) $< -o $@ $(CADNALDFLAGS) $(LDFLAGS)

################################
muller : muller.o

muller_cad : muller_cad.o 
	$(CXX) $< -o $@ $(CADNALDFLAGS) $(LDFLAGS)

################################
newton : newton.o

newton_cad : newton_cad.o 
	$(CXX) $< -o $@ $(CADNALDFLAGS) $(LDFLAGS)

################################
gauss : gauss.o
	$(CXX) $< -o $@ $(LDFLAGS)

gauss_cad : gauss_cad.o  
	$(CXX) $< -o $@ $(CADNALDFLAGS) $(LDFLAGS)
################################
jacobi : jacobi.o

jacobi_cad : jacobi_cad.o 
	$(CXX) $< -o $@ $(CADNALDFLAGS) $(LDFLAGS)

jacobi1_cad : jacobi1_cad.o 
	$(CXX) $< -o $@ $(CADNALDFLAGS) $(LDFLAGS)
################################
logistic : logistic.o

logistic_cad : logistic_cad.o 
	$(CXX) $< -o $@ $(CADNALDFLAGS) $(LDFLAGS)
################################

clean :
	rm -fr *.o $(EXAMPLES)

