//+------------------------------------------------------------------+
//|                                                 BillWilliams.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//|                                              Revision 2010.10.17 |
//+------------------------------------------------------------------+
#include "Indicator.mqh"
//+------------------------------------------------------------------+
//| Class CiAC.                                                      |
//| Purpose: Class of the "Accelerator Oscillator" indicator.        |
//|          Derives from class CIndicator.                          |
//+------------------------------------------------------------------+
class CiAC : public CIndicator
  {
public:
   //--- method of creating
   bool              Create(string symbol,ENUM_TIMEFRAMES period);
   //--- methods of access to data of indicator
   double            Main(int index) const;
   //--- method of identifying
   virtual int       Type()          const { return(IND_AC); }

protected:
   //--- methods of tuning
   virtual bool      Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[]);
   bool              Initialize(string symbol,ENUM_TIMEFRAMES period);
  };
//+------------------------------------------------------------------+
//| Initialize the indicator with universal parameters.              |
//| INPUT:  symbol    - indicator symbol,                            |
//|         period    - indicator period,                            |
//|         num_param - number of parameters,                        |
//|         params    - array of parameters.                         |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiAC::Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[])
  {
   return(Initialize(symbol,period));
  }
//+------------------------------------------------------------------+
//| Initialize the indicator with special parameters.                |
//| INPUT:  symbol - indicator symbol,                               |
//|         period - indicator period.                               |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiAC::Initialize(string symbol,ENUM_TIMEFRAMES period)
  {
   if(CreateBuffers(symbol,period,1))
     {
      //--- string of status of drawing
      m_name  ="AC";
      m_status="("+symbol+","+PeriodDescription()+") H="+IntegerToString(m_handle);
      //--- create buffers
      ((CIndicatorBuffer*)At(0)).Name("MAIN_LINE");
      //--- ok
      return(true);
     }
//--- error
   return(false);
  }
//+------------------------------------------------------------------+
//| Create the "Accelerator Oscillator" indicator.                   |
//| INPUT:  symbol - indicator symbol,                               |
//|         period - indicator period.                               |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiAC::Create(string symbol,ENUM_TIMEFRAMES period)
  {
   m_handle=iAC(symbol,period);
//---
   if(m_handle!=INVALID_HANDLE)
     {
      //--- idicator successfully created
      if(!Initialize(symbol,period))
        {
         //--- initialization failed
         IndicatorRelease(m_handle);
         m_handle=INVALID_HANDLE;
         return(false);
        }
      return(true);
     }
//---
   return(false);
  }
//+------------------------------------------------------------------+
//| Access to the buffer of "Accelerator Oscillator".                |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiAC::Main(int index) const
  {
   CIndicatorBuffer *buffer=At(0);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Class CiAlligator.                                               |
//| Purpose: Class of the "Alligator" indicator .                    |
//|          Derives from class CIndicator.                          |
//+------------------------------------------------------------------+
class CiAlligator : public CIndicator
  {
protected:
   int               m_jaw_period;
   int               m_jaw_shift;
   int               m_teeth_period;
   int               m_teeth_shift;
   int               m_lips_period;
   int               m_lips_shift;
   ENUM_MA_METHOD    m_ma_method;
   int               m_applied;

public:
                     CiAlligator();
   //--- methods of access to protected data
   int               JawPeriod()      const { return(m_jaw_period);   }
   int               JawShift()       const { return(m_jaw_shift);    }
   int               TeethPeriod()    const { return(m_teeth_period); }
   int               TeethShift()     const { return(m_teeth_shift);  }
   int               LipsPeriod()     const { return(m_lips_period);  }
   int               LipsShift()      const { return(m_lips_shift);   }
   ENUM_MA_METHOD    MaMethod()       const { return(m_ma_method);    }
   int               Applied()        const { return(m_applied);      }
   //--- method of creating
   bool              Create(string symbol,ENUM_TIMEFRAMES period,int jaw_period,int jaw_shift,int teeth_period,int teeth_shift,int lips_period,int lips_shift,ENUM_MA_METHOD ma_method,int applied);
   //--- methods of access to data of indicator
   double            Jaw(int index)   const;
   double            Teeth(int index) const;
   double            Lips(int index)  const;
   //--- method of identifying
   virtual int       Type()           const { return(IND_ALLIGATOR);  }

protected:
   //--- methods of tuning
   virtual bool      Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[]);
   bool              Initialize(string symbol,ENUM_TIMEFRAMES period,int jaw_period,int jaw_shift,int teeth_period,int teeth_shift,int lips_period,int lips_shift,ENUM_MA_METHOD ma_method,int applied);
  };
//+------------------------------------------------------------------+
//| Constructor CiAlligator.                                         |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CiAlligator::CiAlligator()
  {
//--- initialize protected data
   m_jaw_period  =-1;
   m_jaw_shift   =-1;
   m_teeth_period=-1;
   m_teeth_shift =-1;
   m_lips_period =-1;
   m_lips_shift  =-1;
   m_ma_method   =WRONG_VALUE;
   m_applied     =-1;
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
bool CiAlligator::Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[])
  {
   return(Initialize(symbol,period,(int)params[0].integer_value,(int)params[1].integer_value,
                                   (int)params[2].integer_value,(int)params[3].integer_value,
                                   (int)params[4].integer_value,(int)params[5].integer_value,
                        (ENUM_MA_METHOD)params[6].integer_value,(int)params[7].integer_value));
  }
//+------------------------------------------------------------------+
//| Initialize the indicator with special parameters.                |
//| INPUT:  symbol       - indicator symbol,                         |
//|         period       - indicator period,                         |
//|         jaw_period   - period for the calculation of jaws,       |
//|         jaw_shift    - shift of jaws,                            |
//|         teeth_period - period for the calculation of teeth,      |
//|         teeth_shift  - shift of teeth,                           |
//|         lips_period  - period for the calculation of lips,       |
//|         lips_shift   - shift of lips,                            |
//|         ma_method    - averaging method for MA,                  |
//|         applied      - what to apply the indicator to.           |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiAlligator::Initialize(string symbol,ENUM_TIMEFRAMES period,int jaw_period,int jaw_shift,int teeth_period,int teeth_shift,int lips_period,int lips_shift,ENUM_MA_METHOD ma_method,int applied)
  {
   if(CreateBuffers(symbol,period,3))
     {
      //--- string of status of drawing
      m_name  ="Alligator";
      m_status="("+symbol+","+PeriodDescription()+","+
                IntegerToString(jaw_period)+","+IntegerToString(jaw_shift)+","+
                IntegerToString(teeth_period)+","+IntegerToString(teeth_shift)+","+
                IntegerToString(lips_period)+","+IntegerToString(lips_shift)+","+
                MethodDescription(ma_method)+","+PriceDescription(applied)+") H="+IntegerToString(m_handle);
      //--- save settings
      m_jaw_period  =jaw_period;
      m_jaw_shift   =jaw_shift;
      m_teeth_period=teeth_period;
      m_teeth_shift =teeth_shift;
      m_lips_period =lips_period;
      m_lips_shift  =lips_shift;
      m_ma_method   =ma_method;
      m_applied     =applied;
      //--- create buffers
      ((CIndicatorBuffer*)At(0)).Name("JAW_LINE");
      ((CIndicatorBuffer*)At(0)).Offset(jaw_shift);
      ((CIndicatorBuffer*)At(1)).Name("TEETH_LINE");
      ((CIndicatorBuffer*)At(1)).Offset(teeth_shift);
      ((CIndicatorBuffer*)At(2)).Name("LIPS_LINE");
      ((CIndicatorBuffer*)At(2)).Offset(lips_shift);
      //--- ok
      return(true);
     }
//--- error
   return(false);
  }
//+------------------------------------------------------------------+
//| Create the "Alligator" indicator.                                |
//| INPUT:  symbol       - indicator symbol,                         |
//|         period       - indicator period,                         |
//|         jaw_period   - period for the calculation of jaws,       |
//|         jaw_shift    - shift of jaws,                            |
//|         teeth_period - period for the calculation of teeth,      |
//|         teeth_shift  - shift of teeth,                           |
//|         lips_period  - period for the calculation of lips,       |
//|         lips_shift   - shift of lips,                            |
//|         ma_method    - averaging method for MA,                  |
//|         applied      - what to apply the indicator to.           |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiAlligator::Create(string symbol,ENUM_TIMEFRAMES period,int jaw_period,int jaw_shift,int teeth_period,int teeth_shift,int lips_period,int lips_shift,ENUM_MA_METHOD ma_method,int applied)
  {
   m_handle=iAlligator(symbol,period,jaw_period,jaw_shift,teeth_period,teeth_shift,lips_period,lips_shift,ma_method,applied);
//---
   if(m_handle!=INVALID_HANDLE)
     {
      //--- idicator successfully created
      if(!Initialize(symbol,period,jaw_period,jaw_shift,teeth_period,teeth_shift,lips_period,lips_shift,ma_method,applied))
        {
         //--- initialization failed
         IndicatorRelease(m_handle);
         m_handle=INVALID_HANDLE;
         return(false);
        }
      return(true);
     }
//---
   return(false);
  }
//+------------------------------------------------------------------+
//| Access to Jaw buffer of "Alligator".                             |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiAlligator::Jaw(int index) const
  {
   CIndicatorBuffer *buffer=At(0);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Access to Teeth buffer of "Alligator".                           |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiAlligator::Teeth(int index) const
  {
   CIndicatorBuffer *buffer=At(1);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Access to Lips buffer of "Alligator".                            |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiAlligator::Lips(int index) const
  {
   CIndicatorBuffer *buffer=At(2);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Class CiAO.                                                      |
//| Purpose: Class of the "Awesome Oscillator" indicator.            |
//|          Derives from class CIndicator.                          |
//+------------------------------------------------------------------+
class CiAO : public CIndicator
  {
public:
   //--- method of creating
   bool              Create(string symbol,ENUM_TIMEFRAMES period);
   //--- methods of access to data of indicator
   double            Main(int index) const;
   //--- method of identifying
   virtual int       Type()          const { return(IND_AO); }

protected:
   //--- methods of tuning
   virtual bool      Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[]);
   bool              Initialize(string symbol,ENUM_TIMEFRAMES period);
  };
//+------------------------------------------------------------------+
//| Initialize the indicator with universal parameters.              |
//| INPUT:  symbol    - indicator symbol,                            |
//|         period    - indicator period,                            |
//|         num_param - number of parameters,                        |
//|         params    - array of parameters.                         |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiAO::Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[])
  {
   return(Initialize(symbol,period));
  }
//+------------------------------------------------------------------+
//| Create the "Awesome Oscillator" indicator.                       |
//| INPUT:  symbol - indicator symbol,                               |
//|         period - indicator period.                               |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiAO::Initialize(string symbol,ENUM_TIMEFRAMES period)
  {
   if(CreateBuffers(symbol,period,1))
     {
      //--- string of status of drawing
      m_status="AO("+symbol+","+PeriodDescription()+") H="+IntegerToString(m_handle);
      //--- create buffers
      ((CIndicatorBuffer*)At(0)).Name("MAIN_LINE");
      //--- ok
      return(true);
     }
//--- error
   return(false);
  }
//+------------------------------------------------------------------+
//| Create the "Awesome Oscillator" indicator.                       |
//| INPUT:  symbol - indicator symbol,                               |
//|         period - indicator period.                               |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiAO::Create(string symbol,ENUM_TIMEFRAMES period)
  {
   m_handle=iAO(symbol,period);
//---
   if(m_handle!=INVALID_HANDLE)
     {
      //--- indicator successfullly created
      if(!Initialize(symbol,period))
        {
         //--- initialization failed
         IndicatorRelease(m_handle);
         m_handle=INVALID_HANDLE;
         return(false);
        }
      return(true);
     }
//---
   return(false);
  }
//+------------------------------------------------------------------+
//| Access to buffer of "Awesome Oscillator".                        |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiAO::Main(int index) const
  {
   CIndicatorBuffer *buffer=At(0);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Class CiFractals.                                                |
//| Purpose: Class of the "Fractals" indicator.                      |
//|          Derives from class CIndicator.                          |
//+------------------------------------------------------------------+
class CiFractals : public CIndicator
  {
public:
   //--- method of creating
   bool              Create(string symbol,ENUM_TIMEFRAMES period);
   //--- methods of access to indicator data
   double            Upper(int index) const;
   double            Lower(int index) const;
   //--- method of identifying
   virtual int       Type()           const { return(IND_FRACTALS); }

protected:
   //--- methods of tuning
   virtual bool      Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[]);
   bool              Initialize(string symbol,ENUM_TIMEFRAMES period);
  };
//+------------------------------------------------------------------+
//| Initialize the indicator with universal parameters.              |
//| INPUT:  symbol    - indicator symbol,                            |
//|         period    - indicator period,                            |
//|         num_param - number of parameters,                        |
//|         params    - array of parameters.                         |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiFractals::Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[])
  {
   return(Initialize(symbol,period));
  }
//+------------------------------------------------------------------+
//| Initialize the indicator with special parameters.                |
//| INPUT:  symbol - indicator symbol,                               |
//|         period - indicator period.                               |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiFractals::Initialize(string symbol,ENUM_TIMEFRAMES period)
  {
   if(CreateBuffers(symbol,period,2))
     {
      //--- string of status of drawing
      m_name  ="Fractals";
      m_status="("+symbol+","+PeriodDescription()+") H="+IntegerToString(m_handle);
      //--- create buffers
      ((CIndicatorBuffer*)At(0)).Name("UPPER_LINE");
      ((CIndicatorBuffer*)At(1)).Name("LOWER_LINE");
      //--- ok
      return(true);
     }
//--- error
   return(false);
  }
//+------------------------------------------------------------------+
//| Create the "Fractals" indicator.                                 |
//| INPUT:  symbol - indicator symbol,                               |
//|         period - indicator period.                               |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiFractals::Create(string symbol,ENUM_TIMEFRAMES period)
  {
   m_handle=iFractals(symbol,period);
//---
   if(m_handle!=INVALID_HANDLE)
     {
      //--- idicator successfully created
      if(!Initialize(symbol,period))
        {
         //--- initialization failed
         IndicatorRelease(m_handle);
         m_handle=INVALID_HANDLE;
         return(false);
        }
      return(true);
     }
//---
   return(false);
  }
//+------------------------------------------------------------------+
//| Access to Upper buffer of "Fractals".                            |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiFractals::Upper(int index) const
  {
   CIndicatorBuffer *buffer=At(0);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Access to Lower buffer of "Fractals".                            |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiFractals::Lower(int index) const
  {
   CIndicatorBuffer *buffer=At(1);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Class CiGator.                                                   |
//| Purpose: Class of the "Gator oscillator" indicator.              |
//|          Derives from class CIndicator.                          |
//+------------------------------------------------------------------+
class CiGator : public CIndicator
  {
protected:
   int               m_jaw_period;
   int               m_jaw_shift;
   int               m_teeth_period;
   int               m_teeth_shift;
   int               m_lips_period;
   int               m_lips_shift;
   ENUM_MA_METHOD    m_ma_method;
   int               m_applied;

public:
                     CiGator();
   //--- methods of access to protected data
   int               JawPeriod()      const { return(m_jaw_period);   }
   int               JawShift()       const { return(m_jaw_shift);    }
   int               TeethPeriod()    const { return(m_teeth_period); }
   int               TeethShift()     const { return(m_teeth_shift);  }
   int               LipsPeriod()     const { return(m_lips_period);  }
   int               LipsShift()      const { return(m_lips_shift);   }
   ENUM_MA_METHOD    MaMethod()       const { return(m_ma_method);    }
   int               Applied()        const { return(m_applied);      }
   //--- method of creating
   bool              Create(string symbol,ENUM_TIMEFRAMES period,int jaw_period,int jaw_shift,int teeth_period,int teeth_shift,int lips_period,int lips_shift,ENUM_MA_METHOD ma_method,int applied);
   //--- methods of access to data of indicator
   double            Upper(int index) const;
   double            Lower(int index) const;
   //--- method of identifying
   virtual int       Type()           const { return(IND_GATOR);      }

protected:
   //--- methods of tuning
   virtual bool      Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[]);
   bool              Initialize(string symbol,ENUM_TIMEFRAMES period,int jaw_period,int jaw_shift,int teeth_period,int teeth_shift,int lips_period,int lips_shift,ENUM_MA_METHOD ma_method,int applied);
  };
//+------------------------------------------------------------------+
//| Constructor CiGator.                                             |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CiGator::CiGator()
  {
//--- initialize protected data
   m_jaw_period  =-1;
   m_jaw_shift   =-1;
   m_teeth_period=-1;
   m_teeth_shift =-1;
   m_lips_period =-1;
   m_lips_shift  =-1;
   m_ma_method   =WRONG_VALUE;
   m_applied     =-1;
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
bool CiGator::Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[])
  {
   return(Initialize(symbol,period,(int)params[0].integer_value,(int)params[1].integer_value,
                                   (int)params[2].integer_value,(int)params[3].integer_value,
                                   (int)params[4].integer_value,(int)params[5].integer_value,
                        (ENUM_MA_METHOD)params[6].integer_value,(int)params[7].integer_value));
  }
//+------------------------------------------------------------------+
//| Initialize the indicator with special parameters.                |
//| INPUT:  symbol       - indicator symbol,                         |
//|         period       - indicator period,                         |
//|         jaw_period   - period for the calculation of jaws,       |
//|         jaw_shift    - shift of jaws,                            |
//|         teeth_period - period for the calculation of teeth,      |
//|         teeth_shift  - shift of teeth,                           |
//|         lips_period  - period for the calculation of lips,       |
//|         lips_shift   - shift of lips,                            |
//|         ma_method    - averaging method for MA,                  |
//|         applied      - what to apply the indicator to.           |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiGator::Initialize(string symbol,ENUM_TIMEFRAMES period,int jaw_period,int jaw_shift,int teeth_period,int teeth_shift,int lips_period,int lips_shift,ENUM_MA_METHOD ma_method,int applied)
  {
   if(CreateBuffers(symbol,period,2))
     {
      //--- string of status drawing
      m_name  ="Gator";
      m_status="("+symbol+","+PeriodDescription()+","+
                IntegerToString(jaw_period)+","+IntegerToString(jaw_shift)+","+
                IntegerToString(teeth_period)+","+IntegerToString(teeth_shift)+","+
                IntegerToString(lips_period)+","+IntegerToString(lips_shift)+","+
                MethodDescription(ma_method)+","+PriceDescription(applied)+") H="+IntegerToString(m_handle);
      //--- save settings
      m_jaw_period  =jaw_period;
      m_jaw_shift   =jaw_shift;
      m_teeth_period=teeth_period;
      m_teeth_shift =teeth_shift;
      m_lips_period =lips_period;
      m_lips_shift  =lips_shift;
      m_ma_method   =ma_method;
      m_applied     =applied;
      //--- create buffers
      ((CIndicatorBuffer*)At(0)).Name("UPPER_LINE");
      ((CIndicatorBuffer*)At(0)).Offset(teeth_shift);
      ((CIndicatorBuffer*)At(1)).Name("LOWER_LINE");
      ((CIndicatorBuffer*)At(1)).Offset(lips_shift);
      //--- ok
      return(true);
     }
//--- error
   return(false);
  }
//+------------------------------------------------------------------+
//| Create indicator "Gator oscillator".                             |
//| INPUT:  symbol       - indicator symbol,                         |
//|         period       - indicator period,                         |
//|         jaw_period   - period for the calculation of jaws,       |
//|         jaw_shift    - shift of jaws,                            |
//|         teeth_period - period for the calculation of teeth,      |
//|         teeth_shift  - shift of teeth,                           |
//|         lips_period  - period for the calculation of lips,       |
//|         lips_shift   - shift of lips,                            |
//|         ma_method    - averaging method for MA,                  |
//|         applied      - what to apply the indicator to.           |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiGator::Create(string symbol,ENUM_TIMEFRAMES period,int jaw_period,int jaw_shift,int teeth_period,int teeth_shift,int lips_period,int lips_shift,ENUM_MA_METHOD ma_method,int applied)
  {
   m_handle=iGator(symbol,period,jaw_period,jaw_shift,teeth_period,teeth_shift,lips_period,lips_shift,ma_method,applied);
//---
   if(m_handle!=INVALID_HANDLE)
     {
      //--- idicator successfully created
      if(!Initialize(symbol,period,jaw_period,jaw_shift,teeth_period,teeth_shift,lips_period,lips_shift,ma_method,applied))
        {
         //--- initialization failed
         IndicatorRelease(m_handle);
         m_handle=INVALID_HANDLE;
         return(false);
        }
      return(true);
     }
//---
   return(false);
  }
//+------------------------------------------------------------------+
//| Access to Upper buffer of "Gator oscillator".                    |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiGator::Upper(int index) const
  {
   CIndicatorBuffer *buffer=At(0);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Access to Lower buffer of "Gator oscillator".                    |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiGator::Lower(int index) const
  {
   CIndicatorBuffer *buffer=At(1);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Class CiBWMFI.                                                   |
//| Purpose: Class of the "Market Facilitation Index" indicator      |
//|          by Bill Williams".                                      |
//|          Derives from class CIndicator.                          |
//+------------------------------------------------------------------+
class CiBWMFI : public CIndicator
  {
protected:
   ENUM_APPLIED_VOLUME m_applied;

public:
                     CiBWMFI();
   //--- methods of access to protected data
   ENUM_APPLIED_VOLUME Applied()     const { return(m_applied); }
   //--- method of creating
   bool              Create(string symbol,ENUM_TIMEFRAMES period,ENUM_APPLIED_VOLUME applied);
   //--- methods of access to data of indicator
   double            Main(int index) const;
   //--- method of identifying
   virtual int       Type()          const { return(IND_BWMFI); }

protected:
   //--- methods of tuning
   virtual bool      Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[]);
   bool              Initialize(string symbol,ENUM_TIMEFRAMES period,ENUM_APPLIED_VOLUME applied);
  };
//+------------------------------------------------------------------+
//| Constructor CiBWMFI.                                             |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CiBWMFI::CiBWMFI()
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
bool CiBWMFI::Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[])
  {
   return(Initialize(symbol,period,(ENUM_APPLIED_VOLUME)params[0].integer_value));
  }
//+------------------------------------------------------------------+
//| Initialize indicator with the special parameters.                |
//| INPUT:  symbol  - indicator symbol,                              |
//|         period  - indicator period,                              |
//|         applied - what to apply the indicator to.                |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiBWMFI::Initialize(string symbol,ENUM_TIMEFRAMES period,ENUM_APPLIED_VOLUME applied)
  {
   if(CreateBuffers(symbol,period,1))
     {
      //--- string of status of drawing
      m_name  ="BWMFI";
      m_status="BWMFI("+symbol+","+PeriodDescription()+","+VolumeDescription(applied)+") H="+IntegerToString(m_handle);
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
//| Create "Market Facilitation Index by Bill Williams" indicator.   |
//| INPUT:  symbol  - indicator symbol,                              |
//|         period  - indicator period,                              |
//|         applied - what to apply the indicator to.                |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiBWMFI::Create(string symbol,ENUM_TIMEFRAMES period,ENUM_APPLIED_VOLUME applied)
  {
   m_handle=iBWMFI(symbol,period,applied);
//---
   if(m_handle!=INVALID_HANDLE)
     {
      //--- idicator successfully created
      if(!Initialize(symbol,period,applied))
        {
         //--- initialization failed
         IndicatorRelease(m_handle);
         m_handle=INVALID_HANDLE;
         return(false);
        }
      return(true);
     }
//---
   return(false);
  }
//+------------------------------------------------------------------+
//| Access to buffer of "Market Facilitation Index by Bill Williams".|
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiBWMFI::Main(int index) const
  {
   CIndicatorBuffer *buffer=At(0);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
