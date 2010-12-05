//+------------------------------------------------------------------+
//|                                                         Fann.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window
//#include <GC\MT5FANN.mqh>
#include <GC\GetVectors.mqh>
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
//---- indicator settings
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_plots   2
#property indicator_type1   DRAW_LINE
#property indicator_type2   DRAW_LINE
#property indicator_color1  Yellow
#property indicator_color2  Blue
#property indicator_label1  "Price High"
#property indicator_label2  "Price Low"
//---- indicator buffers
double ExtUpperBuffer[];
double ExtLowerBuffer[];
//CMT5FANN mt5fannHigh;
//CMT5FANN mt5fannLow;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int)

  {
   int i=0;

   for(i=ObjectsTotal(0);i>=0;i--)
      if(StringSubstr(ObjectName(0,i),0,3)=="GV_") ObjectDelete(0,ObjectName(0,i));

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
//---- indicator buffers mapping
   SetIndexBuffer(0,ExtUpperBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,ExtLowerBuffer,INDICATOR_DATA);
   IndicatorSetInteger(INDICATOR_DIGITS,_Digits);
//---- sets first bar from what index will be drawn
   PlotIndexSetInteger(0,PLOT_ARROW,217);
   PlotIndexSetInteger(1,PLOT_ARROW,218);
//---- arrow shifts when drawing
//   PlotIndexSetInteger(0,PLOT_ARROW_SHIFT,ExtArrowShift);
//   PlotIndexSetInteger(1,PLOT_ARROW_SHIFT,-ExtArrowShift);
//---- sets drawing line empty value--
   PlotIndexSetDouble(0,PLOT_EMPTY_VALUE,EMPTY_VALUE);
   PlotIndexSetDouble(1,PLOT_EMPTY_VALUE,EMPTY_VALUE);
//---- initialization done
   ArraySetAsSeries(ExtUpperBuffer,true);
   ArraySetAsSeries(ExtLowerBuffer,true);
//mt5fann.debug=true;

//   if(!mt5fannHigh.Init("High")) Print("Init error");
//   if(!mt5fannLow.Init("Low")) Print("Init error");
   //Print("SYMBOL_SPREAD=",SymbolInfoInteger(_Symbol,SYMBOL_SPREAD)," SYMBOL_TRADE_STOPS_LEVEL =",SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL));
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
   int i,limit;
   ArraySetAsSeries(high,true);
   ArraySetAsSeries(low,true);
   ArraySetAsSeries(time,true);

//---
   if(rates_total<1)
      return(0);
      if(prev_calculated==rates_total)return(rates_total);
//---
   if(prev_calculated<1)
     {
      limit=100;
      //--- clean up arrays
      ArrayInitialize(ExtUpperBuffer,EMPTY_VALUE);
      ArrayInitialize(ExtLowerBuffer,EMPTY_VALUE);
     }
   else limit=rates_total-prev_calculated;
   limit=300;
   double res;

   DelTrash();

   for(i=1;i<limit;i++)
     {
      res=GetTrend(20,_Symbol,0,i,true);
      //if(0!=res)Print(res);
      //---- Price Hi
      //      if(High[i]>High[i+1] && High[i]>High[i+2] && High[i]>=High[i-1] && High[i]>=High[i-2])
      //ExtUpperBuffer[i]=high[i+1]+mt5fannHigh.forecast(i)/100;
      //      if(mt5fannHigh.GetVector(i))
      //        {
      //         mt5fannHigh.run();
      //         mt5fannHigh.get_output();
      //
      //         ExtUpperBuffer[i]=high[i+1]+mt5fannHigh.OutputVector[0]/100;
      //        }
      //      else ExtUpperBuffer[i]=EMPTY_VALUE;
      //ExtLowerBuffer[i]=low[i+1]+mt5fannLow.forecast(i,true)/100;
      //      if(mt5fannLow.GetVector(i))
      //        {
      //         mt5fannLow.run();
      //         mt5fannLow.get_output();
      //
      //         ExtLowerBuffer[i]=low[i+1]+mt5fannLow.OutputVector[0]/100;
      //        }
      //      else ExtLowerBuffer[i]=EMPTY_VALUE;

      //---- Lower Fractal
      //     if(Low[i]<Low[i+1] && Low[i]<Low[i+2] && Low[i]<=Low[i-1] && Low[i]<=Low[i-2])
      //      if(low[i]<low[i+1] && low[i]<=low[i-1])
      //         ExtLowerBuffer[i]=low[i];
      //      else ExtLowerBuffer[i]=EMPTY_VALUE;
     }
//--- OnCalculate done. Return new prev_calculated.
   return(rates_total);
  }
//+------------------------------------------------------------------+
