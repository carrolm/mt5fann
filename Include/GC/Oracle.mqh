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
class COracle
  {
private:
   string            Symbol;
   string            Functions_Array[10];
   int               Functions_Count[10];
   //int               Max_Functions;
   ENUM_TIMEFRAMES   TimeFrame;
   string            File_Name;
   bool              WithNews;
   bool              WithHours;
   bool              WithDayOfWeek;

public:
   double            InputVector[];
   double            OutputVector[];                     COracle(){Init();}
                    ~COracle(){DeInit();}
   bool              GetVector(string smbl="",int shift=0,bool train=false);
   bool              debug;
   void              Init();
   void              DeInit();
   virtual double    forecast(string smbl="",int shift=0,bool train=false);
   bool              Load(string file_name);
   bool              Save(string file_name="");
   virtual bool      CustomLoad(int file_handle){return(false);};
   virtual bool      CustomSave(int file_handle){return(false);};
   virtual bool      Draw(int window,datetime &time[],int w,int h){return(true);};
   int               num_input();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double COracle::forecast(string smbl="",int shift=0,bool train=false)
  {
   return(0);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COracle::GetVector(string smbl="",int shift=0,bool train=false)
  {// пара, период, смещение назад (для индикатора полезно)
   double IB[],OB[];
   ArrayResize(IB,num_input()+2);
   ArrayResize(OB,1+2);
   ArrayResize(InputVector,num_input());
   ArrayResize(OutputVector,3);
   int FunctionsIdx;
   int n_vectors=num_input();
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

   n_vectors=(n_vectors-pos_in);
   for(FunctionsIdx=0; FunctionsIdx<10;FunctionsIdx++)
     {
      if(GetVectors(IB,OB,Functions_Count[FunctionsIdx],n_o_vectors,Functions_Array[FunctionsIdx],smbl,PERIOD_M1,shift))
        {
         // приведем к общему знаменателю
         double si=1;
         //            for(i=0;i<n_vectors;i++) si+=IB[i]*IB[i]; si=MathSqrt(si);
         for(i=0;i<n_vectors;i++) InputVector[pos_in++]=IB[i]/si;

         for(i=0;i<n_o_vectors;i++)
           {
            OutputVector[i]=OB[i];
            if(OB[i]<-3) OutputVector[i]=-0.5;
            if(OB[i]>3) OutputVector[i]=0.5;
            //OutputVector[i]=1*(1/(1+MathExp(-1*OB[i]/5))-0.5);
           }
        }//if(GetVectors(IB,OB,0,n_o_vectors,"",smbl,PERIOD_M1,shift))
      //  {
      //   for(i=0;i<n_o_vectors;i++)
      //     {
      //      OutputVector[i]=0;
      //      if(OB[i]<-3) OutputVector[i]=-0.5;
      //      if(OB[i]>3) OutputVector[i]=0.5;
      //      //OutputVector[i]=1*(1/(1+MathExp(-1*OB[i]/5))-0.5);
      //     }
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int COracle::num_input(void)
  {
   int ret=0;
   for(int i=0;i<10;i++) ret+=Functions_Count[i];
   return(ret);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COracle::Save(string file_name)
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
bool COracle::Load(string file_name)
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
      while(outstr!="[Custom]")
        {
         sp=1+StringFind(outstr,"=");
         for(i=0;i<10;i++)
           {
            if(Functions_Array[i]==StringSubstr(outstr,0,sp-1)) Functions_Count[i]=(int)StringToInteger(StringSubstr(outstr,sp));;
           }
         outstr=FileReadString(file_handle);
        }
      CustomLoad(file_handle);
      FileClose(file_handle);
      return(true);
     }
   else return(false);
  };
//+------------------------------------------------------------------+
void COracle::Init()
  {
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
//|                                                                  |
//+------------------------------------------------------------------+
void COracle::DeInit()
  {
  }
//
