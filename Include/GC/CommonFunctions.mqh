//+------------------------------------------------------------------+
//|                                              CommonFunctions.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
//#include <icq_mql5.mqh>
input bool _ShowInAllChart_=true;//Show info on all charts Показать данные на всех окнах
input bool __Debug__=true;//Enable debug Показывать отладочную информацию
bool _debug_time=false;
input bool _IamChicken_=false; // I am chicken If openprofit >0 then sl move
input bool _TrailingPosition_=true;//Enable trailing Разрешить следить за ордерами
input bool _OpenNewPosition_=true;//Enable open new position Разрешить входить в рынок
input int _Max_lost_per_Mounth_Percent=10;// Max lost per mounth Максимальные потери в месяц
input int _Max_lost_per_Week_Percent=5;// Max lost in week Максимальный процент потерь за неделю
input int _Max_lost_per_Day_Percent=1;// Max lost in day Максимальный процент потерь за день
input int _Carefull_=20;//How minutes for panic 0=off Сколько минут до паники. 0 = выкл
input int _LovelyProfit_=50;//How money for good order 0=off Сколько денег для хорошей сделки. 0 = выкл
input int _GetMaximum_=30;//How minutes for get profit 0=off Сколько минут до снятия сливок. 0 = выкл
input int _NumTS_=9;// How spreads for stoploss Сколько спредов до стоплоса
input int _NumTP_=10;// How spreads for takeprofit сколько тейкпрофитов берем
input int _Expiration_=5; // How minutes live preorder сколько минут живет предварительный ордер 
input double _Order_Volume_=0.1;// Order volume Объем лота

input int FontSize=10;
input color Bg_Color=Gray;
input color Btn_Color=Gold;

input int _TREND_=30;// на сколько смотреть вперед
input int _NEDATA_=10000;// How deep bars history for export cколько выгрузить
input int _ShiftNEDATA_=0000;// How shift for start export cколько выгрузить
input int _Precision_=10; // Precissin data
input int _deviation_= 5; // Deviation 

input string spamfilename="notify.txt";

datetime StartOpenPosition=0;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool isNewBar(string smbl="",ENUM_TIMEFRAMES tf=0)
  {
   static MqlDateTime  prevT;
   MqlDateTime curT;
   bool result=false;
   if(""==smbl)smbl=_Symbol;
   datetime lastbarTime=(datetime)SeriesInfoInteger(smbl,tf,SERIES_LASTBAR_DATE);
//if(lastTime==0 || lastTime!=lastbarTime)
//  {
//   lastTime=lastbarTime;
//   return(true);
//  }
   if(tf==0) tf=Period();
   TimeToStruct(lastbarTime,curT);
   if(tf==PERIOD_M1||
      tf==PERIOD_M2||
      tf==PERIOD_M3||
      tf==PERIOD_M4||
      tf==PERIOD_M5||
      tf==PERIOD_M6||
      tf==PERIOD_M10||
      tf==PERIOD_M12||
      tf==PERIOD_M15||
      tf==PERIOD_M20||
      tf==PERIOD_M30)
      if(curT.min!=prevT.min)
        {
         result=true;
        };
   if(tf==PERIOD_H1||
      tf==PERIOD_H2||
      tf==PERIOD_H3||
      tf==PERIOD_H4||
      tf==PERIOD_H6||
      tf==PERIOD_H8||
      tf==PERIOD_M12)
      if(curT.hour!=prevT.hour)
        {
         result=true;
        };
   if(tf==PERIOD_D1||
      tf==PERIOD_W1)
      if(curT.day!=prevT.day)
        {
         result=true;
        };
   if(tf==PERIOD_MN1)
      if(curT.mon!=prevT.mon)
        {
         result=true;
        };

   TimeToStruct(lastbarTime,prevT);
   return(result);
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
//  Print("New order double "+way);
   if(""==comment) comment=(string)way;
   if(0.66<way) return(NewOrder(smb,NewOrderBuy,"NO "+comment,price,magic,expiration));
// пока выключим -кажется что глючит 
   if(0.33<way) return(NewOrder(smb,NewOrderWaitBuy,"NO "+comment,price,magic,expiration));
   if(-0.66>way) return(NewOrder(smb,NewOrderSell,"NO "+comment,price,magic,expiration));
// пока выключим -кажется что глючит 
   if(-0.33>way) return(NewOrder(smb,NewOrderWaitSell,"NO "+comment,price,magic,expiration));
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
      Corrector=259200; // длительность трех дней (86400*3)
     }
   else
     {
      Corrector=345600; // длительность четырех дней (86400*4)
     }
   tmp+=Corrector;
   tmp=(tmp/604800)*604800;
   tmp-=Corrector;
   return(tmp);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool RefreshView(void)
  {
   if(!_ShowInAllChart_&&false==MQLInfoInteger(MQL_TESTER)&&false== MQLInfoInteger(MQL_OPTIMIZATION)&&false==  MQLInfoInteger(MQL_PROFILER)) return false;
//if(_Wather_) Watcher.Run();
//Trailing();
   string prefix="GC_";
   string name; //int SymbolIdx,RowPos;
   double BufferO[],BufferC[],BufferL[],BufferH[];
   ArraySetAsSeries(BufferO,true); ArraySetAsSeries(BufferC,true);
   ArraySetAsSeries(BufferL,true); ArraySetAsSeries(BufferH,true);
   int window=0;//ChartWindowOnDropped();
                //if(window==0 && ChartGetInteger(0,CHART_WINDOWS_TOTAL)>1) window=1;
   int i;//,ColPos;
         //ulong ticket;
   double   profit;
   long currChart,prevChart=0;//ChartFirst();
   int limit=10;i=0;
//   double result=0;//,profit=0,loss=0;
   ulong ticket=0;//,trades=0; 
   MqlDateTime str_timeCurrent;
   datetime Start_Date;
   uint total;
//Print("ChartFirst =",ChartSymbol(prevChart)," ID =",prevChart);
//MqlDateTime str1,str2;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   bool OpenPos=false;
   while(i<limit)// у нас наверняка не больше 10 открытых графиков
     {
      currChart=ChartNext(prevChart); // на основании предыдущего получим новый график
      if(currChart<0) break;          // достигли конца списка графиков
                                      //       if(_Symbol!=ChartSymbol(currChart)|!ShowDashBoard)
      //        ChartSetInteger(currChart,CHART_SHIFT,true);
      ChartSetInteger(currChart,CHART_SHOW_ASK_LINE,true);
      ChartSetInteger(currChart,CHART_SHOW_BID_LINE,true);
      //        ChartSetInteger(currChart,CHART_SHOW_VOLUMES,CHART_VOLUME_TICK);
      //        ChartSetDouble(currChart,CHART_SHIFT_SIZE,10);
      OpenPos=false;
      // выведем спред на график
      name=prefix+"chart_SI";
      if(ObjectFind(currChart,name)==-1)
        {
         ObjectCreate(currChart,name,OBJ_LABEL,window,0,0);
         ObjectSetInteger(currChart,name,OBJPROP_XDISTANCE,FontSize*30);
         ObjectSetInteger(currChart,name,OBJPROP_YDISTANCE,FontSize*3);
         ObjectSetInteger(currChart,name,OBJPROP_XSIZE,FontSize*5);
         ObjectSetInteger(currChart,name,OBJPROP_YSIZE,FontSize*1);
         ObjectSetInteger(currChart,name,OBJPROP_FONTSIZE,FontSize*1);
         ObjectSetInteger(currChart,name,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
        }
      profit=0;
      if(PositionSelect(ChartSymbol(currChart)))
        {
         profit=PositionGetDouble(POSITION_PROFIT);
         OpenPos=true;
         name=prefix+"chart_pos_"+ChartSymbol(currChart);ObjectDelete(currChart,name);
         if(profit>0) ObjectCreate(currChart,name,OBJ_ARROW_THUMB_UP,0,PositionGetInteger(POSITION_TIME),PositionGetDouble(POSITION_PRICE_OPEN));
         else ObjectCreate(currChart,name,OBJ_ARROW_THUMB_DOWN,0,PositionGetInteger(POSITION_TIME),PositionGetDouble(POSITION_PRICE_OPEN));
        }
      else ObjectDelete(currChart,prefix+"closepos_"+ChartSymbol(currChart));

      if(0==profit)
        {
         ObjectSetInteger(currChart,prefix+"chart_SI",OBJPROP_COLOR,Bg_Color);
         ObjectSetString(currChart,prefix+"chart_SI",OBJPROP_TEXT,"Spread="+(string)SymbolInfoInteger(ChartSymbol(currChart),SYMBOL_SPREAD));
        }
      else
        {
         ObjectSetString(currChart,prefix+"chart_SI",OBJPROP_TEXT,"Current ="+(string)((int)profit));
         if(0>profit) ObjectSetInteger(currChart,prefix+"chart_SI",OBJPROP_COLOR,Red);
         else ObjectSetInteger(currChart,prefix+"chart_SI",OBJPROP_COLOR,0x008000);
        }

      TimeToStruct(TimeCurrent(),str_timeCurrent);
      str_timeCurrent.hour=0;
      str_timeCurrent.min=0;
      str_timeCurrent.sec=0;
      Start_Date=StructToTime(str_timeCurrent);
      HistorySelect(Start_Date,TimeCurrent());
      HistorySelect(Start_Date,TimeCurrent());

      TimeToStruct(TimeCurrent(),str_timeCurrent);

      total=HistoryDealsTotal();
      profit=0;
      for(uint ihd=0;ihd<total;ihd++)
         //+------------------------------------------------------------------+
         //|                                                                  |
         //+------------------------------------------------------------------+
        {
         if((bool)(ticket=HistoryDealGetTicket(ihd)))
            //      if((ticket=HistoryDealGetTicket(i))>0)
           {
            if(HistoryDealGetInteger(ticket,DEAL_TYPE)!=DEAL_TYPE_BALANCE && HistoryDealGetString(ticket,DEAL_SYMBOL)==ChartSymbol(currChart))
              {
               profit+=HistoryDealGetDouble(ticket,DEAL_PROFIT);
              }
           }
        }
      name=prefix+"chart_DP";
      if(ObjectFind(currChart,name)==-1)
        {
         ObjectCreate(currChart,name,OBJ_LABEL,window,0,0);
         ObjectSetInteger(currChart,name,OBJPROP_XDISTANCE,FontSize*30);
         ObjectSetInteger(currChart,name,OBJPROP_YDISTANCE,FontSize*5);
         ObjectSetInteger(currChart,name,OBJPROP_XSIZE,FontSize*5);
         ObjectSetInteger(currChart,name,OBJPROP_YSIZE,FontSize*1);
         ObjectSetInteger(currChart,name,OBJPROP_FONTSIZE,FontSize*1);
         ObjectSetInteger(currChart,name,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
        }
      if(0==profit)
        {
         ObjectSetInteger(currChart,name,OBJPROP_COLOR,Bg_Color);
        }
      else
        {
         if(0>profit) ObjectSetInteger(currChart,name,OBJPROP_COLOR,Red);
         else ObjectSetInteger(currChart,name,OBJPROP_COLOR,Green);
        }
      ObjectSetString(currChart,name,OBJPROP_TEXT,"In day  ="+(string)((int)profit));

      Start_Date=(datetime)WeekStartTime(TimeCurrent());
      HistorySelect(Start_Date,TimeCurrent());

      TimeToStruct(TimeCurrent(),str_timeCurrent);

      total=HistoryDealsTotal();
      profit=0;
      for(uint ihd=0;ihd<total;ihd++)
         //+------------------------------------------------------------------+
         //|                                                                  |
         //+------------------------------------------------------------------+
        {
         if((bool)(ticket=HistoryDealGetTicket(ihd)))
            //      if((ticket=HistoryDealGetTicket(i))>0)
           {
            if(HistoryDealGetInteger(ticket,DEAL_TYPE)!=DEAL_TYPE_BALANCE && HistoryDealGetString(ticket,DEAL_SYMBOL)==ChartSymbol(currChart))
              {
               profit+=HistoryDealGetDouble(ticket,DEAL_PROFIT);
              }
           }
        }
      name=prefix+"chart_WP";
      if(ObjectFind(currChart,name)==-1)
        {
         ObjectCreate(currChart,name,OBJ_LABEL,window,0,0);
         ObjectSetInteger(currChart,name,OBJPROP_XDISTANCE,FontSize*30);
         ObjectSetInteger(currChart,name,OBJPROP_YDISTANCE,FontSize*7);
         ObjectSetInteger(currChart,name,OBJPROP_XSIZE,FontSize*5);
         ObjectSetInteger(currChart,name,OBJPROP_YSIZE,FontSize*1);
         ObjectSetInteger(currChart,name,OBJPROP_FONTSIZE,FontSize*1);
         ObjectSetInteger(currChart,name,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
        }
      if(0==profit)
        {
         ObjectSetInteger(currChart,name,OBJPROP_COLOR,Bg_Color);
        }
      else
        {
         if(0>profit) ObjectSetInteger(currChart,name,OBJPROP_COLOR,Red);
         else ObjectSetInteger(currChart,name,OBJPROP_COLOR,Green);
        }
      ObjectSetString(currChart,name,OBJPROP_TEXT,"In week="+(string)((int)profit));
      if(_OpenNewPosition_) 
        {
         name=prefix+"_buy_in_chart";
         if(ObjectFind(currChart,name)==-1)
           {
            ObjectCreate(currChart,name,OBJ_BUTTON,window,0,0);
            ObjectSetInteger(currChart,name,OBJPROP_XDISTANCE,FontSize*15);
            ObjectSetInteger(currChart,name,OBJPROP_YDISTANCE,FontSize*3);
            ObjectSetInteger(currChart,name,OBJPROP_XSIZE,FontSize*10);
            ObjectSetInteger(currChart,name,OBJPROP_YSIZE,FontSize*2);
            ObjectSetInteger(currChart,name,OBJPROP_SELECTABLE,0);
            ObjectSetInteger(currChart,name,OBJPROP_FONTSIZE,FontSize);
            ObjectSetInteger(currChart,name,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
            

           }
             ObjectSetString(currChart,name,OBJPROP_TEXT,(OpenPos&&PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL)?"CloseSell":"Buy");   
                  if(ObjectGetInteger(currChart,name,OBJPROP_STATE))
           {
            Print("Buy "+ChartSymbol(currChart));//if(_Symbol!=SymbolsArray[SymbolIdx])ChartSetSymbolPeriod(0,SymbolsArray[SymbolIdx],_Period);
            NewOrder(ChartSymbol(currChart),(OpenPos&&PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL)?NewOrderWaitSell:NewOrderBuy,"handMade");
            ObjectSetInteger(currChart,name,OBJPROP_STATE,false);
           }

         name=prefix+"_sell_in_chart";
         if(ObjectFind(currChart,name)==-1)
           {
            ObjectCreate(currChart,name,OBJ_BUTTON,window,0,0);
            ObjectSetInteger(currChart,name,OBJPROP_XDISTANCE,FontSize*15);
            ObjectSetInteger(currChart,name,OBJPROP_YDISTANCE,FontSize*7);
            ObjectSetInteger(currChart,name,OBJPROP_XSIZE,FontSize*10);
            ObjectSetInteger(currChart,name,OBJPROP_YSIZE,FontSize*2);
            ObjectSetInteger(currChart,name,OBJPROP_SELECTABLE,0);
            ObjectSetInteger(currChart,name,OBJPROP_FONTSIZE,FontSize);
            ObjectSetInteger(currChart,name,OBJPROP_CORNER,CORNER_RIGHT_UPPER);

           }   
                    ObjectSetString(currChart,name,OBJPROP_TEXT,(OpenPos&&PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)?"CloseBuy":"Sell");
         if(ObjectGetInteger(currChart,name,OBJPROP_STATE))
           {
            Print("Sell "+ChartSymbol(currChart));//if(_Symbol!=SymbolsArray[SymbolIdx])ChartSetSymbolPeriod(0,SymbolsArray[SymbolIdx],_Period);
            NewOrder(ChartSymbol(currChart),(OpenPos&&PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)?NewOrderWaitBuy:NewOrderSell,"handMade");
            ObjectSetInteger(currChart,name,OBJPROP_STATE,false);
           }
        }
      prevChart=currChart;// запомним идентификатор текущего графика для ChartNext()
      i++;// не забудем увеличить счетчик
     }
   return true;
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
   if(NewOrderWait==type || !_OpenNewPosition_||StartOpenPosition>TimeCurrent()) return(false);

// проверяем что баланс не упал ниже % чем на начало недели  
   double curr_balance=AccountInfoDouble(ACCOUNT_BALANCE);
//---
   double result=0;//,profit=0,loss=0;
   ulong ticket=0;//,trades=0; 
   MqlDateTime str_timeCurrent;
   datetime Start_Date;
   uint total;
   Start_Date=(datetime)WeekStartTime(TimeCurrent());
   HistorySelect(Start_Date,TimeCurrent());

   TimeToStruct(TimeCurrent(),str_timeCurrent);

   total=HistoryDealsTotal();
   for(uint i=0;i<total;i++)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
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
   if((-result)>(_Max_lost_per_Week_Percent*curr_balance/100) && expiration==0)
     {
      Print("In week, start "+(string)Start_Date+" lost "+DoubleToString(result)+" more then limit "+DoubleToString(_Max_lost_per_Week_Percent*curr_balance/100));
      StartOpenPosition=Start_Date+24*7*3600;
      return(false);
     }
   result=0;
//Start_Date=(datetime)WeekStartTime(TimeCurrent());
   TimeToStruct(TimeCurrent(),str_timeCurrent);
   str_timeCurrent.hour=0;
   str_timeCurrent.min=0;
   str_timeCurrent.sec=0;
   Start_Date=StructToTime(str_timeCurrent);
   HistorySelect(Start_Date,TimeCurrent());

   TimeToStruct(TimeCurrent(),str_timeCurrent);

   total=HistoryDealsTotal();
   for(uint i=0;i<total;i++)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
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
   if((-result)>(_Max_lost_per_Day_Percent*curr_balance/100) && expiration==0)
     {
      Print("In day, start "+(string)Start_Date+" lost "+DoubleToString(result)+" more then limit "+DoubleToString(_Max_lost_per_Day_Percent*curr_balance/100));
      StartOpenPosition=Start_Date+24*7*3600;
      return(false);
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(str_timeCurrent.day_of_week==5 && str_timeCurrent.hour==23 && str_timeCurrent.min>0)
     {
      Print("End of week ");
      StartOpenPosition=Start_Date+24*7*3600;
      return(false);
     }

   string gvn="GC_NewOrder";
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
// есть такой-же отложенный ордер
   for(i=0;i<OrdersTotal();i++)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
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
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
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
   if((0==ticket) && (type==NewOrderWaitBuy || type==NewOrderWaitSell)){  return(false);}
   MqlTick lasttick;
   if(!SymbolInfoTick(smb,lasttick)) { GlobalVariableSet(gvn,0); return(false);}
   if(0==expiration && magic!=789) expiration=TimeCurrent()+_Expiration_*PeriodSeconds(_Period);
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(price==0)
     {
      if(ticket!=0)
        {// есть открытая и она выбрана то паника - ставим на цену с мин прибылью -лишь бы закрыть
         //magic=666;
         if(type==NewOrderBuy || type==NewOrderSell) magic=999;
         if(type==NewOrderWaitBuy || type==NewOrderBuy)
           {
            if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL)
              {
               // если прибыль уже есть -то приближаем к идеалу
               //if(PositionGetDouble(POSITION_PROFIT)>1)
               //   price=PositionGetDouble(POSITION_PRICE_CURRENT)-SymbolInfoInteger(smb,SYMBOL_SPREAD)*SymbolInfoDouble(smb,SYMBOL_POINT)*1.1;
               //else// иначе ставим на мин прибыль
               price=PositionGetDouble(POSITION_PRICE_OPEN)-(3*_deviation_+1.1*SymbolInfoInteger(smb,SYMBOL_SPREAD))*SymbolInfoDouble(smb,SYMBOL_POINT);//BufferC[1];
               if(price>(lasttick.ask+3*_deviation_*SymbolInfoDouble(smb,SYMBOL_POINT))) price=lasttick.ask+3*_deviation_*SymbolInfoDouble(smb,SYMBOL_POINT);
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
               price=PositionGetDouble(POSITION_PRICE_OPEN)+(3*_deviation_+1.1*SymbolInfoInteger(smb,SYMBOL_SPREAD))*SymbolInfoDouble(smb,SYMBOL_POINT);
               if(price<(lasttick.bid-3*_deviation_*SymbolInfoDouble(smb,SYMBOL_POINT))) price=lasttick.bid-3*_deviation_*SymbolInfoDouble(smb,SYMBOL_POINT);
              }
            else return(false);
           }
         expiration=0;         // трекинг на закрытие - этот одрер будет жить до закрытия открытой 
        }
      else
        {
         if(type==NewOrderBuy) price=lasttick.ask+10*_deviation_*SymbolInfoDouble(smb,SYMBOL_POINT);
         if(type==NewOrderWaitBuy) price=lasttick.ask+10*_deviation_*SymbolInfoDouble(smb,SYMBOL_POINT);
         if(type==NewOrderWaitSell) price=lasttick.bid-10*_deviation_*SymbolInfoDouble(smb,SYMBOL_POINT);
         if(type==NewOrderSell) price=lasttick.bid-10*_deviation_*SymbolInfoDouble(smb,SYMBOL_POINT);
        }
     }

   MqlTradeRequest trReq={0};
   MqlTradeResult trRez={0};
   trReq.action=TRADE_ACTION_PENDING;
   trReq.magic=magic;
   trReq.symbol=smb;                 // Trade symbol
   trReq.volume=_Order_Volume_;      // Requested volume for a deal in lots
   trReq.deviation=_deviation_;                                    // Maximal possible deviation from the requested price
   trReq.sl=0;//lasttick.bid + 1.5*TrailingStop*SymbolInfoDouble(smb,SYMBOL_POINT);
   trReq.tp=price;
   trReq.comment=comment;//+" "+(string)(lasttick.ask-lasttick.bid);
   trReq.expiration=expiration;
   if(expiration==0)
      trReq.type_time=ORDER_TIME_GTC;
   else
      trReq.type_time=ORDER_TIME_SPECIFIED;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(type==NewOrderBuy || type==NewOrderWaitBuy)
     {
      trReq.price=0.001;                             // SymbolInfoDouble(NULL,SYMBOL_ASK);
      trReq.type=ORDER_TYPE_BUY_LIMIT;
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
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
//     Print(__FUNCTION__," : ",trRez.comment," код ответа ",trRez.retcode," trReq.price=",trReq.price," trReq.tp=",trReq.tp," trReq.sl=",trReq.sl," trReq.type=",trReq.type);
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
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
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
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
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
   RefreshView();
   if(!_TrailingPosition_) return(false);
   string gvn="GC_Trailing";
// check what run once
   if(TimeCurrent()>(GlobalVariableTime(gvn)+5)) GlobalVariableDel(gvn);
   double gvv;
   if(!GlobalVariableGet(gvn,gvv)) {GlobalVariableTemp(gvn); gvv=0;}
   if(gvv>0) return(false);// startin
   GlobalVariableSet(gvn,1);

   int PosTotal=PositionsTotal();// открытых позицый
   int OrdTotal=OrdersTotal();   // ордеров
   int i;//,TrailingStop;
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
// Удаляем отложенные ордера без предела времени  = паника, если нет открытых позиций -мусор в общем
   for(i=OrdTotal;i>0;i--)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
     {
      ticket=OrderGetTicket(i-1);
      smb=OrderGetString(ORDER_SYMBOL);
      if(OrderGetInteger(ORDER_TIME_EXPIRATION)==0)// паника
        {
         if(!(PositionSelect(smb)
            || 
            (PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY && 
            OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_BUY_LIMIT) || 
            (PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL && 
            OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_SELL_LIMIT)))
            DeleteOrder(ticket);
        }
      else// отложеный
        {
         if(PositionSelect(smb) && ((PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY && 
            OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_BUY_LIMIT)
            || (PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL && 
            OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_SELL_LIMIT)))
            DeleteOrder(ticket);
        }
     }
   OrdTotal=OrdersTotal();
   double  TS=SymbolInfoDouble(smb,SYMBOL_POINT)*SymbolInfoInteger(smb,SYMBOL_SPREAD)*_NumTS_;
   double  TP=SymbolInfoDouble(smb,SYMBOL_POINT)*SymbolInfoInteger(smb,SYMBOL_SPREAD)*_NumTP_;
// проверяем -стоит ли открыть новую позицию, или закрыть старую
   for(i=0;i<OrdTotal && _OpenNewPosition_;i++)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
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
         ); else { GlobalVariableSet(gvn,0); return(false);}
      SymbolInfoTick(smb,lasttick);
      //TrailingStop=(int)(_NumTS_*SymbolInfoInteger(smb,SYMBOL_TRADE_STOPS_LEVEL));
      datetime OTE=(datetime)OrderGetInteger(ORDER_TIME_EXPIRATION);
      if(PositionSelect(smb))
        {// есть открытые
         int v_rate=1;
         if(OrderGetInteger(ORDER_MAGIC)==999) v_rate=2;
         if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)
           { // смотрим есть ли заказ на закрытие
            if(OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_SELL_LIMIT)
              {
               if(
                  (OrderGetDouble(ORDER_TP)>lasttick.bid && lasttick.bid>PositionGetDouble(POSITION_PRICE_OPEN)) // купят дороже чем хотим и дороже чем купили
                  )
                 {// нашли на продажу - значит надо закрыться
                  trReq.action=TRADE_ACTION_DEAL;
                  //              trReq.magic=999;
                  trReq.symbol=smb;                 // Trade symbol
                  trReq.volume=PositionGetDouble(POSITION_VOLUME)*v_rate;      // Requested volume for a deal in lots
                  trReq.deviation=_deviation_;
                  trReq.price=lasttick.bid;
                  trReq.type=ORDER_TYPE_SELL;                           // Order type
                  trReq.sl=0;
                  trReq.tp=0;
                  trReq.comment=OrderGetString(ORDER_COMMENT);
                  Order_Send(trReq,trRez);
                  if(10009!=trRez.retcode) Print(__FUNCTION__," sell:",trRez.comment," ",smb," код ответа ",trRez.retcode," trReq.tp=",trReq.tp," trReq.sl=",trReq.sl);
                  else
                    {
                     DeleteOrder(ticket);
                    }
                 }
               else
                 { // закрыть не смогли или не захотели -посмотрим может его двинуть "получше"?
                  double newtp=lasttick.bid-1.5*SymbolInfoInteger(smb,SYMBOL_TRADE_STOPS_LEVEL)*SymbolInfoDouble(smb,SYMBOL_POINT);
                  if(OrderGetDouble(ORDER_TP)<newtp)
                    {
                     trReq.order=ticket;
                     trReq.sl=0;
                     trReq.tp=newtp;
                     trReq.price=OrderGetDouble(ORDER_PRICE_OPEN);
                     trReq.deviation=_deviation_;
                     trReq.type_time=ORDER_TIME_GTC;
                     trReq.action=TRADE_ACTION_MODIFY;
                     Order_Send(trReq,trRez);
                     //if(10009!=trRez.retcode) Print(__FUNCTION__," sell sl:",trRez.comment," ",smb," код ответа",trRez.retcode," trReq.tp=",trReq.tp," trReq.sl=",trReq.sl);
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
                  trReq.deviation=_deviation_;                     // Maximal possible deviation from the requested price
                  trReq.sl=0;//lasttick.ask+1.1*TrailingStop*SymbolInfoDouble(smb,SYMBOL_POINT);
                  trReq.tp=0;//lasttick.ask+1.1*TrailingStop*SymbolInfoDouble(smb,SYMBOL_POINT);
                  trReq.price=lasttick.ask;                   // SymbolInfoDouble(NULL,SYMBOL_ASK);
                  trReq.type=ORDER_TYPE_BUY;              // Order type
                  trReq.comment=OrderGetString(ORDER_COMMENT);
                  string comm=OrderGetString(ORDER_COMMENT);
                  Order_Send(trReq,trRez);
                  if(10009!=trRez.retcode) Print(__FUNCTION__," buy:",trRez.comment," ",smb," код ответа ",trRez.retcode," trReq.tp=",trReq.tp," trReq.sl=",trReq.sl);
                  else
                    {
                     DeleteOrder(ticket);
                    }
                  if(StringFind(comm,"NewOrder")==0){NewOrder(smb,NewOrderBuy,"");}
                 }
               else
                 { // закрыть не смогли или не захотели -посмотрим может его двинуть "получше"?
                  double newtp=lasttick.ask+1.5*SymbolInfoInteger(smb,SYMBOL_TRADE_STOPS_LEVEL)*SymbolInfoDouble(smb,SYMBOL_POINT);
                  if(OrderGetDouble(ORDER_TP)>newtp)
                    {
                     trReq.order=ticket;
                     trReq.sl=0;
                     trReq.tp=newtp;
                     trReq.price=OrderGetDouble(ORDER_PRICE_OPEN);
                     trReq.deviation=_deviation_;
                     trReq.type_time=ORDER_TIME_GTC;
                     trReq.action=TRADE_ACTION_MODIFY;
                     Order_Send(trReq,trRez);
                     if(10009!=trRez.retcode) Print(__FUNCTION__," buy sl:",trRez.comment," ",smb," код ответа",trRez.retcode," trReq.tp=",trReq.tp," trReq.sl=",trReq.sl);
                    }
                 }
              }
           }
        }
      else if(OTE!=0)// открытых нет
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
         // будем открываться...
         if(trReq.price>0)
           {
            trReq.action=TRADE_ACTION_DEAL;
            trReq.magic=OrderGetInteger(ORDER_MAGIC);
            trReq.symbol=OrderGetString(ORDER_SYMBOL);                 // Trade symbol
            trReq.volume=OrderGetDouble(ORDER_VOLUME_INITIAL);      // Requested volume for a deal in lots
            trReq.comment=OrderGetString(ORDER_COMMENT);
            trReq.deviation=_deviation_;                                    // Maximal possible deviation from the requested price
            trReq.tp=0;  trReq.sl=0;                                  // Maximal possible deviation from the requested price
            Order_Send(trReq,trRez);
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
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
     {
      smb=PositionGetSymbol(i);
      ticket=PositionGetInteger(POSITION_IDENTIFIER);
      newsl=0;
      // текущая история
      if((CopyOpen(smb,per,0,needcopy,BufferO)==needcopy)
         && (CopyClose(smb,per,0,needcopy,BufferC)==needcopy)
         && (CopyLow(smb,per,0,needcopy,BufferL)==needcopy)
         && (CopyHigh(smb,per,0,needcopy,BufferH)==needcopy)
         && (CopyTime(smb,per,0,needcopy,dt)==needcopy)
         ){} else {GlobalVariableSet(gvn,0);return(false);}
      SymbolInfoTick(smb,lasttick);
      trReq.symbol=smb;
      trReq.deviation=_deviation_;
      trReq.order=ticket;
      TS=SymbolInfoDouble(smb,SYMBOL_POINT)*SymbolInfoInteger(smb,SYMBOL_SPREAD)*_NumTS_;
      TP=SymbolInfoDouble(smb,SYMBOL_POINT)*SymbolInfoInteger(smb,SYMBOL_SPREAD)*_NumTP_;

      if(_LovelyProfit_>0 && PositionGetDouble(POSITION_PROFIT)>_LovelyProfit_*_Order_Volume_)
        {
         TS=TS/2;
        }        //TrailingStop=(int)(_NumTS_*SymbolInfoInteger(smb,SYMBOL_TRADE_STOPS_LEVEL));
      if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL)
        {
         if(0==PositionGetDouble(POSITION_SL) || 0==PositionGetDouble(POSITION_TP))
           {
            trReq.action=TRADE_ACTION_SLTP;
            trReq.sl=lasttick.ask+TS;
            trReq.tp=lasttick.bid-TP;;
            Order_Send(trReq,BigDogModifResult);
           }
         else
           {

            newsl=lasttick.ask+TS;
            if((PositionGetDouble(POSITION_SL)>newsl) && ((PositionGetDouble(POSITION_SL)-newsl)>_deviation_*SymbolInfoDouble(smb,SYMBOL_POINT)))
              {
               trReq.action=TRADE_ACTION_SLTP;
               trReq.tp=PositionGetDouble(POSITION_TP)-(PositionGetDouble(POSITION_SL)-newsl);
               trReq.sl=newsl;
               Order_Send(trReq,BigDogModifResult);
              }
           }
         // если паника -то двигаем стоплост ближе
         if(_Carefull_>0 && ((lasttick.bid>
            (PositionGetDouble(POSITION_PRICE_OPEN)-2*SymbolInfoInteger(smb,SYMBOL_SPREAD)*SymbolInfoDouble(smb,SYMBOL_POINT)))
            && (TimeCurrent()>(PositionGetInteger(POSITION_TIME)+_Carefull_*60))))
           {
            NewOrder(smb,NewOrderWaitBuy,"Panic sell",0,789);
           }
         // если можно снять сливки -то двигаем стоплост ближе
         if(_IamChicken_
            && (lasttick.bid<
            (PositionGetDouble(POSITION_PRICE_OPEN)-2*SymbolInfoInteger(smb,SYMBOL_SPREAD)*SymbolInfoDouble(smb,SYMBOL_POINT)))
            )
           {
            NewOrder(smb,NewOrderWaitBuy,"Chicken sell",0,789);
           }
         // если можно снять сливки -то двигаем стоплост ближе
         if(((_GetMaximum_>0 && (TimeCurrent()>(PositionGetInteger(POSITION_TIME)+_GetMaximum_*60))))
            && (lasttick.bid<
            (PositionGetDouble(POSITION_PRICE_OPEN)-_NumTP_*SymbolInfoInteger(smb,SYMBOL_SPREAD)*SymbolInfoDouble(smb,SYMBOL_POINT)))
            )
           {
            NewOrder(smb,NewOrderWaitBuy,"Slivki sell",0,987);
           }
        }
      else
        {
         if((0==PositionGetDouble(POSITION_SL)) || (0==PositionGetDouble(POSITION_TP)))
           {
            trReq.action=TRADE_ACTION_SLTP;
            trReq.sl= lasttick.bid-TS;
            trReq.tp=lasttick.ask+TP;
            Order_Send(trReq,BigDogModifResult);
           }
         else
           {
            newsl=lasttick.bid-TS;
            if((PositionGetDouble(POSITION_SL)<newsl) && ((newsl-PositionGetDouble(POSITION_SL))>5*SymbolInfoDouble(smb,SYMBOL_POINT)))
              {
               trReq.action=TRADE_ACTION_SLTP;
               trReq.sl= newsl;
               trReq.tp=lasttick.ask+TP;
               Order_Send(trReq,BigDogModifResult);
              }
           }
         // если можно снять сливки -то двигаем стоплост ближе
         if(_Carefull_>0 && ((lasttick.ask<
            (PositionGetDouble(POSITION_PRICE_OPEN)+2*SymbolInfoInteger(smb,SYMBOL_SPREAD)*SymbolInfoDouble(smb,SYMBOL_POINT)))
            && (TimeCurrent()>(PositionGetInteger(POSITION_TIME)+_Carefull_*60))))
           {
            NewOrder(smb,NewOrderWaitSell,"Panic buy",0,789);
           }
         // Трусливый
         if(_IamChicken_
            && (lasttick.ask>
            (PositionGetDouble(POSITION_PRICE_OPEN)+2*SymbolInfoInteger(smb,SYMBOL_SPREAD)*SymbolInfoDouble(smb,SYMBOL_POINT)))
            )
           {
            NewOrder(smb,NewOrderWaitSell,"Chicken buy",0,789);
           }
         // если можно снять сливки -то двигаем стоплост ближе
         if(((_GetMaximum_>0 && (TimeCurrent()>(PositionGetInteger(POSITION_TIME)+_GetMaximum_*60))))
            && (lasttick.ask>
            (PositionGetDouble(POSITION_PRICE_OPEN)+1*_NumTP_*SymbolInfoInteger(smb,SYMBOL_SPREAD)*SymbolInfoDouble(smb,SYMBOL_POINT)))
            )
           {
            NewOrder(smb,NewOrderWaitSell,"Slivki buy",0,987);
           }
        }
     }
// Двигаем отложенные ордера "на получше"
   OrdTotal=OrdersTotal();   // ордеров
   for(i=0;i<OrdTotal;i++)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
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
//| Функция обработки ошибок                                         |
//+------------------------------------------------------------------+
int Fun_Error(int Error)
  {
   switch(Error)
     {
      case 10004: Print("Реквота");return(1);
      case 10006: Print("Запрос отвергнут");Sleep(3000);return(1);
      case 10007: Print("Запрос отменен трейдером");return(0);
      case 10008: Print("Ордер размещен");return(2);
      case 10009: Print("Заявка выполнена");return(2);
      case 10010: Print("Заявка выполнена частично");return(2);
      case 10011: Print("Ошибка обработки запроса");return(1);
      case 10012: Print("Запрос отменен по истечению времени");return(1);
      case 10013: Print("Неправильный запрос");return(0);
      case 10014: Print("Неправильный объем в запросе");return(0);
      case 10015: Print("Неправильная цена в запросе");return(0);
      case 10016: Print("Неправильные стопы в запросе");return(0);
      case 10017: Print("Торговля запрещена");return(0);
      case 10018: Print("Рынок закрыт");return(0);
      case 10019: Print("Нет достаточных денежных средств для выполнения запроса");return(0);
      case 10020: Print("Цены изменились");return(1);
      case 10021: Print("Отсутствуют котировки для обработки запроса");Sleep(3000);return(1);
      case 10022: Print("Неверная дата истечения ордера в запросе");return(0);
      case 10023: Print("Состояние ордера изменилось");return(2);
      case 10024: Print("Слишком частые запросы");return(0);
      case 10025: Print("В запросе нет изменений");Sleep(3000);return(1);
      case 10026: Print("Автотрейдинг запрещен сервером");return(0);
      case 10027: Print("Автотрейдинг запрещен клиентским терминалом");return(0);
      case 10028: Print("Запрос заблокирован для обработки");return(2);
      case 10029: Print("Ордер или позиция заморожены");return(2);
      case 10030: Print("Указан неподдерживаемый тип исполнения ордера по остатку");return(0);
      case 10031: Print("Нет соединения с торговым сервером");Sleep(3000);return(1);
      case 10032: Print("Операция разрешена только для реальных счетов");return(0);
      case 10033: Print("Достигнут лимит на количество отложенных ордеров");return(2);
      case 10034: Print("Достигнут лимит на объем ордеров и позиций для данного символа");return(2);

      // Индикаторы
      case 4806: Print("Запрошенные данные не найдены");return(Error);
      case 4807: Print("Недостаточно памяти для перераспределения массива либо попытка изменения размера статического массива");return(Error);
      default:    Print("Ошибка № - ",Error);return(0);
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
      case TRADE_RETCODE_REQUOTE: str="Реквота"; break;
      case TRADE_RETCODE_REJECT: str="Запрос отвергнут"; break;
      case TRADE_RETCODE_CANCEL: str="Запрос отменен трейдером"; break;
      case TRADE_RETCODE_PLACED: str="Ордер размещен"; break;
      case TRADE_RETCODE_DONE: str="Заявка выполнена"; break;
      case TRADE_RETCODE_DONE_PARTIAL: str="Заявка выполнена частично"; break;
      case TRADE_RETCODE_ERROR: str="Ошибка обработки запроса"; break;
      case TRADE_RETCODE_TIMEOUT: str="Запрос отменен по истечению времени";break;
      case TRADE_RETCODE_INVALID: str="Неправильный запрос"; break;
      case TRADE_RETCODE_INVALID_VOLUME: str="Неправильный объем в запросе"; break;
      case TRADE_RETCODE_INVALID_PRICE: str="Неправильная цена в запросе"; break;
      case TRADE_RETCODE_INVALID_STOPS: str="Неправильные стопы в запросе"; break;
      case TRADE_RETCODE_TRADE_DISABLED: str="Торговля запрещена"; break;
      case TRADE_RETCODE_MARKET_CLOSED: str="Рынок закрыт"; break;
      case TRADE_RETCODE_NO_MONEY: str="Нет достаточных денежных средств для выполнения запроса"; break;
      case TRADE_RETCODE_PRICE_CHANGED: str="Цены изменились"; break;
      case TRADE_RETCODE_PRICE_OFF: str="Отсутствуют котировки для обработки запроса"; break;
      case TRADE_RETCODE_INVALID_EXPIRATION: str="Неверная дата истечения ордера в запросе"; break;
      case TRADE_RETCODE_ORDER_CHANGED: str="Состояние ордера изменилось"; break;
      case TRADE_RETCODE_TOO_MANY_REQUESTS: str="Слишком частые запросы"; break;
      case TRADE_RETCODE_NO_CHANGES: str="В запросе нет изменений"; break;
      case TRADE_RETCODE_SERVER_DISABLES_AT: str="Автотрейдинг запрещен сервером"; break;
      case TRADE_RETCODE_CLIENT_DISABLES_AT: str="Автотрейдинг запрещен клиентским терминалом"; break;
      case TRADE_RETCODE_LOCKED: str="Запрос заблокирован для обработки"; break;
      case TRADE_RETCODE_FROZEN: str="Ордер или позиция заморожены"; break;
      case TRADE_RETCODE_INVALID_FILL: str="Указан неподдерживаемый тип исполнения ордера по остатку "; break;
      case TRADE_RETCODE_CONNECTION: str="Нет соединения с торговым сервером"; break;
      case TRADE_RETCODE_ONLY_REAL: str="Операция разрешена только для реальных счетов"; break;
      case TRADE_RETCODE_LIMIT_ORDERS: str="Достигнут лимит на количество отложенных ордеров"; break;
      case TRADE_RETCODE_LIMIT_VOLUME: str="Достигнут лимит на объем ордеров и позиций для данного символа"; break;
      default: str="Неизвестный результат";
     }
//----
   return(str);
  }
//+------------------------------------------------------------------+
