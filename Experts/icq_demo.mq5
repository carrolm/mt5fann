//+------------------------------------------------------------------+
//|                                                    icq_demo.mq5  |
//|              Copyright Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include <icq_mql5.mqh>

COscarClient client;

//+------------------------------------------------------------------+
int OnInit()
//+------------------------------------------------------------------+
{
   printf("Start ICQ Client");
   
   client.login      = "610043094";     //<- логин
   client.password   = "password";      //<- пароль
   client.server     = "login.icq.com";
   client.port       = 5190;
   client.Connect();
   
   return(0);
}
  
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
//+------------------------------------------------------------------+
{
   client.Disconnect();
   printf("Stop ICQ Client");
}
  
//+------------------------------------------------------------------+
void OnTick()
//+------------------------------------------------------------------+
{
   string text;
   static datetime time_out;
   MqlTick last_tick;

   // чтение сообщений
   while(client.ReadMessage(client.uin,client.msg,client.len))
   { 
      printf("Receive: %s, %s, %u", client.uin, client.msg, client.len);
   }

   // передача котировок каждые 30 сек
   if((TimeCurrent()-time_out)>=30)
   {
      time_out = TimeCurrent();
      SymbolInfoTick(Symbol(), last_tick);
      
      text = Symbol()+" BID:"+DoubleToString(last_tick.bid, Digits())+
                  " ASK:"+DoubleToString(last_tick.ask, Digits()); 
      
      if (client.SendMessage("266690424",  //<- номер получателя 
                          text))           //<- текст сообщения 
         printf("Send: " + text);
   }
}
//+------------------------------------------------------------------+