/*==========================================================================
* Parse a single blankctrl chunk from the RF file recorded in microsaccade 
* blank-control experiment
*
* Copyright 2013 Richard J. Cui. Created: Sun 05/05/2013 11:03:53.755 AM
* $Revision: 0.1 $  $Date: Sun 05/05/2013 11:03:53.755 AM $
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
#define NSTIMFIELDS (sizeof(stimfldnames)/sizeof(*stimfldnames))		// 3
#define NTRIALFIELDS (sizeof(trialfldnames)/sizeof(*trialfldnames))		// 2

#define BCTCHUNKID (0xff | ('b' << 8))
#define SESSSTIMID (0xcc | ('s' << 8))
#define SESSTRIALID (0xcc | ('t' << 8))

#define NUMCOND 5
#define NUMTRIAL 60

/* Input Arguments */
#define RFFILE prhs[0]
#define POS prhs[1]		// chunk position

/* Output Arguments */
#define BCTENVVARS	plhs[0]		// info on contrast environment variables, see rf2blankctrl.c
#define SESSSTIM	plhs[1]		// session stimulus info, see rf2blankctrl.c
#define SESSTRIAL	plhs[2]		// session trial info, see rf2blankctrl.c

/* structure for blankctrl environment variables */
typedef struct bctEnvVars		// see savebctexp() in rf2blankctrl.c
{
	// fixation spot
	short	gazebox;
	short	stimsize;
	short	fixx;
	short	fixy;
	short	fixr;
	short	fixg;
	short	fixb;
	short	gazetime;

	// RF paras
	short	bangle;		// note: b - bar, but actually the grating
	short	bwidth;	
	short	blength;
	short	locx;
	short	locy;
	short	trialtime;

	// (3) foregraound/background colors, in rf2main.c
	short	lcolorsr;	// see rf2main.c
	short	lcolorsg;
	short	lcolorsb;	// combination of forgraound / background color

} bctEnvVars;

/* structure for stimulus information */
typedef struct stiminfo		// see strcut bactrial in rfblankctrl.c
{
	long	starttime;
	short	lumpercent, lumindex;

} stiminfo;

typedef stiminfo sessstim[NUMCOND][NUMTRIAL];

/* structure for session trial information */
typedef struct trialinfo
{
	short	numtried;	// total number of tried
	short	numsucc;	// number of trials succeeded
} trialinfo;

typedef trialinfo sesstrial[NUMCOND];

/*************************
* subroutines
*************************/

/*=======================
* read contrast chunk
=========================*/
void readBctChunk(
	char *fname,
	bctEnvVars *pbctEnvVars,
	sessstim *psessstim,
	sesstrial *psesstrial,
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
		/* check ID of bctConVars */
		fread(&id, sizeof(id),1,fp);
		//printf("Attempt conEnvVars id = %d\n", id);
		if(id == BCTCHUNKID)
		{
			fseek(fp, 2, SEEK_CUR);	// skip chunk length info
			fread(pbctEnvVars, sizeof(*pbctEnvVars), 1, fp);
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
	long pos;		// position of the chunk

	const char *fieldnames[] = {"gazebox", "stimsize", "fixx", "fixy", "fixr",
		                        "fixg", "fixb", "gazetime", "bangle", "bwidth",
								"blength", "locx", "locy", "trialtime", "lcolorsr", 
								"lcolorsg", "lcolorsb"};

	const char *stimfldnames[] = {"starttime", "lumpercent", "lumindex"};

	const char *trialfldnames[] = {"numtried", "numsucc"};

	mwSize		dims[2] = {1, NSTRUCTS};
	bctEnvVars	*pbctEnvVars;	// contrast environment variables
	
	mwSize		stimdims[2] =  {NUMCOND, NUMTRIAL};
	sessstim	SessStim;

	mwSize		trialdims[2] = {1,NUMCOND};
	sesstrial	SessTrial;

	mxArray		*pshort;
	mwSize		nsubs;
	mwIndex		index, *subs;
	int			con_i, trl_j;

	/* check for proper number of arguments */
	if(nrhs!=2) {
        mexErrMsgIdAndTxt("MyToolbox:arrayProduct:nrhs","Two inputs required.");
    }
    if(nlhs!=3) {
        mexErrMsgIdAndTxt("MyToolbox:arrayProduct:nlhs","Three output required.");
    }

	/* Input RF data file name */
	rfname = mxArrayToString(RFFILE);
	pos = (long)mxGetScalar(POS);

	pbctEnvVars = (bctEnvVars *)mxCalloc(1, sizeof(*pbctEnvVars));
	//psessstim = (sessstim *)mxCalloc(1, sizeof(*psessstim));
	readBctChunk(rfname, pbctEnvVars, &SessStim, &SessTrial, pos);

	/* ==========================================
	/*  now get the blankctrl environment vars
	/* ==========================================*/
	
	/* create a 1x1 struct matrix for output  */
	BCTENVVARS = mxCreateStructArray(2, dims, NFIELDS, fieldnames);
	
	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = pbctEnvVars->gazebox;
	mxSetFieldByNumber(BCTENVVARS, 0, 0, pshort);
	
	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = pbctEnvVars->stimsize;
	mxSetFieldByNumber(BCTENVVARS, 0, 1, pshort);
	
	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = pbctEnvVars->fixx;
	mxSetFieldByNumber(BCTENVVARS, 0, 2, pshort);

	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = pbctEnvVars->fixy;
	mxSetFieldByNumber(BCTENVVARS, 0, 3, pshort);

	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = pbctEnvVars->fixr;
	mxSetFieldByNumber(BCTENVVARS, 0, 4, pshort);

	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = pbctEnvVars->fixg;
	mxSetFieldByNumber(BCTENVVARS, 0, 5, pshort);

	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = pbctEnvVars->fixb;
	mxSetFieldByNumber(BCTENVVARS, 0, 6, pshort);

	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = pbctEnvVars->gazetime;
	mxSetFieldByNumber(BCTENVVARS, 0, 7, pshort);

	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = pbctEnvVars->bangle;
	mxSetFieldByNumber(BCTENVVARS, 0, 8, pshort);

	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = pbctEnvVars->bwidth;
	mxSetFieldByNumber(BCTENVVARS, 0, 9, pshort);

	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = pbctEnvVars->blength;
	mxSetFieldByNumber(BCTENVVARS, 0, 10, pshort);

	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = pbctEnvVars->locx;
	mxSetFieldByNumber(BCTENVVARS,0, 11, pshort);
	
	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = pbctEnvVars->locy;
	mxSetFieldByNumber(BCTENVVARS,0, 12, pshort);

	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = pbctEnvVars->trialtime;
	mxSetFieldByNumber(BCTENVVARS, 0, 13, pshort);

	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = pbctEnvVars->lcolorsr;
	mxSetFieldByNumber(BCTENVVARS, 0, 14, pshort);

	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = pbctEnvVars->lcolorsg;
	mxSetFieldByNumber(BCTENVVARS, 0, 15, pshort);

	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = pbctEnvVars->lcolorsb;
	mxSetFieldByNumber(BCTENVVARS, 0, 16, pshort);

	mxFree((void *)pbctEnvVars);

	/* ==========================================
	/*  now visual stimulus info
	/* ==========================================*/
	SESSSTIM = mxCreateStructArray((mwSize)2, stimdims, NSTIMFIELDS, stimfldnames);
	nsubs = mxGetNumberOfDimensions(SESSSTIM);
	subs = (mwIndex *)mxCalloc(nsubs, sizeof(mwIndex));

	for(con_i = 0; con_i < NUMCOND; con_i++)
	{
		for(trl_j = 0; trl_j < NUMTRIAL; trl_j++)
		{
			mxArray	*stim_value;

			subs[0] = (mwIndex)con_i;
			subs[1] = (mwIndex)trl_j;
			index = mxCalcSingleSubscript(SESSSTIM, nsubs, subs);

			stim_value = mxCreateDoubleMatrix(1, 1, mxREAL);
			*mxGetPr(stim_value) = SessStim[con_i][trl_j].starttime;
			mxSetFieldByNumber(SESSSTIM, index, 0, stim_value);

			stim_value = mxCreateDoubleMatrix(1, 1, mxREAL);
			*mxGetPr(stim_value) = SessStim[con_i][trl_j].lumpercent;
			mxSetFieldByNumber(SESSSTIM, index, 1, stim_value);

			stim_value = mxCreateDoubleMatrix(1, 1, mxREAL);
			*mxGetPr(stim_value) = SessStim[con_i][trl_j].lumindex;
			mxSetFieldByNumber(SESSSTIM, index, 2, stim_value);

		}
	}

	/* ==========================================
	/*  now trial info
	/* ==========================================*/
	SESSTRIAL = mxCreateStructArray((mwSize)2, trialdims, NTRIALFIELDS, trialfldnames);
	nsubs = mxGetNumberOfDimensions(SESSTRIAL);
	subs = (mwIndex *)mxCalloc(nsubs, sizeof(mwIndex));

	for(con_i = 0; con_i < NUMCOND; con_i++)
	{
		mxArray *trial_value;

		subs[0] = (mwIndex)0;
		subs[1] = (mwIndex)con_i;
		index = mxCalcSingleSubscript(SESSTRIAL, nsubs, subs);

		trial_value = mxCreateDoubleMatrix(1, 1, mxREAL);
		*mxGetPr(trial_value) = SessTrial[con_i].numtried;
		mxSetFieldByNumber(SESSTRIAL, index, 0, trial_value);

		trial_value = mxCreateDoubleMatrix(1, 1, mxREAL);
		*mxGetPr(trial_value) = SessTrial[con_i].numsucc;
		mxSetFieldByNumber(SESSTRIAL, index, 1, trial_value);
	}


	return;
}