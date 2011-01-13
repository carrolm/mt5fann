//+------------------------------------------------------------------+
//|                                                        GCANN.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include <GC\Oracle.mqh>
//#include <GC\GetVectors.mqh>
//#include <GC\CommonFunctions.mqh>
class CDummy:public COracleEasy
  {
public:
   virtual double    forecast(string smbl="",int shift=0,bool train=false);
   virtual string    Name(){return("iEnvelopes");};
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CDummy::forecast(string smbl="",int shift=0,bool train=false)
  {

   double sig=0;
   if(""==smbl) smbl=Symbol();
   MqlRates rates[];
   ArraySetAsSeries(rates,true);
   int copied=CopyRates(_Symbol,_Period,shift,3,rates);
   datetime time=rates[0].time;
   if(debug)Print(time);

   if(_Symbol!="EURUSD") return(0);
   if(time==StringToTime("2011.01.13 02:04:00")) return(-1.255555555555393);
   if(time==StringToTime("2011.01.13 02:03:00")) return(-1.299999999999881);
   if(time==StringToTime("2011.01.13 02:02:00")) return(-1.41111111111098);
   if(time==StringToTime("2011.01.13 01:39:00")) return(1.188888888888783);
   if(time==StringToTime("2011.01.13 01:38:00")) return(1.577777777777752);
   if(time==StringToTime("2011.01.13 01:30:00")) return(-1.011111111111074);
   if(time==StringToTime("2011.01.13 01:29:00")) return(-1.088888888888868);
   if(time==StringToTime("2011.01.12 21:07:00")) return(-1.122222222222173);
   if(time==StringToTime("2011.01.12 20:52:00")) return(-1.055555555555563);
   if(time==StringToTime("2011.01.12 20:51:00")) return(-1.055555555555563);
   if(time==StringToTime("2011.01.12 20:36:00")) return(-1.011111111111074);
   if(time==StringToTime("2011.01.12 20:35:00")) return(-1.088888888888868);
   if(time==StringToTime("2011.01.12 20:34:00")) return(1.644444444444362);
   if(time==StringToTime("2011.01.12 20:32:00")) return(1.511111111111142);
   if(time==StringToTime("2011.01.12 20:31:00")) return(1.566666666666568);
   if(time==StringToTime("2011.01.12 20:30:00")) return(1.744444444444524);
   if(time==StringToTime("2011.01.12 20:28:00")) return(1.788888888888766);
   if(time==StringToTime("2011.01.12 20:27:00")) return(2.455555555555606);
   if(time==StringToTime("2011.01.12 20:17:00")) return(-1.133333333333356);
   if(time==StringToTime("2011.01.12 20:16:00")) return(-1.211111111110904);
   if(time==StringToTime("2011.01.12 20:15:00")) return(-1.288888888888697);
   if(time==StringToTime("2011.01.12 20:11:00")) return(1.199999999999966);
   if(time==StringToTime("2011.01.12 20:03:00")) return(1.288888888888944);
   if(time==StringToTime("2011.01.12 20:01:00")) return(-1.166666666666908);
   if(time==StringToTime("2011.01.12 20:00:00")) return(-1.588888888888936);
   if(time==StringToTime("2011.01.12 19:59:00")) return(-1.73333333333334);
   if(time==StringToTime("2011.01.12 19:47:00")) return(1.044444444444379);
   if(time==StringToTime("2011.01.12 19:46:00")) return(1.122222222222173);
   if(time==StringToTime("2011.01.12 19:45:00")) return(1.188888888888783);
   if(time==StringToTime("2011.01.12 19:44:00")) return(1.233333333333271);
   return(sig);
  }
//+------------------------------------------------------------------+

CDummy *MyExpert;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   MyExpert=new CDummy;
   MyExpert.debug=true;
   return(0);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   delete MyExpert;
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   static double lastf=0;
   if(_TrailingPosition_) Trailing();
   if(isNewBar())
     {
      //Print("NB");
      double f=MyExpert.forecast(_Symbol,0,false);
      if(lastf!=f)
        {
         lastf=f;
         //Print((string)SeriesInfoInteger(_Symbol,0,SERIES_LASTBAR_DATE)+" f="+(string)f);
        }
      NewOrder(_Symbol,f*1.1,(string)f);
     }
  }
//+------------------------------------------------------------------+
