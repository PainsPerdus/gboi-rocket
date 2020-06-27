#include <stdio.h>
#include <stdlib.h>

void createWay(unsigned char c);
unsigned char aleatNumber();
unsigned char unvisitedNeighbours(unsigned char k);
unsigned char * neighbours(unsigned char k);
void display();
void binaryDisplay(unsigned char n);
unsigned char anyNeighbours(unsigned char k);

unsigned char x=0;
unsigned char y=0;
unsigned char z=0;
unsigned char a=1;
unsigned char level = 7;
unsigned char height;
unsigned char width;
unsigned char * map;
unsigned char current;
unsigned char temp[4];
unsigned char start;
unsigned char boss;
unsigned char item;

int main(int argc, char const *argv[]) {
  //printf("level : %d\n",level);
  level=level+6;
  height= level/2;
  width = level - height;
  //printf("height : %d, width : %d\n", height, width);
  map = (unsigned char *) malloc (height * width);
  for (int i = 0; i < height*width; i++){
    map[i] = 0b00000000;
  }

  //Salle de depart
  unsigned char i;
  unsigned char j;
  if (width%2 != 0){
    i = width/2 + 1;
  }
  else {
    unsigned char b = aleatNumber() % 2;
    i = width / 2 + b;
  }
  if (height % 2 != 0){
    j = height/2 + 1;
  }
  else {
    unsigned char b = aleatNumber() % 2;
    j = height / 2 + b;
  }
  i--;
  j--;
  start = j * width + i;
  map[start] = 0b00001100;
  //display();

  //Boss's room with a Way of a length between width/3 and height

  unsigned char diff = height - width/3 ;
  unsigned char c = aleatNumber() % (diff + 1) ;
  c = c + 1 + width/3;

  createWay(c);

  map[current] = map[current] & 0b11111000;
  map[current] = map[current] | 0b00000010;
  //display();

  for (int i = 0; i < height*width; i++){
    map[i] = map[i] & 0b11110111;
  }

  //Item's room with way of a length between width/6 and height/2
  a=a-2;
  x=x+2;
  y=y*2;
  z=z-3;
  diff = height/2 - width/6 ;
  c = aleatNumber() % (diff + 1) ;
  c = c + width/6;

  createWay(c);

  map[current] = map[current] & 0b11111000;
  map[current] = map[current] | 0b00000001;
  //display();

  for (int i = 0; i < height*width; i++){
    map[i] = map[i] & 0b11110111;
  }

  //Dead ends between height/2 and max 3*height/4
  //First
  a=a*2;
  x=x-2;
  y=y*3;
  z=z-2;
  diff = 3*height/4 - height/2 ;
  c = aleatNumber() % (diff + 1) ;
  c = c + height/2;

  createWay(c);
  //display();


  //Second
  a=a-1;
  x=x+1;
  y=y*3;
  z=z-2;
  diff = height/2 - width/6 ;
  c = aleatNumber() % (diff + 1) ;
  c = c + width/6;

  createWay(c);
  //display();

  //Up | Down | Left | Right | Visited | Cat | Cat | Cat
  //000 : normal
  //001 : item
  //010 : boss
  //100 : start
  return 0;
}

unsigned char * neighbours(unsigned char k){
  temp[0] = k - width;
  temp[1] = k - 1;
  temp[2] = k + 1;
  temp[3] = k + width;
  return temp;
}


unsigned char unvisitedNeighbours(unsigned char k){
  unsigned char * possibleNeighbours;
  possibleNeighbours = neighbours(k);
  int compteur = 0;
  unsigned char neighbour;
  char bool[4];
  //for(int i = 0; i < 4; i++){
  neighbour = possibleNeighbours[0];
  if (!(map[neighbour] & (1u << 3))){
    if (k < width){
      bool[0] = 0;
    } else{
      bool[0] = 1;
      compteur++;
    }
  }
  neighbour = possibleNeighbours[1];
  if (!(map[neighbour] & (1u << 3))){
    if (k % width == 0){
      bool[1] = 0;
    } else{
      bool[1] = 1;
      compteur++;
    }
  }
  neighbour = possibleNeighbours[2];
  if (!(map[neighbour] & (1u << 3))){
    if (k % width == width - 1){
      bool[2] = 0;
    } else{
      bool[2] = 1;
      compteur++;
    }
  }
  neighbour = possibleNeighbours[3];
  if (!(map[neighbour] & (1u << 3))){
    if (k >= (height - 1) * width){
      bool[3] = 0;
    } else{
      bool[3] = 1;
      compteur++;
    }
  }
  char alea = aleatNumber() % compteur;
  int i = 0;
  char chose;
  while(alea >= 0){
    if (bool[i] == 1){
      chose = possibleNeighbours[i];
      alea--;
    }
    i++;
  }
  return chose;
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
  //printf("%hhu\n", a%4);
  return a;
}

void createWay(unsigned char c){
  current = start;
  while (c > 0){
    unsigned char next = unvisitedNeighbours(current);
    c--;
    map[next] = map[next] | 0b00001000;
    if (next == current + 1){
      map[current] = map[current] | 0b00010000;
      map[next] = map[next] | 0b00100000;
    } else{
      if (next == current - 1){
        map[current] = map[current] | 0b00100000;
        map[next] = map[next] | 0b00010000;
      } else{
        if (next == current - width){
          map[current] = map[current] | 0b10000000;
          map[next] = map[next] | 0b01000000;
        } else{
          if(next == current + width){
            map[current] = map[current] | 0b01000000;
            map[next] = map[next] | 0b10000000;
          } else{
            printf("Probleme dans le switch case !\n");
          }
        }
      }
    }
    current = next;
    //printf("%d\n", next);
  }
}

void display(){
  for (int k = 0 ; k < height ; k++){
    for (int l = 0 ; l < width ; l++){
      binaryDisplay(map[k * width + l]);
      printf("    ");
    }
    printf("\n");
  }
  printf("\n");
}

void binaryDisplay(unsigned char n) {
  int i = 7;
  while (i >= 0){
    printf("%d", (n >> i ) & 1);
    i--;
  }
}
