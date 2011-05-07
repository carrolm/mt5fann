//+------------------------------------------------------------------+
//|                                                ExportToEncog.mq5 |
//|                                      Copyright 2011, Investeo.pl |
//|                                                http:/Investeo.pl |
//+------------------------------------------------------------------+
#property copyright "Copyright 2011, Investeo.pl"
#property link      "http:/Investeo.pl"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+

// Export Indicator values for NN training by ENCOG
extern string IndExportFileName = "mt5export.csv";
extern int  trainSize = 2000;

MqlRates srcArr[];
double StochKArr[], StochDArr[], WilliamsRArr[];


void OnStart()
  {
//---
   ArraySetAsSeries(srcArr, true);   
   ArraySetAsSeries(StochKArr, true);   
   ArraySetAsSeries(StochDArr, true);   
   ArraySetAsSeries(WilliamsRArr, true);
         
   int copied = CopyRates(Symbol(), Period(), 0, trainSize, srcArr);
   
   if (copied!=trainSize) { Print("Not enough data for " + Symbol()); return; }
   
   int hStochastic = iStochastic(Symbol(), Period(), 8, 5, 5, MODE_EMA, STO_LOWHIGH);
   int hWilliamsR = iWPR(Symbol(), Period(), 21);
   
   
   CopyBuffer(hStochastic, 0, 0, trainSize, StochKArr);
   CopyBuffer(hStochastic, 1, 0, trainSize, StochDArr);
   CopyBuffer(hWilliamsR, 0, 0, trainSize, WilliamsRArr);
    
   int hFile = FileOpen(IndExportFileName, FILE_CSV | FILE_ANSI | FILE_WRITE | FILE_REWRITE, ",", CP_ACP);
   
   FileWriteString(hFile, "DATE,TIME,CLOSE,StochK,StochD,WilliamsR\n");
   
   Print("Exporting indicator data to " + IndExportFileName);
   
   for (int i=trainSize-1; i>=0; i--)
      {
         string candleDate = TimeToString(srcArr[i].time, TIME_DATE);
         StringReplace(candleDate,".","");
         string candleTime = TimeToString(srcArr[i].time, TIME_MINUTES);
         StringReplace(candleTime,":","");
         FileWrite(hFile, candleDate, candleTime, DoubleToString(srcArr[i].close), 
                                                  DoubleToString(StochKArr[i], -10),
                                                  DoubleToString(StochDArr[i], -10),
                                                  DoubleToString(WilliamsRArr[i], -10)
                                                  );
      }
      
   FileClose(hFile);   
     
   Print("Indicator data exported."); 
  }
//+------------------------------------------------------------------+
