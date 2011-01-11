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
if(time==StringToTime("2011.01.10 09:58:00")) return(1.199999999999966);
if(time==StringToTime("2011.01.10 09:54:00")) return(1.244444444444455);
if(time==StringToTime("2011.01.10 09:43:00")) return(-1.244444444444455);
if(time==StringToTime("2011.01.10 09:38:00")) return(1.333333333333433);
if(time==StringToTime("2011.01.10 09:34:00")) return(-1.588888888888689);
if(time==StringToTime("2011.01.10 09:33:00")) return(-1.988888888888842);
if(time==StringToTime("2011.01.10 09:32:00")) return(-2.14444444444443);
if(time==StringToTime("2011.01.10 09:31:00")) return(-2.577777777777642);
if(time==StringToTime("2011.01.10 09:30:00")) return(-2.62222222222213);
if(time==StringToTime("2011.01.10 09:29:00")) return(-2.888888888888817);
if(time==StringToTime("2011.01.10 09:18:00")) return(-1.155555555555724);
if(time==StringToTime("2011.01.10 09:17:00")) return(-1.866666666666806);
if(time==StringToTime("2011.01.10 09:16:00")) return(-1.966666666666721);
if(time==StringToTime("2011.01.10 09:13:00")) return(1.133333333333356);
if(time==StringToTime("2011.01.10 09:08:00")) return(1.211111111110904);
if(time==StringToTime("2011.01.10 09:07:00")) return(1.666666666666483);
if(time==StringToTime("2011.01.10 09:01:00")) return(1.433333333333348);
if(time==StringToTime("2011.01.10 09:00:00")) return(1.788888888889013);
if(time==StringToTime("2011.01.10 08:49:00")) return(1.122222222222173);
if(time==StringToTime("2011.01.10 08:48:00")) return(1.433333333333348);
if(time==StringToTime("2011.01.10 08:47:00")) return(1.444444444444285);
if(time==StringToTime("2011.01.10 08:41:00")) return(1.011111111111074);
if(time==StringToTime("2011.01.10 08:40:00")) return(1.499999999999958);
if(time==StringToTime("2011.01.10 08:39:00")) return(-1.022222222222258);
if(time==StringToTime("2011.01.10 08:37:00")) return(-1.14444444444454);
if(time==StringToTime("2011.01.10 08:33:00")) return(-1.133333333333356);
if(time==StringToTime("2011.01.10 08:29:00")) return(-1.100000000000052);
if(time==StringToTime("2011.01.10 08:28:00")) return(-1.100000000000052);
if(time==StringToTime("2011.01.10 08:27:00")) return(-1.266666666666577);
if(time==StringToTime("2011.01.10 08:26:00")) return(-1.21111111111115);
if(time==StringToTime("2011.01.10 08:20:00")) return(1.133333333333356);
if(time==StringToTime("2011.01.10 08:19:00")) return(1.14444444444454);
if(time==StringToTime("2011.01.10 08:12:00")) return(-1.866666666666806);
if(time==StringToTime("2011.01.10 08:11:00")) return(-2.244444444444592);
if(time==StringToTime("2011.01.10 08:10:00")) return(-2.911111111111185);
if(time==StringToTime("2011.01.10 08:09:00")) return(-3.011111111111346);
if(time==StringToTime("2011.01.10 08:08:00")) return(-3.155555555555751);
if(time==StringToTime("2011.01.10 08:00:00")) return(1.355555555555554);
if(time==StringToTime("2011.01.10 07:59:00")) return(1.755555555555461);
if(time==StringToTime("2011.01.10 07:58:00")) return(1.566666666666568);
if(time==StringToTime("2011.01.10 07:57:00")) return(1.722222222222156);
if(time==StringToTime("2011.01.10 07:56:00")) return(1.588888888888936);
if(time==StringToTime("2011.01.10 07:55:00")) return(1.755555555555461);
if(time==StringToTime("2011.01.10 06:48:00")) return(-1.255555555555639);
if(time==StringToTime("2011.01.10 04:52:00")) return(-1.066666666666747);
if(time==StringToTime("2011.01.10 04:47:00")) return(-1.055555555555563);
if(time==StringToTime("2011.01.10 04:46:00")) return(-1.044444444444379);
if(time==StringToTime("2011.01.10 04:45:00")) return(-1.011111111111074);
if(time==StringToTime("2011.01.10 04:38:00")) return(-1.266666666666823);
if(time==StringToTime("2011.01.10 04:37:00")) return(-1.044444444444626);
if(time==StringToTime("2011.01.10 04:36:00")) return(-1.588888888888936);
if(time==StringToTime("2011.01.10 04:26:00")) return(1.033333333333195);
if(time==StringToTime("2011.01.10 03:36:00")) return(-1.066666666666747);
if(time==StringToTime("2011.01.10 03:35:00")) return(-1.14444444444454);
if(time==StringToTime("2011.01.10 03:33:00")) return(-1.077777777777931);
if(time==StringToTime("2011.01.10 03:32:00")) return(-1.022222222222258);
if(time==StringToTime("2011.01.10 03:31:00")) return(-1.300000000000128);
if(time==StringToTime("2011.01.10 03:28:00")) return(1.022222222222258);
if(time==StringToTime("2011.01.10 03:16:00")) return(1.100000000000052);
if(time==StringToTime("2011.01.10 03:15:00")) return(1.199999999999966);
if(time==StringToTime("2011.01.10 03:14:00")) return(1.244444444444455);
if(time==StringToTime("2011.01.10 03:13:00")) return(1.255555555555639);
if(time==StringToTime("2011.01.10 03:12:00")) return(1.199999999999966);
if(time==StringToTime("2011.01.10 02:52:00")) return(-1.022222222222258);
if(time==StringToTime("2011.01.10 02:46:00")) return(1.133333333333356);
if(time==StringToTime("2011.01.10 02:45:00")) return(1.322222222222249);
if(time==StringToTime("2011.01.10 02:44:00")) return(1.544444444444447);
if(time==StringToTime("2011.01.10 02:40:00")) return(1.455555555555716);
if(time==StringToTime("2011.01.10 02:39:00")) return(1.66666666666673);
if(time==StringToTime("2011.01.10 02:38:00")) return(1.722222222222403);
if(time==StringToTime("2011.01.10 02:37:00")) return(1.455555555555716);
if(time==StringToTime("2011.01.10 02:36:00")) return(1.444444444444532);
if(time==StringToTime("2011.01.10 02:35:00")) return(1.788888888889013);


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
