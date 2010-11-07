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
 //  double need_output;
   if(!SineX.Init("sinex")) Print("Init error");
   SineX.test_on_file();
   SineX.train_on_file();
//   for(int i=0;i<10;i++)
//     {
//      if(GetVectors(SineX.InputVector,SineX.OutputVector,SineX.get_num_input(),SineX.get_num_output(),"sinex",i))
//        {
//         //Print(SineX.InputVector[0]," ",SineX.OutputVector[0]);
//         need_output = SineX.OutputVector[0];
//         //Print(SineX.test());
//         SineX.run();
//         if(SineX.get_output()) Print(SineX.InputVector[0]," out=",SineX.OutputVector[0]," need=",need_output);
////         Print(SineX.get_MSE());
//        }
//     }
  // SineX.train_on_file();

//  Print(mt5fann.train_on_file("sinex.train"));
//mt5fann.Init("forex");
  }
//+------------------------------------------------------------------+
