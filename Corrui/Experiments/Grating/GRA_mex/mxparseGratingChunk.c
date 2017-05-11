/*==========================================================================
* Parse a single Grating chunk from the RF file recorded in microsaccade 
* contrast experiment
*
* Copyright 2012 Richard J. Cui. Created: Wed 05/23/2012 11:10:19.628 AM
* $Revision: 0.1 $  $Date: Wed 05/23/2012 11:10:19.628 AM $
*
* Visual Neuroscience Lab (Dr. Martinez-Conde)
* Barrow Neurological Institute
* 350 W Thomas Road
* Phoenix AZ 85013, USA
*
* Email: jie@neurocorrleate.com
* 
* Reference: function savegrating() in rf2grat.c
*
*===========================================================================*/

#include <stdio.h>
#include <string.h>
#include "mex.h"
#include "matrix.h"

/* General Definations */
#define MAXERRMSGLEN	256	// max length of error message
#define NSTRUCTS	1
#define	SPEEDNUM	5		// number of different speeds, SPEED in pixels/s
#define PERIODNUM	5		// number of different periods, PERIOD in pixles
#define NUMCOND	SPEEDNUM * PERIODNUM	// number of conditions
#define MAXREPEAT	20		// number of repeat times

#define NGRTENVVARFIELDS (sizeof(grtenvvarfldnames)/sizeof(*grtenvvarfldnames))	// for grating enviornment variables
#define NGRATGCONDFIELDS (sizeof(gratcondfldnames)/sizeof(*gratcondfldnames))	// for grating condition variables
#define NTRLSTAENDFIELDS (sizeof(trlstaendfldnames)/sizeof(*trlstaendfldnames))		// for grating trial start-end time stamps

// IDs 
#define GRTENVVARID (0xff | ('g' << 8))
#define TRLSTRENDID	(0xcc | ('e' << 8))
#define MEANRATEAID	(0xcc | ('m' << 8))
#define STDRATECAID	(0xcc | ('s' << 8))
#define GRATGCONDID	(0xcc | ('g' << 8))
#define SPEEDPERDID	(0xcc | ('i' << 8))

/* Input Arguments */
#define NUMARGIN	2
#define RFFILE prhs[0]	// RF type whole filename
#define POS prhs[1]		// tune chunk position

/* Output Arguments */
#define NUMARGOUT	6
#define	GRTENVVAR	plhs[0]		// info on grating enviornment vairiables
#define TRLSTREND	plhs[1]		// trial start-end time stamps
#define MEANRATEA	plhs[2]		// mean rate from channel A
#define STDRATEA	plhs[3]		// stadard deviation of rate from channel A
#define GRTCOND		plhs[4]		// grating condition structure
#define SPEDPERDI	plhs[5]		// speed period index of each condition

/* structure for grating envorinment variable infomation */
//typedef struct grtEnvVar
//{
//	short	gazebox;		// the picnumber
//	short	stimsize;		// size of fixation cross
//	short	bangle;
//	short	bwidth;
//	short	blength;
//	short	lcolorsr;		// see rf2main.c
//	short	lcolorsg;
//	short	lcolorsb;		// combination of foreground / background color
//	short	locx;
//	short	locy;
//	short	speed;
//	short	gazetime;
//	short	fixx;
//	short	fixy;
//	short	fixr;
//	short	fixg;
//	short	fixb;
//	short	period;
//	short	mingray;
//	short	maxgray;
//
//} grtEnvVar;
//
//typedef grtEnvVar grtenvvar;

/* structure for storing speed period pair */
typedef struct speedPeriodPair
{
	short	speed;
	short	period;
} speedPeriodPair;

typedef speedPeriodPair SpeedPeriodPair;

/*************************
* subroutines
*************************/

/*=======================
* read grating chunk
=========================*/
void readGratingChunk(
	char		*fname,
	long		pos,
	short		*pgrtenvvar,
	long		*ptrialstartend,
	short		*pmeanratea,
	short		*pstdratea,
	SpeedPeriodPair		*pSpeedPeriodPair,
	short		*pspeedperiodidx
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
		/* check ID of GratingChunk */
		fread(&id, sizeof(id),1,fp);
		// read grating enviornment variable infomation
		if(id == GRTENVVARID)
		{
			fseek(fp, 2, SEEK_CUR);	// skip chunk length info
			fread(pgrtenvvar, sizeof(*pgrtenvvar), 20, fp);
		}
		
		/* read trial start-end time */
		// check ID
		fread(&id, sizeof(id),1,fp);
		if(id == TRLSTRENDID)
		{
			fread(ptrialstartend, sizeof(*ptrialstartend), NUMCOND * MAXREPEAT *2, fp);
		}
		
		/* read meanrate in Channel A */
		// check ID
		fread(&id, sizeof(id),1,fp);
		if(id == MEANRATEAID)
		{
            fread(pmeanratea, sizeof(*pmeanratea), NUMCOND, fp);
		}

		/* read std. rate in Channel A */
		// check ID
		fread(&id, sizeof(id),1,fp);
		if(id == STDRATECAID)
		{
			fread(pstdratea, sizeof(*pstdratea), NUMCOND, fp);
		}

		/* read speed-period pair */
		// check ID
		fread(&id, sizeof(id),1,fp);
		if(id == GRATGCONDID)
		{
			fread(pSpeedPeriodPair, sizeof(*pSpeedPeriodPair), NUMCOND, fp);
		}

		/* read speed-period index*/
		// check ID
		fread(&id, sizeof(id),1,fp);
		if(id == SPEEDPERDID)
		{
			fread(pspeedperiodidx, sizeof(*pspeedperiodidx), NUMCOND * 2, fp);
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
	/* ------------------------
	/* variable declaration
	/* ----------------------*/
	/* ===== structure for inputs ==== */
	char	*rfname;	// rf2 data file name
	long	pos;		// position of the chunk

	/* ===== datastruct for outputs ===== */
	// structure for grating enviornment variables
	short GrtEnvVar[20] = {0};
	const char *grtenvvarfldnames[] = {"gazebox", "stimsize", "bangle", "bwidth",
									   "blength", "lcolorsr", "lcolorsg", "lcolorsb",
									   "locx", "locy", "speed", "gazetime", "fixx",
	                                   "fixy", "fixr", "fixg", "fixb", "period", 
	                                   "mingray", "maxgray"};
	mwSize	dims[2] = {1, NSTRUCTS};

	/* array for storing start/end time stamps of trials */
	long trialstartend[NUMCOND][MAXREPEAT][2] = {0};	// [0] = start, [1] = end
	const char *trlstaendfldnames[] = {"start", "end"};
	mwSize	dimstse[2] = {NUMCOND, MAXREPEAT};
	// mwSize	dimstsed[3] = {NUMCOND, MAXREPEAT, 2};

	/* array for storing mean rate from channel A */
	short meanratea[SPEEDNUM][PERIODNUM] ={0};

	/* array for storing std of rate from channel A */
	short stdratea[SPEEDNUM][PERIODNUM] = {0};

	/* array for storing speedperiodpair */
	SpeedPeriodPair gratcond[NUMCOND];
	const char *gratcondfldnames[] = {"speed", "period"};
	mwSize	dimsspp[2] = {1, NUMCOND};

	/* array for storing speedperiod index */
	// 1st col. index = 0,1,2,...,SPEEDNUM-1
	// 2nd col. index = 0,1,2,...,PERIODNUM-1
	short speedperiodidx[NUMCOND][2] = {0};

	/* ===== variables for gateway only ===== */
	mxArray		*pvalue;
	mwSize		nsubs;
	mwIndex		index, *subs;
	mwIndex		i, j, k;
	char		*err_msg;
	
	/* -----------------------
	/* codes
	/* ---------------------*/
	/* check for proper number of arguments */
	if(nrhs != NUMARGIN) {
		err_msg = (char *)malloc(MAXERRMSGLEN);
		sprintf(err_msg, "%d inputs required.", NUMARGIN);
        mexErrMsgIdAndTxt("MyToolbox:arrayProduct:nrhs", err_msg);
		free(err_msg);
    }
	if(nlhs != NUMARGOUT) {
		err_msg = (char *)malloc(MAXERRMSGLEN);
		sprintf(err_msg, "%d outputs required.", NUMARGOUT);
        mexErrMsgIdAndTxt("MyToolbox:arrayProduct:nlhs", err_msg);
		free(err_msg);
    }

	/* Input RF data file name */
	rfname = mxArrayToString(RFFILE);
	pos = (long)mxGetScalar(POS);

	/* get data from one Grating Chunk */
	readGratingChunk(rfname, pos, GrtEnvVar, trialstartend[0][0], 
		meanratea[0], stdratea[0], gratcond, speedperiodidx[0]);

	/* ==========================================
	/*  now outputs the grating environment variables
	/* ==========================================*/
	
	/* create a 1x1 struct matrix for output  */
	GRTENVVAR = mxCreateStructArray(2, dims, NGRTENVVARFIELDS, grtenvvarfldnames);
	
	for(index = 0; index < 20; index++)
	{
		pvalue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pvalue) = GrtEnvVar[index];
		mxSetFieldByNumber(GRTENVVAR, 0, index, pvalue);
	}

	
	/* ==========================================
	/*  now output trial start-end time stamps
	/* ==========================================*/
	
	/* create a NUMCOND x MAXREPEAT struct matrix for output  */
	TRLSTREND = mxCreateStructArray((mwSize)2, dimstse, NTRLSTAENDFIELDS, trlstaendfldnames);
	nsubs = mxGetNumberOfDimensions(TRLSTREND);
	subs = (mwIndex *)mxCalloc(nsubs, sizeof(mwIndex));

	for(i = 0; i < NUMCOND; i++)
	{
		for(j = 0; j < MAXREPEAT; j++)
		{
			subs[0] = (mwIndex)i;
			subs[1] = (mwIndex)j;
			index = mxCalcSingleSubscript(TRLSTREND, nsubs, subs);

			pvalue = mxCreateDoubleMatrix(1, 1, mxREAL);
			*mxGetPr(pvalue) = (double)trialstartend[i][j][0];
			mxSetFieldByNumber(TRLSTREND, index, 0, pvalue);

			pvalue = mxCreateDoubleMatrix(1, 1, mxREAL);
			*mxGetPr(pvalue) = (double)trialstartend[i][j][1];
			mxSetFieldByNumber(TRLSTREND, index, 1, pvalue);
		}

	}

	/* create a three-dim double array */
	/* --- doesn't work, problem with high dimsional array --- */
	//TRLSTREND = mxCreateNumericArray(3, dimstsed, mxDOUBLE_CLASS, mxREAL);
	//nsubs = mxGetNumberOfDimensions(TRLSTREND);
	//subs = (mwIndex *)mxCalloc(nsubs, sizeof(mwIndex));

	//for(i = 0; i < NUMCOND; i++)
	//{
	//	for(j = 0; j < MAXREPEAT; j++)
	//	{
	//		for(k = 0; k < 2; i++)
	//		{
	//			subs[0] = (mwIndex)i;
	//			subs[1] = (mwIndex)j;
	//			subs[2] = (mwIndex)k;
	//			index = mxCalcSingleSubscript(TRLSTREND, nsubs, subs);

	//			mxGetPr(TRLSTREND)[index] = (double)trialstartend[i][j][k];
	//		}
	//	}
	//}

	/* ==========================================
	/*  now output mean rate from Channel A
	/* ==========================================*/

	/* create a NUMCOND x 1 mxArray to copy data from meanratea*/
	MEANRATEA = mxCreateDoubleMatrix(SPEEDNUM, PERIODNUM, mxREAL);
	nsubs = mxGetNumberOfDimensions(MEANRATEA);
	subs = (mwIndex *)mxCalloc(nsubs, sizeof(mwIndex));

	for (i = 0; i < SPEEDNUM; i++)
	{
		for(j = 0; j < PERIODNUM; j++)
		{
			subs[0] = (mwSize)i;
			subs[1] = (mwSize)j;
			index = mxCalcSingleSubscript(MEANRATEA, nsubs, subs);

			mxGetPr(MEANRATEA)[index] = (double)meanratea[i][j];
		}
	}


	/* ==========================================
	/*  now output std rate from Channel A
	/* ==========================================*/

	/* create a NUMCOND x 1 mxArray to copy data from stdratea */
	STDRATEA = mxCreateDoubleMatrix(SPEEDNUM, PERIODNUM, mxREAL);
	nsubs = mxGetNumberOfDimensions(STDRATEA);
	subs = (mwIndex *)mxCalloc(nsubs, sizeof(mwIndex));

	for (i = 0; i < SPEEDNUM; i++)
	{
		for(j = 0; j < PERIODNUM; j++)
		{
			subs[0] = (mwSize)i;
			subs[1] = (mwSize)j;
			index = mxCalcSingleSubscript(STDRATEA, nsubs, subs);

			mxGetPr(STDRATEA)[index] = (double)stdratea[i][j];
		}
	}



	/* ==========================================
	/*  now output grating condition
	/* ==========================================*/

	/* create a 1x1 struct matrix for output  */
	GRTCOND = mxCreateStructArray((mwSize)2, dimsspp, NGRATGCONDFIELDS, gratcondfldnames);
	nsubs = mxGetNumberOfDimensions(GRTCOND);
	subs = (mwIndex *)mxCalloc(nsubs, sizeof(mwIndex));

	for(k = 0; k < NUMCOND; k++)
	{
		subs[0] = (mwIndex)0;
		subs[1] = (mwIndex)k;
		index = mxCalcSingleSubscript(GRTCOND, nsubs, subs);

		pvalue = mxCreateDoubleMatrix(1, 1, mxREAL);
		*mxGetPr(pvalue) = gratcond[k].speed;
		mxSetFieldByNumber(GRTCOND, index, 0, pvalue);

		pvalue = mxCreateDoubleMatrix(1, 1, mxREAL);
		*mxGetPr(pvalue) = gratcond[k].period;
		mxSetFieldByNumber(GRTCOND, index, 1, pvalue);

	}


	/* ==========================================
	/*  now output speed-period index
	/* ==========================================*/

	/* create a NUMCOND x 2 matrix for output  */
	SPEDPERDI = mxCreateDoubleMatrix((mwSize)NUMCOND, (mwSize)2, mxREAL);
	nsubs = mxGetNumberOfDimensions(SPEDPERDI);
	subs = (mwIndex *)mxCalloc(nsubs, sizeof(mwIndex));

	for(k = 0; k < NUMCOND; k++)
	{
		// speed index
		subs[0] = k;
		subs[1] = 0;
		index = mxCalcSingleSubscript(SPEDPERDI, nsubs, subs);
		mxGetPr(SPEDPERDI)[index] = (double)speedperiodidx[k][0];

		// period index
		subs[0] = k;
		subs[1] = 1;
		index = mxCalcSingleSubscript(SPEDPERDI, nsubs, subs);
		mxGetPr(SPEDPERDI)[index] = (double)speedperiodidx[k][1];
	}

	return;
}