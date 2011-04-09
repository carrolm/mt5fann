//+------------------------------------------------------------------+
//|                                     ExportTemplateTestExpert.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"

//+------------------------------------------------------------------+
#include <GC\GetVectors.mqh>
#include <GC\CurrPairs.mqh> // пары
input int _CNT_=10000;//Сколько сигналов
input int _SHIFT_=1000;//Сколько сдвиг
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnStart()
  {
   CPInit();
   Write_File(_CNT_); //
                      //   Write_File(SymbolsArray,MaxSymbols,100,_Pers_); //
   Print("Files created...");
   return;// работа скрипта завершена
  }
//+------------------------------------------------------------------+
int Write_File(int qty)
  {
   int i;
   double res,restanh=0;
   string outstr;
   MqlRates rates[];
   MqlDateTime tm;
   double IV[50],OV[10];
   ArraySetAsSeries(rates,true);
   int FileHandle=FileOpen("OracleDummy.mqh",FILE_WRITE|FILE_ANSI,' ');
   if(FileHandle!=INVALID_HANDLE)
     {
      int copied=CopyRates(_Symbol,_Period,10+_SHIFT_-1,qty+1,rates);
      FileWrite(FileHandle,"double od_forecast(datetime time,string smb)  ");
      FileWrite(FileHandle," {");
      int SymbolIdx;
      //FileWrite(FileHandle,"if(smb!=\""+SymbolsArray[SymbolIdx]+"\") return(0);");
      for(SymbolIdx=0; SymbolIdx<MaxSymbols;SymbolIdx++)
        {
         for(i=0; i<qty;i++)
           {
            TimeToStruct(rates[i].time,tm);
            res=GetTrend(20,SymbolsArray[SymbolIdx],PERIOD_M1,i+_SHIFT_,false);
            restanh=tanh(res/5);
            //            if(GetVectors(IV,OV,0,1,"Easy",SymbolsArray[SymbolIdx],PERIOD_M1,i+_SHIFT_))
              {
               //               res=OV[0];
               if(restanh>0.3 || restanh<-0.3) 
               //               Print(tanh(res/5));
               // FileWrite(FileHandle," //" +(string)res+"="+restanh);
               FileWrite(FileHandle,"  if(smb==\""+SymbolsArray[SymbolIdx]+"\" && time==StringToTime(\""+(string)rates[i].time+"\")) return("+(string)restanh+");");
              }
           }
        }
      FileWrite(FileHandle,"  return(0);");
      FileWrite(FileHandle," }");

     }
   FileClose(FileHandle);
   return(0);
  }
//+------------------------------------------------------------------+
