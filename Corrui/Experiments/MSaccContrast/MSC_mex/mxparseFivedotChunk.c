/*==========================================================================
* Parse a single fivedot chunk from the RF file for Windows OS
*
* Copyright 2014 Richard J. Cui. Created: Tue 04/08/2014  4:31:03.886 PM
* $Revision: 0.1 $  $Date: Tue 04/08/2014  4:31:03.886 PM $
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
#define FDOTCHUNKID (0xff | ('P' << 8))		// Fivedot chunk ID

/* Input Arguments */
#define RFFILE prhs[0]	// chunk RF filename
#define POS prhs[1]		// chunk position

/* Output Arguments */
#define FDOTENVVARS	plhs[0]		// info on fivedot environment variables, see rf25dot.c

/* structure for fivedot environment variables */
typedef struct fdtEnvVars		// see savefivedot() in rf25dot.c
{
	short	picnumber;
	short	stimsize;
	short	spreadsize;

	// spares
	short	spare0;
	short	spare1;
	short	spare2;

	// foregraound/background colors, in rf2main.c
	short	lcolorsr;	// see rf2main.c
	short	lcolorsg;
	short	lcolorsb;	// combination of forgraound / background color

	// spare
    short   spare3;

} fdtEnvVars;

/*************************
* subroutines
*************************/

/*=======================
* read fivedot chunk
=========================*/
void readFdtChunk(
	char		*fname,
	fdtEnvVars	*pfdtEnvVars,
	long        pos
	)
{
	FILE *fp;
	short id;

	/*  now read and test */
	fp = fopen(fname, "rb");
	if(fp != NULL)
	{
		fseek(fp, pos, SEEK_SET);       // set read pointer to the beginning of the chun
		fread(&id, sizeof(id),1,fp);    // read in fivedot chunk ID

        if(id == FDOTCHUNKID)
		{
			fseek(fp, 2, SEEK_CUR);	// skip chunk length info = 24 char of fivedot chunk
			fread(pfdtEnvVars, sizeof(*pfdtEnvVars), 1, fp);
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

	const char *fieldnames[] = {
		"picnumber", "stimsize", "spreadsize", "spare0", "spare1", 
        "spare2", "forecolorr", "backcolorr", "forecolorg", "backcolorg", 
        "forecolorb", "backcolorb", "spare3" 
	};

	mwSize		dims[2] = {1, NSTRUCTS};
	fdtEnvVars	*pfdtEnvVars;	// fivedot environment variables
	mxArray		*pshort;

	/* check for proper number of arguments */
	if(nrhs!=2) {
        mexErrMsgIdAndTxt("FivedotChunk:arrayProduct:nrhs","Two inputs required.");
    }
    if(nlhs!=1) {
        mexErrMsgIdAndTxt("FivedotChunk:arrayProduct:nlhs","One output required.");
    }

	/* Input RF data file name */
	rfname = mxArrayToString(RFFILE);
	pos = (long)mxGetScalar(POS);

	pfdtEnvVars = (fdtEnvVars *)mxCalloc(1, sizeof(*pfdtEnvVars));
	readFdtChunk(rfname, pfdtEnvVars, pos);

	/* ==========================================
	 *  now get the diag (star) environment vars
	 * ==========================================*/
	// create a 1x1 struct matrix for output
	FDOTENVVARS = mxCreateStructArray(2, dims, NFIELDS, fieldnames);
	
	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = pfdtEnvVars->picnumber;
	mxSetFieldByNumber(FDOTENVVARS, 0, 0, pshort);
	
	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = pfdtEnvVars->stimsize;
	mxSetFieldByNumber(FDOTENVVARS, 0, 1, pshort);
	
	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = pfdtEnvVars->spreadsize;
	mxSetFieldByNumber(FDOTENVVARS, 0, 2, pshort);

	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = pfdtEnvVars->spare0;
	mxSetFieldByNumber(FDOTENVVARS, 0, 3, pshort);

	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = pfdtEnvVars->spare1;
	mxSetFieldByNumber(FDOTENVVARS, 0, 4, pshort);

	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = pfdtEnvVars->spare2;
	mxSetFieldByNumber(FDOTENVVARS, 0, 5, pshort);

	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = pfdtEnvVars->lcolorsr & 0xff;
	mxSetFieldByNumber(FDOTENVVARS, 0, 6, pshort);

	pshort = mxCreateDoubleMatrix(1,1,mxREAL);
    *mxGetPr(pshort) = (pfdtEnvVars->lcolorsr >> 8) & 0xff;
	mxSetFieldByNumber(FDOTENVVARS, 0, 7, pshort);

    pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = pfdtEnvVars->lcolorsg & 0xff;
	mxSetFieldByNumber(FDOTENVVARS, 0, 8, pshort);

    pshort = mxCreateDoubleMatrix(1,1,mxREAL);
    *mxGetPr(pshort) = (pfdtEnvVars->lcolorsg >> 8) & 0xff;
	mxSetFieldByNumber(FDOTENVVARS, 0, 9, pshort);

    pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = pfdtEnvVars->lcolorsb & 0xff;
	mxSetFieldByNumber(FDOTENVVARS, 0, 10, pshort);

    pshort = mxCreateDoubleMatrix(1,1,mxREAL);
    *mxGetPr(pshort) = (pfdtEnvVars->lcolorsb >> 8) & 0xff;
	mxSetFieldByNumber(FDOTENVVARS, 0, 11, pshort);

    pshort = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(pshort) = pfdtEnvVars->spare3;
	mxSetFieldByNumber(FDOTENVVARS, 0, 12, pshort);

	mxFree((void *)pfdtEnvVars);

	return;
}