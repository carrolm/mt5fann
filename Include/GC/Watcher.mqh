//+------------------------------------------------------------------+
//|                                                     Watcher.mqh |
//|                        Copyright 2011, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2011, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.000"
#include <gc\CommonFunctions.mqh>

input string statusfilename = "status.txt";
input string reportfilename = "report.txt";
input string commandsfilename="commands.txt";
//// autoconnect if exist MustWatcher\data\set_bot
//int filehandle=FileOpen("MustWatcher\data\set_bot",FILE_READ|FILE_CSV|FILE_ANSI,':',CP_ACP);
//if(filehandle!=INVALID_HANDLE)
//  {
//   login="645990858";
//   password="Forex7";
//   Connect();
//   FileClose(filehandle);
//  }

//+------------------------------------------------------------------+
//|   Открывает/закрывает позиции и двигает стоп-лосы. РАБОТАЕТ!!    |
//+------------------------------------------------------------------+
class CWatcher
  {
private:
public:
   int               pospast;
   string            expname;
   string            ar_sSPAM[];
   int               changing;
   string            ar_sSTATUScur[];
   string            ar_sSTATUSpast[];
   string            Abzac;
   double            curbalance;

public:
                     CWatcher(){Init();};
                    ~CWatcher();
   void              Init(void);
   bool              Trailing();
   bool              Notify();
   bool              SendNotify();
   bool              SendStatus();
   bool              SendReport();
   bool              ReadCommands();
   bool              AddNotify(string str);
   bool              Run();
   //  bool              OnTick();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CWatcher::Init()
  {
   expname="statusbot";
   pospast=0;
   ResetLastError();
   AddNotify("Starting watcher...");
   SendStatus();
   string filename=expname+"\\"+statusfilename;
   int    filehandle=FileOpen(filename,FILE_READ|FILE_TXT|FILE_ANSI,'\t',CP_ACP);
   if(filehandle!=INVALID_HANDLE)
     {
      if(FileSize(filehandle)<10)
        {
         FileClose(filehandle);
         return;
        }
      string statstr;

      statstr=FileReadString(filehandle);//StringToUpper(comstr);
      while(StringLen(statstr)>0)
        {
         AddNotify(statstr);
         statstr=FileReadString(filehandle);
        }

      SendNotify();
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CWatcher::~CWatcher()
  {
   AddNotify("Stop watcher...");
   SendNotify();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CWatcher::AddNotify(string str)
  {
   ArrayResize(ar_sSPAM,changing+1);
   ar_sSPAM[changing++]=str;//+ar_sSTATUScur[i];
                            //changing++;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CWatcher::Run(void)
  {
   ReadCommands();
   Trailing();
   Notify();
   SendNotify();
   SendStatus();
   SendReport();
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CWatcher::SendReport()
  {
   if(AccountInfoDouble(ACCOUNT_BALANCE)==curbalance) return(true);
//--- request trade history
   HistorySelect(0,TimeCurrent());
   if(HistoryDealsTotal()<=0) return(true);
   string report_buffer[];
//string report_buffer_sorted[];
   ArrayResize(report_buffer,HistoryDealsTotal());
   int report_size=0,dig;
   string rts="|";
   string opentime,type,size,item,openprice,loss_lim,profit_lim,closetime,closeprice,commision,swap,profit;
   double opendeallots = 0;
   double opendealcomm = 0;
//datetime opendealtime;
//string opendealtype;
   double opendealprice=0;
   uint     total=HistoryDealsTotal();
   ulong    ticket=0;
//--- for all deals
   for(uint i=0;i<total;i++)
     {
      if((bool)(ticket=HistoryDealGetTicket(i)))
        {
         if(HistoryDealGetInteger(ticket,DEAL_ENTRY)!=DEAL_ENTRY_OUT) continue;
         if(HistoryDealGetInteger(ticket,DEAL_TYPE)!=DEAL_TYPE_BUY && HistoryDealGetInteger(ticket,DEAL_TYPE)!=DEAL_TYPE_SELL) continue;
         if(HistoryDealGetInteger(ticket,DEAL_TYPE)==DEAL_TYPE_BUY) type="sell";
         if(HistoryDealGetInteger(ticket,DEAL_TYPE)==DEAL_TYPE_SELL)type="buy";
         item       = HistoryDealGetString(ticket,DEAL_SYMBOL);
         opentime   = TimeToString(HistoryDealGetInteger(ticket,DEAL_TIME),TIME_DATE|TIME_MINUTES);
         dig        = (int)SymbolInfoInteger(item,SYMBOL_DIGITS);
         openprice  = DoubleToString(HistoryDealGetDouble(ticket,DEAL_PRICE),dig);
         size       = DoubleToString(HistoryDealGetDouble(ticket,DEAL_VOLUME),2);
         loss_lim   = "";
         profit_lim = "";
         closetime  = TimeToString(HistoryDealGetInteger(ticket,DEAL_TIME),TIME_DATE|TIME_MINUTES);
         closeprice = DoubleToString(HistoryDealGetDouble(ticket,DEAL_PRICE),dig);
         commision  = DoubleToString(HistoryDealGetDouble(ticket,DEAL_COMMISSION),2);
         swap       = DoubleToString(HistoryDealGetDouble(ticket,DEAL_SWAP),2);
         profit     = DoubleToString(HistoryDealGetDouble(ticket,DEAL_PROFIT),2);

         report_buffer[report_size]=opentime+rts+type+rts+size+rts+item+rts+openprice+rts+loss_lim+rts+profit_lim+rts+closetime+rts+closeprice+rts+commision+rts+swap+rts+profit;
         report_size++;
         opendealprice=0;
         opendeallots=0;
         opendealcomm=0;
        }
     }
//--- если изменения есть то пишем файл report.txt
   ResetLastError();
   string filename=expname+"\\"+reportfilename;
   int filehandle=FileOpen(filename,FILE_WRITE|FILE_CSV|FILE_ANSI,rts,CP_ACP);
   if(filehandle!=INVALID_HANDLE)
     {
      for(int i=0;i<report_size;i++)
        {
         FileWrite(filehandle,"@",report_buffer[i]);
        }
      FileWrite(filehandle,"#",DoubleToString(AccountInfoDouble(ACCOUNT_BALANCE),2),AccountInfoString(ACCOUNT_CURRENCY));
      FileClose(filehandle);
     }
   else Print("Не удалось открыть файл ",reportfilename,", ошибка",GetLastError());
   return(true);
//---
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CWatcher::SendStatus()
  {
   double sumprofit=AccountInfoDouble(ACCOUNT_PROFIT);
   double balance  =AccountInfoDouble(ACCOUNT_BALANCE);
   double equity   =AccountInfoDouble(ACCOUNT_EQUITY);
   string symset,order_type;
   int    tp,sl;
   double vol,open,profit;
//--- пишем инфу в status.txt 
   ArrayResize(ar_sSTATUScur,PositionsTotal());
   ResetLastError();
   string filename=expname+"\\"+statusfilename;
   int    filehandle=FileOpen(filename,FILE_WRITE|FILE_TXT|FILE_ANSI,'\t',CP_ACP);
   FileWrite(filehandle,"Balance = "+DoubleToString(balance,2)+" "+AccountInfoString(ACCOUNT_CURRENCY));
   for(int i=0;i<PositionsTotal() && filehandle!=INVALID_HANDLE;i++)
     {
      if(i==0)FileWrite(filehandle,Abzac);
      PositionGetSymbol(i);
      if(PositionGetInteger(POSITION_TYPE)==ORDER_TYPE_BUY) order_type="buy";
      if(PositionGetInteger(POSITION_TYPE)==ORDER_TYPE_SELL)order_type="sell";
      sl    =(int)PositionGetDouble(POSITION_SL);
      tp    =(int)PositionGetDouble(POSITION_TP);
      vol   =PositionGetDouble(POSITION_VOLUME);
      open  =PositionGetDouble(POSITION_PRICE_OPEN);
      profit=PositionGetDouble(POSITION_PROFIT);
      symset=PositionGetSymbol(i)+"  "+order_type+" "+DoubleToString(vol,2)+"  "+DoubleToString(profit,2)+" "+AccountInfoString(ACCOUNT_CURRENCY);
      FileWrite(filehandle,symset);
      ar_sSTATUScur[i]=symset;
      if(i==PositionsTotal()-1)
        {
         FileWrite(filehandle,"summa = "+DoubleToString(sumprofit,2)+" "+AccountInfoString(ACCOUNT_CURRENCY));
         FileWrite(filehandle,Abzac);
         FileWrite(filehandle,"Equity = "+DoubleToString(equity,2)+" "+AccountInfoString(ACCOUNT_CURRENCY));
        }
     }
   FileClose(filehandle);
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CWatcher::Notify()
  {
   bool ret=true;
   if(pospast==0 && PositionsTotal()==0) return(true);
//--- ищем изменения в позициях
//ArrayResize(ar_sSPAM,PositionsTotal()+pospast+changing);
   int j;
//changing=0;
   for(int i=0;i<PositionsTotal();i++)
     {
      for(j=0;j<pospast;j++) {if(StringSubstr(ar_sSTATUScur[i],0,6)==StringSubstr(ar_sSTATUSpast[j],0,6))break;}
      if(j==pospast)
        {
         //         ar_sSPAM[changing]="[position added] "+ar_sSTATUScur[i];
         AddNotify("[position open] ");//+ar_sSTATUScur[i];
                                       //changing++;
        }
     }
   for(int i=0;i<pospast;i++)
     {
      for(j=0;j<PositionsTotal();j++){if(StringSubstr(ar_sSTATUScur[j],0,6)==StringSubstr(ar_sSTATUSpast[i],0,6))break;}
      if(j==PositionsTotal())
        {
         AddNotify("[position closed] "+ar_sSTATUSpast[i]);
         //changing++;
        }
     }
//---
   ArrayResize(ar_sSTATUSpast,ArraySize(ar_sSTATUScur));
   if(ArraySize(ar_sSTATUScur)>0) ArrayCopy(ar_sSTATUSpast,ar_sSTATUScur,0,0,WHOLE_ARRAY);
   pospast=PositionsTotal();
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool   CWatcher::SendNotify()
  {
   bool ret=true;
   if(changing==0) return(true);
//--- если изменения есть то пишем файл notify.txt
   ResetLastError();
   string filename=expname+"\\"+spamfilename;
   int filehandle=FileOpen(filename,FILE_WRITE|FILE_TXT|FILE_ANSI,'\t',CP_ACP);
   if(filehandle!=INVALID_HANDLE)
     {
      for(int i=0;i<changing;i++)
        {FileWrite(filehandle,ar_sSPAM[i]);}
      FileClose(filehandle);
     }
   else Print("Не удалось открыть файл ",spamfilename,", ошибка",GetLastError());
   changing=0;

   return(true);
  }//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CWatcher::Trailing()
  {
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
// Удаляем отложенные ордера без предела времени -паника, если нет открытых позиций -мусор в общем
   for(i=0;i<OrdTotal && _OpenNewPosition_;i++)
     {
      ticket=OrderGetTicket(i);
      smb=OrderGetString(ORDER_SYMBOL);
      if((OrderGetInteger(ORDER_TIME_EXPIRATION)==0)
         || (PositionSelect(smb) && ((PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY && 
         OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_BUY_LIMIT) || 
         (PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL && 
         OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_SELL_LIMIT))))
        {
         DeleteOrder(ticket);
        }
     }
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
                  trReq.price=10000.00001;                             // SymbolInfoDouble(NULL,SYMBOL_ASK);
                  trReq.sl=OrderGetDouble(ORDER_SL);
                  trReq.magic=OrderGetInteger(ORDER_MAGIC);
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
            DeleteOrder(ticket);
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
            if(10009!=trRez.retcode) Print(__FUNCTION__," (open):",trRez.comment," ",smb," код ответа ",trRez.retcode," trReq.tp=",trReq.tp," trReq.sl=",trReq.sl," StopLevel=",SymbolInfoInteger(smb,SYMBOL_TRADE_STOPS_LEVEL));
            else
              {
               DeleteOrder(ticket);
              }
           }
        }
     }
/// traling open           
   double newsl=0;
   for(i=0;i<PositionsTotal() && _TrailingPosition_;i++)
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
            if((PositionGetDouble(POSITION_SL)>newsl) && ((PositionGetDouble(POSITION_SL)-newsl)>SymbolInfoDouble(smb,SYMBOL_POINT)))
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
            if((PositionGetDouble(POSITION_SL)<newsl) && ((newsl-PositionGetDouble(POSITION_SL))>SymbolInfoDouble(smb,SYMBOL_POINT)))
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
bool CWatcher::ReadCommands()
  {
//commandsfilename
   string filename=expname+"\\"+commandsfilename,comstr,oper,smb,rc;
   int filehandle=FileOpen(filename,FILE_READ|FILE_CSV|FILE_ANSI,' ',CP_ACP);
   if(filehandle!=INVALID_HANDLE)
     {
      if(FileSize(filehandle)<10)
        {
         //Print("Open  command ",filename);
         FileClose(filehandle);
         return(true);
        }

      //Print("Open  command ",filename);
      rc="";
      comstr=FileReadString(filehandle);//StringToUpper(comstr);
      rc+=StringSubstr(comstr,1+StringFind(comstr,";"));
      if(0==StringCompare(comstr,"TRADE;sell",false))
        {
         //oper=FileReadString(filehandle);
         smb=FileReadString(filehandle);
         rc+=" "+smb;
         NewOrder(smb,NewOrderSell,"icq");
        }
      else if(0==StringCompare(comstr,"TRADE;buy",false))
        {
         //oper=FileReadString(filehandle);
         smb=FileReadString(filehandle);
         rc+=" "+smb;
         NewOrder(smb,NewOrderBuy,"icq");
        }
      else
        {
         smb=FileReadString(filehandle);
         rc+=" "+smb;
        }
      FileClose(filehandle);
      //Print(RemoteControl.Run("",rc));
      filehandle=FileOpen(filename,FILE_WRITE|FILE_TXT|FILE_ANSI,';',CP_ACP);
      FileClose(filehandle);
     }
//else Print("Не удалось открыть файл ",spamfilename,", ошибка",GetLastError());
   return(true);
  }
//+------------------------------------------------------------------+
