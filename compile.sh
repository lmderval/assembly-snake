src_o=""
for file in $(find -maxdepth 3 -name '*.asm')
do
    nasm -f elf64 $file
done
for file in $(find -maxdepth 3 -name '*.o')
do
    src_o="$src_o$file "
done
ld $src_o -o main
rm $src_o
