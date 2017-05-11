/*=============================================================================
* Parse a single Spike and Eye chunk from the RF file recorded in microsaccade 
* contrast experiment
*
* Copyright 2011 - 2014 Richard J. Cui. Created: Sun 11/20/2011 10:50:33.569 PM
* $Revision: 0.3 $  $Date: Sat 03/22/2014  7:25:37.228 PM $
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
#define MAXLENGTH	8192
#define CEYE1		10
#define	CEYE2		6
#define CSPIKEA		20
#define CSPIKEB		21
#define CSTIMON1	30
#define	CSTIMOFF1	40
#define CSTIMON2	31
#define CSTIMOFF2	41
#define CBARXY		50
#define CGRATPERIDX	60

#define NSTRUCTS	1
#define NFIELDS (sizeof(fieldnames)/sizeof(*fieldnames))

#define SAECHUNKID (0xff | ('t' << 8))		// should be TIMESTAMP chunk

/* Input Arguments */
#define RFFILE prhs[0]
#define POS prhs[1]		// chunk position

/* Output Arguments */
#define SPIKEANDEYE	plhs[0]		// spike and eye information, see rf2intr.c

/* structure for spike and eye data */
typedef struct SAEChunkHead
{
	unsigned short	chunk_id;			// should be (0xff | ('t' << 8))
	unsigned short	chunk_length;		// length of this SAE chunk in bytes
	unsigned short	data_start;			// Spike and eye data-unit start address. This is an offset from the beginning of chunk.
	unsigned short	long_flag;			// whether the type of data is coded in long words (4 bytes) or short words (2 bytes). = 1, using 4 bytes  = 0, using 2 bytes
	unsigned short	stim_type;			// type of stimulus
	unsigned short	data_info;			// information of the data
	unsigned char	idle[8];			// not used currently
	unsigned short	max_eye_res;		// maximum resolution of eye position

} SAEChunkHead;

typedef struct SpikeAndEye
{
	unsigned short	stim_type;			// type of stimulus
	unsigned short	data_info;			// information of the data
	unsigned short	max_eye_res;		// maximum resolution of eye position
    uint32_t        time[MAXLENGTH];    // time stamps/instants of data_unit
    uint32_t        spike_time[MAXLENGTH];  // time stamps of spikes
	unsigned short	eye_x1[MAXLENGTH];	// eye-x
	unsigned short	eye_y1[MAXLENGTH];	// eye-y
	unsigned short	eye_x2[MAXLENGTH];	// eye-x
	unsigned short	eye_y2[MAXLENGTH];	// eye-y
	unsigned short	stim_x1[MAXLENGTH];			//
	unsigned short	stim_y1[MAXLENGTH];			//
    uint32_t        stim_tON1[MAXLENGTH];
    uint32_t        stim_tOFF1[MAXLENGTH];
	unsigned short	stim_x2[MAXLENGTH];			//
	unsigned short	stim_y2[MAXLENGTH];			//
    uint32_t        stim_tON2[MAXLENGTH];
    uint32_t        stim_tOFF2[MAXLENGTH];		//
	unsigned short	plainbar_x[MAXLENGTH];		// if available, x position of plain bar
	unsigned short	plainbar_y[MAXLENGTH];		// if available, y position of plain bar
	unsigned short	periodidx[MAXLENGTH];		// period index (phase) of (Gabor) gratings

} SpikeAndEye;

typedef struct counter
{
	unsigned short	time;
	unsigned short	spike_time;
	unsigned short	eye_x1;	// eye-x
	unsigned short	eye_y1;	// eye-y
	unsigned short	eye_x2;	// eye-x
	unsigned short	eye_y2;	// eye-y
	unsigned short	stim_x1;		//
	unsigned short	stim_y1;		//
	unsigned short	stim_tON1;		//
	unsigned short	stim_tOFF1;		//
	unsigned short	stim_x2;		//
	unsigned short	stim_y2;		//
	unsigned short	stim_tON2;		//
	unsigned short	stim_tOFF2;		//
	unsigned short	plainbar_x;		// if available, x position of plain bar
	unsigned short	plainbar_y;		// if available, y position of plain bar
	unsigned short	periodidx;		// period index (phase) of (Gabor) gratings

} counter;


/*************************
* subroutines
*************************/

/*=======================
* read spike and eye chunk
=========================*/
bool readSAEChunk(
	char *fname,
	SpikeAndEye *pspikeandeye,
	counter *pcounter,
	int32_t pos
	)
{
	FILE	*fp;
	// errno_t	err;
	unsigned short	c;
	short	sdata_type;
	int32_t	fpointer, nextchunkstart,ldata_type;
	uint32_t        time, last_time = 0;
	unsigned short	eye_x1, eye_y1, eye_x2, eye_y2;
	unsigned short	stim_x1, stim_y1;
	unsigned short	stim_x2, stim_y2;
	unsigned short	plainbar_x, plainbar_y, periodidx;
	SAEChunkHead head;

	/*  now read and test */
	// err = fopen_s(&fp, fname, "rb");
    fp = fopen(fname, "rb");
	// if(!err)
    if(fp != NULL)
	{
		fseek(fp, pos, SEEK_SET);	// set read pointer to the beginning of the chunk
		fread(&head, sizeof(head), 1, fp);	// read in SAE chunk head

		/* assemble SAE chunk data */
		if(head.chunk_id == SAECHUNKID)
		{
			pspikeandeye->data_info		= head.data_info;
			pspikeandeye->max_eye_res	= head.max_eye_res;
			pspikeandeye->stim_type		= head.stim_type;

			/* now assemble other data */
			nextchunkstart = pos + head.chunk_length;
			fpointer = pos + head.data_start;
			fseek(fp, fpointer, SEEK_SET);			// set pointer

			while(fpointer < nextchunkstart)
			{
				/* time stamp */
				fread(&time, sizeof(time), 1, fp);	// read current time
				if(time != last_time)
				{
					c = pcounter->time;
					pspikeandeye->time[c] = time;
					last_time = time;
					pcounter->time = ++c;
					if(c > MAXLENGTH)
						printf("Data length is larger than upper limits!\n");
				}

				/* data type */
				sdata_type = 0;
				ldata_type = 0;
				if(head.long_flag)
					fread(&ldata_type, sizeof(ldata_type), 1, fp);
				else
					fread(&sdata_type, sizeof(sdata_type), 1, fp);

				/* extract data */
				switch(sdata_type | ldata_type)
				{
				case CBARXY:
					fread(&plainbar_x, sizeof(plainbar_x), 1, fp);
					c = pcounter->plainbar_x;
					pspikeandeye->plainbar_x[c] = plainbar_x;
					pcounter->plainbar_x = ++c;
					if(c > MAXLENGTH)
						printf("Data length is larger than upper limits!\n");

					fread(&plainbar_y, sizeof(plainbar_y), 1, fp);
					c = pcounter->plainbar_y;
					pspikeandeye->plainbar_y[c] = plainbar_y;
					pcounter->plainbar_y = ++c;
					if(c > MAXLENGTH)
						printf("Data length is larger than upper limits!\n");

					break;
				case CGRATPERIDX:
					fread(&periodidx, sizeof(periodidx), 1, fp);
					c = pcounter->periodidx;
					pspikeandeye->periodidx[c] = periodidx;
					pcounter->periodidx = ++c;
					if(c > MAXLENGTH)
						printf("Data length is larger than upper limits!\n");

					break;
				case CEYE1:
					fread(&eye_x1, sizeof(eye_x1), 1, fp);
					c = pcounter->eye_x1;
					pspikeandeye->eye_x1[c] = eye_x1;
					pcounter->eye_x1 = ++c;
					if(c > MAXLENGTH)
						printf("Data length is larger than upper limits!\n");

					fread(&eye_y1, sizeof(eye_y1), 1, fp);
					c = pcounter->eye_y1;
					pspikeandeye->eye_y1[c] = eye_y1;
					pcounter->eye_y1 = ++c;
					if(c > MAXLENGTH)
						printf("Data length is larger than upper limits!\n");

					break;
				case CEYE2:
					fread(&eye_x2, sizeof(eye_x2), 1, fp);
					c = pcounter->eye_x2;
					pspikeandeye->eye_x2[c] = eye_x2;
					pcounter->eye_x2 = ++c;
					if(c > MAXLENGTH)
						printf("Data length is larger than upper limits!\n");

					fread(&eye_y2, sizeof(eye_y2), 1, fp);
					c = pcounter->eye_y2;
					pspikeandeye->eye_y2[c] = eye_y2;
					pcounter->eye_y2 = ++c;
					if(c > MAXLENGTH)
						printf("Data length is larger than upper limits!\n");

					break;
				case CSPIKEA:
					c = pcounter->spike_time;
					pspikeandeye->spike_time[c] = time;
					pcounter->spike_time = ++c;
					if(c > MAXLENGTH)
						printf("Data length is larger than upper limits!\n");

					break;
				case CSPIKEB:

					break;
				case CSTIMON1:
					c = pcounter->stim_tON1;
					pspikeandeye->stim_tON1[c] = time;
					pcounter->stim_tON1 = ++c;
					if(c > MAXLENGTH)
						printf("Data length is larger than upper limits!\n");

					c = pcounter->stim_x1;
					fread(&stim_x1, sizeof(stim_x1), 1, fp);
					pspikeandeye->stim_x1[c] = stim_x1;
					pcounter->stim_x1 = ++c;
					if(c > MAXLENGTH)
						printf("Data length is larger than upper limits!\n");

					c = pcounter->stim_y1;
					fread(&stim_y1, sizeof(stim_y1), 1, fp);
					pspikeandeye->stim_y1[c] = stim_y1;
					pcounter->stim_y1 = ++c;
					if(c > MAXLENGTH)
						printf("Data length is larger than upper limits!\n");

					break;
				case CSTIMON2:
					c = pcounter->stim_tON2;
					pspikeandeye->stim_tON2[c] = time;
					pcounter->stim_tON2 = ++c;
					if(c > MAXLENGTH)
						printf("Data length is larger than upper limits!\n");

					c = pcounter->stim_x2;
					fread(&stim_x2, sizeof(stim_x2), 1, fp);
					pspikeandeye->stim_x2[c] = stim_x2;
					pcounter->stim_x2 = ++c;
					if(c > MAXLENGTH)
						printf("Data length is larger than upper limits!\n");

					c = pcounter->stim_y2;
					fread(&stim_y2, sizeof(stim_y2), 1, fp);
					pspikeandeye->stim_y2[c] = stim_y2;
					pcounter->stim_y2 = ++c;
					if(c > MAXLENGTH)
						printf("Data length is larger than upper limits!\n");

					break;
				case CSTIMOFF1:
					c = pcounter->stim_tOFF1;
					pspikeandeye->stim_tOFF1[c] = time;
					pcounter->stim_tOFF1 = ++c;
					if(c > MAXLENGTH)
						printf("Data length is larger than upper limits!\n");

					break;
				case CSTIMOFF2:
					c = pcounter->stim_tOFF2;
					pspikeandeye->stim_tOFF2[c] = time;
					pcounter->stim_tOFF2 = ++c;
					if(c > MAXLENGTH)
						printf("Data length is larger than upper limits!\n");

					break;
				default:
					printf("Unexpected data type! Data chunk is discarded..\n");
					fclose(fp);
					return false;

				}
				fpointer = ftell(fp);
			}
		}
		fclose(fp);
		return true;
	}
	else
	{
		printf("Cannot open %s.\n",fname);
		return false;
	}
}

/*************************
* The Gateway Function
**************************/
void mexFunction(
	int nlhs, mxArray *plhs[],
	int nrhs, const mxArray *prhs[] )

{
	char *rfname;	// rf2 data file name
	int32_t pos;		// position of the chunk

	counter sae_counter = {0};
	const char *fieldnames[] = {"stim_type", "data_info", "max_eye_res", "time", "spike_time",
		"eye_x1", "eye_y1", "eye_x2", "eye_y2", "stim_x1", "stim_y1", "stim_tON1", "stim_OFF1",
		"stim_x2", "stim_y2", "stim_tON2", "stim_OFF2", "plainbar_x", "plainbar_y", "periodidx"};
	SpikeAndEye	sae = {0};

	mwSize	dims[2] = {1, NSTRUCTS};
	mwSize	k, arraysize;
	mxArray	*pscale, *parray;


	/* check for proper number of arguments */
	if(nrhs!=2) {
		mexErrMsgIdAndTxt("MyToolbox:arrayProduct:nrhs","Two inputs required.");
	}
	if(nlhs!=1) {
		mexErrMsgIdAndTxt("MyToolbox:arrayProduct:nlhs","One output required.");
	}

	/* create a 1x1 struct matrix for output  */
	SPIKEANDEYE = mxCreateStructArray(2, dims, NFIELDS, fieldnames);

	/* Input RF data file name */
	rfname = mxArrayToString(RFFILE);
	pos = (int32_t)mxGetScalar(POS);

	if(readSAEChunk(rfname, &sae, &sae_counter, pos))
	{
		/* ==========================================
		 *  now get the Spike and Eye chunk data
		 * ==========================================*/
		pscale = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pscale) = sae.stim_type;
		mxSetFieldByNumber(SPIKEANDEYE, 0, 0, pscale);

		pscale = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pscale) = sae.data_info;
		mxSetFieldByNumber(SPIKEANDEYE, 0, 1, pscale);

		pscale = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(pscale) = sae.max_eye_res;
		mxSetFieldByNumber(SPIKEANDEYE, 0, 2, pscale);

		arraysize = (mwSize)sae_counter.time;
		if( arraysize > 0 )
		{
			parray = mxCreateDoubleMatrix(arraysize, 1, mxREAL);
			for(k = 0; k < arraysize; k++)
				mxGetPr(parray)[k] = sae.time[k];
			mxSetFieldByNumber(SPIKEANDEYE, 0, 3, parray);
		}

		arraysize = (mwSize)sae_counter.spike_time;
		if( arraysize > 0 )
		{
			parray = mxCreateDoubleMatrix(arraysize, 1, mxREAL);
			for(k = 0; k < arraysize; k++)
				mxGetPr(parray)[k] = sae.spike_time[k];
			mxSetFieldByNumber(SPIKEANDEYE, 0, 4, parray);
		}

		arraysize = (mwSize)sae_counter.eye_x1;
		if( arraysize > 0 )
		{
			parray = mxCreateDoubleMatrix(arraysize, 1, mxREAL);
			for(k = 0; k < arraysize; k++)
				mxGetPr(parray)[k] = sae.eye_x1[k];
			mxSetFieldByNumber(SPIKEANDEYE, 0, 5, parray);
		}

		arraysize = (mwSize)sae_counter.eye_y1;
		if( arraysize > 0 )
		{
			parray = mxCreateDoubleMatrix(arraysize, 1, mxREAL);
			for(k = 0; k < arraysize; k++)
				mxGetPr(parray)[k] = sae.eye_y1[k];
			mxSetFieldByNumber(SPIKEANDEYE, 0, 6, parray);
		}

		arraysize = (mwSize)sae_counter.eye_x2;
		if( arraysize > 0 )
		{
			parray = mxCreateDoubleMatrix(arraysize, 1, mxREAL);
			for(k = 0; k < arraysize; k++)
				mxGetPr(parray)[k] = sae.eye_x2[k];
			mxSetFieldByNumber(SPIKEANDEYE, 0, 7, parray);
		}

		arraysize = (mwSize)sae_counter.eye_y2;
		if( arraysize > 0 )
		{
			parray = mxCreateDoubleMatrix(arraysize, 1, mxREAL);
			for(k = 0; k < arraysize; k++)
				mxGetPr(parray)[k] = sae.eye_y2[k];
			mxSetFieldByNumber(SPIKEANDEYE, 0, 8, parray);
		}

		arraysize = (mwSize)sae_counter.stim_x1;
		if( arraysize > 0 )
		{
			parray = mxCreateDoubleMatrix(arraysize, 1, mxREAL);
			for(k = 0; k < arraysize; k++)
				mxGetPr(parray)[k] = sae.stim_x1[k];
			mxSetFieldByNumber(SPIKEANDEYE, 0, 9, parray);
		}

		arraysize = (mwSize)sae_counter.stim_y1;
		if( arraysize > 0 )
		{
			parray = mxCreateDoubleMatrix(arraysize, 1, mxREAL);
			for(k = 0; k < arraysize; k++)
				mxGetPr(parray)[k] = sae.stim_y1[k];
			mxSetFieldByNumber(SPIKEANDEYE, 0, 10, parray);
		}

		arraysize = (mwSize)sae_counter.stim_tON1;
		if( arraysize > 0 )
		{
			parray = mxCreateDoubleMatrix(arraysize, 1, mxREAL);
			for(k = 0; k < arraysize; k++)
				mxGetPr(parray)[k] = sae.stim_tON1[k];
			mxSetFieldByNumber(SPIKEANDEYE, 0, 11, parray);
		}

		arraysize = (mwSize)sae_counter.stim_tOFF1;
		if( arraysize > 0 )
		{
			parray = mxCreateDoubleMatrix(arraysize, 1, mxREAL);
			for(k = 0; k < arraysize; k++)
				mxGetPr(parray)[k] = sae.stim_tOFF1[k];
			mxSetFieldByNumber(SPIKEANDEYE, 0, 12, parray);
		}

		arraysize = (mwSize)sae_counter.stim_x2;
		if( arraysize > 0 )
		{
			parray = mxCreateDoubleMatrix(arraysize, 1, mxREAL);
			for(k = 0; k < arraysize; k++)
				mxGetPr(parray)[k] = sae.stim_x2[k];
			mxSetFieldByNumber(SPIKEANDEYE, 0, 13, parray);
		}

		arraysize = (mwSize)sae_counter.stim_y2;
		if( arraysize > 0 )
		{
			parray = mxCreateDoubleMatrix(arraysize, 1, mxREAL);
			for(k = 0; k < arraysize; k++)
				mxGetPr(parray)[k] = sae.stim_y2[k];
			mxSetFieldByNumber(SPIKEANDEYE, 0, 14, parray);
		}

		arraysize = (mwSize)sae_counter.stim_tON2;
		if( arraysize > 0 )
		{
			parray = mxCreateDoubleMatrix(arraysize, 1, mxREAL);
			for(k = 0; k < arraysize; k++)
				mxGetPr(parray)[k] = sae.stim_tON2[k];
			mxSetFieldByNumber(SPIKEANDEYE, 0, 15, parray);
		}

		arraysize = (mwSize)sae_counter.stim_tOFF2;
		if( arraysize > 0 )
		{
			parray = mxCreateDoubleMatrix(arraysize, 1, mxREAL);
			for(k = 0; k < arraysize; k++)
				mxGetPr(parray)[k] = sae.stim_tOFF2[k];
			mxSetFieldByNumber(SPIKEANDEYE, 0, 16, parray);
		}

		arraysize = (mwSize)sae_counter.plainbar_x;
		if( arraysize > 0 )
		{
			parray = mxCreateDoubleMatrix(arraysize, 1, mxREAL);
			for(k = 0; k < arraysize; k++)
				mxGetPr(parray)[k] = sae.plainbar_x[k];
			mxSetFieldByNumber(SPIKEANDEYE, 0, 17, parray);
		}

		arraysize = (mwSize)sae_counter.plainbar_y;
		if( arraysize > 0 )
		{
			parray = mxCreateDoubleMatrix(arraysize, 1, mxREAL);
			for(k = 0; k < arraysize; k++)
				mxGetPr(parray)[k] = sae.plainbar_y[k];
			mxSetFieldByNumber(SPIKEANDEYE, 0, 18, parray);
		}

		arraysize = (mwSize)sae_counter.periodidx;
		if( arraysize > 0 )
		{
			parray = mxCreateDoubleMatrix(arraysize, 1, mxREAL);
			for(k = 0; k < arraysize; k++)
				mxGetPr(parray)[k] = sae.periodidx[k];
			mxSetFieldByNumber(SPIKEANDEYE, 0, 19, parray);
		}

	}

	return;
}