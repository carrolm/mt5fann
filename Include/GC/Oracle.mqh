//+------------------------------------------------------------------+
//|                                                       Oracle.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#include <Trade\SymbolInfo.mqh>
#include <GC\GetVectors.mqh>
bool _ResultAsString_=false;
int _HistorySignals_=10;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class COracleTemplate
  {
private:

   string            filename;

public:  
 bool              IsInit;
   int               errorFile;
   int               AgeHistory;
   double            HistoryInputVector[];
   double            InputVector[];
   double            OutputVector[];
   bool              debug;
   string            InputSignals;
   string            InputSignal[];
   string            templateInputSignals;
   int               num_repeat;
   int               num_input_signals;
                     COracleTemplate(){IsInit=false;};
                    ~COracleTemplate(){DeInit();};
   virtual void      Init(string FileName="",bool ip_debug=false);
   void              DeInit();
   virtual double    forecast(string smbl,int shift,bool train){Print("Please overwrite (int) in ",Name()); return(0);};
   virtual double    forecast(string smbl,datetime startdt,bool train){Print("Please overwrite (datetime) in ",Name()); return(0);};
   virtual string    Name(){return(filename);/*return("Prpototype");*/};
   bool              ExportHistoryENCOG(string smbl,string fname,ENUM_TIMEFRAMES tf,int num_train,int num_test,int num_valid,int num_work);
   bool              loadSettings(string filename);
   bool              saveSettings(string filename);
   string            GetInputAsString(string smbl,int shift);

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void  COracleTemplate::Init(string FileName="",bool ip_debug=false)
  {
  IsInit=true;
   debug=ip_debug; AgeHistory=0;errorFile=INVALID_HANDLE;
   if(""!=FileName) filename=FileName;
   else  filename="Prototype";

   loadSettings(filename+".ini");
   ArrayResize(InputVector,num_input_signals);
   ArrayResize(InputSignal,num_input_signals);
   ArrayResize(HistoryInputVector,_HistorySignals_*num_input_signals);
   ArrayInitialize(HistoryInputVector,0);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void  COracleTemplate::DeInit()
  {
   saveSettings(filename+".ini");
   for(int i=0;i<ArraySize(IndHandles);i++)
     {
      IndicatorRelease(IndHandles[i].hid);
     }
   if(INVALID_HANDLE!=errorFile) FileClose(errorFile);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string COracleTemplate::GetInputAsString(string smbl,int shift)
  {

   double Result=GetVectors(InputVector,InputSignals,smbl,0,shift);
   if(-100==Result) return("");
   string outstr=""+smbl+",M1,";
   for(int j=0;j<num_input_signals;j++)
     {
      outstr+=DoubleToString(InputVector[j],_Precision_)+",";
     }
   return(StringSubstr(outstr,0,StringLen(outstr)-1));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COracleTemplate::ExportHistoryENCOG(string smbl,string fname,ENUM_TIMEFRAMES tf,int num_train,int num_test=0,int num_valid=0,int num_work=0)
  {
   if(num_train==0 && 0==num_test && 0==num_valid && 0==num_work) return(false);
   if(""==smbl) smbl=_Symbol;
   if(""==fname) fname=Name();
   int FileHandle=-1;
   int i,j,shift=_TREND_;
   string outstr;
   double Result=0;
   int num_vals,prev_prg=0;
   string fnm="";
   MqlRates rates[];
   MqlDateTime tm;
   if(num_work>0) shift=0;
//double IV[50],OV[10];
   ArraySetAsSeries(rates,true);
   TimeToStruct(TimeCurrent(),tm);
   int cm=tm.mon;int FileHandleOC=INVALID_HANDLE;int FileHandleStat=INVALID_HANDLE;
   int QPRF=0,QS=0,QCB=0,QZ=0,QCS=0,QB=0,Q=0;
   for(int ring=0;ring<4;ring++)
     {
      switch(ring)
        {
         case 0: num_vals=num_test;fnm=fname+"_"+smbl+"_M1_test_data.csv";  break;
         case 1: num_vals=num_valid;fnm=fname+"_"+smbl+"_M1_valid_data.csv";  break;
         case 2: num_vals=num_train;fnm=fname+"_"+smbl+"_"+TimeFrameName(tf)+".csv";  break;
         case 3: num_vals=num_work;fnm=fname+"_"+smbl+"_M1_prediction_data.csv";  break;
         default: num_vals=0;
        }
      if(num_vals>0)
        {
         if(num_train>0 && ring==2)
           {
            FileHandleOC=FileOpen("OracleDummy_fc.mqh",FILE_WRITE|FILE_ANSI,' ');
            if(FileHandleOC==INVALID_HANDLE)
              {
               Print("Error open file for write OracleDummy_fc.mqh");
               return(false);
              }
            FileHandleStat=FileOpen("stat.csv",FILE_WRITE|FILE_ANSI|FILE_CSV,';');
            if(FileHandleStat==INVALID_HANDLE)
              {
               Print("Error open file for write stat.csv");
               return(false);
              }
            FileWrite(FileHandleStat,// записываем в файл шапку
                      //                "Symbol","DayOfWeek","Hours","Minuta","Signal","QS","QWS","QW","QWB","QB");
                      "Symbol","SumTotalInSpread","QPRF","QS","QCB","QZ","QCS","QB","Q","MQS","MQCB","MQZ","MQCS","MQB");

           }
         FileHandle=FileOpen(fnm,FILE_CSV|FILE_ANSI|FILE_WRITE|FILE_REWRITE,",");
         if(FileHandle!=INVALID_HANDLE)
           {
            // Header
            outstr="";

            outstr=InputSignals;StringReplace(outstr," ",",");StringReplace(outstr,"-","_");
            outstr="prediction,"+outstr;            //outstr+=",Result";
            if(_debug_time) outstr="NormalTime,"+outstr;
            FileWrite(FileHandle,outstr);
            bool need_exp=true;
            int copied=CopyRates(_Symbol,tf,0,shift+num_vals,rates);
            if(num_train>0 && FileHandleOC!=INVALID_HANDLE)
              {
               FileWrite(FileHandleOC,"double od_forecast(datetime time,string smb)  ");
               FileWrite(FileHandleOC," {");

              }

            for(i=shift;i<(shift+num_vals);i++)
              {
               Result=GetVectors(InputVector,InputSignals,smbl,0,i);
               if(__Debug__) Comment(fnm+" "+(string)i);
               if(Result>1 || Result<-1) continue;

               outstr="";
               if(_debug_time) outstr+=(string)rates[i].time+",";
               need_exp=true; string ss="";
               if(_ResultAsString_)
                 {
                  if(Result>0.66) outstr+="""Buy""";
                  else if(Result>0.33) outstr+="""CloseSell""";
                  else if(Result>-0.33) outstr+="""Wait""";
                  else if(Result>-0.66) outstr+="""CloseBuy""";
                  else outstr+="""Sell""";
                 }
               else    outstr+=DoubleToString(Result,_Precision_);
               for(j=0;j<num_input_signals;j++)
                 {
                  ss=DoubleToString(InputVector[j],_Precision_);
                  outstr+=","+ss;
                 }

               FileWrite(FileHandle,outstr);
               //if(Result>-2&&(Result>0.33 || Result<-0.33))
               if(2==ring)
                 {
                  if(Result>=-1 && FileHandleOC!=INVALID_HANDLE && (Result>0.4 || Result<-0.4))
                    {
                     FileWrite(FileHandleOC,"  if(smb==\""+smbl+"\" && time==StringToTime(\""+(string)rates[i].time+"\")) return("+(string)Result+");");
                    }

                  if(Result>0.66) QB++;
                  else if(Result>.33) QCS++;
                  //else if(res>0.1) QWCS++;
                  else if(Result>-0.33) QZ++;
                  //else if(res>-.33) QWCB++;
                  else if(Result>-.66) QCB++;
                  else QS++;
                 }
              }
            FileClose(FileHandle);
            if(FileHandleOC!=INVALID_HANDLE)
              {
               FileWrite(FileHandleOC,"  return(0);");
               FileWrite(FileHandleOC," }");
               FileClose(FileHandleOC);
               Q=QS+QCB+QZ+QCS+QB;
               if(Q>0)
                  FileWrite(FileHandleStat,
                            smbl,0,_NumTS_,QS,QCB,QZ,QCS,QB,Q,
                            -1+(double)QS/Q,-1+2*(double)QS/Q+(double)QCB/Q
                            //,-1+2*(double)(QS+QCB)/Q+(double)QWCB/Q
                            ,0
                            //,1-2*(double)(QB+QCS)/Q-(double)QWCS/Q
                            ,1-2*(double)QB/Q-(double)QCS/Q,
                            1-(double)QB/Q);//,(string)tm.day+"/"+(string)tm.mon+"/"+(string)tm.year);
               FileClose(FileHandleStat);
              }
            if(ring==3 && Result!=0)
              {
               FileDelete(fnm);
              }
            else Print("Created.",fnm);
           }
         else
           {Print("Error open for write ",fnm);}
         shift+=num_vals;
        }
     }

   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COracleTemplate::loadSettings(string _filename)
  {
   if(""==_filename) _filename=Name()+".ini";
   int FileHandle=FileOpen(_filename,FILE_READ|FILE_ANSI|FILE_CSV,'=');
   string fr;
   if(FileHandle!=INVALID_HANDLE)
     {
      while(""!=(fr=FileReadString(FileHandle)))
        {
         if("inputSignals"==fr)
           {
            templateInputSignals=FileReadString(FileHandle);
           }
         if("Num_repeat"==fr)
           {
            num_repeat=(int)StringToInteger(FileReadString(FileHandle));
           }
        }
      FileClose(FileHandle);
      StringReplace(templateInputSignals,"  "," ");
      StringReplace(templateInputSignals,"  "," ");
      StringReplace(templateInputSignals,"  "," ");
      if(0==num_repeat) num_repeat=1;
      int start_pos=0,end_pos=0,shift_pos=0;
      end_pos=StringFind(templateInputSignals," ",start_pos);
      string fn_name;InputSignals="";
      do //while(end_pos>0)
        {
         fn_name=StringSubstr(templateInputSignals,start_pos,end_pos-start_pos);
         for(int i=0;i<num_repeat;i++)
           {
            num_input_signals++; ArrayResize(InputSignal,num_input_signals);
            if("DayOfWeek"==fn_name || "Hour"==fn_name || "Minute"==fn_name)
              {
               InputSignals+=fn_name+" "; InputSignal[num_input_signals-1]=fn_name;
               break;
              }
            else
              {
               InputSignals+=(string)i+"-"+fn_name+" ";
               InputSignal[num_input_signals-1]=(string)i+"-"+fn_name;
              }
           }
         start_pos=end_pos+1;    end_pos=StringFind(templateInputSignals," ",start_pos);
         if(start_pos==0 || start_pos==-1) break;
        }
      while(true);
      InputSignals=StringSubstr(InputSignals,0,StringLen(InputSignals)-1);
      //Print(Name()," inputSignals=",inputSignals," ",num_input_signals);
      //      if(0!=num_repeat) num_input_signals*=num_repeat;     
     }
   else
     {
      //      FileHandle=FileOpen(filename,FILE_WRITE|FILE_ANSI|FILE_CSV|FILE_COMMON,'=');
      //      if(FileHandle!=INVALID_HANDLE)
      //        {
      //         FileWrite(FileHandle,"inputSignals",inputSignals);
      //
      //         FileClose(FileHandle);
      //        }
     }
   Print(Name()," ready! IS: (",num_input_signals,")",InputSignals);
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COracleTemplate::saveSettings(string _filename)
  {
   if(""==_filename) _filename=Name()+".ini";
   int FileHandle=FileOpen(_filename,FILE_WRITE|FILE_ANSI|FILE_CSV,'=');
//string fr;
   if(FileHandle!=INVALID_HANDLE)
     {
      string AS,BS;
      for(int i=0;i<ArraySize(VectorFunctions);i++) AS=AS+" "+VectorFunctions[i];
      for(int i=0;i<ArraySize(BadVectorFunctions);i++) BS=BS+" "+BadVectorFunctions[i];
      FileWrite(FileHandle,"//How to use"," fill string separate space. Format TT-functionName_Paramm1_ParamX");
      FileWrite(FileHandle,"//Where TT"," shift on timeframe");
      FileWrite(FileHandle,"//example","ROC 5-ROC 10-ROC_13");
      FileWrite(FileHandle,"///Num_repeat","3 eqv ROC 1-ROC 2-ROC");

      FileWrite(FileHandle,"//Bad Signals",BS);
      FileWrite(FileHandle,"//Available Signals",AS);
      FileWrite(FileHandle,"inputSignals",templateInputSignals);
      FileWrite(FileHandle,"Num_repeat",num_repeat);
      FileClose(FileHandle);
     }
   return(true);
  }

COracleTemplate *AllOracles[];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class COracleENCOG:public COracleTemplate
  {
private:
   string            smb;
   string            Functions_Array[50];
   int               Functions_Count[50];
   //int               Max_Functions;
   ENUM_TIMEFRAMES   TimeFrame;
   string            File_Name;
   // begin Encog main config
   string            _FILENAME;
   int               _neuronCount;
   int               _layerCount;
   int               _contextTargetOffset[];
   int               _contextTargetSize[];
   bool              _hasContext;
   int               _inputCount;
   int               _layerContextCount[];
   int               _layerCounts[];
   int               _layerFeedCounts[];
   int               _layerIndex[];
   double            _layerOutput[];
   double            _layerSums[];
   int               _outputCount;
   int               _weightIndex[];
   double            _weights[];
   int               _activation[];
   double            _p[];
   // end Encog main config

   void              ActivationTANH(double &x[],int start,int size);
   void              ActivationSigmoid(double &x[],int start,int size);
   void              ActivationElliottSymmetric(double &x[],int start,int size);
   void              ActivationElliott(double &x[],int start,int size);

   //  void              Compute(double &_input[],double &_output[]);
   double Norm(double x,double normalizedHigh,double normalizedLow,double dataHigh,double dataLow)
     {
      return (((x - dataLow)
              /(dataHigh-dataLow))
              *(normalizedHigh-normalizedLow)+normalizedLow);
     }

   double DeNorm(double x,double normalizedHigh,double normalizedLow,double dataHigh,double dataLow)
     {
      return (((dataLow - dataHigh) * x - normalizedHigh
              *dataLow+dataHigh*normalizedLow)
              /(normalizedLow-normalizedHigh));
     }

public:
   void              Compute(double &_input[],double &_output[]);
   void              ComputeLayer(int currentLayer);
   virtual string    Name(){return("Encog");};
   bool              ClearTraning;
   //   double            InputVector[];

                     COracleENCOG(string FileName=""){Init(FileName);}
   //                 ~COracleENCOG(){DeInit();}
   bool              GetVector(string smbl="",int shift=0,bool train=false);
   //  bool              debug;
   void              Init(string FileName="",bool ip_debug=false);
   virtual void      DeInit();
   //   virtual double    forecast(string smbl="",int shift=0,bool train=false);
   bool              Load(string file_name);
   bool              Save(string file_name="");

   int               ExportDataWithTest(int train_qty,int test_qty,string &Symbols_Array[],string FileName="");
   int               ExportData(int qty,int shift,string &Symbols_Array[],string FileName,bool test=false);
   virtual bool      CustomLoad(int file_handle){return(false);};
   virtual bool      CustomSave(int file_handle){return(false);};
   virtual bool      Draw(int window,datetime &time[],int w,int h){return(true);};
   int               num_input();
   virtual double    forecast(string smbl,int shift,bool train);
   virtual double    forecast(string smbl,datetime startdt,bool train);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COracleENCOG::Init(string FileName="",bool ip_debug=false)
  {
//TimeFrame=PERIOD_M1;
   smb=Symbol();
   COracleTemplate::Init(FileName,ip_debug);
   if(""!=FileName) _FILENAME=FileName;
   else  _FILENAME=Name();

   string _filename=_FILENAME+"_"+smb+"_"+TimeFrameName(TimeFrame)+".eg";
   string inputString;
   ArrayResize(OutputVector,1);
   _layerCount=0; //int tempar
   _neuronCount=0;
   int FileHandle=FileOpen(_filename,FILE_READ|FILE_ANSI|FILE_CSV,'=');
   string fr;
   if(FileHandle!=INVALID_HANDLE)
     {
      while(""!=(fr=FileReadString(FileHandle)))
        {
         _layerCount=0;
         if("contextTargetOffset"==fr)
           {
            inputString=FileReadString(FileHandle);
            int start_pos=0,end_pos=0,shift_pos=0;
            end_pos=StringFind(inputString,",",start_pos);
            do
              {
               _layerCount++; ArrayResize(_contextTargetOffset,_layerCount);
               _contextTargetOffset[_layerCount-1]=(int)StringToInteger(StringSubstr(inputString,start_pos,end_pos-start_pos));
               start_pos=end_pos+1;    end_pos=StringFind(inputString,",",start_pos);
              }
            while(start_pos>0);
           }
         else if("contextTargetSize"==fr)
           {
            inputString=FileReadString(FileHandle);
            int start_pos=0,end_pos=0,shift_pos=0;
            end_pos=StringFind(inputString,",",start_pos);
            do
              {
               _layerCount++; ArrayResize(_contextTargetSize,_layerCount);
               _contextTargetSize[_layerCount-1]=(int)StringToInteger(StringSubstr(inputString,start_pos,end_pos-start_pos));
               start_pos=end_pos+1;    end_pos=StringFind(inputString,",",start_pos);
              }
            while(start_pos>0);
           }
         else if("layerContextCount"==fr)
           {
            inputString=FileReadString(FileHandle);
            int start_pos=0,end_pos=0,shift_pos=0;
            end_pos=StringFind(inputString,",",start_pos);
            do
              {
               _layerCount++; ArrayResize(_layerContextCount,_layerCount);
               _layerContextCount[_layerCount-1]=(int)StringToInteger(StringSubstr(inputString,start_pos,end_pos-start_pos));

               start_pos=end_pos+1;    end_pos=StringFind(inputString,",",start_pos);
              }
            while(start_pos>0);
           }
         else if("layerCounts"==fr)
           {
            inputString=FileReadString(FileHandle);
            int start_pos=0,end_pos=0,shift_pos=0;
            end_pos=StringFind(inputString,",",start_pos);
            do
              {
               _layerCount++; ArrayResize(_layerCounts,_layerCount);
               _layerCounts[_layerCount-1]=(int)StringToInteger(StringSubstr(inputString,start_pos,end_pos-start_pos));
               _neuronCount+=_layerCounts[_layerCount-1];
               start_pos=end_pos+1;    end_pos=StringFind(inputString,",",start_pos);
              }
            while(start_pos>0);
           }
         else if("layerFeedCounts"==fr)
           {
            inputString=FileReadString(FileHandle);
            int start_pos=0,end_pos=0,shift_pos=0;
            end_pos=StringFind(inputString,",",start_pos);
            do
              {
               _layerCount++; ArrayResize(_layerFeedCounts,_layerCount);
               _layerFeedCounts[_layerCount-1]=(int)StringToInteger(StringSubstr(inputString,start_pos,end_pos-start_pos));
               start_pos=end_pos+1;    end_pos=StringFind(inputString,",",start_pos);
              }
            while(start_pos>0);
           }
         else if("layerContextCount"==fr)
           {
            inputString=FileReadString(FileHandle);
            int start_pos=0,end_pos=0,shift_pos=0;
            end_pos=StringFind(inputString,",",start_pos);
            do
              {
               _layerCount++; ArrayResize(_layerContextCount,_layerCount);
               _layerContextCount[_layerCount-1]=(int)StringToInteger(StringSubstr(inputString,start_pos,end_pos-start_pos));
               start_pos=end_pos+1;    end_pos=StringFind(inputString,",",start_pos);
              }
            while(start_pos>0);
           }
         else if("layerIndex"==fr)
           {
            inputString=FileReadString(FileHandle);
            int start_pos=0,end_pos=0,shift_pos=0;
            end_pos=StringFind(inputString,",",start_pos);
            do
              {
               _layerCount++; ArrayResize(_layerIndex,_layerCount);
               _layerIndex[_layerCount-1]=(int)StringToInteger(StringSubstr(inputString,start_pos,end_pos-start_pos));
               start_pos=end_pos+1;    end_pos=StringFind(inputString,",",start_pos);
              }
            while(start_pos>0);
           }
         else if("inputCount"==fr)
           {
            inputString=FileReadString(FileHandle);
            _inputCount=(int)StringToInteger(inputString);
           }
         else if("outputCount"==fr)
           {
            inputString=FileReadString(FileHandle);
            _outputCount=(int)StringToInteger(inputString);
           }
         else if("hasContext"==fr)
           {
            inputString=FileReadString(FileHandle);

            _hasContext=("t"==inputString);
           }
         else if("output"==fr)
           {
            inputString=FileReadString(FileHandle);
            int start_pos=0,end_pos=0,shift_pos=0;
            end_pos=StringFind(inputString,",",start_pos);
            do
              {
               _layerCount++; ArrayResize(_layerOutput,_layerCount);
               _layerOutput[_layerCount-1]=(int)StringToInteger(StringSubstr(inputString,start_pos,end_pos-start_pos));
               start_pos=end_pos+1;    end_pos=StringFind(inputString,",",start_pos);
              }
            while(start_pos>0);
           }
         else if("weightIndex"==fr)
           {
            inputString=FileReadString(FileHandle);
            int start_pos=0,end_pos=0,shift_pos=0;
            end_pos=StringFind(inputString,",",start_pos);
            do
              {
               _layerCount++; ArrayResize(_weightIndex,_layerCount);
               _weightIndex[_layerCount-1]=(int)StringToInteger(StringSubstr(inputString,start_pos,end_pos-start_pos));
               start_pos=end_pos+1;    end_pos=StringFind(inputString,",",start_pos);
              }
            while(start_pos>0);
           }

         else if(StringFind(fr,"weights")!=-1)
           {
            int _weightsSize=_weightIndex[ArraySize(_weightIndex)-1];
            ArrayResize(_weights,_weightsSize,100);
            inputString=FileReadString(FileHandle);
            if("##0"==inputString) continue;
            int start_pos=0,end_pos=0,shift_pos=0;
            end_pos=StringFind(inputString,",",start_pos);
            do
              {
               _layerCount++; string ss=StringSubstr(inputString,start_pos,end_pos-start_pos);StringTrimLeft(ss);
               _weights[_layerCount-1]=(double)StringToDouble(ss);
               start_pos=end_pos+1;    end_pos=StringFind(inputString,",",start_pos);
              }
            while(start_pos>0);
           }
         else if(StringFind(fr,"##double")!=-1)
           {
            int _weightsSize=ArraySize(_weights);
            //           ArrayResize(_weights,_weightsSize,100);
            do
              {
               inputString=FileReadString(FileHandle);
               int start_pos=0,end_pos=0,shift_pos=0;
               end_pos=StringFind(inputString,",",start_pos);
               do
                 {
                  _layerCount++; string ss=StringSubstr(inputString,start_pos,end_pos-start_pos);StringTrimLeft(ss);
                  _weights[_layerCount-1]=(double)StringToDouble(ss);
                  start_pos=end_pos+1;    end_pos=StringFind(inputString,",",start_pos);
                 }
               while(start_pos>0);
              }
            while(_weightsSize>_layerCount);
            inputString=FileReadString(FileHandle);
           }
         else if(StringFind(fr,"[BASIC:ACTIVATION]")!=-1)
           {

            _layerCount=ArraySize(_weightIndex);
            ArrayResize(_activation,_layerCount); ArrayResize(_p,_layerCount);
            for(int i=0;i<_layerCount;i++)
              {
               inputString=FileReadString(FileHandle);
               _activation[i]=0;_p[i]=1;
               if(StringFind(inputString,"ActivationTANH")>0)_activation[i]=1;
              }
           }
         else if(StringFind(fr,"]")==-1) FileReadString(FileHandle);
        }
      FileClose(FileHandle);
      if(num_input_signals!=_inputCount)
        {
         Print("ini not for this eg!");_layerCount=0;
        }
      //num_input_signals=_inputCount;
      ArrayResize(InputVector,num_input_signals);

     }
   else
      Print("not found ",_filename);
//_layerCount=ArraySize(_weightIndex);
   ArrayResize(_layerSums,_neuronCount);
   ClearTraning=false;

   int i;
   for(i=0;i<ArraySize(VectorFunctions) && VectorFunctions[i]!=NULL && VectorFunctions[i]!="";i++)
     {
      Functions_Array[i]=VectorFunctions[i];
      Functions_Count[i]=0;
     }
   TimeFrame=_Period;
   GetVectors(InputVector,templateInputSignals,smb,0,1);
//for(i=0;i<ArraySize(IndHandles);i++)
//  {
//   int pops=1000;
//   while(pops>0)
//     {
//      if(BarsCalculated(IndHandles[i].hid)>0) break;
//      pops--;
//     }
//   if(pops==0) 
//   {
//   Print("Not calculate ",IndHandles[i].hname);
//   }
//  }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COracleENCOG::ActivationTANH(double &x[],int start,int size)
  {
   for(int i=start; i<start+size; i++)
     {
      x[i]=2.0/(1.0+MathExp(-2.0*x[i]))-1.0;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COracleENCOG::ActivationSigmoid(double &x[],int start,int size)
  {
   for(int i=start; i<start+size; i++)
     {
      x[i]=1.0/(1.0+MathExp(-1*x[i]));
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COracleENCOG::ActivationElliottSymmetric(double &x[],int start,int size)
  {
   for(int i=start; i<start+size; i++)
     {
      double s=_p[0];
      x[i]=(x[i]*s)/(1+MathAbs(x[i]*s));
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COracleENCOG::ActivationElliott(double &x[],int start,int size)
  {
   for(int i=start; i<start+size; i++)
     {
      double s=_p[0];
      x[i]=((x[i]*s)/2)/(1+MathAbs(x[i]*s))+0.5;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COracleENCOG::ComputeLayer(int currentLayer)
  {
   int x,y;
   int inputIndex=_layerIndex[currentLayer];
   int outputIndex=_layerIndex[currentLayer-1];
   int inputSize=_layerCounts[currentLayer];
   int outputSize=_layerFeedCounts[currentLayer-1];

   int index=_weightIndex[currentLayer-1];

   int limitX = outputIndex + outputSize;
   int limitY = inputIndex + inputSize;

// weight values
   for(x=outputIndex; x<limitX; x++)
     {
      double sum=0;
      for(y=inputIndex; y<limitY; y++)
        {
         sum+=_weights[index]*_layerOutput[y];
         index++;
        }

      _layerOutput[x]=sum;
      _layerSums[x]=sum;
     }

   switch(_activation[currentLayer-1])
     {
      case 0: // linear
         break;
      case 1:
         ActivationTANH(_layerOutput,outputIndex,outputSize);
         break;
      case 2:
         ActivationSigmoid(_layerOutput,outputIndex,outputSize);
         break;
      case 3:
         ActivationElliottSymmetric(_layerOutput,outputIndex,outputSize);
         break;
      case 4:
         ActivationElliott(_layerOutput,outputIndex,outputSize);
         break;
     }

// update context values
   int offset=_contextTargetOffset[currentLayer];

   for(x=0; x<_contextTargetSize[currentLayer]; x++)
     {
      _layerOutput[offset+x]=_layerOutput[outputIndex+x];
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COracleENCOG::Compute(double &_input[],double &_output[])
  {
   int i,x;
   int sourceIndex=_neuronCount
                   -_layerCounts[_layerCount-1];

   ArrayCopy(_layerOutput,_input,sourceIndex,0,_inputCount);

   for(i=_layerCount-1; i>0; i--)
     {
      ComputeLayer(i);
     }

// update context values
   int offset=_contextTargetOffset[0];

   for(x=0; x<_contextTargetSize[0]; x++)
     {
      _layerOutput[offset+x]=_layerOutput[x];
     }

   ArrayCopy(_output,_layerOutput,0,0,_outputCount);
  }
//+------------------------------------------------------------------+
double COracleENCOG::forecast(string smbl,int shift,bool train)
  {
   if(0==_layerCount) return(0);
   if(""==smbl) smbl=_Symbol;
   double sig=GetVectors(InputVector,InputSignals,smbl,0,shift);
   if(sig<-1||sig>1) return 0;
   Compute(InputVector,OutputVector);
   sig=OutputVector[0];
   int i,j;
   if(INVALID_HANDLE==errorFile)
     {
      errorFile=FileOpen("errors.txt",FILE_WRITE|FILE_ANSI|FILE_CSV,' ');
      FileWrite(errorFile,"debug info ");
     }

   if(AgeHistory<_HistorySignals_) AgeHistory++;
   for(i=AgeHistory;i>1;i--)
     {
      for(j=0;j<num_input_signals;j++) HistoryInputVector[j+(i-1)*num_input_signals]=HistoryInputVector[j+(i-2)*num_input_signals];
     }
   for(j=0;j<num_input_signals;j++)
      HistoryInputVector[j]=InputVector[j];

   for(i=1;i<AgeHistory;i++)
     {
      GetVectors(InputVector,InputSignals,smbl,0,i+shift);
      for(j=0;j<num_input_signals;j++)
        {
         if(HistoryInputVector[j+(i)*num_input_signals]!=InputVector[j])
           {
            FileWrite(errorFile,"not compare! ",InputSignal[j]," shift=",i," old= ",HistoryInputVector[j+(i)*num_input_signals]," new=",InputVector[j]);
            //Print("not compare! ",InputSignal[j]," shift=",i);
           }
         //HistoryInputVector[j+(i-1)*num_input_signals]=InputVector[j];
        }
     }

   return(sig);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

double COracleENCOG::forecast(string smbl,datetime startdt,bool train)
  {
   double sig=0;
//   double ind1_buffer[];
//   double ind2_buffer[];
//   int   h_ind1=iMA(smbl,PERIOD_M1,8,0,MODE_SMA,PRICE_CLOSE);
//   if(CopyBuffer(h_ind1,0,startdt,3,ind1_buffer)<3) return(0);
//   if(!ArraySetAsSeries(ind1_buffer,true)) return(0);
//   int   h_ind2=iMA(smbl,PERIOD_M1,16,0,MODE_SMA,PRICE_CLOSE);
//   if(CopyBuffer(h_ind2,0,startdt,2,ind2_buffer)<2) return(0);
//   if(!ArraySetAsSeries(ind2_buffer,true))return(0);
//
////--- проводим проверку условия и устанавливаем значение для sig
//   if(ind1_buffer[2]<ind2_buffer[1] && ind1_buffer[1]>ind2_buffer[1])
//      sig=1;
//   else if(ind1_buffer[2]>ind2_buffer[1] && ind1_buffer[1]<ind2_buffer[1])
//      sig=-1;
//   else sig=0;
//   IndicatorRelease(h_ind1);   IndicatorRelease(h_ind2);
////--- возвращаем торговый сигнал
   return(sig);
  }
//+------------------------------------------------------------------+

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
protected:
   double            m_adjusted_point;             // point value adjusted for 3 or 5 points
                                                   //CTrade            m_trade;                      // trading object
   //CSymbolInfo       m_symbol;                     // symbol info object
   //CPositionInfo     m_position;                   // trade position object
   //CAccountInfo      m_account;                    // account info wrapper
   string            symbol;
   //--- indicators
   int               m_handle_macd;                // MACD indicator handle
   int               m_handle_ema;                 // moving average indicator handle
   //--- indicator buffers
   double            m_buff_MACD_main[];           // MACD indicator main buffer
   double            m_buff_MACD_signal[];         // MACD indicator signal buffer
   double            m_buff_EMA[];                 // EMA indicator buffer
   int               pMACD1;
   int               pMACD2;
   int               pMACD3;
   int               pMATrendPeriod;
   //--- indicator data for processing
   double            m_macd_current;
   double            m_macd_previous;
   double            m_signal_current;
   double            m_signal_previous;
   double            m_ema_current;
   double            m_ema_previous;
   double            m_macd_open_level;
   double            m_macd_close_level;
public:
                   CiMACD(string FileName=""){Init();}
   virtual double    forecast(string smbl,int shift,bool train);
   virtual double    forecast(string smbl,datetime startdt,bool train);
   virtual string    Name(){return("iMACD");};
   bool              Init(string i_smbl="",int i_MACD1=0,
                          int i_MACD2=0,
                          int i_MACD3=0,
                          int i_MATrendPeriod=0);
protected:
   bool              InitCheckParameters(const int digits_adjust);
   bool              InitIndicators(void);

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CiMACD::Init(string i_smbl="",int i_MACD1=0,
                  int i_MACD2=0,
                  int i_MACD3=0,
                  int i_MATrendPeriod=0)
  {
   m_handle_macd=INVALID_HANDLE;
   m_handle_ema=INVALID_HANDLE;
   IsInit=true;
   symbol=i_smbl;
   pMACD1=i_MACD1;
   pMACD2=i_MACD2;
   pMACD3=i_MACD3;
   pMATrendPeriod =i_MATrendPeriod;
   if(""==symbol)symbol=Symbol();
   if(0==pMACD1) pMACD1 = 48; 
   if(0==pMACD2) pMACD2 = 36;
   if(0==pMACD3) pMACD3 = 19;
   if(0==pMATrendPeriod) pMATrendPeriod = 160;
   
   CSymbolInfo       m_symbol;
//--- initialize common information
   m_symbol.Name(symbol);              // symbol
                                       //   m_trade.SetExpertMagicNumber(12345);  // magic
//--- tuning for 3 or 5 digits
   int digits_adjust=1;
   if(m_symbol.Digits()==3 || m_symbol.Digits()==5)
      digits_adjust=10;
   m_adjusted_point=m_symbol.Point()*digits_adjust;
//--- set default deviation for trading in adjusted points
   m_macd_open_level =3*m_adjusted_point;
   m_macd_close_level=2*m_adjusted_point;
//m_traling_stop    =i_TrailingStop*m_adjusted_point;
//m_take_profit     =i_TakeProfit*m_adjusted_point;
//--- set default deviation for trading in adjusted points
//  m_trade.SetDeviationInPoints(3*digits_adjust);
//---
//  if(!InitCheckParameters(digits_adjust))
//    return(false);
   ArraySetAsSeries(m_buff_MACD_main,true);
   ArraySetAsSeries(m_buff_MACD_signal,true);
   ArraySetAsSeries(m_buff_EMA,true);
   if(!InitIndicators())
      return(false);
//--- succeed
   return(true);
  }
//+------------------------------------------------------------------+
//| Initialization of the indicators                                 |
//+------------------------------------------------------------------+
bool CiMACD::InitIndicators(void)
  {
//--- create MACD indicator
   if(m_handle_macd==INVALID_HANDLE)
      if((m_handle_macd=iMACD(NULL,0,pMACD1,pMACD2,pMACD3,PRICE_CLOSE))==INVALID_HANDLE)
        {
         printf("Error creating MACD indicator");
         return(false);
        }
//--- create EMA indicator and add it to collection
   if(m_handle_ema==INVALID_HANDLE)
      if((m_handle_ema=iMA(NULL,0,pMATrendPeriod,0,MODE_EMA,PRICE_CLOSE))==INVALID_HANDLE)
        {
         printf("Error creating EMA indicator");
         return(false);
        }
//--- succeed
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

double CiMACD::forecast(string smbl,int shift,bool train)
  {

   double sig=0;
   if(!IsInit) {
   Print("Not Init!");
   return(0);
   }
   if(""==smbl) smbl=Symbol();
   
   if(BarsCalculated(m_handle_macd)<2 || BarsCalculated(m_handle_ema)<2)
      return(sig);
   if(CopyBuffer(m_handle_macd,0,0,2,m_buff_MACD_main)  !=2 ||
      CopyBuffer(m_handle_macd,1,0,2,m_buff_MACD_signal)!=2 ||
      CopyBuffer(m_handle_ema,0,0,2,m_buff_EMA)         !=2)
      return(sig);
//   m_indicators.Refresh();
//--- to simplify the coding and speed up access
//--- data are put into internal variables
   m_macd_current   =m_buff_MACD_main[0];
   m_macd_previous  =m_buff_MACD_main[1];
   m_signal_current =m_buff_MACD_signal[0];
   m_signal_previous=m_buff_MACD_signal[1];
   m_ema_current    =m_buff_EMA[0];
   m_ema_previous   =m_buff_EMA[1];
//--- check for long position (BUY) possibility
   if(m_macd_current<0)
      if(m_macd_current>m_signal_current && m_macd_previous<m_signal_previous)
         if(MathAbs(m_macd_current)>(m_macd_open_level) && m_ema_current>m_ema_previous)
           {
            sig=1;
           }
//--- check for short position (SELL) possibility
   if(m_macd_current>0)
      if(m_macd_current<m_signal_current && m_macd_previous>m_signal_previous)
         if(m_macd_current>(m_macd_open_level) && m_ema_current<m_ema_previous)
           {
            sig=-1;
           }
//--- it is important to enter the market correctly, 
//--- but it is more important to exit it correctly...   
//--- first check if position exists - try to select it
//   if(m_position.Select(smbl))
//     {
//      if(m_position.PositionType()==POSITION_TYPE_BUY)
//        {
//         //--- try to close or modify long position
//         if(LongClosed())
//            return(true);
//         if(LongModified())
//            return(true);
//        }
//      else
//        {
//         //--- try to close or modify short position
//         if(ShortClosed())
//            return(true);
//         if(ShortModified())
//            return(true);
//        }
//     }
////--- no opened position identified
//   else
//     {
//      //--- check for long position (BUY) possibility
//      if(LongOpened())
//         return(true);
//      //--- check for short position (SELL) possibility
//      if(ShortOpened())
//         return(true);
//     }
//--- exit without position processing
   return(sig);

//   double ind1_buffer[];double ind2_buffer[];
//   int   h_ind1=iMACD(smbl,PERIOD_M1,12,26,9,PRICE_CLOSE);
//
//   if(CopyBuffer(h_ind1,0,shift,2,ind1_buffer)<2) return(0);
//   if(CopyBuffer(h_ind1,1,shift,3,ind2_buffer)<3) return(0);
//   if(!ArraySetAsSeries(ind1_buffer,true))         return(0);
//   if(!ArraySetAsSeries(ind2_buffer,true))         return(0);
//
////--- проводим проверку условия и устанавливаем значение для sig
//   if(ind2_buffer[2]>ind1_buffer[1] && ind2_buffer[1]<ind1_buffer[1])
//      sig=1;
//   else if(ind2_buffer[2]<ind1_buffer[1] && ind2_buffer[1]>ind1_buffer[1])
//      sig=-1;
//   else sig=0;
//
//   IndicatorRelease(h_ind1);
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
   //   double            InputVector[];

                     COracleANN(){Init();}
                    ~COracleANN(){DeInit();}
   bool              GetVector(string smbl="",int shift=0,bool train=false);
   //  bool              debug;
   virtual void      Init();
   //   virtual void              DeInit();
   //   virtual double    forecast(string smbl="",int shift=0,bool train=false);
   bool              Load(string file_name);
   bool              Save(string file_name="");
   //   int               ExportFANNDataWithTest(int train_qty,int test_qty,string &SymbolsArray[],string FileName="");
   //   int               ExportFANNData(int qty,int shift,string &SymbolsArray[],string FileName,bool test=false);
   int               ExportDataWithTest(int train_qty,int test_qty,string &Symbols_Array[],string FileName="");
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
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(FileHandle!=INVALID_HANDLE && FileHandleFANN!=INVALID_HANDLE)
     {// записываем в файл шапку
      FileWrite(FileHandleFANN,Max_Symbols*needcopy*((test)?1:2),num_input(),1);
      //     FileWrite(FileHandle,Max_Symbols*needcopy*((test)?1:2),num_input(),1);
      for(ma=0;ma<Max_Symbols;ma++)
        {
         Comment("Export ..."+FileName+" "+(string)((int)(100*((double)(1+ma)/Max_Symbols)))+"%");
         for(i=0;i<needcopy;shift++)
            //+------------------------------------------------------------------+
            //|                                                                  |
            //+------------------------------------------------------------------+
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
//   double IB[],OB[];
//   ArrayResize(IB,num_input()+2);
//   ArrayResize(OB,1+2);
//   ArrayResize(InputVector,num_input());
//   ArrayResize(OutputVector,3);
//   int FunctionsIdx;
////int n_vectors=num_input();
//   int n_o_vectors=1;
//   int pos_in=0,pos_out=0,i;
//   if(""==smbl) smbl=_Symbol;
//   if(WithHours || WithDayOfWeek)
//     {
//      MqlRates rates[];
//      ArraySetAsSeries(rates,true);
//      MqlDateTime tm;
//      CopyRates(smbl,PERIOD_M1,shift,3,rates);
//      TimeToStruct(rates[1].time,tm);
//      if(WithDayOfWeek) InputVector[pos_in++]=((double)tm.day_of_week/7);
//      if(WithDayOfWeek) InputVector[pos_in++]=((double)tm.hour/24);
//     }
//   if(!train)n_o_vectors=0;
//
////n_vectors=(n_vectors-pos_in);
//   for(FunctionsIdx=0; FunctionsIdx<10;FunctionsIdx++)
//     {
//      if(Get_Vectors(IB,OB,Functions_Count[FunctionsIdx],0,Functions_Array[FunctionsIdx],smbl,PERIOD_M1,shift))
//        {
//         // приведем к общему знаменателю
//         double si=1;
//         //            for(i=0;i<Functions_Count[FunctionsIdx];i++) si+=IB[i]*IB[i]; si=MathSqrt(si);
//         for(i=0;i<Functions_Count[FunctionsIdx];i++) InputVector[pos_in++]=IB[i]/si;
//
//         // for(i=0;i<n_o_vectors;i++)
//         //   {
//         //    OutputVector[i]=OB[i];
//         //    if(OB[i]<-3) OutputVector[i]=-0.5;
//         //    if(OB[i]>3) OutputVector[i]=0.5;
//         //    //OutputVector[i]=1*(1/(1+MathExp(-1*OB[i]/5))-0.5);
//         //   }
//        }
//     }
//   if(train && Get_Vectors(IB,OB,0,n_o_vectors,"",smbl,PERIOD_M1,shift))
//     {
//      for(i=0;i<n_o_vectors;i++)
//        {
//         OutputVector[i]=OB[i];
//         //if(OB[i]<-3) OutputVector[i]=-0.5;
//         //if(OB[i]>3) OutputVector[i]=0.5;
//         //OutputVector[i]=1*(1/(1+MathExp(-1*OB[i]/5))-0.5);
//        }
//
//     }
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
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
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
            //+------------------------------------------------------------------+
            //|                                                                  |
            //+------------------------------------------------------------------+
           {
            if(Functions_Array[i]==StringSubstr(outstr,0,sp-1)) Functions_Count[i]=(int)StringToInteger(StringSubstr(outstr,sp));;
           }
         outstr=FileReadString(file_handle);
        }
      if(outstr=="[Custom]") CustomLoad(file_handle);
      FileClose(file_handle);
      return(true);
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
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
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
     {
      Functions_Array[i]=VectorFunctions[i];
      Functions_Count[i]=0;
     }
   TimeFrame=_Period;
  }
//+------------------------------------------------------------------+
