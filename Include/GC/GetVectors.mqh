//+------------------------------------------------------------------+
//|                                                   GetVectors.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool GetVectors(double &InputVector[],double &OutputVector[],int num_inputvectors,int num_outputvectors,string fn_name,int shift=0,string params="")
  {// пара, период, смещение назад (для индикатора полезно)
   if("Easy"==fn_name) return(GetVectors_Easy(InputVector,OutputVector,num_inputvectors,num_outputvectors,shift,params));
   if("sinex"==fn_name) return(GetVectors_Sinex(InputVector,OutputVector,num_inputvectors,num_outputvectors,shift,params));
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool GetVectors_Easy(double &InputVector[],double &OutputVector[],int num_inputvectors,int num_outputvectors,int shift=0,string params="")
  {// пара, период, смещение назад (для индикатора полезно)
   int shft_his=7;
   int shft_cur=0;

   string smbl=_Symbol;
   ENUM_TIMEFRAMES   tf=_Period;
   double Close[];
   ArraySetAsSeries(Close,true);
// копируем историю
   int maxcount=CopyClose(smbl,tf,shift,num_inputvectors+num_outputvectors+2,Close);
   ArrayInitialize(InputVector,EMPTY_VALUE);
   ArrayInitialize(OutputVector,EMPTY_VALUE);
   if(maxcount<num_inputvectors+num_outputvectors+2)
     {
      Print("Shift = ",shift," maxcount = ",maxcount);
      return(false);
     }
   int i,j;j=1;
   for(i=0;i<num_outputvectors;i++,j++)
     {
      // вычислим и отнормируем
      OutputVector[i]=100*(Close[j]-Close[j+1]);
     }
   for(i=0;i<num_inputvectors;i++,j++)
     {
      // вычислим и отнормируем
      InputVector[i]=100*(Close[j]-Close[j+1]);
     }
//  OutputVector[0]=100*(Close[1]-Close[2]);
   return(true);
  }
//+------------------------------------------------------------------+
//|  Для теста нейросети                                             |
//+------------------------------------------------------------------+
bool GetVectors_Sinex(double &InputVector[],double &OutputVector[],int num_inputvectors,int num_outputvectors,int shift=0,string params="")
  {// пара, период, смещение назад (для индикатора полезно)
   ArrayInitialize(InputVector,EMPTY_VALUE);
   ArrayInitialize(OutputVector,EMPTY_VALUE);
   if(0==shift) {InputVector[0]=0.050000;OutputVector[0]=0.479426;}
   else if(1==shift) {InputVector[0]=0.150000;OutputVector[0]=0.997495;}
   else if(2==shift) {InputVector[0]=0.100000;OutputVector[0]=0.841471;}
   else return(false);

   return(true);
  }
//+------------------------------------------------------------------+
