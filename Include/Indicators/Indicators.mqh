//+------------------------------------------------------------------+
//|                                                   Indicators.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//|                                              Revision 2010.10.17 |
//+------------------------------------------------------------------+
#include "Trend.mqh"
#include "Oscilators.mqh"
#include "Volumes.mqh"
#include "BillWilliams.mqh"
#include "Custom.mqh"
#include "TimeSeries.mqh"
//+------------------------------------------------------------------+
//| Class CIndicators.                                               |
//| Purpose: Class for creation of collection of instances of        |
//|          technical indicators.                                   |
//+------------------------------------------------------------------+
class CIndicators : public CArrayObj
  {
protected:
   MqlDateTime       m_prev_time;

public:
                     CIndicators();
   //--- method for creation
   CIndicator*       Create(string symbol,ENUM_TIMEFRAMES period,ENUM_INDICATOR type,int count,MqlParam& params[]);
   //--- method of refreshing of the data of all indicators in the collection
   int               Refresh();
protected:
   //--- method of formation of flags timeframes
   int               TimeframesFlags();
  };
//+------------------------------------------------------------------+
//| Constructor CIndicators.                                         |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CIndicators::CIndicators()
  {
//--- initialize protected data
   m_prev_time.min=-1;
  }
//+------------------------------------------------------------------+
//| Indicator creation.                                              |
//| INPUT:  symbol    - indicator symbol,                            |
//|         period    - indicator period,                            |
//|         type      - indicator type,                              |
//|         count     - number of parameters,                        |
//|         params    - structure of parameters.                     |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CIndicator *CIndicators::Create(string symbol,ENUM_TIMEFRAMES period,ENUM_INDICATOR type,int count,MqlParam& params[])
  {
   CIndicator *result=NULL;
//---
   switch(type)
     {
      //--- Identifier of "Accelerator Oscillator"
      case IND_AC:
         if(count!=0) break;
         result=new CiAC;
         break;
      //--- Identifier of "Accumulation/Distribution"
      case IND_AD:
         if(count!=1) break;
         result=new CiAD;
         break;
      //--- Identifier of "Alligator"
      case IND_ALLIGATOR:
         if(count!=8) break;
         result=new CiAlligator;
         break;
      //--- Identifier of "Average Directional Index"
      case IND_ADX:
         if(count!=1) break;
         result=new CiADX;
         break;
      //--- Identifier of "Average Directional Index by Welles Wilder"
      case IND_ADXW:
         if(count!=1) break;
         result=new CiADXWilder;
         break;
      //--- Identifier of "Average True Range"
      case IND_ATR:
         if(count!=1) break;
         result=new CiATR;
         break;
      //--- Identifier of "Awesome Oscillator"
      case IND_AO:
         if(count!=0) break;
         result=new CiAO;
         break;
      //--- Identifier of "Bears Power"
      case IND_BEARS:
         if(count!=1) break;
         result=new CiBearsPower;
         break;
      //--- Identifier of "Bollinger Bands"
      case IND_BANDS:
         if(count!=4) break;
         result=new CiBands;
         break;
      //--- Identifier of "Bulls Power"
      case IND_BULLS:
         if(count!=1) break;
         result=new CiBullsPower;
         break;
      //--- Identifier of "Commodity Channel Index"
      case IND_CCI:
         if(count!=2) break;
         result=new CiCCI;
         break;
      //--- Identifier of "Chaikin Oscillator"
      case IND_CHAIKIN:
         if(count!=4) break;
         result=new CiChaikin;
         break;
      //--- Identifier of "DeMarker"
      case IND_DEMARKER:
         if(count!=1) break;
         result=new CiDeMarker;
         break;
      //--- Identifier of "Envelopes"
      case IND_ENVELOPES:
         if(count!=5) break;
         result=new CiEnvelopes;
         break;
      //--- Identifier of "Force Index"
      case IND_FORCE:
         if(count!=3) break;
         result=new CiForce;
         break;
      //--- Identifier of "Fractals"
      case IND_FRACTALS:
         if(count!=0) break;
         result=new CiFractals;
         break;
      //--- Identifier of "Gator oscillator"
      case IND_GATOR:
         if(count!=8) break;
         result=new CiGator;
         break;
      //--- Identifier of "Ichimoku Kinko Hyo"
      case IND_ICHIMOKU:
         if(count!=3) break;
         result=new CiIchimoku;
         break;
      //--- Identifier of "Moving Averages Convergence-Divergence"
      case IND_MACD:
         if(count!=4) break;
         result=new CiMACD;
         break;
      //--- Identifier of "Market Facilitation Index by Bill Williams"
      case IND_BWMFI:
         if(count!=1) break;
         result=new CiBWMFI;
         break;
      //--- Identifier of "Momentum"
      case IND_MOMENTUM:
         if(count!=2) break;
         result=new CiMomentum;
         break;
      //--- Identifier of "Money Flow Index"
      case IND_MFI:
         if(count!=2) break;
         result=new CiMFI;
         break;
      //--- Identifier of "Moving Average"
      case IND_MA:
         if(count!=4) break;
         result=new CiMA;
         break;
      //--- Identifier of "Moving Average of Oscillator (MACD histogram)"
      case IND_OSMA:
         if(count!=4) break;
         result=new CiOsMA;
         break;
      //--- Identifier of "On Balance Volume"
      case IND_OBV:
         if(count!=1) break;
         result=new CiOBV;
         break;
      //--- Identifier of "Parabolic Stop And Reverse System"
      case IND_SAR:
         if(count!=2) break;
         result=new CiSAR;
         break;
      //--- Identifier of "Relative Strength Index"
      case IND_RSI:
         if(count!=2) break;
         result=new CiRSI;
         break;
      //--- Identifier of "Relative Vigor Index"
      case IND_RVI:
         if(count!=1) break;
         result=new CiRVI;
         break;
      //--- Identifier of "Standard Deviation"
      case IND_STDDEV:
         if(count!=4) break;
         result=new CiStdDev;
         break;
      //--- Identifier of "Stochastic Oscillator"
      case IND_STOCHASTIC:
         if(count!=5) break;
         result=new CiStochastic;
         break;
      //--- Identifier of "Williams' Percent Range"
      case IND_WPR:
         if(count!=1) break;
         result=new CiWPR;
         break;
      //--- Identifier of "Double Exponential Moving Average"
      case IND_DEMA:
         if(count!=3) break;
         result=new CiDEMA;
         break;
      //--- Identifier of "Triple Exponential Moving Average"
      case IND_TEMA:
         if(count!=3) break;
         result=new CiTEMA;
         break;
      //--- Identifier of "Triple Exponential Moving Averages Oscillator"
      case IND_TRIX:
         if(count!=2) break;
         result=new CiTriX;
         break;
      //--- Identifier of "Fractal Adaptive Moving Average"
      case IND_FRAMA:
         if(count!=3) break;
         result=new CiFrAMA;
         break;
      //--- Identifier of "Adaptive Moving Average"
      case IND_AMA:
         if(count!=5) break;
         result=new CiAMA;
         break;
      //--- Identifier of "Variable Index DYnamic Average"
      case IND_VIDYA:
         if(count!=4) break;
         result=new CiVIDyA;
         break;
      //--- Identifier of "Volumes"
      case IND_VOLUMES:
         if(count!=1) break;
         result=new CiVolumes;
         break;
      //--- Identifier of "Custom"
      case IND_CUSTOM:
         if(count<=0) break;
         result=new CiCustom;
         break;
     }
   if(result!=NULL)
     {
      if(result.Create(symbol,period,type,count,params))
         Add(result);
      else
        {
         delete result;
         result=NULL;
        }
     }
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Refreshing of the data of all indicators in the collection.      |
//| INPUT:  no.                                                      |
//| OUTPUT: flags of updating timeframes.                            |
//| REMARK: flags are similar to "flags of visibility of objects".   |
//+------------------------------------------------------------------+
int CIndicators::Refresh()
  {
   int flags=TimeframesFlags();
//---
   for(int i=0;i<Total();i++)
     {
      CSeries *indicator=At(i);
      if(indicator!=NULL) indicator.Refresh(flags);
     }
//---
   return(flags);
  }
//+------------------------------------------------------------------+
//| Formation of timeframe flags.                                    |
//| INPUT:  no.                                                      |
//| OUTPUT: flags.                                                   |
//| REMARK: formation of flags is similar to "flags of visibility    |
//|         of objects".                                             |
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
int CIndicators::TimeframesFlags()
  {
   MqlDateTime time;
   int         result=OBJ_PERIOD_M1;
//--- check time
   TimeCurrent(time);
   if(time.min==m_prev_time.min &&
      time.hour==m_prev_time.hour &&
      time.day==m_prev_time.day &&
      time.mon==m_prev_time.mon) return(0);
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
