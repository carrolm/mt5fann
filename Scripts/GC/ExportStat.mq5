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
input int _Pers_=5;//Период анализа
input int _Shift_=5;//на сколько периодов вперед прогноз
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnStart()
  {
  CPInit();   Write_File(1000,_Pers_); //
//   Write_File(SymbolsArray,MaxSymbols,100,_Pers_); //
   Print("Files created...");
   return;// работа скрипта завершена
  }
//+------------------------------------------------------------------+
int Write_File(int qty,int Pers)
  {
   int shift=0,i,pp,j;
   double SumBuy,SumSell,SumWait;
   int QtyBuy,QtySell,QtyWait;
   int ProfQty[11];
   double res;
   int ni=3,no=1;
   int FileHandle=0,TrainFile=0;
   int SymbolIdx;
   string outstr;
   int maxprof=11;
   MqlRates rates[];
   MqlDateTime tm;
   double IV[50],OV[10];
   ArraySetAsSeries(rates,true);
   FileHandle=FileOpen("stat.csv",FILE_WRITE|FILE_ANSI|FILE_CSV,';');
   TrainFile=FileOpen("train.csv",FILE_WRITE|FILE_ANSI|FILE_CSV,';');
   if(FileHandle!=INVALID_HANDLE)
     {
      int copied=CopyRates(SymbolsArray[0],_Period,qty,3,rates);
      TimeToStruct(rates[2].time,tm);
      FileWrite(FileHandle,// записываем в файл шапку
                "Symbol","TotalProfit","QtyWait","QtyBuy","SumBuy","QtySell","SumSell",(string)tm.day+"/"+(string)tm.mon+"/"+(string)tm.year);
      //FileWrite(TrainFile,"X","Y","Z","Rez");
      for(SymbolIdx=0; SymbolIdx<MaxSymbols;SymbolIdx++)
        {
         SumBuy=0;SumSell=0;SumWait=0;QtyBuy=0;QtySell=0;QtyWait=0;
         long k=SymbolInfoInteger(SymbolsArray[SymbolIdx],SYMBOL_TRADE_STOPS_LEVEL);
         for(i=0;i<maxprof;i++) ProfQty[i]=0;
         for(i=0;i<qty;i++)
           {
            if(GetVectors(IV,OV,ni,no,"Easy",SymbolsArray[SymbolIdx],PERIOD_M1,i))
              {
                outstr="";
                res=OV[0];//GetTrend(30,SymbolsArray[SymbolIdx],PERIOD_M1,i,false);
                for(j=0;j<ni;j++) outstr+=(string)IV[j]+";";
                for(j=0;j<no;j++) outstr+=(string)OV[j]+";";
                 
                  //if(GetVectors_Easy(IV,3,SymbolsArray[SymbolIdx],0,i+30))
                 {
//                  FileWrite(TrainFile,IV[0],IV[1],res);
                  FileWrite(TrainFile,outstr);
                 }
               if(0==res) continue;
               if((res<0 && res>-2) || (res>0 && res<2)) res=0;
               if((res<0 && (res*k/10+1)>-10) || (res>0 && (res*k/10-1)<10)) res=0;
               if(0==res) {outstr="Wait";QtyWait++; continue;}
               if(0<res){res= res;outstr= "Buy"; QtyBuy++;SumBuy+=+res*k/10-1;}
               if(0>res){res=-res;outstr= "Sell";QtySell++;SumSell+=res*k/10-1;}
               pp=(int)((res*k/100)); if(pp>(maxprof-1)) pp=maxprof-1;
               if(pp>(maxprof-1)) maxprof=maxprof-1;
               ProfQty[pp]++;
              }
            //FileWrite(FileHandle, SymbolsArray[SymbolIdx],outstr,res*k/10-1,res);
           }
         outstr="";
         for(i=0;i<maxprof;i++) outstr+=";"+(string)ProfQty[i];
//         FileWrite(FileHandle,outstr);
         FileWrite(FileHandle,SymbolsArray[SymbolIdx],SumSell+SumBuy,QtyWait,QtyBuy,SumBuy,QtySell,SumSell,outstr);
        }
      FileClose(FileHandle);FileClose(TrainFile);
     }
   return(shift);
  }
//+------------------------------------------------------------------+
