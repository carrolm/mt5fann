//+------------------------------------------------------------------+
//|                                                   Oscilators.mqh |
//|                        Copyright 2011, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//|                                              Revision 2011.06.09 |
//+------------------------------------------------------------------+
#include "Indicator.mqh"
//+------------------------------------------------------------------+
//| Class CiATR.                                                     |
//| Purpose: Class of the "Average True Range" idnicator.            |
//|          Derives from class CIndicator.                          |
//+------------------------------------------------------------------+
class CiATR : public CIndicator
  {
protected:
   int               m_ma_period;

public:
                     CiATR();
   //--- methods of access to protected data
   int               MaPeriod()      const { return(m_ma_period); }
   //--- method of creation
   bool              Create(string symbol,ENUM_TIMEFRAMES period,int ma_period);
   //--- methods of access to indicator data
   double            Main(int index) const;
   //--- method of identifying
   virtual int       Type()          const { return(IND_ATR);     }

protected:
   //--- methods of tuning
   virtual bool      Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[]);
   bool              Initialize(string symbol,ENUM_TIMEFRAMES period,int ma_period);
  };
//+------------------------------------------------------------------+
//| Constructor CiATR.                                               |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CiATR::CiATR()
  {
//--- initialize protected data
   m_ma_period=-1;
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
bool CiATR::Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[])
  {
   return(Initialize(symbol,period,(int)params[0].integer_value));
  }
//+------------------------------------------------------------------+
//| Initialize the indicator with special parameters.                |
//| INPUT:  symbol    - indicator symbol,                            |
//|         period    - indicator period,                            |
//|         ma_period - period of MA.                                |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiATR::Initialize(string symbol,ENUM_TIMEFRAMES period,int ma_period)
  {
   if(CreateBuffers(symbol,period,1))
     {
      //--- string of status of drawing
      m_name  ="ATR";
      m_status="("+symbol+","+PeriodDescription()+","+IntegerToString(ma_period)+") H="+IntegerToString(m_handle);
      //--- save settings
      m_ma_period=ma_period;
      //--- create buffers
      ((CIndicatorBuffer*)At(0)).Name("MAIN_LINE");
      //--- ok
      return(true);
     }
//--- error
   return(false);
  }
//+------------------------------------------------------------------+
//| Create the "Average True Range" indicator.                       |
//| INPUT:  symbol    - indicator symbol,                            |
//|         period    - indicator period,                            |
//|         ma_period - period of MA.                                |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiATR::Create(string symbol,ENUM_TIMEFRAMES period,int ma_period)
  {
//--- check history
   if(!SetSymbolPeriod(symbol,period)) return(false);
//--- create
   m_handle=iATR(symbol,period,ma_period);
//--- check result
   if(m_handle==INVALID_HANDLE)        return(false);
//--- indicator successfully created
   if(!Initialize(symbol,period,ma_period))
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
//| Access to buffer of "Average True Range".                        |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiATR::Main(int index) const
  {
   CIndicatorBuffer *buffer=At(0);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Class CiBearsPower.                                              |
//| Purpose: Class indicator "Bears Power".                          |
//|          Derives from class CIndicator.                          |
//+------------------------------------------------------------------+
class CiBearsPower : public CIndicator
  {
protected:
   int               m_ma_period;

public:
                     CiBearsPower();
   //--- methods of access to protected data
   int               MaPeriod()      const { return(m_ma_period); }
   //--- method create
   bool              Create(string symbol,ENUM_TIMEFRAMES period,int ma_period);
   //--- methods of access to indicator data
   double            Main(int index) const;
   //--- method of identifying
   virtual int       Type()          const { return(IND_BEARS);   }

protected:
   //--- methods of tuning
   virtual bool      Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[]);
   bool              Initialize(string symbol,ENUM_TIMEFRAMES period,int ma_period);
  };
//+------------------------------------------------------------------+
//| Constructor CiBearsPower.                                        |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CiBearsPower::CiBearsPower()
  {
//--- initialize protected data
   m_ma_period=-1;
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
bool CiBearsPower::Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[])
  {
   return(Initialize(symbol,period,(int)params[0].integer_value));
  }
//+------------------------------------------------------------------+
//| Initialize the indicator with special parameters.                |
//| INPUT:  symbol    - indicator symbol,                            |
//|         period    - indicator period,                            |
//|         ma_period - period of MA.                                |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiBearsPower::Initialize(string symbol,ENUM_TIMEFRAMES period,int ma_period)
  {
   if(CreateBuffers(symbol,period,1))
     {
      //--- string of status of drawing
      m_name  ="BearsPower";
      m_status="("+symbol+","+PeriodDescription()+","+IntegerToString(ma_period)+") H="+IntegerToString(m_handle);
      //--- save settings
      m_ma_period=ma_period;
      //--- create buffers
      ((CIndicatorBuffer*)At(0)).Name("MAIN_LINE");
      //--- ok
      return(true);
     }
//--- error
   return(false);
  }
//+------------------------------------------------------------------+
//| Create the "Bears Power" indicator.                              |
//| INPUT:  symbol    - indicator symbol,                            |
//|         period    - indicator period,                            |
//|         ma_period - period of MA.                                |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiBearsPower::Create(string symbol,ENUM_TIMEFRAMES period,int ma_period)
  {
//--- check history
   if(!SetSymbolPeriod(symbol,period)) return(false);
//--- create
   m_handle=iBearsPower(symbol,period,ma_period);
//--- check result
   if(m_handle==INVALID_HANDLE)        return(false);
//--- indicator successfully created
   if(!Initialize(symbol,period,ma_period))
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
//| Access to buffer of "Bears Power".                               |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiBearsPower::Main(int index) const
  {
   CIndicatorBuffer *buffer=At(0);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Class CiBullsPower.                                              |
//| Purpose: Class of the "Bulls Power" indicator.                   |
//|          Derives from class CIndicator.                          |
//+------------------------------------------------------------------+
class CiBullsPower : public CIndicator
  {
protected:
   int               m_ma_period;

public:
                     CiBullsPower();
   //--- methods of access to protected data
   int               MaPeriod()      const { return(m_ma_period); }
   //--- method create
   bool              Create(string symbol,ENUM_TIMEFRAMES period,int ma_period);
   //--- methods of access to indicator data
   double            Main(int index) const;
   //--- method of identifying
   virtual int       Type()          const { return(IND_BULLS);   }

protected:
   //--- methods of tuning
   virtual bool      Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[]);
   bool              Initialize(string symbol,ENUM_TIMEFRAMES period,int ma_period);
  };
//+------------------------------------------------------------------+
//| Constructor CiBullsPower.                                        |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CiBullsPower::CiBullsPower()
  {
//--- initialize protected data
   m_ma_period=-1;
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
bool CiBullsPower::Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[])
  {
   return(Initialize(symbol,period,(int)params[0].integer_value));
  }
//+------------------------------------------------------------------+
//| Initialize the indicator with special parameters.                |
//| INPUT:  symbol    - indicator symbol,                            |
//|         period    - indicator period,                            |
//|         ma_period - period of MA.                                |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiBullsPower::Initialize(string symbol,ENUM_TIMEFRAMES period,int ma_period)
  {
   if(CreateBuffers(symbol,period,1))
     {
      //--- string of status of drawing
      m_name  ="BullsPower";
      m_status="("+symbol+","+PeriodDescription()+","+IntegerToString(ma_period)+") H="+IntegerToString(m_handle);
      //--- save settings
      m_ma_period=ma_period;
      //--- create buffers
      ((CIndicatorBuffer*)At(0)).Name("MAIN_LINE");
      //--- ok
      return(true);
     }
//--- error
   return(false);
  }
//+------------------------------------------------------------------+
//| Create indicator "Bulls Power".                                  |
//| INPUT:  symbol    - indicator symbol,                            |
//|         period    - indicator period,                            |
//|         ma_period - period of MA.                                |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiBullsPower::Create(string symbol,ENUM_TIMEFRAMES period,int ma_period)
  {
//--- check history
   if(!SetSymbolPeriod(symbol,period)) return(false);
//--- create
   m_handle=iBullsPower(symbol,period,ma_period);
//--- check result
   if(m_handle==INVALID_HANDLE)        return(false);
//--- indicator successfully created
   if(!Initialize(symbol,period,ma_period))
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
//| Access to buffer of "Bulls Power".                               |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiBullsPower::Main(int index) const
  {
   CIndicatorBuffer *buffer=At(0);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Class CiCCI.                                                     |
//| Purpose: Class of the "Commodity Channel Index" indicator.       |
//|          Derives from class CIndicator.                          |
//+------------------------------------------------------------------+
class CiCCI : public CIndicator
  {
protected:
   int               m_ma_period;
   int               m_applied;

public:
                     CiCCI();
   //--- methods of access to protected data
   int               MaPeriod()      const { return(m_ma_period); }
   int               Applied()       const { return(m_applied);   }
   //--- method create
   bool              Create(string symbol,ENUM_TIMEFRAMES period,int ma_period,int applied);
   //--- methods of access to indicator data
   double            Main(int index) const;
   //--- method of identifying
   virtual int       Type()          const { return(IND_CCI);     }

protected:
   //--- methods of tuning
   virtual bool      Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[]);
   bool              Initialize(string symbol,ENUM_TIMEFRAMES period,int ma_period,int applied);
  };
//+------------------------------------------------------------------+
//| Constructor CiCCI.                                               |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CiCCI::CiCCI()
  {
//--- initialize protected data
   m_ma_period=-1;
   m_applied  =-1;
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
bool CiCCI::Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[])
  {
   return(Initialize(symbol,period,(int)params[0].integer_value,(int)params[1].integer_value));
  }
//+------------------------------------------------------------------+
//| Create the "Commodity Channel Index" indicator.                  |
//| INPUT:  symbol    - indicator symbol,                            |
//|         period    - indicator period,                            |
//|         ma_period - period of MA,                                |
//|         applied   - what to apply the indicator to.              |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiCCI::Initialize(string symbol,ENUM_TIMEFRAMES period,int ma_period,int applied)
  {
   if(CreateBuffers(symbol,period,1))
     {
      //--- string of status of drawing
      m_name  ="CCI";
      m_status="("+symbol+","+PeriodDescription()+","+
                IntegerToString(ma_period)+","+PriceDescription(applied)+") H="+IntegerToString(m_handle);
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
//| Create the "Commodity Channel Index" indicator.                  |
//| INPUT:  symbol    - indicator symbol,                            |
//|         period    - indicator period,                            |
//|         ma_period - period of MA,                                |
//|         applied   - what to apply the indicator to.              |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiCCI::Create(string symbol,ENUM_TIMEFRAMES period,int ma_period,int applied)
  {
//--- check history
   if(!SetSymbolPeriod(symbol,period)) return(false);
//--- create
   m_handle=iCCI(symbol,period,ma_period,applied);
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
//| Access to buffer of "Commodity Channel Index".                   |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiCCI::Main(int index) const
  {
   CIndicatorBuffer *buffer=At(0);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Class CiChaikin.                                                 |
//| Purpose: Class of the "Chaikin Oscillator" indicator.            |
//|          Derives from class CIndicator.                          |
//+------------------------------------------------------------------+
class CiChaikin : public CIndicator
  {
protected:
   int               m_fast_ma_period;
   int               m_slow_ma_period;
   ENUM_MA_METHOD    m_ma_method;
   ENUM_APPLIED_VOLUME m_applied;

public:
                     CiChaikin();
   //--- methods of access to protected data
   int               FastMaPeriod()  const { return(m_fast_ma_period); }
   int               SlowMaPeriod()  const { return(m_slow_ma_period); }
   ENUM_MA_METHOD    MaMethod()      const { return(m_ma_method);      }
   ENUM_APPLIED_VOLUME Applied()     const { return(m_applied);        }
   //--- method of creation
   bool              Create(string symbol,ENUM_TIMEFRAMES period,int fast_ma_period,int slow_ma_period,ENUM_MA_METHOD ma_method,ENUM_APPLIED_VOLUME applied);
   //--- methods of access to indicator data
   double            Main(int index) const;
   //--- method of identifying
   virtual int       Type()          const { return(IND_CHAIKIN);      }

protected:
   //--- methods of tuning
   virtual bool      Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[]);
   bool              Initialize(string symbol,ENUM_TIMEFRAMES period,int fast_ma_period,int slow_ma_period,ENUM_MA_METHOD ma_method,ENUM_APPLIED_VOLUME applied);
  };
//+------------------------------------------------------------------+
//| Constructor CiChaikin.                                           |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CiChaikin::CiChaikin()
  {
//--- initialize protected data
   m_fast_ma_period=-1;
   m_slow_ma_period=-1;
   m_ma_method     =WRONG_VALUE;
   m_applied       =WRONG_VALUE;
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
bool CiChaikin::Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[])
  {
   return(Initialize(symbol,period,(int)params[0].integer_value,(int)params[1].integer_value,
                        (ENUM_MA_METHOD)params[2].integer_value,(ENUM_APPLIED_VOLUME)params[3].integer_value));
  }
//+------------------------------------------------------------------+
//| Initialize the indicator with special parameters.                |
//| INPUT:  symbol         - indicator symbol,                       |
//|         period         - indicator period,                       |
//|         fast_ma_period - period of fast MA,                      |
//|         slow_ma_period - period of slow MA,                      |
//|         ma_method      - averaging method for MA,                |
//|         applied        - what to apply the indicator to.         |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiChaikin::Initialize(string symbol,ENUM_TIMEFRAMES period,int fast_ma_period,int slow_ma_period,ENUM_MA_METHOD ma_method,ENUM_APPLIED_VOLUME applied)
  {
   if(CreateBuffers(symbol,period,1))
     {
      //--- string of status of drawing
      m_name  ="Chaikin";
      m_status="("+symbol+","+PeriodDescription()+","+
                IntegerToString(fast_ma_period)+","+IntegerToString(slow_ma_period)+","+
                MethodDescription(ma_method)+","+PriceDescription(applied)+") H="+IntegerToString(m_handle);
      //--- save settings
      m_fast_ma_period=fast_ma_period;
      m_slow_ma_period=slow_ma_period;
      m_ma_method     =ma_method;
      m_applied       =applied;
      //--- create buffers
      ((CIndicatorBuffer*)At(0)).Name("MAIN_LINE");
      //--- ok
      return(true);
     }
//--- error
   return(false);
  }
//+------------------------------------------------------------------+
//| Create indicator "Chaikin Oscillator".                           |
//| INPUT:  symbol         - indicator symbol,                       |
//|         period         - indicator period,                       |
//|         fast_ma_period - period of fast MA,                      |
//|         slow_ma_period - period of slow MA,                      |
//|         ma_method      - averaging method for MA,                |
//|         applied        - what to apply the indicator to.         |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiChaikin::Create(string symbol,ENUM_TIMEFRAMES period,int fast_ma_period,int slow_ma_period,ENUM_MA_METHOD ma_method,ENUM_APPLIED_VOLUME applied)
  {
//--- check history
   if(!SetSymbolPeriod(symbol,period)) return(false);
//--- create
   m_handle=iChaikin(symbol,period,fast_ma_period,slow_ma_period,ma_method,applied);
//--- check result
   if(m_handle==INVALID_HANDLE)        return(false);
//--- indicator successfully created
   if(!Initialize(symbol,period,fast_ma_period,slow_ma_period,ma_method,applied))
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
//| Access to buffer of "Chaikin Oscillator".                        |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiChaikin::Main(int index) const
  {
   CIndicatorBuffer *buffer=At(0);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Class CiDeMarker.                                                |
//| Purpose: Class of the "DeMarker" indicator.                      |
//|          Derives from class CIndicator.                          |
//+------------------------------------------------------------------+
class CiDeMarker : public CIndicator
  {
protected:
   int               m_ma_period;

public:
                     CiDeMarker();
   //--- methods of access to protected data
   int               MaPeriod()      const { return(m_ma_period);  }
   //--- method of creation
   bool              Create(string symbol,ENUM_TIMEFRAMES period,int ma_period);
   //--- methods of access to indicator data
   double            Main(int index) const;
   //--- method of identifying
   virtual int       Type()          const { return(IND_DEMARKER); }

protected:
   //--- methods of tuning
   virtual bool      Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[]);
   bool              Initialize(string symbol,ENUM_TIMEFRAMES period,int ma_period);
  };
//+------------------------------------------------------------------+
//| Constructor CiDeMarker.                                          |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CiDeMarker::CiDeMarker()
  {
//--- initialize protected data
   m_ma_period=-1;
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
bool CiDeMarker::Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[])
  {
   return(Initialize(symbol,period,(int)params[0].integer_value));
  }
//+------------------------------------------------------------------+
//| Initialize the indicator with special parameters.                |
//| INPUT:  symbol    - indicator symbol,                            |
//|         period    - indicator period,                            |
//|         ma_period - period of MA.                                |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiDeMarker::Initialize(string symbol,ENUM_TIMEFRAMES period,int ma_period)
  {
   if(CreateBuffers(symbol,period,1))
     {
      //--- string of status of drawing
      m_name  ="DeMarker";
      m_status="("+symbol+","+PeriodDescription()+","+IntegerToString(ma_period)+") H="+IntegerToString(m_handle);
      //--- save settings
      m_ma_period=ma_period;
      //--- create buffers
      ((CIndicatorBuffer*)At(0)).Name("MAIN_LINE");
      //--- ok
      return(true);
     }
//--- error
   return(false);
  }
//+------------------------------------------------------------------+
//| Create indicator "DeMarker".                                     |
//| INPUT:  symbol    - indicator symbol,                            |
//|         period    - indicator period,                            |
//|         ma_period - period of MA.                                |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiDeMarker::Create(string symbol,ENUM_TIMEFRAMES period,int ma_period)
  {
//--- check history
   if(!SetSymbolPeriod(symbol,period)) return(false);
//--- create
   m_handle=iDeMarker(symbol,period,ma_period);
//--- check result
   if(m_handle==INVALID_HANDLE)        return(false);
//--- indicator successfully created
   if(!Initialize(symbol,period,ma_period))
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
//| Access to buffer of "DeMarker".                                  |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiDeMarker::Main(int index) const
  {
   CIndicatorBuffer *buffer=At(0);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Class CiForce.                                                   |
//| Purpose: Class of the "Force Index" indicator.                   |
//|          Derives from class CIndicator.                          |
//+------------------------------------------------------------------+
class CiForce : public CIndicator
  {
protected:
   int               m_ma_period;
   ENUM_MA_METHOD    m_ma_method;
   ENUM_APPLIED_VOLUME m_applied;

public:
                     CiForce();
   //--- methods of access to protected data
   int               MaPeriod()      const { return(m_ma_period); }
   ENUM_MA_METHOD    MaMethod()      const { return(m_ma_method); }
   ENUM_APPLIED_VOLUME Applied()     const { return(m_applied);   }
   //--- method of creation
   bool              Create(string symbol,ENUM_TIMEFRAMES period,int ma_period,ENUM_MA_METHOD ma_method,ENUM_APPLIED_VOLUME applied);
   //--- methods of access to indicator data
   double            Main(int index) const;
   //--- method of identifying
   virtual int       Type()          const { return(IND_FORCE);   }

protected:
   //--- methods of tuning
   virtual bool      Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[]);
   bool              Initialize(string symbol,ENUM_TIMEFRAMES period,int ma_period,ENUM_MA_METHOD ma_method,ENUM_APPLIED_VOLUME applied);
  };
//+------------------------------------------------------------------+
//| Constructor CiForce.                                             |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CiForce::CiForce()
  {
//--- initialize protected data
   m_ma_period=-1;
   m_ma_method=WRONG_VALUE;
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
bool CiForce::Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[])
  {
   return(Initialize(symbol,period,(int)params[0].integer_value,(ENUM_MA_METHOD)params[1].integer_value,
                   (ENUM_APPLIED_VOLUME)params[2].integer_value));
  }
//+------------------------------------------------------------------+
//| Initialize the indicator with special parameters.                |
//| INPUT:  symbol    - indicator symbol,                            |
//|         period    - indicator period,                            |
//|         ma_period - period of MA,                                |
//|         ma_method - averaging method for MA,                     |
//|         applied   - what to apply the indicator to.              |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiForce::Initialize(string symbol,ENUM_TIMEFRAMES period,int ma_period,ENUM_MA_METHOD ma_method,ENUM_APPLIED_VOLUME applied)
  {
   if(CreateBuffers(symbol,period,1))
     {
      //--- string of status of drawing
      m_name  ="Force";
      m_status="("+symbol+","+PeriodDescription()+","+
                IntegerToString(ma_period)+","+MethodDescription(ma_method)+","+
                VolumeDescription(applied)+","+") H="+IntegerToString(m_handle);
      //--- save settings
      m_ma_period=ma_period;
      m_ma_method=ma_method;
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
//| Create indicator "Force Index".                                  |
//| INPUT:  symbol    - indicator symbol,                            |
//|         period    - indicator period,                            |
//|         ma_period - period of MA,                                |
//|         ma_method - averaging method for MA,                     |
//|         applied   - what to apply the indicator to.              |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiForce::Create(string symbol,ENUM_TIMEFRAMES period,int ma_period,ENUM_MA_METHOD ma_method,ENUM_APPLIED_VOLUME applied)
  {
//--- check history
   if(!SetSymbolPeriod(symbol,period)) return(false);
//--- create
   m_handle=iForce(symbol,period,ma_period,ma_method,applied);
//--- check result
   if(m_handle==INVALID_HANDLE)        return(false);
//--- indicator successfully created
   if(!Initialize(symbol,period,ma_period,ma_method,applied))
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
//| Access to buffer of "Force Index".                               |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiForce::Main(int index) const
  {
   CIndicatorBuffer *buffer=At(0);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Class CiMACD.                                                    |
//| Purpose: Class of the "Moving Averages                           |
//|          Convergence-Divergence" indicator.                      |
//|          Derives from class CIndicator.                          |
//+------------------------------------------------------------------+
class CiMACD : public CIndicator
  {
protected:
   int               m_fast_ema_period;
   int               m_slow_ema_period;
   int               m_signal_period;
   int               m_applied;

public:
                     CiMACD();
   //--- methods of access to protected data
   int               FastEmaPeriod()   const { return(m_fast_ema_period); }
   int               SlowEmaPeriod()   const { return(m_slow_ema_period); }
   int               SignalPeriod()    const { return(m_signal_period);   }
   int               Applied()         const { return(m_applied);         }
   //--- method of creation
   bool              Create(string symbol,ENUM_TIMEFRAMES period,int fast_ema_period,int slow_ema_period,int signal_period,int applied);
   //--- methods of access to indicator data
   double            Main(int index)   const;
   double            Signal(int index) const;
   //--- method of identifying
   virtual int       Type()            const { return(IND_MACD);          }

protected:
   //--- methods of tuning
   virtual bool      Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[]);
   bool              Initialize(string symbol,ENUM_TIMEFRAMES period,int fast_ema_period,int slow_ema_period,int signal_period,int applied);
  };
//+------------------------------------------------------------------+
//| Constructor CiMACD.                                              |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CiMACD::CiMACD()
  {
//--- initialize protected data
   m_fast_ema_period=-1;
   m_slow_ema_period=-1;
   m_signal_period  =-1;
   m_applied        =-1;
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
bool CiMACD::Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[])
  {
   return(Initialize(symbol,period,(int)params[0].integer_value,(int)params[1].integer_value,
                                   (int)params[2].integer_value,(int)params[3].integer_value));
  }
//+------------------------------------------------------------------+
//| Initialize the indicator with special parameters.                |
//| INPUT:  symbol          - indicator symbol,                      |
//|         period          - indicator period,                      |
//|         fast_ema_period - period of fast EMA,                    |
//|         slow_ema_period - period of slow EMA,                    |
//|         signal_period   - period of signal MA,                   |
//|         applied         - what to apply the indicator to.        |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiMACD::Initialize(string symbol,ENUM_TIMEFRAMES period,int fast_ema_period,int slow_ema_period,int signal_period,int applied)
  {
   if(CreateBuffers(symbol,period,2))
     {
      //--- string of status of drawing
      m_name  ="MACD";
      m_status="("+symbol+","+PeriodDescription()+","+
                IntegerToString(fast_ema_period)+","+IntegerToString(slow_ema_period)+","+
                IntegerToString(signal_period)+","+PriceDescription(applied)+","+") H="+IntegerToString(m_handle);
      //--- save settings
      m_fast_ema_period=fast_ema_period;
      m_slow_ema_period=slow_ema_period;
      m_signal_period  =signal_period;
      m_applied        =applied;
      //--- create buffers
      ((CIndicatorBuffer*)At(0)).Name("MAIN_LINE");
      ((CIndicatorBuffer*)At(1)).Name("SIGNAL_LINE");
      //--- ok
      return(true);
     }
//--- error
   return(false);
  }
//+------------------------------------------------------------------+
//| Create the "Moving Averages Convergence-Divergence" indicator.   |
//| INPUT:  symbol          - indicator symbol,                      |
//|         period          - indicator period,                      |
//|         fast_ema_period - period of fast EMA,                    |
//|         slow_ema_period - period of slow EMA,                    |
//|         signal_period   - period of signal MA,                   |
//|         applied         - what to apply the indicator to.        |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiMACD::Create(string symbol,ENUM_TIMEFRAMES period,int fast_ema_period,int slow_ema_period,int signal_period,int applied)
  {   
//--- check history
   if(!SetSymbolPeriod(symbol,period)) return(false);
//--- create
   m_handle=iMACD(symbol,period,fast_ema_period,slow_ema_period,signal_period,applied);
//--- check result
   if(m_handle==INVALID_HANDLE)        return(false);
//--- indicator successfully created
   if(!Initialize(symbol,period,fast_ema_period,slow_ema_period,signal_period,applied))
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
//| Access to Main buffer of "Moving Averages                        |
//|                           Convergence-Divergence".               |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiMACD::Main(int index) const
  {
   CIndicatorBuffer *buffer=At(0);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Access to Signal buffer of "Moving Averages                      |
//|                             Convergence-Divergence".             |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiMACD::Signal(int index) const
  {
   CIndicatorBuffer *buffer=At(1);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Class CiMomentum.                                                |
//| Purpose: Class of the "Momentum" indicator.                      |
//|          Derives from class CIndicator.                          |
//+------------------------------------------------------------------+
class CiMomentum : public CIndicator
  {
protected:
   int               m_ma_period;
   int               m_applied;

public:
                     CiMomentum();
   //--- methods of access to protected data
   int               MaPeriod()      const { return(m_ma_period);  }
   int               Applied()       const { return(m_applied);    }
   //--- method of creation
   bool              Create(string symbol,ENUM_TIMEFRAMES period,int ma_period,int applied);
   //--- methods of access to indicator data
   double            Main(int index) const;
   //--- method of identifying
   virtual int       Type()          const { return(IND_MOMENTUM); }

protected:
   //--- methods of tuning
   virtual bool      Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[]);
   bool              Initialize(string symbol,ENUM_TIMEFRAMES period,int ma_period,int applied);
  };
//+------------------------------------------------------------------+
//| Constructor CiMomentum.                                          |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CiMomentum::CiMomentum()
  {
//--- initialize protected data
   m_ma_period=-1;
   m_applied  =-1;
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
bool CiMomentum::Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[])
  {
   return(Initialize(symbol,period,(int)params[0].integer_value,(int)params[1].integer_value));
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
bool CiMomentum::Initialize(string symbol,ENUM_TIMEFRAMES period,int ma_period,int applied)
  {
   if(CreateBuffers(symbol,period,1))
     {
      //--- string of status of drawing
      m_name="Momentum";
      m_status="("+symbol+","+PeriodDescription()+","+
                IntegerToString(ma_period)+","+PriceDescription(applied)+","+") H="+IntegerToString(m_handle);
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
//| Create the "Momentum" indicator.                                 |
//| INPUT:  symbol    - indicator symbol,                            |
//|         period    - indicator period,                            |
//|         ma_period - period of MA,                                |
//|         applied   - what to apply the indicator to.              |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiMomentum::Create(string symbol,ENUM_TIMEFRAMES period,int ma_period,int applied)
  {
//--- check history
   if(!SetSymbolPeriod(symbol,period)) return(false);
//--- create
   m_handle=iMomentum(symbol,period,ma_period,applied);
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
//| Access to buffer of "Momentum".                                  |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiMomentum::Main(int index) const
  {
   CIndicatorBuffer *buffer=At(0);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Class CiOsMA.                                                    |
//| Purpose: Class of the "Moving Average of Oscillator              |
//|          (MACD histogram)" indicator.                            |
//|          Derives from class CIndicator.                          |
//+------------------------------------------------------------------+
class CiOsMA : public CIndicator
  {
protected:
   int               m_fast_ema_period;
   int               m_slow_ema_period;
   int               m_signal_period;
   int               m_applied;

public:
                     CiOsMA();
   //--- methods of access to protected data
   int               FastEmaPeriod() const { return(m_fast_ema_period); }
   int               SlowEmaPeriod() const { return(m_slow_ema_period); }
   int               SignalPeriod()  const { return(m_signal_period);   }
   int               Applied()       const { return(m_applied);         }
   //--- method of creation
   bool              Create(string symbol,ENUM_TIMEFRAMES period,int fast_ema_period,int slow_ema_period,int signal_period,int applied);
   //--- methods of access to indicator data
   double            Main(int index) const;
   //--- method of identifying
   virtual int       Type()          const { return(IND_OSMA);          }

protected:
   //--- methods of tuning
   virtual bool      Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[]);
   bool              Initialize(string symbol,ENUM_TIMEFRAMES period,int fast_ema_period,int slow_ema_period,int signal_period,int applied);
  };
//+------------------------------------------------------------------+
//| Constructor CiOsMA.                                              |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CiOsMA::CiOsMA()
  {
//--- initialize protected data
   m_fast_ema_period=-1;
   m_slow_ema_period=-1;
   m_signal_period  =-1;
   m_applied        =-1;
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
bool CiOsMA::Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[])
  {
   return(Initialize(symbol,period,(int)params[0].integer_value,(int)params[1].integer_value,
                                   (int)params[2].integer_value,(int)params[3].integer_value));
  }
//+------------------------------------------------------------------+
//| Initialize the indicator with special parameters.                |
//| INPUT:  symbol          - indicator symbol,                      |
//|         period          - indicator period,                      |
//|         fast_ema_period - period of fast EMA,                    |
//|         slow_ema_period - period of slow EMA,                    |
//|         signal_period   - period of signal MA,                   |
//|         applied         - what to apply the indicator to.        |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiOsMA::Initialize(string symbol,ENUM_TIMEFRAMES period,int fast_ema_period,int slow_ema_period,int signal_period,int applied)
  {
   if(CreateBuffers(symbol,period,1))
     {
      //--- string of status of drawing
      m_name  ="OsMA";
      m_status="("+symbol+","+PeriodDescription()+","+
                IntegerToString(fast_ema_period)+","+IntegerToString(slow_ema_period)+","+
                IntegerToString(signal_period)+","+PriceDescription(applied)+","+") H="+IntegerToString(m_handle);
      //--- save settings
      m_fast_ema_period=fast_ema_period;
      m_slow_ema_period=slow_ema_period;
      m_signal_period  =signal_period;
      m_applied        =applied;
      //--- create buffers
      ((CIndicatorBuffer*)At(0)).Name("MAIN_LINE");
      //--- ok
      return(true);
     }
//--- error
   return(false);
  }
//+------------------------------------------------------------------+
//| Create indicator "Moving Average of Oscillator                   |
//| (MACD histogram)".                                               |
//| INPUT:  symbol          - indicator symbol,                      |
//|         period          - indicator period,                      |
//|         fast_ema_period - period of fast EMA,                    |
//|         slow_ema_period - period of slow EMA,                    |
//|         signal_period   - period of signal MA,                   |
//|         applied         - what to apply the indicator to.        |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiOsMA::Create(string symbol,ENUM_TIMEFRAMES period,int fast_ema_period,int slow_ema_period,int signal_period,int applied)
  {
//--- check history
   if(!SetSymbolPeriod(symbol,period)) return(false);
//--- create
   m_handle=iOsMA(symbol,period,fast_ema_period,slow_ema_period,signal_period,applied);
//--- check result
   if(m_handle==INVALID_HANDLE)        return(false);
//--- indicator successfully created
   if(!Initialize(symbol,period,fast_ema_period,slow_ema_period,signal_period,applied))
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
//| Access to buffer of "Moving Average of Oscillator                |
//|                     (MACD histogram)".                           |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiOsMA::Main(int index) const
  {
   CIndicatorBuffer *buffer=At(0);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Class CiRSI.                                                     |
//| Purpose: Class of the "Relative Strength Index" indicator.       |
//|          Derives from class CIndicator.                          |
//+------------------------------------------------------------------+
class CiRSI : public CIndicator
  {
protected:
   int               m_ma_period;
   int               m_applied;

public:
                     CiRSI();
   //--- methods of access to protected data
   int               MaPeriod()      const { return(m_ma_period); }
   int               Applied()       const { return(m_applied);   }
   //--- method of creation
   bool              Create(string symbol,ENUM_TIMEFRAMES period,int ma_period,int applied);
   //--- methods of access to indicator data
   double            Main(int index) const;
   //--- method of identifying
   virtual int       Type()          const { return(IND_RSI);     }

protected:
   //--- methods of tuning
   virtual bool      Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[]);
   bool              Initialize(string symbol,ENUM_TIMEFRAMES period,int ma_period,int applied);
  };
//+------------------------------------------------------------------+
//| Constructor CiRSI.                                               |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CiRSI::CiRSI()
  {
//--- initialize protected data
   m_ma_period=-1;
   m_applied  =-1;
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
bool CiRSI::Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[])
  {
   return(Initialize(symbol,period,(int)params[0].integer_value,(int)params[1].integer_value));
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
bool CiRSI::Initialize(string symbol,ENUM_TIMEFRAMES period,int ma_period,int applied)
  {
   if(CreateBuffers(symbol,period,1))
     {
      //--- string of status of drawing
      m_name  ="RSI";
      m_status="("+symbol+","+PeriodDescription()+","+
                IntegerToString(ma_period)+","+PriceDescription(applied)+","+") H="+IntegerToString(m_handle);
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
//| Create indicator "Relative Strength Index".                      |
//| INPUT:  symbol    - indicator symbol,                            |
//|         period    - indicator period,                            |
//|         ma_period - period of MA,                                |
//|         applied   - what to apply the indicator to.              |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiRSI::Create(string symbol,ENUM_TIMEFRAMES period,int ma_period,int applied)
  {
//--- check history
   if(!SetSymbolPeriod(symbol,period)) return(false);
//--- create
   m_handle=iRSI(symbol,period,ma_period,applied);
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
//| Access to buffer of "Relative Strength Index".                   |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiRSI::Main(int index) const
  {
   CIndicatorBuffer *buffer=At(0);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Class CiRVI.                                                     |
//| Purpose: Class of the "Relative Vigor Index" indicator.          |
//|          Derives from class CIndicator.                          |
//+------------------------------------------------------------------+
class CiRVI : public CIndicator
  {
protected:
   int               m_ma_period;

public:
                     CiRVI();
   //--- methods of access to protected data
   int               MaPeriod()        const { return(m_ma_period); }
   //--- method of creation
   bool              Create(string symbol,ENUM_TIMEFRAMES period,int ma_period);
   //--- methods of access to indicator data
   double            Main(int index)   const;
   double            Signal(int index) const;
   //--- method of identifying
   virtual int       Type()            const { return(IND_RVI);     }

protected:
   //--- methods of tuning
   virtual bool      Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[]);
   bool              Initialize(string symbol,ENUM_TIMEFRAMES period,int ma_period);
  };
//+------------------------------------------------------------------+
//| Constructor CiRVI.                                               |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CiRVI::CiRVI()
  {
//--- initialize protected data
   m_ma_period=-1;
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
bool CiRVI::Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[])
  {
   return(Initialize(symbol,period,(int)params[0].integer_value));
  }
//+------------------------------------------------------------------+
//| Initialize the indicator with special parameters.                |
//| INPUT:  symbol    - indicator symbol,                            |
//|         period    - indicator period,                            |
//|         ma_period - period of MA.                                |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiRVI::Initialize(string symbol,ENUM_TIMEFRAMES period,int ma_period)
  {
   if(CreateBuffers(symbol,period,2))
     {
      //--- string of status of drawing
      m_name  ="RVI";
      m_status="("+symbol+","+PeriodDescription()+","+
                IntegerToString(ma_period)+") H="+IntegerToString(m_handle);
      //--- save settings
      m_ma_period=ma_period;
      //--- create buffers
      ((CIndicatorBuffer*)At(0)).Name("MAIN_LINE");
      ((CIndicatorBuffer*)At(1)).Name("SIGNAL_LINE");
      //--- ok
      return(true);
     }
//--- error
   return(false);
  }
//+------------------------------------------------------------------+
//| Create the "Relative Vigor Index" indicator.                     |
//| INPUT:  symbol    - indicator symbol,                            |
//|         period    - indicator period,                            |
//|         ma_period - period of MA.                                |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiRVI::Create(string symbol,ENUM_TIMEFRAMES period,int ma_period)
  {
//--- check history
   if(!SetSymbolPeriod(symbol,period)) return(false);
//--- create
   m_handle=iRVI(symbol,period,ma_period);
//--- check result
   if(m_handle==INVALID_HANDLE)        return(false);
//--- indicator successfully created
   if(!Initialize(symbol,period,ma_period))
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
//| Access to Main buffer of "Relative Vigor Index".                 |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiRVI::Main(int index) const
  {
   CIndicatorBuffer *buffer=At(0);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Access to Signal buffer of "Relative Vigor Index".               |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiRVI::Signal(int index) const
  {
   CIndicatorBuffer *buffer=At(1);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Class CiStochastic.                                              |
//| Purpose: Class of the "Stochastic Oscillator" indicator.         |
//|          Derives from class CIndicator.                          |
//+------------------------------------------------------------------+
class CiStochastic : public CIndicator
  {
protected:
   int               m_Kperiod;
   int               m_Dperiod;
   int               m_slowing;
   ENUM_MA_METHOD    m_ma_method;
   ENUM_STO_PRICE    m_price_field;

public:
                     CiStochastic();
   //--- methods of access to protected data
   int               Kperiod()         const { return(m_Kperiod);      }
   int               Dperiod()         const { return(m_Dperiod);      }
   int               Slowing()         const { return(m_slowing);      }
   ENUM_MA_METHOD    MaMethod()        const { return(m_ma_method);    }
   ENUM_STO_PRICE    PriceField()      const { return(m_price_field);  }
   //--- method create
   bool              Create(string symbol,ENUM_TIMEFRAMES period,int Kperiod,int Dperiod,int slowing,ENUM_MA_METHOD ma_method,ENUM_STO_PRICE price_field);
   //--- methods of access to indicator data
   double            Main(int index)   const;
   double            Signal(int index) const;
   //--- method of identifying
   virtual int       Type()            const { return(IND_STOCHASTIC); }

protected:
   //--- methods of tuning
   virtual bool      Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[]);
   bool              Initialize(string symbol,ENUM_TIMEFRAMES period,int Kperiod,int Dperiod,int slowing,ENUM_MA_METHOD ma_method,ENUM_STO_PRICE price_field);
  };
//+------------------------------------------------------------------+
//| Constructor CiStochastic.                                        |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CiStochastic::CiStochastic()
  {
//--- initialize protected data
   m_Kperiod    =-1;
   m_Dperiod    =-1;
   m_slowing    =-1;
   m_ma_method  =WRONG_VALUE;
   m_price_field=WRONG_VALUE;
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
bool CiStochastic::Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[])
  {
   return(Initialize(symbol,period,(int)params[0].integer_value,(int)params[1].integer_value,
                                   (int)params[2].integer_value,(ENUM_MA_METHOD)params[3].integer_value,
                        (ENUM_STO_PRICE)params[4].integer_value));
  }
//+------------------------------------------------------------------+
//| Initialize the indicator with special parameters.                |
//| INPUT:  symbol    - indicator symbol,                            |
//|         period    - indicator period,                            |
//|         Kperiod   - %K period,                                   |
//|         Dperiod   - %D period,                                   |
//|         slowing   - period of slowing,                           |
//|         ma_method - averaging method,                            |
//|         price_field - price to apply the indicator to.           |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiStochastic::Initialize(string symbol,ENUM_TIMEFRAMES period,int Kperiod,int Dperiod,int slowing,ENUM_MA_METHOD ma_method,ENUM_STO_PRICE price_field)
  {
   if(CreateBuffers(symbol,period,2))
     {
      //--- string of status of drawing
      m_name  ="Stochastic";
      m_status="("+symbol+","+PeriodDescription()+","+
                IntegerToString(Kperiod)+","+IntegerToString(Dperiod)+","+IntegerToString(slowing)+","+
                MethodDescription(ma_method)+","+IntegerToString(price_field)+") H="+IntegerToString(m_handle);
      //--- save settings
      m_Kperiod    =Kperiod;
      m_Dperiod    =Dperiod;
      m_slowing    =slowing;
      m_ma_method  =ma_method;
      m_price_field=price_field;
      //--- create buffers
      ((CIndicatorBuffer*)At(0)).Name("MAIN_LINE");
      ((CIndicatorBuffer*)At(1)).Name("SIGNAL_LINE");
      //--- ok
      return(true);
     }
//--- error
   return(false);
  }
//+------------------------------------------------------------------+
//| Create the "Stochastic Oscillator" indicator.                    |
//| INPUT:  symbol      - indicator symbol,                          |
//|         period      - indicator period,                          |
//|         Kperiod     - %K period,                                 |
//|         Dperiod     - %D period,                                 |
//|         slowing     - period of slowing,                         |
//|         ma_method   - averaging method,                          |
//|         price_field - price to apply the indicator to.           |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiStochastic::Create(string symbol,ENUM_TIMEFRAMES period,int Kperiod,int Dperiod,int slowing,ENUM_MA_METHOD ma_method,ENUM_STO_PRICE price_field)
  {
//--- check history
   if(!SetSymbolPeriod(symbol,period)) return(false);
//--- create
   m_handle=iStochastic(symbol,period,Kperiod,Dperiod,slowing,ma_method,price_field);
//--- check result
   if(m_handle==INVALID_HANDLE)        return(false);
//--- indicator successfully created
   if(!Initialize(symbol,period,Kperiod,Dperiod,slowing,ma_method,price_field))
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
//| Access to Main buffer of "Stochastic Oscillator".                |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiStochastic::Main(int index) const
  {
   CIndicatorBuffer *buffer=At(0);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Access to Signal buffer of "Stochastic Oscillator".              |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiStochastic::Signal(int index) const
  {
   CIndicatorBuffer *buffer=At(1);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Class CiWPR.                                                     |
//| Purpose: Class of the "Williams' Percent Range" indicator.       |
//|          Derives from class CIndicator.                          |
//+------------------------------------------------------------------+
class CiWPR : public CIndicator
  {
protected:
   int               m_calc_period;

public:
                     CiWPR();
   //--- methods of access to protected data
   int               CalcPeriod()    const { return(m_calc_period); }
   //--- method of creation
   bool              Create(string symbol,ENUM_TIMEFRAMES period,int calc_period);
   //--- methods of access to indicator data
   double            Main(int index) const;
   //--- method of identifying
   virtual int       Type()          const  { return(IND_WPR);       }

protected:
   //--- methods of tuning
   virtual bool      Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[]);
   bool              Initialize(string symbol,ENUM_TIMEFRAMES period,int calc_period);
  };
//+------------------------------------------------------------------+
//| Constructor CiWPR.                                               |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CiWPR::CiWPR()
  {
//--- initialize protected data
   m_calc_period=-1;
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
bool CiWPR::Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[])
  {
   return(Initialize(symbol,period,(int)params[0].integer_value));
  }
//+------------------------------------------------------------------+
//| Initialize indicator with the cpecial parameters.                |
//| INPUT:  symbol      - indicator symbol,                          |
//|         period      - indicator period,                          |
//|         calc_period - period.                                    |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiWPR::Initialize(string symbol,ENUM_TIMEFRAMES period,int calc_period)
  {
   if(CreateBuffers(symbol,period,1))
     {
      //--- string of status of drawing
      m_name  ="WPR";
      m_status="("+symbol+","+PeriodDescription()+","+
                IntegerToString(calc_period)+") H="+IntegerToString(m_handle);
      //--- save settings
      m_calc_period=calc_period;
      //--- create buffers
      ((CIndicatorBuffer*)At(0)).Name("MAIN_LINE");
      //--- ok
      return(true);
     }
//--- error
   return(false);
  }
//+------------------------------------------------------------------+
//| Create the "Williams' Percent Range" indicator.                  |
//| INPUT:  symbol      - indicator symbol,                          |
//|         period      - indicator period,                          |
//|         calc_period - period.                                    |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiWPR::Create(string symbol,ENUM_TIMEFRAMES period,int calc_period)
  {
//--- check history
   if(!SetSymbolPeriod(symbol,period)) return(false);
//--- create
   m_handle=iWPR(symbol,period,calc_period);
//--- check result
   if(m_handle==INVALID_HANDLE)        return(false);
//--- indicator successfully created
   if(!Initialize(symbol,period,calc_period))
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
//| Access to buffer of "Williams' Percent Range".                   |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiWPR::Main(int index) const
  {
   CIndicatorBuffer *buffer=At(0);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Class CiTriX.                                                    |
//| Purpose: Class of the "Triple Exponential Moving Averages        |
//|          Oscillator" indicator.                                  |
//|          Derives from class CIndicator.                          |
//+------------------------------------------------------------------+
class CiTriX : public CIndicator
  {
protected:
   int               m_ma_period;
   int               m_applied;

public:
                     CiTriX();
   //--- methods of access to protected data
   int               MaPeriod()      const { return(m_ma_period); }
   int               Applied()       const { return(m_applied);   }
   //--- method of creation
   bool              Create(string symbol,ENUM_TIMEFRAMES period,int ma_period,int applied);
   //--- methods of access to indicator data
   double            Main(int index) const;
   //--- method of identifying
   virtual int       Type()          const { return(IND_TRIX);    }

protected:
   //--- methods of tuning
   virtual bool      Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[]);
   bool              Initialize(string symbol,ENUM_TIMEFRAMES period,int ma_period,int applied);
  };
//+------------------------------------------------------------------+
//| Constructor CiTriX.                                              |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CiTriX::CiTriX()
  {
//--- initialize protected data
   m_ma_period=-1;
   m_applied  =-1;
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
bool CiTriX::Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[])
  {
   return(Initialize(symbol,period,(int)params[0].integer_value,(int)params[1].integer_value));
  }
//+------------------------------------------------------------------+
//| Create the "Triple Exponential Moving Averages                   |
//| Oscillator" indicator.                                           |
//| INPUT:  symbol    - indicator symbol,                            |
//|         period    - indicator period,                            |
//|         ma_period - period of MA,                                |
//|         applied   - what to apply the indicator to.              |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiTriX::Initialize(string symbol,ENUM_TIMEFRAMES period,int ma_period,int applied)
  {
   if(CreateBuffers(symbol,period,1))
     {
      //--- string of status of drawing
      m_name  ="TriX";
      m_status="("+symbol+","+PeriodDescription()+","+
                IntegerToString(ma_period)+","+PriceDescription(applied)+") H="+IntegerToString(m_handle);
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
//| Create the "Triple Exponential Moving Averages                   |
//| Oscillator" indicator.                                           |
//| INPUT:  symbol    - indicator symbol,                            |
//|         period    - indicator period,                            |
//|         ma_period - period of MA,                                |
//|         applied   - what to apply the indicator to.              |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiTriX::Create(string symbol,ENUM_TIMEFRAMES period,int ma_period,int applied)
  {
//--- check history
   if(!SetSymbolPeriod(symbol,period)) return(false);
//--- create
   m_handle=iTriX(symbol,period,ma_period,applied);
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
//| Access to buffer of "Triple Exponential Moving Averages          |
//|                      Oscillator".                                |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiTriX::Main(int index) const
  {
   CIndicatorBuffer *buffer=At(0);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
