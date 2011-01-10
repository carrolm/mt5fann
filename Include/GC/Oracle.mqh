//+------------------------------------------------------------------+
//|                                                       Oracle.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#include <GC\GetVectors.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class COracleEasy
  {
private:
public:
   bool              debug;
                     COracleEasy(){Init();};
                    ~COracleEasy(){DeInit();};
   virtual void              Init(){debug=false;};
   virtual void              DeInit(){};
   virtual double    forecast(string smbl,int shift,bool train){return(0.0);};
   virtual string    Name(){return("Prpototype");};
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CiMA:public COracleEasy
  {
   virtual double    forecast(string smbl="",int shift=0,bool train=false);
   virtual string    Name(){return("iMA");};
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CiMA::forecast(string smbl="",int shift=0,bool train=false)
  {

   double sig=0;
   if(""==smbl) smbl=Symbol();
   double ind1_buffer[];
   double ind2_buffer[];
   int   h_ind1=iMA(smbl,PERIOD_M1,8,0,MODE_SMA,PRICE_CLOSE);
   if(CopyBuffer(h_ind1,0,shift,3,ind1_buffer)<3) return(0);
   if(!ArraySetAsSeries(ind1_buffer,true)) return(0);
   int   h_ind2=iMA(smbl,PERIOD_M1,16,0,MODE_SMA,PRICE_CLOSE);
   if(CopyBuffer(h_ind2,0,0,2,ind2_buffer)<2) return(0);
   if(!ArraySetAsSeries(ind2_buffer,true))return(0);

//--- проводим проверку условия и устанавливаем значение для sig
   if(ind1_buffer[2]<ind2_buffer[1] && ind1_buffer[1]>ind2_buffer[1])
      sig=1;
   else if(ind1_buffer[2]>ind2_buffer[1] && ind1_buffer[1]<ind2_buffer[1])
      sig=-1;
   else sig=0;
   IndicatorRelease(h_ind1);   IndicatorRelease(h_ind2);
//--- возвращаем торговый сигнал
   return(sig);
  }
//+------------------------------------------------------------------+
class CiMACD:public COracleEasy
  {
   virtual double    forecast(string smbl="",int shift=0,bool train=false);
   virtual string    Name(){return("iMACD");};
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CiMACD::forecast(string smbl="",int shift=0,bool train=false)
  {

   double sig=0;
   if(""==smbl) smbl=Symbol();
   double ind1_buffer[];double ind2_buffer[];
   int   h_ind1=iMACD(smbl,PERIOD_M1,12,26,9,PRICE_CLOSE);

   if(CopyBuffer(h_ind1,0,shift,2,ind1_buffer)<2) return(0);
   if(CopyBuffer(h_ind1,1,shift,3,ind2_buffer)<3) return(0);
   if(!ArraySetAsSeries(ind1_buffer,true))         return(0);
   if(!ArraySetAsSeries(ind2_buffer,true))         return(0);

//--- проводим проверку условия и устанавливаем значение для sig
   if(ind2_buffer[2]>ind1_buffer[1] && ind2_buffer[1]<ind1_buffer[1])
      sig=1;
   else if(ind2_buffer[2]<ind1_buffer[1] && ind2_buffer[1]>ind1_buffer[1])
      sig=-1;
   else sig=0;

   IndicatorRelease(h_ind1);
//--- возвращаем торговый сигнал
   return(sig);
  }
//+------------------------------------------------------------------+
class CPriceChanel:public COracleEasy
  {
   virtual double    forecast(string smbl="",int shift=0,bool train=false);
   virtual string    Name(){return("Price Chanel");};
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CPriceChanel::forecast(string smbl="",int shift=0,bool train=false)
  {

   double sig=0;
   if(""==smbl) smbl=Symbol();
   double ind1_buffer[];
   double ind2_buffer[];
   double Close[];
   int   h_ind1=iCustom(smbl,PERIOD_M1,"Price Channel",22);
   if(CopyBuffer(h_ind1,0,shift,3,ind1_buffer)<3)         return(0);
   if(CopyBuffer(h_ind1,1,shift,3,ind2_buffer)<3)         return(0);
   if(CopyClose(Symbol(),Period(),0,2,Close)<2) return(0);
   if(!ArraySetAsSeries(ind1_buffer,true))         return(0);
   if(!ArraySetAsSeries(ind2_buffer,true))         return(0);
   if(!ArraySetAsSeries(Close,true)) return(0);

//--- проводим проверку условия и устанавливаем значение для sig
   if(Close[1]>ind1_buffer[2])
      sig=1;
   else if(Close[1]<ind2_buffer[2])
      sig=-1;
   else sig=0;
   IndicatorRelease(h_ind1);
//--- возвращаем торговый сигнал
   return(sig);
  }
//+------------------------------------------------------------------+
class CiStochastic:public COracleEasy
  {
   virtual double    forecast(string smbl="",int shift=0,bool train=false);
   virtual string    Name(){return("iStochastic");};
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CiStochastic::forecast(string smbl="",int shift=0,bool train=false)
  {

   double sig=0;
   if(""==smbl) smbl=Symbol();
   double ind1_buffer[];
   int   h_ind1=iStochastic(smbl,PERIOD_M1,5,3,3,MODE_SMA,STO_LOWHIGH);
   if(CopyBuffer(h_ind1,0,shift,3,ind1_buffer)<3) return(0);

   if(!ArraySetAsSeries(ind1_buffer,true)) return(0);

   if(ind1_buffer[2]<20 && ind1_buffer[1]>20)
      sig=1;
   else if(ind1_buffer[2]>80 && ind1_buffer[1]<80)
      sig=-1;
   else sig=0;
   IndicatorRelease(h_ind1);
//--- возвращаем торговый сигнал
   return(sig);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CiRSI:public COracleEasy
  {
   virtual double    forecast(string smbl="",int shift=0,bool train=false);
   virtual string    Name(){return("iRSI");};
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CiRSI::forecast(string smbl="",int shift=0,bool train=false)
  {

   double sig=0;
   if(""==smbl) smbl=Symbol();
   double ind1_buffer[];
   int   h_ind1=iRSI(smbl,PERIOD_M1,14,PRICE_CLOSE);
   if(CopyBuffer(h_ind1,0,shift,3,ind1_buffer)<3) return(0);

   if(!ArraySetAsSeries(ind1_buffer,true)) return(0);

   if(ind1_buffer[2]<30 && ind1_buffer[1]>30)
      sig=1;
   else if(ind1_buffer[2]>70 && ind1_buffer[1]<70)
      sig=-1;
   else sig=0;
   IndicatorRelease(h_ind1);
//--- возвращаем торговый сигнал
   return(sig);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CiCGI:public COracleEasy
  {
   virtual double    forecast(string smbl="",int shift=0,bool train=false);
   virtual string    Name(){return("iCGI");};
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CiCGI::forecast(string smbl="",int shift=0,bool train=false)
  {

   double sig=0;
   if(""==smbl) smbl=Symbol();
   double ind1_buffer[];
   int   h_ind1=iCCI(smbl,PERIOD_M1,14,PRICE_TYPICAL);
   if(CopyBuffer(h_ind1,0,shift,3,ind1_buffer)<3) return(0);

   if(!ArraySetAsSeries(ind1_buffer,true)) return(0);

   if(ind1_buffer[2]<-100 && ind1_buffer[1]>-100)
      sig=1;
   else if(ind1_buffer[2]>100 && ind1_buffer[1]<100)
      sig=-1;
   else sig=0;
   IndicatorRelease(h_ind1);
//--- возвращаем торговый сигнал
   return(sig);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CiWPR:public COracleEasy
  {
   virtual double    forecast(string smbl="",int shift=0,bool train=false);
   virtual string    Name(){return("iWPR");};
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CiWPR::forecast(string smbl="",int shift=0,bool train=false)
  {

   double sig=0;
   if(""==smbl) smbl=Symbol();
   double ind1_buffer[];
   int   h_ind1=iWPR(smbl,PERIOD_M1,14);
   if(CopyBuffer(h_ind1,0,shift,3,ind1_buffer)<3) return(0);

   if(!ArraySetAsSeries(ind1_buffer,true)) return(0);

   if(ind1_buffer[2]<-80 && ind1_buffer[1]>-80)
      sig=1;
   else if(ind1_buffer[2]>-20 && ind1_buffer[1]<-20)
      sig=-1;

   else sig=0;
   IndicatorRelease(h_ind1);
//--- возвращаем торговый сигнал
   return(sig);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CiBands:public COracleEasy
  {
   virtual double    forecast(string smbl="",int shift=0,bool train=false);
   virtual string    Name(){return("iBands");};
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CiBands::forecast(string smbl="",int shift=0,bool train=false)
  {

   double sig=0;
   if(""==smbl) smbl=Symbol();
   double ind1_buffer[];
   double ind2_buffer[];
   double Close[];
   int   h_ind1=iBands(smbl,PERIOD_M1,20,0,2,PRICE_CLOSE);
   if(CopyBuffer(h_ind1,0,shift,3,ind1_buffer)<3)         return(0);
   if(CopyBuffer(h_ind1,1,shift,3,ind2_buffer)<3)         return(0);
   if(!ArraySetAsSeries(ind1_buffer,true))         return(0);
   if(!ArraySetAsSeries(ind2_buffer,true))         return(0);
   if(CopyClose(Symbol(),Period(),0,3,Close)<2) return(0);
   if(!ArraySetAsSeries(Close,true)) return(0);
   if(Close[2]<=ind2_buffer[1] && Close[1]>ind2_buffer[1])
      sig=1;
   else if(Close[2]>=ind1_buffer[1] && Close[1]<ind1_buffer[1])
                     sig=-1;
   else sig=0;
   IndicatorRelease(h_ind1);
//--- возвращаем торговый сигнал
   return(sig);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CNRTR:public COracleEasy
  {
   virtual double    forecast(string smbl="",int shift=0,bool train=false);
   virtual string    Name(){return("NRTR");};
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CNRTR::forecast(string smbl="",int shift=0,bool train=false)
  {

   double sig=0;
   if(""==smbl) smbl=Symbol();
   double ind1_buffer[];
   double ind2_buffer[];

   int   h_ind1=iCustom(smbl,PERIOD_M1,"NRTR",40,2.0);
   if(CopyBuffer(h_ind1,0,shift,3,ind1_buffer)<3)         return(0);
   if(CopyBuffer(h_ind1,1,shift,3,ind2_buffer)<3)         return(0);
   if(!ArraySetAsSeries(ind1_buffer,true))         return(0);
   if(!ArraySetAsSeries(ind2_buffer,true))         return(0);

   if(ind1_buffer[1]>0) sig=1;
   else if(ind2_buffer[1]>0) sig=-1;
   else sig=0;
   IndicatorRelease(h_ind1);
//--- возвращаем торговый сигнал
   return(sig);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CiAlligator:public COracleEasy
  {
   virtual double    forecast(string smbl="",int shift=0,bool train=false);
   virtual string    Name(){return("iAlligator");};
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CiAlligator::forecast(string smbl="",int shift=0,bool train=false)
  {

   double sig=0;
   if(""==smbl) smbl=Symbol();
   double ind1_buffer[];
   double ind2_buffer[];
   double ind3_buffer[];
   int   h_ind1=iAlligator(smbl,PERIOD_M1,13,0,8,0,5,0,MODE_SMMA,PRICE_MEDIAN);
   if(CopyBuffer(h_ind1,0,shift,3,ind1_buffer)<3)         return(0);
   if(CopyBuffer(h_ind1,1,shift,3,ind2_buffer)<3)         return(0);
   if(CopyBuffer(h_ind1,2,shift,3,ind3_buffer)<3)         return(0);
   if(!ArraySetAsSeries(ind1_buffer,true))         return(0);
   if(!ArraySetAsSeries(ind2_buffer,true))         return(0);
   if(!ArraySetAsSeries(ind3_buffer,true))         return(0);

   if(ind3_buffer[1]>ind2_buffer[1] && ind2_buffer[1]>ind1_buffer[1])
      sig=1;
   else if(ind3_buffer[1]<ind2_buffer[1] && ind2_buffer[1]<ind1_buffer[1])
      sig=-1;
   else sig=0;
   IndicatorRelease(h_ind1);
//--- возвращаем торговый сигнал
   return(sig);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CiAMA:public COracleEasy
  {
   virtual double    forecast(string smbl="",int shift=0,bool train=false);
   virtual string    Name(){return("iAMA");};
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CiAMA::forecast(string smbl="",int shift=0,bool train=false)
  {

   double sig=0;
   if(""==smbl) smbl=Symbol();
   double ind1_buffer[];
   int   h_ind1=iAMA(smbl,PERIOD_M1,9,2,30,0,PRICE_CLOSE);
   if(CopyBuffer(h_ind1,0,shift,3,ind1_buffer)<3) return(0);
   if(!ArraySetAsSeries(ind1_buffer,true)) return(0);

   if(ind1_buffer[2]<ind1_buffer[1])
      sig=1;
   else if(ind1_buffer[2]>ind1_buffer[1])
      sig=-1;
   else sig=0;
   IndicatorRelease(h_ind1);
//--- возвращаем торговый сигнал
   return(sig);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CiAO:public COracleEasy
  {
   virtual double    forecast(string smbl="",int shift=0,bool train=false);
   virtual string    Name(){return("iAO");};
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CiAO::forecast(string smbl="",int shift=0,bool train=false)
  {

   double sig=0;
   if(""==smbl) smbl=Symbol();
   double ind1_buffer[];
   int   h_ind1=iAO(smbl,PERIOD_M1);
   if(CopyBuffer(h_ind1,0,shift,3,ind1_buffer)<3) return(0);
   if(!ArraySetAsSeries(ind1_buffer,true)) return(0);

   if(ind1_buffer[1]==0)
      sig=1;
   else if(ind1_buffer[1]==1)
      sig=-1;
   else sig=0;
   IndicatorRelease(h_ind1);
//--- возвращаем торговый сигнал
   return(sig);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CiIchimoku:public COracleEasy
  {
   virtual double    forecast(string smbl="",int shift=0,bool train=false);
   virtual string    Name(){return("iIchimoku");};
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CiIchimoku::forecast(string smbl="",int shift=0,bool train=false)
  {

   double sig=0;
   if(""==smbl) smbl=Symbol();
   double ind1_buffer[];
   double ind2_buffer[];
   int   h_ind1=iIchimoku(smbl,PERIOD_M1,9,26,52);
   if(CopyBuffer(h_ind1,0,shift,3,ind1_buffer)<3) return(0);
   if(!ArraySetAsSeries(ind1_buffer,true)) return(0);
   if(CopyBuffer(h_ind1,1,shift,3,ind2_buffer)<3) return(0);
   if(!ArraySetAsSeries(ind2_buffer,true)) return(0);

   if(ind1_buffer[1]>ind2_buffer[1])
      sig=1;
   else if(ind1_buffer[1]<ind2_buffer[1])
      sig=-1;
   else sig=0;
   IndicatorRelease(h_ind1);
//--- возвращаем торговый сигнал
   return(sig);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CiEnvelopes:public COracleEasy
  {
   virtual double    forecast(string smbl="",int shift=0,bool train=false);
   virtual string    Name(){return("iEnvelopes");};
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CiEnvelopes::forecast(string smbl="",int shift=0,bool train=false)
  {

   double sig=0;
   if(""==smbl) smbl=Symbol();
   double ind1_buffer[];
   double ind2_buffer[];
   double Close[];
   int   h_ind1=iEnvelopes(smbl,PERIOD_M1,28,0,MODE_SMA,PRICE_CLOSE,0.1);
   if(CopyBuffer(h_ind1,0,shift,3,ind1_buffer)<3)         return(0);
   if(CopyBuffer(h_ind1,1,shift,3,ind2_buffer)<3)         return(0);
   if(!ArraySetAsSeries(ind1_buffer,true))         return(0);
   if(!ArraySetAsSeries(ind2_buffer,true))         return(0);
   if(CopyClose(Symbol(),Period(),0,3,Close)<2) return(0);
   if(!ArraySetAsSeries(Close,true)) return(0);

   if(Close[2]<=ind2_buffer[1] && Close[1]>ind2_buffer[1])
      sig=1;
   else if(Close[2]>=ind1_buffer[1] && Close[1]<ind1_buffer[1])
                     sig=-1;
   else sig=0;
   IndicatorRelease(h_ind1);
//--- возвращаем торговый сигнал
   return(sig);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class COracleANN:public COracleEasy
  {
private:
   string            Symbol;
   string            Functions_Array[50];
   int               Functions_Count[50];
   //int               Max_Functions;
   ENUM_TIMEFRAMES   TimeFrame;
   string            File_Name;
   bool              WithNews;
   bool              WithHours;
   bool              WithDayOfWeek;

public:
   bool              ClearTraning;
   double            InputVector[];
   double            OutputVector[];
                     COracleANN(){Init();}
                    ~COracleANN(){DeInit();}
   bool              GetVector(string smbl="",int shift=0,bool train=false);
   bool              debug;
   virtual void      Init();
   //   virtual void              DeInit();
   //   virtual double    forecast(string smbl="",int shift=0,bool train=false);
   bool              Load(string file_name);
   bool              Save(string file_name="");
   //   int               ExportFANNDataWithTest(int train_qty,int test_qty,string &SymbolsArray[],string FileName="");
   //   int               ExportFANNData(int qty,int shift,string &SymbolsArray[],string FileName,bool test=false);
   int               ExportDataWithTest(int train_qty,int test_qty,string &SymbolsArray[],string FileName="");
   int               ExportData(int qty,int shift,string &SymbolsArray[],string FileName,bool test=false);
   virtual bool      CustomLoad(int file_handle){return(false);};
   virtual bool      CustomSave(int file_handle){return(false);};
   virtual bool      Draw(int window,datetime &time[],int w,int h){return(true);};
   int               num_input();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//int COracleANN::ExportFANNDataWithTest(int train_qty,int test_qty,string &Symbols_Array[],string FileName="")
//  {
//   if(""==FileName) FileName=File_Name;
//   int shift=0;
//// test
//   shift=ExportFANNData(test_qty,shift,Symbols_Array,FileName+"_test.test",true);
//   shift=ExportFANNData(train_qty,shift,Symbols_Array,FileName+"_train.train",false);
//// чето ниже не работает :(
////   FileCopy(FileName+"_test.test",FILE_COMMON,FileName+"_test.dat",FILE_REWRITE);
////   FileCopy(FileName+"_train.train",FILE_COMMON,FileName+"_train.dat",FILE_REWRITE);
////\
//   return(shift);
//  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int COracleANN::ExportDataWithTest(int train_qty,int test_qty,string &Symbols_Array[],string FileName="")
  {
   if(""==FileName) FileName=File_Name;
   int shift=0;
// test
   shift=ExportData(test_qty,shift,Symbols_Array,FileName+"_test",true);
   shift=ExportData(train_qty,shift,Symbols_Array,FileName+"_train",false);
// чето ниже не работает :(
//   FileCopy(FileName+"_test.test",FILE_COMMON,FileName+"_test.dat",FILE_REWRITE);
//   FileCopy(FileName+"_train.train",FILE_COMMON,FileName+"_train.dat",FILE_REWRITE);
//\
   return(shift);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//int COracleANN::ExportFANNData(int qty,int shift,string &Symbols_Array[],string FileName,bool test)
//  {
//   int i,ma;
//   int FileHandle=0;
//   int needcopy=0;
//   int copied=0;
//
//// временно!
//   test=false;
////\
//
//   string outstr;
//   FileHandle=FileOpen(FileName,FILE_WRITE|FILE_ANSI|FILE_TXT,' ');
//   needcopy=qty;int Max_Symbols=0;
//   for(ma=0;ma<ArraySize(Symbols_Array);ma++) if(StringLen(Symbols_Array[ma])!=0)Max_Symbols++;
////GNGAlgorithm.forecast(SymbolsArray[ma],i,true);
//
//   if(FileHandle!=INVALID_HANDLE)
//     {// записываем в файл шапку
//      FileWrite(FileHandle,Max_Symbols*needcopy*((test)?1:2),num_input(),1);
//      for(ma=0;ma<Max_Symbols;ma++)
//        {
//         Comment("Export ..."+FileName+" "+(string)((int)(100*((double)(1+ma)/Max_Symbols)))+"%");
//         for(i=0;i<needcopy;shift++)
//           {
//            if(GetVector(Symbols_Array[ma],shift,true))
//              {
//               i++;
//
//               outstr="";
//               for(int ibj=0;ibj<num_input();ibj++)
//                 {
//                  outstr=outstr+(string)(InputVector[ibj])+" ";
//                 }
//               FileWrite(FileHandle,outstr);       // 
//               outstr="";
//               for(int ibj=0;ibj<1;ibj++)
//                 {
//                  outstr=outstr+(string)(OutputVector[ibj])+" ";
//                 }
//               FileWrite(FileHandle,outstr);       // 
//                                                   //if(test) continue;
//               //// сделаем еще и симметричный дубль
//               //outstr="";
//               //for(int ibj=0;ibj<num_input();ibj++)
//               //  {
//               //   outstr=outstr+(string)(InputVector[ibj])+" ";
//               //  }
//               //FileWrite(FileHandle,outstr);       // 
//               //outstr="";
//               //for(int ibj=0;ibj<1;ibj++)
//               //  {
//               //   outstr=outstr+(string)(OutputVector[ibj])+" ";
//               //  }
//               //FileWrite(FileHandle,outstr);       // 
//
//              }
//           }
//        }
//     }
//   FileClose(FileHandle);
//   Print("Created file "+FileName);
//   return(shift);
//  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int COracleANN::ExportData(int qty,int shift,string &Symbols_Array[],string FileName,bool test)
  {
   int i,ma;
   int FileHandle=0;
   int FileHandleFANN=0;
   int needcopy=0;
   int copied=0;

// временно!
   test=false;
//\

   string outstr,trainstrstr;
   FileHandle=FileOpen(FileName+".csv",FILE_WRITE|FILE_ANSI|FILE_CSV,' ');
   FileHandleFANN=FileOpen(FileName+".dat",FILE_WRITE|FILE_ANSI|FILE_TXT,' ');
   needcopy=qty;int Max_Symbols=0;
   for(ma=0;ma<ArraySize(Symbols_Array);ma++) if(StringLen(Symbols_Array[ma])!=0)Max_Symbols++;
//GNGAlgorithm.forecast(SymbolsArray[ma],i,true);

   if(FileHandle!=INVALID_HANDLE && FileHandleFANN!=INVALID_HANDLE)
     {// записываем в файл шапку
      FileWrite(FileHandleFANN,Max_Symbols*needcopy*((test)?1:2),num_input(),1);
      //     FileWrite(FileHandle,Max_Symbols*needcopy*((test)?1:2),num_input(),1);
      for(ma=0;ma<Max_Symbols;ma++)
        {
         Comment("Export ..."+FileName+" "+(string)((int)(100*((double)(1+ma)/Max_Symbols)))+"%");
         for(i=0;i<needcopy;shift++)
           {
            if(GetVector(Symbols_Array[ma],shift,true))
              {
               i++;
               outstr="";
               for(int ibj=0;ibj<num_input();ibj++)
                 {
                  outstr=outstr+(string)(InputVector[ibj])+" ";
                 }
               FileWrite(FileHandleFANN,outstr);       // 
               trainstrstr="";
               for(int ibj=0;ibj<1;ibj++)
                 {
                  trainstrstr=trainstrstr+(string)(OutputVector[ibj])+" ";
                 }
               FileWrite(FileHandle,outstr+trainstrstr);       // 
               FileWrite(FileHandleFANN,trainstrstr);       // 
                                                            //if(test) continue;
               //// сделаем еще и симметричный дубль
               //outstr="";
               //for(int ibj=0;ibj<num_input();ibj++)
               //  {
               //   outstr=outstr+(string)(InputVector[ibj])+" ";
               //  }
               ////FileWrite(FileHandle,outstr);       // 
               ////outstr="";
               //for(int ibj=0;ibj<1;ibj++)
               //  {
               //   outstr=outstr+(string)(OutputVector[ibj])+" ";
               //  }
               //FileWrite(FileHandle,outstr);       // 

              }
           }
        }
     }
   FileClose(FileHandle);
   FileClose(FileHandleFANN);
   Print("Created file "+FileName);
   return(shift);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COracleANN::GetVector(string smbl="",int shift=0,bool train=false)
  {// пара, период, смещение назад (для индикатора полезно)
   double IB[],OB[];
   ArrayResize(IB,num_input()+2);
   ArrayResize(OB,1+2);
   ArrayResize(InputVector,num_input());
   ArrayResize(OutputVector,3);
   int FunctionsIdx;
//int n_vectors=num_input();
   int n_o_vectors=1;
   int pos_in=0,pos_out=0,i;
   if(""==smbl) smbl=_Symbol;
   if(WithHours || WithDayOfWeek)
     {
      MqlRates rates[];
      ArraySetAsSeries(rates,true);
      MqlDateTime tm;
      CopyRates(smbl,PERIOD_M1,shift,3,rates);
      TimeToStruct(rates[1].time,tm);
      if(WithDayOfWeek) InputVector[pos_in++]=((double)tm.day_of_week/7);
      if(WithDayOfWeek) InputVector[pos_in++]=((double)tm.hour/24);
     }
   if(!train)n_o_vectors=0;

//n_vectors=(n_vectors-pos_in);
   for(FunctionsIdx=0; FunctionsIdx<10;FunctionsIdx++)
     {
      if(GetVectors(IB,OB,Functions_Count[FunctionsIdx],0,Functions_Array[FunctionsIdx],smbl,PERIOD_M1,shift))
        {
         // приведем к общему знаменателю
         double si=1;
         //            for(i=0;i<Functions_Count[FunctionsIdx];i++) si+=IB[i]*IB[i]; si=MathSqrt(si);
         for(i=0;i<Functions_Count[FunctionsIdx];i++) InputVector[pos_in++]=IB[i]/si;

         // for(i=0;i<n_o_vectors;i++)
         //   {
         //    OutputVector[i]=OB[i];
         //    if(OB[i]<-3) OutputVector[i]=-0.5;
         //    if(OB[i]>3) OutputVector[i]=0.5;
         //    //OutputVector[i]=1*(1/(1+MathExp(-1*OB[i]/5))-0.5);
         //   }
        }
     }
   if(train && GetVectors(IB,OB,0,n_o_vectors,"",smbl,PERIOD_M1,shift))
     {
      for(i=0;i<n_o_vectors;i++)
        {
         OutputVector[i]=OB[i];
         //if(OB[i]<-3) OutputVector[i]=-0.5;
         //if(OB[i]>3) OutputVector[i]=0.5;
         //OutputVector[i]=1*(1/(1+MathExp(-1*OB[i]/5))-0.5);
        }

     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int COracleANN::num_input(void)
  {
   int ret=0;
   for(int i=0;i<20;i++) ret+=Functions_Count[i];
   return(ret);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COracleANN::Save(string file_name)
  {
   if(""==file_name) file_name=File_Name;
   int file_handle;  string outstr="";

   file_handle=FileOpen(file_name+".gc_oracle",FILE_WRITE|FILE_ANSI|FILE_TXT,"= ");
// сделаем шаблончик
   if(file_handle!=INVALID_HANDLE)
     {
      FileWriteString(file_handle,"[Common]\n");
      FileWriteString(file_handle,"LastStart="+(string)TimeCurrent()+"\n");

      FileWriteString(file_handle,"[FunctionsArray]\n");
      int i;
      i=0;
      while(Functions_Array[i]!="")
        {
         FileWriteString(file_handle,Functions_Array[i]+"="+(string)Functions_Count[i]+"\n");
         i++;
        }
      FileWriteString(file_handle,"[Custom]\n");
      CustomSave(file_handle);
      FileClose(file_handle);
      return(true);
     }
   else return(false);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COracleANN::Load(string file_name)
  {
   int file_handle;  string outstr="";   int i=0,sp;
   File_Name=file_name;
   file_handle=FileOpen(file_name+".gc_oracle",FILE_READ|FILE_ANSI|FILE_TXT,"= ");

   if(file_handle!=INVALID_HANDLE)
     {
      outstr=FileReadString(file_handle);//   [Common]
      outstr=FileReadString(file_handle);//   LastStart
      while(outstr!="[FunctionsArray]"){outstr=FileReadString(file_handle);}
      outstr=FileReadString(file_handle);
      while(outstr!="[Custom]" && outstr!="")
        {
         sp=1+StringFind(outstr,"=");
         for(i=0;i<50;i++)
           {
            if(Functions_Array[i]==StringSubstr(outstr,0,sp-1)) Functions_Count[i]=(int)StringToInteger(StringSubstr(outstr,sp));;
           }
         outstr=FileReadString(file_handle);
        }
      if(outstr=="[Custom]") CustomLoad(file_handle);
      FileClose(file_handle);
      return(true);
     }
   else
     {
      Print("Файл не найден в папке "+TerminalInfoString(TERMINAL_DATA_PATH));
      return(false);
     }
  };
//+------------------------------------------------------------------+
void COracleANN::Init()
  {
   ClearTraning=false;
   debug=false;
   WithNews = false;
   WithHours= false;
   WithDayOfWeek=false;
   int i;
   for(i=0;i<10;i++)
     {
      Functions_Array[i]=VectorFunctions[i];
      Functions_Count[i]=0;
     }
   TimeFrame=_Period;
  }
//+------------------------------------------------------------------+

class CDummy:public COracleEasy
  {
public:
   virtual double    forecast(string smbl="",int shift=0,bool train=false);
   virtual string    Name(){return("iEnvelopes");};
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CDummy::forecast(string smbl="",int shift=0,bool train=false)
  {

   double sig=0;
   if(""==smbl) smbl=Symbol();
   MqlRates rates[];
   ArraySetAsSeries(rates,true);
   int copied=CopyRates(_Symbol,_Period,shift,3,rates);
   datetime time=rates[0].time;
   if(debug)Print(time);
   if(_Symbol!="USDJPY") return(0);
   if(time==StringToTime("2011.01.07 22:59:00")) return(0.1642857142857882);
   if(time==StringToTime("2011.01.07 22:58:00")) return(0.2000000000000414);
   if(time==StringToTime("2011.01.07 22:57:00")) return(0.1928571428571502);
   if(time==StringToTime("2011.01.07 22:56:00")) return(0.1571428571428969);
   if(time==StringToTime("2011.01.07 22:52:00")) return(-0.2714285714285479);
   if(time==StringToTime("2011.01.07 19:35:00")) return(0.1428571428572159);
   if(time==StringToTime("2011.01.07 19:34:00")) return(0.1928571428571502);
   if(time==StringToTime("2011.01.07 19:33:00")) return(0.1642857142857882);
   if(time==StringToTime("2011.01.07 19:32:00")) return(0.1642857142857882);
   if(time==StringToTime("2011.01.07 19:31:00")) return(0.2714285714286494);
   if(time==StringToTime("2011.01.07 18:51:00")) return(-0.2071428571428312);
   if(time==StringToTime("2011.01.07 18:46:00")) return(-0.5000000000000527);
   if(time==StringToTime("2011.01.07 18:45:00")) return(-0.535714285714306);
   if(time==StringToTime("2011.01.07 18:44:00")) return(-0.5500000000000884);
   if(time==StringToTime("2011.01.07 18:43:00")) return(-0.4500000000000171);
   if(time==StringToTime("2011.01.07 18:42:00")) return(-0.5428571428571972);
   if(time==StringToTime("2011.01.07 18:41:00")) return(0.1928571428571502);
   if(time==StringToTime("2011.01.07 18:38:00")) return(0.1000000000000715);
   if(time==StringToTime("2011.01.07 18:37:00")) return(0.1714285714285779);
   if(time==StringToTime("2011.01.07 18:36:00")) return(0.1000000000000715);
   if(time==StringToTime("2011.01.07 18:35:00")) return(0.1500000000000057);
   if(time==StringToTime("2011.01.07 18:23:00")) return(0.1071428571428612);
   if(time==StringToTime("2011.01.07 18:19:00")) return(0.1500000000000057);
   if(time==StringToTime("2011.01.07 18:18:00")) return(0.1285714285714334);
   if(time==StringToTime("2011.01.07 18:17:00")) return(0.1214285714286437);
   if(time==StringToTime("2011.01.07 18:16:00")) return(0.2071428571429327);
   if(time==StringToTime("2011.01.07 18:13:00")) return(-0.3571428571428368);
   if(time==StringToTime("2011.01.07 18:12:00")) return(-0.2857142857142289);
   if(time==StringToTime("2011.01.07 18:11:00")) return(-0.2857142857142289);
   if(time==StringToTime("2011.01.07 18:10:00")) return(-0.2571428571427654);
   if(time==StringToTime("2011.01.07 18:09:00")) return(-0.3857142857141988);
   if(time==StringToTime("2011.01.07 18:08:00")) return(-0.4571428571428068);
   if(time==StringToTime("2011.01.07 18:07:00")) return(-0.4428571428571259);
   if(time==StringToTime("2011.01.07 18:06:00")) return(-0.5857142857142402);
   if(time==StringToTime("2011.01.07 18:01:00")) return(0.1000000000000715);
   if(time==StringToTime("2011.01.07 18:00:00")) return(0.1214285714286437);
   if(time==StringToTime("2011.01.07 17:35:00")) return(-0.5357142857142045);
   if(time==StringToTime("2011.01.07 17:34:00")) return(-0.5499999999999871);
   if(time==StringToTime("2011.01.07 17:33:00")) return(-0.4214285714285536);
   if(time==StringToTime("2011.01.07 17:32:00")) return(-0.4142857142856623);
   if(time==StringToTime("2011.01.07 17:31:00")) return(-0.3499999999999456);
   if(time==StringToTime("2011.01.07 17:30:00")) return(-0.3142857142856924);
   if(time==StringToTime("2011.01.07 17:28:00")) return(0.1214285714285422);
   if(time==StringToTime("2011.01.07 17:27:00")) return(0.1071428571428612);
   if(time==StringToTime("2011.01.07 17:24:00")) return(0.2928571428571201);
   if(time==StringToTime("2011.01.07 17:23:00")) return(0.3714285714285178);
   if(time==StringToTime("2011.01.07 17:22:00")) return(0.6428571428571672);
   if(time==StringToTime("2011.01.07 17:21:00")) return(0.6285714285713847);
   if(time==StringToTime("2011.01.07 17:19:00")) return(-0.2571428571428669);
   if(time==StringToTime("2011.01.07 17:18:00")) return(-0.3857142857143003);
   if(time==StringToTime("2011.01.07 17:17:00")) return(-0.3000000000000114);
   if(time==StringToTime("2011.01.07 17:16:00")) return(-0.3142857142856924);
   if(time==StringToTime("2011.01.07 17:15:00")) return(-0.3071428571428011);
   if(time==StringToTime("2011.01.07 17:14:00")) return(0.2142857142857224);
   if(time==StringToTime("2011.01.07 17:13:00")) return(-0.2285714285714034);
   if(time==StringToTime("2011.01.07 17:12:00")) return(0.3142857142856924);
   if(time==StringToTime("2011.01.07 17:09:00")) return(-0.4071428571428726);
   if(time==StringToTime("2011.01.07 17:08:00")) return(-0.3428571428571559);
   if(time==StringToTime("2011.01.07 17:07:00")) return(-0.564285714285668);
   if(time==StringToTime("2011.01.07 17:06:00")) return(-0.7785714285713904);
   if(time==StringToTime("2011.01.07 17:05:00")) return(-0.7357142857142459);
   if(time==StringToTime("2011.01.07 17:04:00")) return(-0.6642857142857395);
   if(time==StringToTime("2011.01.07 17:03:00")) return(0.5500000000000884);
   if(time==StringToTime("2011.01.07 17:02:00")) return(0.6500000000000584);
   if(time==StringToTime("2011.01.07 17:01:00")) return(0.5928571428572329);
   if(time==StringToTime("2011.01.07 17:00:00")) return(0.621428571428595);
   if(time==StringToTime("2011.01.07 16:59:00")) return(0.7928571428571729);
   if(time==StringToTime("2011.01.07 16:58:00")) return(-0.2000000000000414);
   if(time==StringToTime("2011.01.07 16:57:00")) return(-0.1857142857142589);
   if(time==StringToTime("2011.01.07 16:55:00")) return(-0.2714285714285479);
   if(time==StringToTime("2011.01.07 16:53:00")) return(0.1214285714285422);
   if(time==StringToTime("2011.01.07 16:52:00")) return(0.1000000000000715);
   if(time==StringToTime("2011.01.07 16:51:00")) return(0.2071428571429327);
   if(time==StringToTime("2011.01.07 16:49:00")) return(0.114285714285651);
   if(time==StringToTime("2011.01.07 16:48:00")) return(0.2499999999999756);
   if(time==StringToTime("2011.01.07 16:47:00")) return(0.1857142857142589);
   if(time==StringToTime("2011.01.07 16:46:00")) return(0.1928571428570486);
   if(time==StringToTime("2011.01.07 16:41:00")) return(0.2000000000000414);
   if(time==StringToTime("2011.01.07 16:40:00")) return(0.2357142857142947);
   if(time==StringToTime("2011.01.07 16:38:00")) return(0.1642857142856867);
   if(time==StringToTime("2011.01.07 16:37:00")) return(0.2928571428571201);
   if(time==StringToTime("2011.01.07 16:35:00")) return(-0.1428571428571144);
   if(time==StringToTime("2011.01.07 16:34:00")) return(-0.2214285714285122);
   if(time==StringToTime("2011.01.07 16:33:00")) return(-0.2499999999999756);
   if(time==StringToTime("2011.01.07 16:32:00")) return(-0.4857142857142703);
   if(time==StringToTime("2011.01.07 16:31:00")) return(-0.6214285714284935);
   if(time==StringToTime("2011.01.07 16:30:00")) return(-0.635714285714276);
   if(time==StringToTime("2011.01.07 16:14:00")) return(-0.1642857142856867);
   if(time==StringToTime("2011.01.07 16:13:00")) return(-0.1857142857142589);
   if(time==StringToTime("2011.01.07 16:12:00")) return(-0.1071428571428612);
   if(time==StringToTime("2011.01.07 16:09:00")) return(-0.5214285714285235);
   if(time==StringToTime("2011.01.07 16:08:00")) return(-0.4857142857142703);
   if(time==StringToTime("2011.01.07 16:07:00")) return(-0.5928571428571315);
   if(time==StringToTime("2011.01.07 16:06:00")) return(-0.7999999999999626);
   if(time==StringToTime("2011.01.07 16:05:00")) return(-0.7785714285713904);
   if(time==StringToTime("2011.01.07 16:04:00")) return(-0.7500000000000284);
   if(time==StringToTime("2011.01.07 16:03:00")) return(-0.7642857142857095);
   if(time==StringToTime("2011.01.07 16:02:00")) return(-0.9142857142857152);
   if(time==StringToTime("2011.01.07 16:01:00")) return(0.1071428571428612);
   if(time==StringToTime("2011.01.07 15:59:00")) return(0.1214285714285422);
   if(time==StringToTime("2011.01.07 15:58:00")) return(0.1357142857142232);
   if(time==StringToTime("2011.01.07 15:51:00")) return(0.1000000000000715);
   if(time==StringToTime("2011.01.07 15:50:00")) return(0.3142857142857939);
   if(time==StringToTime("2011.01.07 15:49:00")) return(0.3285714285714748);
   if(time==StringToTime("2011.01.07 15:48:00")) return(0.1000000000000715);
   if(time==StringToTime("2011.01.07 15:44:00")) return(0.1214285714285422);
   if(time==StringToTime("2011.01.07 15:41:00")) return(0.1357142857142232);
   if(time==StringToTime("2011.01.07 15:40:00")) return(0.4142857142856623);
   if(time==StringToTime("2011.01.07 15:39:00")) return(-0.3714285714286193);
   if(time==StringToTime("2011.01.07 15:38:00")) return(-0.1785714285714692);
   if(time==StringToTime("2011.01.07 15:37:00")) return(-0.2214285714286136);
   if(time==StringToTime("2011.01.07 15:36:00")) return(-0.3714285714286193);
   if(time==StringToTime("2011.01.07 15:35:00")) return(0.5071428571428426);
   if(time==StringToTime("2011.01.07 15:34:00")) return(0.5285714285714148);
   if(time==StringToTime("2011.01.07 15:33:00")) return(0.5428571428571972);
   if(time==StringToTime("2011.01.07 15:32:00")) return(0.7714285714286007);
   if(time==StringToTime("2011.01.07 15:31:00")) return(1.24999999999998);
   if(time==StringToTime("2011.01.07 15:30:00")) return(1.099999999999974);
   if(time==StringToTime("2011.01.07 15:29:00")) return(-0.9857142857143231);
   if(time==StringToTime("2011.01.07 15:28:00")) return(-0.9928571428571129);
   if(time==StringToTime("2011.01.07 15:27:00")) return(-1.042857142857149);
   if(time==StringToTime("2011.01.07 15:26:00")) return(-1.114285714285757);
   if(time==StringToTime("2011.01.07 15:25:00")) return(-1.064285714285721);
   if(time==StringToTime("2011.01.07 15:24:00")) return(-1.021428571428576);
   if(time==StringToTime("2011.01.07 15:23:00")) return(-1.24285714285719);
   if(time==StringToTime("2011.01.07 15:22:00")) return(0.1500000000000057);
   if(time==StringToTime("2011.01.07 15:21:00")) return(0.1071428571428612);
   if(time==StringToTime("2011.01.07 15:17:00")) return(0.2714285714285479);
   if(time==StringToTime("2011.01.07 15:16:00")) return(0.8999999999999325);
   if(time==StringToTime("2011.01.07 15:15:00")) return(0.8999999999999325);
   if(time==StringToTime("2011.01.07 15:14:00")) return(1.078571428571402);
   if(time==StringToTime("2011.01.07 15:13:00")) return(1.035714285714257);
   if(time==StringToTime("2011.01.07 15:12:00")) return(1.178571428571372);
   if(time==StringToTime("2011.01.07 15:11:00")) return(1.042857142857047);
   if(time==StringToTime("2011.01.07 15:09:00")) return(-0.3214285714285836);
   if(time==StringToTime("2011.01.07 15:08:00")) return(-0.2071428571428312);
   if(time==StringToTime("2011.01.07 15:06:00")) return(-0.1357142857143247);
   if(time==StringToTime("2011.01.07 15:04:00")) return(-0.1142857142857525);
   if(time==StringToTime("2011.01.07 15:03:00")) return(-0.3142857142857939);
   if(time==StringToTime("2011.01.07 15:02:00")) return(-0.2214285714286136);
   if(time==StringToTime("2011.01.07 15:01:00")) return(0.3857142857143003);
   if(time==StringToTime("2011.01.07 15:00:00")) return(0.6071428571429139);
   if(time==StringToTime("2011.01.07 14:59:00")) return(0.635714285714276);
   if(time==StringToTime("2011.01.07 14:58:00")) return(0.535714285714306);
   if(time==StringToTime("2011.01.07 14:57:00")) return(-0.2785714285714391);
   if(time==StringToTime("2011.01.07 14:56:00")) return(-0.6000000000000227);
   if(time==StringToTime("2011.01.07 14:55:00")) return(-0.7928571428571729);
   if(time==StringToTime("2011.01.07 14:54:00")) return(-0.9071428571428239);
   if(time==StringToTime("2011.01.07 14:53:00")) return(0.4785714285714805);
   if(time==StringToTime("2011.01.07 14:52:00")) return(0.8571428571428896);
   if(time==StringToTime("2011.01.07 14:51:00")) return(-1.071428571428612);
   if(time==StringToTime("2011.01.07 14:50:00")) return(-1.064285714285721);
   if(time==StringToTime("2011.01.07 14:49:00")) return(0.3571428571428368);
   if(time==StringToTime("2011.01.07 14:48:00")) return(-0.8285714285714262);
   if(time==StringToTime("2011.01.07 14:47:00")) return(-1.121428571428546);
   if(time==StringToTime("2011.01.07 14:46:00")) return(-1.171428571428582);
   if(time==StringToTime("2011.01.07 14:45:00")) return(0.4142857142856623);
   if(time==StringToTime("2011.01.07 14:44:00")) return(-0.3285714285713733);
   if(time==StringToTime("2011.01.07 14:43:00")) return(-0.8142857142856436);
   if(time==StringToTime("2011.01.07 14:42:00")) return(-0.5714285714285593);
   if(time==StringToTime("2011.01.07 14:41:00")) return(0.5785714285714505);
   if(time==StringToTime("2011.01.07 14:40:00")) return(1.064285714285721);
   if(time==StringToTime("2011.01.07 14:39:00")) return(-0.5285714285714148);
   if(time==StringToTime("2011.01.07 14:38:00")) return(-0.535714285714306);
   if(time==StringToTime("2011.01.07 14:37:00")) return(0.6285714285714862);
   if(time==StringToTime("2011.01.07 14:36:00")) return(-0.7071428571428839);
   if(time==StringToTime("2011.01.07 14:35:00")) return(-0.9285714285713962);
   if(time==StringToTime("2011.01.07 14:34:00")) return(-1.042857142857149);
   if(time==StringToTime("2011.01.07 14:33:00")) return(1.257142857142871);
   if(time==StringToTime("2011.01.07 14:32:00")) return(1.771428571428605);
   if(time==StringToTime("2011.01.07 14:31:00")) return(-0.8642857142857808);
   if(time==StringToTime("2011.01.07 14:30:00")) return(0.9214285714286064);
   if(time==StringToTime("2011.01.07 14:29:00")) return(-4.485714285714286);
   if(time==StringToTime("2011.01.07 14:28:00")) return(-4.850000000000014);
   if(time==StringToTime("2011.01.07 14:27:00")) return(-4.807142857142869);
   if(time==StringToTime("2011.01.07 14:26:00")) return(-4.735714285714364);
   if(time==StringToTime("2011.01.07 14:25:00")) return(-4.90000000000005);
   if(time==StringToTime("2011.01.07 14:24:00")) return(-4.935714285714303);
   if(time==StringToTime("2011.01.07 14:23:00")) return(-4.750000000000044);
   if(time==StringToTime("2011.01.07 14:22:00")) return(-4.728571428571472);
   if(time==StringToTime("2011.01.07 14:21:00")) return(0.7357142857143474);
   if(time==StringToTime("2011.01.07 14:20:00")) return(0.8642857142857808);
   if(time==StringToTime("2011.01.07 14:19:00")) return(-0.3071428571428011);
   if(time==StringToTime("2011.01.07 14:18:00")) return(-0.3785714285714091);
   if(time==StringToTime("2011.01.07 14:17:00")) return(-0.3214285714285836);
   if(time==StringToTime("2011.01.07 14:16:00")) return(-0.2285714285714034);
   if(time==StringToTime("2011.01.07 14:15:00")) return(0.3000000000000114);
   if(time==StringToTime("2011.01.07 14:14:00")) return(0.4928571428571615);
   if(time==StringToTime("2011.01.07 14:13:00")) return(0.6142857142857038);
   if(time==StringToTime("2011.01.07 14:12:00")) return(0.6071428571428125);
   if(time==StringToTime("2011.01.07 14:08:00")) return(-0.2642857142857581);
   if(time==StringToTime("2011.01.07 14:07:00")) return(-0.1714285714285779);
   if(time==StringToTime("2011.01.07 14:06:00")) return(-0.2500000000000772);
   if(time==StringToTime("2011.01.07 13:58:00")) return(0.114285714285651);
   if(time==StringToTime("2011.01.07 13:55:00")) return(0.114285714285651);
   if(time==StringToTime("2011.01.07 13:52:00")) return(0.1285714285714334);
   if(time==StringToTime("2011.01.07 13:50:00")) return(0.114285714285651);
   if(time==StringToTime("2011.01.07 13:20:00")) return(0.1285714285714334);
   if(time==StringToTime("2011.01.07 13:19:00")) return(0.2928571428571201);
   if(time==StringToTime("2011.01.07 13:18:00")) return(0.2714285714285479);
   if(time==StringToTime("2011.01.07 09:57:00")) return(0.1142857142857525);
   if(time==StringToTime("2011.01.07 09:56:00")) return(0.2499999999999756);
   if(time==StringToTime("2011.01.07 09:55:00")) return(0.2928571428571201);
   if(time==StringToTime("2011.01.07 09:54:00")) return(0.2785714285714391);
   if(time==StringToTime("2011.01.07 09:53:00")) return(0.3642857142857281);
   if(time==StringToTime("2011.01.07 09:52:00")) return(0.3500000000000471);
   if(time==StringToTime("2011.01.07 09:50:00")) return(-0.2857142857143303);
   if(time==StringToTime("2011.01.07 09:49:00")) return(-0.3999999999999813);
   if(time==StringToTime("2011.01.07 09:46:00")) return(0.1714285714285779);
   if(time==StringToTime("2011.01.07 09:43:00")) return(0.1642857142856867);
   if(time==StringToTime("2011.01.07 09:42:00")) return(0.1071428571428612);
   if(time==StringToTime("2011.01.07 07:01:00")) return(0.1999999999999399);
   if(time==StringToTime("2011.01.07 07:00:00")) return(0.3285714285713733);
   if(time==StringToTime("2011.01.07 06:59:00")) return(0.2499999999999756);
   if(time==StringToTime("2011.01.07 06:58:00")) return(0.2499999999999756);
   if(time==StringToTime("2011.01.07 06:57:00")) return(0.478571428571379);
   if(time==StringToTime("2011.01.07 06:56:00")) return(0.5428571428570957);
   if(time==StringToTime("2011.01.07 06:55:00")) return(0.5428571428570957);
   if(time==StringToTime("2011.01.07 05:39:00")) return(-0.1857142857142589);
   if(time==StringToTime("2011.01.07 05:38:00")) return(-0.3142857142856924);
   if(time==StringToTime("2011.01.07 05:37:00")) return(-0.4642857142856981);
   if(time==StringToTime("2011.01.07 05:36:00")) return(-0.5499999999999871);
   if(time==StringToTime("2011.01.07 05:35:00")) return(-0.5428571428570957);
   if(time==StringToTime("2011.01.07 05:34:00")) return(-0.5928571428571315);
   if(time==StringToTime("2011.01.07 05:33:00")) return(-0.3285714285713733);
   if(time==StringToTime("2011.01.07 05:32:00")) return(0.4714285714285893);
   if(time==StringToTime("2011.01.07 05:31:00")) return(0.4142857142857638);
   if(time==StringToTime("2011.01.07 05:30:00")) return(0.6428571428571672);
   if(time==StringToTime("2011.01.07 05:26:00")) return(-0.1142857142857525);
   if(time==StringToTime("2011.01.07 05:25:00")) return(-0.2142857142857224);
   if(time==StringToTime("2011.01.07 05:24:00")) return(-0.2142857142857224);
   if(time==StringToTime("2011.01.06 20:57:00")) return(-0.1214285714285422);
   if(time==StringToTime("2011.01.06 19:59:00")) return(-0.1142857142857525);
   if(time==StringToTime("2011.01.06 19:58:00")) return(-0.1714285714285779);
   if(time==StringToTime("2011.01.06 19:57:00")) return(-0.2642857142857581);
   if(time==StringToTime("2011.01.06 19:56:00")) return(-0.3214285714285836);
   if(time==StringToTime("2011.01.06 19:52:00")) return(0.1785714285714692);
   if(time==StringToTime("2011.01.06 19:51:00")) return(0.3000000000000114);
   if(time==StringToTime("2011.01.06 19:20:00")) return(-0.1142857142857525);
   if(time==StringToTime("2011.01.06 19:16:00")) return(-0.1714285714285779);
   if(time==StringToTime("2011.01.06 18:25:00")) return(-0.3000000000000114);
   if(time==StringToTime("2011.01.06 18:24:00")) return(-0.3428571428571559);
   if(time==StringToTime("2011.01.06 18:23:00")) return(-0.4285714285714448);
   if(time==StringToTime("2011.01.06 18:02:00")) return(0.3071428571428011);
   if(time==StringToTime("2011.01.06 17:57:00")) return(-0.1928571428571502);
   if(time==StringToTime("2011.01.06 17:56:00")) return(-0.2142857142857224);
   if(time==StringToTime("2011.01.06 17:55:00")) return(-0.1428571428571144);
   if(time==StringToTime("2011.01.06 17:54:00")) return(-0.1071428571428612);
   if(time==StringToTime("2011.01.06 17:28:00")) return(-0.1000000000000715);
   if(time==StringToTime("2011.01.06 17:26:00")) return(-0.1071428571428612);
   if(time==StringToTime("2011.01.06 17:20:00")) return(-0.2428571428571859);
   if(time==StringToTime("2011.01.06 17:00:00")) return(0.1285714285714334);
   if(time==StringToTime("2011.01.06 16:58:00")) return(0.635714285714276);
   if(time==StringToTime("2011.01.06 16:57:00")) return(0.8071428571428539);
   if(time==StringToTime("2011.01.06 16:56:00")) return(0.4571428571428068);
   if(time==StringToTime("2011.01.06 16:55:00")) return(0.5571428571427768);
   if(time==StringToTime("2011.01.06 16:54:00")) return(-0.5571428571427768);
   if(time==StringToTime("2011.01.06 16:53:00")) return(-0.721428571428565);
   if(time==StringToTime("2011.01.06 16:52:00")) return(-0.7428571428571372);
   if(time==StringToTime("2011.01.06 16:51:00")) return(-0.6142857142857038);
   if(time==StringToTime("2011.01.06 16:50:00")) return(-0.5357142857142045);
   if(time==StringToTime("2011.01.06 16:49:00")) return(0.3714285714286193);
   if(time==StringToTime("2011.01.06 16:48:00")) return(0.5500000000000884);
   if(time==StringToTime("2011.01.06 16:47:00")) return(0.5928571428572329);
   if(time==StringToTime("2011.01.06 16:46:00")) return(0.635714285714276);
   if(time==StringToTime("2011.01.06 16:45:00")) return(0.6928571428572029);
   if(time==StringToTime("2011.01.06 16:41:00")) return(-0.1214285714285422);
   if(time==StringToTime("2011.01.06 16:40:00")) return(-0.1642857142856867);
   if(time==StringToTime("2011.01.06 16:39:00")) return(-0.1857142857142589);
   if(time==StringToTime("2011.01.06 16:38:00")) return(-0.1642857142856867);
   if(time==StringToTime("2011.01.06 16:33:00")) return(-0.1357142857142232);
   if(time==StringToTime("2011.01.06 16:31:00")) return(-0.1285714285714334);
   if(time==StringToTime("2011.01.06 16:29:00")) return(-0.2285714285714034);
   if(time==StringToTime("2011.01.06 16:28:00")) return(-0.1357142857142232);
   if(time==StringToTime("2011.01.06 16:18:00")) return(-0.3000000000000114);
   if(time==StringToTime("2011.01.06 16:17:00")) return(-0.4642857142856981);
   if(time==StringToTime("2011.01.06 16:16:00")) return(-0.3642857142857281);
   if(time==StringToTime("2011.01.06 16:15:00")) return(-0.635714285714276);
   if(time==StringToTime("2011.01.06 16:14:00")) return(-0.821428571428535);
   if(time==StringToTime("2011.01.06 16:13:00")) return(-0.721428571428565);
   if(time==StringToTime("2011.01.06 16:12:00")) return(0.4642857142856981);
   if(time==StringToTime("2011.01.06 16:11:00")) return(0.5142857142857338);
   if(time==StringToTime("2011.01.06 16:10:00")) return(0.3642857142857281);
   if(time==StringToTime("2011.01.06 16:09:00")) return(-0.3428571428571559);
   if(time==StringToTime("2011.01.06 16:08:00")) return(-0.2357142857142947);
   if(time==StringToTime("2011.01.06 16:07:00")) return(0.2571428571428669);
   if(time==StringToTime("2011.01.06 16:06:00")) return(-0.2214285714286136);
   if(time==StringToTime("2011.01.06 16:05:00")) return(0.2142857142857224);
   if(time==StringToTime("2011.01.06 16:04:00")) return(-0.2785714285714391);
   if(time==StringToTime("2011.01.06 16:03:00")) return(0.3214285714285836);
   if(time==StringToTime("2011.01.06 16:02:00")) return(0.621428571428595);
   if(time==StringToTime("2011.01.06 15:59:00")) return(-0.1071428571428612);
   if(time==StringToTime("2011.01.06 15:57:00")) return(-0.1071428571428612);
   if(time==StringToTime("2011.01.06 15:52:00")) return(-0.2000000000000414);
   if(time==StringToTime("2011.01.06 15:51:00")) return(-0.2000000000000414);
   if(time==StringToTime("2011.01.06 15:50:00")) return(-0.2000000000000414);
   if(time==StringToTime("2011.01.06 15:37:00")) return(-0.1642857142856867);
   if(time==StringToTime("2011.01.06 15:36:00")) return(-0.1714285714285779);
   if(time==StringToTime("2011.01.06 15:35:00")) return(-0.1928571428571502);
   if(time==StringToTime("2011.01.06 15:34:00")) return(-0.2214285714286136);
   if(time==StringToTime("2011.01.06 15:28:00")) return(-0.1285714285714334);
   if(time==StringToTime("2011.01.06 15:27:00")) return(-0.1428571428572159);
   if(time==StringToTime("2011.01.06 15:24:00")) return(-0.3714285714286193);
   if(time==StringToTime("2011.01.06 15:23:00")) return(-0.2214285714286136);
   if(time==StringToTime("2011.01.06 15:16:00")) return(-0.407142857142771);
   if(time==StringToTime("2011.01.06 15:15:00")) return(-0.3857142857141988);
   if(time==StringToTime("2011.01.06 15:14:00")) return(-0.6857142857142102);
   if(time==StringToTime("2011.01.06 15:13:00")) return(-0.6428571428570657);
   if(time==StringToTime("2011.01.06 15:11:00")) return(0.1785714285714692);
   if(time==StringToTime("2011.01.06 15:10:00")) return(0.2285714285714034);
   if(time==StringToTime("2011.01.06 15:09:00")) return(0.2428571428571859);
   if(time==StringToTime("2011.01.06 15:07:00")) return(0.1285714285714334);
   if(time==StringToTime("2011.01.06 15:04:00")) return(0.1785714285713677);
   if(time==StringToTime("2011.01.06 15:03:00")) return(0.3071428571428011);
   if(time==StringToTime("2011.01.06 15:02:00")) return(0.2571428571428669);
   if(time==StringToTime("2011.01.06 15:01:00")) return(0.2499999999999756);
   if(time==StringToTime("2011.01.06 15:00:00")) return(0.1214285714285422);
   if(time==StringToTime("2011.01.06 14:59:00")) return(0.1928571428571502);
   if(time==StringToTime("2011.01.06 14:58:00")) return(0.2499999999999756);
   if(time==StringToTime("2011.01.06 14:53:00")) return(0.1642857142857882);
   if(time==StringToTime("2011.01.06 14:50:00")) return(0.1357142857143247);
   if(time==StringToTime("2011.01.06 14:49:00")) return(0.2214285714286136);
   if(time==StringToTime("2011.01.06 14:36:00")) return(0.1857142857142589);
   if(time==StringToTime("2011.01.06 14:35:00")) return(0.5071428571428426);
   if(time==StringToTime("2011.01.06 14:34:00")) return(0.4571428571428068);
   if(time==StringToTime("2011.01.06 14:33:00")) return(0.649999999999957);
   if(time==StringToTime("2011.01.06 14:32:00")) return(-0.3357142857142646);
   if(time==StringToTime("2011.01.06 14:31:00")) return(0.4714285714285893);
   if(time==StringToTime("2011.01.06 14:30:00")) return(-0.3285714285714748);
   if(time==StringToTime("2011.01.06 14:29:00")) return(-0.6285714285714862);
   if(time==StringToTime("2011.01.06 14:28:00")) return(-0.5071428571428426);
   if(time==StringToTime("2011.01.06 14:27:00")) return(-0.435714285714336);
   if(time==StringToTime("2011.01.06 14:26:00")) return(0.3214285714285836);
   if(time==StringToTime("2011.01.06 14:25:00")) return(0.2214285714286136);
   if(time==StringToTime("2011.01.06 14:24:00")) return(0.3214285714285836);
   if(time==StringToTime("2011.01.06 14:23:00")) return(0.1285714285714334);
   if(time==StringToTime("2011.01.06 14:22:00")) return(0.1500000000000057);
   if(time==StringToTime("2011.01.06 14:14:00")) return(0.1785714285714692);
   if(time==StringToTime("2011.01.06 14:13:00")) return(0.2428571428571859);
   if(time==StringToTime("2011.01.06 14:12:00")) return(0.1071428571428612);
   if(time==StringToTime("2011.01.06 14:04:00")) return(-0.1357142857143247);
   if(time==StringToTime("2011.01.06 14:03:00")) return(-0.1071428571428612);
   if(time==StringToTime("2011.01.06 14:02:00")) return(-0.1428571428572159);
   if(time==StringToTime("2011.01.06 14:01:00")) return(-0.1500000000000057);
   if(time==StringToTime("2011.01.06 14:00:00")) return(-0.1571428571428969);
   if(time==StringToTime("2011.01.06 13:57:00")) return(0.2214285714285122);
   if(time==StringToTime("2011.01.06 13:51:00")) return(-0.1357142857142232);
   if(time==StringToTime("2011.01.06 13:50:00")) return(-0.1428571428571144);
   if(time==StringToTime("2011.01.06 13:49:00")) return(-0.2214285714285122);
   if(time==StringToTime("2011.01.06 13:48:00")) return(-0.2642857142856566);
   if(time==StringToTime("2011.01.06 13:47:00")) return(-0.2357142857142947);
   if(time==StringToTime("2011.01.06 12:49:00")) return(-0.1714285714285779);
   if(time==StringToTime("2011.01.06 12:45:00")) return(0.1071428571428612);
   if(time==StringToTime("2011.01.06 12:42:00")) return(0.3000000000000114);
   if(time==StringToTime("2011.01.06 12:41:00")) return(0.3928571428570901);
   if(time==StringToTime("2011.01.06 12:37:00")) return(-0.1500000000000057);
   if(time==StringToTime("2011.01.06 12:36:00")) return(-0.1928571428571502);
   if(time==StringToTime("2011.01.06 12:35:00")) return(-0.2499999999999756);
   if(time==StringToTime("2011.01.06 12:34:00")) return(-0.3571428571428368);
   if(time==StringToTime("2011.01.06 12:27:00")) return(0.1500000000000057);
   if(time==StringToTime("2011.01.06 12:26:00")) return(0.1928571428571502);
   if(time==StringToTime("2011.01.06 12:25:00")) return(0.2428571428571859);
   if(time==StringToTime("2011.01.06 12:24:00")) return(0.1571428571428969);
   if(time==StringToTime("2011.01.06 12:23:00")) return(0.1857142857143604);
   if(time==StringToTime("2011.01.06 11:45:00")) return(-0.1357142857143247);
   if(time==StringToTime("2011.01.06 11:44:00")) return(-0.2285714285714034);
   if(time==StringToTime("2011.01.06 11:19:00")) return(-0.1071428571428612);
   if(time==StringToTime("2011.01.06 11:18:00")) return(-0.1642857142856867);
   if(time==StringToTime("2011.01.06 11:12:00")) return(-0.1428571428571144);
   if(time==StringToTime("2011.01.06 11:11:00")) return(-0.1928571428571502);
   if(time==StringToTime("2011.01.06 11:10:00")) return(-0.1928571428571502);
   if(time==StringToTime("2011.01.06 10:51:00")) return(-0.2142857142857224);
   if(time==StringToTime("2011.01.06 10:36:00")) return(-0.1500000000000057);
   if(time==StringToTime("2011.01.06 10:35:00")) return(-0.1571428571428969);
   if(time==StringToTime("2011.01.06 10:32:00")) return(-0.1142857142857525);
   if(time==StringToTime("2011.01.06 10:30:00")) return(-0.1428571428571144);
   if(time==StringToTime("2011.01.06 10:20:00")) return(-0.1142857142857525);
   if(time==StringToTime("2011.01.06 10:19:00")) return(-0.2142857142857224);
   if(time==StringToTime("2011.01.06 10:18:00")) return(0.2642857142857581);
   if(time==StringToTime("2011.01.06 09:34:00")) return(-0.2928571428571201);
   if(time==StringToTime("2011.01.06 09:33:00")) return(-0.4857142857142703);
   if(time==StringToTime("2011.01.06 09:32:00")) return(-0.3785714285714091);
   if(time==StringToTime("2011.01.06 09:31:00")) return(-0.6142857142857038);
   if(time==StringToTime("2011.01.06 09:30:00")) return(-0.621428571428595);
   if(time==StringToTime("2011.01.06 09:29:00")) return(-0.6142857142857038);
   if(time==StringToTime("2011.01.06 09:28:00")) return(0.1928571428570486);
   if(time==StringToTime("2011.01.06 09:14:00")) return(-0.1428571428571144);
   if(time==StringToTime("2011.01.06 09:13:00")) return(-0.114285714285651);
   if(time==StringToTime("2011.01.06 08:52:00")) return(0.1357142857142232);
   if(time==StringToTime("2011.01.06 08:51:00")) return(0.1071428571428612);
   if(time==StringToTime("2011.01.06 08:48:00")) return(0.2642857142857581);
   if(time==StringToTime("2011.01.06 08:47:00")) return(0.1500000000000057);
   if(time==StringToTime("2011.01.06 08:46:00")) return(0.1714285714285779);
   if(time==StringToTime("2011.01.06 08:45:00")) return(0.2142857142857224);
   if(time==StringToTime("2011.01.06 08:44:00")) return(0.2642857142857581);
   if(time==StringToTime("2011.01.06 08:43:00")) return(0.1142857142857525);
   if(time==StringToTime("2011.01.06 08:42:00")) return(0.1714285714285779);
   if(time==StringToTime("2011.01.06 08:35:00")) return(-0.1428571428571144);
   if(time==StringToTime("2011.01.06 05:00:00")) return(-0.1285714285714334);
   if(time==StringToTime("2011.01.06 04:59:00")) return(-0.1571428571427954);
   if(time==StringToTime("2011.01.06 02:01:00")) return(0.1214285714286437);
   if(time==StringToTime("2011.01.06 01:58:00")) return(0.3142857142856924);
   if(time==StringToTime("2011.01.06 01:54:00")) return(-0.2642857142857581);
   if(time==StringToTime("2011.01.06 01:50:00")) return(-0.1500000000000057);
   if(time==StringToTime("2011.01.06 01:49:00")) return(-0.2428571428571859);
   if(time==StringToTime("2011.01.06 01:48:00")) return(-0.1928571428571502);
   if(time==StringToTime("2011.01.06 01:47:00")) return(-0.2357142857142947);
   if(time==StringToTime("2011.01.06 01:46:00")) return(-0.2714285714286494);
   if(time==StringToTime("2011.01.06 01:45:00")) return(-0.2357142857142947);
   if(time==StringToTime("2011.01.06 01:44:00")) return(-0.1357142857143247);
   if(time==StringToTime("2011.01.06 01:00:00")) return(-0.1071428571428612);
   if(time==StringToTime("2011.01.06 00:58:00")) return(-0.1357142857142232);
   if(time==StringToTime("2011.01.05 20:48:00")) return(0.2642857142857581);
   if(time==StringToTime("2011.01.05 20:47:00")) return(0.3428571428571559);
   if(time==StringToTime("2011.01.05 20:45:00")) return(0.2857142857143303);
   if(time==StringToTime("2011.01.05 20:44:00")) return(0.3214285714285836);
   if(time==StringToTime("2011.01.05 20:38:00")) return(-0.1857142857142589);
   if(time==StringToTime("2011.01.05 20:37:00")) return(-0.2357142857142947);
   if(time==StringToTime("2011.01.05 20:36:00")) return(-0.1357142857142232);
   if(time==StringToTime("2011.01.05 20:06:00")) return(0.1642857142857882);
   if(time==StringToTime("2011.01.05 20:05:00")) return(0.1357142857143247);
   if(time==StringToTime("2011.01.05 20:00:00")) return(-0.114285714285651);
   if(time==StringToTime("2011.01.05 19:59:00")) return(-0.2999999999999098);
   if(time==StringToTime("2011.01.05 19:55:00")) return(0.1285714285714334);
   if(time==StringToTime("2011.01.05 19:54:00")) return(0.114285714285651);
   if(time==StringToTime("2011.01.05 19:53:00")) return(0.1214285714285422);
   if(time==StringToTime("2011.01.05 19:52:00")) return(0.1928571428571502);
   if(time==StringToTime("2011.01.05 19:51:00")) return(0.2214285714285122);
   if(time==StringToTime("2011.01.05 19:31:00")) return(-0.114285714285651);
   if(time==StringToTime("2011.01.05 19:03:00")) return(0.1785714285713677);
   if(time==StringToTime("2011.01.05 18:14:00")) return(0.1214285714285422);
   if(time==StringToTime("2011.01.05 18:13:00")) return(0.1357142857142232);
   if(time==StringToTime("2011.01.05 18:05:00")) return(0.1500000000000057);
   if(time==StringToTime("2011.01.05 17:47:00")) return(0.1428571428571144);
   if(time==StringToTime("2011.01.05 17:46:00")) return(0.1571428571428969);
   if(time==StringToTime("2011.01.05 17:31:00")) return(-0.2214285714285122);
   if(time==StringToTime("2011.01.05 17:30:00")) return(-0.1214285714285422);
   if(time==StringToTime("2011.01.05 17:29:00")) return(-0.2571428571428669);
   if(time==StringToTime("2011.01.05 17:28:00")) return(-0.2857142857142289);
   if(time==StringToTime("2011.01.05 17:27:00")) return(-0.1714285714285779);
   if(time==StringToTime("2011.01.05 17:26:00")) return(-0.1857142857142589);
   if(time==StringToTime("2011.01.05 17:25:00")) return(-0.3428571428571559);
   if(time==StringToTime("2011.01.05 17:24:00")) return(0.1785714285714692);
   if(time==StringToTime("2011.01.05 17:23:00")) return(0.1000000000000715);
   if(time==StringToTime("2011.01.05 17:19:00")) return(0.1428571428571144);
   if(time==StringToTime("2011.01.05 17:18:00")) return(0.4571428571428068);
   if(time==StringToTime("2011.01.05 17:17:00")) return(0.3071428571428011);
   if(time==StringToTime("2011.01.05 17:16:00")) return(-0.4285714285714448);
   if(time==StringToTime("2011.01.05 17:15:00")) return(-0.2857142857142289);
   if(time==StringToTime("2011.01.05 17:14:00")) return(0.2428571428570844);
   if(time==StringToTime("2011.01.05 17:13:00")) return(-0.3785714285714091);
   if(time==StringToTime("2011.01.05 17:12:00")) return(-0.3571428571428368);
   if(time==StringToTime("2011.01.05 17:11:00")) return(-0.4642857142856981);
   if(time==StringToTime("2011.01.05 17:10:00")) return(-0.3999999999999813);
   if(time==StringToTime("2011.01.05 17:09:00")) return(0.1571428571428969);
   if(time==StringToTime("2011.01.05 17:07:00")) return(0.2785714285714391);
   if(time==StringToTime("2011.01.05 17:06:00")) return(0.2142857142857224);
   if(time==StringToTime("2011.01.05 17:05:00")) return(-0.3071428571429026);
   if(time==StringToTime("2011.01.05 17:04:00")) return(0.2785714285714391);
   if(time==StringToTime("2011.01.05 17:03:00")) return(0.5428571428570957);
   if(time==StringToTime("2011.01.05 17:02:00")) return(0.5928571428571315);
   if(time==StringToTime("2011.01.05 17:01:00")) return(0.4857142857142703);
   if(time==StringToTime("2011.01.05 17:00:00")) return(-0.3642857142857281);
   if(time==StringToTime("2011.01.05 16:59:00")) return(-0.664285714285638);
   if(time==StringToTime("2011.01.05 16:58:00")) return(0.521428571428625);
   if(time==StringToTime("2011.01.05 16:57:00")) return(0.6285714285714862);
   if(time==StringToTime("2011.01.05 16:56:00")) return(0.5071428571428426);
   if(time==StringToTime("2011.01.05 16:55:00")) return(0.7928571428571729);
   if(time==StringToTime("2011.01.05 16:54:00")) return(0.8499999999999984);
   if(time==StringToTime("2011.01.05 16:53:00")) return(0.8499999999999984);
   if(time==StringToTime("2011.01.05 16:52:00")) return(0.7285714285714562);
   if(time==StringToTime("2011.01.05 16:51:00")) return(0.8785714285714619);
   if(time==StringToTime("2011.01.05 16:49:00")) return(-0.1357142857143247);
   if(time==StringToTime("2011.01.05 16:48:00")) return(-0.1285714285714334);
   if(time==StringToTime("2011.01.05 16:41:00")) return(-0.1142857142857525);
   if(time==StringToTime("2011.01.05 16:39:00")) return(-0.1285714285714334);
   if(time==StringToTime("2011.01.05 16:38:00")) return(-0.2071428571429327);
   if(time==StringToTime("2011.01.05 16:37:00")) return(-0.1357142857143247);
   if(time==StringToTime("2011.01.05 16:33:00")) return(-0.1642857142856867);
   if(time==StringToTime("2011.01.05 16:32:00")) return(-0.3142857142856924);
   if(time==StringToTime("2011.01.05 16:31:00")) return(-0.564285714285668);
   if(time==StringToTime("2011.01.05 16:30:00")) return(-0.535714285714306);
   if(time==StringToTime("2011.01.05 16:29:00")) return(-0.3642857142857281);
   if(time==StringToTime("2011.01.05 16:28:00")) return(-0.4999999999999513);
   if(time==StringToTime("2011.01.05 16:23:00")) return(0.1714285714284764);
   if(time==StringToTime("2011.01.05 16:22:00")) return(0.1357142857142232);
   if(time==StringToTime("2011.01.05 16:21:00")) return(0.2071428571428312);
   if(time==StringToTime("2011.01.05 16:20:00")) return(0.2499999999999756);
   if(time==StringToTime("2011.01.05 16:14:00")) return(-0.1214285714285422);
   if(time==StringToTime("2011.01.05 16:12:00")) return(-0.1428571428571144);
   if(time==StringToTime("2011.01.05 16:08:00")) return(-0.1500000000000057);
   if(time==StringToTime("2011.01.05 16:05:00")) return(-0.1142857142857525);
   if(time==StringToTime("2011.01.05 16:04:00")) return(-0.4285714285714448);
   if(time==StringToTime("2011.01.05 16:03:00")) return(-0.5928571428571315);
   if(time==StringToTime("2011.01.05 16:02:00")) return(-0.621428571428595);
   if(time==StringToTime("2011.01.05 16:01:00")) return(0.2214285714286136);
   if(time==StringToTime("2011.01.05 16:00:00")) return(0.1000000000000715);
   if(time==StringToTime("2011.01.05 15:59:00")) return(0.4642857142856981);
   if(time==StringToTime("2011.01.05 15:58:00")) return(0.3785714285714091);
   if(time==StringToTime("2011.01.05 15:57:00")) return(0.4142857142856623);
   if(time==StringToTime("2011.01.05 15:56:00")) return(0.4071428571428726);
   if(time==StringToTime("2011.01.05 15:55:00")) return(0.5214285714285235);
   if(time==StringToTime("2011.01.05 15:54:00")) return(0.5857142857142402);
   if(time==StringToTime("2011.01.05 15:53:00")) return(0.6071428571428125);
   if(time==StringToTime("2011.01.05 15:52:00")) return(0.621428571428595);
   if(time==StringToTime("2011.01.05 15:51:00")) return(0.7714285714286007);
   if(time==StringToTime("2011.01.05 15:49:00")) return(-0.1714285714285779);
   if(time==StringToTime("2011.01.05 15:48:00")) return(-0.1642857142856867);
   if(time==StringToTime("2011.01.05 15:47:00")) return(-0.2000000000000414);
   if(time==StringToTime("2011.01.05 15:43:00")) return(-0.2071428571428312);
   if(time==StringToTime("2011.01.05 15:41:00")) return(-0.1571428571428969);
   if(time==StringToTime("2011.01.05 15:40:00")) return(-0.2000000000000414);
   if(time==StringToTime("2011.01.05 15:39:00")) return(-0.2500000000000772);
   if(time==StringToTime("2011.01.05 15:38:00")) return(-0.3071428571429026);
   if(time==StringToTime("2011.01.05 15:30:00")) return(0.1714285714285779);
   if(time==StringToTime("2011.01.05 15:29:00")) return(0.114285714285651);
   if(time==StringToTime("2011.01.05 15:27:00")) return(0.2142857142857224);
   if(time==StringToTime("2011.01.05 15:26:00")) return(0.4714285714285893);
   if(time==StringToTime("2011.01.05 15:25:00")) return(0.5071428571428426);
   if(time==StringToTime("2011.01.05 15:24:00")) return(0.6857142857143117);
   if(time==StringToTime("2011.01.05 15:23:00")) return(0.5857142857142402);
   if(time==StringToTime("2011.01.05 15:22:00")) return(-0.1142857142857525);
   if(time==StringToTime("2011.01.05 15:21:00")) return(-0.2571428571428669);
   if(time==StringToTime("2011.01.05 15:20:00")) return(-0.3999999999999813);
   if(time==StringToTime("2011.01.05 15:19:00")) return(-0.5000000000000527);
   if(time==StringToTime("2011.01.05 15:18:00")) return(-0.8857142857142517);
   if(time==StringToTime("2011.01.05 15:16:00")) return(0.649999999999957);
   if(time==StringToTime("2011.01.05 15:15:00")) return(0.5499999999999871);
   if(time==StringToTime("2011.01.05 15:14:00")) return(0.8499999999999984);
   if(time==StringToTime("2011.01.05 15:13:00")) return(0.821428571428535);
   if(time==StringToTime("2011.01.05 15:12:00")) return(0.9142857142857152);
   if(time==StringToTime("2011.01.05 15:11:00")) return(1.07142857142851);
   if(time==StringToTime("2011.01.05 15:10:00")) return(1.378571428571413);
   if(time==StringToTime("2011.01.05 15:07:00")) return(-0.1571428571427954);
   if(time==StringToTime("2011.01.05 15:04:00")) return(-0.1357142857142232);
   if(time==StringToTime("2011.01.05 15:02:00")) return(-0.3785714285714091);
   if(time==StringToTime("2011.01.05 15:01:00")) return(-0.114285714285651);
   if(time==StringToTime("2011.01.05 14:59:00")) return(-0.1785714285714692);
   if(time==StringToTime("2011.01.05 14:56:00")) return(-0.4714285714285893);
   if(time==StringToTime("2011.01.05 14:55:00")) return(-0.4857142857142703);
   if(time==StringToTime("2011.01.05 14:54:00")) return(-0.6785714285714205);
   if(time==StringToTime("2011.01.05 14:53:00")) return(-1.064285714285721);
   if(time==StringToTime("2011.01.05 14:52:00")) return(-0.8714285714285707);
   if(time==StringToTime("2011.01.05 14:51:00")) return(0.3999999999999813);
   if(time==StringToTime("2011.01.05 14:50:00")) return(0.5714285714285593);
   if(time==StringToTime("2011.01.05 14:49:00")) return(0.6999999999999927);
   if(time==StringToTime("2011.01.05 14:48:00")) return(0.8428571428571072);
   if(time==StringToTime("2011.01.05 14:47:00")) return(-0.4357142857142345);
   if(time==StringToTime("2011.01.05 14:46:00")) return(-0.649999999999957);
   if(time==StringToTime("2011.01.05 14:45:00")) return(-0.5785714285714505);
   if(time==StringToTime("2011.01.05 14:44:00")) return(-0.5571428571428783);
   if(time==StringToTime("2011.01.05 14:43:00")) return(-0.721428571428565);
   if(time==StringToTime("2011.01.05 14:42:00")) return(0.4285714285714448);
   if(time==StringToTime("2011.01.05 14:41:00")) return(0.2642857142857581);
   if(time==StringToTime("2011.01.05 14:40:00")) return(-0.4642857142856981);
   if(time==StringToTime("2011.01.05 14:39:00")) return(-0.3999999999999813);
   if(time==StringToTime("2011.01.05 14:38:00")) return(-0.5071428571428426);
   if(time==StringToTime("2011.01.05 14:37:00")) return(0.6071428571428125);
   if(time==StringToTime("2011.01.05 14:36:00")) return(0.8928571428571429);
   if(time==StringToTime("2011.01.05 14:35:00")) return(1.257142857142871);
   if(time==StringToTime("2011.01.05 14:34:00")) return(1.092857142857083);
   if(time==StringToTime("2011.01.05 14:33:00")) return(1.142857142857119);
   if(time==StringToTime("2011.01.05 14:32:00")) return(0.9857142857142215);
   if(time==StringToTime("2011.01.05 14:31:00")) return(-0.4500000000000171);
   if(time==StringToTime("2011.01.05 14:30:00")) return(-0.9571428571428596);
   if(time==StringToTime("2011.01.05 14:29:00")) return(-1.378571428571413);
   if(time==StringToTime("2011.01.05 14:28:00")) return(0.5285714285715162);
   if(time==StringToTime("2011.01.05 14:27:00")) return(-0.3999999999999813);
   if(time==StringToTime("2011.01.05 14:26:00")) return(1.542857142857201);
   if(time==StringToTime("2011.01.05 14:25:00")) return(1.450000000000021);
   if(time==StringToTime("2011.01.05 14:24:00")) return(2.178571428571477);
   if(time==StringToTime("2011.01.05 14:23:00")) return(-0.664285714285638);
   if(time==StringToTime("2011.01.05 14:22:00")) return(-0.5571428571427768);
   if(time==StringToTime("2011.01.05 14:21:00")) return(0.5857142857142402);
   if(time==StringToTime("2011.01.05 14:20:00")) return(0.478571428571379);
   if(time==StringToTime("2011.01.05 14:19:00")) return(0.7785714285714919);
   if(time==StringToTime("2011.01.05 14:18:00")) return(1.228571428571408);
   if(time==StringToTime("2011.01.05 14:17:00")) return(1.307142857142907);
   if(time==StringToTime("2011.01.05 14:16:00")) return(-0.4928571428571615);
   if(time==StringToTime("2011.01.05 14:15:00")) return(0.5428571428570957);
   if(time==StringToTime("2011.01.05 14:14:00")) return(3.292857142857133);
   if(time==StringToTime("2011.01.05 14:13:00")) return(3.221428571428524);
   if(time==StringToTime("2011.01.05 14:12:00")) return(3.307142857142813);
   if(time==StringToTime("2011.01.05 14:11:00")) return(3.314285714285705);
   if(time==StringToTime("2011.01.05 14:10:00")) return(3.314285714285705);
   if(time==StringToTime("2011.01.05 14:09:00")) return(3.392857142857102);
   if(time==StringToTime("2011.01.05 14:08:00")) return(3.435714285714246);
   if(time==StringToTime("2011.01.05 13:59:00")) return(0.1785714285714692);
   if(time==StringToTime("2011.01.05 13:58:00")) return(0.2071428571429327);
   if(time==StringToTime("2011.01.05 13:54:00")) return(0.6285714285713847);
   if(time==StringToTime("2011.01.05 13:53:00")) return(0.749999999999927);
   if(time==StringToTime("2011.01.05 13:52:00")) return(0.649999999999957);
   if(time==StringToTime("2011.01.05 13:51:00")) return(0.649999999999957);
   if(time==StringToTime("2011.01.05 13:50:00")) return(0.7571428571428182);
   if(time==StringToTime("2011.01.05 13:49:00")) return(0.7785714285713904);
   if(time==StringToTime("2011.01.05 13:48:00")) return(0.7999999999999626);
   if(time==StringToTime("2011.01.05 13:46:00")) return(-0.1071428571428612);
   if(time==StringToTime("2011.01.05 12:15:00")) return(-0.1571428571428969);
   if(time==StringToTime("2011.01.05 12:14:00")) return(-0.1500000000000057);
   if(time==StringToTime("2011.01.05 12:13:00")) return(-0.1714285714285779);
   if(time==StringToTime("2011.01.05 12:07:00")) return(-0.1214285714285422);
   if(time==StringToTime("2011.01.05 12:06:00")) return(-0.1714285714285779);
   if(time==StringToTime("2011.01.05 11:59:00")) return(0.2357142857142947);
   if(time==StringToTime("2011.01.05 11:57:00")) return(-0.2071428571428312);
   if(time==StringToTime("2011.01.05 11:56:00")) return(-0.3499999999999456);
   if(time==StringToTime("2011.01.05 11:55:00")) return(-0.2571428571428669);
   if(time==StringToTime("2011.01.05 11:54:00")) return(-0.2857142857142289);
   if(time==StringToTime("2011.01.05 11:53:00")) return(0.2428571428571859);
   if(time==StringToTime("2011.01.05 11:52:00")) return(-0.2428571428570844);
   if(time==StringToTime("2011.01.05 11:51:00")) return(0.2499999999999756);
   if(time==StringToTime("2011.01.05 11:50:00")) return(0.2785714285714391);
   if(time==StringToTime("2011.01.05 11:49:00")) return(0.2857142857143303);
   if(time==StringToTime("2011.01.05 11:07:00")) return(-0.1642857142856867);
   if(time==StringToTime("2011.01.05 11:06:00")) return(-0.1714285714285779);
   if(time==StringToTime("2011.01.05 11:05:00")) return(-0.1928571428571502);
   if(time==StringToTime("2011.01.05 10:07:00")) return(-0.1214285714286437);
   if(time==StringToTime("2011.01.05 09:41:00")) return(-0.1285714285714334);
   if(time==StringToTime("2011.01.05 09:40:00")) return(-0.1428571428572159);
   if(time==StringToTime("2011.01.05 09:39:00")) return(-0.1357142857143247);
   if(time==StringToTime("2011.01.05 09:38:00")) return(-0.2142857142857224);
   if(time==StringToTime("2011.01.05 09:37:00")) return(-0.2642857142857581);
   if(time==StringToTime("2011.01.05 09:06:00")) return(0.1071428571428612);
   if(time==StringToTime("2011.01.05 09:03:00")) return(0.1571428571427954);
   if(time==StringToTime("2011.01.05 08:53:00")) return(-0.1500000000000057);
   if(time==StringToTime("2011.01.05 08:52:00")) return(-0.2214285714285122);
   if(time==StringToTime("2011.01.05 08:51:00")) return(-0.2857142857142289);
   if(time==StringToTime("2011.01.05 08:27:00")) return(0.1285714285714334);
   return(sig);
  }
//+------------------------------------------------------------------+
