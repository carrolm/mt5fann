//+------------------------------------------------------------------+
//|                                     ExportTemplateTestExpert.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"

//+------------------------------------------------------------------+
#include <GC\GetVectors.mqh>
input int _CNT_=500;//Сколько сигналов
input int _SHIFT_=1000;//Сколько сигналов
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnStart()
  {
   Write_File(_CNT_); //
                      //   Write_File(SymbolsArray,MaxSymbols,100,_Pers_); //
   Print("Files created...");
   return;// работа скрипта завершена
  }
//+------------------------------------------------------------------+
int Write_File(int qty)
  {
   int i;
   double res;
   string outstr;
   MqlRates rates[];
   MqlDateTime tm;
   double IV[50],OV[10];
   ArraySetAsSeries(rates,true);
   int FileHandle=FileOpen("stat.txt",FILE_WRITE|FILE_ANSI,' ');
   if(FileHandle!=INVALID_HANDLE)
     {
      int copied=CopyRates(_Symbol,_Period,10+_SHIFT_-1,qty+1,rates);
      //FileWrite(TrainFile,"X","Y","Z","Rez");
    FileWrite(FileHandle,"if(_Symbol!=\""+_Symbol+"\") return(0);");
      for(i=0; i<qty;i++)
        {
         TimeToStruct(rates[i].time,tm);
         if(GetVectors(IV,OV,0,1,"Easy",_Symbol,PERIOD_M1,i+_SHIFT_))
           {
            res=OV[0];
            if(res>1||res<-1) FileWrite(FileHandle,"if(time==StringToTime(\""+(string)rates[i].time+"\")) return("+(string)res+");");
           }
        }
     }
   FileClose(FileHandle);
   return(0);
  }
//+------------------------------------------------------------------+
