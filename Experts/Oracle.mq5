//+------------------------------------------------------------------+
//|                                                       Oracle.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include <Trade\Trade.mqh>



//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include <Oracles.mqh>
int OnInit()
  {
//---
//   MqlRates rates[];
//   ArraySetAsSeries(rates,true);
//   int copied=CopyRates(Symbol(),0,0,10,rates);
//   if(copied>0)
//     {
//      Print("—копировано баров:"+copied);
//      string format="open=%G, high=%G, low=%G, close=%G, volume=%d";
//      string out;
//      int size=fmin(copied,10);
//      for(int i=0;i<size;i++)
//        {
//         out=i+":"+TimeToString(rates[i].time);
//         out=out+" "+StringFormat(format,
//                                  rates[i].open,
//                                  rates[i].high,
//                                  rates[i].low,
//                                  rates[i].close,
//                                  rates[i].tick_volume);
//         Print(out);
//        }
//     }
//   else Print("Ќе удалось получить исторические данные по символу",Symbol());
//

//---
   
//---
   return(0);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   CCandels myExpert;
//   TOracle myExpert=new CRevers();
   if (myExpert.Prediction(_Symbol))
   //&&Heiken_Ashi.Prediction(_Symbol)) 
//   if (Revers.Prediction(_Symbol)) 
    {
//     Print("Heiken_Ashi=",Heiken_Ashi.way,"eSimpleMA",eSimpleMA.way);
//     if ((0!=Heiken_Ashi.way)&&
     if (0!=myExpert.way)
//     if ((0!=Revers.way))
      {
      Print(myExpert.way,myExpert.price,TimeCurrent());
       CTrade trade;
       if (0>myExpert.way&&myExpert.price<SymbolInfoDouble(_Symbol,SYMBOL_BID))// продажа
//       if (0>myExpert.way)// продажа
        {
         double stop_level=SymbolInfoDouble(_Symbol,SYMBOL_ASK)+SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point;
         if(!trade.PositionOpen(_Symbol,ORDER_TYPE_SELL,0.1,SymbolInfoDouble(_Symbol,SYMBOL_BID),stop_level,0))
            Print(trade.ResultRetcodeDescription());
        }
       else
       {
      double stop_level=SymbolInfoDouble(_Symbol,SYMBOL_BID)-SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point;
      if (0<myExpert.way&&myExpert.price>SymbolInfoDouble(_Symbol,SYMBOL_ASK))// продажа
//       if (0<Heiken_Ashi.way)// продажа
         if(!trade.PositionOpen(_Symbol,ORDER_TYPE_BUY,0.1,SymbolInfoDouble(_Symbol,SYMBOL_ASK),stop_level,0))
            Print(trade.ResultRetcodeDescription());
       }
//       Print(Heiken_Ashi.way);
      }
    }
  }
//+------------------------------------------------------------------+

