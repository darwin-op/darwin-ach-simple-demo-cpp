default: all

CFLAGS := -I/etc/darwin-legacy/include -Wall
CC := g++

BINARIES := test
all : $(BINARIES)

LIBS := -lrt -lstdc++ -lach

$(BINARIES): src/test.o
	gcc -o $@ $< $(LIBS)

%.o: %.cpp
	$(CC) $(CFLAGS) -o $@ -c $<

clean:
	rm -f $(BINARIES) src/*.o

