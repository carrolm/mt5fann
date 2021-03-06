//+------------------------------------------------------------------+
//|                                                    HoursStat.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property indicator_separate_window
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
//---
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
   if(rates_total<100) return(rates_total);

   double BufferL[],BufferH[],BufferT[];
   ArraySetAsSeries(BufferL,true); ArraySetAsSeries(BufferH,true);ArraySetAsSeries(BufferT,true);

   int needcopy=24*7*5;// ñêîëüêî ñêîïèðîâàòü... åñëè ÷àñû - òî 24*7*5 - áóäåò ìåñÿö
   if(CopyLow(_Symbol,_Period,0,needcopy,BufferL)!=needcopy)      return(false);
   if(CopyHigh(_Symbol,_Period,0,needcopy,BufferH)!=needcopy)
     {
      return(false);
     }
   if(CopyTime(_Symbol,_Period,0,needcopy,BufferT)!=needcopy)
     {
      return(false);
     }
   for(int i=0;i<needcopy;i++)
     {
      (BufferC[1]-BufferO[needcopy-1]);
      (BufferH[1]-BufferL[needcopy-1]);

      //---
      //--- return value of prev_calculated for next call
      return(rates_total);
     }
//+------------------------------------------------------------------+
