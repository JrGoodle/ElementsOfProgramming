# eop Makefile

CC       = g++
DEBUG    = -O0 -ggdb -pg
//CFLAGS   = -Wall 
CFLAGS   =
CXXFLAGS = $(CFLAGS)
LDFLAGS	 = -g


TARGETS=eop
INCLUDES=eop.h assertions.h integers.h pointers.h type_functions.h drivers.h intrinsics.h print.h tests.h measurements.h read.h

all:$(TARGETS)

eop: eop.o
	$(CC) $(LDFLAGS) $^ -o $@ 

eop.o: eop.cpp $(INCLUDES)
	$(CC) $(CXXFLAGS) -c $< -o $@

.PHONY: clean 

clean :
	rm -rf eop
	rm -rf *.o

archive :
	zip -u -v eop-code.zip Makefile eop.cpp $(INCLUDES)


