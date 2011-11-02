//+------------------------------------------------------------------+
//|                                         SignalSilverChannels.mqh |
//|                      Copyright © 2010, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//|                                              Revision 2010.08.26 |
//+------------------------------------------------------------------+
#include <Expert\ExpertSignal.mqh>
#include <Indicators\Custom.mqh>
//--- inputs
input int    Inp_Signal_SilverChannels_Period    =26;     // Signal::SilverChannels::Period
input double Inp_Signal_SilverChannels_Silver    =38.2;   // Signal::SilverChannels::Silver
input double Inp_Signal_SilverChannels_Sky       =23.6;   // Signal::SilverChannels::Sky
input double Inp_Signal_SilverChannels_Future    =61.8;   // Signal::SilverChannels::Future
input int    Inp_Signal_SilverChannels_TakeProfit=50;     // Signal::SilverChannels::TakeProfit
input int    Inp_Signal_SilverChannels_StopLoss  =20;     // Signal::SilverChannels::StopLoss
//+------------------------------------------------------------------+
//| Class CSignalSilverChannels.                                     |
//| Appointment: Class trading signals                               |
//|              breakdown of the sivver channel.                    |
//|              Derives from class CExpertSignal.                   |
//+------------------------------------------------------------------+
class CSignalSilverChannels : public CExpertSignal
  {
protected:
   CiCustom         *m_SilverChannels;
   CiMA             *m_close;

public:
                     CSignalSilverChannels();
   //---
   virtual bool      InitIndicators(CIndicators *indicators);
   //---
   virtual bool      CheckOpenLong(double& price,double& sl,double& tp,datetime& expiration);
   virtual bool      CheckCloseLong(double& price);
   virtual bool      CheckOpenShort(double& price,double& sl,double& tp,datetime& expiration);
   virtual bool      CheckCloseShort(double& price);

protected:
   bool              InitSilverChannels(CIndicators *indicators);
   bool              InitClose(CIndicators *indicators);
   //---
   double            Close(int ind)   { return(m_close.Main(ind));               }
   double            SilHigh(int ind) { return(m_SilverChannels.GetData(0,ind)); }
   double            SilLow(int ind)  { return(m_SilverChannels.GetData(1,ind)); }
   double            SkyHigh(int ind) { return(m_SilverChannels.GetData(2,ind)); }
   double            SkyLow(int ind)  { return(m_SilverChannels.GetData(3,ind)); }
   double            ZenHigh(int ind) { return(m_SilverChannels.GetData(4,ind)); }
   double            ZenLow(int ind)  { return(m_SilverChannels.GetData(5,ind)); }
   double            FutHigh(int ind) { return(m_SilverChannels.GetData(6,ind)); }
   double            FutLow(int ind)  { return(m_SilverChannels.GetData(7,ind)); }
  };
//+------------------------------------------------------------------+
//| Constructor CSignalSilverChannels.                               |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CSignalSilverChannels::CSignalSilverChannels()
  {
//--- initialize protected data
   m_SilverChannels=NULL;
  }
//+------------------------------------------------------------------+
//| Create indicators.                                               |
//| INPUT:  indicators -pointer of indicator collection.             |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CSignalSilverChannels::InitIndicators(CIndicators *indicators)
  {
//--- create and initialize SilverChannels indicator
   if(!InitSilverChannels(indicators)) return(false);
//--- create and initialize close indicator
   if(!InitClose(indicators))          return(false);
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| Create SilverChannels indicators.                                |
//| INPUT:  indicators -pointer of indicator collection.             |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CSignalSilverChannels::InitSilverChannels(CIndicators *indicators)
  {
   MqlParam params[5];
//--- create SilverChannels indicator and add it to collection
   if(m_SilverChannels==NULL)
      if((m_SilverChannels=new CiCustom)==NULL)
         return(false);
   if(!indicators.Add(m_SilverChannels))
      return(false);
//--- prepare data for initialize SilverChannels indicator
   params[0].type         =TYPE_STRING;
   params[0].string_value ="Silver-channels";
   params[1].type         =TYPE_INT;
   params[1].integer_value=Inp_Signal_SilverChannels_Period;
   params[2].type         =TYPE_DOUBLE;
   params[2].double_value =Inp_Signal_SilverChannels_Silver;
   params[3].type         =TYPE_DOUBLE;
   params[3].double_value =Inp_Signal_SilverChannels_Sky;
   params[4].type         =TYPE_DOUBLE;
   params[4].double_value =Inp_Signal_SilverChannels_Future;
//--- initialize SilverChannels indicator
   if(!m_SilverChannels.NumBuffers(8))
      return(false);
   if(!m_SilverChannels.Create(m_symbol.Name(),m_period,IND_CUSTOM,5,params))
      return(false);
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| Create Close indicators.                                         |
//| INPUT:  indicators -pointer of indicator collection.             |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CSignalSilverChannels::InitClose(CIndicators *indicators)
  {
//--- create close indicator and add it to collection
   if(m_close==NULL)
      if((m_close=new CiMA)==NULL)
         return(false);
   if(!indicators.Add(m_close))
      return(false);
//--- initialize close indicator
   if(!m_close.Create(m_symbol.Name(),m_period,1,0,MODE_SMA,PRICE_CLOSE))
      return(false);
   m_close.FullRelease(true);
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
bool CSignalSilverChannels::CheckOpenLong(double& price,double& sl,double& tp,datetime& expiration)
  {
   price=0.0;
   sl   =m_symbol.Ask()-Inp_Signal_SilverChannels_StopLoss*m_adjusted_point;
   tp   =m_symbol.Ask()+Inp_Signal_SilverChannels_TakeProfit*m_adjusted_point;
//---
   return(Close(2)<SilHigh(1) && Close(1)>SilHigh(1));
  }
//+------------------------------------------------------------------+
//| Check conditions for long position close.                        |
//| INPUT:  price - refernce for price.                              |
//| OUTPUT: true-if condition performed, false otherwise.            |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CSignalSilverChannels::CheckCloseLong(double& price)
  {
   price=0.0;
//---
   return(Close(2)>SilLow(1) && Close(1)<SilLow(1));
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
bool CSignalSilverChannels::CheckOpenShort(double& price,double& sl,double& tp,datetime& expiration)
  {
   price=0.0;
   sl   =m_symbol.Bid()+Inp_Signal_SilverChannels_StopLoss*m_adjusted_point;
   tp   =m_symbol.Bid()-Inp_Signal_SilverChannels_TakeProfit*m_adjusted_point;
//---
   return(Close(2)>SilLow(1) && Close(1)<SilLow(1));
  }
//+------------------------------------------------------------------+
//| Check conditions for short position close.                       |
//| INPUT:  price - refernce for price.                              |
//| OUTPUT: true-if condition performed, false otherwise.            |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CSignalSilverChannels::CheckCloseShort(double& price)
  {
   price=0.0;
//---
   return(Close(2)<SilHigh(1) && Close(1)>SilHigh(1));
  }
//+------------------------------------------------------------------+
