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
input string spamfilename   = "notify.txt";
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
   if((0==ticket) && (type==NewOrderWaitBuy || type==NewOrderWaitSell))return(false);
   MqlTick lasttick;
   if(!SymbolInfoTick(smb,lasttick)) return(false);;
   if(0==expiration) expiration=TimeCurrent()+3*PeriodSeconds(_Period);
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
               //if(PositionGetDouble(POSITION_PROFIT)>1)
               //   price=PositionGetDouble(POSITION_PRICE_CURRENT)-SymbolInfoInteger(smb,SYMBOL_SPREAD)*SymbolInfoDouble(smb,SYMBOL_POINT)*1.1;
               //else// иначе ставим на мин прибыль
               price=PositionGetDouble(POSITION_PRICE_OPEN)-1.5*SymbolInfoInteger(smb,SYMBOL_SPREAD)*SymbolInfoDouble(smb,SYMBOL_POINT);//BufferC[1];
              }
            else return(false);
           }
         if(type==NewOrderWaitSell || type==NewOrderSell)
           {
            if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)
              {
               //// если прибыль уже есть -то приближаем к идеалу
               //if(PositionGetDouble(POSITION_PROFIT)>1)
               //   price=PositionGetDouble(POSITION_PRICE_CURRENT)+SymbolInfoInteger(smb,SYMBOL_SPREAD)*SymbolInfoDouble(smb,SYMBOL_POINT)*1.1;
               //else// иначе ставим на мин прибыль
               price=PositionGetDouble(POSITION_PRICE_OPEN)+1.5*SymbolInfoInteger(smb,SYMBOL_SPREAD)*SymbolInfoDouble(smb,SYMBOL_POINT);
              }
            else return(false);
           }
         expiration=0;         // трекинг на закрытие - этот одрер будет жить до закрытия открытой 
        }
      else
        {
         if(type==NewOrderBuy) price=lasttick.ask+5*SymbolInfoDouble(smb,SYMBOL_POINT);
         if(type==NewOrderWaitBuy) price=lasttick.ask+5*SymbolInfoDouble(smb,SYMBOL_POINT);
         if(type==NewOrderWaitSell) price=lasttick.bid-5*SymbolInfoDouble(smb,SYMBOL_POINT);
         if(type==NewOrderSell) price=lasttick.bid-5*SymbolInfoDouble(smb,SYMBOL_POINT);
        }
     }

   MqlTradeRequest trReq;
   MqlTradeResult trRez;
   trReq.action=TRADE_ACTION_PENDING;
   trReq.magic=magic;
   trReq.symbol=smb;                 // Trade symbol
   trReq.volume=0.1;      // Requested volume for a deal in lots
   trReq.deviation=3;                                    // Maximal possible deviation from the requested price
   trReq.sl=0;//lasttick.bid + 1.5*TrailingStop*SymbolInfoDouble(smb,SYMBOL_POINT);
   trReq.tp=price;
   trReq.comment=comment;
   trReq.expiration=expiration;
   if(expiration==0)
      trReq.type_time=ORDER_TIME_GTC;
   else
      trReq.type_time=ORDER_TIME_SPECIFIED;

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
//|                                                                  |
//+------------------------------------------------------------------+
int DeleteOrder(ulong ticket)
  {
   MqlTradeRequest   trReq;
   MqlTradeResult    trRez;
   trReq.action    =TRADE_ACTION_REMOVE;
   trReq.order     =ticket;
   if(!OrderSend(trReq,trRez)){};
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
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
//| Функция обработки ошибок                                         |
//+------------------------------------------------------------------+
int Fun_Error(int Error)
  {
   switch(Error)
     {
      case 10004: Alert("Реквота");return(1);
      case 10006: Alert("Запрос отвергнут");Sleep(3000);return(1);
      case 10007: Alert("Запрос отменен трейдером");return(0);
      case 10008: Alert("Ордер размещен");return(2);
      case 10009: Alert("Заявка выполнена");return(2);
      case 10010: Alert("Заявка выполнена частично");return(2);
      case 10011: Alert("Ошибка обработки запроса");return(1);
      case 10012: Alert("Запрос отменен по истечению времени");return(1);
      case 10013: Alert("Неправильный запрос");return(0);
      case 10014: Alert("Неправильный объем в запросе");return(0);
      case 10015: Alert("Неправильная цена в запросе");return(0);
      case 10016: Alert("Неправильные стопы в запросе");return(0);
      case 10017: Alert("Торговля запрещена");return(0);
      case 10018: Alert("Рынок закрыт");return(0);
      case 10019: Alert("Нет достаточных денежных средств для выполнения запроса");return(0);
      case 10020: Alert("Цены изменились");return(1);
      case 10021: Alert("Отсутствуют котировки для обработки запроса");Sleep(3000);return(1);
      case 10022: Alert("Неверная дата истечения ордера в запросе");return(0);
      case 10023: Alert("Состояние ордера изменилось");return(2);
      case 10024: Alert("Слишком частые запросы");return(0);
      case 10025: Alert("В запросе нет изменений");Sleep(3000);return(1);
      case 10026: Alert("Автотрейдинг запрещен сервером");return(0);
      case 10027: Alert("Автотрейдинг запрещен клиентским терминалом");return(0);
      case 10028: Alert("Запрос заблокирован для обработки");return(2);
      case 10029: Alert("Ордер или позиция заморожены");return(2);
      case 10030: Alert("Указан неподдерживаемый тип исполнения ордера по остатку");return(0);
      case 10031: Alert("Нет соединения с торговым сервером");Sleep(3000);return(1);
      case 10032: Alert("Операция разрешена только для реальных счетов");return(0);
      case 10033: Alert("Достигнут лимит на количество отложенных ордеров");return(2);
      case 10034: Alert("Достигнут лимит на объем ордеров и позиций для данного символа");return(2);
      default:    Alert("Ошибка № - ",Error);return(0);
     }
  }
//+------------------------------------------------------------------+
