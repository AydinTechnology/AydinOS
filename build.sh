export PATH=$PATH:/Users/a9257/Documents/projects

nasm bootloader.asm -o boot.bin
nasm kernel.asm -o kernel.bin

cat boot.bin kernel.bin > OS.bin

rm boot.bin | rm kernel.bin
