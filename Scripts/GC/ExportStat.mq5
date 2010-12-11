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
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
input bool _EURUSD_=true;//Euro vs US Dollar
input bool _GBPUSD_=true;//Great Britain Pound vs US Dollar
input bool _USDCHF_=true;//US Dollar vs Swiss Franc
input bool _USDJPY_=true;//US Dollar vs Japanese Yen
input bool _USDCAD_=true;//US Dollar vs Canadian Dollar
input bool _AUDUSD_=true;//Australian Dollar vs US Dollar
input bool _NZDUSD_=true;//New Zealand Dollar vs US Dollar
                         //input bool _USDSEK_=false;//US Dollar vs Sweden Kronor
// crosses
/////input bool _AUDNZD_=true;//Australian Dollar vs New Zealand Dollar
/////input bool _AUDCAD_=true;//Australian Dollar vs Canadian Dollar
//input bool _AUDCHF_=true;//Australian Dollar vs Swiss Franc
input bool _AUDJPY_=true;//Australian Dollar vs Japanese Yen
                         //input bool _CHFJPY_=false;//Swiss Frank vs Japanese Yen
input bool _EURGBP_=true;//Euro vs Great Britain Pound 
                         //input bool _EURAUD_=false;//Euro vs Australian Dollar
input bool _EURCHF_=true;//Euro vs Swiss Franc
input bool _EURJPY_=true;//Euro vs Japanese Yen
                         //input bool _EURNZD_=false;//Euro vs New Zealand Dollar
//input bool _EURCAD_=false;//Euro vs Canadian Dollar
//input bool _GBPCHF_=false;//Great Britain Pound vs Swiss Franc
//input bool _GBPJPY_=false;//Great Britain Pound vs Japanese Yen
//input bool _CADCHF_=false;//Canadian Dollar vs Swiss Franc
input int _Pers_=5;//Период анализа
input int _Shift_=5;//на сколько периодов вперед прогноз
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnStart()
  {
   string SymbolsArray[30];//={"","USDCHF","GBPUSD","EURUSD","USDJPY","AUDUSD","USDCAD","EURGBP","EURAUD","EURCHF","EURJPY","GBPJPY","GBPCHF"};

   int MaxSymbols=0;

//---- 
   if(_EURUSD_) SymbolsArray[MaxSymbols++]="EURUSD";//Euro vs US Dollar
   if(_GBPUSD_) SymbolsArray[MaxSymbols++]="GBPUSD";//Euro vs US Dollar
   if(_AUDUSD_) SymbolsArray[MaxSymbols++]="AUDUSD";//Euro vs US Dollar
   if(_NZDUSD_) SymbolsArray[MaxSymbols++]="NZDUSD";//Euro vs US Dollar
   if(_USDCHF_) SymbolsArray[MaxSymbols++]="USDCHF";//Euro vs US Dollar
   if(_USDJPY_) SymbolsArray[MaxSymbols++]="USDJPY";//Euro vs US Dollar
   if(_USDCAD_) SymbolsArray[MaxSymbols++]="USDCAD";//Euro vs US Dollar
   if(_AUDJPY_) SymbolsArray[MaxSymbols++]="AUDJPY";//Euro vs US Dollar
   if(_EURGBP_) SymbolsArray[MaxSymbols++]="EURGBP";//Euro vs US Dollar
   if(_EURCHF_) SymbolsArray[MaxSymbols++]="EURCHF";//Euro vs US Dollar
   if(_EURJPY_) SymbolsArray[MaxSymbols++]="EURJPY";//Euro vs US Dollar
                                                    //WriteFile( 1,5,2010); // день, месяц, год 
   Write_File(SymbolsArray,MaxSymbols,10000,_Pers_); //
//   Write_File(SymbolsArray,MaxSymbols,100,_Pers_); //
   Print("Files created...");
   return;// работа скрипта завершена
  }
//+------------------------------------------------------------------+
int Write_File(string &SymbolsArray[],int MaxSymbols,int qty,int Pers)
  {
   int shift=0,i,pp;
   double SumBuy,SumSell,SumWait;
   int QtyBuy,QtySell,QtyWait;
   int ProfQty[11];
   double res;
   int FileHandle=0,TrainFile=0;
   int SymbolIdx;
   string outstr;
   int maxprof=11;
   MqlRates rates[];
   MqlDateTime tm;
   double IV[10],OV[2];
   ArraySetAsSeries(rates,true);
   FileHandle=FileOpen("stat.csv",FILE_WRITE|FILE_ANSI|FILE_CSV,';');
   TrainFile=FileOpen("train.csv",FILE_WRITE|FILE_ANSI|FILE_CSV,';');
   if(FileHandle!=INVALID_HANDLE)
     {
      int copied=CopyRates(SymbolsArray[0],_Period,qty,3,rates);
      TimeToStruct(rates[2].time,tm);
      FileWrite(FileHandle,// записываем в файл шапку
                "Symbol","TotalProfit","QtyWait","QtyBuy","SumBuy","QtySell","SumSell",(string)tm.day+"/"+(string)tm.mon+"/"+(string)tm.year);
      FileWrite(TrainFile,"X","Y","Z","Rez");
      for(SymbolIdx=0; SymbolIdx<MaxSymbols;SymbolIdx++)
        {
         SumBuy=0;SumSell=0;SumWait=0;QtyBuy=0;QtySell=0;QtyWait=0;
         long k=SymbolInfoInteger(SymbolsArray[SymbolIdx],SYMBOL_TRADE_STOPS_LEVEL);
         for(i=0;i<maxprof;i++) ProfQty[i]=0;
         for(i=0;i<qty;i++)
           {
            if(GetVectors(IV,OV,3,1,"Easy",SymbolsArray[SymbolIdx],PERIOD_M1,i))
              {
                res=OV[0];//GetTrend(30,SymbolsArray[SymbolIdx],PERIOD_M1,i,false);
                  //if(GetVectors_Easy(IV,3,SymbolsArray[SymbolIdx],0,i+30))
                 {
//                  FileWrite(TrainFile,IV[0],IV[1],res);
                  FileWrite(TrainFile,IV[0],IV[1],IV[2],res);
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
