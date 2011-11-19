//+------------------------------------------------------------------+
//|                                         IndicatorsCollection.mqh |
//|                        Copyright 2009, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#include "Indicators.mqh"
//+------------------------------------------------------------------+
//| Class CIndicators.                                               |
//| Appointment: Create indicators.                                  |
//+------------------------------------------------------------------+
class CIndicators : public CArrayObj
  {
protected:
   MqlDateTime       m_prev_time;

public:
                     CIndicators();
   //--- method create
   CIndicator*       Create(ENUM_INDICATOR_TYPE type,string symbol,ENUM_TIMEFRAMES period,int& i_values[],double& d_values[],ENUM_MA_METHOD ma_method,int applied);
   //--- method of "freshening" of the data collection of all indicators
   int               Refresh();
protected:
   //--- method of formation of flags timeframes
   int               FormFlags();
  };
//+------------------------------------------------------------------+
//| Constructor CIndicators.                                |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CIndicators::CIndicators()
  {
   m_prev_time.min=-1;
  }
//+------------------------------------------------------------------+
//| Indicator creation.                                              |
//| INPUT:  type      -indicator type,                               |
//|         symbol    -chart symbol,                                 |
//|         period    -chart period,                                 |
//|         i_values  -array parameters of type int,                 |
//|         d_values  -array parameters of type double,              |
//|         ma_method -averaging method,                             |
//|         applied   -that average.                                 |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CIndicator *CIndicators::Create(ENUM_INDICATOR_TYPE type,string symbol,ENUM_TIMEFRAMES period,int& i_values[],double& d_values[],ENUM_MA_METHOD ma_method,int applied)
  {
   CIndicator *result=NULL;
//---
   switch(type)
     {
      //--- Identifier of "Accelerator Oscillator"
      case IT_AC:
         if((result=new CiAC)!=NULL) break;
         ((CiAC*)result).Create(symbol,period);
         break;
      //--- Identifier of "Accumulation/Distribution"
      case IT_AD:
         if((result=new CiAD)==NULL) break;
         ((CiAD*)result).Create(symbol,period,(ENUM_APPLIED_VOLUME)applied);
         break;
      //--- Identifier of "Alligator"
      case IT_ALLIGATOR:
         if(ArraySize(i_values)<6) return(NULL);
         if((result=new CiAlligator)==NULL) break;
         ((CiAlligator*)result).Create(symbol,period,i_values[0],i_values[1],i_values[2],i_values[3],i_values[4],i_values[5],ma_method,(ENUM_APPLIED_PRICE)applied);
         break;
      //--- Identifier of "Average Directional Index"
      case IT_ADX:
         if(ArraySize(i_values)<1) return(NULL);
         if((result=new CiADX)==NULL) break;
         ((CiADX*)result).Create(symbol,period,i_values[0]);
         break;
      //--- Identifier of "Average Directional Index by Welles Wilder"
      case IT_ADX_WILDER:
         if(ArraySize(i_values)<1) return(NULL);
         if((result=new CiADXWilder)==NULL) break;
         ((CiADXWilder*)result).Create(symbol,period,i_values[0]);
         break;
      //--- Identifier of "Average True Range"
      case IT_ATR:
         if(ArraySize(i_values)<1) return(NULL);
         if((result=new CiATR)==NULL) break;
         ((CiATR*)result).Create(symbol,period,i_values[0]);
         break;
      //--- Identifier of "Awesome Oscillator"
      case IT_AO:
         if((result=new CiAO)==NULL) break;
         ((CiAO*)result).Create(symbol,period);
         break;
      //--- Identifier of "Bears Power"
      case IT_BEARS_POWER:
         if(ArraySize(i_values)<1) return(NULL);
         if((result=new CiBearsPower)==NULL) break;
         ((CiBearsPower*)result).Create(symbol,period,i_values[0]);
         break;
      //--- Identifier of "Bollinger Bands"
      case IT_BANDS:
         if(ArraySize(i_values)<2 || ArraySize(d_values)<1) return(NULL);
         if((result=new CiBands)==NULL) break;
         ((CiBands*)result).Create(symbol,period,i_values[0],i_values[1],d_values[0],(ENUM_APPLIED_PRICE)applied);
         break;
      //--- Identifier of "Bulls Power"
      case IT_BULLS_POWER:
         if(ArraySize(i_values)<1) return(NULL);
         if((result=new CiBullsPower)==NULL) break;
         ((CiBullsPower*)result).Create(symbol,period,i_values[0]);
         break;
      //--- Identifier of "Commodity Channel Index"
      case IT_CCI:
         if(ArraySize(i_values)<1) return(NULL);
         if((result=new CiCCI)==NULL) break;
         ((CiCCI*)result).Create(symbol,period,i_values[0],(ENUM_APPLIED_PRICE)applied);
         break;
      //--- Identifier of "Chaikin Oscillator"
      case IT_CHAIKIN:
         if(ArraySize(i_values)<2) return(NULL);
         if((result=new CiChaikin)==NULL) break;
         ((CiChaikin*)result).Create(symbol,period,i_values[0],i_values[1],ma_method,(ENUM_APPLIED_VOLUME)applied);
         break;
      //--- Identifier of "DeMarker"
      case IT_DE_MARKER:
         if(ArraySize(i_values)<1) return(NULL);
         if((result=new CiDeMarker)==NULL) break;
         ((CiDeMarker*)result).Create(symbol,period,i_values[0]);
         break;
      //--- Identifier of "Envelopes"
      case IT_ENVELOPES:
         if(ArraySize(i_values)<2 || ArraySize(d_values)<1) return(NULL);
         if((result=new CiEnvelopes)==NULL) break;
         ((CiEnvelopes*)result).Create(symbol,period,i_values[0],i_values[1],ma_method,(ENUM_APPLIED_PRICE)applied,d_values[0]);
         break;
      //--- Identifier of "Force Index"
      case IT_FORCE_INDEX:
         if(ArraySize(i_values)<1) return(NULL);
         if((result=new CiForce)==NULL) break;
         ((CiForce*)result).Create(symbol,period,i_values[0],ma_method,(ENUM_APPLIED_VOLUME)applied);
         break;
      //--- Identifier of "Fractals"
      case IT_FRACTALS:
         if((result=new CiFractals)==NULL) break;
         ((CiFractals*)result).Create(symbol,period);
         break;
      //--- Identifier of "Gator oscillator"
      case IT_GATOR:
         if(ArraySize(i_values)<6) return(NULL);
         if((result=new CiGator)==NULL) break;
         ((CiGator*)result).Create(symbol,period,i_values[0],i_values[1],i_values[2],i_values[3],i_values[4],i_values[5],ma_method,(ENUM_APPLIED_PRICE)applied);
         break;
      //--- Identifier of "Ichimoku Kinko Hyo"
      case IT_ICHIMOKU:
         if(ArraySize(i_values)<3) return(NULL);
         if((result=new CiIchimoku)==NULL) break;
         ((CiIchimoku*)result).Create(symbol,period,i_values[0],i_values[1],i_values[2]);
         break;
      //--- Identifier of "Moving Averages Convergence-Divergence"
      case IT_MACD:
         if(ArraySize(i_values)<3) return(NULL);
         if((result=new CiMACD)==NULL) break;
         ((CiMACD*)result).Create(symbol,period,i_values[0],i_values[1],i_values[2],(ENUM_APPLIED_PRICE)applied);
         break;
      //--- Identifier of "Market Facilitation Index by Bill Williams"
      case IT_BWMFI:
         if((result=new CiBWMFI)==NULL) break;
         ((CiBWMFI*)result).Create(symbol,period,(ENUM_APPLIED_VOLUME)applied);
         break;
      //--- Identifier of "Momentum"
      case IT_MOMENTUM:
         if(ArraySize(i_values)<1) return(NULL);
         if((result=new CiMomentum)==NULL) break;
         ((CiMomentum*)result).Create(symbol,period,i_values[0],(ENUM_APPLIED_PRICE)applied);
         break;
      //--- Identifier of "Money Flow Index"
      case IT_MFI:
         if(ArraySize(i_values)<1) return(NULL);
         if((result=new CiMFI)==NULL) break;
         ((CiMFI*)result).Create(symbol,period,i_values[0],(ENUM_APPLIED_VOLUME)applied);
         break;
      //--- Identifier of "Moving Average"
      case IT_MA:
         if(ArraySize(i_values)<2) return(NULL);
         if((result=new CiMA)==NULL) break;
         ((CiMA*)result).Create(symbol,period,i_values[0],i_values[1],ma_method,(ENUM_APPLIED_PRICE)applied);
         break;
      //--- Identifier of "Moving Average of Oscillator (MACD histogram)"
      case IT_OSMA:
         if(ArraySize(i_values)<3) return(NULL);
         if((result=new CiOsMA)==NULL) break;
         ((CiOsMA*)result).Create(symbol,period,i_values[0],i_values[1],i_values[2],(ENUM_APPLIED_PRICE)applied);
         break;
      //--- Identifier of "On Balance Volume"
      case IT_OBV:
         if((result=new CiOBV)==NULL) break;
         ((CiOBV*)result).Create(symbol,period,(ENUM_APPLIED_VOLUME)applied);
         break;
      //--- Identifier of "Parabolic Stop And Reverse System"
      case IT_SAR:
         if(ArraySize(d_values)<2) return(NULL);
         if((result=new CiSAR)==NULL) break;
         ((CiSAR*)result).Create(symbol,period,d_values[0],d_values[1]);
         break;
      //--- Identifier of "Relative Strength Index"
      case IT_RSI:
         if(ArraySize(i_values)<1) return(NULL);
         if((result=new CiRSI)==NULL) break;
         ((CiRSI*)result).Create(symbol,period,i_values[0],(ENUM_APPLIED_PRICE)applied);
         break;
      //--- Identifier of "Relative Vigor Index"
      case IT_RVI:
         if(ArraySize(i_values)<1) return(NULL);
         if((result=new CiRVI)==NULL) break;
         ((CiRVI*)result).Create(symbol,period,i_values[0]);
         break;
      //--- Identifier of "Standard Deviation"
      case IT_STD_DEV:
         if(ArraySize(i_values)<2) return(NULL);
         if((result=new CiStdDev)==NULL) break;
         ((CiStdDev*)result).Create(symbol,period,i_values[0],i_values[1],ma_method,(ENUM_APPLIED_PRICE)applied);
         break;
      //--- Identifier of "Stochastic Oscillator"
      case IT_STOCHASTIC:
         if(ArraySize(i_values)<3) return(NULL);
         if((result=new CiStochastic)==NULL) break;
         ((CiStochastic*)result).Create(symbol,period,i_values[0],i_values[1],i_values[2],ma_method,(ENUM_STO_PRICE)applied);
         break;
      //--- Identifier of "Williams' Percent Range"
      case IT_WPR:
         if(ArraySize(i_values)<1) return(NULL);
         if((result=new CiWPR)==NULL) break;
         ((CiWPR*)result).Create(symbol,period,i_values[0]);
         break;
      //--- Identifier of "Double Exponential Moving Average"
      case IT_DEMA:
         if(ArraySize(i_values)<1) return(NULL);
         if((result=new CiDEMA)==NULL) break;
         ((CiDEMA*)result).Create(symbol,period,i_values[0],i_values[1],(ENUM_APPLIED_PRICE)applied);
         break;
      //--- Identifier of "Triple Exponential Moving Average"
      case IT_TEMA:
         if(ArraySize(i_values)<1) return(NULL);
         if((result=new CiTEMA)==NULL) break;
         ((CiTEMA*)result).Create(symbol,period,i_values[0],i_values[1],(ENUM_APPLIED_PRICE)applied);
         break;
      //--- Identifier of "Triple Exponential Moving Averages Oscillator"
      case IT_TRIX:
         if(ArraySize(i_values)<1) return(NULL);
         if((result=new CiTriX)==NULL) break;
         ((CiTriX*)result).Create(symbol,period,i_values[0],(ENUM_APPLIED_PRICE)applied);
         break;
      //--- Identifier of "Fractal Adaptive Moving Average"
      case IT_FRAMA:
         if(ArraySize(i_values)<1) return(NULL);
         if((result=new CiFrAMA)==NULL) break;
         ((CiFrAMA*)result).Create(symbol,period,i_values[0],i_values[1],(ENUM_APPLIED_PRICE)applied);
         break;
      //--- Identifier of "Adaptive Moving Average"
      case IT_AMA:
         if(ArraySize(i_values)<3) return(NULL);
         if((result=new CiAMA)==NULL) break;
         ((CiAMA*)result).Create(symbol,period,i_values[0],i_values[1],i_values[2],i_values[3],(ENUM_APPLIED_PRICE)applied);
         break;
      //--- Identifier of "Variable Index DYnamic Average"
      case IT_VIDYA:
         if(ArraySize(i_values)<2) return(NULL);
         if((result=new CiVIDyA)==NULL) break;
         ((CiVIDyA*)result).Create(symbol,period,i_values[0],i_values[1],i_values[2],(ENUM_APPLIED_PRICE)applied);
         break;
     }
   if(result!=NULL) Add(result);
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| "freshening" of the data collection of all indicators.           |
//| INPUT:  no.                                                      |
//| OUTPUT: flags are updated timeframes.                            |
//| REMARK: flags are similar "objects visibility flags".            |
//+------------------------------------------------------------------+
int CIndicators::Refresh()
  {
   int flags=FormFlags();
//---
   for(int i=0;i<Total();i++)
     {
      CIndicator *indicator=At(i);
      indicator.Refresh(flags);
     }
//---
   return(flags);
  }
//+------------------------------------------------------------------+
//| Formation of flags timeframes.                                   |
//| INPUT:  no.                                                      |
//| OUTPUT: flags.                                                   |
//| REMARK: flags formed similarly "objects visibility flags"        |
//|         OBJ_PERIOD_M1  =0x00000001                               |
//|         OBJ_PERIOD_M2  =0x00000002                               |
//|         OBJ_PERIOD_M3  =0x00000004                               |
//|         OBJ_PERIOD_M4  =0x00000008                               |
//|         OBJ_PERIOD_M5  =0x00000010                               |
//|         OBJ_PERIOD_M6  =0x00000020                               |
//|         OBJ_PERIOD_M10 =0x00000040                               |
//|         OBJ_PERIOD_M12 =0x00000080                               |
//|         OBJ_PERIOD_M15 =0x00000100                               |
//|         OBJ_PERIOD_M20 =0x00000200                               |
//|         OBJ_PERIOD_M30 =0x00000400                               |
//|         OBJ_PERIOD_H1  =0x00000800                               |
//|         OBJ_PERIOD_H2  =0x00001000                               |
//|         OBJ_PERIOD_H3  =0x00002000                               |
//|         OBJ_PERIOD_H4  =0x00004000                               |
//|         OBJ_PERIOD_H6  =0x00008000                               |
//|         OBJ_PERIOD_H8  =0x00010000                               |
//|         OBJ_PERIOD_H12 =0x00020000                               |
//|         OBJ_PERIOD_D1  =0x00040000                               |
//|         OBJ_PERIOD_W1  =0x00080000                               |
//|         OBJ_PERIOD_MN1 =0x00100000                               |
//+------------------------------------------------------------------+
int CIndicators::FormFlags()
  {
   MqlDateTime time;
   int         result=OBJ_PERIOD_M1;
//--- check time
   TimeCurrent(time);
   if(time.min==m_prev_time.min) return(0);
//---
   if(m_prev_time.min==-1) result=0x1FFFFF;
   m_prev_time=time;
//--- minutes
   if(time.min%2==0)       result|=OBJ_PERIOD_M2;   
   if(time.min%3==0)       result|=OBJ_PERIOD_M3;
   if(time.min%4==0)       result|=OBJ_PERIOD_M4;
   if(time.min%5==0)       result|=OBJ_PERIOD_M5;
   if(time.min%6==0)       result|=OBJ_PERIOD_M6;
   if(time.min%10==0)      result|=OBJ_PERIOD_M10;
   if(time.min%12==0)      result|=OBJ_PERIOD_M12;
   if(time.min%15==0)      result|=OBJ_PERIOD_M15;
   if(time.min%20==0)      result|=OBJ_PERIOD_M20;
   if(time.min%30==0)      result|=OBJ_PERIOD_M30;
   if(time.min!=0)         return(result);
//--- new hour
   result|=OBJ_PERIOD_H1;
   if(time.hour%2==0)      result|=OBJ_PERIOD_H2;
   if(time.hour%3==0)      result|=OBJ_PERIOD_H3;
   if(time.hour%4==0)      result|=OBJ_PERIOD_H4;
   if(time.hour%6==0)      result|=OBJ_PERIOD_H6;
   if(time.hour%8==0)      result|=OBJ_PERIOD_H8;
   if(time.hour%12==0)     result|=OBJ_PERIOD_H12;
   if(time.hour!=0)        return(result);
//--- new day
   result|=OBJ_PERIOD_D1;
//--- new week
   if(time.day_of_week==1) result|=OBJ_PERIOD_W1;
//--- new month
   if(time.day==1)         result|=OBJ_PERIOD_MN1;
//---
   return(result);
  }
//+------------------------------------------------------------------+
