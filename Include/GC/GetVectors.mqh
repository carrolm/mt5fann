//+------------------------------------------------------------------+
//|                                                   GetVectors.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#include <GC\CommonFunctions.mqh>
string VectorFunctions[21]={"Fractals","Easy","RSI","HL","High","Low","","","","","","",""};
//+---------------------------------------------------------------------+
//| входные вектора даются только на фракталах -пиках -90% что разворот |
//| входных веторов может быть много                                    |
//| выходной веторвсегда один - сигнал на покупку/продажу               |
//+---------------------------------------------------------------------+
bool GetVectors(double &InputVector[],double &OutputVector[],int num_inputvectors,int num_outputvectors,string fn_name,string smbl="",ENUM_TIMEFRAMES tf=0,int shift=0)
  {// пара, период, смещение назад (для индикатора полезно)
   bool ret=false;
   int shift_history=7;//
   if(""==smbl) smbl=_Symbol;
   if(0==tf) tf=_Period;
   if(0==num_outputvectors) shift_history=0;
// работаем только если есть фарктал! только на экстремумах!
   ArrayInitialize(InputVector,EMPTY_VALUE);
   ArrayInitialize(OutputVector,EMPTY_VALUE);
   double Low[],High[];
   ArraySetAsSeries(Low,true); ArraySetAsSeries(High,true);
// копируем историю
   int ncl=CopyLow(smbl,tf,shift+shift_history,4,Low);
   int nch=CopyHigh(smbl,tf,shift+shift_history,4,High);
   if((High[2]>High[1] && High[2]>High[3]) || (Low[2]<Low[1] && Low[2]<Low[3]))
     {// Есть!
      if("Easy"==fn_name) ret=GetVectors_Easy(InputVector,num_inputvectors,smbl,tf,shift,shift_history);
      if("RSI"==fn_name) ret=GetVectors_RSI(InputVector,num_inputvectors,smbl,tf,shift,shift_history);
      if("Fractals"==fn_name) ret=GetVectors_Fractals(InputVector,num_inputvectors,smbl,tf,shift,shift_history);
      if("HL"==fn_name) ret=GetVectors_HL(InputVector,num_inputvectors,smbl,tf,shift,shift_history);
      if("High"==fn_name) ret=GetVectors_High(InputVector,num_inputvectors,smbl,tf,shift,shift_history);
      if("Low"==fn_name) ret=GetVectors_Low(InputVector,num_inputvectors,smbl,tf,shift,shift_history);
      //   if("sinex"==fn_name) return(GetVectors_Sinex(InputVector,OutputVector,num_inputvectors,num_outputvectors,shift,params));
      if(shift_history>0) OutputVector[0]=GetTrend(shift_history,smbl,tf,shift);
     }
   return(ret);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetTrend(int shift_history,string smb="",ENUM_TIMEFRAMES tf=0,int shift=0)
  {
   double mS=0,mB=0,S=0,B=0;
   double Close[]; ArraySetAsSeries(Close,true);
   double High[]; ArraySetAsSeries(High,true);
   double Low[]; ArraySetAsSeries(Low,true);
   datetime Time[]; ArraySetAsSeries(Time,true);
//if(num_outputvectors!=2 ||num_inputvectors%3!=0)
//  {
//   Print("Output vectors only 2!");
//   return(false);
//  }
// копируем историю
   if(""==smb) smb=_Symbol;
   if(0==tf) tf=_Period;
   int maxcount=CopyHigh(smb,tf,shift,shift_history+3,High);
   maxcount=CopyClose(smb,tf,shift,shift_history+3,Close);
   maxcount=CopyLow(smb,tf,shift,shift_history+3,Low);
   maxcount=CopyTime(smb,tf,shift,shift_history+3,Time);
   double res=0;
   int is,ib;
//Print(Time[1]," ",Time[shift_history]);
   if((High[shift_history+1]>High[shift_history] && High[shift_history+1]>High[shift_history+2]) || (Low[shift_history+1]<Low[shift_history] && Low[shift_history+1]<Low[shift_history+2]))
     {
      S=Close[shift_history]; B=Close[shift_history];
      is=ib=shift_history;
      double   TS=(int)(3*SymbolInfoInteger(smb,SYMBOL_TRADE_STOPS_LEVEL));
      //if(TS<SymbolInfoInteger(smb,SYMBOL_TRADE_STOPS_LEVEL)) TS=(int)SymbolInfoInteger(smb,SYMBOL_TRADE_STOPS_LEVEL);
      if(0==TS) TS=60;
      TS=TS*SymbolInfoDouble(smb,SYMBOL_POINT);
      //  ObjectCreate(0,"GV_S",OBJ_ARROWED_LINE,0,Time[10],Close[10],Time[1],Low[1]);
      //   ObjectCreate(0,name,OBJ_BUTTON,window,0,0);

      for(int i=shift_history-1;i>0;i--)
        {
         if(0==mS)
           {
            if(Close[i]<(High[i]-TS))
              {
               mS=Close[shift_history]-S;
               //S=0;
              }
            else
              {
               if(S>Low[i]){S=Low[i];is=i;}
               ObjectCreate(0,"GV_S_"+(string)shift,OBJ_ARROWED_LINE,0,Time[shift_history],Close[shift_history],Time[is],S);
              }
           }
         if(0==mB)
           {
            if(Close[i]>(Low[i]+TS))
              {
               mB=B-Close[shift_history];
               //B=0;
              }
            else
              {
               if(B<High[i]) {B=High[i];ib=i;}
               ObjectCreate(0,"GV_B_"+(string)shift,OBJ_ARROWED_LINE,0,Time[shift_history],Close[shift_history],Time[ib],B);
              }
           }

        }
      mB=B-Close[shift_history];mS=Close[shift_history]-S;
      double rat;//=(prf-prl)/(SymbolInfoInteger(smbl,SYMBOL_SPREAD)*SymbolInfoDouble(smbl,SYMBOL_POINT));
      if(mS>mB) {rat=-mS;ObjectDelete(0,"GV_B_"+(string)shift);}
      else      { rat=mB;ObjectDelete(0,"GV_S_"+(string)shift);}
      rat=rat/(SymbolInfoInteger(smb,SYMBOL_TRADE_STOPS_LEVEL)*SymbolInfoDouble(smb,SYMBOL_POINT));
      res=2*(1/(1+MathExp(-rat/5))-0.5);
      //if(rat>1) res=0.25;
      //if(rat>5)  res=0.50;
      //if(rat>10) res=0.95;
      //if(rat<-1) res=-0.25;
      //if(rat<-5) res=-0.50;
      //if(rat<-10) res=-0.95;
     }
   return(res);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool GetVectors_Easy(double &InputVector[],int num_inputvectors,string smbl="",ENUM_TIMEFRAMES tf=0,int shift=0,int shft_his=7)
  {// пара, период, смещение назад (для индикатора полезно)

   int shft_cur=0;

   double Close[];
   ArraySetAsSeries(Close,true);
// копируем историю
   int maxcount=CopyClose(smbl,tf,shift,num_inputvectors+2,Close);
   ArrayInitialize(InputVector,EMPTY_VALUE);

   if(maxcount<num_inputvectors+2)
     {
      Print("Shift = ",shift," maxcount = ",maxcount);
      return(false);
     }
   int i,j;j=1;
   for(i=0;i<num_inputvectors;i++,j++)
     {
      // вычислим и отнормируем
      InputVector[i]=100*(Close[j]-Close[j+1]);
     }
//  OutputVector[0]=100*(Close[1]-Close[2]);
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Прогноз минимальных и максимальных цен                           |
//+------------------------------------------------------------------+
bool GetVectors_HL(double &InputVector[],int num_inputvectors,string smbl="",ENUM_TIMEFRAMES tf=0,int shift=0,int shft_his=7)
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
   int maxcount=CopyHigh(smbl,tf,shift,num_inputvectors+2,High);
   maxcount=CopyClose(smbl,tf,shift,num_inputvectors+2,Close);
   maxcount=CopyLow(smbl,tf,shift,num_inputvectors+2,Low);


   if(maxcount<num_inputvectors+2)
     {
      Print("Shift = ",shift," maxcount = ",maxcount);
      return(false);
     }
   int i,j;j=1;

   for(i=0;i<num_inputvectors;j++)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
     {
      // вычислим и отнормируем
      InputVector[i++]=1000*(High[j]-High[j+1]);
      InputVector[i++]=1000*(Low[j]-Low[j+1]);
      InputVector[i++]=1000*(Close[j]-Close[j+1]);
     }
//  OutputVector[0]=100*(Close[1]-Close[2]);
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Прогноз  максимальных цен                           |
//+------------------------------------------------------------------+
bool GetVectors_High(double &InputVector[],int num_inputvectors,string smbl="",ENUM_TIMEFRAMES tf=0,int shift=0,int shft_his=7)
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
   int maxcount=CopyHigh(smbl,tf,shift,num_inputvectors+2,High);
   maxcount=CopyClose(smbl,tf,shift,num_inputvectors+2,Close);
   maxcount=CopyLow(smbl,tf,shift,num_inputvectors+2,Low);

   if(maxcount<num_inputvectors+2)
     {
      Print("Shift = ",shift," maxcount = ",maxcount);
      return(false);
     }
   int i,j;j=1;
// вычислим и отнормируем
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
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Прогноз  максимальных цен                           |
//+------------------------------------------------------------------+
bool GetVectors_Low(double &InputVector[],int num_inputvectors,string smbl="",ENUM_TIMEFRAMES tf=0,int shift=0,int shft_his=7)
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
   int maxcount=CopyHigh(smbl,tf,shift,num_inputvectors+2,High);
   maxcount=CopyClose(smbl,tf,shift,num_inputvectors+2,Close);
   maxcount=CopyLow(smbl,tf,shift,num_inputvectors+2,Low);


   if(maxcount<num_inputvectors+2)
     {
      Print("Shift = ",shift," maxcount = ",maxcount);
      return(false);
     }
   int i,j;j=1;
// вычислим и отнормируем
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
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Заполняем вектор ! вначале -выходы -потом вход                   |
//| Фракталы                                                         |
//+------------------------------------------------------------------+
bool GetVectors_Fractals(double &InputVector[],int num_inputvectors,string smbl="",ENUM_TIMEFRAMES tf=0,int shift=0,int shft_his=7)

                                                                                //bool GetVectors_f(double &InputVector[],double &OutputVector[],int num_ivectors,int num_ovectors,string smbl="",ENUM_TIMEFRAMES tf=0,int npf=3,int shift=0)
  {// пара, период, смещение назад (для индикатора полезно)

   int shft_cur=0;
   int npf=3;
   double Low[],High[];
   ArraySetAsSeries(Low,true); ArraySetAsSeries(High,true);
// копируем историю
   int ncl=CopyLow(smbl,tf,shift,num_inputvectors*10*npf,Low);
   int nch=CopyHigh(smbl,tf,shift,num_inputvectors*10*npf,High);

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
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool GetVectors_RSI(double &InputVector[],int num_inputvectors,string smbl="",ENUM_TIMEFRAMES tf=0,int shift=0,int shft_his=0)
  {// пара, период, смещение назад (для индикатора полезно)
   int h_rsi=iRSI(smbl,tf,14,PRICE_CLOSE);
   double rsi_buffer[];
   if(!ArraySetAsSeries(rsi_buffer,true)) return(false);
   if(CopyBuffer(h_rsi,0,shift+shft_his,num_inputvectors+1,rsi_buffer)<(num_inputvectors+1)) return(false);
   double Close[];
   ArraySetAsSeries(Close,true);
// копируем историю
   int maxcount=CopyClose(smbl,tf,shift,num_inputvectors+2,Close);

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(maxcount<num_inputvectors+2)
     {
      Print("Shift = ",shift," maxcount = ",maxcount);
      return(false);
     }
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
