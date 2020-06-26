#include <stdio.h>
#include <stdlib.h>

unsigned char aleatNumber();
unsigned char * unvisitedNeighbours1(unsigned char k);
unsigned char * unvisitedNeighbours2(unsigned char k);
unsigned char * neighbours(unsigned char k);
void display();

unsigned char x=0;
unsigned char y=0;
unsigned char z=0;
unsigned char a=1;
unsigned char level = 4;
unsigned char hauteur;
unsigned char largeur;
unsigned char * map;
unsigned char current;

int main(int argc, char const *argv[]) {
  printf("level : %d\n",level);
  level=level+6;
  hauteur= level/2;
  largeur = level - hauteur;
  printf("hauteur : %d, largeur : %d\n", hauteur, largeur);
  map = (char *) malloc (hauteur * largeur);
  for (int i = 0; i < hauteur*largeur; i++){
    map[i] = 0b00000000;
  }

  //Salle de depart
  unsigned char i;
  unsigned char j;
  if (largeur%2 != 0){
    i = largeur/2 + 1;
  }
  else {
    unsigned char b = aleatNumber() % 2;
    i = largeur / 2 + b;
  }
  if (hauteur % 2 != 0){
    j = hauteur/2 + 1;
  }
  else {
    unsigned char b = aleatNumber() % 2;
    j = hauteur / 2 + b;
  }
  i--;
  j--;
  map[j * largeur + i] = 0b00001001;
  display();

  //Salle de boss
  unsigned char diff = hauteur - largeur/3 ;
  unsigned char c = aleatNumber() % (diff + 1) ;
  c = c + m/3;
  //char * temp;
  //char currentX = i;
  /*whar currentY = j;
  while (c > 0){
    //temp = unvisitedNeighbours(map, currentX, currentY, m, n);
    c--;
  }*/
  //Chemin de longueur commprise entre min m/3 et max n

//item same/2

//cul de sac
//min n/2
//max 3n/4

  //Salle d'item

  int k = 0;

  /*for (int k = 0; k < 10; k++){

    aleatNumber(a,x,y,z);
  }*/


  //Up | Down | Left | Right | Visited | Visited2 | Cat | Cat
  //00 : normal
  //01 : depart
  //10 : item
  //11 : boss*/
  return 0;
}

unsigned char * neighbours(unsigned char k){
  char[4] temp;
  temp[0] = k - largeur;
  tamp[1] = k - 1;
  temp[2] = k + 1;
  temp[3] = k + largeur;
  return temp;
}


unsigned char * unvisitedNeighbours1(unsigned char k){

}

unsigned char aleatNumber(){
  y=y*2;
  x=x-1;
  z=z+6;
  a++;
  for(unsigned long i = 0 ; i < 14 ; i++) {
    unsigned char t = x ^ (x << 4);
    x=y;
    y=z;
    z=a;
    a = z ^ t ^ ( z >> 1) ^ (t << 1);
  }
  printf("%hhu\n", a%4);
  return a;
}

void display(){
  for (int k = 0 ; k < hauteur ; k++){
    for (int l = 0 ; l < largeur ; l++){
      printf("%d   ", map[k * largeur + l]);
    }
    printf("\n");
  }
  printf("\n");
}
