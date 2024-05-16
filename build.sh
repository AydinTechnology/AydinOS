export PATH=$PATH:

nasm bootloader.asm -o boot.bin
nasm kernel.asm -o kernel.bin

cat boot.bin kernel.bin > OS.bin

rm boot.bin | rm kernel.bin
