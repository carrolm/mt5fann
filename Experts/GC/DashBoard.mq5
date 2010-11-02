//+------------------------------------------------------------------+
//|                                                    DashBoard.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "0.00a"

#include <DashBoard.mqh>
// sell  фигня
void CDashBoard::Trailing()
  {
   int PosTotal=PositionsTotal();
   int SymbolIdx;
   MqlTick lasttick;
// смотрим есть ли заказ на покупку/продажу
//   MqlTick tick; //variable for tick info
   for(int i=PosTotal-1; i>=0; i--)
     {
      //     Print("Trailing ...перебираем открытые позиции");
      // перебираем открытые позиции
      string smb=PositionGetSymbol(i);
      SymbolInfoTick(smb,lasttick);
      //TrailingStop=2.5;
      TrailingStop=(int)(2*SymbolInfoInteger(smb,SYMBOL_SPREAD));
      if(TrailingStop<55) TrailingStop=55;
      if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)
        { // смотрим есть ли заказ на закрытие
         for(SymbolIdx=0; SymbolIdx<MaxSymbols;SymbolIdx++)
            if(SymbolsArray[SymbolIdx]==smb)
              {
               if(sell_price[SymbolIdx]>0 && sell_price[SymbolIdx]>lasttick.bid && lasttick.bid>PositionGetDouble(POSITION_PRICE_OPEN))
                 {
                  Print("closepos",sell_price[SymbolIdx],lasttick.bid,PositionGetDouble(POSITION_PRICE_OPEN));
                  trReq.action=TRADE_ACTION_DEAL;
                  trReq.magic=777;
                  trReq.symbol=SymbolsArray[SymbolIdx];                 // Trade symbol
                  trReq.volume=PositionGetDouble(POSITION_VOLUME);   // Requested volume for a deal in lots
                  trReq.deviation=1;                     // Maximal possible deviation from the requested price
                  trReq.price=lasttick.bid;                   // SymbolInfoDouble(NULL,SYMBOL_ASK);
                  trReq.type=ORDER_TYPE_SELL;              // Order type
                  OrderSend(trReq,trRez);
                  if(10009==trRez.retcode)
                    {
                     sell_price[SymbolIdx]=0;//Print("sell ",ObjectSetInteger(0,prefix+"m_sell_"+SymbolsArray[SymbolIdx],OBJPROP_SELECTED,false));
                    }
                 }

              }
         if(TrailingStop>0
            &&(((lasttick.bid-PositionGetDouble(POSITION_PRICE_OPEN))/SymbolInfoDouble(smb,SYMBOL_POINT)>TrailingStop)
            && ((lasttick.bid-PositionGetDouble(POSITION_SL))/SymbolInfoDouble(smb,SYMBOL_POINT)>TrailingStop))
            || (0==PositionGetDouble(POSITION_SL)))
           {
            MqlTradeRequest BigDogModif;
            BigDogModif.action= TRADE_ACTION_SLTP;
            BigDogModif.symbol= smb;
            BigDogModif.sl = lasttick.bid - TrailingStop*SymbolInfoDouble(smb,SYMBOL_POINT);
            BigDogModif.tp = PositionGetDouble(POSITION_TP);
            BigDogModif.deviation=3;
            MqlTradeResult BigDogModifResult;
            OrderSend(BigDogModif,BigDogModifResult);
            //           Print(__FUNCTION__,":",BigDogModifResult.comment);
           }
        }
      if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL)
        {//sell
         for(SymbolIdx=0; SymbolIdx<MaxSymbols;SymbolIdx++)
            if(SymbolsArray[SymbolIdx]==smb)
              {
               if(buy_price[SymbolIdx]>0 && buy_price[SymbolIdx]<lasttick.ask && lasttick.ask<PositionGetDouble(POSITION_PRICE_OPEN))
                 {
                  Print("closepos",buy_price[SymbolIdx],lasttick.ask,PositionGetDouble(POSITION_PRICE_OPEN));
                  trReq.action=TRADE_ACTION_DEAL;
                  trReq.magic=777;
                  trReq.symbol=SymbolsArray[SymbolIdx];                 // Trade symbol
                  trReq.volume=PositionGetDouble(POSITION_VOLUME);   // Requested volume for a deal in lots
                  trReq.deviation=1;                     // Maximal possible deviation from the requested price
                  trReq.price=lasttick.ask;                   // SymbolInfoDouble(NULL,SYMBOL_ASK);
                  trReq.type=ORDER_TYPE_BUY;              // Order type
                  OrderSend(trReq,trRez);
                  if(10009==trRez.retcode)
                    {
                     buy_price[SymbolIdx]=0;//Print("buy ",ObjectSetInteger(0,prefix+"m_buy_"+SymbolsArray[SymbolIdx],OBJPROP_SELECTED,false));
                    }
                 }
              }
         if(TrailingStop>0
            && (((PositionGetDouble(POSITION_PRICE_OPEN)-lasttick.ask)/SymbolInfoDouble(smb,SYMBOL_POINT)>TrailingStop)
            && ((PositionGetDouble(POSITION_SL)-lasttick.ask)/SymbolInfoDouble(smb,SYMBOL_POINT)>TrailingStop))
            || (0==PositionGetDouble(POSITION_SL)))
           {
            MqlTradeRequest BigDogModif;
            BigDogModif.action= TRADE_ACTION_SLTP;
            BigDogModif.symbol= smb;
            BigDogModif.sl = lasttick.ask + TrailingStop*SymbolInfoDouble(smb,SYMBOL_POINT);
            BigDogModif.tp = PositionGetDouble(POSITION_TP);
            BigDogModif.deviation=3;
            MqlTradeResult BigDogModifResult;
            OrderSend(BigDogModif,BigDogModifResult);
           }
        }
     }
   for(int SymbolIdx=0; SymbolIdx<MaxSymbols;SymbolIdx++)
     {
      if(PositionSelect(SymbolsArray[SymbolIdx])) continue;// есть открытая - обработка была выше
      SymbolInfoTick(SymbolsArray[SymbolIdx],lasttick);
      //     if (SymbolsArray[SymbolIdx]==ChartSymbol(currChart))
      //    {
      //      name=prefix+"sl_sell_"+SymbolsArray[SymbolIdx];
      if(!SymbolInfoTick(SymbolsArray[SymbolIdx],lasttick))
        {
         Print("Failed to get Symbol info!");
         return;
        }
      if(buy_price[SymbolIdx]>0 && buy_price[SymbolIdx]<lasttick.ask)
        {
         trReq.action=TRADE_ACTION_DEAL;
         trReq.magic=777;
         trReq.symbol=SymbolsArray[SymbolIdx];                 // Trade symbol
         trReq.volume=0.1;                      // Requested volume for a deal in lots
         trReq.deviation=1;                     // Maximal possible deviation from the requested price
         trReq.price=lasttick.ask;                   // SymbolInfoDouble(NULL,SYMBOL_ASK);
         trReq.type=ORDER_TYPE_BUY;              // Order type
         OrderSend(trReq,trRez);
         if(10009==trRez.retcode)
           {
            buy_price[SymbolIdx]=0;Print("buy ",ObjectSetInteger(0,prefix+"m_buy_"+SymbolsArray[SymbolIdx],OBJPROP_SELECTED,false));
           }
        }
      if(sell_price[SymbolIdx]>0 && sell_price[SymbolIdx]>lasttick.bid)
        {
         trReq.action=TRADE_ACTION_DEAL;
         trReq.magic=777;
         trReq.symbol=SymbolsArray[SymbolIdx];                 // Trade symbol
         trReq.volume=0.1;                      // Requested volume for a deal in lots
         trReq.deviation=1;                     // Maximal possible deviation from the requested price
         trReq.price=lasttick.bid;                   // SymbolInfoDouble(NULL,SYMBOL_ASK);
         trReq.type=ORDER_TYPE_SELL;              // Order type
         OrderSend(trReq,trRez);
         if(10009==trRez.retcode)
           {
            sell_price[SymbolIdx]=0;Print("sell ",ObjectSetInteger(0,prefix+"m_sell_"+SymbolsArray[SymbolIdx],OBJPROP_SELECTED,false));
           }
        }

     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CDashBoard::OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//  if (id==(int)CHARTEVENT_OBJECT_DRAG )
//   {
//   Print("Координаты щелчка мышки на графике: x=",lparam,"  y=",dparam);
//   }
//  else if (id==(int)CHARTEVENT_CLICK )
//   {
//   Print("Координаты щелчка мышки на графике: x=",lparam,"  y=",dparam);
//   }
//
//  else 
//  if(Timer1!=NULL) Timer1.OnEvent(id,lparam,dparam,sparam);
   if(TimerH1!=NULL)TimerH1.OnEvent(id,lparam,dparam,sparam);
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(id==(int)CHARTEVENT_OBJECT_CLICK)
     {
      //    Print("Click",sparam);
      //if(sparam==prefix+"ShowDashBoard")
      // {
      //  ShowDashBoard=ObjectGetInteger(0,sparam,OBJPROP_STATE);
      //  if(!ShowDashBoard)
      //   {
      //    ShowExperts=false;ObjectSetInteger(0,prefix+"ShowExpert",OBJPROP_STATE,false);
      //    ShowTable=false;ObjectSetInteger(0,prefix+"ShowTable",OBJPROP_STATE,false);
      //   }
      //  Refresh(); ChartRedraw();
      // }
      //if(sparam==prefix+"ShowExpert")
      // {
      //  ShowExperts=ObjectGetInteger(0,sparam,OBJPROP_STATE);
      //  if(ShowExperts)
      //   {
      //    ShowDashBoard=true; ObjectSetInteger(0,prefix+"ShowDashBoard",OBJPROP_STATE,true);
      //   }
      //  Refresh(); ChartRedraw();
      // }
      //if(sparam==prefix+"ShowTable")
      // {
      //  ShowTable=ObjectGetInteger(0,sparam,OBJPROP_STATE);
      //  if(ShowTable)
      //   {
      //    ShowDashBoard=true; ObjectSetInteger(0,prefix+"ShowDashBoard",OBJPROP_STATE,true);
      //   }
      //  Refresh(); ChartRedraw();
      // }
      if(sparam==prefix+"m_equity")
        {
         TypeResult++; if(TypeResult>3) TypeResult=0;
         ObjectSetInteger(0,sparam,OBJPROP_STATE,false);
         if(TypeResult==0) ObjectSetString(0,sparam,OBJPROP_TEXT,"Открытые");
         else if(TypeResult==1) ObjectSetString(0,sparam,OBJPROP_TEXT, "За день");
         else if(TypeResult==2) ObjectSetString(0,sparam,OBJPROP_TEXT, "За месяц");
         else if(TypeResult==3)  ObjectSetString(0,sparam,OBJPROP_TEXT, "Всего");
         Refresh(); ChartRedraw();
        }

      for(int SymbolIdx=0; SymbolIdx<MaxSymbols;SymbolIdx++)
        {
         // нажата кнопка с символами
         if(sparam==prefix+"m_tot_"+SymbolsArray[SymbolIdx])
           {
            //        ChartOpen(SymbolsArray[SymbolIdx],PERIOD_M1);
           }
         //close_price 
         if(sparam==prefix+"closepos_"+SymbolsArray[SymbolIdx])
           {
            Print("closepos");
            if(ObjectGetInteger(0,sparam,OBJPROP_STATE)) //проверим состояние кнопки
              {// туточки
               //if(PositionSelect(SymbolsArray[SymbolIdx],100)&&close_price[SymbolIdx]==0)
               // {
               //  MqlTick lasttick;
               //  SymbolInfoTick(SymbolsArray[SymbolIdx],lasttick);
               //  if(PositionGetInteger(POSITION_TYPE)==0)
               //   {
               //    close_price[SymbolIdx] = lasttick.bid - SymbolInfoDouble(SymbolsArray[SymbolIdx],SYMBOL_POINT)*SymbolInfoInteger(SymbolsArray[SymbolIdx],SYMBOL_SPREAD);
               //   }
               //  if(PositionGetInteger(POSITION_TYPE)==1)
               //   {
               //    close_price[SymbolIdx] =  lasttick.ask + SymbolInfoDouble(SymbolsArray[SymbolIdx],SYMBOL_POINT)*SymbolInfoInteger(SymbolsArray[SymbolIdx],SYMBOL_SPREAD);
               //   }
               //  Print(SymbolsArray[SymbolIdx],close_price[SymbolIdx]);
               // }
              }
            else
              {
               //        close_price[SymbolIdx] =0;
              }
           }
         //for(int iperiod=0; iperiod<MaxPeriod;iperiod++) // по периодам
         // {
         // if(sparam==prefix+"t_"+SymbolsArray[SymbolIdx]+"_"+PeriodName[iperiod])
         //  {
         //   //проверим состояние кнопки
         //   bool selected=ObjectGetInteger(0,sparam,OBJPROP_STATE);//проверим состояние кнопки
         //    //если нажата
         //   if(selected)
         //    {
         //     ChartSetSymbolPeriod(0,SymbolsArray[SymbolIdx],PeriodNumber[iperiod]);
         //     ObjectSetInteger(0,sparam,OBJPROP_STATE,false);         ChartRedraw();
         //    }
         //   else
         //    {
         //    }
         //  }
         //  }
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(id==(int)CHARTEVENT_KEYDOWN)
     {
      switch(lparam)
        {
         case KEY_NUMLOCK_LEFT:
         case KEY_LEFT:
            break;
         case KEY_NUMLOCK_UP:    Print("Нажата KEY_NUMLOCK_UP");     break;
         case KEY_UP:            Print("Нажата KEY_UP");             break;
         case KEY_NUMLOCK_RIGHT: Print("Нажата KEY_NUMLOCK_RIGHT");  break;
         case KEY_RIGHT:         Print("Нажата KEY_RIGHT");          break;
         case KEY_NUMLOCK_DOWN:  Print("Нажата KEY_NUMLOCK_DOWN");   break;
         case KEY_DOWN:          Print("Нажата KEY_DOWN");           break;
         case KEY_NUMPAD_5:      Print("Нажата KEY_NUMPAD_5");       break;
         case KEY_NUMLOCK_5:     Print("Нажата KEY_NUMLOCK_5");      break;
         case KEY_NUMLOCK_PLUS:
            break;
         case KEY_NUMLOCK_MINUS:
            break;
         default:                Print("Нажата какая-то неперечисленная клавиша");
        }
      ChartRedraw();
     }
//   else  ObjectSetInteger(0,sparam,OBJPROP_STATE,false);

//   else  ObjectSetInteger(0,sparam,OBJPROP_STATE,false);

//DashBoard.OnChartEvent(id,lparam, dparam, sparam);
  }


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
CDashBoard DashBoard;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   if(!DashBoard.Init()) DashBoard.DeInit();
//   ChartRedraw();
   return(0);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
//DashBoard.DeInit();
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
//  DashBoard.Refresh();
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Expert tiimer function                                             |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
void OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
   DashBoard.OnChartEvent(id,lparam,dparam,sparam);
  }
//+------------------------------------------------------------------+
void OnTimer()
  {
   if(_TrailingPosition_) DashBoard.Trailing();
   DashBoard.OnTimer();
   DashBoard.Refresh();

  }
//+------------------------------------------------------------------+
//| OnTrade function                                                 |
//+------------------------------------------------------------------+
void OnTrade()
  {
//---

//---
  }
//+------------------------------------------------------------------+
