//+------------------------------------------------------------------+
//|                                                   ExportStat.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                ExportHistory.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                           History_in_MathCAD.mq5 |
//|                                                    Привалов С.В. |
//|                           https://login.mql5.com/ru/users/Prival |
//+------------------------------------------------------------------+

//проверка на  потерю данных

#property copyright "GreyCardinal"
#property version   "0.01"
//#include <Fractals.mqh>
#include <GC\GetVectors.mqh>
#include <GC\CurrPairs.mqh> // пары
//input int _Pers_=5;//Период анализа
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
                   //input int _Shift_=5;//на сколько периодов вперед прогноз
/// ---
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnStart()
  {
  CPInit();   Write_File(90000); //

//   CPInit();   Write_File(900,_Pers_); //
                                       //   Write_File(SymbolsArray,MaxSymbols,100,_Pers_); //
   Print("Files created...");
   return;// работа скрипта завершена
  }
//+------------------------------------------------------------------+
int Write_File(int qty)
  {
   int shift=0,i;//,pp;//,j;
   double SumBuy,SumSell,SumWait;
   int QtyBuy,QtySell,QtyWait;
   int ProfQty[11];
   double res;
   int ni=0,no=1;
   int FileHandle=0;//,TrainFile=0;
   int SymbolIdx;
   string outstr;
   int maxprof=11;
   MqlRates rates[];
   MqlDateTime tm;
      int copied=0;
   int QS=0,QWS=0,QW=0,QWB=0,QB=0;
   ArraySetAsSeries(rates,true);
   FileHandle=FileOpen("stat.csv",FILE_WRITE|FILE_ANSI|FILE_CSV,';');
   if(FileHandle!=INVALID_HANDLE)
     {
      int copied=CopyRates(SymbolsArray[0],_Period,qty,3,rates);
      TimeToStruct(rates[2].time,tm);
      FileWrite(FileHandle,// записываем в файл шапку
                "Symbol","DayOfWeek","Hours","Minuta","Signal","QS","QWS","QW","QWB","QB");

      for(SymbolIdx=0; SymbolIdx<MaxSymbols;SymbolIdx++)
        {
         SumBuy=0;SumSell=0;SumWait=0;QtyBuy=0;QtySell=0;QtyWait=0;
         long k=SymbolInfoInteger(SymbolsArray[SymbolIdx],SYMBOL_TRADE_STOPS_LEVEL);
         for(i=0;i<maxprof;i++) ProfQty[i]=0;
         for(i=0;i<qty;i++)
           {
            res=GetTrend(20,SymbolsArray[SymbolIdx],PERIOD_M1,i,false);
              {
               outstr="";
               copied=CopyRates(SymbolsArray[SymbolIdx],PERIOD_M1,i,3,rates);
               TimeToStruct(rates[0].time,tm);

               FileWrite(FileHandle,// записываем в файл
                         SymbolsArray[SymbolIdx],tm.day_of_week,tm.hour,tm.min,res);//,(string)tm.day+"/"+(string)tm.mon+"/"+(string)tm.year);
               QtyBuy=0;QtySell=0;QtyWait=0;
               if(res>0.6) QB++;
               else if (res>0.3) QWB++;
               else if (res>-0.3) QW++;
               else if (res>-0.6) QWS++;
               else QS++;
              }
           }
         outstr="";
        }
      FileClose(FileHandle);
     }
   Print("QS=",QS," QWS=",QWS," QW=",QW," QWB=",QWB," QB=",QB);
   return(shift);
  }
//+------------------------------------------------------------------+
