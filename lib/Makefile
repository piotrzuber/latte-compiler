all: runtime

runtime:
	gcc -m32 -fno-stack-protector -std=c89 -o runtime.s -S runtime.c && gcc -c -m32 runtime.s -o runtime.o

clean:
	rm -rf runtime.o