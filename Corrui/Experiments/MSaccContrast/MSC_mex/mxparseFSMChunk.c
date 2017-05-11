/*=============================================================================
* Parse a single "fixsim" chunk from the RF file recorded in Fixsim experiment
*
* Copyright 2013 Richard J. Cui. Created: Wed 01/22/2014  2:16:22.546 PM
* $Revision: 0.1 $  $Date: Wed 01/22/2014  2:16:22.546 PM $
*
* Visual Neuroscience Lab (Dr. Martinez-Conde)
* Barrow Neurological Institute
* 350 W Thomas Road
* Phoenix AZ 85013, USA
*
* Email: jie@neurocorrleate.com
*==============================================================================*/

#include <stdio.h>
#include <string.h>
#include "mex.h"
#include "matrix.h"

/* General Definations */
#define NSTRUCTS 1

#define NFIELDS (sizeof(fieldnames)/sizeof(*fieldnames))
#define FSMCHUNKID (0xff | ('f' << 8))

#define SHORTCHUNKSIZE	90
#define LONGCHUNKSIZE	96
#define	EMPTY			9999

/* Input Arguments */
#define RFFILE prhs[0]
#define POS prhs[1]		// chunk position

/* Output Arguments */
#define FSMENVVARS	plhs[0]		// info on Fixsim environment variables, see rf2fixsim.c

/* structure for fixsim environment variables */
typedef struct fsmEnvVarsShort		// compatible with old exp; see savefixsim() in rf2fixsim.c
{
	// fixation spot
	short	gazebox;
	short	stimsize;

	// bar paras
	short	bangle;		// note: b - bar
	short	bwidth;	
	short	blength;

	// foregraound/background colors, in rf2main.c
	short	lcolorsr;	// see rf2main.c
	short	lcolorsg;
	short	lcolorsb;	// combination of forgraound / background color

	// bar location
	short	locx;
	short	locy;
	short	gazetime;

	// fix sport color
	short	fixr;
	short	fixg;
	short	fixb;

	// other paras
	short	startchunk;	// TS chunk number where the eye signals used starts
	short	active;		// flag: 1 = bar in active mode
	char	infilename[40];		// infile name
	long	activetime;			// time stamp when the bar/fix was set by the user in active mode
	long	dataONtime;			// time stamp when the data was recorded
	long	activetimestart;	// time stamp when the bar/fix was actaully moving

} fsmEnvVarsShort;

typedef struct fsmEnvVarsLong		// compatible with new exp; see savefixsim() in rf2fixsim.c
{
	// fixation spot
	short	gazebox;
	short	stimsize;

	// bar paras
	short	bangle;		// note: b - bar
	short	bwidth;	
	short	blength;

	// foregraound/background colors, in rf2main.c
	short	lcolorsr;	// see rf2main.c
	short	lcolorsg;
	short	lcolorsb;	// combination of forgraound / background color

	// bar location
	short	locx;
	short	locy;
	short	gazetime;

	// fix sport color
	short	fixr;
	short	fixg;
	short	fixb;

	// other paras
	short	startchunk;	// TS chunk number where the eye signals used starts
	short	active;		// flag: 1 = bar in active mode
	char	infilename[40];		// infile name
	long	activetime;			// time stamp when the bar/fix was set by the user in active mode
	long	dataONtime;			// time stamp when the data was recorded
	long	activetimestart;	// time stamp when the bar/fix was actaully moving

	// new vars fro fix spot active
	short	showbar;	// flag: 1 = bar was shown
	short	fixactive;	// flag: 1 = fix spot in active mode
	short	fixx;		// x - fix spot location
	short	fixy;		// y - fix spot location

} fsmEnvVarsLong;

/*************************
* subroutines
*************************/

/*=======================
* read fixsim chunk
=========================*/
void readFsmChunk(
	char *fname,	// RF data file name
	fsmEnvVarsShort *pfsmEnvVarsShort,	// short format
	fsmEnvVarsLong *pfsmEnvVarsLong,	// long format
	short *ChunkSize,					// chunk size, different in long/short fixsim chunk
	long pos
	)
{
	FILE *fp;
	errno_t err;
	short id;

	/*  now read and test */
	err = fopen_s(&fp, fname, "rb");
	if(!err)
	{
		/* set read pointer position */
		fseek(fp, pos, SEEK_SET);
		/* check ID of fsmEnvVarsLong/Short */
		fread(&id, sizeof(id),1,fp);
		//printf("Attempt fsmEnvVars id = %d\n", id);
		if(id == FSMCHUNKID)
		{
			fread(ChunkSize, sizeof(*ChunkSize), 1, fp);	// read chunk size info
			if( *ChunkSize == SHORTCHUNKSIZE )
				fread(pfsmEnvVarsShort, sizeof(*pfsmEnvVarsShort), 1, fp);
			else if( *ChunkSize == LONGCHUNKSIZE )
				fread(pfsmEnvVarsLong, sizeof(*pfsmEnvVarsLong), 1, fp);
			else
				printf("Size of Fixsim chunk is not correct!\n");
		}

	}
	else
	{
		printf("Cannot open %s.\n",fname);
	}

	fclose(fp);

}

/*************************
* The Gateway Function
**************************/
void mexFunction(
	int nlhs, mxArray *plhs[],
	int nrhs, const mxArray *prhs[] )

{
	char    *rfname;	// rf2 data file name
	long	pos;		// position of the chunk

	const char *fieldnames[] = {"gazebox", "stimsize", "bangle", "bwidth", "blength",
		"lcolorsr", "lcolorsg", "lcolorsb", "locx", "locy",
		"gazetime", "fixr", "fixg", "fixb", "startchunk", 
		"active", "infilename", "activetime", "dataONtime", "activetimestart",
		"showbar", "fixactive", "fixx", "fixy"
	};

	short		ChunkSize;		// chunk size of fixsim chunks

	mwSize		dims[2] = {1, NSTRUCTS};
    char *str[1];
    
	fsmEnvVarsShort	*pfsmEnvVarsShort;	// contrast environment variables
	fsmEnvVarsLong	*pfsmEnvVarsLong;

	mxArray		*pvalue;
	mwSize		nsubs;
	mwIndex		index, *subs;

	/* check for proper number of arguments */
	if(nrhs!=2) {
		mexErrMsgIdAndTxt("MyToolbox:arrayProduct:nrhs","Two inputs required.");
	}
	if(nlhs!=1) {
		mexErrMsgIdAndTxt("MyToolbox:arrayProduct:nlhs","One output required.");
	}

	/* Input RF data file name */
	rfname = mxArrayToString(RFFILE);
	pos = (long)mxGetScalar(POS);

	pfsmEnvVarsShort = (fsmEnvVarsShort *)mxCalloc(1, sizeof(*pfsmEnvVarsShort));
	pfsmEnvVarsLong  = (fsmEnvVarsLong *)mxCalloc(1, sizeof(*pfsmEnvVarsLong));
	readFsmChunk(rfname, pfsmEnvVarsShort, pfsmEnvVarsLong, &ChunkSize, pos);

	/* ==========================================
	/*  now get the Fixsim environment vars
	/* ==========================================*/

	/* create a 1x1 struct matrix for output  */
	FSMENVVARS = mxCreateStructArray(2, dims, NFIELDS, fieldnames);

	if(ChunkSize == LONGCHUNKSIZE)
	{
		pvalue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pvalue) = pfsmEnvVarsLong->gazebox;
		mxSetFieldByNumber(FSMENVVARS, 0, 0, pvalue);

		pvalue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pvalue) = pfsmEnvVarsLong->stimsize;
		mxSetFieldByNumber(FSMENVVARS, 0, 1, pvalue);

		pvalue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pvalue) = pfsmEnvVarsLong->bangle;
		mxSetFieldByNumber(FSMENVVARS, 0, 2, pvalue);

		pvalue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pvalue) = pfsmEnvVarsLong->bwidth;
		mxSetFieldByNumber(FSMENVVARS, 0, 3, pvalue);

		pvalue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pvalue) = pfsmEnvVarsLong->blength;
		mxSetFieldByNumber(FSMENVVARS, 0, 4, pvalue);

		pvalue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pvalue) = pfsmEnvVarsLong->lcolorsr;
		mxSetFieldByNumber(FSMENVVARS, 0, 5, pvalue);

		pvalue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pvalue) = pfsmEnvVarsLong->lcolorsg;
		mxSetFieldByNumber(FSMENVVARS, 0, 6, pvalue);

		pvalue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pvalue) = pfsmEnvVarsLong->lcolorsb;
		mxSetFieldByNumber(FSMENVVARS, 0, 7, pvalue);

		pvalue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pvalue) = pfsmEnvVarsLong->locx;
		mxSetFieldByNumber(FSMENVVARS, 0, 8, pvalue);

		pvalue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pvalue) = pfsmEnvVarsLong->locy;
		mxSetFieldByNumber(FSMENVVARS, 0, 9, pvalue);

		pvalue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pvalue) = pfsmEnvVarsLong->gazetime;
		mxSetFieldByNumber(FSMENVVARS, 0, 10, pvalue);

		pvalue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pvalue) = pfsmEnvVarsLong->fixr;
		mxSetFieldByNumber(FSMENVVARS, 0, 11, pvalue);

		pvalue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pvalue) = pfsmEnvVarsLong->fixg;
		mxSetFieldByNumber(FSMENVVARS, 0, 12, pvalue);

		pvalue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pvalue) = pfsmEnvVarsLong->fixb;
		mxSetFieldByNumber(FSMENVVARS, 0, 13, pvalue);

		pvalue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pvalue) = pfsmEnvVarsLong->startchunk;
		mxSetFieldByNumber(FSMENVVARS, 0, 14, pvalue);

		pvalue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pvalue) = pfsmEnvVarsLong->active;
		mxSetFieldByNumber(FSMENVVARS, 0, 15, pvalue);

		str[0] = pfsmEnvVarsLong->infilename;
        pvalue = mxCreateCharMatrixFromStrings((mwSize)1, (const char **)str);
        mxSetFieldByNumber(FSMENVVARS, 0, 16, pvalue);

		pvalue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pvalue) = pfsmEnvVarsLong->activetime;
		mxSetFieldByNumber(FSMENVVARS, 0, 17, pvalue);

		pvalue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pvalue) = pfsmEnvVarsLong->dataONtime;
		mxSetFieldByNumber(FSMENVVARS, 0, 18, pvalue);

		pvalue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pvalue) = pfsmEnvVarsLong->activetimestart;
		mxSetFieldByNumber(FSMENVVARS, 0, 19, pvalue);

		pvalue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pvalue) = pfsmEnvVarsLong->showbar;
		mxSetFieldByNumber(FSMENVVARS, 0, 20, pvalue);

		pvalue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pvalue) = pfsmEnvVarsLong->fixactive;
		mxSetFieldByNumber(FSMENVVARS, 0, 21, pvalue);

		pvalue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pvalue) = pfsmEnvVarsLong->fixx;
		mxSetFieldByNumber(FSMENVVARS, 0, 22, pvalue);

		pvalue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pvalue) = pfsmEnvVarsLong->fixy;
		mxSetFieldByNumber(FSMENVVARS, 0, 23, pvalue);

		mxFree((void *)pfsmEnvVarsLong);
		mxFree((void *)pfsmEnvVarsShort);
	}
	else if(ChunkSize == SHORTCHUNKSIZE)
	{
		pvalue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pvalue) = pfsmEnvVarsShort->gazebox;
		mxSetFieldByNumber(FSMENVVARS, 0, 0, pvalue);

		pvalue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pvalue) = pfsmEnvVarsShort->stimsize;
		mxSetFieldByNumber(FSMENVVARS, 0, 1, pvalue);

		pvalue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pvalue) = pfsmEnvVarsShort->bangle;
		mxSetFieldByNumber(FSMENVVARS, 0, 2, pvalue);

		pvalue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pvalue) = pfsmEnvVarsShort->bwidth;
		mxSetFieldByNumber(FSMENVVARS, 0, 3, pvalue);

		pvalue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pvalue) = pfsmEnvVarsShort->blength;
		mxSetFieldByNumber(FSMENVVARS, 0, 4, pvalue);

		pvalue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pvalue) = pfsmEnvVarsShort->lcolorsr;
		mxSetFieldByNumber(FSMENVVARS, 0, 5, pvalue);

		pvalue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pvalue) = pfsmEnvVarsShort->lcolorsg;
		mxSetFieldByNumber(FSMENVVARS, 0, 6, pvalue);

		pvalue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pvalue) = pfsmEnvVarsShort->lcolorsb;
		mxSetFieldByNumber(FSMENVVARS, 0, 7, pvalue);

		pvalue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pvalue) = pfsmEnvVarsShort->locx;
		mxSetFieldByNumber(FSMENVVARS, 0, 8, pvalue);

		pvalue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pvalue) = pfsmEnvVarsShort->locy;
		mxSetFieldByNumber(FSMENVVARS, 0, 9, pvalue);

		pvalue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pvalue) = pfsmEnvVarsShort->gazetime;
		mxSetFieldByNumber(FSMENVVARS, 0, 10, pvalue);

		pvalue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pvalue) = pfsmEnvVarsShort->fixr;
		mxSetFieldByNumber(FSMENVVARS, 0, 11, pvalue);

		pvalue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pvalue) = pfsmEnvVarsShort->fixg;
		mxSetFieldByNumber(FSMENVVARS, 0, 12, pvalue);

		pvalue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pvalue) = pfsmEnvVarsShort->fixb;
		mxSetFieldByNumber(FSMENVVARS, 0, 13, pvalue);

		pvalue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pvalue) = pfsmEnvVarsShort->startchunk;
		mxSetFieldByNumber(FSMENVVARS, 0, 14, pvalue);

		pvalue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pvalue) = pfsmEnvVarsShort->active;
		mxSetFieldByNumber(FSMENVVARS, 0, 15, pvalue);

		str[0] = pfsmEnvVarsShort->infilename;
        pvalue = mxCreateCharMatrixFromStrings((mwSize)1, (const char **)str);
		mxSetFieldByNumber(FSMENVVARS, 0, 16, pvalue);

		pvalue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pvalue) = pfsmEnvVarsShort->activetime;
		mxSetFieldByNumber(FSMENVVARS, 0, 17, pvalue);

		pvalue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pvalue) = pfsmEnvVarsShort->dataONtime;
		mxSetFieldByNumber(FSMENVVARS, 0, 18, pvalue);

		pvalue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pvalue) = pfsmEnvVarsShort->activetimestart;
		mxSetFieldByNumber(FSMENVVARS, 0, 19, pvalue);

		pvalue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pvalue) = EMPTY;
		mxSetFieldByNumber(FSMENVVARS, 0, 20, pvalue);

		pvalue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pvalue) = EMPTY;
		mxSetFieldByNumber(FSMENVVARS, 0, 21, pvalue);

		pvalue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pvalue) = EMPTY;
		mxSetFieldByNumber(FSMENVVARS, 0, 22, pvalue);

		pvalue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pvalue) = EMPTY;
		mxSetFieldByNumber(FSMENVVARS, 0, 23, pvalue);

		mxFree((void *)pfsmEnvVarsLong);
		mxFree((void *)pfsmEnvVarsShort);
	}

	return;
}