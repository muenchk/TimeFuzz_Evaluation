/* The file has been taken from the IJon repository
 * https://github.com/RUB-SysSec/ijon-data/blob/master/maze/big.c
 * minor modifications have been made for the purpose of this work
*/

// The maze demo is taken from Felipe Andres Manzano's blog:
// http://feliam.wordpress.com/2010/10/07/the-symbolic-maze/
//
//

#include <exception>
#include <iostream>
#include <string>

#if defined(_WIN32) || defined(_WIN64) || defined(__CYGWIN__)
#include <cstdio>
#include <cstdlib>
#include <io.h>
#include <cassert>
#else
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <assert.h>
#include <stdbool.h>
#endif

#define H 19
#define W 27

char maze[H][W]={
"+-+----------------------+",
"| |              |#  |   |", 
"| | +-----* *------+ | + +",
"|   |        |     | | | |",
"+---+-* *-----+ ++ +   | +",
"|             | |   +--+ |",
"+ +-----------+ ++ ++  | +",
"| |       |   | |  |   | |",
"| | *---+ * * * |  | * | |",
"| |     |   |   |    | | |",
"| +---* +-------|------+ +",
"|             |          |",
"+-----* *-----+ +--------|",
"|          |             |",
"+ +--------+----* * *----|",
"| |   |   | |     |      |",
"| * * * * * * +-----+ +--|",
"|   |   |                |",
"+------------------------+",};

void draw ()
{
	int i/*, j*/;
	for (i = 0; i < H; i++)
	  {
		 // for (j = 0; j < W; j++)
		//		  printf ("%c", maze[i][j]);
		  printf ("%s\n", maze[i]);
	  }
	printf ("\n");
}

int
main (int argc, char *argv[])
{
	/* Returns codes have been modified to the following interpretations:
	* 0 : success
	* 1 : command line arguments failure
	* 2 : wrong command
	* 3 : lose
	*/

	int32_t toread = 0;
	// command line args
	if (argc == 2) {
		try
		{
			toread = std::atoi(argv[1]);
		}
		catch (std::exception& e)
		{
			std::cout << e.what();
		}
	} else {
		printf("executed:%d:  cmd args error", 0);
		return 1;
	}

	int x, y;     //Player position
	int ox, oy;   //Old player position
	int i = 0;    //Iteration number
	x = 1;
	y = 1;
	maze[y][x]='X';
	draw();
/*#define ITERS 512
	char program[ITERS];
	read(0,program,ITERS);*/
	while(i < toread)
	{
		char c = (char)getchar();
		maze[y][x]=' ';
		ox = x;    //Save old player position
		oy = y;
    //transition(hashint(x,y));
		switch (c)
		{
			case 'w':
				y--;
				break;
			case 's':
				y++;
				break;
			case 'a':
				x--;
				break;
			case 'd':
				x++;
				break;
			default:
				printf("Wrong command!(only w,s,a,d accepted!)\n");
				printf("You lose!\n");
#if defined(_WIN32) || defined(_WIN64) || defined(__CYGWIN__)
			printf("executed:%d:", i);
#endif
				exit(2);
		}
		i++;

		if (maze[y][x] == '#')
		{
			printf("You win");
#if defined(_WIN32) || defined(_WIN64) || defined(__CYGWIN__)
			printf("executed:%d:", i);
#endif
			exit(0);
		}
		if (maze[y][x] != ' ') {
			x = ox;
			y = oy;
		}
		if (ox==x && oy==y){
			printf("You lose\n");
#if defined(_WIN32) || defined(_WIN64) || defined(__CYGWIN__)
			printf("executed:%d:", i);
#endif
			exit(3);
		}

		maze[y][x]='X';
		draw ();          //draw it
	}
	printf("You lose\n");
#if defined(_WIN32) || defined(_WIN64) || defined(__CYGWIN__)
			printf("executed:%d:", i);
#endif
	exit(4);
}