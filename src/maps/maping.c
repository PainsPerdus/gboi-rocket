#include <stdio.h>
#include <stdlib.h>
#include <time.h>

void createWay(unsigned char c);//create a way between the start and a specific room, opening doors
void randomNumber();//give an random number
unsigned char unvisitedNeighbour(unsigned char k);//give a random neighbour in the unvisited accessible rooms
unsigned char * neighbours(unsigned char k);//give the subscripts of theoric accesible rooms for a given subscript
void display();//display the map in the terminal
void binaryDisplay(unsigned char n);//show a char in its binaty form
void addRoomsToList();
void displayList();

unsigned char x=0;
unsigned char y=0;
unsigned char z=0;
unsigned char a=1;
unsigned char level = 1;//level of the stage to generate
unsigned char height;//height of the arrayof rooms
unsigned char width;//width of the array of rooms
unsigned char * map;//array of rooms
unsigned char * list;//opened rooms' list
unsigned char current;//current room in the algo
unsigned char temp[4];//subscript of theoric accessible rooms for a specifi room
unsigned char start;//subscript of start room
unsigned char boss;//subscript of boss's room
unsigned char item;//subscript of item's room
unsigned char basicNumber = 8; //numer² of basic rooms
unsigned char itemNumber = 1; //number of item's rooms
unsigned char bossNumber = 1; //number of boss's rooms
unsigned char openedRooms; //number of visitable rooms

int main(int argc, char const *argv[]) {

  //get the number of second since january the first
  int times = time(NULL)%200;
  for (int i = 0 ; i < times ; i++){
    randomNumber();
  }


  //Initialization of width and jeight on level
  level=level+6;
  height= level/2;
  width = level - height;

  //Initialization of the list map wich is a grid and will contain all the rooms
  map = (unsigned char *) malloc (height * width);
  for (int i = 0; i < height*width; i++){
    map[i] = 0b00000000;//Initialisation of each box = rooms
    //Each room is represented by a byte
    //Here each room is a normal room without any door and unvisited
    //Room format (same than first byte int the room file Format in the wiki)
    //Up | Down | Left | Right | Visited | Cat | Cat | Cat
    //000 : normal
    //001 : item
    //010 : boss
    //100 : start
  }

  //Start room in the middle of the grid
  unsigned char i;
  unsigned char j;
  if (width%2 != 0){
    i = width/2 + 1;
  }
  else {
    randomNumber();
    unsigned char b = a % 2;
    i = width / 2 + b;
  }
  if (height % 2 != 0){
    j = height/2 + 1;
  }
  else {
    randomNumber();
    unsigned char b = a % 2;
    j = height / 2 + b;
  }
  i--;
  j--;
  start = j * width + i;
  map[start] = 0b00001100;//Put the start room as a start and visited room

  //Boss's room with a Way of a length between width - 2 and width + 2
  //width + 1 - 2^2
  unsigned char diff = 4;
  randomNumber();
  unsigned char c = a % diff  ;//generate a random length of the way between the limits mentionned above
  c = width - c + 2;
  printf("%d\n", c);

  createWay(c);

  map[current] = map[current] & 0b11111000;
  map[current] = map[current] | 0b00001010;//Put the final room as the boss's room
  boss = current;

  for (int i = 0; i < height*width; i++){
    if ((i != start)&&(i != boss)){
      map[i] = map[i] & 0b11110111; //put back all room as unvisited rooms except the start room
    }
  }

  //Item's room with way of a length between width - 4 and width
  randomNumber();
  c = a % diff ;//generate a random length of the way between the limits mentionned above
  c = width - c - 1;
  printf("%d\n", c);

  createWay(c);

  map[current] = map[current] & 0b11111000;
  map[current] = map[current] | 0b00001001;//Put the final room as the boss's room
  item =  current ;

  for (int i = 0; i < height*width; i++){
    if ((i != start) && (i != boss) && (i != item)){
      map[i] = map[i] & 0b11110111;//Put back all the rooms unvisited rooms except the start room
    }
  }

  //Dead ends between width - 4 and width
  //First dead end
  /*randomNumber();
  c = a % diff  ;//generate a random length of the way between the limits mentionned above
  c = width - c - 1;
  printf("%d\n", c);

  createWay(c);*/

  //Second dead end
  randomNumber();
  c = a % diff  ;//generate a random length of the way between the limits mentionned above
  c = width - c - 1;
  printf("%d\n", c);

  createWay(c);
  display();

  //Save rooms in the dedicated Initialisation
  addRoomsToList();
  displayList();

  return 0;
}

//Give the subscripts of the 4 theoric rooms next to the room correcponding to the subscript in argument
unsigned char * neighbours(unsigned char k){
  temp[0] = k - width;
  temp[1] = k - 1;
  temp[2] = k + 1;
  temp[3] = k + width;
  return temp;
}

//one random unvisited and accessible room next to the room correcponding to the subscript in argument
unsigned char unvisitedNeighbour(unsigned char k){
  unsigned char * possibleNeighbours;
  possibleNeighbours = neighbours(k);//Give theoric neighbours
  int compteur = 0;//will count accessible unvisited rooms
  unsigned char neighbour;
  char bool[4];//will contain booleans about if the room is (accessible and unvisited)

  //For the room above
  neighbour = possibleNeighbours[0];
  unsigned char circle = map[neighbour] & 0b00001000;
  if (!(circle == 0) || (k < width)){//check if it is unvisited and accessible
    bool[0] = 0;
  } else{
    bool[0] = 1;
    compteur++;//count unvisited accessible rooms
  }

  //For the room on the left
  neighbour = possibleNeighbours[1];
  circle = map[neighbour] & 0b00001000;
  if (!(circle == 0) || (k % width == 0)){//check if it is unvisited and accessible
    bool[1] = 0;
  } else{
    bool[1] = 1;
    compteur++;//count unvisited accessible rooms
  }

  //for the room on the right
  neighbour = possibleNeighbours[2];
  circle = map[neighbour] & 0b00001000;
  if (!(circle == 0) || (k % width == width - 1)){//check if it is unvisited and accessible
    bool[2] = 0;
  } else{
    bool[2] = 1;
    compteur++;//count unvisited accessible rooms
  }

  //for the room below
  neighbour = possibleNeighbours[3];
  circle = map[neighbour] & 0b00001000;
  if (!(circle == 0) || (k >= (height - 1) * width)){//check if it is unvisited and accessible
    bool[3] = 0;
  } else{
    bool[3] = 1;
    compteur++;//count unvisited accessible rooms
  }
  char chose;//will contain the final choice
  if (compteur == 0){
    chose = current;
  }
  else{
    randomNumber();
    char alea = a % 4;//chose a random room in thos unvisited and accessible
    while (alea >= compteur){
      randomNumber();
      alea = a % 4;
    }
    int i = 0;
    while(alea >= 0){//Circle to find the alea-nd unvisited accessible rooms
      if (bool[i] == 1){
        chose = possibleNeighbours[i];
        alea--;
      }
      i++;
    }
  }
  return chose;
}

void randomNumber(){//Have a random number
  unsigned char t = x ^ (x << 4);
  x=y;
  y=z;
  z=a;
  a = z ^ t ^ ( z >> 1) ^ (t << 1);
}

void createWay(unsigned char c){//create a random way from the start to a specific room with the length mentionned in argument
  current = start;//the way start in the start room
  while (c > 0){//until the length of the way is not reached
    unsigned char next = unvisitedNeighbour(current);//take a random unvisited accessible neighbour
    c--;
    unsigned char b;
    unsigned char a;
    map[next] = map[next] | 0b00001000;//set the new room as visited
    //The following code aim to open the right door between the previous and the next room in different cases
    if (next == current + 1){
      b = 0b00010000;
      a = 0b00100000;
    } else{
      if (next == current - 1){
        b = 0b00100000;
        a = 0b00010000;
      } else{
        if (next == current - width){
          b = 0b10000000;
          a = 0b01000000;
        } else{
          if(next == current + width){
            b = 0b01000000;
            a = 0b10000000;
          }
        }
      }
    }
    map[current] |= b;
    map[next] |= a;
    map[next] |= 0b00001000;
    current = next;//Move on next room
  }
}

void addRoomsToList(){//This function load the visitable rooms in the list list, here the rooms will be represented in 3 bytes : 1 for coordinates, 1 for room ID, 1 for door flags
  unsigned char compteur = 0;//to count opened rooms
  for (int i = 0; i < height*width; i++){
    unsigned char temp = map[i];
    temp &= 0b11110000;//check if one of the door flags is 1 to know if the room is opened
    if (temp > 0){
      map[i] |= 0b00001000;//set the flag to 1 when the room is visitable
      compteur++;
    }
  }
  openedRooms = compteur;
  list = (unsigned char *) malloc (openedRooms*10 + 1);//10 bytes by room
  compteur = 0;
  int i = 0;
  list[0] = openedRooms;
  for (int k = 0; k < height; k++){
    for (int l = 0; l < width; l++){
      unsigned char temp = map[i] & 0b00001000;
      if (temp > 0){
        //Set coordinates in first byte
        unsigned char x = i % width;
        x++;//to start at 1 and not 0
        x = x << 4;//to put in higher wieght bits
        unsigned char y = i / width;
        y++;//to start at 1 and not 0
        list[compteur*10 + 1] = x | y;//put x and y coordinates (each on 4 bits) together in one byte

        //Set ID of a random corresponding room in second byte
        unsigned char type = map[i] & 0b00000111;
        if (type == 0){//if it is a basic room
          randomNumber();
          unsigned char c = a % basicNumber;
          list[compteur*10 + 2] = c + 1;//TODO : = c + (first ID of basic room)
        }
        if (type == 1){//if it is an item's room
          //randomNumber();
          //unsigned char c = a % itemNumber;
          list[compteur*10 + 2] = 0;//TODO : = c + (first ID of item's room)
        }
        if (type == 2){//if it is a boss's room
          //randomNumber();
          //unsigned char c = a % bossNumber;
          list[compteur*10 + 2] = 0;//TODO : = c + (first ID of boss's room)
        }
        if (type == 4){//if it is a start room
          list[compteur*10 + 2] = 0;//0 is the ID of the start room
        }

        //Set door flags in third byte
        list[compteur*10 + 3] = map[i];

        //Set flags in 7 last bytes
        for (int ind = 0; ind < 7; ind++){
          list[compteur*10 + 4 + ind] = 0b11111111;
        }

        compteur++;
      }
      i++;
    }
  }
}

//Specific C code to display and check the code above
void display(){//to show the map of rooms, each room is represented by a byte
  for (int k = 0 ; k < height ; k++){
    for (int l = 0 ; l < width ; l++){
      binaryDisplay(map[k * width + l]);
      printf("    ");
    }
    printf("\n");
  }
  printf("\n");
}

void displayList(){
  printf("%d\n", list[0]);
  printf(".DB ");
  binaryDisplay(list[0]);
  printf("\n");
  for (int k = 0 ; k < openedRooms ; k++){
    printf(".DB ");
    for (int l = 0 ; l < 10 ; l++){
      binaryDisplay(list[k * 10 + l + 1]);
      if (l != 9){
        printf(",");
      }
    }
    printf("\n");
  }
  printf("\n");
}

void binaryDisplay(unsigned char n) {//to show a char in its binary form
  int i = 7;
  printf("%%");
  while (i >= 0){
    printf("%d", (n >> i ) & 1);
    i--;
  }
}
