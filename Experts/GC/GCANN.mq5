//+------------------------------------------------------------------+
//|                                                        GCANN.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include <GC\gc_ann.mqh>
#include <GC\GetVectors.mqh>
#include <GC\CommonFunctions.mqh>
CGCANN *MyExpert;
int bars;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   MyExpert=new CGCANN;
   MyExpert.Load("GCANN");
   MyExpert.Save("GCANN_new");
   Print("Ready!");
   double f=MyExpert.forecast();
   Print("f="+(string)f);
   bars=0;
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
   if(_TrailingPosition_) Trailing(); 
   if(isNewBar())
     {
      bars=Bars(_Symbol,_Period);
      double f=MyExpert.forecast();
      Print("f="+(string)f);
      NewOrder(_Symbol,f,"");
     }
  }
//+------------------------------------------------------------------+
