//+------------------------------------------------------------------+
//|                                                      MT5FANN.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property copyright "Mariusz Woloszyn"
#property link      ""
#include <GC\IniFile.mqh>
//#include <Fann2MQL.mqh>
//#import "fanndoubleMT.dll"
//#import
#import "Fann2MQL114b2.dll"

int f2M_create_standard(int num_layers,int l1num,int l2num,int l3num,int l4num);
////int f2M_create_from_file(string path);
////меняем на
int f2M_create_from_file(char &path[]);
int f2M_run(int ann,double &input_vector[]);
int f2M_destroy(int ann);
int f2M_destroy_all_anns();

double f2M_get_output(int ann,int output);
int  f2M_get_num_input(int ann);
int  f2M_get_num_output(int ann);

int f2M_train(int ann,double &input_vector[],double &output_vector[]);
int f2M_train_fast(int ann,double &input_vector[],double &output_vector[]);
int f2M_randomize_weights(int ann,double min_weight,double max_weight);
double f2M_get_MSE(int ann);
//int f2M_save(int ann,string path);
int f2M_save(int ann,uchar &path[]);
int f2M_reset_MSE(int ann);
int f2M_test(int ann,double &input_vector[],double &output_vector[]);
int f2M_set_act_function_layer(int ann,int activation_function,int layer);
int f2M_set_act_function_hidden(int ann,int activation_function);
int f2M_set_act_function_output(int ann,int activation_function);

/* Threads functions */
int f2M_threads_init(int num_threads);
int f2M_threads_deinit();
int f2M_parallel_init();
int f2M_parallel_deinit();
int f2M_run_threaded(int anns_count,int &anns[],double &input_vector[]);
int f2M_run_parallel(int anns_count,int &anns[],double &input_vector[]);
#import
///* Creation/Execution */
//int f2M_create_standard(int num_layers,int l1num,int l2num,int l3num,int l4num);
//int f2M_destroy(int ann);
//int f2M_destroy_all_anns();
//int f2M_run(int ann,double &input_vector[]);
//double f2M_get_output(int ann,int output);
//int f2M_randomize_weights(int ann,double min_weight,double max_weight);
///* Creation/Execution Parameters */
//int  f2M_get_num_input(int ann);
//int  f2M_get_num_output(int ann);
//
///* Training */
//int f2M_train(int ann,double &input_vector[],double &output_vector[]);
//int f2M_train_fast(int ann,double &input_vector[],double &output_vector[]);
//int f2M_test(int ann,double &input_vector[],double &output_vector[]);
//double f2M_get_MSE(int ann);
//int f2M_get_bit_fail(int ann);
//int f2M_reset_MSE(int ann);
///* Training Parameters */
//int f2m_get_training_algorithm(int ann);
//int f2m_set_training_algorithm(int ann,int training_algorithm);
//int f2M_set_act_function_layer(int ann,int activation_function,int layer);
//int f2M_set_act_function_hidden(int ann,int activation_function);
//int f2M_set_act_function_output(int ann,int activation_function);
//
///* Data training */
//int f2M_train_on_file(int ann,string filename,int max_epoch,float desired_error);
//
///* File Input/Output */
////int f2M_create_from_file(string path);
////int f2M_create_from_file(string path);
////меняем на
//int f2M_create_from_file(uchar& path[]);
////int f2M_save(int ann,string path);
//int f2M_save(int ann,uchar &path[]);
///* Parallel processing functions */
//int f2M_parallel_init();
//int f2M_parallel_deinit();
//int f2M_run_parallel(int anns_count,int &anns[],double &input_vector[]);
//int f2M_train_parallel(int anns_count,int &anns[],double &input_vector[],double &output_vector[]);
//#import

#define F2M_MAX_THREADS	64

#define FANN_DOUBLE_ERROR	-1000000000

#define FANN_LINEAR                     0
#define FANN_THRESHOLD	                1
#define FANN_THRESHOLD_SYMMETRIC        2
#define FANN_SIGMOID                    3
#define FANN_SIGMOID_STEPWISE           4
#define FANN_SIGMOID_SYMMETRIC          5
#define FANN_SIGMOID_SYMMETRIC_STEPWISE 6
#define FANN_GAUSSIAN                   7
#define FANN_GAUSSIAN_SYMMETRIC         8
#define FANN_GAUSSIAN_STEPWISE          9
#define FANN_ELLIOT                     10
#define FANN_ELLIOT_SYMMETRIC           11
#define FANN_LINEAR_PIECE               12
#define FANN_LINEAR_PIECE_SYMMETRIC     13
#define FANN_SIN_SYMMETRIC              14
#define FANN_COS_SYMMETRIC              15
#define FANN_SIN                        16
#define FANN_COS                        17

#define FANN_TRAIN_INCREMENTAL			0
#define FANN_TRAIN_BATCH				1
#define FANN_TRAIN_RPROP				2
#define FANN_TRAIN_QUICKPROP			3
//+------------------------------------------------------------------+
//|     CMT5FANN                                                     |
//+------------------------------------------------------------------+
class CMT5FANN
  {// changes
private:
   string            Symbols_Array[30];
   int               Max_Symbols;
   int               FileHandle;
   int               num_in_vectors;
   int               num_out_vectors;
   string            File_Name;
   CIniFile          MyIniFile;                       // Создаем экземпляр класса
   CArrayString      Strings;                     // Необходим для работы с массивами данных
   int               ann;
   int               num_layers;
   int               CreateAnn();

public:
   int ann_load(string path)
     {
      char p[];
      StringToCharArray(path,p);
      return(f2M_create_from_file(p));
     }
   bool ann_save(string path)
     {
      char p[];
      StringToCharArray(path,p,0,-1,CP_OEMCP);
      if(debug)Print(ann,CharArrayToString(p,0,WHOLE_ARRAY,CP_OEMCP));
      if(f2M_save(ann,p)<0)
        {
         if(debug)Print("ne shmogla");
         return(false);
        }
      return(true);
     }
   bool              debug;
                     CMT5FANN(){debug=false;f2M_parallel_init();num_layers=4;}
                    ~CMT5FANN(){DeInit();}
   bool              Init(string FileName,string &SymbolsArray[],int MaxSymbols,int num_invectors,int num_outvectors,int new_num_layers);
   bool              Init(string FileName);
   void              DeInit();
   bool              GetVectors(double &InputVector[],double &OutputVector[],int num_vectors,string smbl="",ENUM_TIMEFRAMES tf=0,int npf=3,int shift=0);

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMT5FANN::DeInit()
  {
   ann_save(TerminalInfoString(TERMINAL_DATA_PATH)+"\\MQL5\\Files\\"+File_Name+".net");
   f2M_destroy(ann);
//   f2M_save(ann,File_Name+".net");
//   Print(TerminalInfoString(TERMINAL_DATA_PATH)+"\\MQL5\\Files\\"+File_Name+".net");
  }
//+------------------------------------------------------------------+
bool  CMT5FANN::Init(string FileName,string &SymbolsArray[],int MaxSymbols,int num_invectors,int num_outvectors,int new_num_layers)
  {
   if(debug) Print("Full init...");
   File_Name=FileName;
   Max_Symbols=ArrayCopy( Symbols_Array,SymbolsArray);
   Max_Symbols=MaxSymbols;
   num_in_vectors=num_invectors;
   num_out_vectors=num_outvectors;
   num_layers=new_num_layers;
   MyIniFile.Init(TerminalInfoString(TERMINAL_DATA_PATH)+"\\MQL5\\Files\\"+FileName+".ini");
// Пишем 
   bool     resb;
//string outstr;
   for(int SymbolIdx=0; SymbolIdx<MaxSymbols;SymbolIdx++)
     {

      resb=MyIniFile.WriteString("SymbolsArray",Symbols_Array[SymbolIdx],"True");
      if(!resb)
         //{if(debug) Print("Ok write string");}
         //else
        {if(debug) Print("Error on write string");return(false);}
     }
   if(!MyIniFile.WriteInteger("VectorsSize","Input",num_in_vectors))
     {File_Name="";if(debug) Print("Error on write num_in_vectors");return(false);}
   if(!MyIniFile.WriteInteger("VectorsSize","Output",num_out_vectors))
     {File_Name="";if(debug) Print("Error on write num_out_vectors");return(false);}
   if(!MyIniFile.WriteInteger("Layers","Num",num_layers))
     {File_Name="";if(debug) Print("Error on write num_layers");return(false);}
   if(-1==(ann=CreateAnn()))
     {
      File_Name="";
      return(false);
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool  CMT5FANN::Init(string FileName)
  {
   File_Name=FileName;

   MyIniFile.Init(TerminalInfoString(TERMINAL_DATA_PATH)+"\\MQL5\\Files\\"+FileName+".ini");
// Проверяем, если секция существует, читаем ее KeyNames
   if(MyIniFile.SectionExists("SymbolsArray"))
     {
      MyIniFile.ReadSection("SymbolsArray",Strings);
      Max_Symbols=Strings.Total();
      for(int i=0; i<Strings.Total(); i++)
        {Symbols_Array[i]=Strings.At(i);if(debug) Print(Strings.At(i));}
     }
   else
     {
      File_Name="";
      return(false);
     }
   if(0==(num_in_vectors=(int)MyIniFile.ReadInteger("VectorsSize","Input",0)))
     {File_Name="";if(debug) Print("Error on read num_in_vectors");return(false);}
   if(0==(num_out_vectors=(int)MyIniFile.ReadInteger("VectorsSize","Output",0)))
     {File_Name="";if(debug) Print("Error on read num_out_vectors");return(false);}
   if(0==(num_layers=(int)MyIniFile.ReadInteger("Layers","Num",0)))
     {File_Name="";if(debug) Print("Error on read num_layers");return(false);}
   if(-1==(ann=ann_load(TerminalInfoString(TERMINAL_DATA_PATH)+"\\MQL5\\Files\\"+File_Name+".net")))
     {
      File_Name="";
      return(false);
     }
   Print(ann);
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

int CMT5FANN::CreateAnn()
  {
   ann=f2M_create_standard(4,2,4,5,2);
   //ann=f2M_create_standard(num_layers,num_in_vectors,num_in_vectors*2,num_in_vectors,num_out_vectors);
//  f2M_set_act_function_hidden(ann,6);
//  f2M_set_act_function_output(ann,6);
   f2M_randomize_weights(ann,-0.7,0.7);
   if(debug)Print("ANN: created successfully with handler "+IntegerToString(ann));
   if(ann==-1) Print("ERROR INITIALIZING NETWORK!");
   return(ann);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

bool CMT5FANN::GetVectors(double &InputVector[],double &OutputVector[],int num_vectors,string smbl="",ENUM_TIMEFRAMES tf=0,int npf=3,int shift=0)
  {// пара, период, смещение назад (для индикатора полезно)
   int shft_his=7;
   int shft_cur=0;

   if(""==smbl) smbl=_Symbol;
   if(0==tf) tf=_Period;
   double Close[];
   ArraySetAsSeries(Close,true);
// копируем историю
   int maxcount=CopyClose(smbl,tf,shift,num_vectors+2,Close);
   ArrayInitialize(InputVector,EMPTY_VALUE);
   ArrayInitialize(OutputVector,EMPTY_VALUE);
   if(maxcount<num_vectors)
     {
      Print("Shift = ",shift," maxcount = ",maxcount);
      return(false);
     }
   int i;
   for(i=1;i<num_vectors;i++)
     {
      // вычислим и отнормируем
      InputVector[i-1]=100*(Close[i]-Close[i+1]);
     }
   OutputVector[0]=100*(Close[1]-Close[2]);
   return(true);
  }
//+------------------------------------------------------------------+
