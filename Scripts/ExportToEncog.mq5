//+------------------------------------------------------------------+
//|                                                ExportToEncog.mq5 |
//|                                      Copyright 2011, Investeo.pl |
//|                                                http:/Investeo.pl |
//+------------------------------------------------------------------+
#property copyright "Copyright 2011, Investeo.pl"
#property link      "http:/Investeo.pl"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+

// Export Indicator values for NN training by ENCOG
#include <GC\Oracle.mqh>
#include <GC\CommonFunctions.mqh>
//COracleTemplate *Oracles[];
input int _NEDATA_=100000;// cколько выгрузить

void OnStart()
  {

   COracleTemplate* MyOracles=new COracleTemplate;
   MyOracles.Init();
   MyOracles.ExportHistoryENCOG("","",_NEDATA_,0,0);
   delete  MyOracles;
   Print("Indicator data exported."); 
  }
//+------------------------------------------------------------------+
