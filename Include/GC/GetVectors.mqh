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
double Sigmoid(double x)// вычисление логистической функции активации
  {
   return(1/(1+exp(-x)));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool GetVectors(double &InputVector[],double &OutputVector[],int num_inputvectors,int num_outputvectors,string fn_name,string smbl="",ENUM_TIMEFRAMES tf=0,int shift=0)
  {// пара, период, смещение назад (для индикатора полезно)
   bool ret=false;
   if(0==num_inputvectors && 0==num_outputvectors) return(false);
   int shift_history=30,i;//
   if(""==smbl) smbl=_Symbol;
   if(0==tf) tf=_Period;
   if(0==num_outputvectors) shift_history=0;
// работаем только если есть фарктал! только на экстремумах!
   ArrayInitialize(InputVector,0);
   ArrayInitialize(OutputVector,0);
   double Low[],High[];
   ArraySetAsSeries(Low,true); ArraySetAsSeries(High,true);
// копируем историю
   int ncl=CopyLow(smbl,tf,shift+shift_history,4,Low);
   int nch=CopyHigh(smbl,tf,shift+shift_history,4,High);
//if((High[1]>High[0] && High[1]>High[2])
//   || (Low[1]<Low[0] && Low[1]<Low[2]))
   if(shift_history>0) OutputVector[0]=Sigmoid(GetTrend(shift_history,smbl,tf,shift))-0.5;
   if(num_inputvectors>0)
     {// Есть фрактал!
      if("Easy"==fn_name) ret=GetVectors_Easy(InputVector,num_inputvectors,smbl,tf,shift+shift_history);
      if("RSI"==fn_name) ret=GetVectors_RSI(InputVector,num_inputvectors,smbl,tf,shift+shift_history);
      if("Fractals"==fn_name) ret=GetVectors_Fractals(InputVector,num_inputvectors,smbl,tf,shift+shift_history);
      if("HL"==fn_name) ret=GetVectors_HL(InputVector,num_inputvectors,smbl,tf,shift+shift_history);
      if("High"==fn_name) ret=GetVectors_High(InputVector,num_inputvectors,smbl,tf,shift+shift_history);
      if("Low"==fn_name) ret=GetVectors_Low(InputVector,num_inputvectors,smbl,tf,shift+shift_history);
      //   if("sinex"==fn_name) return(GetVectors_Sinex(InputVector,OutputVector,num_inputvectors,num_outputvectors,shift,params));

      //      if(shift_history>0) OutputVector[0]=GetTrend(shift_history,smbl,tf,shift);
      // нормируем в гиперкуб -0.5...0.5
      double sq=0;
      for(i=0;i<num_inputvectors;i++) sq+=InputVector[i]*InputVector[i]; sq=MathSqrt(sq); if(0==sq) return(false);
      for(i=0;i<num_inputvectors;i++) InputVector[i]=InputVector[i]/sq;
      //     for(i=0;i<num_inputvectors;i++) InputVector[i]=Sigmoid(InputVector[i]/sq)-0.5;
      //for(i=0;i<num_inputvectors;i++) InputVector[i]=Sigmoid(InputVector[i]/sq);
      //double min=InputVector[0];
      //for(i=0;i<num_inputvectors;i++) if(InputVector[i]<min) min=InputVector[i];
      //for(i=0;i<num_inputvectors;i++) InputVector[i]-=min;
      //double max=InputVector[0];
      //for(i=0;i<num_inputvectors;i++) if(InputVector[i]>max) max=InputVector[i];if(max==0) max=1;
      //for(i=0;i<num_inputvectors;i++) InputVector[i]=2*InputVector[i]/max-1;

     }
   return(ret);
  }
//+------------------------------------------------------------------+
//| Удаляет мусорные объекты на графиках                             |
//+------------------------------------------------------------------+
void DelTrash()
  {
   for(int i=ObjectsTotal(0);i>=0;i--)
      if(StringSubstr(ObjectName(0,i),0,3)=="GV_") ObjectDelete(0,ObjectName(0,i));

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetTrend(int shift_history,string smb="",ENUM_TIMEFRAMES tf=0,int shift=0,bool draw=false)
  {

   double mS=0,mB=0,S=0,B=0;
   double Close[]; ArraySetAsSeries(Close,true);
   double High[]; ArraySetAsSeries(High,true);
   double Low[]; ArraySetAsSeries(Low,true);
   datetime Time[]; ArraySetAsSeries(Time,true);
// копируем историю
   if(""==smb) smb=_Symbol;
   if(0==tf) tf=_Period;
// TF всегда минутка!
   tf=PERIOD_M1;
   int maxcount=CopyHigh(smb,tf,shift,shift_history+3,High);
   maxcount=CopyClose(smb,tf,shift,shift_history+3,Close);
   maxcount=CopyLow(smb,tf,shift,shift_history+3,Low);
   maxcount=CopyTime(smb,tf,shift,shift_history+3,Time);
   double res=0;
   int is,ib;
//   if((High[shift_history+1]>High[shift_history] && High[shift_history+1]>High[shift_history+2]) || (Low[shift_history+1]<Low[shift_history] && Low[shift_history+1]<Low[shift_history+2]))
     {
      S=Close[shift_history]-0.0000001; B=Close[shift_history]+0.0000001;
      is=ib=shift_history;
      double  TS=SymbolInfoDouble(smb,SYMBOL_POINT)*(2*SymbolInfoInteger(smb,SYMBOL_TRADE_STOPS_LEVEL));

      for(int i=shift_history-1;i>0;i--)
        {
         if(0==mS)
           {
            if(Close[i]>(Low[i]+TS) || S<(High[i]-TS))
              {
               if(S>Low[i]){S=Low[i];is=i;}
               mS=Close[shift_history]-S;
               //S=0;
              }
            else
              {
               if(S>Low[i]){S=Low[i];is=i;}
              }
           }
         if(0==mB)
           {
            if(Close[i]<(High[i]-TS) || B>(Low[i]+TS))
              {
               if(B<High[i]) {B=High[i];ib=i;}
               mB=B-Close[shift_history];
               //B=0;
              }
            else
              {
               if(B<High[i]) {B=High[i];ib=i;}
              }
           }

        }
      //mB=B-Close[shift_history];mS=Close[shift_history]-S;
      //=(prf-prl)/(SymbolInfoInteger(smbl,SYMBOL_SPREAD)*SymbolInfoDouble(smbl,SYMBOL_POINT));
      if(draw)ObjectCreate(0,"GV_S_"+(string)shift,OBJ_ARROWED_LINE,0,Time[shift_history],Close[shift_history],Time[is],S);
      if(draw)ObjectCreate(0,"GV_B_"+(string)shift,OBJ_ARROWED_LINE,0,Time[shift_history],Close[shift_history],Time[ib],B);
      if(mS>mB) {res=-mS;ObjectDelete(0,"GV_B_"+(string)shift);if(2*TS>-res) ObjectDelete(0,"GV_S_"+(string)shift);}
      else      { res=mB;ObjectDelete(0,"GV_S_"+(string)shift);if(2*TS>res) ObjectDelete(0,"GV_B_"+(string)shift);}
      res=res/(SymbolInfoInteger(smb,SYMBOL_TRADE_STOPS_LEVEL)*SymbolInfoDouble(smb,SYMBOL_POINT))/5;
      //res=1*(1/(1+MathExp(-1*res/5))-0.5);
     }
   return(res);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool GetVectors_Easy(double &InputVector[],int num_inputvectors,string smbl="",ENUM_TIMEFRAMES tf=0,int shift=0)
  {// пара, период, смещение назад (для индикатора полезно)

   int shft_cur=0;

   double Close[];
   ArraySetAsSeries(Close,true);
// копируем историю
   int maxcount=CopyClose(smbl,tf,shift,num_inputvectors+5,Close);
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
      InputVector[i]=MathLog(Close[j]/Close[j+1]);
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
bool GetVectors_HL(double &InputVector[],int num_inputvectors,string smbl="",ENUM_TIMEFRAMES tf=0,int shift=0)
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
bool GetVectors_High(double &InputVector[],int num_inputvectors,string smbl="",ENUM_TIMEFRAMES tf=0,int shift=0)
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
//| Прогноз  минимальных цен                           |
//+------------------------------------------------------------------+
bool GetVectors_Low(double &InputVector[],int num_inputvectors,string smbl="",ENUM_TIMEFRAMES tf=0,int shift=0)
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
bool GetVectors_Fractals(double &InputVector[],int num_inputvectors,string smbl="",ENUM_TIMEFRAMES tf=0,int shift=0)

                                                                                //bool GetVectors_f(double &InputVector[],double &OutputVector[],int num_ivectors,int num_ovectors,string smbl="",ENUM_TIMEFRAMES tf=0,int npf=3,int shift=0)
  {// пара, период, смещение назад (для индикатора полезно)

   int shft_cur=0;
   int npf=3;
   double Low[],High[],Close[];
   ArraySetAsSeries(Low,true); ArraySetAsSeries(High,true);ArraySetAsSeries(Close,true);
// копируем историю
   int ncl=CopyLow(smbl,tf,shift,num_inputvectors*10*npf,Low);
   int nch=CopyHigh(smbl,tf,shift,num_inputvectors*10*npf,High);
   int ncc=CopyHigh(smbl,tf,shift,2,Close);

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
//Считаем  относительно цены закрытия последнего бара
   int fp=npf-1;
   double prf=0,prl=0;
//if(UpperBuffer[fp]==EMPTY_VALUE && LowerBuffer[fp]==EMPTY_VALUE) return(false);// нет фрактала  
//if(LowerBuffer[fp]==EMPTY_VALUE)// ExtUpperBuffer[i]=High[i];
//   prf=UpperBuffer[fp];
//else  prf=LowerBuffer[fp];
   prf=Close[0]; double res;
   for(i=0;i<num_inputvectors;i++)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
     {
      for(j=fp+1;UpperBuffer[j]==EMPTY_VALUE && LowerBuffer[j]==EMPTY_VALUE && j<maxcount;j++);
      if(LowerBuffer[j]==EMPTY_VALUE)// ExtUpperBuffer[i]=High[i];
         prl=UpperBuffer[j];
      else  prl=LowerBuffer[j];
      res=(prf-prl);///SymbolInfoDouble(smbl,SYMBOL_POINT);
      res=res/(SymbolInfoInteger(smbl,SYMBOL_TRADE_STOPS_LEVEL)*SymbolInfoDouble(smbl,SYMBOL_POINT));
      res=1*(1/(1+MathExp(-1*res/5)));//-0.5);
      InputVector[i]=res;      prf=prl;fp=j;
     }

   return(true);// 

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool GetVectors_RSI(double &InputVector[],int num_inputvectors,string smbl="",ENUM_TIMEFRAMES tf=0,int shift=0)
  {// пара, период, смещение назад (для индикатора полезно)
   int h_rsi=iRSI(smbl,tf,14,PRICE_CLOSE);
   double rsi_buffer[];
   if(!ArraySetAsSeries(rsi_buffer,true)) return(false);
   if(CopyBuffer(h_rsi,0,shift,num_inputvectors+1,rsi_buffer)<(num_inputvectors+1)) return(false);
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
      res=(rsi_buffer[i])/100.0;
      if(MathAbs(res)>0.5)
        {
         if(res>0)
           {
            InputVector[i]=0.5;
              } else {
            InputVector[i]=-0.5;
           }
        }
      else
        {
         InputVector[i]=res;
        }
     }
//  OutputVector[0]=100*(Close[1]-Close[2]);
   return(true);
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
