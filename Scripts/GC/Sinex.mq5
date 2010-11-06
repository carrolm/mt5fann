//+------------------------------------------------------------------+
//|                                                 MT5FANN_TEST.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include <GC\MT5FANN.mqh>
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   CMT5FANN mt5fann;
   mt5fann.debug=true;

   if(!mt5fann.Init("sinex")) Print("Init error");
 //  Print(mt5fann.train_on_file("sinex.train"));
//mt5fann.Init("forex");
  }
//+------------------------------------------------------------------+
