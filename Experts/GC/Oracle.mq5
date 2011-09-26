//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2010, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include <GC\Oracle.mqh>
#include <GC\CommonFunctions.mqh>
#include <GC\Watcher.mqh>
//COracleTemplate *Oracles[];
input int _NEDATA_=10000;// cколько выгрузить
int nOracles;
CWatcher watcher;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   ArrayResize(AllOracles,20);
   nOracles=0;//AllOracles();
   AllOracles[nOracles++]=new CEasy;//COracleTemplate;
   AllOracles[0].Init();
   //AllOracles[0].ExportHistoryENCOG("","",_NEDATA_,0,0);
   Print(AllOracles[0].GetInputAsString(_Symbol,0));
//for(int i=0;i<nOracles;i++) Print(AllOracles[i].Name()," Ready!");
//   double            InputVector[];ArrayResize(InputVector,20);
//   GetVectors(InputVector,AllOracles[0].inputSignals,_Symbol,0,0);
   return(0);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   for(int i=0;i<nOracles;i++) delete AllOracles[i];
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(!isNewBar(_Symbol))   return;
   string str=AllOracles[0].GetInputAsString(_Symbol,0);
   if(""==str)  return;
    
   return;
   if(_TrailingPosition_) Trailing();
   int io;
   double   res=0;
   for(io=0;io<nOracles;io++)
     {
      res+=AllOracles[io].forecast(_Symbol,0,false);
      Print(AllOracles[io].GetInputAsString(_Symbol,0));
      watcher.AddNotify("");
      watcher.SendNotify();
     }

//
   NewOrder(_Symbol,res,"");
  }
//+------------------------------------------------------------------+
void OnChartEvent(const int id,         // идентификатор события  
                  const long& lparam,   // параметр события типа long
                  const double& dparam, // параметр события типа double
                  const string& sparam  // параметр события типа string
                  )
  {
//if(id==(int)CHARTEVENT_CLICK)
//  {
//   Print("Координаты щелчка мышки на графике: x=",lparam,"  y=",dparam);
//  };
   if(id==(int)CHARTEVENT_OBJECT_CLICK)
     {
      datetime dt=(datetime)ObjectGetInteger(0,sparam,OBJPROP_TIME);
      //Print("Координаты щелчка мышки на объекте: x=",lparam,"  y=",dparam," ",sparam," ",dt);
      int io;
      double   res=0,tres=0;
      Print("For ",dt);
      for(io=0;io<nOracles;io++)
        {
         res=AllOracles[io].forecast(Symbol(),dt,false);
         tres+=res;
         if(0!=res) Print(AllOracles[io].Name()," ",res);
        }

     };

  }
//+------------------------------------------------------------------+
