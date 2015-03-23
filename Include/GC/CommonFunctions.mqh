//+------------------------------------------------------------------+
//|                                              CommonFunctions.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
//#include <icq_mql5.mqh>
input bool __Debug__=true;//���������� ���������� ����������
bool _debug_time=false;
input bool _TrailingPosition_=true;//��������� ������� �� ��������
input bool _OpenNewPosition_=true;//��������� ������� � �����
input int _LostInWeekInPercent_=1;// ������������ ������� ������ �� ������
input int _Carefull_=0;//������� ����� �� ������. 0 = ����
input int _TREND_=30;// �� ������� �������� ������
input int _GetMaximum_=30;//������� ����� �� ������ ������. 0 = ����
input int _NumTS_=2;//������� ������� �� ��������
input int _NumTP_=4;// ������� ������������ �����
input int _Expiration_=5; // ������� ����� ����� ��������������� ����� 
input string spamfilename="notify.txt";
input double _Order_Volume_=0.1;// ����� ����
input int _Nax_lost_per_Mounth_Percent=10;// ������������ ������ � �����
int _Precision_=10;
datetime StartOpenPosition=0;
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
      //if(__Debug__) Print("New bar");
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
//|   ����� �� ����� - �������� �� ������� -�� ����������� ��������� ��� ��� ���� ����������  |
//+------------------------------------------------------------------+
bool NewOrder(string smb,double way,string comment,double price=0,int magic=777,datetime expiration=0)
  {
//  Print("New order double "+way);
   if(""==comment) comment=(string)way;
   if(0.66<way) return(NewOrder(smb,NewOrderBuy,"NO "+comment,price,magic,expiration));
// ���� �������� -������� ��� ������ 
   if(0.33<way) return(NewOrder(smb,NewOrderWaitBuy,"NO"+comment,price,magic,expiration));
   if(-0.66>way) return(NewOrder(smb,NewOrderSell,"NO"+comment,price,magic,expiration));
// ���� �������� -������� ��� ������ 
   if(-0.33>way) return(NewOrder(smb,NewOrderWaitSell,"NO"+comment,price,magic,expiration));
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
long WeekStartTime(datetime aTime,bool aStartsOnMonday=false)
  {
   long tmp=aTime;
   long Corrector;
   if(aStartsOnMonday)
     {
      Corrector=259200; // ������������ ���� ���� (86400*3)
     }
   else
     {
      Corrector=345600; // ������������ ������� ���� (86400*4)
     }
   tmp+=Corrector;
   tmp=(tmp/604800)*604800;
   tmp-=Corrector;
   return(tmp);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool NewOrder(string smb,NewOrder_Type type,string comment,double price=0,int magic=777,datetime expiration=0)
  {
   if(""==smb)
     {
      //      Print("empty symbol");
      return(false);
     }
   if(NewOrderWait==type || !_OpenNewPosition_||StartOpenPosition>TimeCurrent()) return(false);

// ��������� ��� ������ �� ���� ���� % ��� �� ������ ������  
   double curr_balance=AccountInfoDouble(ACCOUNT_BALANCE);
//---
   double result=0;//,profit=0,loss=0;
   ulong ticket=0;//,trades=0;
   datetime Start_Date=(datetime)WeekStartTime(TimeCurrent());
   HistorySelect(Start_Date,TimeCurrent());
   uint total=HistoryDealsTotal();
   for(uint i=0;i<total;i++)
     {
      if((bool)(ticket=HistoryDealGetTicket(i)))
//      if((ticket=HistoryDealGetTicket(i))>0)
        {
         if(HistoryDealGetInteger(ticket,DEAL_TYPE)!=DEAL_TYPE_BALANCE)
           {
            result+=HistoryDealGetDouble(ticket,DEAL_PROFIT);
           }
        }
     }
   if((-result)>(_LostInWeekInPercent_*curr_balance/100)&&expiration==0)
     {
      Print("in week, start "+(string)Start_Date+" lost "+DoubleToString(result)+" more then limit "+DoubleToString(_LostInWeekInPercent_*curr_balance/100));
      StartOpenPosition = Start_Date+24*7*3600;
      return(false);
     }

   string gvn="gc_NewOrder";
// check what run once
// if(TimeCurrent() > (GlobalVariableTime(gvn)+5)) GlobalVariableDel(gvn);
// double gvv;
// if(!GlobalVariableGet(gvn,gvv)) {GlobalVariableTemp(gvn); gvv=0;}
////  if(gvv>0) return(false);// startin
//  GlobalVariableSet(gvn,1);

   StringToUpper(smb);
   if(""==comment) comment=smb;
   ticket=0;
   int i;
// ���� �����-�� ���������� �����
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
// ���� �������� �������
   for(i=0;i<PositionsTotal();i++)
     {
      if(smb==PositionGetSymbol(i))
        {
         // ��������? ���������������� �����!
         if(type==NewOrderBuy && PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY) return(false);
         if(type==NewOrderWaitBuy && PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY) return(false);
         // ���������? ���������������� �����!
         if(type==NewOrderSell && PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL) return(false);
         if(type==NewOrderWaitSell && PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL) return(false);
         // ���� ������� ������� - � ������ ������ -����� ������� ������ ������!!
         ticket=PositionGetInteger(POSITION_IDENTIFIER);
         break;
        }
     }
// ���� ��� ������, � ���� ������ ������� -�� ������...
   if((0==ticket) && (type==NewOrderWaitBuy || type==NewOrderWaitSell)){  return(false);}
   MqlTick lasttick;
   if(!SymbolInfoTick(smb,lasttick)) { GlobalVariableSet(gvn,0); return(false);}
   if(0==expiration) expiration=TimeCurrent()+_Expiration_*PeriodSeconds(_Period);
   if(price==0)
     {
      if(ticket!=0)
        {// ���� �������� � ��� ������� �� ������ - ������ �� ���� � ��� �������� -���� �� �������
         magic=666;
         if(type==NewOrderBuy || type==NewOrderSell) magic=999; 
         if(type==NewOrderWaitBuy || type==NewOrderBuy)
           {
            if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL)
              {
               // ���� ������� ��� ���� -�� ���������� � ������
               //if(PositionGetDouble(POSITION_PROFIT)>1)
               //   price=PositionGetDouble(POSITION_PRICE_CURRENT)-SymbolInfoInteger(smb,SYMBOL_SPREAD)*SymbolInfoDouble(smb,SYMBOL_POINT)*1.1;
               //else// ����� ������ �� ��� �������
               price=PositionGetDouble(POSITION_PRICE_OPEN)-1.1*SymbolInfoInteger(smb,SYMBOL_SPREAD)*SymbolInfoDouble(smb,SYMBOL_POINT);//BufferC[1];
               if(price>(lasttick.ask+5*SymbolInfoDouble(smb,SYMBOL_POINT))) price=lasttick.ask+5*SymbolInfoDouble(smb,SYMBOL_POINT);
              }
            else return(false);
           }
         if(type==NewOrderWaitSell || type==NewOrderSell)
           {
            if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)
              {
               //// ���� ������� ��� ���� -�� ���������� � ������
               //if(PositionGetDouble(POSITION_PROFIT)>1)
               //   price=PositionGetDouble(POSITION_PRICE_CURRENT)+SymbolInfoInteger(smb,SYMBOL_SPREAD)*SymbolInfoDouble(smb,SYMBOL_POINT)*1.1;
               //else// ����� ������ �� ��� �������
               price=PositionGetDouble(POSITION_PRICE_OPEN)+1.1*SymbolInfoInteger(smb,SYMBOL_SPREAD)*SymbolInfoDouble(smb,SYMBOL_POINT);
               if(price<(lasttick.bid-5*SymbolInfoDouble(smb,SYMBOL_POINT))) price=lasttick.bid-5*SymbolInfoDouble(smb,SYMBOL_POINT);
              }
            else return(false);
           }
         expiration=0;         // ������� �� �������� - ���� ����� ����� ���� �� �������� �������� 
        }
      else
        {
         if(type==NewOrderBuy) price=lasttick.ask+5*SymbolInfoDouble(smb,SYMBOL_POINT);
         if(type==NewOrderWaitBuy) price=lasttick.ask+5*SymbolInfoDouble(smb,SYMBOL_POINT);
         if(type==NewOrderWaitSell) price=lasttick.bid-5*SymbolInfoDouble(smb,SYMBOL_POINT);
         if(type==NewOrderSell) price=lasttick.bid-5*SymbolInfoDouble(smb,SYMBOL_POINT);
        }
     }

   MqlTradeRequest trReq={0};
   MqlTradeResult trRez={0};
   trReq.action=TRADE_ACTION_PENDING;
   trReq.magic=magic;
   trReq.symbol=smb;                 // Trade symbol
   trReq.volume=_Order_Volume_;      // Requested volume for a deal in lots
   trReq.deviation=3;                                    // Maximal possible deviation from the requested price
   trReq.sl=0;//lasttick.bid + 1.5*TrailingStop*SymbolInfoDouble(smb,SYMBOL_POINT);
   trReq.tp=price;
   trReq.comment=comment+" "+(string)(lasttick.ask-lasttick.bid);
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

   else if(type==NewOrderSell || type==NewOrderWaitSell)
     {
      trReq.price=10000.00001;                             // SymbolInfoDouble(NULL,SYMBOL_ASK);
      trReq.type=ORDER_TYPE_SELL_LIMIT;
     }
//if(NewOrderWait==trReq.type) return (false);  
   if(!OrderSend(trReq,trRez))
      //  if(10009!=trRez.retcode)
      //    {
      Print(ResultRetcodeDescription(trRez.retcode));
//     Print(__FUNCTION__," : ",trRez.comment," ��� ������ ",trRez.retcode," trReq.price=",trReq.price," trReq.tp=",trReq.tp," trReq.sl=",trReq.sl," trReq.type=",trReq.type);
//     if(ORDER_TYPE_BUY_LIMIT==trReq.type) Print("ORDER_TYPE_BUY_LIMIT");
//    }
//   else
//     Print("New order failed  "+type+" = "+trReq.type); 
//  GlobalVariableSet(gvn,0);
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Order_Send(MqlTradeRequest &trReq,MqlTradeResult &trRez)
  {
//if(trReq.price==0) return(false);
   int Error=OrderSend(trReq,trRez);
   if(10009!=trRez.retcode) Fun_Error(trRez.retcode);

   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int DeleteOrder(ulong ticket)
  {
   MqlTradeRequest   trReq={0};
   MqlTradeResult    trRez={0};
   trReq.action      = TRADE_ACTION_REMOVE;
   trReq.order       = ticket;
   if(!Order_Send(trReq,trRez)){Print("Error delete! ticket="+(string)ticket);};
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
            datetime dt=(datetime)HistoryDealGetInteger(ticket,DEAL_TIME);
            ENUM_DEAL_TYPE deal_type=(ENUM_DEAL_TYPE)HistoryDealGetInteger(ticket,DEAL_TYPE);
            FileWrite(FileHandle,dt,HistoryDealGetString(ticket,DEAL_SYMBOL),deal_type,HistoryDealGetDouble(ticket,DEAL_PROFIT),HistoryDealGetString(ticket,DEAL_COMMENT));
           }
        }
      FileClose(FileHandle);
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ExportRates(string smb)
  {
   if(!isNewBar()) return(false);
   int FileHandle=FileOpen("statusbot\\"+smb+".csv",FILE_WRITE|FILE_ANSI|FILE_CSV,',');
   if(FileHandle!=INVALID_HANDLE)
     {
      //for(int idt=0;idt<deals;idt++)
      //  {
      //   if((bool)(ticket=HistoryDealGetTicket(idt)))
      //     {
      //      FileWrite(FileHandle,HistoryDealGetString(ticket,DEAL_SYMBOL),HistoryDealGetDouble(ticket,DEAL_PROFIT));
      //     }
      //  }
      FileClose(FileHandle);
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Trailing()
  {
   if(!_TrailingPosition_) return(false);
   string gvn="gc_Trailing";
// check what run once
   if(TimeCurrent()>(GlobalVariableTime(gvn)+5)) GlobalVariableDel(gvn);
   double gvv;
   if(!GlobalVariableGet(gvn,gvv)) {GlobalVariableTemp(gvn); gvv=0;}
   if(gvv>0) return(false);// startin
   GlobalVariableSet(gvn,1);

   int PosTotal=PositionsTotal();// �������� �������
   int OrdTotal=OrdersTotal();   // �������
   int i,TrailingStop;
   MqlTick lasttick;
   MqlTradeRequest BigDogModif={0};
   MqlTradeResult BigDogModifResult={0};
   double BufferO[],BufferC[],BufferL[],BufferH[];
   datetime dt[];
   ArraySetAsSeries(BufferO,true); ArraySetAsSeries(BufferC,true);
   ArraySetAsSeries(BufferL,true); ArraySetAsSeries(BufferH,true);
   ArraySetAsSeries(dt,true);
   int needcopy=5;
   string smb;
   MqlTradeRequest   trReq={0};
   MqlTradeResult    trRez={0};

   ENUM_TIMEFRAMES per=PERIOD_M1;
   ulong  ticket;
// ������� ���������� ������ ��� ������� �������  = ������, ���� ��� �������� ������� -����� � �����
   for(i=OrdTotal;i>0;i--)
     {
      ticket=OrderGetTicket(i-1);
      smb=OrderGetString(ORDER_SYMBOL);
      if(OrderGetInteger(ORDER_TIME_EXPIRATION)==0)// ������
        {
         if(!(PositionSelect(smb)
            || 
            (PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY && 
            OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_BUY_LIMIT) || 
            (PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL && 
            OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_SELL_LIMIT)))
            DeleteOrder(ticket);
        }
      else// ���������
        {
         if(PositionSelect(smb) && ((PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY && 
            OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_BUY_LIMIT)
            || (PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL && 
            OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_SELL_LIMIT)))
            DeleteOrder(ticket);
        }
     }
   OrdTotal=OrdersTotal();
// ��������� -����� �� ������� ����� �������, ��� ������� ������
   for(i=0;i<OrdTotal && _OpenNewPosition_;i++)
     {// ���� "������" � �������� ���������
      ticket=OrderGetTicket(i);
      smb=OrderGetString(ORDER_SYMBOL);
      ArrayInitialize(BufferC,0);ArrayInitialize(BufferO,0);
      ArrayInitialize(BufferL,0);ArrayInitialize(BufferH,0);
      // ������� �������
      if((CopyOpen(smb,per,0,needcopy,BufferO)==needcopy)
         && (CopyClose(smb,per,0,needcopy,BufferC)==needcopy)
         && (CopyLow(smb,per,0,needcopy,BufferL)==needcopy)
         && (CopyHigh(smb,per,0,needcopy,BufferH)==needcopy)
         && (CopyTime(smb,per,0,needcopy,dt)==needcopy)
         ); else { GlobalVariableSet(gvn,0); return(false);}
      SymbolInfoTick(smb,lasttick);
      TrailingStop=(int)(_NumTS_*SymbolInfoInteger(smb,SYMBOL_TRADE_STOPS_LEVEL));
      datetime OTE=(datetime)OrderGetInteger(ORDER_TIME_EXPIRATION);
      if(PositionSelect(smb))
        {// ���� ��������
        int v_rate=1;
        if(OrderGetInteger(ORDER_MAGIC)==999) v_rate=2; 
         if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)
           { // ������� ���� �� ����� �� ��������
            if(OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_SELL_LIMIT)
              {
               if(
                  (OrderGetDouble(ORDER_TP)>lasttick.bid && lasttick.bid>PositionGetDouble(POSITION_PRICE_OPEN)) // ����� ������ ��� ����� � ������ ��� ������
                  )
                 {// ����� �� ������� - ������ ���� ���������
                  trReq.action=TRADE_ACTION_DEAL;
                  //              trReq.magic=999;
                  trReq.symbol=smb;                 // Trade symbol
                  trReq.volume=PositionGetDouble(POSITION_VOLUME)*v_rate;      // Requested volume for a deal in lots
                  trReq.deviation=3;
                  trReq.price=lasttick.bid;
                  trReq.type=ORDER_TYPE_SELL;                           // Order type
                  trReq.sl=0;
                  trReq.tp=0;
                  trReq.comment=OrderGetString(ORDER_COMMENT);
                  Order_Send(trReq,trRez);
                  if(10009!=trRez.retcode) Print(__FUNCTION__," sell:",trRez.comment," ",smb," ��� ������ ",trRez.retcode," trReq.tp=",trReq.tp," trReq.sl=",trReq.sl);
                  else
                    {
                     DeleteOrder(ticket);
                    }
                 }
               else
                 { // ������� �� ������ ��� �� �������� -��������� ����� ��� ������� "�������"?
                  double newtp=lasttick.bid-1.5*SymbolInfoInteger(smb,SYMBOL_TRADE_STOPS_LEVEL)*SymbolInfoDouble(smb,SYMBOL_POINT);
                  if(OrderGetDouble(ORDER_TP)<newtp)
                    {
                     trReq.order=ticket;
                     trReq.sl=0;
                     trReq.tp=newtp;
                     trReq.price=OrderGetDouble(ORDER_PRICE_OPEN);
                     trReq.deviation=0;
                     trReq.type_time=ORDER_TIME_GTC;
                     trReq.action=TRADE_ACTION_MODIFY;
                     Order_Send(trReq,trRez);
                     //if(10009!=trRez.retcode) Print(__FUNCTION__," sell sl:",trRez.comment," ",smb," ��� ������",trRez.retcode," trReq.tp=",trReq.tp," trReq.sl=",trReq.sl);
                    }
                 }
              }
           }

         if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL)
           {//sell
            if(OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_BUY_LIMIT)
              {
               if(((OrderGetInteger(ORDER_MAGIC)%10)==0
                  || (OrderGetDouble(ORDER_TP)<lasttick.ask && lasttick.ask<PositionGetDouble(POSITION_PRICE_OPEN))
                  ))
                 {
                  trReq.action=TRADE_ACTION_DEAL;
                  //              trReq.magic=999;
                  trReq.symbol=smb;                 // Trade symbol
                  trReq.volume=PositionGetDouble(POSITION_VOLUME)*v_rate;   // Requested volume for a deal in lots
                  trReq.deviation=3;                     // Maximal possible deviation from the requested price
                  trReq.sl=0;//lasttick.ask+1.1*TrailingStop*SymbolInfoDouble(smb,SYMBOL_POINT);
                  trReq.tp=0;//lasttick.ask+1.1*TrailingStop*SymbolInfoDouble(smb,SYMBOL_POINT);
                  trReq.price=lasttick.ask;                   // SymbolInfoDouble(NULL,SYMBOL_ASK);
                  trReq.type=ORDER_TYPE_BUY;              // Order type
                  trReq.comment=OrderGetString(ORDER_COMMENT);
                  string comm=OrderGetString(ORDER_COMMENT);
                  Order_Send(trReq,trRez);
                  if(10009!=trRez.retcode) Print(__FUNCTION__," buy:",trRez.comment," ",smb," ��� ������ ",trRez.retcode," trReq.tp=",trReq.tp," trReq.sl=",trReq.sl);
                  else
                    {
                     DeleteOrder(ticket);
                    }
                  if(StringFind(comm,"NewOrder")==0){NewOrder(smb,NewOrderBuy,"");}
                 }
               else
                 { // ������� �� ������ ��� �� �������� -��������� ����� ��� ������� "�������"?
                  double newtp=lasttick.ask+1.5*SymbolInfoInteger(smb,SYMBOL_TRADE_STOPS_LEVEL)*SymbolInfoDouble(smb,SYMBOL_POINT);
                  if(OrderGetDouble(ORDER_TP)>newtp)
                    {
                     trReq.order=ticket;
                     trReq.sl=0;
                     trReq.tp=newtp;
                     trReq.price=OrderGetDouble(ORDER_PRICE_OPEN);
                     trReq.deviation=0;
                     trReq.type_time=ORDER_TIME_GTC;
                     trReq.action=TRADE_ACTION_MODIFY;
                     Order_Send(trReq,trRez);
                     if(10009!=trRez.retcode) Print(__FUNCTION__," buy sl:",trRez.comment," ",smb," ��� ������",trRez.retcode," trReq.tp=",trReq.tp," trReq.sl=",trReq.sl);
                    }
                 }
              }
           }
        }
      else if(OTE!=0)// �������� ���
        {
         ticket=OrderGetTicket(i);
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
                                                                  //trReq.sl=0;//lasttick.bid+TrailingStop*SymbolInfoDouble(smb,SYMBOL_POINT);
           }
         if(OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_BUY_LIMIT
            && ((OrderGetInteger(ORDER_MAGIC)%10)==0
            || (OrderGetDouble(ORDER_TP)<lasttick.ask)
            ))
           {
            trReq.price=lasttick.ask;                   // SymbolInfoDouble(NULL,SYMBOL_ASK);
                                                        //trReq.sl=0;//lasttick.ask-TrailingStop*SymbolInfoDouble(smb,SYMBOL_POINT);
            trReq.type=ORDER_TYPE_BUY;              // Order type
           }
         // ����� �����������...
         if(trReq.price>0)
           {
            trReq.action=TRADE_ACTION_DEAL;
            trReq.magic=OrderGetInteger(ORDER_MAGIC);
            trReq.symbol=OrderGetString(ORDER_SYMBOL);                 // Trade symbol
            trReq.volume=OrderGetDouble(ORDER_VOLUME_INITIAL);      // Requested volume for a deal in lots
            trReq.comment=OrderGetString(ORDER_COMMENT);
            trReq.deviation=3;                                    // Maximal possible deviation from the requested price
            trReq.tp=0;  trReq.sl=0;                                  // Maximal possible deviation from the requested price
            Order_Send(trReq,trRez);
            if(10009!=trRez.retcode) Print(__FUNCTION__," (open):",trRez.comment," ",smb," ��� ������ ",trRez.retcode," trReq.tp=",trReq.tp," trReq.sl=",trReq.sl," StopLevel=",SymbolInfoInteger(smb,SYMBOL_TRADE_STOPS_LEVEL));
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
      ticket=PositionGetInteger(POSITION_IDENTIFIER);
      newsl=0;
      // ������� �������
      if((CopyOpen(smb,per,0,needcopy,BufferO)==needcopy)
         && (CopyClose(smb,per,0,needcopy,BufferC)==needcopy)
         && (CopyLow(smb,per,0,needcopy,BufferL)==needcopy)
         && (CopyHigh(smb,per,0,needcopy,BufferH)==needcopy)
         && (CopyTime(smb,per,0,needcopy,dt)==needcopy)
         ){} else {GlobalVariableSet(gvn,0);return(false);}
      SymbolInfoTick(smb,lasttick);
      trReq.symbol=smb;
      trReq.deviation=3;
      trReq.order=ticket;
      TrailingStop=(int)(_NumTS_*SymbolInfoInteger(smb,SYMBOL_TRADE_STOPS_LEVEL));
      if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL)
        {
         if(0==PositionGetDouble(POSITION_SL) || 0==PositionGetDouble(POSITION_TP))
           {
            trReq.action=TRADE_ACTION_SLTP;
            trReq.sl=lasttick.ask+TrailingStop*SymbolInfoDouble(smb,SYMBOL_POINT);
            trReq.tp=lasttick.bid-3*TrailingStop*SymbolInfoDouble(smb,SYMBOL_POINT);;
            Order_Send(trReq,BigDogModifResult);
           }
         else
           {
            newsl=lasttick.ask+TrailingStop*SymbolInfoDouble(smb,SYMBOL_POINT);
            if((PositionGetDouble(POSITION_SL)>newsl) && ((PositionGetDouble(POSITION_SL)-newsl)>5*SymbolInfoDouble(smb,SYMBOL_POINT)))
              {
               trReq.action=TRADE_ACTION_SLTP;
               trReq.tp=PositionGetDouble(POSITION_TP)-(PositionGetDouble(POSITION_SL)-newsl);
               trReq.sl=newsl;
               Order_Send(trReq,BigDogModifResult);
              }
           }
         // ���� ����� ����� ������ -�� ������� �������� �����
         if(_Carefull_>0 && ((lasttick.bid<
            (PositionGetDouble(POSITION_PRICE_OPEN)-_NumTS_*SymbolInfoInteger(smb,SYMBOL_SPREAD)*SymbolInfoDouble(smb,SYMBOL_POINT)))
            || (PositionGetInteger(POSITION_TIME)<(TimeCurrent()-_Carefull_*60))))
           {
            NewOrder(smb,NewOrderBuy,"Panic");
           }
         // ���� ����� ����� ������ -�� ������� �������� �����
         if(_GetMaximum_>0 && ((lasttick.bid<
            (PositionGetDouble(POSITION_PRICE_OPEN)-3*_NumTS_*SymbolInfoInteger(smb,SYMBOL_SPREAD)*SymbolInfoDouble(smb,SYMBOL_POINT)))
            && (TimeCurrent()>(PositionGetInteger(POSITION_TIME)+_GetMaximum_*60))))
           {
            NewOrder(smb,NewOrderWaitBuy,"Slivki");
           }
        }
      else
        {
         if((0==PositionGetDouble(POSITION_SL)) || (0==PositionGetDouble(POSITION_TP)))
           {
            trReq.action=TRADE_ACTION_SLTP;
            trReq.sl= lasttick.bid-TrailingStop*SymbolInfoDouble(smb,SYMBOL_POINT);
            trReq.tp=lasttick.ask+3*TrailingStop*SymbolInfoDouble(smb,SYMBOL_POINT);
            Order_Send(trReq,BigDogModifResult);
           }
         else
           {
            newsl=lasttick.bid-TrailingStop*SymbolInfoDouble(smb,SYMBOL_POINT);
            if((PositionGetDouble(POSITION_SL)<newsl) && ((newsl-PositionGetDouble(POSITION_SL))>5*SymbolInfoDouble(smb,SYMBOL_POINT)))
              {
               trReq.action=TRADE_ACTION_SLTP;
               trReq.sl= newsl;
               trReq.tp=lasttick.ask+3*TrailingStop*SymbolInfoDouble(smb,SYMBOL_POINT);
               Order_Send(trReq,BigDogModifResult);
              }
           }
         // ���� ����� ����� ������ -�� ������� �������� �����
         if(_Carefull_>0 && ((lasttick.ask>
            (PositionGetDouble(POSITION_PRICE_OPEN)+2*_NumTS_*SymbolInfoInteger(smb,SYMBOL_SPREAD)*SymbolInfoDouble(smb,SYMBOL_POINT)))
            || (PositionGetInteger(POSITION_TIME)<(TimeCurrent()-_Carefull_*60))))
           {
            NewOrder(smb,NewOrderSell,"Panic");
           }
         // ���� ����� ����� ������ -�� ������� �������� �����
         if(_GetMaximum_>0 && ((lasttick.ask>
            (PositionGetDouble(POSITION_PRICE_OPEN)+2*_NumTS_*SymbolInfoInteger(smb,SYMBOL_SPREAD)*SymbolInfoDouble(smb,SYMBOL_POINT)))
            && (TimeCurrent()>(PositionGetInteger(POSITION_TIME)+_GetMaximum_*60))))
           {
            NewOrder(smb,NewOrderWaitSell,"Slivki");
           }
        }
     }
// ������� ���������� ������ "�� �������"
   OrdTotal=OrdersTotal();   // �������
   for(i=0;i<OrdTotal;i++)
     {
      ticket=OrderGetTicket(i);
      smb=OrderGetString(ORDER_SYMBOL);
      if(PositionSelect(smb)) continue;
      SymbolInfoTick(smb,lasttick);
      trReq.action=TRADE_ACTION_MODIFY;
      trReq.price=OrderGetDouble(ORDER_PRICE_OPEN);
      trReq.order=ticket;
      datetime expiration=(datetime)OrderGetInteger(ORDER_TIME_EXPIRATION);
      if(0==expiration)
        {
         expiration=TimeCurrent()+3*PeriodSeconds(_Period);
         trReq.expiration=expiration;
         trReq.type_time=ORDER_TIME_SPECIFIED;//(ENUM_ORDER_TYPE_TIME)OrderGetInteger(ORDER_TYPE_TIME);
         Order_Send(trReq,trRez);
        }
      trReq.type_time  = (ENUM_ORDER_TYPE_TIME)OrderGetInteger(ORDER_TYPE_TIME);
      trReq.expiration = expiration;
      trReq.sl=0;

      if(OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_BUY_LIMIT)
        {
         if(OrderGetInteger(ORDER_TIME_EXPIRATION)>0)
            trReq.tp=lasttick.ask+5*SymbolInfoDouble(smb,SYMBOL_POINT);
         else
            trReq.tp=lasttick.bid-_NumTS_*SymbolInfoInteger(smb,SYMBOL_SPREAD)*SymbolInfoDouble(smb,SYMBOL_POINT);
         if(OrderGetDouble(ORDER_TP)>trReq.tp)
           {
            Order_Send(trReq,trRez);
           }
        }
      if(OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_SELL_LIMIT)
        {
         if(OrderGetInteger(ORDER_TIME_EXPIRATION)>0)
            trReq.tp=lasttick.bid-5*SymbolInfoDouble(smb,SYMBOL_POINT);
         else
            trReq.tp=lasttick.ask+_NumTS_*SymbolInfoInteger(smb,SYMBOL_SPREAD)*SymbolInfoDouble(smb,SYMBOL_POINT);

         if(OrderGetDouble(ORDER_TP)<trReq.tp)
           {
            Order_Send(trReq,trRez);
           }
        }
     }
   GlobalVariableSet(gvn,0);
   return(true);
  }
//+------------------------------------------------------------------+
//| ������� ��������� ������                                         |
//+------------------------------------------------------------------+
int Fun_Error(int Error)
  {
   switch(Error)
     {
      case 10004: Print("�������");return(1);
      case 10006: Print("������ ���������");Sleep(3000);return(1);
      case 10007: Print("������ ������� ���������");return(0);
      case 10008: Print("����� ��������");return(2);
      case 10009: Print("������ ���������");return(2);
      case 10010: Print("������ ��������� ��������");return(2);
      case 10011: Print("������ ��������� �������");return(1);
      case 10012: Print("������ ������� �� ��������� �������");return(1);
      case 10013: Print("������������ ������");return(0);
      case 10014: Print("������������ ����� � �������");return(0);
      case 10015: Print("������������ ���� � �������");return(0);
      case 10016: Print("������������ ����� � �������");return(0);
      case 10017: Print("�������� ���������");return(0);
      case 10018: Print("����� ������");return(0);
      case 10019: Print("��� ����������� �������� ������� ��� ���������� �������");return(0);
      case 10020: Print("���� ����������");return(1);
      case 10021: Print("����������� ��������� ��� ��������� �������");Sleep(3000);return(1);
      case 10022: Print("�������� ���� ��������� ������ � �������");return(0);
      case 10023: Print("��������� ������ ����������");return(2);
      case 10024: Print("������� ������ �������");return(0);
      case 10025: Print("� ������� ��� ���������");Sleep(3000);return(1);
      case 10026: Print("������������ �������� ��������");return(0);
      case 10027: Print("������������ �������� ���������� ����������");return(0);
      case 10028: Print("������ ������������ ��� ���������");return(2);
      case 10029: Print("����� ��� ������� ����������");return(2);
      case 10030: Print("������ ���������������� ��� ���������� ������ �� �������");return(0);
      case 10031: Print("��� ���������� � �������� ��������");Sleep(3000);return(1);
      case 10032: Print("�������� ��������� ������ ��� �������� ������");return(0);
      case 10033: Print("��������� ����� �� ���������� ���������� �������");return(2);
      case 10034: Print("��������� ����� �� ����� ������� � ������� ��� ������� �������");return(2);

      // ����������
      case 4806: Print("����������� ������ �� �������");return(Error);
      default:    Print("������ � - ",Error);return(0);
     }
  }
//+------------------------------------------------------------------+

string TimeFrameName(ENUM_TIMEFRAMES tf)
  {
   switch(Period())
     {
      case PERIOD_M1: return("M1");
      case PERIOD_M20: return("M20");
      case PERIOD_M30: return("M30");
      case PERIOD_M4: return("M4");
      case PERIOD_M5: return("M5");
      case PERIOD_M6: return("M6");
      default:    return("");
     }
  }
//+------------------------------------------------------------------+

string ResultRetcodeDescription(int retcode)
  {
   string str;
//----
   switch(retcode)
     {
      case TRADE_RETCODE_REQUOTE: str="�������"; break;
      case TRADE_RETCODE_REJECT: str="������ ���������"; break;
      case TRADE_RETCODE_CANCEL: str="������ ������� ���������"; break;
      case TRADE_RETCODE_PLACED: str="����� ��������"; break;
      case TRADE_RETCODE_DONE: str="������ ���������"; break;
      case TRADE_RETCODE_DONE_PARTIAL: str="������ ��������� ��������"; break;
      case TRADE_RETCODE_ERROR: str="������ ��������� �������"; break;
      case TRADE_RETCODE_TIMEOUT: str="������ ������� �� ��������� �������";break;
      case TRADE_RETCODE_INVALID: str="������������ ������"; break;
      case TRADE_RETCODE_INVALID_VOLUME: str="������������ ����� � �������"; break;
      case TRADE_RETCODE_INVALID_PRICE: str="������������ ���� � �������"; break;
      case TRADE_RETCODE_INVALID_STOPS: str="������������ ����� � �������"; break;
      case TRADE_RETCODE_TRADE_DISABLED: str="�������� ���������"; break;
      case TRADE_RETCODE_MARKET_CLOSED: str="����� ������"; break;
      case TRADE_RETCODE_NO_MONEY: str="��� ����������� �������� ������� ��� ���������� �������"; break;
      case TRADE_RETCODE_PRICE_CHANGED: str="���� ����������"; break;
      case TRADE_RETCODE_PRICE_OFF: str="����������� ��������� ��� ��������� �������"; break;
      case TRADE_RETCODE_INVALID_EXPIRATION: str="�������� ���� ��������� ������ � �������"; break;
      case TRADE_RETCODE_ORDER_CHANGED: str="��������� ������ ����������"; break;
      case TRADE_RETCODE_TOO_MANY_REQUESTS: str="������� ������ �������"; break;
      case TRADE_RETCODE_NO_CHANGES: str="� ������� ��� ���������"; break;
      case TRADE_RETCODE_SERVER_DISABLES_AT: str="������������ �������� ��������"; break;
      case TRADE_RETCODE_CLIENT_DISABLES_AT: str="������������ �������� ���������� ����������"; break;
      case TRADE_RETCODE_LOCKED: str="������ ������������ ��� ���������"; break;
      case TRADE_RETCODE_FROZEN: str="����� ��� ������� ����������"; break;
      case TRADE_RETCODE_INVALID_FILL: str="������ ���������������� ��� ���������� ������ �� ������� "; break;
      case TRADE_RETCODE_CONNECTION: str="��� ���������� � �������� ��������"; break;
      case TRADE_RETCODE_ONLY_REAL: str="�������� ��������� ������ ��� �������� ������"; break;
      case TRADE_RETCODE_LIMIT_ORDERS: str="��������� ����� �� ���������� ���������� �������"; break;
      case TRADE_RETCODE_LIMIT_VOLUME: str="��������� ����� �� ����� ������� � ������� ��� ������� �������"; break;
      default: str="����������� ���������";
     }
//----
   return(str);
  }
//+------------------------------------------------------------------+
