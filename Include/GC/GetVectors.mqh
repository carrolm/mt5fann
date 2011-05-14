//+------------------------------------------------------------------+
//|                                                   GetVectors.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#include <GC\CommonFunctions.mqh>
string VectorFunctions[21]={"DayOfWeek","Hour","Minute","EasyClose","Fractals","RSI","IMA","StochasticK","StochasticD","HL","High","Low","MACD","CCI","WPR","AMA","AO","Ichimoku","Envelopes"};
//+---------------------------------------------------------------------+
//| входные вектора даются только на фракталах -пиках -90% что разворот |
//| входных веторов может быть много                                    |
//| выходной веторвсегда один - сигнал на покупку/продажу               |
//+---------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Гиперболический тангенс                                          |
//+------------------------------------------------------------------+
double tanh(double x)
  {
   double x_=MathExp(x);
   double _x=MathExp(-x);
   if(0==(x_+_x)) return(0);
   return((x_-_x)/(x_+_x));
  }
//+------------------------------------------------------------------+
//| Сигмоидальная логистическая функция                                          |
//+------------------------------------------------------------------+

double Sigmoid(double x)// вычисление логистической функции активации
  {
   return(1/(1+exp(-x)));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetVectors(double &InputVector[],string fn_names,string smbl,ENUM_TIMEFRAMES tf,int shift)
  {// пара, период, смещение назад (для индикатора полезно)
   double output_vector=0;
   int shift_history=15,ni=0;
   //if(shift<shift_history) shift_history=0;
   ArrayInitialize(InputVector,0);
// вернем выход -если история
   if(shift>shift_history>0) output_vector=GetTrend(shift_history,smbl,tf,shift-shift_history,false,2);
   if(StringLen(fn_names)<5) return output_vector;
// разберем строку...
   int start_pos=0,end_pos=0,shift_pos=0,add_shift;
   end_pos=StringFind(fn_names," ",start_pos);
   do //while(end_pos>0)
     {
      add_shift=0;
      shift_pos= StringFind(fn_names,"-",start_pos);
      if(shift_pos>0 && (shift_pos<end_pos||-1==end_pos))
        {
         add_shift=(int)StringToInteger(StringSubstr(fn_names,start_pos,shift_pos-start_pos));
         start_pos=shift_pos+1;
        }
       //      Print("-"+StringSubstr(fn_names,start_pos,end_pos-start_pos)+"-");
      InputVector[ni++]=GetVectorByName(StringSubstr(fn_names,start_pos,end_pos-start_pos),smbl,tf,shift+add_shift-1);
      start_pos=end_pos+1;    end_pos=StringFind(fn_names," ",start_pos);
     }
   while(start_pos>0);
   return output_vector;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetVectorByName(string fn_name,string smbl,ENUM_TIMEFRAMES tf,int shift)
  {
//Print("Process=",fn_name);

   if("DayOfWeek"==fn_name) return GetVector_DayOfWeek(smbl,tf,shift);
   if("Hour"==fn_name) return GetVector_Hour(smbl,tf,shift);
   if("Minute"==fn_name) return GetVector_Minute(smbl,tf,shift);
   if("EasyClose"==fn_name) return GetVector_EasyClose(smbl,tf,shift);
   if("StochasticK"==fn_name) return GetVector_StochasticK(smbl,tf,shift);
   if("StochasticD"==fn_name) return GetVector_StochasticD(smbl,tf,shift);
   if("RSI"==fn_name) return GetVector_RSI(smbl,tf,shift);
   if("IMA"==fn_name) return GetVector_IMA(smbl,tf,shift);
   if("MACD"==fn_name) return GetVector_MACD(smbl,tf,shift);
   if("CCI"==fn_name) return GetVector_CCI(smbl,tf,shift);
   if("WPR"==fn_name) return GetVector_WPR(smbl,tf,shift);
   if("AMA"==fn_name) return GetVector_AMA(smbl,tf,shift);
   if("AO"==fn_name) return GetVector_AO(smbl,tf,shift);
   if("Ichimoku"==fn_name) return GetVector_Ichimoku(smbl,tf,shift);
   if("Envelopes"==fn_name) return GetVector_Envelopes(smbl,tf,shift);
   Print("Not found fn=",fn_name);
   return 0.0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetVector_WPR(string smb,ENUM_TIMEFRAMES tf,int shift)
  {// пара, период, смещение назад (для индикатора полезно)
   int h_ind=iWPR(smb,tf,14);
   if(h_ind==INVALID_HANDLE) return(0);//--- если хэндл невалидный
   double ind_buffer[];
   if(!ArraySetAsSeries(ind_buffer,true)) return(0);
   if(CopyBuffer(h_ind,0,shift,5,ind_buffer)<(5)) return(0);

   IndicatorRelease(h_ind);
   return ind_buffer[1]/100+0.5;

  }
//+------------------------------------------------------------------+

double GetVector_AMA(string smb,ENUM_TIMEFRAMES tf,int shift)
  {// пара, период, смещение назад (для индикатора полезно)
   int h_ind=iAMA(smb,tf,9,2,30,0,PRICE_CLOSE);
   if(h_ind==INVALID_HANDLE) return(false);//--- если хэндл невалидный
   double ind_buffer[];
   if(!ArraySetAsSeries(ind_buffer,true)) return(0);
   if(CopyBuffer(h_ind,0,shift,5,ind_buffer)<5) return(0);

   IndicatorRelease(h_ind);
   return MathLog10(ind_buffer[1]/ind_buffer[2])*10000;

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetVector_AO(string smb,ENUM_TIMEFRAMES tf,int shift)
  {// пара, период, смещение назад (для индикатора полезно)
   int h_ind=iAO(smb,tf);
   if(h_ind==INVALID_HANDLE) return(0);//--- если хэндл невалидный
   double ind_buffer[];
   if(!ArraySetAsSeries(ind_buffer,true)) return(0);
   if(CopyBuffer(h_ind,0,shift,5,ind_buffer)<5) return(0);

   IndicatorRelease(h_ind);
   return tanh(MathLog10(ind_buffer[1]/ind_buffer[2]));

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetVector_Ichimoku(string smb,ENUM_TIMEFRAMES tf,int shift)
  {// пара, период, смещение назад (для индикатора полезно)
   int h_ind=iIchimoku(smb,tf,9,26,52);
   if(h_ind==INVALID_HANDLE) return(false);//--- если хэндл невалидный
   double ind_buffer[];
   if(!ArraySetAsSeries(ind_buffer,true)) return(0);
   if(CopyBuffer(h_ind,0,shift,5,ind_buffer)<5) return(0);

   IndicatorRelease(h_ind);
   return MathLog10(ind_buffer[1]/ind_buffer[2])*10000;
  }
//+------------------------------------------------------------------+
double GetVector_Envelopes(string smb,ENUM_TIMEFRAMES tf,int shift)
  {// пара, период, смещение назад (для индикатора полезно)
   int h_ind=iEnvelopes(smb,tf,28,0,MODE_SMA,PRICE_MEDIAN,0.1);
   if(h_ind==INVALID_HANDLE) return(0);//--- если хэндл невалидный
   double ind_buffer[];
   if(!ArraySetAsSeries(ind_buffer,true)) return(0);
   if(CopyBuffer(h_ind,0,shift,5,ind_buffer)<5) return(0);

   IndicatorRelease(h_ind);

   return MathLog10(ind_buffer[1]/ind_buffer[2])*10000;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetVector_IMA(string smb,ENUM_TIMEFRAMES tf,int shift)
  {// пара, период, смещение назад (для индикатора полезно)
   int h_ind=iMA(smb,tf,6,0,MODE_LWMA,PRICE_WEIGHTED);
   if(h_ind==INVALID_HANDLE) return(0);//--- если хэндл невалидный
   double ind_buffer[];
   if(!ArraySetAsSeries(ind_buffer,true)) return(0);
   if(CopyBuffer(h_ind,0,shift,5,ind_buffer)<(5)) return(0);
   IndicatorRelease(h_ind);
   return MathLog10(ind_buffer[1]/ind_buffer[2])*1000;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetVector_MACD(string smb,ENUM_TIMEFRAMES tf,int shift)
  {// пара, период, смещение назад (для индикатора полезно)
   int h_ind=iMACD(smb,tf,12,26,9,PRICE_CLOSE);
   if(h_ind==INVALID_HANDLE) return(0);//--- если хэндл невалидный
   double ind_buffer[];
   if(!ArraySetAsSeries(ind_buffer,true)) return(0);
   if(CopyBuffer(h_ind,0,shift,5,ind_buffer)<5) return(0);

   IndicatorRelease(h_ind);
   return tanh(MathLog10(ind_buffer[1]/ind_buffer[2]));

  }
//+------------------------------------------------------------------+
double GetVector_CCI(string smb,ENUM_TIMEFRAMES tf,int shift)
  {// пара, период, смещение назад (для индикатора полезно)
   int h_ind=iCCI(smb,tf,14,PRICE_TYPICAL);
   if(h_ind==INVALID_HANDLE) return(false);//--- если хэндл невалидный
   double ind_buffer[];
   if(!ArraySetAsSeries(ind_buffer,true)) return(0);
   if(CopyBuffer(h_ind,0,shift,5,ind_buffer)<5) return(0);
   IndicatorRelease(h_ind);
   return tanh(MathLog10(ind_buffer[1]/ind_buffer[2])/10);

  }
//+------------------------------------------------------------------+

double GetVector_DayOfWeek(string smb,ENUM_TIMEFRAMES tf,int shift)
  {
   datetime Time[]; ArraySetAsSeries(Time,true);
   CopyTime(smb,tf,shift,3,Time);
   MqlDateTime tm;

   TimeToStruct(Time[1],tm);
   return((double)tm.day_of_week/3.5-1);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetVector_Hour(string smb,ENUM_TIMEFRAMES tf,int shift)
  {
   datetime Time[]; ArraySetAsSeries(Time,true);
   CopyTime(smb,tf,shift,3,Time);
   MqlDateTime tm;

   TimeToStruct(Time[1],tm);
   return((double)tm.hour/12-1);
  }
  double GetVector_Minute(string smb,ENUM_TIMEFRAMES tf,int shift)
  {
   datetime Time[]; ArraySetAsSeries(Time,true);
   CopyTime(smb,tf,shift,3,Time);
   MqlDateTime tm;

   TimeToStruct(Time[1],tm);
   return((double)tm.min/30-1);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetVector_EasyClose(string smb,ENUM_TIMEFRAMES tf,int shift)
  {// пара, период, смещение назад (для индикатора полезно)

   double  TS=SymbolInfoDouble(smb,SYMBOL_POINT)*(SymbolInfoInteger(smb,SYMBOL_TRADE_STOPS_LEVEL));

   double Close[];
   ArraySetAsSeries(Close,true);
// копируем историю
   int maxcount=CopyClose(smb,tf,shift,3,Close);
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(maxcount<3)
     {
      Print("Shift = ",shift," maxcount = ",maxcount);
      return(false);
     }
   return tanh(MathLog(Close[1]/Close[2])/TS);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetVector_StochasticK(string smb,ENUM_TIMEFRAMES tf,int shift)
  {// пара, период, смещение назад (для индикатора полезно)
   int h_ind=iStochastic(smb,tf,5,3,3,MODE_SMA,STO_LOWHIGH);
   double ind_buffer[];
   if(!ArraySetAsSeries(ind_buffer,true)) return(0);
   if(CopyBuffer(h_ind,0,shift,5,ind_buffer)<(5)) return(0);

   IndicatorRelease(h_ind);
   return ind_buffer[1]/100-0.5;

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetVector_StochasticD(string smb,ENUM_TIMEFRAMES tf,int shift)
  {// пара, период, смещение назад (для индикатора полезно)
   int h_ind=iStochastic(smb,tf,5,3,3,MODE_SMA,STO_LOWHIGH);
   double ind_buffer[];
   if(!ArraySetAsSeries(ind_buffer,true)) return(0);
   if(CopyBuffer(h_ind,1,shift,5,ind_buffer)<(5)) return(0);

   IndicatorRelease(h_ind);
   return ind_buffer[1]/100-0.5;

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetVector_RSI(string smb,ENUM_TIMEFRAMES tf,int shift)
  {// пара, период, смещение назад (для индикатора полезно)
   int h_ind=iRSI(smb,tf,14,PRICE_CLOSE);
   double ind_buffer[];
   if(!ArraySetAsSeries(ind_buffer,true)) return(0);
   if(CopyBuffer(h_ind,0,shift,5,ind_buffer)<(5))return(0);
   IndicatorRelease(h_ind);
   return ind_buffer[1]/100-0.5;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool GetVectors(double &InputVector[],double &OutputVector[],int num_inputvectors,int num_outputvectors,string fn_name,string smbl,ENUM_TIMEFRAMES tf,int shift)
  {// пара, период, смещение назад (для индикатора полезно)
   bool ret=false;
   if(0==num_inputvectors && 0==num_outputvectors) return(false);
   int shift_history=15;//,i;//
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
//   if(shift_history>0) {OutputVector[0]=Sigmoid(GetTrend(shift_history,smbl,tf,shift))-0.5; ret=true;}
   if(shift_history>0) {OutputVector[0]=GetTrend(shift_history,smbl,tf,shift,false,2); ret=true;}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(num_inputvectors>0)
     {// Есть фрактал!
      //Print("shift="+shift+" shift_history="+shift_history);
      if("Easy"==fn_name) ret=GetVectors_Easy(InputVector,num_inputvectors,smbl,tf,shift+shift_history);
      // нормируем в гиперкуб -0.5...0.5
      //      double sq=0;
      //     for(i=0;i<num_inputvectors;i++) sq+=InputVector[i]*InputVector[i]; sq=MathSqrt(sq);
      //     if(0<sq) for(i=0;i<num_inputvectors;i++) InputVector[i]=InputVector[i]/sq;

      if("RSI"==fn_name) ret=GetVectors_RSI(InputVector,num_inputvectors,smbl,tf,shift+shift_history);
      if("IMA"==fn_name) ret=GetVectors_IMA(InputVector,num_inputvectors,smbl,tf,shift+shift_history);
      if("Fractals"==fn_name) ret=GetVectors_Fractals(InputVector,num_inputvectors,smbl,tf,shift+shift_history);
      if("HL"==fn_name) ret=GetVectors_HL(InputVector,num_inputvectors,smbl,tf,shift+shift_history);
      if("High"==fn_name) ret=GetVectors_High(InputVector,num_inputvectors,smbl,tf,shift+shift_history);
      if("Low"==fn_name) ret=GetVectors_Low(InputVector,num_inputvectors,smbl,tf,shift+shift_history);
      if("Stochastic"==fn_name) ret=GetVectors_Stochastic(InputVector,num_inputvectors,smbl,tf,shift+shift_history);
      if("MACD"==fn_name) ret=GetVectors_MACD(InputVector,num_inputvectors,smbl,tf,shift+shift_history);
      if("CCI"==fn_name) ret=GetVectors_CCI(InputVector,num_inputvectors,smbl,tf,shift+shift_history);
      if("WPR"==fn_name) ret=GetVectors_WPR(InputVector,num_inputvectors,smbl,tf,shift+shift_history);
      if("AMA"==fn_name) ret=GetVectors_AMA(InputVector,num_inputvectors,smbl,tf,shift+shift_history);
      if("AO"==fn_name) ret=GetVectors_AO(InputVector,num_inputvectors,smbl,tf,shift+shift_history);
      if("Ichimoku"==fn_name) ret=GetVectors_Ichimoku(InputVector,num_inputvectors,smbl,tf,shift+shift_history);
      if("Envelopes"==fn_name) ret=GetVectors_Envelopes(InputVector,num_inputvectors,smbl,tf,shift+shift_history);
      if("Ichimoku"==fn_name) ret=GetVectors_Ichimoku(InputVector,num_inputvectors,smbl,tf,shift+shift_history);
      // for(i=0;i<num_inputvectors;i++) InputVector[i]=Sigmoid(InputVector[i]/sq)-0.5;
      //for(i=0;i<num_inputvectors;i++) InputVector[i]=Sigmoid(InputVector[i]/sq);
      //double min=InputVector[0];
      //for(i=0;i<num_inputvectors;i++) if(InputVector[i]<min) min=InputVector[i];
      //for(i=0;i<num_inputvectors;i++) InputVector[i]-=min;
      //double max=InputVector[0];
      //for(i=0;i<num_inputvectors;i++) if(InputVector[i]>max) max=InputVector[i];if(max==0) max=1;
      //for(i=0;i<num_inputvectors;i++) InputVector[i]=2*InputVector[i]/max-1;
      //    for(i=0;i<num_inputvectors;i++) InputVector[i]=MathRound(1000*InputVector[i])/1000;

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
double GetTrend(int shift_history,string smb,ENUM_TIMEFRAMES tf,int shift,bool draw=false,int _ts=2)
  {
   double mS=0,mB=0,S=0,B=0;
   double Close[]; ArraySetAsSeries(Close,true);
   double High[]; ArraySetAsSeries(High,true);
   double Low[]; ArraySetAsSeries(Low,true);
   datetime Time[]; ArraySetAsSeries(Time,true);
   int RatioTP_SL=5;
// копируем историю
// TF всегда минутка!
//   tf=PERIOD_M1;
   int maxcount=CopyHigh(smb,tf,shift,shift_history+3,High);
   maxcount=CopyClose(smb,tf,shift,shift_history+3,Close);
   maxcount=CopyLow(smb,tf,shift,shift_history+3,Low);
   maxcount=CopyTime(smb,tf,shift,shift_history+3,Time);
   double res=0,res1=0;
   int is,ib;
//   if((High[shift_history+1]>High[shift_history] && High[shift_history+1]>High[shift_history+2]) || (Low[shift_history+1]<Low[shift_history] && Low[shift_history+1]<Low[shift_history+2]))
     {
      S=Close[shift_history]-0.0000001; B=Close[shift_history]+0.0000001;
      is=ib=shift_history;
      double  TS=SymbolInfoDouble(smb,SYMBOL_POINT)*(_ts*SymbolInfoInteger(smb,SYMBOL_TRADE_STOPS_LEVEL));
      if(Close[shift_history]<Close[shift_history-1]) mS=Close[shift_history]-S;
      if(Close[shift_history]>Close[shift_history-1]) mB=Close[shift_history]-B;
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
      if(mS>mB) {res=-mS;if(4*TS<-res&&draw)ObjectCreate(0,"GV_S_"+(string)shift+"_"+(string)(int)(mS/(SymbolInfoInteger(smb,SYMBOL_TRADE_STOPS_LEVEL)*SymbolInfoDouble(smb,SYMBOL_POINT))/_ts),OBJ_ARROWED_LINE,0,Time[shift_history],Close[shift_history],Time[is],S);}
      else      { res=mB;if(4*TS<res&&draw)ObjectCreate(0,"GV_B_"+(string)shift+"_"+(string)(int)(mB/(SymbolInfoInteger(smb,SYMBOL_TRADE_STOPS_LEVEL)*SymbolInfoDouble(smb,SYMBOL_POINT))/_ts),OBJ_ARROWED_LINE,0,Time[shift_history],Close[shift_history],Time[ib],B);}

      if(TS>0.00001)
        {
         //Print(res+"/"+(TS));
         res=res/TS;
        }
      else
        {
         //Print(smb+" SYMBOL_TRADE_STOPS_LEVEL="+(string)SymbolInfoInteger(smb,SYMBOL_TRADE_STOPS_LEVEL)+" SYMBOL_POINT="+(string)SymbolInfoDouble(smb,SYMBOL_POINT));
         res=0;
        }
     }
   if(NULL==res) res=0.0001;
//   Сигнал	Количество	процент	дельтах	Серединка	-1
//QS	7 580,00	1,20317%	0,0240634921	0,012031746	-0,987968254
//QWS	39 142,00	6,21302%	0,1242603175	0,0621301587	-0,9138063492
//QW	535 033,00	84,92587%	1,6985174603	0,8492587302	-0,0024174603
//QWB	40 643,00	6,45127%	0,1290253968	0,0645126984	0,9113539683
//QB	7 602,00	1,20667%	0,0241333333	0,0120666667	0,9879333333
   res=tanh(res/5);
//if(res>0.6) res=0.9879333333;
//else if (res>0.3) res=0.9113539683;
//else if (res>-0.3) res=-0.002417460;
//else if (res>-0.6) res=-0.9138063492;
//else res=-0.987968254;

   return(res);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

bool GetVectors_Easy(double &InputVector[],int num_inputvectors,string smbl,ENUM_TIMEFRAMES tf=0,int shift=0)
  {// пара, период, смещение назад (для индикатора полезно)

   int shft_cur=0;
   double  TS=SymbolInfoDouble(smbl,SYMBOL_POINT)*(SymbolInfoInteger(smbl,SYMBOL_TRADE_STOPS_LEVEL));

   double Close[];
   ArraySetAsSeries(Close,true);
// копируем историю
   int maxcount=CopyClose(smbl,tf,shift,num_inputvectors+5,Close);
   ArrayInitialize(InputVector,EMPTY_VALUE);
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(maxcount<num_inputvectors+2)
     {
      Print("Shift = ",shift," maxcount = ",maxcount);
      return(false);
     }
   int i,j;j=0;
   double pr=0;
   for(i=0;i<num_inputvectors;i++,j++)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
     {
      pr=Close[j+1]/Close[j+2];
      pr=MathLog(pr);
      pr=pr/TS;
      pr=tanh(pr);
      // вычислим и отнормируем
      InputVector[i]=tanh(MathLog(Close[j+1]/Close[j+2])/TS);
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
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
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
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
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
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
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
bool GetVectors_Stochastic(double &InputVector[],int num_inputvectors,string smbl="",ENUM_TIMEFRAMES tf=0,int shift=0)
  {// пара, период, смещение назад (для индикатора полезно)
   int h_ind=iStochastic(smbl,tf,5,3,3,MODE_SMA,STO_LOWHIGH);
   double ind_buffer[];
   if(!ArraySetAsSeries(ind_buffer,true)) return(false);
   if(CopyBuffer(h_ind,0,shift,num_inputvectors+5,ind_buffer)<(num_inputvectors+1)) return(false);
   int i;   double res=0;
   for(i=0;i<num_inputvectors;i++)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
     {
      // вычислим и отнормируем
      res=ind_buffer[i+1]/100-0.5;
      //if(ind_buffer[i+2]==0) res=0;
      //else res=MathLog10(ind_buffer[i+1]/ind_buffer[i+2]);
      ////res=MathLog10(rsi_buffer[i]/rsi_buffer[i+1]);
      InputVector[i]=res;
     }
   IndicatorRelease(h_ind);
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool GetVectors_RSI(double &InputVector[],int num_inputvectors,string smbl="",ENUM_TIMEFRAMES tf=0,int shift=0)
  {// пара, период, смещение назад (для индикатора полезно)
   int h_ind=iRSI(smbl,tf,14,PRICE_CLOSE);
   double ind_buffer[];ArrayResize(ind_buffer,num_inputvectors+6);
   if(!ArraySetAsSeries(ind_buffer,true)) return(false);
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(CopyBuffer(h_ind,0,shift,num_inputvectors+5,ind_buffer)<(num_inputvectors+1))
     {
      Print("RSI not copy= "+(string)h_ind+" "+(string)num_inputvectors+" shift="+(string)shift);
      return(false);
     }
   int i;   double res=0;
   for(i=0;i<num_inputvectors;i++)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
     {
      // вычислим и отнормируем
      res=ind_buffer[i+1]/100-0.5;
      //      res=MathLog10(ind_buffer[i+1]/ind_buffer[i+2]);
      //res=MathLog10(rsi_buffer[i]/rsi_buffer[i+1]);
      InputVector[i]=res;
     }
//IndicatorRelease(h_ind);
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool GetVectors_IMA(double &InputVector[],int num_inputvectors,string smbl="",ENUM_TIMEFRAMES tf=0,int shift=0)
  {// пара, период, смещение назад (для индикатора полезно)
   int h_ind=iMA(smbl,tf,6,0,MODE_LWMA,PRICE_WEIGHTED);
   if(h_ind==INVALID_HANDLE) return(false);//--- если хэндл невалидный
   double ind_buffer[];
   if(!ArraySetAsSeries(ind_buffer,true)) return(false);
   if(CopyBuffer(h_ind,0,shift,num_inputvectors+5,ind_buffer)<(num_inputvectors+1)) return(false);

   int i;   double res=0;
   for(i=0;i<num_inputvectors;i++)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
     {
      // вычислим и отнормируем
      res=MathLog10(ind_buffer[i+1]/ind_buffer[i+2]);
      InputVector[i]=res;
     }
   IndicatorRelease(h_ind);

   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool GetVectors_MACD(double &InputVector[],int num_inputvectors,string smbl="",ENUM_TIMEFRAMES tf=0,int shift=0)
  {// пара, период, смещение назад (для индикатора полезно)
   int h_ind=iMACD(smbl,tf,12,26,9,PRICE_CLOSE);
   if(h_ind==INVALID_HANDLE) return(false);//--- если хэндл невалидный
   double ind_buffer[];
   if(!ArraySetAsSeries(ind_buffer,true)) return(false);
   if(CopyBuffer(h_ind,0,shift,num_inputvectors+5,ind_buffer)<(num_inputvectors+1)) return(false);

   int i;   double res=0;
   for(i=0;i<num_inputvectors;i++)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
     {
      // вычислим и отнормируем
      res=MathLog10(ind_buffer[i+1]/ind_buffer[i+2]);
      InputVector[i]=res;
     }
   IndicatorRelease(h_ind);

   return(true);
  }
//+------------------------------------------------------------------+
bool GetVectors_CCI(double &InputVector[],int num_inputvectors,string smbl="",ENUM_TIMEFRAMES tf=0,int shift=0)
  {// пара, период, смещение назад (для индикатора полезно)
   int h_ind=iCCI(smbl,tf,14,PRICE_TYPICAL);
   if(h_ind==INVALID_HANDLE) return(false);//--- если хэндл невалидный
   double ind_buffer[];
   if(!ArraySetAsSeries(ind_buffer,true)) return(false);
   if(CopyBuffer(h_ind,0,shift,num_inputvectors+5,ind_buffer)<(num_inputvectors+1)) return(false);

   int i;   double res=0;
   for(i=0;i<num_inputvectors;i++)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
     {
      // вычислим и отнормируем
      res=MathLog10(ind_buffer[i+1]/ind_buffer[i+2]);
      InputVector[i]=res;
     }
   IndicatorRelease(h_ind);

   return(true);
  }
//+------------------------------------------------------------------+

bool GetVectors_WPR(double &InputVector[],int num_inputvectors,string smbl="",ENUM_TIMEFRAMES tf=0,int shift=0)
  {// пара, период, смещение назад (для индикатора полезно)
   int h_ind=iWPR(smbl,tf,14);
   if(h_ind==INVALID_HANDLE) return(false);//--- если хэндл невалидный
   double ind_buffer[];
   if(!ArraySetAsSeries(ind_buffer,true)) return(false);
   if(CopyBuffer(h_ind,0,shift,num_inputvectors+5,ind_buffer)<(num_inputvectors+1)) return(false);

   int i;   double res=0;
   for(i=0;i<num_inputvectors;i++)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
     {
      res=ind_buffer[i+1]/100+0.5;
      // вычислим и отнормируем
      //res=MathLog10(ind_buffer[i+1]/ind_buffer[i+2]);
      InputVector[i]=res;
     }
   IndicatorRelease(h_ind);

   return(true);
  }
//+------------------------------------------------------------------+

bool GetVectors_AMA(double &InputVector[],int num_inputvectors,string smbl="",ENUM_TIMEFRAMES tf=0,int shift=0)
  {// пара, период, смещение назад (для индикатора полезно)
   int h_ind=iAMA(smbl,tf,9,2,30,0,PRICE_CLOSE);
   if(h_ind==INVALID_HANDLE) return(false);//--- если хэндл невалидный
   double ind_buffer[];
   if(!ArraySetAsSeries(ind_buffer,true)) return(false);
   if(CopyBuffer(h_ind,0,shift,num_inputvectors+5,ind_buffer)<(num_inputvectors+1)) return(false);

   int i;   double res=0;
   for(i=0;i<num_inputvectors;i++)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
     {
      // вычислим и отнормируем
      res=MathLog10(ind_buffer[i+1]/ind_buffer[i+2]);
      InputVector[i]=res;
     }
   IndicatorRelease(h_ind);

   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool GetVectors_AO(double &InputVector[],int num_inputvectors,string smbl="",ENUM_TIMEFRAMES tf=0,int shift=0)
  {// пара, период, смещение назад (для индикатора полезно)
   int h_ind=iAO(smbl,tf);
   if(h_ind==INVALID_HANDLE) return(false);//--- если хэндл невалидный
   double ind_buffer[];
   if(!ArraySetAsSeries(ind_buffer,true)) return(false);
   if(CopyBuffer(h_ind,0,shift,num_inputvectors+5,ind_buffer)<(num_inputvectors+1)) return(false);

   int i;   double res=0;
   for(i=0;i<num_inputvectors;i++)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
     {
      // вычислим и отнормируем
      res=MathLog10(ind_buffer[i+1]/ind_buffer[i+2]);
      InputVector[i]=res;
     }
   IndicatorRelease(h_ind);

   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool GetVectors_Ichimoku(double &InputVector[],int num_inputvectors,string smbl="",ENUM_TIMEFRAMES tf=0,int shift=0)
  {// пара, период, смещение назад (для индикатора полезно)
   int h_ind=iIchimoku(smbl,tf,9,26,52);
   if(h_ind==INVALID_HANDLE) return(false);//--- если хэндл невалидный
   double ind_buffer[];
   if(!ArraySetAsSeries(ind_buffer,true)) return(false);
   if(CopyBuffer(h_ind,0,shift,num_inputvectors+5,ind_buffer)<(num_inputvectors+1)) return(false);

   int i;   double res=0;
   for(i=0;i<num_inputvectors;i++)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
     {
      // вычислим и отнормируем
      res=MathLog10(ind_buffer[i+1]/ind_buffer[i+2]);
      InputVector[i]=res;
     }
   IndicatorRelease(h_ind);

   return(true);
  }
//+------------------------------------------------------------------+
bool GetVectors_Envelopes(double &InputVector[],int num_inputvectors,string smbl="",ENUM_TIMEFRAMES tf=0,int shift=0)
  {// пара, период, смещение назад (для индикатора полезно)
   int h_ind=iEnvelopes(smbl,tf,28,0,MODE_SMA,PRICE_MEDIAN,0.1);
   if(h_ind==INVALID_HANDLE) return(false);//--- если хэндл невалидный
   double ind_buffer[];
   if(!ArraySetAsSeries(ind_buffer,true)) return(false);
   if(CopyBuffer(h_ind,0,shift,num_inputvectors+5,ind_buffer)<(num_inputvectors+1)) return(false);

   int i;   double res=0;
   for(i=0;i<num_inputvectors;i++)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
     {
      // вычислим и отнормируем
      res=MathLog10(ind_buffer[i+1]/ind_buffer[i+2]);
      InputVector[i]=res;
     }
   IndicatorRelease(h_ind);

   return(true);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Предобработка сигнала                                            |
//+------------------------------------------------------------------+
void InNormalize(double &aa[],int typ=1)
  {
   double sum_sqrt,rmax,rmin;
   int i,n=ArraySize(aa);
//---
   switch(typ)
     {
      case 1:
         rmax=aa[ArrayMaximum(aa)];
         rmin=aa[ArrayMinimum(aa)];
         for(i=0;i<=n-1;i++)
           {
            aa[i]=2*(aa[i]-rmin)/(rmax-rmin)-1;
           }
         break;
      case 2:
         sum_sqrt=0;
         for(i=0; i<=n-1; i++)
           {
            sum_sqrt+=MathPow(aa[i],2);
           }
         sum_sqrt=MathSqrt(sum_sqrt);
         //---
         if(sum_sqrt!=0)
           {
            for(i=0; i<=n-1; i++)
              {
               aa[i]=aa[i]/sum_sqrt;
              }
           }
         break;
      case 3:
         for(i=0; i<=n-1; i++)
           {
            aa[i]=tanh(aa[i]);
           }
         break;
      case 4:
         for(i=0; i<=n-1; i++)
           {
            aa[i]=Sigmoid(aa[i]);
           }
         break;

      default: break;
     }

//---
   return;
  }
//+-------------------------------------------------------------------+
//| Масштабирование входящих сигналов                                              |
//| aa[]  - числовой массив подлежащий нормализации        |
//| scale - диаппазон нормализации                                                                      |
//|              +1 -1 ->>  scale=11;   +1  0  ->> scale==10              |
//| Return - 0 и нормализоваанный массив, в случае успеха|
//|                     или код последней  ошибки                                                          |
//+------------------------------------------------------------------+
int GetScale(int scale,double &aa[])
  {
   int sign=0;
   int I,i=0,Err=0;
//double range;
   double sum[],nn[];

   double rmax=aa[ArrayMaximum(aa)];
   double rmin=aa[ArrayMinimum(aa)];


   if(rmax>0 && rmin>=0) sign= 1;
   if(rmin<0 && rmax<=0) sign=-1;

   I=ArraySize(aa);
   ArrayResize(sum,I);
   ArrayResize(nn,I);
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(scale==11) // приводим к +1 -1 
     {
      if(sign==0) // для массивов с положительными и отрицательными значениями
        {
         for(i=0;i<=I-1;i++)
           {
            if(aa[i]>=0) {sum[i]=aa[i]; nn[i]=1;}  else {sum[i]=-aa[i]; nn[i]=-1;}
           }
         Scale01(sum);

         for(i=0;i<=I-1;i++)
           {
            if(nn[i]== 1) aa[i]= sum[i];
            if(nn[i]==-1) aa[i]=-sum[i];
           }
        }
      else                   // для массивов только с положительными или отрицательными значениями
        {
         if(sign==-1) for(i=0;i<=I-1;i++) aa[i]=-aa[i];// invert sign
         Scale11(aa);
         if(sign==-1) aa[i]=-aa[i];// recover sign
        }
      Err=err();
      return(Err);
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(scale==10) // приводим к 0 +1 
     {
      if(sign==0) // для массивов с положительными и отрицательными значениями
        {
         for(i=0;i<=I-1;i++)
           {
            if(aa[i]>=0) {sum[i]=aa[i]; nn[i]=1;}  else {sum[i]=-aa[i]; nn[i]=-1;}
           }
         Scale01(sum);

         for(i=0;i<=I-1;i++)
           {
            if(nn[i]== 1) aa[i]= (sum[i]+1)/2;
            if(nn[i]==-1) aa[i]=(-sum[i]+1)/2;
           }
        }
      else                   // для массивов только с положительными или отрицательными значениями
        {
         if(sign==1) Scale01(aa);
         else
           {
            for(i=0;i<=I-1;i++) aa[i]=-aa[i];// invert sign
            Scale01(aa);
            aa[i]=-aa[i];// recover sign
           }
        }
      Err=err();
      return(Err);

     }
   return(Err);
  }
//+-------------------------------------------------------------------------------------+
//| Масштабирование входящих сигналов > 0 приводим в диаппазон +1 -1 |
//+-------------------------------------------------------------------------------------+
void Scale11(double &aa[])
  {
   int I=ArraySize(aa);
   double rmax=aa[ArrayMaximum(aa)];
   double rmin=aa[ArrayMinimum(aa)];
   double range=(rmax-rmin);
   if( range==0 ) range=0.5;
   for(int i=0;i<=I-1;i++)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
     {
      aa[i]=2*(aa[i]-rmin)/range-1;
     }
   return;
  }
//+-------------------------------------------------------------------------------------+
//| Масштабирование входящих сигналов > 0 приводим в диаппазон +1  0 |
//+-------------------------------------------------------------------------------------+
void Scale01(double &aa[])
  {
   int I=ArraySize(aa);
   double rmax=aa[ArrayMaximum(aa)];
   double rmin=aa[ArrayMinimum(aa)];
   double range=rmax-rmin;
   for(int i=0;i<=I-1;i++)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
     {
      if( range!=0 ) aa[i]=(aa[i]-rmin)/range;
      else aa[i]=0;
     }
   return;

  }
//+------------------------------------------------------------------+
//|       Обработка ошибок                                                                                                |
//+------------------------------------------------------------------+
int err()
  {
   int err=GetLastError();
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(err!=0)
     {
      Print("error(",err,"): ");///,ErrorDescription(err));
     }
   return(err);
  }
//+------------------------------------------------------------------+
