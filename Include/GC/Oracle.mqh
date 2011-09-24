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
class COracleTemplate
  {
private:
   bool              IsInit;
public:
   double            InputVector[];
   bool              debug;
   string            inputSignals;
   int               num_input_signals;
   string            filename;
                     COracleTemplate(){IsInit=false;/*Init();*/};
                    ~COracleTemplate(){DeInit();};
   virtual void      Init(){if(!IsInit) {IsInit=true;debug=false;filename=Name()+".ini";loadSettings(filename);ArrayResize(InputVector,num_input_signals);}};
   virtual void      DeInit(){saveSettings(filename);};
   virtual double    forecast(string smbl,int shift,bool train){Print("Please overwrite (int) in ",Name()); return(0);};
   virtual double    forecast(string smbl,datetime startdt,bool train){Print("Please overwrite (datetime) in ",Name()); return(0);};
   virtual string    Name(){return("Prpototype");};
   bool              ExportHistoryENCOG(string smbl,string fname,int num_train,int num_test,int num_valid);
   bool              loadSettings(string filename);
   bool              saveSettings(string filename);
   string            GetInputAsString(string smbl,int shift);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string COracleTemplate::GetInputAsString(string smbl,int shift)
  {
   int export_precision=5;
   double Result=GetVectors(InputVector,inputSignals,smbl,0,shift);
   string outstr="";
   for(int j=0;j<num_input_signals;j++)
     {
      outstr+=DoubleToString(InputVector[j],export_precision)+",";
     }
   return(StringSubstr(outstr,0,StringLen(outstr)-1));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COracleTemplate::ExportHistoryENCOG(string smbl,string fname,int num_train,int num_test,int num_valid)
  {
   int export_precision=5;
   if(num_train==0 && 0==num_test && 0==num_valid) return(false);
   if(""==smbl) smbl=_Symbol;
   if(""==fname) fname=Name();
   int FileHandle=-1;
   int i,j,shift=15;
   string outstr;
   double Result;
   int num_vals,prev_prg=0;
   string fnm="";
   MqlRates rates[];
   MqlDateTime tm;
//double IV[50],OV[10];
   ArraySetAsSeries(rates,true);
   TimeToStruct(TimeCurrent(),tm);
   int cm=tm.mon;
   int FileHandleOC=FileOpen("OracleDummy_fc.mqh",FILE_WRITE|FILE_ANSI,' ');
   if(FileHandleOC==INVALID_HANDLE)
     {
      Print("Error");
      return(false);
     }
   for(int ring=0;ring<3;ring++)
     {
      switch(ring)
        {
         case 0: num_vals=num_test;fnm=fname+"_"+smbl+"_test_data.csv";  break;
         case 1: num_vals=num_valid;fnm=fname+"_"+smbl+"_valid_data.csv";  break;
         case 2: num_vals=num_train;fnm=fname+"_"+smbl+"_train_data.csv";  break;
         default: num_vals=0;
        }
      if(num_vals>0)
        {
         FileHandle=FileOpen(fnm,FILE_CSV|FILE_ANSI|FILE_WRITE|FILE_REWRITE,",");
         if(FileHandle!=INVALID_HANDLE)
           {
            // Header
            outstr="";
            outstr=inputSignals;StringReplace(outstr," ",",");StringReplace(outstr,"-","_");
            outstr+=",Result";
            FileWrite(FileHandle,outstr);
            bool need_exp=true;
            int copied=CopyRates(_Symbol,PERIOD_M1,0,shift+num_vals,rates);
            FileWrite(FileHandleOC,"double od_forecast(datetime time,string smb)  ");
            FileWrite(FileHandleOC," {");

            for(i=shift;i<(shift+num_vals);i++)
              {
               Result=GetVectors(InputVector,inputSignals,smbl,0,i);
               //отнормируем
               //Result=Result2Neuro(Result,smbl);
               // отнормируем
               //if(Result==0) continue;
               outstr="";need_exp=true;
               for(j=0;j<num_input_signals;j++)
                 {
                  outstr+=DoubleToString(InputVector[j],export_precision)+",";
                  if(InputVector[j]>1 || InputVector[j]<-1) need_exp=false;
                 }
               //if(Result>0.66) outstr+="""QB""";
               //else if(Result>0.33) outstr+="""QCS""";
               //else if(Result>0.1) outstr+="""QWCS""";
               //else if(Result>-0.1) outstr+="""QZ""";
               //else if(Result>-0.33) outstr+="""QWCB""";
               //else if(Result>-0.66) outstr+="""QCB""";
               //else outstr+="""QS""";

               outstr+=DoubleToString(Result,export_precision);
               //if(need_exp && -1==StringFind(outstr,"#IND0")) 
               FileWrite(FileHandle,outstr);
               if(Result>0.33 || Result<-0.33)
                 {
                  FileWrite(FileHandleOC,"  if(smb==\""+smbl+"\" && time==StringToTime(\""+(string)rates[i].time+"\")) return("+(string)Result+");");
                 }
              }
            FileClose(FileHandle);
            FileWrite(FileHandleOC,"  return(0);");
            FileWrite(FileHandleOC," }");
            FileClose(FileHandleOC);
            Print("Created.",fnm);
           }
         shift+=num_vals;
        }
     }

   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COracleTemplate::loadSettings(string filename)
  {
   if(""==filename) filename=Name()+".ini";
   int FileHandle=FileOpen(filename,FILE_READ|FILE_ANSI|FILE_CSV,'=');
   string fr;
   if(FileHandle!=INVALID_HANDLE)
     {
      while(""!=(fr=FileReadString(FileHandle)))
        {
         if("inputSignals"==fr)
           {
            inputSignals=FileReadString(FileHandle);
            int start_pos=0,end_pos=0,shift_pos=0;
            end_pos=StringFind(inputSignals," ",start_pos);
            do //while(end_pos>0)
              {
               num_input_signals++;
               start_pos=end_pos+1;    end_pos=StringFind(inputSignals," ",start_pos);
              }
            while(start_pos>0);

            //Print(Name()," inputSignals=",inputSignals," ",num_input_signals);
           }
        }
      FileClose(FileHandle);
     }
   Print(Name()," ready!");
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COracleTemplate::saveSettings(string filename)
  {
   if(""==filename) filename=Name()+".ini";
   int FileHandle=FileOpen(filename,FILE_WRITE|FILE_ANSI|FILE_CSV,'=');
//string fr;
   if(FileHandle!=INVALID_HANDLE)
     {
      FileWrite(FileHandle,"inputSignals",inputSignals);
      FileClose(FileHandle);
     }
   return(true);
  }

COracleTemplate *AllOracles[];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CEasy:public COracleTemplate
  {
   //  virtual double    forecast(string smbl,int shift,bool train);
   // virtual double    forecast(string smbl,datetime startdt,bool train);
   virtual string    Name(){return("Easy");};
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

class CiMA:public COracleTemplate
  {
   virtual double    forecast(string smbl,int shift,bool train);
   virtual double    forecast(string smbl,datetime startdt,bool train);
   virtual string    Name(){return("iMA");};
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

double CiMA::forecast(string smbl,int shift,bool train)
  {

   double sig=0;
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
//|                                                                  |
//+------------------------------------------------------------------+

double CiMA::forecast(string smbl,datetime startdt,bool train)
  {
   double sig=0;
   double ind1_buffer[];
   double ind2_buffer[];
   int   h_ind1=iMA(smbl,PERIOD_M1,8,0,MODE_SMA,PRICE_CLOSE);
   if(CopyBuffer(h_ind1,0,startdt,3,ind1_buffer)<3) return(0);
   if(!ArraySetAsSeries(ind1_buffer,true)) return(0);
   int   h_ind2=iMA(smbl,PERIOD_M1,16,0,MODE_SMA,PRICE_CLOSE);
   if(CopyBuffer(h_ind2,0,startdt,2,ind2_buffer)<2) return(0);
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
//|                                                                  |
//+------------------------------------------------------------------+

class CiMACD:public COracleTemplate
  {
   virtual double    forecast(string smbl,int shift,bool train);
   virtual double    forecast(string smbl,datetime startdt,bool train);
   virtual string    Name(){return("iMACD");};
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

double CiMACD::forecast(string smbl,int shift,bool train)
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
//|                                                                  |
//+------------------------------------------------------------------+

double CiMACD::forecast(string smbl,datetime shift,bool train)
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
//|                                                                  |
//+------------------------------------------------------------------+
class CPriceChanel:public COracleTemplate
  {
   virtual double    forecast(string smbl,int shift,bool train);
   virtual double    forecast(string smbl,datetime startdt,bool train);
   virtual string    Name(){return("Price Chanel");};
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CPriceChanel::forecast(string smbl,int shift,bool train)
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
//|                                                                  |
//+------------------------------------------------------------------+
double CPriceChanel::forecast(string smbl,datetime shift,bool train)
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
//|                                                                  |
//+------------------------------------------------------------------+
class CiStochastic:public COracleTemplate
  {
   virtual double    forecast(string smbl,int shift,bool train);
   virtual double    forecast(string smbl,datetime startdt,bool train);
   virtual string    Name(){return("iStochastic");};
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CiStochastic::forecast(string smbl,int shift,bool train)
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
double CiStochastic::forecast(string smbl,datetime shift,bool train)
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
class CiRSI:public COracleTemplate
  {
   virtual double    forecast(string smbl,int shift,bool train);
   virtual double    forecast(string smbl,datetime startdt,bool train);
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
double CiRSI::forecast(string smbl,datetime shift,bool train)
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
class CiCGI:public COracleTemplate
  {
   virtual double    forecast(string smbl,int shift,bool train);
   virtual double    forecast(string smbl,datetime startdt,bool train);
   virtual string    Name(){return("iCGI");};
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CiCGI::forecast(string smbl,int shift,bool train)
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
double CiCGI::forecast(string smbl,datetime shift,bool train)
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
class CiWPR:public COracleTemplate
  {
   virtual double    forecast(string smbl,int shift,bool train);
   virtual double    forecast(string smbl,datetime startdt,bool train);
   virtual string    Name(){return("iWPR");};
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CiWPR::forecast(string smbl,int shift,bool train)
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
double CiWPR::forecast(string smbl,datetime shift,bool train)
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
class CiBands:public COracleTemplate
  {
   virtual double    forecast(string smbl,int shift,bool train);
   virtual double    forecast(string smbl,datetime startdt,bool train);
   virtual string    Name(){return("iBands");};
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CiBands::forecast(string smbl,int shift,bool train)
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
double CiBands::forecast(string smbl,datetime shift,bool train)
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
class CNRTR:public COracleTemplate
  {
   virtual double    forecast(string smbl,int shift,bool train);
   virtual double    forecast(string smbl,datetime startdt,bool train);
   virtual string    Name(){return("NRTR");};
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CNRTR::forecast(string smbl,int shift,bool train)
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
double CNRTR::forecast(string smbl,datetime shift,bool train)
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
class CiAlligator:public COracleTemplate
  {
   virtual double    forecast(string smbl,int shift,bool train);
   virtual double    forecast(string smbl,datetime startdt,bool train);
   virtual string    Name(){return("iAlligator");};
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CiAlligator::forecast(string smbl,int shift,bool train)
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
double CiAlligator::forecast(string smbl,datetime shift,bool train)
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
class CiAMA:public COracleTemplate
  {
   virtual double    forecast(string smbl,int shift,bool train);
   virtual double    forecast(string smbl,datetime startdt,bool train);
   virtual string    Name(){return("iAMA");};
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CiAMA::forecast(string smbl,int shift,bool train)
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
double CiAMA::forecast(string smbl,datetime shift,bool train)
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
class CiAO:public COracleTemplate
  {
   virtual double    forecast(string smbl,int shift,bool train);
   virtual double    forecast(string smbl,datetime startdt,bool train);
   virtual string    Name(){return("iAO");};
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CiAO::forecast(string smbl,int shift,bool train)
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
double CiAO::forecast(string smbl,datetime shift,bool train)
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
class CiIchimoku:public COracleTemplate
  {
   virtual double    forecast(string smbl,int shift,bool train);
   virtual double    forecast(string smbl,datetime startdt,bool train);
   virtual string    Name(){return("iIchimoku");};
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CiIchimoku::forecast(string smbl,int shift,bool train)
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
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CiIchimoku::forecast(string smbl,datetime shift,bool train)
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
class CiEnvelopes:public COracleTemplate
  {
   virtual double    forecast(string smbl,int shift,bool train);
   virtual double    forecast(string smbl,datetime startdt,bool train);
   virtual string    Name(){return("iEnvelopes");};
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CiEnvelopes::forecast(string smbl,int shift,bool train)
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
double CiEnvelopes::forecast(string smbl,datetime shift,bool train)
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
class CMA_Crossover_ADX:public COracleTemplate
  {
   //   virtual double    forecast(string smbl,int shift,bool train);
   virtual double    forecast(string smbl,datetime startdt,bool train);
   virtual string    Name(){return("MA_Crossover_ADX");};
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CMA_Crossover_ADX::forecast(string smbl,datetime shift,bool train)
  {

   double sig=0;

//   double ind1_buffer[];
//   double ind2_buffer[];
//   double Close[];
//   int   h_ind1=iEnvelopes(smbl,PERIOD_M1,28,0,MODE_SMA,PRICE_CLOSE,0.1);
//   if(CopyBuffer(h_ind1,0,shift,3,ind1_buffer)<3)         return(0);
//   if(CopyBuffer(h_ind1,1,shift,3,ind2_buffer)<3)         return(0);
//   if(!ArraySetAsSeries(ind1_buffer,true))         return(0);
//   if(!ArraySetAsSeries(ind2_buffer,true))         return(0);
//   if(CopyClose(Symbol(),Period(),0,3,Close)<2) return(0);
//   if(!ArraySetAsSeries(Close,true)) return(0);
//
////--- условие 1: скользящая средняя возрастает на текущем и предыдущем баре 
//   bool Buy_Condition_1=(StateEMA(0)>0 && StateEMA(1)>0);
////--- условие 2: цена закрытия завершенного бара выше скользящей средней 
//   bool Buy_Condition_2=(StateClose(1)>0);
////--- условие 3: значение ADX на текущем баре больше минимально заданного 
//   bool Buy_Condition_3=(MainADX(0)>m_minimum_ADX);
////--- условие 4: на текущем баре значение DI+ больше, чем DI-
//   bool Buy_Condition_4=(StateADX(0)>0);
////--- условие 1: скользящая средняя убывает на текущем и предыдущем баре 
//   bool Sell_Condition_1=(StateEMA(0)<0 && StateEMA(1)<0);
////--- условие 2: цена закрытия завершенного бара ниже скользящей средней 
//   bool Sell_Condition_2=(StateClose(1)<0);
////--- условие 3: значение ADX на текущем баре больше минимально заданного 
//   bool Sell_Condition_3=(MainADX(0)>m_minimum_ADX);
////--- условие 4: на текущем баре DI- больше, чем DI+
//   bool Sell_Condition_4=(StateADX(0)<0);
//
//
//   if((Buy_Condition_1 && Buy_Condition_2 && Buy_Condition_3 && Buy_Condition_4)
//      sig=1;
//   else if(Sell_Condition_1 && Sell_Condition_2 && Sell_Condition_3 && Sell_Condition_4)
//                     sig=-1;
//   else sig=0;
//   IndicatorRelease(h_ind1);
////--- возвращаем торговый сигнал
   return(sig);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int AllOracles()
  {
   ArrayResize(AllOracles,20);
   int nAllOracles=0;
   AllOracles[nAllOracles++]=new CiStochastic;
   AllOracles[nAllOracles++]=new CiMACD;
   AllOracles[nAllOracles++]=new CiMA;
   AllOracles[nAllOracles++]=new CPriceChanel;
   AllOracles[nAllOracles++]=new CiRSI;
   AllOracles[nAllOracles++]=new CiCGI;
   AllOracles[nAllOracles++]=new CiWPR;
   AllOracles[nAllOracles++]=new CiBands;
   AllOracles[nAllOracles++]=new CiAlligator;
   AllOracles[nAllOracles++]=new CiAO;
   AllOracles[nAllOracles++]=new CiIchimoku;
   AllOracles[nAllOracles++]=new CiEnvelopes;
   for(int i=0;i<nAllOracles;i++) AllOracles[i].Init();
   return(nAllOracles);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class COracleANN:public COracleTemplate
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
int COracleANN::ExportData(int qty,int shift,string &Symbols_Array[],string FileName,bool test)
  {
   int i,ma;
   int FileHandle=0;
   int FileHandleFANN=0;
   int needcopy=0;
   int copied=0;

// временно!
   test=true;
//\

   string outstr,trainstrstr;
   FileHandle=FileOpen(FileName+".csv",FILE_WRITE|FILE_ANSI|FILE_CSV,' ');
   FileHandleFANN=FileOpen(FileName+".dat",FILE_WRITE|FILE_ANSI|FILE_TXT,' ');
   needcopy=qty;int Max_Symbols=0;
   for(ma=0;ma<ArraySize(Symbols_Array);ma++) if(StringLen(Symbols_Array[ma])!=0)Max_Symbols++;
//GNGAlgorithm.forecast(SymbolsArray[ma],i,true);
   MqlRates rates[];
   ArraySetAsSeries(rates,true);

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
               //              CopyRates(_Symbol,_Period,shift+10,3,rates);
               i++;
               outstr="";
               //              outstr+=(string)rates[0].time+" ";
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
      while(i<ArraySize(Functions_Array) && Functions_Array[i]!="" && Functions_Array[i]!=NULL)
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
//|                                                                  |
//+------------------------------------------------------------------+
void COracleANN::Init()
  {
   ClearTraning=false;
   debug=false;
   WithNews = false;
   WithHours= false;
   WithDayOfWeek=false;
   int i;
   for(i=0;i<ArraySize(VectorFunctions) && VectorFunctions[i]!=NULL && VectorFunctions[i]!="";i++)
     {
      Functions_Array[i]=VectorFunctions[i];
      Functions_Count[i]=0;
     }
   TimeFrame=_Period;
  }
//+------------------------------------------------------------------+
