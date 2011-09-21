//+------------------------------------------------------------------+
//|                                                   GetVectors.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#include <GC\CommonFunctions.mqh>
string VectorFunctions[21]={"DayOfWeek","Hour","Minute","EasyClose","Fractals","RSI","IMA","StochasticK","StochasticD","HL","High","Low","MACD","CCI","WPR","AMA","AO","Ichimoku","Envelopes","Chaikin","ROC"};
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
//  x=1+MathExp(-2 *x);
//  if(0==0) return(0);
//return((x_-_x)/(x_+_x));
//   return -1+(2/(1+MathExp(-2 *x)));
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
double Result2Neuro(double in,string smbl)
  {// in - количество спредов
   return(tanh(in));
   double res=0;
   double ac[];
   double EURUSD[]={-0.8634858714678669,-0.5181595398849712,-0.2567541885471368,0,0.2543535883970993,0.5113378344586146,0.8596049012253063};
//EURUSD;79895;3;73337.27777777761;6558.555555555656;13648;20876;5258;10322;4910;20782;14036;89832;-0.8480719565410989;-0.4637545640751625;-0.1728337340813964;0;0.1701620803277229;0.4561626146584736;0.8437527829726601
//GBPUSD;31380;3;28091.64285714257;3289.321428571481;6210;14897;5486;22955;5656;15352;6366;76922;-0.9192688697641767;-0.6448740282363954;-0.3798913184784587;0;0.3617950651309119;0.634902888640441;0.9172408413717792
//AUDUSD;15838;3;13962.26666666666;1876.2333333334;3646;11917;6214;27916;6056;12135;3353;71237;-0.9488187318387916;-0.730350800847874;-0.4758341872903126;0;0.4801577831744739;0.7355166556705083;0.9529317629883347
   if("EURUSD"==smbl) ArrayCopy(ac,EURUSD);
   else { Print("Not data for ",smbl);return 0;}
   if(in==0) return 0;
   if(in>4) return ac[6];
   else if(in>1) return ac[5];
   else if(in>0.1) return ac[4];
   else if(in>-0.1) return ac[3];
   else if(in>-1) return ac[2];
   else if(in>-4) return ac[1];
   else return ac[0];

   return res;
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
   if(shift>shift_history>0) output_vector=GetTrend(shift_history,smbl,tf,shift-shift_history,false);
   if(StringLen(fn_names)<5) return output_vector;
// разберем строку...
   int start_pos=0,end_pos=0,shift_pos=0,add_shift;
   end_pos=StringFind(fn_names," ",start_pos);
   do //while(end_pos>0)
     {
      add_shift=0;
      shift_pos= StringFind(fn_names,"-",start_pos);
      if(shift_pos>0 && (shift_pos<end_pos || -1==end_pos))
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
   if("Easy"==fn_name) return GetVector_Easy(smbl,tf,shift);
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
   if("Chaikin"==fn_name) return GetVector_Chaikin(smbl,tf,shift);
   if("ROC"==fn_name) return GetVector_Chaikin(smbl,tf,shift);
   Print("Not found fn=",fn_name);
   return 0.0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetVector_ROC(string smb,ENUM_TIMEFRAMES tf,int shift)
  {// пара, период, смещение назад (для индикатора полезно)
   static int h_ind=0;
   if(0==h_ind) h_ind=iCustom(smb,tf,"GC\ROC");
   if(h_ind==INVALID_HANDLE) return(0);//--- если хэндл невалидный
   double ind_buffer[];
   if(!ArraySetAsSeries(ind_buffer,true)) return(0);
   if(CopyBuffer(h_ind,0,shift,5,ind_buffer)<(5)) return(0);

//IndicatorRelease(h_ind);
   return 4*(ind_buffer[1]);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetVector_WPR(string smb,ENUM_TIMEFRAMES tf,int shift)
  {// пара, период, смещение назад (для индикатора полезно)
   static int h_ind=0;
   if(0==h_ind) h_ind=iWPR(smb,tf,14);
   if(h_ind==INVALID_HANDLE) return(0);//--- если хэндл невалидный
   double ind_buffer[];
   if(!ArraySetAsSeries(ind_buffer,true)) return(0);
   if(CopyBuffer(h_ind,0,shift,5,ind_buffer)<(5)) return(0);

//IndicatorRelease(h_ind);
   return 2*(ind_buffer[1]/100+0.5);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetVector_Chaikin(string smb,ENUM_TIMEFRAMES tf,int shift)
  {// пара, период, смещение назад (для индикатора полезно)
   static int h_ind=0;
   if(0==h_ind) h_ind=iChaikin(smb,tf,3,10,MODE_EMA,VOLUME_TICK);
   if(h_ind==INVALID_HANDLE) return(0);//--- если хэндл невалидный
   double ind_buffer[];
   if(!ArraySetAsSeries(ind_buffer,true)) return(0);
   if(CopyBuffer(h_ind,0,shift,5,ind_buffer)<(5)) return(0);

//IndicatorRelease(h_ind);
   return 2*(ind_buffer[1]/150);

  }
//+------------------------------------------------------------------+

double GetVector_AMA(string smb,ENUM_TIMEFRAMES tf,int shift)
  {// пара, период, смещение назад (для индикатора полезно)
   static int h_ind=0;
   if(0==h_ind) h_ind=iAMA(smb,tf,9,2,30,0,PRICE_CLOSE);
   if(h_ind==INVALID_HANDLE) return(false);//--- если хэндл невалидный
   double ind_buffer[];
   if(!ArraySetAsSeries(ind_buffer,true)) return(0);
   if(CopyBuffer(h_ind,0,shift,5,ind_buffer)<5) return(0);

//IndicatorRelease(h_ind);
   return atan(MathLog10(ind_buffer[1]/ind_buffer[2])*5000);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetVector_AO(string smb,ENUM_TIMEFRAMES tf,int shift)
  {// пара, период, смещение назад (для индикатора полезно)
   static int h_ind=0;
   if(0==h_ind) h_ind=iAO(smb,tf);
   if(h_ind==INVALID_HANDLE) return(0);//--- если хэндл невалидный
   double ind_buffer[];
   if(!ArraySetAsSeries(ind_buffer,true)) return(0);
   if(CopyBuffer(h_ind,0,shift,5,ind_buffer)<5) return(0);

//IndicatorRelease(h_ind);
   return tanh(MathLog10(ind_buffer[1]/ind_buffer[2]));

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetVector_Ichimoku(string smb,ENUM_TIMEFRAMES tf,int shift)
  {// пара, период, смещение назад (для индикатора полезно)
   static int h_ind=0;
   if(0==h_ind) h_ind=iIchimoku(smb,tf,9,26,52);
   if(h_ind==INVALID_HANDLE) return(false);//--- если хэндл невалидный
   double ind_buffer[];
   if(!ArraySetAsSeries(ind_buffer,true)) return(0);
   if(CopyBuffer(h_ind,0,shift,5,ind_buffer)<5) return(0);

//IndicatorRelease(h_ind);
   return tanh(MathLog10(ind_buffer[1]/ind_buffer[2])*10000);
  }
//+------------------------------------------------------------------+
double GetVector_Envelopes(string smb,ENUM_TIMEFRAMES tf,int shift)
  {// пара, период, смещение назад (для индикатора полезно)
   static int h_ind=0;
   if(0==h_ind) h_ind=iEnvelopes(smb,tf,28,0,MODE_SMA,PRICE_MEDIAN,0.1);
   if(h_ind==INVALID_HANDLE) return(0);//--- если хэндл невалидный
   double ind_buffer[];
   if(!ArraySetAsSeries(ind_buffer,true)) return(0);
   if(CopyBuffer(h_ind,0,shift,5,ind_buffer)<5) return(0);

//IndicatorRelease(h_ind);

   return tanh(MathLog10(ind_buffer[1]/ind_buffer[2])*10000);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetVector_IMA(string smb,ENUM_TIMEFRAMES tf,int shift)
  {// пара, период, смещение назад (для индикатора полезно)
   static int h_ind=0;
   if(0==h_ind) h_ind=iMA(smb,tf,6,0,MODE_LWMA,PRICE_WEIGHTED);
   if(h_ind==INVALID_HANDLE) return(0);//--- если хэндл невалидный
   double ind_buffer[];
   if(!ArraySetAsSeries(ind_buffer,true)) return(0);
   if(CopyBuffer(h_ind,0,shift,5,ind_buffer)<(5)) return(0);
//IndicatorRelease(h_ind);
   return MathLog10(ind_buffer[1]/ind_buffer[2])*1000;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetVector_MACD(string smb,ENUM_TIMEFRAMES tf,int shift)
  {// пара, период, смещение назад (для индикатора полезно)
   static int h_ind=0;
   if(0==h_ind) h_ind=iMACD(smb,tf,12,26,9,PRICE_CLOSE);
   if(h_ind==INVALID_HANDLE) return(0);//--- если хэндл невалидный
   double ind_buffer[];
   if(!ArraySetAsSeries(ind_buffer,true)) return(0);
   if(CopyBuffer(h_ind,0,shift,5,ind_buffer)<5) return(0);

//IndicatorRelease(h_ind);
   return tanh(MathLog10(ind_buffer[1]/ind_buffer[2]));

  }
//+------------------------------------------------------------------+
double GetVector_CCI(string smb,ENUM_TIMEFRAMES tf,int shift)
  {// пара, период, смещение назад (для индикатора полезно)
   static int h_ind=0;
   if(0==h_ind) h_ind=iCCI(smb,tf,14,PRICE_TYPICAL);
   if(h_ind==INVALID_HANDLE) return(false);//--- если хэндл невалидный
   double ind_buffer[];
   if(!ArraySetAsSeries(ind_buffer,true)) return(0);
   if(CopyBuffer(h_ind,0,shift,5,ind_buffer)<5) return(0);
//IndicatorRelease(h_ind);
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
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
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
double GetVector_Easy(string smb,ENUM_TIMEFRAMES tf,int shift)
  {// пара, период, смещение назад (для индикатора полезно)

   double  TS=SymbolInfoDouble(smb,SYMBOL_POINT)*(SymbolInfoInteger(smb,SYMBOL_TRADE_STOPS_LEVEL));

   double Close[];  ArraySetAsSeries(Close,true);
   double High[];  ArraySetAsSeries(High,true);
   double Low[];  ArraySetAsSeries(Low,true);
// копируем историю
   int maxcount=CopyClose(smb,tf,shift,3,Close);
   int maxcountH=CopyHigh(smb,tf,shift,3,High);
   int maxcountL=CopyLow(smb,tf,shift,3,Low);
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(maxcount<3)
     {
      Print("Shift = ",shift," maxcount = ",maxcount);
      return(0);
     }
   return tanh(MathLog((2*Close[1]+High[1]+Low[1])/(2*Close[2]+High[1]+Low[1]))/TS);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetVector_StochasticK(string smb,ENUM_TIMEFRAMES tf,int shift)
  {// пара, период, смещение назад (для индикатора полезно)
   static int h_ind=0;
   if(0==h_ind) h_ind=iStochastic(smb,tf,5,3,3,MODE_SMA,STO_LOWHIGH);
   double ind_buffer[];
   if(!ArraySetAsSeries(ind_buffer,true)) return(0);
   if(CopyBuffer(h_ind,0,shift,5,ind_buffer)<(5)) return(0);

//IndicatorRelease(h_ind);
   return 2*(ind_buffer[1]/100-0.5);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetVector_StochasticD(string smb,ENUM_TIMEFRAMES tf,int shift)
  {// пара, период, смещение назад (для индикатора полезно)
   static int h_ind=0;
   if(0==h_ind) h_ind=iStochastic(smb,tf,5,3,3,MODE_SMA,STO_LOWHIGH);
   double ind_buffer[];
   if(!ArraySetAsSeries(ind_buffer,true)) return(0);
   if(CopyBuffer(h_ind,1,shift,5,ind_buffer)<(5)) return(0);

//IndicatorRelease(h_ind);
   return 2*(ind_buffer[1]/100-0.5);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetVector_RSI(string smb,ENUM_TIMEFRAMES tf,int shift)
  {// пара, период, смещение назад (для индикатора полезно)
   static int h_ind=0;
   if(0==h_ind) h_ind=iRSI(smb,tf,14,PRICE_CLOSE);
   double ind_buffer[];
   if(!ArraySetAsSeries(ind_buffer,true)) return(0);
   if(CopyBuffer(h_ind,0,shift,5,ind_buffer)<(5))return(0);
//IndicatorRelease(h_ind);
   return 2*(ind_buffer[1]/100-0.5);

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
   if(shift_history>0) {OutputVector[0]=GetTrend(shift_history,smbl,tf,shift,false); ret=true;}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(num_inputvectors>0)
     {// Есть фрактал!
      //Print("shift="+shift+" shift_history="+shift_history);
      if("Easy"==fn_name) ret=GetVectors_Easy(InputVector,num_inputvectors,smbl,tf,shift+shift_history);
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
double GetTrend(int shift_history,string smb,ENUM_TIMEFRAMES tf,int shift,bool draw=false)
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
   if(((shift_history+3)>CopyHigh(smb,tf,shift,shift_history+3,High))
      || ((shift_history+3)>CopyClose(smb,tf,shift,shift_history+3,Close))
      || ((shift_history+3)>CopyLow(smb,tf,shift,shift_history+3,Low))
      || ((shift_history+3)>CopyTime(smb,tf,shift,shift_history+3,Time))
      )
     {
      Print(smb," ",shift);
      return(0);
     }
// только фрактал попробуем...
   if((High[shift_history+1]>High[shift_history+0] && High[shift_history+1]>High[shift_history+2])
      || (Low[shift_history+1]<Low[shift_history+0] && Low[shift_history+1]<Low[shift_history+2]))
     {}
   else
     {
      return(0);
     }
   double res=0,res1=0;
   int is,ib;double  TS;
//   if((High[shift_history+1]>High[shift_history] && High[shift_history+1]>High[shift_history+2]) || (Low[shift_history+1]<Low[shift_history] && Low[shift_history+1]<Low[shift_history+2]))
     {
      S=Close[shift_history]-0.0000001; B=Close[shift_history]+0.0000001;
      is=ib=shift_history;
      TS=SymbolInfoDouble(smb,SYMBOL_POINT)*(_NumTS_*SymbolInfoInteger(smb,SYMBOL_TRADE_STOPS_LEVEL));
      if(TS>0.00001)
        {
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
         if(mS>mB)
           {
            if(Close[shift_history]<Close[shift_history-1]) return(0);
            res=-mS;if(4*TS<-res && draw)ObjectCreate(0,"GV_S_"+(string)shift+"_"+(string)(int)(mS/(SymbolInfoInteger(smb,SYMBOL_TRADE_STOPS_LEVEL)*SymbolInfoDouble(smb,SYMBOL_POINT))/_NumTS_),OBJ_ARROWED_LINE,0,Time[shift_history],Close[shift_history],Time[is],S);
           }
         else
           {
            if(Close[shift_history]>Close[shift_history-1]) return(0);
            res=mB;if(4*TS<res && draw)ObjectCreate(0,"GV_B_"+(string)shift+"_"+(string)(int)(mB/(SymbolInfoInteger(smb,SYMBOL_TRADE_STOPS_LEVEL)*SymbolInfoDouble(smb,SYMBOL_POINT))/_NumTS_),OBJ_ARROWED_LINE,0,Time[shift_history],Close[shift_history],Time[ib],B);
           }
         //Print(res+"/"+(TS));
         res=_NumTS_*res/TS;
        }
      else
        {
         Print(smb+" SYMBOL_TRADE_STOPS_LEVEL="+(string)SymbolInfoInteger(smb,SYMBOL_TRADE_STOPS_LEVEL)+" SYMBOL_POINT="+(string)SymbolInfoDouble(smb,SYMBOL_POINT));
         res=0;
        }
     }
   if(NULL==res)
     {
      //         Print(smb+" NULL SYMBOL_TRADE_STOPS_LEVEL="+(string)SymbolInfoInteger(smb,SYMBOL_TRADE_STOPS_LEVEL)+" SYMBOL_POINT="+(string)SymbolInfoDouble(smb,SYMBOL_POINT));
      res=0;
      //    res=0.0001;
     }
//   Сигнал	Количество	процент	дельтах	Серединка	-1
//QS	7 580,00	1,20317%	0,0240634921	0,012031746	-0,987968254
//QWS	39 142,00	6,21302%	0,1242603175	0,0621301587	-0,9138063492
//QW	535 033,00	84,92587%	1,6985174603	0,8492587302	-0,0024174603
//QWB	40 643,00	6,45127%	0,1290253968	0,0645126984	0,9113539683
//QB	7 602,00	1,20667%	0,0241333333	0,0120666667	0,9879333333
//res=tanh(res/5);
//if(res>0.6) res=0.9879333333;
//else if (res>0.3) res=0.9113539683;
//else if (res>-0.3) res=-0.002417460;
//else if (res>-0.6) res=-0.9138063492;
//else res=-0.987968254;
//if(res==0) continue;
// if(res>0.66) QB++;
// else if(res>0.33) QCS++;
// else if(res>0.1) QWCS++;
// else if(res>-0.1) QZ++;
// else if(res>-0.33) QWCB++;
// else if(res>-0.66) QCB++;
// else QS++;

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
