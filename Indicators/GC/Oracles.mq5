//+------------------------------------------------------------------+
//|                                                      Oracles.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "0.01"
#property indicator_separate_window
#property indicator_buffers 2
#property indicator_plots   1
#property indicator_type1   DRAW_COLOR_HISTOGRAM
#property indicator_color1  Green,DodgerBlue,Red
#property indicator_style1  0
#property indicator_width1  1
#property indicator_minimum -1
#property indicator_maximum 1
#property indicator_level1 -0.50
#property indicator_level2 0.50
#include <GC\Oracle.mqh>
double    ExtBufferData[];
double    ExtBufferColor[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
COracleEasy *Oracles[];
int nOracles;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
//---
   SetIndexBuffer(0,ExtBufferData,INDICATOR_DATA);
   SetIndexBuffer(1,ExtBufferColor,INDICATOR_COLOR_INDEX);

   ArraySetAsSeries(ExtBufferData,true);
   ArraySetAsSeries(ExtBufferColor,true);
//----
   ArrayResize(Oracles,10);
   nOracles=0;
   Oracles[nOracles++]=new CiStochastic;
   Oracles[nOracles++]=new CiMACD;
   Oracles[nOracles++]=new CiMA;
   Oracles[nOracles++]=new CPriceChanel;
   Oracles[nOracles++]=new CiRSI;
   Oracles[nOracles++]=new CiCGI;
   Oracles[nOracles++]=new CiWPR;
   Oracles[nOracles++]=new CiBands;
   Oracles[nOracles++]=new CNRTR;
   Oracles[nOracles++]=new CiAlligator;
   Oracles[nOracles++]=new CiAO;
   Oracles[nOracles++]=new CiIchimoku;
   Oracles[nOracles++]=new CiEnvelopes;
   IndicatorSetString(INDICATOR_SHORTNAME,"GC Oracles "+(string)nOracles);
//  for(int i=0;i<nOracles;i++) Print(Oracles[i].Name());
   refresh();
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,const int prev_calculated,
                const datetime &Time[],
                const double &Open[],
                const double &High[],
                const double &Low[],
                const double &Close[],
                const long &TickVolume[],
                const long &Volume[],
                const int &Spread[])
  {
//---
//--- return value of prev_calculated for next call
   ArraySetAsSeries(Time,true);
   ArraySetAsSeries(High,true);
   ArraySetAsSeries(Low,true);
   ArraySetAsSeries(Open,true);
   ArraySetAsSeries(Close,true);
   refresh();
   int i,io; double res;
   for(i=0;i<100;i++)
     {
      res=0;
      for(io=0;io<nOracles;io++)
        {
         res+=Oracles[io].forecast(Symbol(),i);
        }
      ExtBufferData[i]=res;
      if(res<0)
         ExtBufferColor[i]=2.0;
      else if(res>0)
         ExtBufferColor[i]=0.0;
      else ExtBufferColor[i]=1.0;
     }

   return(rates_total);
  }
//+------------------------------------------------------------------+
void refresh()
  {
//    ChartRedraw(); 
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)

  {
   for(int i=0;i<nOracles;i++) delete Oracles[i];
  }
//+------------------------------------------------------------------+
