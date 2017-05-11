/*==========================================================================
* Parse a single Tune chunk from the RF file recorded in microsaccade 
* contrast experiment
*
* Copyright 2014 Richard J. Cui. Created: Mon 05/21/2012  4:34:38.752 PM
* $Revision: 0.2 $  $Date: Sat 03/22/2014 10:21:19.037 PM $
*
* Visual Neuroscience Lab (Dr. Martinez-Conde)
* Barrow Neurological Institute
* 350 W Thomas Road
* Phoenix AZ 85013, USA
*
* Email: jie@neurocorrleate.com
* 
* Reference: function savetune() in rf2tune.c
*
*===========================================================================*/

#include <stdio.h>
#include <string.h>
#include "mex.h"
#include "matrix.h"

/* General Definations */
#define NSTRUCTS 1
#define TOTALPOINTS 36	// total points per 360 deg

#define NFIELDS (sizeof(fieldnames)/sizeof(*fieldnames))

#define TUNECHUNKID (0xff | ('T' << 8))

/* Input Arguments */
#define RFFILE prhs[0]	// RF type whole filename
#define POS prhs[1]		// tune chunk position

/* Output Arguments */
#define	TUNEHEAD	plhs[0]		// info on TUNE chunk, see tuneHead structure below
#define TRUEHITS	plhs[1]		// standardized hits at each point
#define SEMERR		plhs[2]		// standard error of mean * 256

/* structure for tune head infomation */
typedef struct tuneHead
{
	short	totalpoints;	// total points / 360 deg
	short	maxtries;		// max number of tries per point
	short	spare;			// no use now

} tuneHead;

typedef tuneHead tunehead;

/*************************
* subroutines
*************************/

/*=======================
* read tune chunk
=========================*/
void readTuneChunk(
	char *fname,
	int32_t pos,
	tuneHead *ptunehead,
	short *ptruehits,
	short *psemerr
	)
{
	FILE *fp;
	short id;
	
	/*  now read and test */
	fp = fopen(fname, "rb");
	if(fp != NULL)
	{

		/* set read pointer position */
		fseek(fp, pos, SEEK_SET);
		/* check ID of TuneChunk */
		fread(&id, sizeof(id),1,fp);
		// read tunehead infomation
		if(id == TUNECHUNKID)
		{
			// printf("chunk id OK\n");
			fseek(fp, 2, SEEK_CUR);	// skip chunk length info
			fread(ptunehead, sizeof(*ptunehead), 1, fp);

			/* read truehits */
			fread(ptruehits, sizeof(*ptruehits), TOTALPOINTS, fp);

			/* read semerr */
			fread(psemerr, sizeof(*psemerr), TOTALPOINTS, fp);
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
	char	*rfname;	// rf2 data file name
	int32_t	pos;		// position of the chunk

	const char *fieldnames[] = {"totalpoints", "maxtries", "spare"};
	mwSize	dims[2] = {1, NSTRUCTS};
	tuneHead	TuneHead;
	
	/* array for storing ture hits */
	short truehits[TOTALPOINTS] = {0};

	/* array for storing sem */
	short semerr[TOTALPOINTS] ={0};


	mxArray		*pshort;
	mwIndex		index;
	// int			cyc_i, trl_j;

	/* check for proper number of arguments */
	if(nrhs!=2) {
        mexErrMsgIdAndTxt("MyToolbox:arrayProduct:nrhs","Two inputs required.");
    }
    if(nlhs!=3) {
        mexErrMsgIdAndTxt("MyToolbox:arrayProduct:nlhs","Three output required.");
    }

	/* initialization */
	TuneHead.totalpoints = 0;
	TuneHead.maxtries = 0;
	TuneHead.spare = 0;

	/* Input RF data file name */
	rfname = mxArrayToString(RFFILE);
	pos = (int32_t)mxGetScalar(POS);

	// printf("filename: %s \n", rfname);
	// printf("position = %d \n", pos);

	/* get data from one Tune Chunk */
	readTuneChunk(rfname, pos, &TuneHead, truehits, semerr);

	/* ==========================================
	 *  now get the Tune Head vars
	 * ==========================================*/
	
	/* create a 1x1 struct matrix for output  */
	TUNEHEAD = mxCreateStructArray(2, dims, NFIELDS, fieldnames);
	
	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = TuneHead.totalpoints;
	mxSetFieldByNumber(TUNEHEAD, 0, 0, pshort);
	
	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = TuneHead.maxtries;
	mxSetFieldByNumber(TUNEHEAD, 0, 1, pshort);

	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = TuneHead.spare;
	mxSetFieldByNumber(TUNEHEAD, 0, 2, pshort);
	
	/* ==========================================
	 *  now get truehits array
	 * ==========================================*/
	
	/* create a TOTALPOOINT x 1 mxArray to copy data from truehits */
	TRUEHITS = mxCreateDoubleMatrix(TOTALPOINTS, 1, mxREAL);
	for (index = 0; index < TOTALPOINTS; index++)
	{
		mxGetPr(TRUEHITS)[index] = truehits[index];
	}

	/* ==========================================
	 *  now get semerr
	 * ==========================================*/

	/* create a TOTALPOOINT x 1 mxArray to copy data from truehits */
	SEMERR = mxCreateDoubleMatrix(TOTALPOINTS, 1, mxREAL);
	for (index = 0; index < TOTALPOINTS; index++)
	{
		mxGetPr(SEMERR)[index] = semerr[index];
	}

	return;
}