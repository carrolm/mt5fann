//+------------------------------------------------------------------+
//|                                              CommonFunctions.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
//#include <icq_mql5.mqh>
input bool _TrailingPosition_=true;//Разрешить следить за ордерами
input bool _OpenNewPosition_=true;//Разрешить входить в рынок
input int _NumTS_=3;//Сколько спредов до стоплоса
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool isNewBar(string smbl="",ENUM_TIMEFRAMES tf=0)
  {
   static datetime lastTime=0;
   if(""==smbl)smbl=_Symbol;
   datetime lastbarTime=(datetime)SeriesInfoInteger(smbl,tf,SERIES_LASTBAR_DATE);
   if(lastTime==0 || lastTime!=lastbarTime)
     {
      lastTime=lastbarTime;
      return(true);
     }
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum NewOrder_Type
  {
   NewOrderBuy=1,// 
   NewOrderWaitBuy=2,// 
   NewOrderWait=3,// 
   NewOrderWaitSell=4,
   NewOrderSell=5
  };
//COscarClient client;
// ask
// bid
//+------------------------------------------------------------------+
//|   Заказ на ордер - хранится на сервере -не открывается автоматом так как цена нереальная  |
//+------------------------------------------------------------------+
bool NewOrder(string smb,double way,string comment,double price=0,int magic=777,datetime expiration=0)
  {
   if(""==comment) comment=(string)way;
   if(0.66<way) return(NewOrder(smb,NewOrderBuy,comment,price,magic,expiration));
   // пока выключим -кажется что глючит if(0.33<way) return(NewOrder(smb,NewOrderWaitBuy,comment,price,magic,expiration));
   if(-0.66>way) return(NewOrder(smb,NewOrderSell,comment,price,magic,expiration));
   // пока выключим -кажется что глючит if(-0.33>way) return(NewOrder(smb,NewOrderWaitSell,comment,price,magic,expiration));
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool NewOrder(string smb,NewOrder_Type type,string comment,double price=0,int magic=777,datetime expiration=0)
  {
   if(""==smb)
   {
   Print("empty symbol");
   return(false);
   }
   StringToUpper(smb);
   if(NewOrderWait==type || !_OpenNewPosition_) return(false);
   if(""==comment) comment=smb;
   ulong    ticket;
   ticket=0;
   int i;
// есть такой-же отложенный ордер
   for(i=0;i<OrdersTotal();i++)
     {
      OrderGetTicket(i);
      if(OrderGetString(ORDER_SYMBOL)==smb)
        {
         if(type==NewOrderBuy && OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_BUY_LIMIT) return(false);
         if(type==NewOrderWaitBuy && OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_BUY_LIMIT) return(false);
         if(type==NewOrderSell  &&  OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_SELL_LIMIT) return(false);
         if(type==NewOrderWaitSell && OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_SELL_LIMIT) return(false);
        }
     }
// есть открытая позиция
   for(i=0;i<PositionsTotal();i++)
     {
      if(smb==PositionGetSymbol(i))
        {
         // докупать? закомментировать тогда!
         if(type==NewOrderBuy && PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY) return(false);
         if(type==NewOrderWaitBuy && PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY) return(false);
         // допродать? закомментировать тогда!
         if(type==NewOrderSell && PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL) return(false);
         if(type==NewOrderWaitSell && PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL) return(false);
         // если открыта позиция - и сигнал против -тогда перейти врежим паники!!
         ticket=PositionGetInteger(POSITION_IDENTIFIER);
         break;
        }
     }
   // если нет паники, а есть слабые сигналы -их пинаем...
   if((0==ticket)&&(type==NewOrderWaitBuy||type==NewOrderWaitSell))return(false);  
   MqlTick lasttick;
   if(!SymbolInfoTick(smb,lasttick)) return(false);;
   if(price==0)
     {
      if(ticket!=0)
        {// есть открытая и она выбрана то паника - ставим на цену с мин прибылью -лишь бы закрыть
         magic=666;
         if(type==NewOrderWaitBuy || type==NewOrderBuy)
           {
            if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL)
              {
               // если прибыль уже есть -то приближаем к идеалу
               if(PositionGetDouble(POSITION_PROFIT)>0)
                  price=PositionGetDouble(POSITION_PRICE_CURRENT)-SymbolInfoInteger(smb,SYMBOL_SPREAD)*SymbolInfoDouble(smb,SYMBOL_POINT)*1.1;
               else// иначе ставим на мин прибыль
               price=lasttick.bid;//PositionGetDouble(POSITION_PRICE_OPEN)-1.5*SymbolInfoInteger(smb,SYMBOL_SPREAD)*SymbolInfoDouble(smb,SYMBOL_POINT);//BufferC[1];
              }
            else return(false);
           }
         if(type==NewOrderWaitSell || type==NewOrderSell)
           {
            if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)
              {
               // если прибыль уже есть -то приближаем к идеалу
               if(PositionGetDouble(POSITION_PROFIT)>0)
                  price=PositionGetDouble(POSITION_PRICE_CURRENT)+SymbolInfoInteger(smb,SYMBOL_SPREAD)*SymbolInfoDouble(smb,SYMBOL_POINT)*1.1;
               else// иначе ставим на мин прибыль
               price=lasttick.ask;//PositionGetDouble(POSITION_PRICE_OPEN)+1.5*SymbolInfoInteger(smb,SYMBOL_SPREAD)*SymbolInfoDouble(smb,SYMBOL_POINT);//BufferC[1];
              }
            else return(false);
           }

         // трекинг на закрытие - этот одрер будет жить до закрытия открытой 
         if(0==expiration) expiration=TimeCurrent()+PeriodSeconds(PERIOD_H4);
        }
      else
        {
         if(type==NewOrderBuy) price=lasttick.bid;
         if(type==NewOrderWaitBuy) price=lasttick.bid;
         if(type==NewOrderWaitSell) price=lasttick.ask;
         if(type==NewOrderSell) price=lasttick.ask;
        }
     }
   if(0==expiration) expiration=TimeCurrent()+3*PeriodSeconds(_Period);

   MqlTradeRequest trReq;
   MqlTradeResult trRez;
   trReq.action=TRADE_ACTION_PENDING;
   trReq.magic=magic;
   trReq.symbol=smb;                 // Trade symbol
   trReq.volume=0.1;      // Requested volume for a deal in lots
   trReq.deviation=5;                                    // Maximal possible deviation from the requested price
   trReq.sl=0;//lasttick.bid + 1.5*TrailingStop*SymbolInfoDouble(smb,SYMBOL_POINT);
   trReq.tp=price;
   trReq.comment=comment;
   trReq.expiration=expiration;

   if(type==NewOrderBuy || type==NewOrderWaitBuy)
     {
      trReq.price=0.001;                             // SymbolInfoDouble(NULL,SYMBOL_ASK);
      trReq.type=ORDER_TYPE_BUY_LIMIT;
     }

   else//  if(type==NewOrderSell||type==NewOrderWaitSell)
     {
      trReq.price=10000.00001;                             // SymbolInfoDouble(NULL,SYMBOL_ASK);
      trReq.type=ORDER_TYPE_SELL_LIMIT;
     }
   OrderSend(trReq,trRez);
   if(10009!=trRez.retcode) 
   {
      Print(__FUNCTION__," : ",trRez.comment," код ответа ",trRez.retcode," trReq.price=",trReq.price," trReq.tp=",trReq.tp," trReq.sl=",trReq.sl," trReq.type=",trReq.type);
     if(ORDER_TYPE_BUY_LIMIT==trReq.type) Print("ORDER_TYPE_BUY_LIMIT");  
   }
   return(true);
  }
//+------------------------------------------------------------------+
//|   Открывает/закрывает позиции и двигает стоп-лосы. РАБОТАЕТ!!    |
//+------------------------------------------------------------------+

bool Trailing()
  {
//if(AccountInfoDouble(ACCOUNT_FREEMARGIN)<4000) return(false);
//client.autocon=true;
//client.login="645990858";     //<- логин
//client.password="Odnako7952";      //<- пароль
//client.server     = "login.icq.com";
//client.port       = 80;
//client.Connect();

   int PosTotal=PositionsTotal();// открытых позицый
   int OrdTotal=OrdersTotal();   // ордеров
   int i,TrailingStop;
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
      TrailingStop=(int)(_NumTS_*SymbolInfoInteger(smb,SYMBOL_TRADE_STOPS_LEVEL));
      //if(TrailingStop<SymbolInfoInteger(smb,SYMBOL_TRADE_STOPS_LEVEL)) TrailingStop=(int)SymbolInfoInteger(smb,SYMBOL_TRADE_STOPS_LEVEL);
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
               trReq.magic=999;
               trReq.symbol=smb;                 // Trade symbol
               trReq.volume=PositionGetDouble(POSITION_VOLUME);      // Requested volume for a deal in lots
               trReq.deviation=5;                                    // Maximal possible deviation from the requested price
               trReq.price=lasttick.bid;                             // SymbolInfoDouble(NULL,SYMBOL_ASK);
               trReq.type=ORDER_TYPE_SELL;                           // Order type
               trReq.sl=0;// trReq.price+1.1*TrailingStop*SymbolInfoDouble(smb,SYMBOL_POINT);
               trReq.tp=0;//lasttick.ask+1.1*TrailingStop*SymbolInfoDouble(smb,SYMBOL_POINT);
               trReq.comment=OrderGetString(ORDER_COMMENT);
               OrderSend(trReq,trRez);
               if(10009!=trRez.retcode) Print(__FUNCTION__," sell:",trRez.comment," ",smb," код ответа ",trRez.retcode," trReq.tp=",trReq.tp," trReq.sl=",trReq.sl);
               else
                 {
                  //client.SendMessage("36770049",  smb+" закрыли "); //<- текст сообщения 
                 }
              }
            else
              { // закрыть не смогли или не захотели -посмотрим может его двинуть "получше"?
               double newtp=lasttick.bid-1.1*SymbolInfoInteger(smb,SYMBOL_TRADE_STOPS_LEVEL)*SymbolInfoDouble(smb,SYMBOL_POINT);
               if(OrderGetDouble(ORDER_TP)<newtp)
                 {
                  trReq.order=ticket;
                  trReq.comment= OrderGetString(ORDER_COMMENT);
                  trReq.symbol = OrderGetString(ORDER_SYMBOL);
                  //trReq.price=OrderGetDouble(ORDER_PRICE_);
                  trReq.price=10000.00001;                             // SymbolInfoDouble(NULL,SYMBOL_ASK);
                  trReq.sl=OrderGetDouble(ORDER_SL);
                  trReq.magic=OrderGetInteger(ORDER_MAGIC);
                  //if( (OrderGetDouble(ORDER_TP)>lasttick.bid)OrderGetString(ORDER_COMMENT);
                  trReq.tp=newtp;

                  trReq.action=TRADE_ACTION_MODIFY;
                  OrderSend(trReq,trRez);
                  if(10009!=trRez.retcode) Print(__FUNCTION__," sell sl:",trRez.comment," ",smb," код ответа",trRez.retcode," trReq.tp=",trReq.tp," trReq.sl=",trReq.sl);
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
               trReq.magic=999;
               trReq.symbol=smb;                 // Trade symbol
               trReq.volume=PositionGetDouble(POSITION_VOLUME);   // Requested volume for a deal in lots
               trReq.deviation=5;                     // Maximal possible deviation from the requested price
               trReq.sl=0;//lasttick.ask+1.1*TrailingStop*SymbolInfoDouble(smb,SYMBOL_POINT);
               trReq.tp=0;//lasttick.ask+1.1*TrailingStop*SymbolInfoDouble(smb,SYMBOL_POINT);
               trReq.price=lasttick.ask;                   // SymbolInfoDouble(NULL,SYMBOL_ASK);
               trReq.type=ORDER_TYPE_BUY;              // Order type
               trReq.comment=OrderGetString(ORDER_COMMENT);
               OrderSend(trReq,trRez);
               if(10009!=trRez.retcode) Print(__FUNCTION__," buy:",trRez.comment," ",smb," код ответа ",trRez.retcode," trReq.tp=",trReq.tp," trReq.sl=",trReq.sl);
               else
                 {
                  // client.SendMessage("36770049",//<- номер получателя 
                  //                  smb+" закрыли "); //<- текст сообщения 
                 }
              }
            else
              { // закрыть не смогли или не захотели -посмотрим может его двинуть "получше"?
               double newtp=lasttick.ask+1.1*SymbolInfoInteger(smb,SYMBOL_TRADE_STOPS_LEVEL)*SymbolInfoDouble(smb,SYMBOL_POINT);
               if(OrderGetDouble(ORDER_TP)>newtp)
                 {
                  trReq.order=ticket;
                  trReq.comment= OrderGetString(ORDER_COMMENT);
                  trReq.symbol = OrderGetString(ORDER_SYMBOL);
                  trReq.price=0.00001;                             // SymbolInfoDouble(NULL,SYMBOL_ASK);
                  trReq.sl=OrderGetDouble(ORDER_SL);
                  trReq.magic=OrderGetInteger(ORDER_MAGIC);
                  //if( (OrderGetDouble(ORDER_TP)>lasttick.bid)OrderGetString(ORDER_COMMENT);
                  trReq.tp=newtp;

                  trReq.action=TRADE_ACTION_MODIFY;
                  OrderSend(trReq,trRez);
                  if(10009!=trRez.retcode) Print(__FUNCTION__," buy sl:",trRez.comment," ",smb," код ответа",trRez.retcode," trReq.tp=",trReq.tp," trReq.sl=",trReq.sl);
                 }
              }
           }
        }
      else
        {
         // если был ордер на закрытие -то удаляем просто
         if(666==OrderGetInteger(ORDER_MAGIC))
           {
            MqlTradeRequest request;
            request.order=ticket;
            request.action=TRADE_ACTION_REMOVE;
            OrderSend(request,trRez);
            if(10009!=trRez.retcode) Print(__FUNCTION__,":",trRez.comment," ",smb," код ответа",trRez.retcode," trReq.tp=",trReq.tp," trReq.sl=",trReq.sl);

           }
         // открываем позиции
         trReq.price=0;
         if(OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_SELL_LIMIT
            && (
            (OrderGetInteger(ORDER_MAGIC)%10)==0
            || (OrderGetDouble(ORDER_TP)>lasttick.bid)
            )
            )
           {
            trReq.price=lasttick.bid;                             // SymbolInfoDouble(NULL,SYMBOL_ASK);
            trReq.type=ORDER_TYPE_SELL;                           // Order type
            trReq.sl=lasttick.bid+TrailingStop*SymbolInfoDouble(smb,SYMBOL_POINT);
           }
         if(OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_BUY_LIMIT
            && ((OrderGetInteger(ORDER_MAGIC)%10)==0
            || (OrderGetDouble(ORDER_TP)<lasttick.ask)
            ))
           {
            trReq.price=lasttick.ask;                   // SymbolInfoDouble(NULL,SYMBOL_ASK);
            trReq.sl=lasttick.ask-TrailingStop*SymbolInfoDouble(smb,SYMBOL_POINT);
            trReq.type=ORDER_TYPE_BUY;              // Order type
           }
         // будем открываться...
         if(trReq.price>0)
           {
            trReq.action=TRADE_ACTION_DEAL;
            trReq.magic=OrderGetInteger(ORDER_MAGIC);
            trReq.symbol=OrderGetString(ORDER_SYMBOL);                 // Trade symbol
            trReq.volume=OrderGetDouble(ORDER_VOLUME_INITIAL);      // Requested volume for a deal in lots
            trReq.comment=OrderGetString(ORDER_COMMENT);
            trReq.deviation=3;                                    // Maximal possible deviation from the requested price
            trReq.tp=0;                                    // Maximal possible deviation from the requested price
            OrderSend(trReq,trRez);
            if(10009!=trRez.retcode) Print(__FUNCTION__," (open):",trRez.comment," ",smb," код ответа ",trRez.retcode," trReq.tp=",trReq.tp," trReq.sl=",trReq.sl," StopLevel=", SymbolInfoInteger(smb,SYMBOL_TRADE_STOPS_LEVEL));
            else
              {
               trReq.order=ticket;
               trReq.action=TRADE_ACTION_REMOVE;
               OrderSend(trReq,trRez);
               if(10009!=trRez.retcode) Print(__FUNCTION__," (open-remove):",trRez.comment," ",smb," код ответа ",trRez.retcode," trReq.tp=",trReq.tp," trReq.sl=",trReq.sl);
              }
           }
        }
     }
/// traling open           
   double newsl=0;
   for(i=0;i<PositionsTotal() && _TrailingPosition_;i++)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
     {
      smb=PositionGetSymbol(i);
      newsl=0;
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
      TrailingStop=(int)(_NumTS_*SymbolInfoInteger(smb,SYMBOL_TRADE_STOPS_LEVEL));
      if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL)
        {
         if(0==PositionGetDouble(POSITION_SL))
           {
            trReq.action=TRADE_ACTION_SLTP;
            trReq.sl=lasttick.ask+TrailingStop*SymbolInfoDouble(smb,SYMBOL_POINT);
            trReq.tp=0;
            OrderSend(trReq,BigDogModifResult);
           }
         else
           {
            newsl=lasttick.ask+1.2*TrailingStop*SymbolInfoDouble(smb,SYMBOL_POINT);
            if((PositionGetDouble(POSITION_SL)>newsl)&&((PositionGetDouble(POSITION_SL)-newsl)>SymbolInfoDouble(smb,SYMBOL_POINT)))
               {
               trReq.action=TRADE_ACTION_SLTP;
               trReq.sl=newsl;
               trReq.tp=0;
               OrderSend(trReq,BigDogModifResult);
              }
           }
        }
      else
        {
         if(0==PositionGetDouble(POSITION_SL))
           {
            trReq.action=TRADE_ACTION_SLTP;
            trReq.sl= lasttick.bid-TrailingStop*SymbolInfoDouble(smb,SYMBOL_POINT);
            trReq.tp=0;
            OrderSend(trReq,BigDogModifResult);
           }
         else
           {
            newsl=lasttick.bid-TrailingStop*SymbolInfoDouble(smb,SYMBOL_POINT);
            if((PositionGetDouble(POSITION_SL)<newsl)&&((newsl-PositionGetDouble(POSITION_SL))>SymbolInfoDouble(smb,SYMBOL_POINT)))
              {
               trReq.action=TRADE_ACTION_SLTP;
               trReq.sl= newsl;
               trReq.tp=0;
               OrderSend(trReq,BigDogModifResult);
              }
           }
        }
     }
//client.Disconnect();
   return(true);
  }
//+------------------------------------------------------------------+
bool ExportHistory(string fname,int from=0,int to=0)
  {
   HistorySelect(0,TimeCurrent());
   int deals=HistoryDealsTotal();
   ulong ticket;
   int FileHandle=FileOpen(fname,FILE_WRITE|FILE_ANSI|FILE_CSV,';');
   if(FileHandle!=INVALID_HANDLE)
     {
      for(int idt=0;idt<deals;idt++)
        {
         if((bool)(ticket=HistoryDealGetTicket(idt)))
           {
            FileWrite(FileHandle,HistoryDealGetString(ticket,DEAL_SYMBOL),HistoryDealGetDouble(ticket,DEAL_PROFIT));
           }
        }
      FileClose(FileHandle);
     }
   return(true);
  }
//+------------------------------------------------------------------+
