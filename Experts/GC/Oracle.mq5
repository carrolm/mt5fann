#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include <GC\Oracle.mqh>
#include <GC\CommonFunctions.mqh>
COracleEasy *Oracles[];
int nOracles;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   ArrayResize(Oracles,10);
   nOracles=0;
   Oracles[nOracles++]=new CiStochastic;
   Oracles[nOracles++]=new CiMACD;
   Oracles[nOracles++]=new CiMA;
   Oracles[nOracles++]=new CPriceChanel;
   Oracles[nOracles++]=new CiRSI;
   Oracles[nOracles++]=new CiCGI;
   Oracles[nOracles++]=new CiWPR;
   Oracles[nOracles++]=new CiBands;
   Oracles[nOracles++]=new CNRTR;
   Print("Ready!");
   return(0);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   for(int i=0;i<nOracles;i++) delete Oracles[i];
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(_TrailingPosition_) Trailing();
   int io; 
    double   res=0;
      for(io=0;io<nOracles;io++)
        {
         res+=Oracles[io].forecast(Symbol());
        }
   NewOrder(_Symbol,res,"");
  }
//+------------------------------------------------------------------+
