//+------------------------------------------------------------------+
//|                                              CommonFunctions.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#include <icq_mql5.mqh>
input bool _TrailingPosition_=true;//Разрешить следить за ордерами
input bool _OpenNewPosition_=true;//Разрешить входить в рынок
int TrailingStop=3;
COscarClient client;
//+------------------------------------------------------------------+
//|   Заказ на ордер - хранится на сервере -не открывается автоматом так как цена нереальная  |
//+------------------------------------------------------------------+
bool NewOrder(string smb,ENUM_ORDER_TYPE type,string comment,double price=0,datetime expiration=0)
  {
   ulong    ticket;
   ticket=0;
   int i;
// есть такой-же отложенный ордер
   for(i=0;i<OrdersTotal();i++)
     {
      OrderGetTicket(i);
      if(OrderGetString(ORDER_SYMBOL)==smb)
        {
         if(type==ORDER_TYPE_BUY &&OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_BUY_LIMIT) return(false);
         if(type==ORDER_TYPE_SELL&&OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_SELL_LIMIT) return(false);
        }
     }
// есть открытая позиция
   for(i=0;i<PositionsTotal();i++)
     {
      if(smb==PositionGetSymbol(i))
        {
         if(type==ORDER_TYPE_BUY &&PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY) return(false);
         if(type==ORDER_TYPE_SELL&&PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL) return(false);
        }
     }
   if(ticket!=0)
     {
      return(false);
     }

   MqlTradeRequest trReq;
   MqlTradeResult trRez;
//double BufferO[],
   double BufferC[];
//,BufferL[],BufferH[];
//ArraySetAsSeries(BufferO,true); ArraySetAsSeries(BufferC,true);
//ArraySetAsSeries(BufferL,true); ArraySetAsSeries(BufferH,true);
   int needcopy=2;ENUM_TIMEFRAMES per=_Period;
   ArrayInitialize(BufferC,0);
//ArrayInitialize(BufferO,0);
//ArrayInitialize(BufferL,0);ArrayInitialize(BufferH,0);
// текущая история

//if((CopyOpen(smb,per,0,needcopy,BufferO)==needcopy)
//   && 
   if(CopyClose(smb,per,0,needcopy,BufferC)==needcopy)
      //   && (CopyLow(smb,per,0,needcopy,BufferL)==needcopy)
      //   && (CopyHigh(smb,per,0,needcopy,BufferH)==needcopy)
      //   );else return(false);
      //Print("NewOrder-his0k");
     {
      trReq.action=TRADE_ACTION_PENDING;
      trReq.magic=777;
      trReq.symbol=smb;                 // Trade symbol
      trReq.volume=0.1;      // Requested volume for a deal in lots
      trReq.deviation=5;                                    // Maximal possible deviation from the requested price
      trReq.sl=0;//lasttick.bid + 1.5*TrailingStop*SymbolInfoDouble(smb,SYMBOL_POINT);
      trReq.tp=price;
      trReq.comment=comment;
      //Print(smb," ",type," ",comment);
      if(0==expiration) expiration=TimeCurrent()+3*PeriodSeconds(per);
      trReq.expiration=expiration;
      if(type==ORDER_TYPE_BUY)
        {
         trReq.price=0.00001;                             // SymbolInfoDouble(NULL,SYMBOL_ASK);
         trReq.type=ORDER_TYPE_BUY_LIMIT;
         if(price==0) trReq.tp=BufferC[1];
        }
      else
      if(type==ORDER_TYPE_SELL)
        {
         trReq.price=1000.00001;                             // SymbolInfoDouble(NULL,SYMBOL_ASK);
         trReq.type=ORDER_TYPE_SELL_LIMIT;
         if(price==0) trReq.tp=BufferC[1];
        }
      OrderSend(trReq,trRez);
      if(10009!=trRez.retcode) Print(__FUNCTION__,":",trRez.comment," код ответа",trRez.retcode," trReq.tp=",trReq.tp," trReq.sl=",trReq.sl);

     }
   return(true);
  }
//+------------------------------------------------------------------+
//|   Открывает/закрывает позиции и двигает стоп-лосы. РАБОТАЕТ!!    |
//+------------------------------------------------------------------+

bool Trailing()
  {
//if(AccountInfoDouble(ACCOUNT_FREEMARGIN)<4000) return(false);
   client.autocon=true;
   client.login="645990858";     //<- логин
   client.password="Odnako7952";      //<- пароль
   client.server     = "login.icq.com";
   client.port       = 80;
//client.Connect();

   int PosTotal=PositionsTotal();// открытых позицый
   int OrdTotal=OrdersTotal();   // ордеров
   int i;
   MqlTick lasttick;
   MqlTradeRequest BigDogModif;
   MqlTradeResult BigDogModifResult;
   double BufferO[],BufferC[],BufferL[],BufferH[];
   datetime dt[];
   ArraySetAsSeries(BufferO,true); ArraySetAsSeries(BufferC,true);
   ArraySetAsSeries(BufferL,true); ArraySetAsSeries(BufferH,true);
   ArraySetAsSeries(dt,true);
   int needcopy=5;
   string smb;
   MqlTradeRequest   trReq;
   MqlTradeResult    trRez;

   ENUM_TIMEFRAMES per=PERIOD_M1;
   ulong  ticket;
// проверяем -стоит ли открыть новую позицию, или закрыть старую
   for(i=0;i<OrdTotal && _OpenNewPosition_;i++)
     {// есть "заказы" и открытие разрешено
      ticket=OrderGetTicket(i);
      smb=OrderGetString(ORDER_SYMBOL);
      ArrayInitialize(BufferC,0);ArrayInitialize(BufferO,0);
      ArrayInitialize(BufferL,0);ArrayInitialize(BufferH,0);
      // текущая история
      if((CopyOpen(smb,per,0,needcopy,BufferO)==needcopy)
         && (CopyClose(smb,per,0,needcopy,BufferC)==needcopy)
         && (CopyLow(smb,per,0,needcopy,BufferL)==needcopy)
         && (CopyHigh(smb,per,0,needcopy,BufferH)==needcopy)
         && (CopyTime(smb,per,0,needcopy,dt)==needcopy)
         ); else return(false);
      SymbolInfoTick(smb,lasttick);
      TrailingStop=(int)(3*SymbolInfoInteger(smb,SYMBOL_SPREAD));
      if(TrailingStop<60) TrailingStop=60;
      if(PositionSelect(smb))
        {// есть открытые
         if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)
           { // смотрим есть ли заказ на закрытие
            if(OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_SELL_LIMIT
               && (
               (OrderGetInteger(ORDER_MAGIC)%10)==0 // немедленное закрытие
               || (OrderGetDouble(ORDER_TP)>lasttick.bid && lasttick.bid>PositionGetDouble(POSITION_PRICE_OPEN)) // купят дороже чем хотим и дороже чем купили
               )
               )
              {// нашли на продажу - значит надо закрыться
               //           Print("closepos ",sell_price[SymbolIdx]," ",lasttick.bid," ",PositionGetDouble(POSITION_PRICE_OPEN));
               trReq.action=TRADE_ACTION_DEAL;
               trReq.magic=777;
               trReq.symbol=smb;                 // Trade symbol
               trReq.volume=PositionGetDouble(POSITION_VOLUME);      // Requested volume for a deal in lots
               trReq.deviation=5;                                    // Maximal possible deviation from the requested price
               trReq.price=lasttick.bid;                             // SymbolInfoDouble(NULL,SYMBOL_ASK);
               trReq.type=ORDER_TYPE_SELL;                           // Order type
               trReq.sl=0;//lasttick.bid + 1.5*TrailingStop*SymbolInfoDouble(smb,SYMBOL_POINT);
               trReq.comment=OrderGetString(ORDER_COMMENT);
               OrderSend(trReq,trRez);
               if(10009!=trRez.retcode) Print(__FUNCTION__,":",trRez.comment," код ответа",trRez.retcode," trReq.tp=",trReq.tp," trReq.sl=",trReq.sl);
               else
                 {
                  client.SendMessage("36770049",//<- номер получателя 
                                     smb+" закрыли "); //<- текст сообщения 
                  //trReq.order=ticket;
                  //trReq.action=TRADE_ACTION_REMOVE;
                  //OrderSend(trReq,trRez);
                  //if(10009!=trRez.retcode) Print(__FUNCTION__,":",trRez.comment," код ответа",trRez.retcode," trReq.tp=",trReq.tp," trReq.sl=",trReq.sl);
                 }
              }
           }
         if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL)
           {//sell
            if(OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_BUY_LIMIT
               && ((OrderGetInteger(ORDER_MAGIC)%10)==0
               || (OrderGetDouble(ORDER_TP)<lasttick.ask && lasttick.ask<PositionGetDouble(POSITION_PRICE_OPEN))
               ))
              {
               //       Print("closepos ",buy_price[SymbolIdx]," ",lasttick.bid," ",PositionGetDouble(POSITION_PRICE_OPEN));
               trReq.action=TRADE_ACTION_DEAL;
               trReq.magic=777;
               trReq.symbol=smb;                 // Trade symbol
               trReq.volume=PositionGetDouble(POSITION_VOLUME);   // Requested volume for a deal in lots
               trReq.deviation=5;                     // Maximal possible deviation from the requested price
               trReq.sl=0;//lasttick.bid + 1.5*TrailingStop*SymbolInfoDouble(smb,SYMBOL_POINT);
               trReq.price=lasttick.ask;                   // SymbolInfoDouble(NULL,SYMBOL_ASK);
               trReq.type=ORDER_TYPE_BUY;              // Order type
               trReq.comment=OrderGetString(ORDER_COMMENT);
               OrderSend(trReq,trRez);
               if(10009==trRez.retcode)
                 {
                  client.SendMessage("36770049",//<- номер получателя 
                                     smb+" закрыли "); //<- текст сообщения 
                  //trReq.order=ticket;
                  //trReq.action=TRADE_ACTION_REMOVE;
                  //OrderSend(trReq,trRez);
                  //if(10009!=trRez.retcode) Print(__FUNCTION__,":",trRez.comment," код ответа",trRez.retcode," trReq.tp=",trReq.tp," trReq.sl=",trReq.sl);
                 }
              }
           }
        }
      else
        { // открываем позиции
         if(OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_SELL_LIMIT
            && (
            (OrderGetInteger(ORDER_MAGIC)%10)==0
            || (OrderGetDouble(ORDER_TP)>lasttick.bid)
            )
            )
           {
            trReq.action=TRADE_ACTION_DEAL;
            trReq.magic=777;
            trReq.symbol=smb;                 // Trade symbol
            trReq.volume=OrderGetDouble(ORDER_VOLUME_INITIAL);      // Requested volume for a deal in lots
            trReq.deviation=1;                                    // Maximal possible deviation from the requested price
            trReq.price=lasttick.bid;                             // SymbolInfoDouble(NULL,SYMBOL_ASK);
            trReq.type=ORDER_TYPE_SELL;                           // Order type
            trReq.comment=OrderGetString(ORDER_COMMENT);
            trReq.sl=0;//lasttick.bid + 1.5*TrailingStop*SymbolInfoDouble(smb,SYMBOL_POINT);
            OrderSend(trReq,trRez);
            if(10009!=trRez.retcode) Print(__FUNCTION__,":",trRez.comment," код ответа",trRez.retcode," trReq.tp=",trReq.tp," trReq.sl=",trReq.sl);
            else
              {
               trReq.order=ticket;
               trReq.action=TRADE_ACTION_REMOVE;
               OrderSend(trReq,trRez);
               if(10009!=trRez.retcode) Print(__FUNCTION__,":",trRez.comment," код ответа",trRez.retcode," trReq.tp=",trReq.tp," trReq.sl=",trReq.sl);
              }
           }
         if(OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_BUY_LIMIT
            && ((OrderGetInteger(ORDER_MAGIC)%10)==0
            || (OrderGetDouble(ORDER_TP)<lasttick.ask)
            ))
           {
            trReq.action=TRADE_ACTION_DEAL;
            trReq.magic=777;
            trReq.symbol=smb;                 // Trade symbol
            trReq.volume=OrderGetDouble(ORDER_VOLUME_INITIAL);      // Requested volume for a deal in lots
            trReq.deviation=1;                     // Maximal possible deviation from the requested price
            trReq.sl=0;//lasttick.bid + 1.5*TrailingStop*SymbolInfoDouble(smb,SYMBOL_POINT);
            trReq.price=lasttick.bid;                   // SymbolInfoDouble(NULL,SYMBOL_ASK);
            trReq.type=ORDER_TYPE_BUY;              // Order type
            trReq.comment=OrderGetString(ORDER_COMMENT);
            OrderSend(trReq,trRez);
            if(10009==trRez.retcode)
              {
               trReq.order=ticket;
               trReq.action=TRADE_ACTION_REMOVE;
               OrderSend(trReq,trRez);
               if(10009!=trRez.retcode) Print(__FUNCTION__,":",trRez.comment," код ответа",trRez.retcode," trReq.tp=",trReq.tp," trReq.sl=",trReq.sl);
              }
           }
        }
     }
/// traling open           
   for(i=0;i<PositionsTotal() && _TrailingPosition_;i++)
     {
      smb=PositionGetSymbol(i);
      // текущая история
      if((CopyOpen(smb,per,0,needcopy,BufferO)==needcopy)
         && (CopyClose(smb,per,0,needcopy,BufferC)==needcopy)
         && (CopyLow(smb,per,0,needcopy,BufferL)==needcopy)
         && (CopyHigh(smb,per,0,needcopy,BufferH)==needcopy)
         && (CopyTime(smb,per,0,needcopy,dt)==needcopy)
         ){} else return(false);
      SymbolInfoTick(smb,lasttick);
      trReq.symbol=smb;
      trReq.deviation=3;
      TrailingStop=(int)(3*SymbolInfoInteger(smb,SYMBOL_SPREAD));
      if(TrailingStop<60) TrailingStop=60;
      if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL)
        {
         if(0==PositionGetDouble(POSITION_SL))
           {
            trReq.action=TRADE_ACTION_SLTP;
            //Print(lasttick.ask," ",1.1*TrailingStop*SymbolInfoDouble(smb,SYMBOL_POINT));
            trReq.sl=lasttick.ask+1.1*TrailingStop*SymbolInfoDouble(smb,SYMBOL_POINT);
            trReq.tp=PositionGetDouble(POSITION_TP);
            //if((PositionGetDouble(POSITION_SL)-trReq.sl)>SymbolInfoDouble(smb,SYMBOL_POINT)) 
            OrderSend(trReq,BigDogModifResult);
            //Print(__FUNCTION__,":",trRez.comment," код ответа",trRez.retcode,"lt.ask=",lasttick.ask," trReq.sl=",trReq.sl);
           }
         else
           {
            if(
               ((PositionGetDouble(POSITION_PRICE_OPEN)-lasttick.ask)/SymbolInfoDouble(smb,SYMBOL_POINT)>TrailingStop)
               && ((BufferH[1]+TrailingStop*SymbolInfoDouble(smb,SYMBOL_POINT))<PositionGetDouble(POSITION_SL)
               && (PositionGetDouble(POSITION_SL)-lasttick.ask)/SymbolInfoDouble(smb,SYMBOL_POINT)>TrailingStop)
               )

              {
               //Print(TimeCurrent()," ",dt[1]," ",smb," ",BufferH[1]," ",BufferH[1] + TrailingStop*SymbolInfoDouble(smb,SYMBOL_POINT));
               trReq.action=TRADE_ACTION_SLTP;
               trReq.sl=BufferH[1]+TrailingStop*SymbolInfoDouble(smb,SYMBOL_POINT);
               trReq.tp=PositionGetDouble(POSITION_TP);
               if((PositionGetDouble(POSITION_SL)-trReq.sl)>SymbolInfoDouble(smb,SYMBOL_POINT)) OrderSend(trReq,BigDogModifResult);
               //Print(__FUNCTION__,":",trRez.comment," код ответа",trRez.retcode,"lt.ask=",lasttick.ask," trReq.sl=",trReq.sl);
              }
           }
        }
      else
        {
         if(0==PositionGetDouble(POSITION_SL))
           {
            trReq.action=TRADE_ACTION_SLTP;
            trReq.sl= lasttick.bid-1.1*TrailingStop*SymbolInfoDouble(smb,SYMBOL_POINT);
            trReq.tp= PositionGetDouble(POSITION_TP);
            //Print(trReq.sl," tp=",trReq.tp);
            //if((trReq.sl-PositionGetDouble(POSITION_SL))>SymbolInfoDouble(smb,SYMBOL_POINT)) 
            OrderSend(trReq,BigDogModifResult);
           }
         else
           {
            if(
               ((lasttick.bid-PositionGetDouble(POSITION_PRICE_OPEN))/SymbolInfoDouble(smb,SYMBOL_POINT)>TrailingStop)
               && ((BufferL[1]-TrailingStop*SymbolInfoDouble(smb,SYMBOL_POINT))>PositionGetDouble(POSITION_SL)
               && (lasttick.bid-PositionGetDouble(POSITION_SL))/SymbolInfoDouble(smb,SYMBOL_POINT)>TrailingStop)
               )
              {
               // Print(TimeCurrent()," ",BufferL[1] - TrailingStop*SymbolInfoDouble(smb,SYMBOL_POINT));
               trReq.action=TRADE_ACTION_SLTP;
               trReq.sl= BufferL[1]-TrailingStop*SymbolInfoDouble(smb,SYMBOL_POINT);
               trReq.tp= PositionGetDouble(POSITION_TP);
               if((trReq.sl-PositionGetDouble(POSITION_SL))>SymbolInfoDouble(smb,SYMBOL_POINT)) OrderSend(trReq,BigDogModifResult);
               //Print(__FUNCTION__,":",trRez.comment," код ответа",trRez.retcode," lt.bid=",lasttick.bid," trReq.sl=",trReq.sl);
              }
           }
        }
     }
//client.Disconnect();
   return(true);
  }
//+------------------------------------------------------------------+
