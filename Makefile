LIBS=-lpcre -lcrypto -lm -lpthread
CFLAGS=-L/usr/local/opt/openssl/lib -L/usr/local/lib -I/usr/local/opt/openssl/include -I/usr/local/include -ggdb -O3 -Wall
OBJS=vangen.o oclvanitygen.o oclvanityminer.o oclengine.o keyconv.o pattern.o util.o
PROGS=vangen keyconv oclvanitygen oclvanityminer
CXX=g++
PLATFORM=$(shell uname -s)
ifeq ($(PLATFORM),Darwin)
OPENCL_LIBS=-framework OpenCL
else
OPENCL_LIBS=-lOpenCL
endif


most: vangen keyconv

all: $(PROGS)

vangen: vangen.o pattern.o util.o
	$(CXX) $^ -o $@ $(CFLAGS) $(LIBS)


vangenocl: oclvanitygen.o oclengine.o pattern.o util.o
	$(CXX) $^ -o $@ $(CFLAGS) $(LIBS) $(OPENCL_LIBS)

oclvanityminer: oclvanityminer.o oclengine.o pattern.o util.o
	$(CXX) $^ -o $@ $(CFLAGS) $(LIBS) $(OPENCL_LIBS) -lcurl

keyconv: keyconv.o util.o
	$(CXX) $^ -o $@ $(CFLAGS) $(LIBS)

clean:
	rm -f $(OBJS) $(PROGS) $(TESTS)
