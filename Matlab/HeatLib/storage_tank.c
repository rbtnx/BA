/* Copyright (C) 2014 Kai Kruppa, HAW Hamburg, Life Sciences
 * This program is free software: you can redistribute it and/or modify it 
 * under the terms of the GNU General Public License as published by the 
 * Free Software Foundation, either version 3 of the License, or (at your 
 * option) any later version.
 * 
 * This program is distributed in the hope that it will be useful, but 
 * WITHOUT ANY WARRANTY; without even the implied warranty of 
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
 * See the GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

/*
 *Entwickelt auf Grundlage der Masterarbeit "Entwicklung einer 
nichtlinearen modellprädiktiven Heizungsregelung zur energetisch 
optimierten Nutzung eines Warmwasserspeichers", 2012 von 
Herrn Jan Seifert.
 */

/* Description!!! -> search for: '!' or 'comment' or '//'
 *
 *
 * 					 +---------------+
 * (dV1,T1_ein)----->| 				 |----->(dV2,T2_aus) 
 *					 | Speicherkette |
 *					 |               |
 *					 |               |
 * (dV1,T1_aus)<-----|               |<-----(dV2,T2_ein)
 *					 +---------------+
 *
 *
 *     dV1 ->															    dV2 ->
 *    ------------------------------------------------------------------+--------- 
 *	   T1_ein		       										        |   T2_aus
 *	        		  Tank k		     Tank j    		    Tank 1		|	
 *                  +--------+         +--------+         +--------+    | 
 *                  |--Hin---| ---+    |--Hin---| ---+  1 |--Hin---| ---+ 
 *      Tmess[1] <- |--h(1)--|    |    |--h(1)--|    |  2 |--h(1)--|        
 *         :        |--------| .. | .. |--------| .. | .: |--------|        
 *         :        |--------|    |    |--------|    |  i |--------|        
 *     Tmess[ns] <- |--h(ns)-|    |    |--h(ns)-|    |  : |--h(ns)-|    
 *             +--- |--Hout--|    +--- |--Hout--|    +- n |--Hout--|    
 *             |    +--------+         +--------+         +--------+        
 *             |
 *     T1_aus  | 															T2_ein
 *    ---------+------------------------------------------------------------------ 
 *    <- dV1															    <- dV2
 *
 */

#define S_FUNCTION_NAME  storage_tank
#define S_FUNCTION_LEVEL 2

#include "simstruc.h"
#include "math.h"

#define PI    3.14159265358979
#define NMAX  100 /* Max. number of nodes */
#define KMAX  10  /* Max. number of tanks */
#define DVMAX (VTANK/10.0) /* Max. volumne flow rate (tank volume in 10sec) [m^3/s] */
#define T0_MIN  293.0 /* Min. interpolated initial temperature [K] */
#define T0_MAX  363.0 /* Max. interpolated initial temperature [K] */
#define TRUE  1
#define FALSE 0
#define EMPTY -1.0
#define max(a,b)  (((a) > (b)) ? (a) : (b))
#define min(a,b)  (((a) < (b)) ? (a) : (b))
      
/* User-specified parameters (converted: 1W = 3.6 kJ/h)) */	
#define MODE     *mxGetPr(ssGetSFcnParam(S,0))  /* Inlet position mode: '0' fixed, '1' variable */   
#define N        *mxGetPr(ssGetSFcnParam(S,1))  /* Number of nodes */
#define K        *mxGetPr(ssGetSFcnParam(S,2))  /* Number of tanks */
#define VTANK    *mxGetPr(ssGetSFcnParam(S,3))  /* Tank volume [m^3] */
#define HTANK    *mxGetPr(ssGetSFcnParam(S,4))  /* Tank height [m] */
#define H_IN     *mxGetPr(ssGetSFcnParam(S,5))  /* Height of flow inlet [m] */
#define H_OUT    *mxGetPr(ssGetSFcnParam(S,6))  /* Height of flow outlet [m] */
#define ULOSS    *mxGetPr(ssGetSFcnParam(S,7))  /* Tank loss coefficient [W/(m^2 K)]	*/
#define KEFF     *mxGetPr(ssGetSFcnParam(S,8))  /* Tank fluid thermal conductivity [W/(m K)]	*/         
#define TINIT     mxGetPr(ssGetSFcnParam(S,9))  /* Array of initial node temperatures [°C] */ 
#define H_SENSORS mxGetPr(ssGetSFcnParam(S,10)) /* Array of sensor heights of one tank */
#define TENV     *mxGetPr(ssGetSFcnParam(S,11)) /* Temperature of environment [°C] */        
#define N_PARAMETER                        12   /* Number of expected parameters */

#define N_INIT    mxGetN(ssGetSFcnParam(S,9))   /* Number of inital temperatures */
#define N_SENSORS mxGetN(ssGetSFcnParam(S,10))  /* Number of sensors in one tank */

/* Expected parameters for Simulink model (exact order) :
 *       mode, n, k, Vtank, Htank, Hin, Hout, U, keff, Tinit, Hsensors, Tenv */	


/* Input vector */
#define T1_IN   (*uPtrs[0]) /* Temperature of entering hot fluid [°C] */
#define DV1     (*uPtrs[1]) /* Volume flow rate of entering hot fluid [m^3/s] */      
#define T3_IN   (*uPtrs[2]) /* Temperature of entering cold fluid [°C] */     
#define DV2     (*uPtrs[3]) /* Volume flow rate of entering cold fluid [m^3/s] */              
#define N_INPUT         4   /* Number of expected inputs */

/* Output vector 0 */ 
#define T4        Y0[0]   /* Temperature of leaving cold fluid [°C] */
#define T2        Y0[1]   /* Temperature of leaving hot fluid [°C] */       
#define N_OUTPUT0    2    /* Number of expected outputs */ 

/* Output vector 1 */
#define TMESSptr   Y1           /* Pointer to temperature measurement outputs */
#define N_OUTPUT1 (N_SENSORS*k) /* Number of expected outputs */  

/* Output vector 2 */
#define TNODE      Y2     /* Pointer to output of all node temperatures */
#define N_OUTPUT2 (n*k)   /* Number of expected outputs */

/* DWork vector */
#define AS        W[0]  /* Surface area of middle node [m^2] */
#define AS_CAP    W[1]  /* Surface area of top and bottom node with cap [m^2] */
#define AC_UP     W[2]  /* Cross-sectional area of top of nodes [m^2] */
#define AC_DWN    W[3]  /* Cross-sectional area of bottom of nodes [m^2] */
#define PER       W[4]  /* Tank perimeter [m] */
#define H_NODE    W[5]  /* Equally sized node height [m] */
#define N_IN      W[6]  /* Node of flow inlet */
#define N_OUT     W[7]  /* Node of flow outlet */      
#define SENSORS  &W[8]  /* Nodes of all sensors in one tank */
#define N_DWORK   (8+N_SENSORS)  /* Number of expected DWork vector 0 elements */

#if !defined(MATLAB_MEX_FILE)
/*
 * This file cannot be used directly with the Real-Time Workshop. 
 */
# error This_file_can_be_used_only_during_simulation_inside_Simulink
#endif

/*=======================*
 * User function methods *
 *=======================*/
/* Function: getRho =======================================================
 * Abstract:
 *    Calculates approx. of density of fluid [kg/m^3]
 */
real_T getRho(real_T T)
{
    const real_T a = 1.21895531784123e-05;
    const real_T b = -0.00522116154923367;
    const real_T c = -0.0211965798637170;
    const real_T d = 1000.63883088852;
    return a*T*T*T + b*T*T + c*T + d;
} /* END getRho */

/* Function: getCp ========================================================
 * Abstract:
 *    Calculates approx. of tank fluid specific heat [J/(kg K)]
 */
real_T getCp(real_T T)
{
    const real_T a = 1.58139220189693e-06;
    const real_T b = -0.000381832403338523;
    const real_T c = 0.0413966702310755;
    const real_T d = -1.76358967395789;
    const real_T e = 4203.24095038807;
    return a*T*T*T*T + b*T*T*T + c*T*T + d*T + e;
} /* END getCp */
        
        
/* Function: interpolateStates ============================================
 * Abstract:
 *    Interpolate temperatures between the sensors with linear regression
 *    to set the initial node temperatures.
 */
void interpolateStates(real_T *T0, const real_T* Ts, real_T *W, const int_T n, const int_T ns)
{
    int_T i;
    real_T* sensors = SENSORS; /* Pointer to nodes of all sensors in one tank */
    const int_T n_in  = (int_T) N_IN;  /* Node of flow inlet */
    const int_T n_out = (int_T) N_OUT; /* Node of flow outlet */
    real_T n_bar = 0.0; /* Mean sensor height */
    real_T T_bar = 0.0; /* Mean sensor temperature */
    real_T SSxy  = 0.0; /* Empirical covariance */
    real_T SSxx  = 0.0; /* Empirical variance */
    real_T a     = 0.0; /* Linear offset */
    real_T b     = 0.0; /* Linear slope */
    
    /* Get mean sensor height and mean sensor temperature */ 
    for(i = 0; i < ns; i++)
    {
        n_bar += sensors[i];
        T_bar += Ts[i];
    }
    n_bar = n_bar/(real_T) ns;
    T_bar = T_bar/(real_T) ns;
    
    /* Get linear slope and offset */
    for(i = 0; i < ns; i++)
    {
        SSxy += (sensors[i] - n_bar)*(Ts[i] - T_bar);
        SSxx += (sensors[i] - n_bar)*(sensors[i] - n_bar);
    }
    b = SSxy/SSxx;
    a = T_bar - b*n_bar;
    
    /* Interpolate with linear curve */
    for(i = 0; i < n; i++)
    {
        T0[i] = min(max(a + b*i,T0_MIN),T0_MAX);
    }
    
    /* Introduce saturation on top of tank */
    if(n_in <= (int_T) sensors[0])
    {
        for(i = 0; i < n_in; i++)
        {
            /* Hold temperature from 'n_in' */
            T0[i] = T0[n_in];
        }
    }    
    else  
    {
        for(i = 0; i < (int_T) sensors[0]; i++)
        {
            /* Hold temperature from 'sensor[0]' */
            T0[i] = T0[(int_T) sensors[0]];
        }
    }
    
    /* Introduce saturation on bottom of tank */
    if(n_out >= (int_T) sensors[ns])
    {
        for(i = n_out; i < n; i++)
        {
            /* Hold temperature from 'n_out' */
            T0[i] = T0[n_out];
        }
    }    
    else  
    {
        for(i = (int_T) sensors[ns]; i < n; i++)
        {
            /* Hold temperature from 'sensor[ns]' */
            T0[i] = T0[(int_T) sensors[ns]];
        }
    }
} /* END interpolateStates */

/* Function: setInputFlows ================================================
 * Abstract:
 *    Set flows to corresponding nodes.
 */
void setInputFlows(real_T *m1in, real_T *m1out, const real_T m, real_T *W, const int_T charge)
{
    const int_T n_in  = (int_T) N_IN;  /* Node of flow inlet */
    const int_T n_out = (int_T) N_OUT; /* Node of flow outlet */
    if(charge == 1) /* Tank is charging */
    {    
        m1in[n_in]   = m; /* Set input flow to respective node */
        m1out[n_out] = m; /* Set output flow to respective node */
    }    
    else /* Tank is discharging */
    {    
        m1in[n_out] = m; /* Set input flow to respective node */
        m1out[n_in] = m; /* Set output flow to respective node */
    }
} /* END setInputFlows */


/* Function: setInletTemperatures =============================================
 * Abstract:
 *    Initialize internal inlet temperatures.
 *    1) Tank is charging:
 *   
 *	   				   Tin[k-1]           Tin[j]             Tin[0]
 *             +--------+ <--+    +--------+ <--+    +--------+ <-- dV, T1      
 *             |  Tank  |    |    |  Tank  |    |    |  Tank  |        
 *             |  'k-1' | .. | .. |   'j'  | .. | .. |   '0'  |        
 *             |        |    |    |        |    |    |        |        
 *             |        |    |    |        |    |    |        |        
 *      dV <-- +--------+    +--- +--------+    +--- +--------+        
 *             T[k-1][n_out]      T[j][n_out]        T[0][n_out]
 *   
 *    2) Tank is discharging:
 *   
 *	   				   T[k-1][n_in]       T[j][n_in]         T[j][n_in]
 *             +--------+ ---+    +--------+ ---+    +--------+ --> dV, T1      
 *             |  Tank  |    |    |  Tank  |    |    |  Tank  |        
 *             |  'k-1' | .. | .. |   'j'  | .. | .. |   '0'  |        
 *             |        |    |    |        |    |    |        |        
 *             |        |    |    |        |    |    |        |        
 *   dV,T3 --> +--------+    +--> +--------+    +--> +--------+        
 *            Tin[k-1]           Tin[j]             Tin[0]
 *
 */  
void setInletTemperatures(real_T *Tin, real_T *T, const real_T T1, const real_T T3, \
                          const int_T charge, const int_T n, const int_T k, real_T* W)
{
    int_T j;
    const int_T n_in  = (int_T) N_IN;  /* Node of flow inlet */
    const int_T n_out = (int_T) N_OUT; /* Node of flow outlet */
    if(charge == 1) /* Tank is charging */
    {
        /* Inlet temp. of tank '0' = temp. of entering hot fluid */
        Tin[0] = T1;
        
        /* Inlet temp. of tank 'j' = outlet node temp. of tank 'j-1' */
        for(j = 1; j <= k-1; j++)
        {
            Tin[j] = *(T + n*(j-1) + n_out); 
        }    
    }
    else /* Tank is discharging */
    {
        /* Inlet temp. of tank 'j' = top node temp. of tank 'j+1' */
        for(j = 0; j <= k-2; j++)
        {
            Tin[j] = *(T + n*(j+1) + n_in); 
        }
        
        /* Inlet temp. of tank 'k-1' = temp. of entering cold fluid */
        Tin[k-1] = T3;
    }    
} /* END setInletTemperatures */


/* Function: stratifiedLoading ============================================
 * Abstract:
 *    If using mode to place inlets at the node closest to it in temperature,
 *    find which node those are and reset inlet position to there.
 */
void stratifiedLoading(real_T *T, const real_T Tin, real_T *m1in, real_T m, const int_T n)
{
    /* General purpose variables and constants */
    const real_T Heps = 1e-3; /* Small number to compare two real heigths */
    real_T T1eps = 1000; /* initalize first temperature difference with large number  */
    
    /* Indexing and branching variables */
    int_T node1 = 1; /* Position of entering mass flow */
    int_T i;

    for(i = 0; i < n; i++)
    {    
        /* overwrite old inflows */
        m1in[i] = 0.0;
        /* find node with temperature T(node1) closest to T1 */
        if(fabs(Tin-T[i]) < T1eps)
        {    
            T1eps = fabs(Tin-T[i]);
            node1 = i;
        }   
    }
    /* set inflows to matching nodes */
    m1in[node1] = m;
    
} /* END stratifiedLoading */


/* Function: setFlowDirection ============================================
 * Abstract:
 *    Compute bulk flow in and out of each node.
 *    Set control flows in appropriate directions.
 */

void setFlowDirection(real_T *m1in, real_T *m1out, real_T *mT, real_T *mB, real_T *mTup, \
                      real_T *mTdwn, real_T *mBup, real_T *mBdwn,const int_T n)
{
    int i;
    /* Compute bulk flow in and out of each node
     *              mT(i)
     *               | (in)
     *     	      +--------+
     *  m1in(i) ->| node i |-> m1out(i)
     *            +--------+
     *               | (in)
     *              mB(i)
     */
    mT[0] = 0;
    mB[0] = m1out[0]-m1in[0];
    for(i = 1; i < n-1; i++)
    {    
        mT[i] = -mB[i-1];
        mB[i] = m1out[i]-m1in[i]-mT[i];
    }
    mT[n-1] = -mB[n-2];
    mB[n-1] = 0;
    
    /* Set control flows in appropriate directions
     *     	       +--------+
     *  mTdwn(i) ->| node i |-> mBdwn(i)
     *   mTup(i) <-|        |<- mBup(i)
     *             +--------+
     *           top -----> bottom
     */
    for(i = 0; i < n; i++)
    {
        if(mT[i] > 0)
        {    
            mTup[i] = 0;
            mTdwn[i] = mT[i];
        }    
        else if(mT[i] <= 0)
        {    
            mTup[i] = -mT[i];
            mTdwn[i] = 0;
        }
        if(mB[i] > 0)
        {    
            mBup[i] = mB[i];
            mBdwn[i] = 0;
        }    
        else if (mB[i] <= 0)
        {    
            mBup[i] = 0;
            mBdwn[i] = -mB[i];
        }
    } 
} /* END setFlowDirection*/


/* Function: mixing =======================================================
 * Abstract:
 *    Mixing of node temperatures to include temperature inversion.
 */
void mixing(real_T *T, const int_T n, real_T *M)
{
    int_T  i, j, w, set;
    real_T Tmix = 0.001;
    real_T dum2, dum3;
    int_T  trip1 = 0;
    int_T  trip2 = 1;
    
    while(trip2 == 1)
    {
        /* Bottom -> Top */
        trip1 = 0;
        w = 0;
        for(i = n-2; i >= 0; i--)
        {
            if((T[i] + Tmix >= T[i+1]) && (trip1 != 0))
            {
                trip1 = 0;
                w = 0;
            }
            /* Check if upper node is colder than lower one */
            if(T[i] + Tmix < T[i+1])
            {
                if(trip1 == 0)
                {
                    w = i + 1;
                    trip1 = 1;
                }
                /* Mix indexed nodes to one mean temperature */
                dum2 = 0.0;
                dum3 = 0.0;
                for(j = w; j >= i; j--)
                {
                    dum2 += M[j]*T[j];
                    dum3 += M[j];
                }
                for(j = w; j >= i; j--)
                {			
                    T[j] = dum2/dum3; 
                }
            }
        }
        /* Top -> Bottom */
        trip1 = 0;
        w = 0;
        set = 0;
        for(i = 1; i < n; i++)
        {
            if(fabs(T[i]-T[i-1]) <= Tmix)
            {
                set++;
            }
            if((T[i] <= T[i-1] + Tmix) && (trip1 != 0))
            {
                trip1 = 0;
                w = 0;
            }
            if(T[i] > T[i-1] + Tmix)
            {
                if(trip1 == 0)
                {
                    w = i - 1 - set;
                    trip1 = 1;
                }
                /* Mix indexed nodes to one mean temperature */
                dum2 = 0.0;
                dum3 = 0.0;
                for(j = w; j <= i; j++)
                {
                    dum2 += M[j]*T[j];
                    dum3 += M[j];
                }
                for(j = w; j <= i; j++)
                {
                    T[j] = dum2/dum3;
                } 
            }   
        }           
        /* Ceck to make sure everything got mixed */
        Tmix  = 0.0015;
        trip2 = 0;
        for(i = 1; i < n; i++)
        {
            if(T[i-1] + Tmix < T[i])
            {
                trip2 = 1;
            }
        }    
    }
} /* END mixing */



/*====================*
 * S-function methods *
 *====================*/
 
/* Function: mdlCheckParameters =============================================
 * Abstract:
 *    Validate our parameters to verify they are okay.
 */
#define MDL_CHECK_PARAMETERS   
static void mdlCheckParameters(SimStruct *S)
{
	if(VTANK <= 0.0) 
	{
		ssSetErrorStatus(S,"Error in storage tank: Tank volume must be > 0.");
		return;
	}
	if(HTANK <= 0.0) 
	{
		ssSetErrorStatus(S,"Error in storage tank: Tank heigth must be > 0.");
		return;
	}
    if((H_IN < 0.0) || (H_IN > HTANK)) 
	{
		ssSetErrorStatus(S,"Error in storage tank: Height of flow inlet must be inside the tank.");
		return;
	}
    if((H_OUT < 0.0) || (H_OUT > HTANK)) 
	{
		ssSetErrorStatus(S,"Error in storage tank: Height of flow outlet must be inside the tank.");
		return;
	}
	if((N > NMAX) || (N < 1)) 
	{
		ssSetErrorStatus(S,"Error in storage tank: Number of nodes must be between 1 and 100.");
		return;
	}
    if((K > KMAX) || (K < 1)) 
	{
		ssSetErrorStatus(S,"Error in storage tank: Number of tanks must be between 1 and 10.");
		return;
	}
	if(ULOSS < 0.0)
	{
		ssSetErrorStatus(S,"Error in storage tank: Overall heat transfer coefficient must be >= 0.");
		return;
	}
	if(KEFF < 0.0)
	{
		ssSetErrorStatus(S,"Error in storage tank: Tank fluid thermal conductivity must be >= 0.");
		return;
	}
	if((MODE != 0) && (MODE != 1)) 
	{
		ssSetErrorStatus(S,"Error in storage tank: Inlet position mode must be 0 or 1.");
		return;
	}
    if(N_INIT != N_SENSORS*K)
	{
		ssSetErrorStatus(S,"Error in storage tank: Number of initial sensor temperatures and number of sensor heights don't fit.");
		return;
	}
	
} /* END mdlCheckParameters */

 

/* Function: mdlInitializeSizes ===============================================
 * Abstract:
 *    The sizes information is used by Simulink to determine the S-function
 *    block's characteristics (number of inputs, outputs, states, etc.).
 */
static void mdlInitializeSizes(SimStruct *S)
{
    int_T i;
    const int_T n = (int_T) N; /* Number of nodes */
    const int_T k = (int_T) K; /* Number of tanks */
    
    ssSetNumSFcnParams(S, N_PARAMETER);  /* Number of expected parameters */
	
	/* Ceck parameters for correctness */
    if (ssGetNumSFcnParams(S) == ssGetSFcnParamsCount(S))
	{
        mdlCheckParameters(S);
        if (ssGetErrorStatus(S) != NULL) 
		{
			return;
        }
    } 
	else 
	{
		return; /* Parameter mismatch will be reported by Simulink */
    }
    
    /* Parameters can't be tuned */
    for (i = 0; i < N_PARAMETER; i++) 
    {
        ssSetSFcnParamNotTunable(S,i);
    }
    
    /* Register the number and type of states the S-Function uses */
    ssSetNumContStates(S, n*k); /* number of continuous states */
    ssSetNumDiscStates(S, 0);   /* number of discrete states */

    /* Configure the input port */
    if (!ssSetNumInputPorts(S, 1)) return; /* number of inputs */
    ssSetInputPortWidth(S, 0, N_INPUT);
    // ssSetInputPortDirectFeedThrough(S, 0, 0); /* Don't use input in 'mdlOutputs' */
    ssSetInputPortDirectFeedThrough(S, 0, 1); /* Use input in 'mdlOutputs' */
    
    /* Configure the output ports */
    if (!ssSetNumOutputPorts(S, 3)) return; /* number of outputs */
    ssSetOutputPortWidth(S, 0, N_OUTPUT0);
    ssSetOutputPortWidth(S, 1, N_OUTPUT1);
    ssSetOutputPortWidth(S, 2, N_OUTPUT2);
    
    /* Configure sampling time */
    ssSetNumSampleTimes(S, 1);   /* number of sample times */
    ssSetNumNonsampledZCs(S, 0); /* number of nonsampled zero crossings */
    
    /* Configure DWork vectors */
    ssSetNumDWork(S, 1); /* number of DWork vectors */
    ssSetDWorkWidth(S, 0, N_DWORK);
    ssSetDWorkDataType(S, 0, SS_DOUBLE);   
    
    /* Configure elementary vectors */
    ssSetNumRWork(S, 0); /* number of real work vector elements */
    ssSetNumIWork(S, 0); /* number of integer work vector elements */
    ssSetNumPWork(S, 0); /* number of pointer work vector elements */
    ssSetNumModes(S, 0); /* number of mode work vector elements */
    
    
    /* Specify the sim state compliance to be same as a built-in block */
    ssSetSimStateCompliance(S, USE_DEFAULT_SIM_STATE);

    /* Take care when specifying exception free code - see sfuntmpl_doc.c */
    ssSetOptions(S, SS_OPTION_EXCEPTION_FREE_CODE);
} /* END mdlInitializeSizes */


/* Function: mdlInitializeSampleTimes =========================================
 * Abstract:
 *    This function is used to specify the sample time(s) for your
 *    S-function. You must register the same number of sample times as
 *    specified in ssSetNumSampleTimes.
 */
static void mdlInitializeSampleTimes(SimStruct *S)
{
    ssSetSampleTime(S,0,CONTINUOUS_SAMPLE_TIME);
    ssSetOffsetTime(S,0,0.0);
}


/* Function: mdlInitializeConditions ========================================
* Abstract:
*    In this function, you should initialize the continuous and discrete
*    states for your S-function block.  The initial states are placed
*    in the state vector, ssGetContStates(S) or ssGetRealDiscStates(S).
*    You can also perform any other initialization activities that your
*    S-function may require. Note, this routine will be called at the
*    start of simulation and if it is present in an enabled subsystem
*    configured to reset states, it will be call when the enabled subsystem
*    restarts execution to reset the states.
*/
#define MDL_INITIALIZE_CONDITIONS
static void mdlInitializeConditions(SimStruct *S)
{
    real_T *T0 = ssGetContStates(S);        /* Node temperatures [°C] */
    real_T *W  = (real_T*) ssGetDWork(S,0); /* DWork vector for constants */
    
    /* Copy parameter to avoid function calls */
    const real_T     Vtank = VTANK;     /* Tank volume [m^3] */
    const real_T     Htank = HTANK;     /* Tank height [m] */
    const real_T    *Tinit = TINIT;     /* Pointer to sensor temperatures at start of simulation */
    const real_T *Hsensors = H_SENSORS; /* Pointer to sensor heights of one tank */
    real_T        *sensors = SENSORS;   /* Pointer to sensor nodes of one tank */
    const int_T    ns  = (int_T) N_SENSORS; /* Number of sensors in one tank */
    const int_T    n   = (int_T) N; /* Number of nodes */
    const int_T    k   = (int_T) K; /* Number of tanks */
    const real_T   hin = H_IN;      /* Height of inlet pipe */        
    const real_T  hout = H_OUT;     /* Height of outlet pipe */
    
    /* Indexing variables */
    int_T i,j; 
    
    /* General purpose variables and constants */
    const real_T  heps = 1e-3; /* Small number to compare two real heigths */
    const real_T  h = Htank/n; /* Equally sized node height */
    real_T ha    = 0.0;   /* Accumulative height with respect to bottom of tank  */
    int_T  skip3 = FALSE; /* Logic variable to avoid repetitive writing to 'N_IN' */
    int_T  skip4 = FALSE; /* Logic variable to avoid repetitive writing to 'N_OUT' */
   
    /* Determine tank constants (vertical cylindric tank) */
    PER    = sqrt(4*PI*Vtank/Htank); /* Tank perimeter */
    H_NODE = Htank/n;                /* Equally sized node height */
    if(n == 1)
    {
        AS = 2*Vtank/Htank + PER*H_NODE; /* Surface area of node */
    }
    else
    {
        AC_UP = Vtank/Htank;  /* Cross-sectional area of top of nodes */
        AC_DWN = Vtank/Htank; /* Cross-sectional area of bottom of nodes */
        AS_CAP = Vtank/Htank + PER*H_NODE; /* Surface area of top and bottom node with cap */
        AS = PER*H_NODE;     /* Surface area of middle nodes */
    }
    
    /* Initialize sensor nodes (EMPTY means not yet specified) */
    for(j = 0; j < ns; j++)
    {
        sensors[j] = EMPTY;
    }    
    
    /* Convert sensor heights into node numbers */
    for(i = n-1; i >= 0; i--)
    {
        ha = ha + h;      /* Accumulate height */
        for(j = 0; j < ns; j++)
        {
            if((Hsensors[j] - ha <= heps) && sensors[j] == EMPTY)
            {    
                sensors[j] = (real_T) i; /* Node number that contains sensor */
            }    
        }    
        if((hin-ha <= heps) && (!skip3))
		{
            N_IN = (real_T) i; /* Node number that contains inlet pipe */
            skip3 = TRUE;      /* 'N_IN' needs only to be set once */
        }
        if((hout-ha <= heps) && (!skip4))
		{
            N_OUT = (real_T) i; /* Node number that contains outlet pipe */
            skip4 = TRUE;       /* 'N_OUT' needs only to be set once */
        }
    }
    /* Get initial node temperatures via interpolation between given initial measurements */
    for(j = 0; j < k; j++)
    {    
        if(n == 1)
        {
            /* Get mean sensor temperature if using only one node */
            T0[j] = 0.0;
            for(i = 0; i < ns; i++)
            {
                T0[j] += Tinit[j*ns+i];
            }
            T0[j] = T0[j]/(real_T) ns;
        }  
        else
        {    
            /* Interpolate between sensor points if using more than one node */
            interpolateStates(T0+j*n, Tinit+j*ns, W, n, ns);
        }    
    }
    
} /* END mdlInitializeConditions */


/* Function: mdlOutputs =======================================================
 * Abstract:
 *    In this function, you compute the outputs of your S-function
 *    block.
 */
static void mdlOutputs(SimStruct *S, int_T tid)
{
    InputRealPtrsType uPtrs   = ssGetInputPortRealSignalPtrs(S,0); /*Input vector */
    real_T  *Y0 = ssGetOutputPortSignal(S,0); /* 1st output vector */
    real_T  *Y1 = ssGetOutputPortSignal(S,1); /* 2st output vector */
    real_T  *Y2 = ssGetOutputPortSignal(S,2); /* 3rd output vector */
    real_T  *T  = ssGetContStates(S);         /* Node temperatures [°C] */
    real_T  *W  = (real_T*) ssGetDWork(S,0);  /* DWork vector for constants */
    real_T  *sensors = SENSORS; /* Pointer to sensor nodes of one tank */
    real_T  M[KMAX*NMAX];       /* Mass of nodes [kg] */
    
    /* Copy input to avoid function calls */
    const real_T  T1 = T1_IN; /* Temperature of entering hot fluid [°C] */
    const real_T  T3 = T3_IN; /* Temperature of entering cold fluid [°C] */
    
    /* Copy parameter to avoid function calls */
    const int_T    n  = (int_T) N;  /* Number of nodes */
    const int_T    k  = (int_T) K;  /* Number of tanks */
    const int_T   ns  = (int_T) N_SENSORS; /* Number of sensors in one tank */
    const int_T  n_in = (int_T) N_IN;  /* Node of flow inlet */
    const int_T n_out = (int_T) N_OUT; /* Node of flow outlet */

    int_T i,j;
    
    /* Calculate mass of nodes [kg] */
    for(i = 0; i < n*k; i++)
    {    
        M[i] = VTANK*getRho(T[i])/n; /* Mass of one node */
    }
    
    /* Mixing of node temperatures to include temperature inversion */
    for(j = 0; j < k; j++)
    {    
        mixing(T+j*n, n, M+j*n);
    }
    
    /* Create 1st output */
    if(DV1 >= DV2) /* Tank is charging */
    { 
        T2 = T1; /* Temperature of leaving hot fluid [°C] */
        if(DV1 == DV2)
        {
            T4 = T3; // <-Does this fit with simulations (temperature jumps)???
        }
        else
        {    
            T4 = (T[n*(k-1)+n_out] * (DV1-DV2) + T3*DV2)/DV1; /* Temperature of leaving cold fluid [°C] */
        }    
    }
    else         /* Tank is discharging */
    {
        T2 = (T[n_in]*(DV2-DV1) + T1*DV1)/DV2; /* Temperature of leaving hot fluid [°C] */
        T4 = T3;    /* Temperature of leaving cold fluid [°C] */
    }
    
    /* Create 2nd output */
    for(j = 0; j < k; j++)
    {    
        for(i = 0; i < ns; i++)
        {
            TMESSptr[ns*j+i] = T[n*j+(int_T)sensors[i]]; /* Sensor measurements */
        }    
    }
     /* Create 3rd output */
    for(j = 0; j < k*n; j++)
    {
        TNODE[j] = T[j]; /* Node temperatures */
    }    
} /* END mdlOutputs */


/* Function: mdlUpdate ======================================================
* Abstract:
*    This function is called once for every major integration time step.
*    Discrete states are typically updated here, but this function is useful
*    for performing any tasks that should only take place once per
*    integration step.
*/
static void mdlUpdate(SimStruct *S, int_T tid)
{
}


/* Function: mdlDerivatives =================================================
* Abstract:
*    In this function, you compute the S-function block's derivatives.
*    The derivatives are placed in the derivative vector, ssGetdX(S).
*/
#define MDL_DERIVATIVES
static void mdlDerivatives(SimStruct *S)
{
    /* delete unnecessary variables !!! */
    InputRealPtrsType uPtrs   = ssGetInputPortRealSignalPtrs(S,0); /*Input vector */
    real_T  *dT = ssGetdX(S);                /* Derivative of node temperatures [K/s] */
    real_T  *T  = ssGetContStates(S);        /* Node temperatures [°C] */
    real_T	*W  = (real_T*) ssGetDWork(S,0); /* DWork vector for constants */
    real_T  M[KMAX*NMAX];  /* Mass of nodes [kg] */ 
    real_T  Cp[KMAX*NMAX]; /* Tank fluid specific heat [J/(kg K)] */
    
    /* Copy parameter to avoid function calls */
    const real_T   Vtank  = VTANK;  /* Tank volume [m^3] */
    const real_T   Htank  = HTANK;  /* Tank height [m] */
    const real_T   U      = ULOSS;  /* Tank loss coefficient [W/(m^2 K)] */
    const real_T   Keff   = KEFF;   /* Tank fluid thermal conductivity [W/(m K)] */
    const int_T    n      = (int_T) N;    /* Number of nodes  */
    const int_T    k      = (int_T) K;    /* Number of tanks */
    const real_T   Tenv   = TENV;         /* Temperature of environment [°C] */
    const int_T    mode   = (int_T) MODE; /* Inlet position mode: '0' fixed, '1' variable */
    const real_T   As	  = AS;     /* Surface area of middle node [m^2] */ 
    const real_T   As_cap = AS_CAP; /* Surface area of top and bottom node with cap [m^2] */   
    const real_T   Ac_up  = AC_UP;  /* Cross-sectional area of top of nodes [m^2] */
    const real_T   Ac_dwn = AC_DWN; /* Cross-sectional area of bottom of nodes [m^2] */
    const real_T   H      = H_NODE; /* Equally sized node height [m] */       
    
     /* Copy input to avoid function calls */
    const real_T  T1 = T1_IN; /* Temperature of entering hot fluid [°C] */
    const real_T  T3 = T3_IN; /* Temperature of entering cold fluid [°C] */
	real_T    m1 = DV1 * getRho(T1); /* Mass flow rate of entering hot fluid [kg/s] */           
    real_T    m2 = DV2 * getRho(T3); /* Mass flow rate of entering cold fluid [kg/s] */
    
    /* Internal inlet temperatures */
    real_T   Tin   [KMAX];
    
    /* Tank flow variables */
    real_T   m;    /* Overall mass flowrate */    
    real_T   mT    [KMAX*NMAX]; /* Mass flow rate entering or leaving top of node */
    real_T   mB    [KMAX*NMAX]; /* Mass flow rate entering or leaving bottom of node */
    real_T   m1in  [KMAX*NMAX]; /* Mass flow rate of fluid entering pipe 1 (from inputs) */
    real_T   m1out [KMAX*NMAX]; /* Mass flow rate of fluid exiting pipe 1 (from inputs) */
    real_T   mBdwn [KMAX*NMAX]; /* Mass flow rate entering the bottom of the node */
    real_T   mBup  [KMAX*NMAX]; /* Mass flow rate leaving the bottom of the node */
    real_T   mTdwn [KMAX*NMAX]; /* Mass flow rate entering the top of the node */
    real_T   mTup  [KMAX*NMAX]; /* Mass flow rate leaving the top of the node */
    
    /* Energy balance equation: dX(i) = a(i)X(i)+b(i)X(i-1)+c(i)X(i+1)+d(i) */
    real_T   a     [KMAX*NMAX]; /* First energy balance coefficient vector */
    real_T   b     [KMAX*NMAX]; /* Second energy balance coefficient vector */
    real_T   c     [KMAX*NMAX]; /* Third energy balance coefficient vector */
    real_T   d     [KMAX*NMAX]; /* Array containing energy balance constants */
    
    /* Indexing and branching variables */
    int_T    i,j;
    int_T    charge;
    
    /* Pointers */
    real_T *aPtr, *bPtr, *cPtr, *dPtr, *dTPtr, *TPtr, *CpPtr, *MPtr; 
    real_T *m1inPtr, *m1outPtr, *mBupPtr, *mBdwnPtr, *mTupPtr, *mTdwnPtr; 
    
    /* Initialize flow variables and energy balance coefficients */
    for(i = 0; i < k*n; i++)
    {
        mT[i]    = 0.0;
        mB[i]    = 0.0;
        m1in[i]  = 0.0;
        m1out[i] = 0.0;
        mBdwn[i] = 0.0;
        mBup[i]  = 0.0;
        mTdwn[i] = 0.0;
        mTup[i]  = 0.0;
        a[i]  = 0.0;
        b[i]  = 0.0;
        c[i]  = 0.0;
        d[i]  = 0.0;
        M[i]  = Vtank*getRho(T[i])/n;
        Cp[i] = getCp(T[i]);
    }

    /* Check for charging or discharging */
    if(m1 >= m2)
    {   
        /* tank is charging */
        charge = 1;
    }    
    else
    {    
        /* tank is discharging */
        charge = 0;
    }
    m = fabs(m1-m2); /* work only with positive flow internally */
    
    /* Set flows to corresponding nodes */
    for(j = 0; j < k; j++)
    {
        setInputFlows(m1in+j*n, m1out+j*n, m, W, charge);
    }
    
    /* Initialize internal inlet temperatures */    
	setInletTemperatures(Tin, T, T1, T3, charge, n, k, W);
    
    /* If using mode to place inlets at the node closest to it in temperature,
     * find which node those are and reset inlet position to there. */
    if((mode == 1) && (m > 0))
    {   
        for(j = 0; j < k; j++)
        {    
            stratifiedLoading(T+j*n, Tin[j], m1in+j*n, m, n);
        }    
    } 
    
    /* Compute bulk flow in and out of each node.
     * Set control flows in appropriate directions. */
    for(j = 0; j < k; j++)
    {
        setFlowDirection(m1in+j*n, m1out+j*n, mT+j*n, mB+j*n, mTup+j*n, \
                         mTdwn+j*n, mBup+j*n, mBdwn+j*n, n);  
    } 

    /* Set up coefficient matrix for energy balance of each node
     * -> dX(i) = a(i)X(i)+b(i)X(i-1)+c(i)X(i+1)+d(i) */ 
    for(j = 0; j < k; j++)
    {   
        /* Shift all pointers */
        aPtr     = a + n*j;     
        bPtr     = b + n*j;     
        cPtr     = c + n*j;     
        dPtr     = d + n*j;     
        m1inPtr  = m1in  + n*j;
        m1outPtr = m1out + n*j;
        mBupPtr  = mBup  + n*j;
        mBdwnPtr = mBdwn + n*j;    
        mTupPtr  = mTup  + n*j;   
        mTdwnPtr = mTdwn + n*j;   
        dTPtr    = dT + n*j;    
        TPtr     = T  + n*j;
        CpPtr    = Cp + n*j;
        MPtr     = M  + n*j;
        if(n == 1) /* One node tank */
        {    
            aPtr[0] = (-m1outPtr[0]-As*U/CpPtr[0])/MPtr[0];
            dPtr[0] = (m1inPtr[0]*Tin[j]+U*As*Tenv/CpPtr[0])/MPtr[0];
        } 
        else       /* Two or more nodes */
        {
            /* Compute top and bottom node coefficients */
            aPtr[0]   = (-m1outPtr[0]-mBdwnPtr[0]-Keff*Ac_dwn/(CpPtr[0]*H)-U*As_cap/CpPtr[0])/MPtr[0];
            cPtr[0]   = (mBupPtr[0]+Keff*Ac_dwn/(CpPtr[0]*H))/MPtr[0];
            dPtr[0]   = (m1inPtr[0]*Tin[j]+U*As_cap*Tenv/CpPtr[0])/MPtr[0];
            aPtr[n-1] = (-m1outPtr[n-1]-mTupPtr[n-1]-Keff*Ac_up/(CpPtr[n-1]*H)-U*As_cap/CpPtr[n-1])/MPtr[n-1];
            bPtr[n-1] = (mTdwnPtr[n-1]+Keff*Ac_up/(CpPtr[n-1]*H))/MPtr[n-1];
            dPtr[n-1] = (m1inPtr[n-1]*Tin[j]+U*As_cap*Tenv/CpPtr[n-1])/MPtr[n-1];

            /* Compute middle node coefficients */
            for(i = 1; i < n-1; i++)
            {
                aPtr[i] = (-m1outPtr[i]-mTupPtr[i]-mBdwnPtr[i]-Keff*Ac_up/(CpPtr[i]*H)  \
                           -Keff*Ac_dwn/(CpPtr[i]*H)-U*As/CpPtr[i])/MPtr[i];
                bPtr[i] = (mTdwnPtr[i]+Keff*Ac_up/(CpPtr[i]*H))/MPtr[i];
                cPtr[i] = (mBupPtr[i]+Keff*Ac_dwn/(CpPtr[i]*H))/MPtr[i];
                dPtr[i] = (m1inPtr[i]*Tin[j]+U*As*Tenv/CpPtr[i])/MPtr[i];
            }    
        }
        /* Calculate differential equation of energy balance */
        if(n == 1) /* One node tank */
        {    
            dTPtr[0] = aPtr[0]*TPtr[0] + dPtr[0];
        }
        else       /* Two or more nodes */
        {
            dTPtr[0] = aPtr[0]*TPtr[0] + cPtr[0]*TPtr[1] + dPtr[0];
            for(i = 1; i < n-1; i++)
            {
                dTPtr[i] = aPtr[i]*TPtr[i] + bPtr[i]*TPtr[i-1] + cPtr[i]*TPtr[i+1] + dPtr[i];
            }
            dTPtr[n-1] = aPtr[n-1]*TPtr[n-1] + bPtr[n-1]*TPtr[n-2] + dPtr[n-1];
        } 
    }   
} /* END mdlDerivatives */




/* Function: mdlTerminate =====================================================
 * Abstract:
 *    In this function, you should perform any actions that are necessary
 *    at the termination of a simulation.  For example, if memory was
 *    allocated in mdlStart, this is the place to free it.
 */
static void mdlTerminate(SimStruct *S)
{
}


/*======================================================*
 * See sfuntmpl_doc.c for the optional S-function methods *
 *======================================================*/

/*=============================*
 * Required S-function trailer *
 *=============================*/

#ifdef  MATLAB_MEX_FILE    /* Is this file being compiled as a MEX-file? */
#include "simulink.c"      /* MEX-file interface mechanism */
#else
#include "cg_sfun.h"       /* Code generation registration function */
#endif
