//+------------------------------------------------------------------+
//|                                                  ExportEncog.mq5 |
//|                        Copyright 2011, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+

//�������� ��  ������ ������

#property copyright "GreyCardinalRus"
#property link      "https://login.mql5.com/ru/users/Prival"
#property version   "1.000"

#include <GC\GetVectors.mqh>
#include <GC\CurrPairs.mqh> // ����
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+

input int _Pers_=24;//������ �������
input int _Shift_=5;//�� ������� �������� ������ �������
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnStart()
  {
   CPInit();                                                     //WriteFile( 1,5,2010); // ����, �����, ��� 
   Write_File(5000,20,_Pers_); //
   Print("Files created...");
   return;// ������ ������� ���������
  }
//+------------------------------------------------------------------+
int Write_File(int train_qty,int test_qty,int Pers)
  {
   int shift=0;
// test
//   shift=Write_File_fann_data("Forex_test.csv",test_qty,Pers,shift);
   shift=Write_File_encog_data("Forex_train.csv",train_qty,Pers,shift);
   return(shift);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int Write_File_encog_data(string FileName,int qty,int Pers,int shift)
  {
   int i;
   double IB[],OB[];
   ArrayResize(IB,Pers+2);
   ArrayResize(OB,Pers+2);
   int FileHandle=0;
   int needcopy=0;
   int copied=0;
   MqlRates rates[];
//MqlDateTime tm;
   ArraySetAsSeries(rates,true);
   string outstr;
   int SymbolIdx;
   FileHandle=FileOpen(FileName,FILE_WRITE|FILE_ANSI|FILE_TXT,' ');
   needcopy=qty;

   if(FileHandle!=INVALID_HANDLE)
     {
      FileWrite(FileHandle,// ���������� � ���� �����
                needcopy,// 
                //               2+(1+Pers)*MaxSymbols,
                Pers*MaxSymbols,
                MaxSymbols);
      for(SymbolIdx=0; SymbolIdx<MaxSymbols;SymbolIdx++)
        {
         int bars=Bars(SymbolsArray[SymbolIdx],_Period);
         for(i=0;i<needcopy && shift<bars;shift++)
            if(GetVectors(IB,OB,Pers,1,"Easy",SymbolsArray[SymbolIdx],PERIOD_M1,shift))
               //if(GetVectors(IB,OB,3,1,"Easy",SymbolsArray[SymbolIdx],PERIOD_M1,i))
              {
               i++;
               //copied=CopyRates(SymbolsArray[SymbolIdx],_Period,shift,3,rates);
               //TimeToStruct(rates[2].time,tm);
               //               outstr=""+(string)tm.mon+" "+(string)tm.day+" "+(string)tm.day_of_week+" "+(string)tm.hour+" "+(string)tm.min;
               outstr="";//(string)tm.day_of_week+" "+(string)tm.hour;

               for(int ibj=0;ibj<Pers;ibj++)
                 {
                  outstr=outstr+(string)(IB[ibj])+" ";
                 }
               outstr=outstr+(string)(OB[0]);
               FileWrite(FileHandle,outstr);       // 
                                                   //FileWrite(FileHandle,OB[0]); // 
              }
        }
     }
   FileClose(FileHandle);

   return(shift);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string fTimeFrameName(int arg)
  {
   int v;
   if(arg==0)
     {
      v=_Period;
     }
   else
     {
      v=arg;
     }
   switch(v)
     {
      case PERIOD_M1:    return("M1");
      case PERIOD_M2:    return("M2");
      case PERIOD_M3:    return("M3");
      case PERIOD_M4:    return("M4");
      case PERIOD_M5:    return("M5");
      case PERIOD_M6:    return("M6");
      case PERIOD_M10:   return("M10");
      case PERIOD_M12:   return("M12");
      case PERIOD_M15:   return("M15");
      case PERIOD_M20:   return("M20");
      case PERIOD_M30:   return("M30");
      case PERIOD_H1:    return("H1");
      case PERIOD_H2:    return("H2");
      case PERIOD_H3:    return("H3");
      case PERIOD_H4:    return("H4");
      case PERIOD_H6:    return("H6");
      case PERIOD_H8:    return("H8");
      case PERIOD_H12:   return("H12");
      case PERIOD_D1:    return("D1");
      case PERIOD_W1:    return("W1");
      case PERIOD_MN1:   return("MN1");
      default:    return("?");
     }
  } // end fTimeFrameName
//+------------------------------------------------------------------+
//| ��������� ������ ! ������� -������ -����� ����                   |
//| ������ �������                                                   |
//+------------------------------------------------------------------+

bool GetVectors(double &InputVector[],double &OutputVector[],int num_vectors,string smbl="",ENUM_TIMEFRAMES tf=0,int npf=3,int shift=0)
  {// ����, ������, �������� ����� (��� ���������� �������)
   int shft_his=7;
   int shft_cur=0;

   if(""==smbl) smbl=_Symbol;
   if(0==tf) tf=_Period;
   double Close[];
   ArraySetAsSeries(Close,true);
// �������� �������
   int maxcount=CopyClose(smbl,tf,shift,num_vectors+2,Close);
   ArrayInitialize(InputVector,EMPTY_VALUE);
   ArrayInitialize(OutputVector,EMPTY_VALUE);
   if(maxcount<num_vectors)
     {
      Print("Shift = ",shift," maxcount = ",maxcount);
      return(false);
     }
   int i;
   for(i=0;i<num_vectors;i++)
     {
      // �������� � �����������
      InputVector[i]=100*(Close[i]-Close[i+1]);
     }
   OutputVector[0]=100*(Close[1]-Close[2]);
   return(true);
  }
//+------------------------------------------------------------------+
