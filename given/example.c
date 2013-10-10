/*   This is an input and output example for using command-line arguments */
/*   and pgm images                                                       */ 
/*   What it does is just assigning pixels above a threshold to 255    */ 
/*   How to run the program:                                           */
/*   example -T threshold_value -f input_image.pgm -o output_image.pgm */

#include <stdlib.h>     /* include standard library package */ 
#include <stdio.h>      /* include standard inpout and output package */ 
#include <math.h>       /* include mathematic package                 */
#include <strings.h>    /* include string package */ 
#define MAXNROW 512     /* the maximum number of rows allowed      */
#define MAXNCOL 640     /* the maximum number of columns allowed   */ 
#define MAXFNL 128      /* the maximum fine name length            */
#define WHITE  255      /* the white value of the output image     */
#define BLACK    0      /* the black value of the output image     */

unsigned char charim[MAXNROW][MAXNCOL];		/* unsigned char image     */
/* The above is static memory allocation, for simplicity.                  */
/* A better way is to use dynamic memory allocation by calling function    */
/* malloc(size), which allocates an area of memory of the size (in bytes)  */
/* and returns a pointer to the first element of the region.               */
/* This way, the image size is not limited by MAXNROW*MAXNCOL              */
/* Use man malloc to find out how to use it. You are encouraged to use     */
/* dynamic memory allocation for our projects.                             */
char cchFName[MAXFNL];   /* a buffer to hold file name                 */
char cchPGMStr[71];       /* string to hold string                     */
FILE *fptIn, *fptOut; /* pointers to image files, one input and one output       */

/* this procedure opens a file */
/* It allows a sufix to be added to the filename to be opened*/
/* but our example does not use sufix                                    */
/* flppFile: the file opened (output)                                    */
/* cchpFileName: the stem of file name for openning (input)              */
/* cchpFileTail: the tail of file name to be appended (input)            */
/* cchpType: the permission type of file to be opended (input)           */
void ffopen(flppFile,cchpFileName,cchpFileTail,cchpType)
  FILE **flppFile;
  char *cchpFileName, *cchpFileTail, *cchpType; 
{
  strncpy(cchFName,cchpFileName,sizeof cchFName);
  strncat(cchFName,cchpFileTail,sizeof cchFName);
  if ((*flppFile = fopen(cchFName,cchpType)) == NULL) {
    fprintf(stderr,"ERROR -- Can't open file: %s!\n",cchFName);
    exit(1); } }

    /* complete fread. This procedure reads using fread, but reports read errors */
    /* chpData: the data stream to store the data                             */
    /* stSize: the size of each item (input)                                 */
    /* intNItems: the number of items (input)                                */
    /* flppFile;  input file pointer (input)                                 */
void cfread(chpData,stSize,intNItems,flppFile)
  char *chpData;   /* pointer to char data storage */
  size_t stSize; /* size of each item */ 
  int intNItems; /* number of items */
  FILE *flppFile; /* input file pointer */
{  	if (fread(chpData,stSize,intNItems,flppFile) != intNItems) {
  fprintf (stderr,"Error! Input file read failure\n");
  exit(1);
                                                               }
}

/* complete fwrite. This procedure write using fwrite, but reports write errors */
/* chpData: the data stream to read the data from                        */
/* stSize: the size of each item (input)                                 */
/* intNItems: the number of items (input)                                */
/* flppFile;  the file to be write into (input)                          */
void cfwrite(chpData,stSize,intNItems,flppFile)
  char *chpData;   /* pointer to char data storage */
  size_t stSize; /* size of each item */ 
  int intNItems; /* number of items */
  FILE *flppFile; /* output file pointer */
{  	if (fwrite(chpData,stSize,intNItems,flppFile) != intNItems) {
  fprintf (stderr,"Error! Output file write failure\n");
  exit(1);
                                                                }
}

/* this proceedure skips all the characters until it reads in a new line */
/* this proceedure skips all the characters until it reads in a new line */
void skiptonewline(f1)
  FILE *f1;
{
  char chTmp;
  do { cfread(&chTmp,sizeof(char),1,f1);
  } while (chTmp != '\n');
}

/* print instructions to standard error if the syntax is wrong */
/* argv: argument vector (input)  */
void usage(argv)
  char *argv[];
{
  fprintf (stderr,"Usage: %s switches \n", argv[0]);
  fprintf (stderr,"where switches are:\n");
  fprintf (stderr," -f = input RAWBITS pgm image file (default standard in)\n");
  fprintf (stderr," -T = threshold, between 0 and 255, required\n");
  fprintf (stderr," -o = output RAWBITS pgm image (default: standard out)\n");
  fprintf (stderr,"Examples:\n");
  fprintf (stderr,"example -T 128 -f TVad.pgm -o TVad_thresh.pgm\n");
  fprintf (stderr,"example -T 128 < TVad.pgm > TVad_thresh.pgm\n");
  exit(1);
}

/* this is the main program */
/* argc: argument count (input) */
/* argv: argument vector (input) */
void main(argc,argv)
  int argc;
  char *argv[];
{
  int intAC;  /* Argument count */	
  int intCNRow=MAXNROW,intCNCol=MAXNCOL; 
  /* Maximum number of row and columns */
  int intThreshGiven = 0;
  /* Whether the threshold number is given */
  int intCol,intRow;
  /* the column and rwo numbers */
  int intThresh;
  /* the threshold for the image */
  int intMaxVal;
  /* the maximum value for pixels */

  fptIn = stdin; /* get the file descriptor for standard input */
  fptOut = stdout; /* the the file descriptor for standard output */
  /* get command line arguments */
  for (intAC=1; intAC < argc; intAC++)
    if (argv[intAC][0] == '-')
      switch (argv[intAC][1])    {
        case 'f':       ffopen(&fptIn,argv[++intAC],"","r");
                        /* provide the input file name */
                        break;
        case 'T':       intThresh = atoi(argv[++intAC]); 
                        /* provide the threshold value. */
                        intThreshGiven = 1;
                        /* flag that the threshold value has been given.*/
                        break;
        case 'o':       ffopen(&fptOut,argv[++intAC],"","w");
                        /* provide the output file name.*/
                        break;
        default:        usage(argv);
                        /* report usage if the flag is wrong.*/
      }
    else usage(argv);     
  /* report usage if - is not provided for flag.*/

  if (intThreshGiven == 0 ) {
    /* report error for the case where threshould not given:*/
    fprintf(stderr,"Error: threshold not given\n");
    exit(1);
  }

  /* first to move the disk head to the beginning of the file: */
  fseek(fptIn,0L,0);

  /* read magic string P5 of the RAWBITS pgm image */
  fscanf(fptIn, "%s", cchPGMStr);
  if (strcmp(cchPGMStr,"P5") != 0) {
    fprintf(stderr,"ERROR --- input image is not RAWBITS pgm\n"); 
    exit(1);
  }
  /* read the number of columns of the pgm image */
  fscanf(fptIn, "%s", cchPGMStr);
  /* skip possible comment */ 
  if (cchPGMStr[0] == '#') skiptonewline(fptIn); 
  sscanf(cchPGMStr, "%d", &intCNCol); 
  /* read the number of rows of the pgm image */
  fscanf(fptIn, "%s", cchPGMStr);
  if (cchPGMStr[0] == '#') skiptonewline(fptIn); 
  sscanf(cchPGMStr, "%d", &intCNRow); 
  /* read the maximum gray value of the pgm image */
  fscanf(fptIn, "%s", cchPGMStr);
  if (cchPGMStr[0] == '#') skiptonewline(fptIn); 
  sscanf(cchPGMStr, "%d", &intMaxVal); 
  /* pgm head has been read */ 
  /* now read the raw bits using unformated input */
  for (intRow=0; intRow<intCNRow; intRow++) 
    cfread(&charim[intRow][0],sizeof(char),intCNCol,fptIn);

  /* processing starts here     */
  /* it generates a thresholded binary image here. */
  fprintf(stderr,"thresh=%d\n",intThresh);
  for (intRow=0; intRow<intCNRow; intRow++) {
    for (intCol=0; intCol<intCNCol; intCol++) {
      if (charim[intRow][intCol] > intThresh) 
        charim[intRow][intCol] = WHITE;
      else charim[intRow][intCol] = BLACK;
    }
  }
  /* processing has been done. */

  /* Output charimage: */
  /* write pgm header: */
  /* write the RAWBITS pgm magic number: */
  fprintf(fptOut,"P5\n");
  /* write the comment: */
  fprintf(fptOut,"# generated by example program for project 2\n");
  /* write the width and height: */
  fprintf(fptOut,"%d %d \n",intCNCol,intCNRow);
  /* write the maxval: */
  fprintf(fptOut,"%d\n",WHITE);
  for (intRow=0; intRow<intCNRow; intRow++) 
    cfwrite(&charim[intRow][0],sizeof(char),intCNCol,fptOut);
  /* close input file: */
  fclose(fptIn);
  /* close output file:*/
  fclose(fptOut);
}

