//+------------------------------------------------------------------+
//|                                                   GetVectors.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
string VectorFunctions[21]={"Fractals","Easy","RSI","","","","","","","","","",""};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool GetVectors(double &InputVector[],double &OutputVector[],int num_inputvectors,int num_outputvectors,string fn_name,string smbl="",ENUM_TIMEFRAMES tf=0,int shift=0)
  {// пара, период, смещение назад (для индикатора полезно)
   bool ret=false;
   int shift_history=7;//
   if(""==smbl) smbl=_Symbol;
   if(0==tf) tf=_Period;
   if(0==num_outputvectors) shift_history=0;
   if("Easy"==fn_name) ret=GetVectors_Easy(InputVector,OutputVector,num_inputvectors,num_outputvectors,smbl,tf,shift,shift_history);
   if("RSI"==fn_name) ret=GetVectors_RSI(InputVector,OutputVector,num_inputvectors,num_outputvectors,smbl,tf,shift,shift_history);
   if("Fractals"==fn_name) ret=GetVectors_Fractals(InputVector,OutputVector,num_inputvectors,num_outputvectors,smbl,tf,shift,shift_history);
   if("HL"==fn_name) ret=GetVectors_HL(InputVector,OutputVector,num_inputvectors,num_outputvectors,smbl,tf,shift,shift_history);
//   if("sinex"==fn_name) return(GetVectors_Sinex(InputVector,OutputVector,num_inputvectors,num_outputvectors,shift,params));
   return(ret);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool GetVectors_Easy(double &InputVector[],double &OutputVector[],int num_inputvectors,int num_outputvectors,string smbl="",ENUM_TIMEFRAMES tf=0,int shift=0,int shft_his=7)
  {// пара, период, смещение назад (для индикатора полезно)

   int shft_cur=0;

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
//| Прогноз минимальных и максимальных цен                           |
//+------------------------------------------------------------------+
bool GetVectors_HL(double &InputVector[],double &OutputVector[],int num_inputvectors,int num_outputvectors,string smbl="",ENUM_TIMEFRAMES tf=0,int shift=0,int shft_his=7)
  {// пара, период, смещение назад (для индикатора полезно)

   int shft_cur=0;

   double Close[]; ArraySetAsSeries(Close,true);
   double High[]; ArraySetAsSeries(High,true);
   double Low[]; ArraySetAsSeries(Low,true);
//if(num_outputvectors!=2 ||num_inputvectors%3!=0)
//  {
//   Print("Output vectors only 2!");
//   return(false);
//  }
// копируем историю
   int maxcount=CopyHigh(smbl,tf,shift,num_inputvectors+num_outputvectors+2,High);
   maxcount=CopyClose(smbl,tf,shift,num_inputvectors+num_outputvectors+2,Close);
   maxcount=CopyLow(smbl,tf,shift,num_inputvectors+num_outputvectors+2,Low);

   ArrayInitialize(InputVector,EMPTY_VALUE);
   ArrayInitialize(OutputVector,EMPTY_VALUE);
   if(maxcount<num_inputvectors+num_outputvectors+2)
     {
      Print("Shift = ",shift," maxcount = ",maxcount);
      return(false);
     }
   int i,j;j=1;
// вычислим и отнормируем
   if(0!=num_outputvectors)
     {
      OutputVector[0]=100*(High[j]-High[j+1]);
      OutputVector[1]=100*(Low[j]-Low[j+1]);
      j++;
     }
   for(i=0;i<num_inputvectors;j++)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
     {
      // вычислим и отнормируем
      InputVector[i++]=100*(High[j]-High[j+1]);
      InputVector[i++]=100*(Low[j]-Low[j+1]);
      InputVector[i++]=100*(Close[j]-Close[j+1]);
     }
//  OutputVector[0]=100*(Close[1]-Close[2]);
   return(true);
  }
//+------------------------------------------------------------------+
//| Заполняем вектор ! вначале -выходы -потом вход                   |
//| Фракталы                                                         |
//+------------------------------------------------------------------+
bool GetVectors_Fractals(double &InputVector[],double &OutputVector[],int num_inputvectors,int num_outputvectors,string smbl="",ENUM_TIMEFRAMES tf=0,int shift=0,int shft_his=7)

                                                                                                                             //bool GetVectors_f(double &InputVector[],double &OutputVector[],int num_ivectors,int num_ovectors,string smbl="",ENUM_TIMEFRAMES tf=0,int npf=3,int shift=0)
  {// пара, период, смещение назад (для индикатора полезно)

   int shft_cur=0;
   int npf=3;
   double Low[],High[];
   ArraySetAsSeries(Low,true); ArraySetAsSeries(High,true);
// копируем историю
   int ncl=CopyLow(smbl,tf,shift,num_inputvectors*10*npf,Low);
   int nch=CopyHigh(smbl,tf,shift,num_inputvectors*10*npf,High);
   ArrayInitialize(InputVector,EMPTY_VALUE);
   ArrayInitialize(OutputVector,EMPTY_VALUE);
   int maxcount=MathMin(ncl,nch);
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(maxcount<num_inputvectors*10*npf)
     {
      Print("Shift = ",shift," maxcount = ",maxcount);
      return(false);
     }
   double UpperBuffer[];
   double LowerBuffer[];
   ArrayResize(UpperBuffer,num_inputvectors*10*npf);
   ArrayResize(LowerBuffer,num_inputvectors*10*npf);
   ArrayInitialize(UpperBuffer,EMPTY_VALUE);
   ArrayInitialize(LowerBuffer,EMPTY_VALUE);
   int i,j;
   for(i=npf-1;i<maxcount-2;i++)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
     {
      if(((5==npf) && (High[i]>High[i+1] && High[i]>High[i+2] && High[i]>=High[i-1] && High[i]>=High[i-2]))
         || ((3==npf) && ((High[i]>High[i+1] && High[i]>=High[i-1]))))
        {
         UpperBuffer[i]=High[i];
         //// проверка что предыдущее тоже верх и ниже
         //for(j=i-1;UpperBuffer[j]==EMPTY_VALUE && LowerBuffer[j]==EMPTY_VALUE && j>0;j--);
         //if(UpperBuffer[j]==EMPTY_VALUE)
         //  {
         //   if(LowerBuffer[j]>UpperBuffer[i])UpperBuffer[i]=EMPTY_VALUE;// ExtUpperBuffer[i]=High[i];
         //  }
         //else
         //  {
         //   if(UpperBuffer[j]>UpperBuffer[i]) UpperBuffer[i]=EMPTY_VALUE;
         //   else
         //     {
         //      UpperBuffer[j]=EMPTY_VALUE;
         //      for(j=i-1;UpperBuffer[j]==EMPTY_VALUE && LowerBuffer[j]==EMPTY_VALUE && j>0;j--);
         //      if(LowerBuffer[j]==EMPTY_VALUE);// ExtUpperBuffer[i]=High[i];
         //      else
         //        {
         //         if(LowerBuffer[j]<LowerBuffer[i]) LowerBuffer[i]=EMPTY_VALUE;
         //         else LowerBuffer[j]=EMPTY_VALUE;
         //        }
         //     }
         //  }
        }
      else UpperBuffer[i]=EMPTY_VALUE;

      //---- Lower Fractal
      if(((5==npf) && (Low[i]<Low[i+1] && Low[i]<Low[i+2] && Low[i]<=Low[i-1] && Low[i]<=Low[i-2]))
         || ((3==npf) && ((Low[i]<Low[i+1] && Low[i]<=Low[i-1]))))
        {
         LowerBuffer[i]=Low[i];
         // проверка что предыдущее тоже верх и ниже
         //for(j=i-1;UpperBuffer[j]==EMPTY_VALUE && LowerBuffer[j]==EMPTY_VALUE && j>0;j--);
         //if(LowerBuffer[j]==EMPTY_VALUE)
         //  {
         //   if(UpperBuffer[j]<LowerBuffer[i]) LowerBuffer[i]=EMPTY_VALUE;
         //  }
         //else
         //  {
         //   if(LowerBuffer[j]<LowerBuffer[i]) LowerBuffer[i]=EMPTY_VALUE;
         //   else
         //     {
         //      LowerBuffer[j]=EMPTY_VALUE;
         //      for(j=i-1;UpperBuffer[j]==EMPTY_VALUE && LowerBuffer[j]==EMPTY_VALUE && j>0;j--);
         //      if(UpperBuffer[j]==EMPTY_VALUE);// ExtUpperBuffer[i]=High[i];
         //      else
         //        {
         //         if(UpperBuffer[j]>UpperBuffer[i]) UpperBuffer[i]=EMPTY_VALUE;
         //        }
         //     }
         //  }

        }
      else LowerBuffer[i]=EMPTY_VALUE;
     }
// Возьмем num_vectors значимых элементов
// вначале проверим что последний "красивый" -тоесть на котором можно заработать
   int fp=npf-1;
   double prf=0,prl=0;
   if(UpperBuffer[fp]==EMPTY_VALUE && LowerBuffer[fp]==EMPTY_VALUE) return(false);// нет фрактала  
   if(LowerBuffer[fp]==EMPTY_VALUE)// ExtUpperBuffer[i]=High[i];
      prf=UpperBuffer[fp];
   else  prf=LowerBuffer[fp];
//fp=j;
   for(j=fp+1;UpperBuffer[j]==EMPTY_VALUE && LowerBuffer[j]==EMPTY_VALUE && j<maxcount;j++);
   if(LowerBuffer[j]==EMPTY_VALUE)// ExtUpperBuffer[i]=High[i];
      prl=UpperBuffer[j];
   else  prl=LowerBuffer[j];
// заполняем массив выходной 
   double res=(prf-prl)/(SymbolInfoInteger(smbl,SYMBOL_SPREAD)*SymbolInfoDouble(smbl,SYMBOL_POINT));
   if(res>10)
      OutputVector[0]=0.95;
   else if(res>5)
      OutputVector[0]=0.50;
   else if(res>1)
      OutputVector[0]=0.25;
   else if(res<-10)
      OutputVector[0]=-0.95;
   else if(res<-5)
      OutputVector[0]=-0.50;
   else if(res<-1)
      OutputVector[0]=-0.25;
   else    OutputVector[0]=0.0;
   prf=prl;fp=j;
   for(i=0;i<num_inputvectors;i++)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
     {
      for(j=fp+1;UpperBuffer[j]==EMPTY_VALUE && LowerBuffer[j]==EMPTY_VALUE && j<maxcount;j++);
      if(LowerBuffer[j]==EMPTY_VALUE)// ExtUpperBuffer[i]=High[i];
         prl=UpperBuffer[j];
      else  prl=LowerBuffer[j];
      InputVector[i]=(prf-prl)/1000/SymbolInfoDouble(smbl,SYMBOL_POINT);      prf=prl;fp=j;
     }

   return(true);// 

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool GetVectors_RSI(double &InputVector[],double &OutputVector[],int num_inputvectors,int num_outputvectors,string smbl="",ENUM_TIMEFRAMES tf=0,int shift=0,int shft_his=0)
  {// пара, период, смещение назад (для индикатора полезно)
   int h_rsi=iRSI(smbl,tf,14,PRICE_CLOSE);
   double rsi_buffer[];
   if(!ArraySetAsSeries(rsi_buffer,true)) return(false);
   if(CopyBuffer(h_rsi,0,shift+shft_his,num_inputvectors+1,rsi_buffer)<(num_inputvectors+1)) return(false);
   double Close[];
   ArraySetAsSeries(Close,true);
// копируем историю
   int maxcount=CopyClose(smbl,tf,shift,num_inputvectors+num_outputvectors+2,Close);
   ArrayInitialize(InputVector,EMPTY_VALUE);
   ArrayInitialize(OutputVector,EMPTY_VALUE);
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(maxcount<num_inputvectors+num_outputvectors+2)
     {
      Print("Shift = ",shift," maxcount = ",maxcount);
      return(false);
     }
   OutputVector[0]=100*(Close[0]-Close[shft_his]);
   int i;   double res=0;
   for(i=0;i<num_inputvectors;i++)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
     {
      // вычислим и отнормируем
      res=(rsi_buffer[i]-50.0)/50.0;
      if(MathAbs(res)>1)
        {
         if(res>0)
           {
            InputVector[i]=1.0;
              } else {
            InputVector[i]=-1.0;
           }
           } else {
         InputVector[i]=res;
        }
     }
//  OutputVector[0]=100*(Close[1]-Close[2]);
   return(true);
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
