//+------------------------------------------------------------------+
//|                                                    DashBoard.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
//#property version   "000.001"

#include <GC\DashBoard.mqh>
#include <GC\Watcher.mqh>
CWatcher watcher;
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
         default:;             //  Print("Нажата какая-то неперечисленная клавиша");
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
   EventSetTimer(1);
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
//if(_TrailingPosition_) Trailing();//DashBoard.Trailing();
//DashBoard.Refresh();
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
   DashBoard.Refresh();
   watcher.Run();
   Trailing();

  }
//+------------------------------------------------------------------+
//| Expert tiimer function                                             |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
   DashBoard.OnChartEvent(id,lparam,dparam,sparam);
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
