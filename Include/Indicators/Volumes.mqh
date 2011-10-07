//+------------------------------------------------------------------+
//|                                                      Volumes.mqh |
//|                        Copyright 2011, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//|                                              Revision 2011.06.09 |
//+------------------------------------------------------------------+
#include "Indicator.mqh"
//+------------------------------------------------------------------+
//| Class CiAD.                                                      |
//| Purpose: Class of the "Accumulation/Distribution" indicator.     |
//|          Derives from class CIndicator.                          |
//+------------------------------------------------------------------+
class CiAD : public CIndicator
  {
protected:
   ENUM_APPLIED_VOLUME m_applied;        // applied volume

public:
                     CiAD();
   //--- methods of access to protected data
   ENUM_APPLIED_VOLUME Applied()     const { return(m_applied); }
   //--- method of creation
   bool              Create(string symbol,ENUM_TIMEFRAMES period,ENUM_APPLIED_VOLUME applied);
   //--- methods of access to indicator data
   double            Main(int index) const;
   //--- method of identifying
   virtual int       Type()          const { return(IND_AD);    }

protected:
   //--- methods of tuning
   virtual bool      Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[]);
   bool              Initialize(string symbol,ENUM_TIMEFRAMES period,ENUM_APPLIED_VOLUME applied);
  };
//+------------------------------------------------------------------+
//| Constructor CiAD.                                                |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CiAD::CiAD()
  {
//--- initialize protected data
   m_applied=WRONG_VALUE;
  }
//+------------------------------------------------------------------+
//| Initialize the indicator with universal parameters.              |
//| INPUT:  symbol    - indicator symbol,                            |
//|         period    - indicator period,                            |
//|         num_param - number of parameters,                        |
//|         params    - array of parameters.                         |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiAD::Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[])
  {
   return(Initialize(symbol,period,(ENUM_APPLIED_VOLUME)params[0].integer_value));
  }
//+------------------------------------------------------------------+
//| Initialize the indicator with special parameters.                |
//| INPUT:  symbol  - indicator symbol,                              |
//|         period  - indicator period,                              |
//|         applied - what to apply the indicator to.                |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiAD::Initialize(string symbol,ENUM_TIMEFRAMES period,ENUM_APPLIED_VOLUME applied)
  {
   if(CreateBuffers(symbol,period,1))
     {
      //--- string of status of drawing
      m_name  ="AD";
      m_status="("+symbol+","+PeriodDescription()+","+VolumeDescription(applied)+") H="+IntegerToString(m_handle);
      //--- save settings
      m_applied=applied;
      //--- create buffers
      ((CIndicatorBuffer*)At(0)).Name("MAIN_LINE");
      //--- ok
      return(true);
     }
//--- error
   return(false);
  }
//+------------------------------------------------------------------+
//| Create the "Accumulation/Distribution" indicator.                |
//| INPUT:  symbol  - indicator symbol,                              |
//|         period  - indicator period,                              |
//|         applied - what to apply the indicator to.                |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiAD::Create(string symbol,ENUM_TIMEFRAMES period,ENUM_APPLIED_VOLUME applied)
  {
//--- check history
   if(!SetSymbolPeriod(symbol,period)) return(false);
//--- create
   m_handle=iAD(symbol,period,applied);
//--- check result
   if(m_handle==INVALID_HANDLE)        return(false);
//--- indicator successfully created
   if(!Initialize(symbol,period,applied))
     {
      //--- initialization failed
      IndicatorRelease(m_handle);
      m_handle=INVALID_HANDLE;
      return(false);
     }
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| Access to buffer of "Accumulation/Distribution".                 |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiAD::Main(int index) const
  {
   CIndicatorBuffer *buffer=At(0);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Class CiMFI.                                                     |
//| Purpose: Class of the "Money Flow Index" indicator.              |
//|          Derives from class CIndicator.                          |
//+------------------------------------------------------------------+
class CiMFI : public CIndicator
  {
protected:
   int               m_ma_period;
   ENUM_APPLIED_VOLUME m_applied;

public:
                     CiMFI();
   //--- methods of access to protected data
   int               MaPeriod()      const { return(m_ma_period); }
   ENUM_APPLIED_VOLUME Applied()     const { return(m_applied);   }
   //--- method of creation
   bool              Create(string symbol,ENUM_TIMEFRAMES period,int ma_period,ENUM_APPLIED_VOLUME applied);
   //--- methods of access to indicator data
   double            Main(int index) const;
   //--- method of identifying
   virtual int       Type()          const { return(IND_MFI);     }

protected:
   //--- methods of tuning
   virtual bool      Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[]);
   bool              Initialize(string symbol,ENUM_TIMEFRAMES period,int ma_period,ENUM_APPLIED_VOLUME applied);
  };
//+------------------------------------------------------------------+
//| Constructor CiMFI.                                               |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CiMFI::CiMFI()
  {
//--- initialize protected data
   m_ma_period=-1;
   m_applied  =WRONG_VALUE;
  }
//+------------------------------------------------------------------+
//| Initialize the indicator with universal parameters.              |
//| INPUT:  symbol    - indicator symbol,                            |
//|         period    - indicator period,                            |
//|         num_param - number of parameters,                        |
//|         params    - array of parameters.                         |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiMFI::Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[])
  {
   return(Initialize(symbol,period,(int)params[0].integer_value,(ENUM_APPLIED_VOLUME)params[1].integer_value));
  }
//+------------------------------------------------------------------+
//| Initialize the indicator with special parameters.                |
//| INPUT:  symbol    - indicator symbol,                            |
//|         period    - indicator period,                            |
//|         ma_period - period of MA,                                |
//|         applied   - what to apply the indicator to.              |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiMFI::Initialize(string symbol,ENUM_TIMEFRAMES period,int ma_period,ENUM_APPLIED_VOLUME applied)
  {
   if(CreateBuffers(symbol,period,1))
     {
      //--- string of status of drawing
      m_name  ="MFI";
      m_status="("+symbol+","+PeriodDescription()+","+
                IntegerToString(ma_period)+","+VolumeDescription(applied)+","+") H="+IntegerToString(m_handle);
      //--- save settings
      m_ma_period=ma_period;
      m_applied  =applied;
      //--- create buffers
      ((CIndicatorBuffer*)At(0)).Name("MAIN_LINE");
      //--- ok
      return(true);
     }
//--- error
   return(false);
  }
//+------------------------------------------------------------------+
//| Create the "Money Flow Index" indicator.                         |
//| INPUT:  symbol    - indicator symbol,                            |
//|         period    - indicator period,                            |
//|         ma_period - period of MA,                                |
//|         applied   - what to apply the indicator to.              |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiMFI::Create(string symbol,ENUM_TIMEFRAMES period,int ma_period,ENUM_APPLIED_VOLUME applied)
  {
//--- check history
   if(!SetSymbolPeriod(symbol,period)) return(false);
//--- create
   m_handle=iMFI(symbol,period,ma_period,applied);
//--- check result
   if(m_handle==INVALID_HANDLE)        return(false);
//--- indicator successfully created
   if(!Initialize(symbol,period,ma_period,applied))
     {
      //--- initialization failed
      IndicatorRelease(m_handle);
      m_handle=INVALID_HANDLE;
      return(false);
     }
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| Access to buffer of "Money Flow Index".                          |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiMFI::Main(int index) const
  {
   CIndicatorBuffer *buffer=At(0);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Class CiOBV.                                                     |
//| Purpose: Class of the "On Balance Volume" indicator.             |
//|          Derives from class CIndicator.                          |
//+------------------------------------------------------------------+
class CiOBV : public CIndicator
  {
protected:
   ENUM_APPLIED_VOLUME m_applied;

public:
                     CiOBV();
   //--- methods of access to protected data
   ENUM_APPLIED_VOLUME Applied()     const { return(m_applied); }
   //--- method create
   bool              Create(string symbol,ENUM_TIMEFRAMES period,ENUM_APPLIED_VOLUME applied);
   //--- methods of access to indicator data
   double            Main(int index) const;
   //--- method of identifying
   virtual int       Type()          const  { return(IND_OBV);   }

protected:
   //--- methods of tuning
   virtual bool      Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[]);
   bool              Initialize(string symbol,ENUM_TIMEFRAMES period,ENUM_APPLIED_VOLUME applied);
  };
//+------------------------------------------------------------------+
//| Constructor CiOBV.                                               |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CiOBV::CiOBV()
  {
//--- initialize protected data
   m_applied=WRONG_VALUE;
  }
//+------------------------------------------------------------------+
//| Initialize the indicator with universal parameters.              |
//| INPUT:  symbol    - indicator symbol,                            |
//|         period    - indicator period,                            |
//|         num_param - number of parameters,                        |
//|         params    - array of parameters.                         |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiOBV::Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[])
  {
   return(Initialize(symbol,period,(ENUM_APPLIED_VOLUME)params[0].integer_value));
  }
//+------------------------------------------------------------------+
//| Initialize the indicator with special parameters.                |
//| INPUT:  symbol  - indicator symbol,                              |
//|         period  - indicator period,                              |
//|         applied - what to apply the indicator to.                |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiOBV::Initialize(string symbol,ENUM_TIMEFRAMES period,ENUM_APPLIED_VOLUME applied)
  {
   if(CreateBuffers(symbol,period,1))
     {
      //--- string of status of drawing
      m_name  ="OBV";
      m_status="("+symbol+","+PeriodDescription()+","+VolumeDescription(applied)+","+") H="+IntegerToString(m_handle);
      //--- save settings
      m_applied=applied;
      //--- create buffers
      ((CIndicatorBuffer*)At(0)).Name("MAIN_LINE");
      //--- ok
      return(true);
     }
//--- error
   return(false);
  }
//+------------------------------------------------------------------+
//| Create the "On Balance Volume" indicator.                        |
//| INPUT:  symbol  - indicator symbol,                              |
//|         period  - indicator period,                              |
//|         applied - what to apply the indicator to.                |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiOBV::Create(string symbol,ENUM_TIMEFRAMES period,ENUM_APPLIED_VOLUME applied)
  {
//--- check history
   if(!SetSymbolPeriod(symbol,period)) return(false);
//--- create
   m_handle=iOBV(symbol,period,applied);
//--- check result
   if(m_handle==INVALID_HANDLE)        return(false);
//--- indicator successfully created
   if(!Initialize(symbol,period,applied))
     {
      //--- initialization failed
      IndicatorRelease(m_handle);
      m_handle=INVALID_HANDLE;
      return(false);
     }
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| Access to buffer of "On Balance Volume".                         |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiOBV::Main(int index) const
  {
   CIndicatorBuffer *buffer=At(0);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Class CiVolumes.                                                 |
//| Purpose: Class of the "Volumes" indicator.                       |
//|          Derives from class CIndicator.                          |
//+------------------------------------------------------------------+
class CiVolumes : public CIndicator
  {
protected:
   ENUM_APPLIED_VOLUME m_applied;

public:
                     CiVolumes();
   //--- methods of access to protected data
   ENUM_APPLIED_VOLUME Applied()     const { return(m_applied);   }
   //--- method create
   bool              Create(string symbol,ENUM_TIMEFRAMES period,ENUM_APPLIED_VOLUME applied);
   //--- methods of access to indicator data
   double            Main(int index) const;
   //--- method of identifying
   virtual int       Type()          const { return(IND_VOLUMES); }

protected:
   //--- methods of tuning
   virtual bool      Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[]);
   bool              Initialize(string symbol,ENUM_TIMEFRAMES period,ENUM_APPLIED_VOLUME applied);
  };
//+------------------------------------------------------------------+
//| Constructor CiVolumes.                                           |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CiVolumes::CiVolumes()
  {
//--- initialize protected data
   m_applied=WRONG_VALUE;
  }
//+------------------------------------------------------------------+
//| Initialize the indicator with universal parameters.              |
//| INPUT:  symbol    - indicator symbol,                            |
//|         period    - indicator period,                            |
//|         num_param - number of parameters,                        |
//|         params    - array of parameters.                         |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiVolumes::Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[])
  {
   return(Initialize(symbol,period,(ENUM_APPLIED_VOLUME)params[0].integer_value));
  }
//+------------------------------------------------------------------+
//| Initialize the indicator with special parameters.                |
//| INPUT:  symbol  - indicator symbol,                              |
//|         period  - indicator period,                              |
//|         applied - what to apply the indicator to.                |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiVolumes::Initialize(string symbol,ENUM_TIMEFRAMES period,ENUM_APPLIED_VOLUME applied)
  {
   if(CreateBuffers(symbol,period,1))
     {
      //--- string of status of drawing
      m_name  ="Volumes";
      m_status="("+symbol+","+PeriodDescription()+","+VolumeDescription(applied)+","+") H="+IntegerToString(m_handle);
      //--- save settings
      m_applied=applied;
      //--- create buffers
      ((CIndicatorBuffer*)At(0)).Name("MAIN_LINE");
      //--- ok
      return(true);
     }
//--- error
   return(false);
  }
//+------------------------------------------------------------------+
//| Create the "Volumes" indicator.                                  |
//| INPUT:  symbol  - indicator symbol,                              |
//|         period  - indicator period,                              |
//|         applied - what to apply the indicator to.                |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiVolumes::Create(string symbol,ENUM_TIMEFRAMES period,ENUM_APPLIED_VOLUME applied)
  {
//--- check history
   if(!SetSymbolPeriod(symbol,period)) return(false);
//--- create
   m_handle=iVolumes(symbol,period,applied);
//--- check result
   if(m_handle==INVALID_HANDLE)        return(false);
//--- indicator successfully created
   if(!Initialize(symbol,period,applied))
     {
      //--- initialization failed
      IndicatorRelease(m_handle);
      m_handle=INVALID_HANDLE;
      return(false);
     }
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| Access to buffer of "Volumes".                                   |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiVolumes::Main(int index) const
  {
   CIndicatorBuffer *buffer=At(0);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
