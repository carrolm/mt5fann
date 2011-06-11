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
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
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
//   CPInit();   Write_File(100000-25); //
   CPInit();   Write_File(100000-25); //

                                      //   CPInit();   Write_File(900,_Pers_); //
//   Write_File(SymbolsArray,MaxSymbols,100,_Pers_); //
   Print("Files created...");
   return;// работа скрипта завершена
  }
//+------------------------------------------------------------------+
int Write_File(int qty)
  {
   int shift=0,i;//,pp;//,j;
   double SumBuy,SumSell;//,SumWait;
   double res;
   int ni=0,no=1;
   int FileHandle=0;//,TrainFile=0;
   int SymbolIdx;
   string outstr;
   int maxprof=11;

   int QPRF=0,QS=0,QCB=0,QWCB=0,QZ=0,QWCS=0,QCS=0,QB=0,Q=0;

   FileHandle=FileOpen("stat.csv",FILE_WRITE|FILE_ANSI|FILE_CSV,';');
   if(FileHandle!=INVALID_HANDLE)
     {

      FileWrite(FileHandle,// записываем в файл шапку
                //                "Symbol","DayOfWeek","Hours","Minuta","Signal","QS","QWS","QW","QWB","QB");
                "Symbol","SumTotalInSpread","QPRF","SumBuy","SumSell","QS","QCB","QWCB","QZ","QWCS","QCS","QB","Q","MQS","MQCB","MQWCB","MQZ","MQWCS","MQCS","MQB");

      for(SymbolIdx=0; SymbolIdx<MaxSymbols;SymbolIdx++)
        {
         SumBuy=0;SumSell=0;
         QPRF=0;QS=0;QCB=0;QWCB=0;QWCS=0;QCS=0;QB=0;QZ=0;
         Print(SymbolIdx+1," of ",MaxSymbols);
         for(i=0;i<qty;i++)
           {
            res=GetTrend(20,SymbolsArray[SymbolIdx],PERIOD_M1,i,false);
            outstr="";
            if(res==0) continue;
            if(res>4) {QB++;SumBuy+=(res-2);}
            else if(res>1) QCS++;
            else if(res>0.1) QWCS++;
            else if(res>-0.1) QZ++;
            else if(res>-1) QWCB++;
            else if(res>-4) {QCB++;SumSell-=(res+2);}
            else QS++;
           }

         Q=QS+QCB+QWCB+QZ+QWCS+QCS+QB;
         FileWrite(FileHandle,
                   SymbolsArray[SymbolIdx],(int)(SumBuy+SumSell),_NumTS_,SumBuy,SumSell,QS,QCB,QWCB,QZ,QWCS,QCS,QB,Q,-1+(double)QS/Q,-1+2*(double)QS/Q+(double)QCB/Q,-1+2*(double)(QS+QCB)/Q+(double)QWCB/Q,0,1-2*(double)(QB+QCS)/Q-(double)QWCS/Q,1-2*(double)QB/Q-(double)QCS/Q,1-(double)QB/Q);//,(string)tm.day+"/"+(string)tm.mon+"/"+(string)tm.year);
         outstr="";
        }
      FileClose(FileHandle);
     }
   return(shift);
  }
//+------------------------------------------------------------------+
