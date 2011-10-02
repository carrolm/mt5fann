//+------------------------------------------------------------------+
//|                                                OracleEasyICQ.mqh |
//|                        Copyright 2011, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2011, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#include <gc\icq_mql5.mqh>
#include <gc\Oracle.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CEasyICQ:public COracleTemplate
  {
   COscarClient      client;
   virtual double    forecast(string smbl,int shift,bool train);
   //virtual double    forecast(string smbl,datetime startdt,bool train);
   virtual string    Name(){return("Easy");};
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CEasyICQ::forecast(string smbl,int shift,bool train)
  {
   double res=0;
   int i=0;
   client.SendMessage(ICQ_Expert,GetInputAsString(smbl,shift));
   for(i=0;i<100||client.ReadMessage(client.uin,client.msg,client.len);i++)
      {
        //client.ReadMessage(client.uin,client.msg,client.len);
      }
   if(client.len>0 &&0<StringFind(client.msg,smbl,0))
      {
      Print(client.msg);
      if(0==StringFind(client.msg,"!Sell",0)) return(-1);
      if(0==StringFind(client.msg,"!Buy",0)) return(1);
//      if(0==StringFind(client.msg,"!Sell",0) return(-1);
//      if(0==StringFind(client.msg,"!Sell",0) return(-1);
      
//      res = StringToDouble(client.msg);// есть ответ
      }   
   return(res);
  }
//+------------------------------------------------------------------+
