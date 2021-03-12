# I - Le projet Snake ASM
### Snake ASM est un projet qui reprend le jeu du Snake en assembleur :

Le code est intégralement écrit dans le langage assembleur NASM. Celui est prévu pour être exécuter sur un ordinateur sous linux avec un processeur x86_64.
<hr />

# II - Pré-requis
### Afin de compiler le code, il est nécessaire d'installer le compilateur NASM :

Debian et dérivé :
```shell
$ sudo apt install nasm
```
<hr />

# III - Compiler le programme
### La compilation du programme se fait automatiquement avec le script `compile.sh` :

Exécuter le script `compile.sh` :
```shell
$ ./compile.sh
```
Un exécutable est créé sous le nom de `main`.
<hr />

# IV - Exécuter le programme
### L'exécution du programme se fait de la manière suivante :

Exécuter `main` :
```shell
$ ./main
```
A noter qu'il est possible d'exécuter le programme juste après la compilation :
```shell
$ ./compile.sh && ./main
```
