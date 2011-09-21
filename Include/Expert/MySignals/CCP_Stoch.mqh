//+------------------------------------------------------------------+
//|                                                    CCP_Stoch.mqh |
//|                        Copyright 2011, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//|                                              Revision 2011.04.19 |
//+------------------------------------------------------------------+
#include "CandlePatterns.mqh"
// wizard description start
//+------------------------------------------------------------------+
//| Description of the class                                         |
//| Title=Signals based on Candlestick Patterns+Stochastic           |
//| Type=Signal                                                      |
//| Name=CCP_Stoch                                                   |
//| Class=CCP_Stoch                                                  |
//| Page=                                                            |
//| Parameter=StochPeriodK,int,33                                    |
//| Parameter=StochPeriodD,int,37                                    |
//| Parameter=StochPeriodSlow,int,30                                 |
//| Parameter=StochApplied,ENUM_STO_PRICE,STO_LOWHIGH                |
//| Parameter=MAPeriod,int,25                                        |
//+------------------------------------------------------------------+
// wizard description end
//+------------------------------------------------------------------+
//| CCP_Stoch Class.                                                 |
//| Purpose: Trading signals class, based on                         |
//| Japanese Candlestick Patterns                                    |
//| with confirmation by Stochastic indicator                        |
//| Derived from CCandlePattern class.                               |
//+------------------------------------------------------------------+
class CCP_Stoch : public CCandlePattern
  {
protected:
   CiStochastic      m_stoch;
   CPriceSeries      *m_app_price_high;
   CPriceSeries      *m_app_price_low;
   //--- input parameters
   int               m_periodK;
   int               m_periodD;
   int               m_period_slow;
   ENUM_STO_PRICE    m_applied;

public:
   //--- class constructor
                     CCP_Stoch();
   //--- input parameters initialization methods
   void              StochPeriodK(int period)              { m_periodK=period;            }
   void              StochPeriodD(int period)              { m_periodD=period;            }
   void              StochPeriodSlow(int period)           { m_period_slow=period;        }
   void              StochApplied(ENUM_STO_PRICE applied)  { m_applied=applied;           }
   //--- initialization of indicators
   virtual bool      ValidationSettings();
   virtual bool      InitIndicators(CIndicators *indicators);
   //---
   virtual bool      CheckOpenLong(double &price,double &sl,double &tp,datetime &expiration);
   virtual bool      CheckCloseLong(double &price);
   virtual bool      CheckOpenShort(double &price,double &sl,double &tp,datetime &expiration);
   virtual bool      CheckCloseShort(double &price);

protected:
   //--- Stochastic initialization method
   bool              InitStoch(CIndicators *indicators);
   //--- lines of Stochastic indicator
   double            StochMain(int ind)         const      { return(m_stoch.Main(ind));   }
   double            StochSignal(int ind)       const      { return(m_stoch.Signal(ind)); }
  };
//+------------------------------------------------------------------+
//| CCP_Stoch class constructor.                                  |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CCP_Stoch::CCP_Stoch()
  {
//--- set default inputs
   m_periodK    =7;
   m_periodD    =11;
   m_period_slow=15;
   m_applied    =STO_LOWHIGH;
  }
//+------------------------------------------------------------------+
//| Validation settings.                                             |
//| INPUT:  no.                                                      |
//| OUTPUT: true-if settings are correct, false otherwise.           |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CCP_Stoch::ValidationSettings()
  {
   if(!CCandlePattern::ValidationSettings()) return(false);
//--- initial input parameters
   if(m_periodK<=0)
     {
      printf(__FUNCTION__+": period %K Stochastic must be greater than 0");
      return(false);
     }
   if(m_periodD<=0)
     {
      printf(__FUNCTION__+": period %D Stochastic must be greater than 0");
      return(false);
     }
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| Create indicators.                                               |
//| INPUT:  indicators -pointer of indicator collection.             |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CCP_Stoch::InitIndicators(CIndicators *indicators)
  {
//--- check
   if(indicators==NULL) return(false);
   if(!CCandlePattern::InitIndicators(indicators)) return(false);
//--- create and initialize Stochastic indicator
   if(!InitStoch(indicators))                      return(false);
   if(m_applied==STO_CLOSECLOSE)
     {
      //--- copy Close series
      m_app_price_high=GetPointer(m_close);
      //--- copy Close series
      m_app_price_low=GetPointer(m_close);
     }
   else
     {
      //--- copy High series
      m_app_price_high=GetPointer(m_high);
      //--- copy Low series
      m_app_price_low=GetPointer(m_low);
     }
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| Create Stochastic indicators.                                    |
//| INPUT:  indicators -pointer of indicator collection.             |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CCP_Stoch::InitStoch(CIndicators *indicators)
  {
//--- add Stochastic indicator to collection
   if(!indicators.Add(GetPointer(m_stoch)))
     {
      printf(__FUNCTION__+": error adding object");
      return(false);
     }
//--- initialize Stochastic indicator
   if(!m_stoch.Create(m_symbol.Name(),m_period,m_periodK,m_periodD,m_period_slow,MODE_SMA,m_applied))
     {
      printf(__FUNCTION__+": error initializing object");
      return(false);
     }
   m_stoch.BufferResize(50);
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| Check conditions for long position open.                         |
//| INPUT:  price      - refernce for price,                         |
//|         sl         - refernce for stop loss,                     |
//|         tp         - refernce for take profit,                   |
//|         expiration - refernce for expiration.                    |
//| OUTPUT: true-if condition performed, false otherwise.            |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CCP_Stoch::CheckOpenLong(double &price,double &sl,double &tp,datetime &expiration)
  {
//--- check formation of bullish pattern
  if (!CheckPatternAllBullish()) return(false);
//--- check signal line of stochastic indicator
  if (!(StochSignal(1)<30))      return(false);
//--- ok, use market orders
   price=0.0;
   sl   =0.0;
   tp   =0.0;
//--- set signal to open long position
   return(true);
  }
//+------------------------------------------------------------------+
//| Check conditions for long position close.                        |
//| INPUT:  price - refernce for price.                              |
//| OUTPUT: true-if condition performed, false otherwise.            |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CCP_Stoch::CheckCloseLong(double &price)
  {
  if (!CheckPatternAllBearish())                       return(true);  
//--- check conditions of long position closing
   if(!(((StochSignal(1)<80) && (StochSignal(2)>80)) ||
        ((StochSignal(1)<20) && (StochSignal(2)>20)))) return(false);
//--- ok, use market orders
   price=0.0;
//--- set signal to close long position
   return(true);
  }
//+------------------------------------------------------------------+
//| Check conditions for short position open.                        |
//| INPUT:  price      - refernce for price,                         |
//|         sl         - refernce for stop loss,                     |
//|         tp         - refernce for take profit,                   |
//|         expiration - refernce for expiration.                    |
//| OUTPUT: true-if condition performed, false otherwise.            |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CCP_Stoch::CheckOpenShort(double &price,double &sl,double &tp,datetime &expiration)
  {         
//--- check formation of bearish pattern
  if (!CheckPatternAllBearish()) return(false);  
//--- check signal line of stochastic indicator
  if (!(StochSignal(1)>70))      return(false);
//--- ok, use market orders
   price=0.0;
   sl   =0.0;
   tp   =0.0;
//--- set signal to open short position
   return(true);
  }
//+------------------------------------------------------------------+
//| Check conditions for short position close.                       |
//| INPUT:  price - refernce for price.                              |
//| OUTPUT: true-if condition performed, false otherwise.            |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CCP_Stoch::CheckCloseShort(double &price)
  {
  if (!CheckPatternAllBullish())                       return(true);  
//--- check conditions of short position closing
   if(!(((StochSignal(1)>20) && (StochSignal(2)<20)) ||
        ((StochSignal(1)>80) && (StochSignal(2)<80)))) return(false);
//--- ok, use market orders
   price=0.0;
//--- set signal to close short position
   return(true);
  }
//+------------------------------------------------------------------+