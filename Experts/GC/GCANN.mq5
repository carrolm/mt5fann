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
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
  MyExpert=new CGCANN;
  MyExpert.Load("GCANN");
  MyExpert.ini_save("GCANN_new");
  Print("Ready!");

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
   if(_TrailingPosition_) Trailing();
   NewOrder(_Symbol,MyExpert.forecast()*10,"");
//---
   
  }
//+------------------------------------------------------------------+
