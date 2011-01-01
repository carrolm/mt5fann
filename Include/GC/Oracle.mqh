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
   int               Max_Functions;
   ENUM_TIMEFRAMES   TimeFrame;
   string            File_Name;
public:
                     COracle(){Init();}
                    ~COracle(){DeInit();}
   bool              debug;
   void              Init();
   void              DeInit();
   double            forecast(int shift=0,bool train=false);
   bool              Load(string file_name);
   bool              Save(string file_name);
   virtual bool      CustomLoad(int file_handle){return(false);};
   virtual bool      CustomSave(int file_handle){return(false);};

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COracle::Save(string file_name)
  {
   int file_handle;  string outstr="";
   file_handle=FileOpen(file_name+".gc_oracle",FILE_WRITE|FILE_ANSI|FILE_TXT,"= ");
// сделаем шаблончик
   if(file_handle!=INVALID_HANDLE)
     {
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
   int file_handle;  string outstr="";
   file_handle=FileOpen(file_name+".gc_oracle",FILE_READ|FILE_ANSI|FILE_TXT,"= ");
   if(file_handle!=INVALID_HANDLE)
     {
      outstr=FileReadString(file_handle);//   [FunctionsArray]
      while(outstr!="[Custom]")
        {
         //     if("AnnType=CGCANN"!=FileReadString(fileid)){FileClose(fileid);return(false);};//AnnType=CGCANN
         //if(StringFind(outstr,"input_dimension")==0)input_dimension=(int)StringToInteger(StringSubstr(outstr,StringLen("input_dimension=")));
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
