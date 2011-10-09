//+------------------------------------------------------------------+
//|                                                       Socket.mq5 |
//|                                                     GreyCardinal |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include <GC\Socket.mqh>

#define host "encogserver"
//#define host "192.168.2.104"
//#define host "localhost"
#define port 7777

SOCKET_CLIENT client;
MqlTick tick;
//+------------------------------------------------------------------+
int OnInit()
//+------------------------------------------------------------------+
  {
   if(SocketOpen(client,host,port)==SOCKET_CONNECT_STATUS_OK)
      Print("Socket Opened");
   EventSetTimer(6);
   return(0);
  }
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
//+------------------------------------------------------------------+
  {
//SocketWriteString(client,"!Exit\n");
   SocketClose(client);
   Print("Socket Closed");
   EventKillTimer();
  }
//+------------------------------------------------------------------+
void OnTimer()
//+------------------------------------------------------------------+
  {
   static int nm=0;
   string str_out,str_in;
   int r=0;
   if(SymbolInfoTick(_Symbol,tick))
     {

      str_out=StringFormat("%s %s %s %s %s",IntegerToString(nm++),_Symbol,TimeToString(tick.time,TIME_DATE|TIME_SECONDS),
                           DoubleToString(tick.bid,_Digits),DoubleToString(tick.ask,_Digits));

      if(SocketWriteString(client,str_out+"\n")==SOCKET_CONNECT_STATUS__ERROR)
        {
         Print("Error, connection failed");
         Sleep(3000);
         if(SocketOpen(client,host,port)==SOCKET_CONNECT_STATUS_OK)
            Print("Opened Socket");
        }
      else Print(str_out);
     }
   if((r=SocketReadString(client,str_in))>0)
     {
      Print("get...",r," ",str_in);
     }
  }
//+------------------------------------------------------------------+
