//+------------------------------------------------------------------+
//|                                          ExportVectorsForANN.mq5 |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <GC\Oracle.mqh>

//string exfname;
int exFileHandle=INVALID_HANDLE;
int exFileHandleStat=INVALID_HANDLE;

int curr_num_data=0;
int exQPRF=0,exQS=0,exQCB=0,exQZ=0,exQCS=0,exQB=0,exQ=0,AgeHistory=0;
double            HistoryInputVector[];
COracleTemplate *MyExpert;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   MyExpert=new COracleTemplate("Encog");
   MyExpert.Init();
   string fnm="ANN_"+_Symbol+"_"+TimeFrameName(0)+".csv";
   exFileHandle=FileOpen(fnm,FILE_CSV|FILE_ANSI|FILE_WRITE|FILE_REWRITE,",");
   ArrayResize(HistoryInputVector,(1+2*_TREND_)*(_OutputVectors_+MyExpert.num_input_signals));
   ArrayInitialize(HistoryInputVector,0);
//---
   if(exFileHandle!=INVALID_HANDLE)
     {
      string outstr="";

      outstr=MyExpert.InputSignals; StringReplace(outstr," ",","); StringReplace(outstr,"-","_");
      if(_OutputVectors_==4 && !_ResultAsString_)
         outstr+=",IsBuy,IsCloseSell,IsCloseBuy,IsSell";//,"+outstr;            //outstr+=",Result";
      else if(_OutputVectors_==2 && !_ResultAsString_)
         outstr+=",IsBuy,IsSell";//,"+outstr;            //outstr+=",Result";
      else outstr+=",prediction";//,"+outstr;            //outstr+=",Result";
      FileWrite(exFileHandle,outstr);

      return(INIT_SUCCEEDED);
     }
   else
     {
      Print("Error open for write ",fnm);
      return(INIT_FAILED);
     }
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

//   int maxRepeat=0,nr;
//   for(i=shift;QZ>0 && i<(shift+num_vals);i++)
//     {
//      Result=GetVectors(InputVector,InputSignals,smbl,0,i);
//      if(Result>1 || Result<-1) continue;
//
//
//
//     }
   FileClose(exFileHandle);
//if(FileHandleOC!=INVALID_HANDLE)
//  {
//   FileWrite(FileHandleOC,"  return(0);");
//   FileWrite(FileHandleOC," }");
//   FileClose(FileHandleOC);
//   Q=QS+QCB+QZ+QCS+QB;
//   if(Q>0)
//      FileWrite(FileHandleStat,
//                smbl,0,_NumTS_,QS,QCB,QZ,QCS,QB,Q,
//                -1+(double)QS/Q,-1+2*(double)QS/Q+(double)QCB/Q
//                //,-1+2*(double)(QS+QCB)/Q+(double)QWCB/Q
//                ,0
//                //,1-2*(double)(QB+QCS)/Q-(double)QWCS/Q
//                ,1-2*(double)QB/Q-(double)QCS/Q,
//                1-(double)QB/Q);//,(string)tm.day+"/"+(string)tm.mon+"/"+(string)tm.year);
//   FileClose(FileHandleStat);
//  }
//if(ring==3 && Result!=0)
//  {
//   FileDelete(fnm);
//  }
//else
   Print("Created.");
   delete MyExpert;
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(curr_num_data>_NEDATA_)
     {
      //Print("all done");
     }
   if(!isNewBar()||curr_num_data>_NEDATA_) return;
   curr_num_data++;
   int i,j,shift=_TREND_;
   string outstr;
   double Result=0;
// int num_vals,prev_prg=0;
   string fnm="";

   Result=GetVectors(MyExpert.InputVector,MyExpert.InputSignals,_Symbol,0,0);
   if(Result>1 || Result<-1) return;
//     need_exp=true;

   if(Result>0.66) exQB++;
   else if(Result>.49) exQCS++;
//else if(res>0.1) QWCS++;
   else if(Result>-0.49) exQZ++;
//else if(res>-.49) QWCB++;
   else if(Result>-.66) exQCB++;
   else exQS++;

   if(AgeHistory<_TREND_*2) AgeHistory++;
   for(i=AgeHistory;i>1;i--)
     {
      for(j=0;j<MyExpert.num_input_signals+_OutputVectors_;j++)
         HistoryInputVector[j+(i-1)*(MyExpert.num_input_signals+_OutputVectors_)]=HistoryInputVector[j+(i-2)*(MyExpert.num_input_signals+_OutputVectors_)];
     }
   for(j=0;j<MyExpert.num_input_signals;j++)
      HistoryInputVector[j]=MyExpert.InputVector[j];

   if(AgeHistory==_TREND_*2)
     {
      Result=GetTrend(_Symbol,0,_TREND_*2-1,false);
      if(Result>1 || Result<-1) return;
      outstr="";

      for(j=0;j<MyExpert.num_input_signals;j++)
        {
         outstr+=DoubleToString(HistoryInputVector[(2*_TREND_-1)*(MyExpert.num_input_signals+_OutputVectors_)+j],_Precision_)+",";
        }
      outstr=FormOut(outstr,Result);

      FileWrite(exFileHandle,outstr);
     }
   return;
  }

//---

//+------------------------------------------------------------------+
