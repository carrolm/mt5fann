//+------------------------------------------------------------------+
//|                                                    FannExper.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include <GC\MT5FANN.mqh>
#include <GC\GetVectors.mqh>
#include <GC\CommonFunctions.mqh>
input double LotSize=0.1; // Размер лота
#include <GC\CurrPairs.mqh> // пары
CMT5FANN fannExpert;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {

   fannExpert.debug=true;

   if(!fannExpert.Init("fx_eliot")) Print("Init error");
  
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
 
   if(fannExpert.GetVector())
     {
      fannExpert.run();
      fannExpert.get_output();
      //Print(_Symbol,fannExpert," ".OutputVector[0]);
      if(fannExpert.OutputVector[0]>0.3 )  NewOrder(_Symbol,ORDER_TYPE_BUY,(string)fannExpert.OutputVector[0]);
      if(fannExpert.OutputVector[0]<-0.3 ) NewOrder(_Symbol,ORDER_TYPE_SELL,(string)fannExpert.OutputVector[0]);
      
 //     Print(fannExpert.OutputVector[0]);
     }
   Trailing();
  }
  
   

//+------------------------------------------------------------------+
