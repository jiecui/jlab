/*==========================================================================
* Parse a single contrast chunk from the RF file recorded in microsaccade 
* contrast experiment
*
* Copyright 2014 Richard J. Cui. Created: 11/01/2011  4:34:14.902 PM
* $Revision: 0.2 $  $Date: Sun 03/23/2014 12:26:47.500 PM $
*
* Visual Neuroscience Lab (Dr. Martinez-Conde)
* Barrow Neurological Institute
* 350 W Thomas Road
* Phoenix AZ 85013, USA
*
* Email: jie@neurocorrleate.com
*===========================================================================*/

#include <stdio.h>
#include <string.h>
#include "mex.h"
#include "matrix.h"

/* General Definations */
#define NSTRUCTS 1

#define NFIELDS (sizeof(fieldnames)/sizeof(*fieldnames))
#define NSTIMFIELDS (sizeof(stimfldnames)/sizeof(*stimfldnames))	// 11
#define NTRIALFIELDS (sizeof(trialfldnames)/sizeof(*trialfldnames))		// 2

#define CONCHUNKID (0xff | ('m' << 8))
#define SESSSTIMID (0xcc | ('s' << 8))
#define SESSTRIALID (0xcc | ('t' << 8))

#define NUMLEVEL 11
#define NUMTRIAL NUMLEVEL * NUMLEVEL + 1
#define NUMREPEAT 10

/* Input Arguments */
#define RFFILE prhs[0]
#define POS prhs[1]		// chunk position

/* Output Arguments */
#define CONENVVARS	plhs[0]		// info on contrast environment variables, see rf2cont.c
#define SESSSTIM	plhs[1]		// session stimulus info, see rf2cont.c
#define SESSTRIAL	plhs[2]		// session trial info, see rf2cont.c

/* structure for contrast environment variables */
typedef struct conEnvVars		// see saveconexp() in rf2cont.c
{
	
	short	gazebox;
	short	stimsize;
	short	fixx;
	short	fixy;
	short	fixr;
	short	fixg;
	short	fixb;
	short	gazetime;
	short	bangle;		// note: b - bar, but actually the grating
	short	bwidth;	
	short	blength;
	short	locx;
	short	locy;
	short	period;
	short	speed;
	short	mingray;
	short	maxgray;
	short	grattime;
	short	lcolorsr;	// see rf2main.c
	short	lcolorsg;
	short	lcolorsb;	// combination of forgraound / background color

} conEnvVars;

/* structure for stimulus information */
typedef struct stiminfo		// see rf2cont.c
{
	short	cyclenum;		// cycle number
	short	trialnum;		// trial number

	int32_t	thistim0;
	short	mingray0, maxgray0;

	int32_t	thistime1;
	short	mingray1, maxgray1;

	int32_t	thistime2;
	short	mingray2, maxgray2;

} stiminfo;

typedef stiminfo sessstim[NUMREPEAT][NUMTRIAL];

/* structure for session trial information */
typedef struct trialinfo
{
	short	numtried;	// total number of tried
	short	numsucc;	// number of trials succeeded
} trialinfo;

typedef trialinfo sesstrial[NUMREPEAT];

/*************************
* subroutines
*************************/

/*=======================
* read contrast chunk
=========================*/
void readConChunk(
	char *fname,
	conEnvVars *pconEnvVars,
	sessstim *psessstim,
	sesstrial *psesstrial,
	int32_t pos
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
		/* check ID of conConVars */
		fread(&id, sizeof(id),1,fp);
		//printf("Attempt conEnvVars id = %d\n", id);
		if(id == CONCHUNKID)
		{
			fseek(fp, 2, SEEK_CUR);	// skip chunk length info
			fread(pconEnvVars, sizeof(*pconEnvVars), 1, fp);
		}

		/* check ID of session stimulus info */
		fread(&id, sizeof(id), 1, fp);
		//printf("Attempt SessStim id = %d\n", id);
		if(id == SESSSTIMID)
		{
			fread(psessstim, sizeof(*psessstim), 1, fp);
		}

		fread(&id, sizeof(id),1, fp);
		//printf("Attempt SessTrial id = %d\n", id);
		if(id == SESSTRIALID)
		{
			fread(psesstrial, sizeof(*psesstrial), 1, fp);
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
	char    *rfname;			// rf2 data file name
	int32_t pos;		// position of the chunk

	const char *fieldnames[] = {"gazebox", "stimsize", "fixx", "fixy", "fixr",
		                        "fixg", "fixb", "gazetime", "bangle", "bwidth",
								"blength", "locx", "locy", "period", "speed",
								"mingray", "maxgray", "grattime", "lcolorsr", 
								"lcolorsg", "lcolorsb"};

	const char *stimfldnames[] = {"cyclenum", "trialnum", 
								  "thistime0", "mingray0", "maxgray0",
								  "thistime1", "mingray1", "maxgray1",
								  "thistime2", "mingray2", "maxgray2"};

	const char *trialfldnames[] = {"numtried", "numsucc"};

	mwSize		dims[2] = {1, NSTRUCTS};
	conEnvVars	*pconEnvVars;	// contrast environment variables
	
	mwSize		stimdims[2] =  {NUMREPEAT, NUMTRIAL};
	sessstim	SessStim;

	mwSize		trialdims[2] = {1,NUMREPEAT};
	sesstrial	SessTrial;

	mxArray		*pshort;
	mwSize		nsubs;
	mwIndex		index, *subs;
	int			cyc_i, trl_j;

	/* check for proper number of arguments */
	if(nrhs!=2) {
        mexErrMsgIdAndTxt("MyToolbox:arrayProduct:nrhs","Two inputs required.");
    }
    if(nlhs!=3) {
        mexErrMsgIdAndTxt("MyToolbox:arrayProduct:nlhs","Three output required.");
    }

	/* Input RF data file name */
	rfname = mxArrayToString(RFFILE);
	pos = (int32_t)mxGetScalar(POS);

	pconEnvVars = (conEnvVars *)mxCalloc(1, sizeof(*pconEnvVars));
	//psessstim = (sessstim *)mxCalloc(1, sizeof(*psessstim));
	readConChunk(rfname, pconEnvVars, &SessStim, &SessTrial, pos);

	/* ==========================================
	 *  now get the contrast environment vars
	 * ==========================================*/
	
	/* create a 1x1 struct matrix for output  */
	CONENVVARS = mxCreateStructArray(2, dims, NFIELDS, fieldnames);
	
	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = pconEnvVars->gazebox;
	mxSetFieldByNumber(CONENVVARS, 0, 0, pshort);
	
	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = pconEnvVars->stimsize;
	mxSetFieldByNumber(CONENVVARS, 0, 1, pshort);
	
	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = pconEnvVars->fixx;
	mxSetFieldByNumber(CONENVVARS, 0, 2, pshort);

	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = pconEnvVars->fixy;
	mxSetFieldByNumber(CONENVVARS, 0, 3, pshort);

	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = pconEnvVars->fixr;
	mxSetFieldByNumber(CONENVVARS, 0, 4, pshort);

	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = pconEnvVars->fixg;
	mxSetFieldByNumber(CONENVVARS, 0, 5, pshort);

	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = pconEnvVars->fixb;
	mxSetFieldByNumber(CONENVVARS, 0, 6, pshort);

	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = pconEnvVars->gazetime;
	mxSetFieldByNumber(CONENVVARS, 0, 7, pshort);

	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = pconEnvVars->bangle;
	mxSetFieldByNumber(CONENVVARS, 0, 8, pshort);

	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = pconEnvVars->bwidth;
	mxSetFieldByNumber(CONENVVARS, 0, 9, pshort);

	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = pconEnvVars->blength;
	mxSetFieldByNumber(CONENVVARS, 0, 10, pshort);

	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = pconEnvVars->locx;
	mxSetFieldByNumber(CONENVVARS,0, 11, pshort);
	
	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = pconEnvVars->locy;
	mxSetFieldByNumber(CONENVVARS,0, 12, pshort);

	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = pconEnvVars->period;
	mxSetFieldByNumber(CONENVVARS, 0, 13, pshort);

	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = pconEnvVars->speed;
	mxSetFieldByNumber(CONENVVARS, 0, 14, pshort);

	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = pconEnvVars->mingray;
	mxSetFieldByNumber(CONENVVARS, 0, 15, pshort);

	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = pconEnvVars->maxgray;
	mxSetFieldByNumber(CONENVVARS, 0, 16, pshort);

	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = pconEnvVars->grattime;
	mxSetFieldByNumber(CONENVVARS, 0, 17, pshort);

	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = pconEnvVars->lcolorsr;
	mxSetFieldByNumber(CONENVVARS, 0, 18, pshort);

	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = pconEnvVars->lcolorsg;
	mxSetFieldByNumber(CONENVVARS, 0, 19, pshort);

	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = pconEnvVars->lcolorsb;
	mxSetFieldByNumber(CONENVVARS, 0, 20, pshort);

	mxFree((void *)pconEnvVars);

	/* ==========================================
	 *  now visual stimulus info
	 * ==========================================*/
	SESSSTIM = mxCreateStructArray((mwSize)2, stimdims, NSTIMFIELDS, stimfldnames);
	nsubs = mxGetNumberOfDimensions(SESSSTIM);
	subs = (mwIndex *)mxCalloc(nsubs, sizeof(mwIndex));

	for(cyc_i = 0; cyc_i < NUMREPEAT; cyc_i++)
	{
		for(trl_j = 0; trl_j < NUMTRIAL; trl_j++)
		{
			mxArray	*stim_value;

			subs[0] = (mwIndex)cyc_i;
			subs[1] = (mwIndex)trl_j;
			index = mxCalcSingleSubscript(SESSSTIM, nsubs, subs);

			stim_value = mxCreateDoubleMatrix(1, 1, mxREAL);
			*mxGetPr(stim_value) = SessStim[cyc_i][trl_j].cyclenum;
			mxSetFieldByNumber(SESSSTIM, index, 0, stim_value);

			stim_value = mxCreateDoubleMatrix(1, 1, mxREAL);
			*mxGetPr(stim_value) = SessStim[cyc_i][trl_j].trialnum;
			mxSetFieldByNumber(SESSSTIM, index, 1, stim_value);

			stim_value = mxCreateDoubleMatrix(1, 1, mxREAL);
			*mxGetPr(stim_value) = SessStim[cyc_i][trl_j].thistim0;
			mxSetFieldByNumber(SESSSTIM, index, 2, stim_value);

			stim_value = mxCreateDoubleMatrix(1, 1, mxREAL);
			*mxGetPr(stim_value) = SessStim[cyc_i][trl_j].mingray0;
			mxSetFieldByNumber(SESSSTIM, index, 3, stim_value);

			stim_value = mxCreateDoubleMatrix(1, 1, mxREAL);
			*mxGetPr(stim_value) = SessStim[cyc_i][trl_j].maxgray0;
			mxSetFieldByNumber(SESSSTIM, index, 4, stim_value);

			stim_value = mxCreateDoubleMatrix(1, 1, mxREAL);
			*mxGetPr(stim_value) = SessStim[cyc_i][trl_j].thistime1;
			mxSetFieldByNumber(SESSSTIM, index, 5, stim_value);

			stim_value = mxCreateDoubleMatrix(1, 1, mxREAL);
			*mxGetPr(stim_value) = SessStim[cyc_i][trl_j].mingray1;
			mxSetFieldByNumber(SESSSTIM, index, 6, stim_value);

			stim_value = mxCreateDoubleMatrix(1, 1, mxREAL);
			*mxGetPr(stim_value) = SessStim[cyc_i][trl_j].maxgray1;
			mxSetFieldByNumber(SESSSTIM, index, 7, stim_value);

			stim_value = mxCreateDoubleMatrix(1, 1, mxREAL);
			*mxGetPr(stim_value) = SessStim[cyc_i][trl_j].thistime2;
			mxSetFieldByNumber(SESSSTIM, index, 8, stim_value);

			stim_value = mxCreateDoubleMatrix(1, 1, mxREAL);
			*mxGetPr(stim_value) = SessStim[cyc_i][trl_j].mingray2;
			mxSetFieldByNumber(SESSSTIM, index, 9, stim_value);

			stim_value = mxCreateDoubleMatrix(1, 1, mxREAL);
			*mxGetPr(stim_value) = SessStim[cyc_i][trl_j].maxgray2;
			mxSetFieldByNumber(SESSSTIM, index, 10, stim_value);

		}
	}

	/* ==========================================
	 *  now trial info
	 * ==========================================*/
	SESSTRIAL = mxCreateStructArray((mwSize)2, trialdims, NTRIALFIELDS, trialfldnames);
	nsubs = mxGetNumberOfDimensions(SESSTRIAL);
	subs = (mwIndex *)mxCalloc(nsubs, sizeof(mwIndex));

	for(cyc_i = 0; cyc_i < NUMREPEAT; cyc_i++)
	{
		mxArray *trial_value;

		subs[0] = (mwIndex)0;
		subs[1] = (mwIndex)cyc_i;
		index = mxCalcSingleSubscript(SESSTRIAL, nsubs, subs);

		trial_value = mxCreateDoubleMatrix(1, 1, mxREAL);
		*mxGetPr(trial_value) = SessTrial[cyc_i].numtried;
		mxSetFieldByNumber(SESSTRIAL, index, 0, trial_value);

		trial_value = mxCreateDoubleMatrix(1, 1, mxREAL);
		*mxGetPr(trial_value) = SessTrial[cyc_i].numsucc;
		mxSetFieldByNumber(SESSTRIAL, index, 1, trial_value);
	}


	return;
}