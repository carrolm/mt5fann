//+------------------------------------------------------------------+
//|                                                 MT5FANN_TEST.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include <GC\MT5FANN.mqh>
#include <GC\GetVectors.mqh>
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   CMT5FANN SineX;
   SineX.debug=true;

   if(!SineX.Init("sinex")) Print("Init error");
   Print("NI=",SineX.get_num_input());//
   Print("NO=",SineX.get_num_output());//
   if(GetVectors(SineX.InputVector,SineX.OutputVector,SineX.get_num_input(),SineX.get_num_output(),"sinex"))
      Print(SineX.InputVector[0]," ",SineX.OutputVector[0]);
//  Print(mt5fann.train_on_file("sinex.train"));
//mt5fann.Init("forex");
  }
//+------------------------------------------------------------------+
