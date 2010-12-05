//+------------------------------------------------------------------+
//|                                                        Trend.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//|                                              Revision 2010.10.17 |
//+------------------------------------------------------------------+
#include "Indicator.mqh"
//+------------------------------------------------------------------+
//| Class CiADX.                                                     |
//| Purpose: Class of the "Average Directional Index" indicator.     |
//|          Derives from class CIndicator.                          |
//+------------------------------------------------------------------+
class CiADX : public CIndicator
  {
protected:
   int               m_ma_period;

public:
                     CiADX();
   //--- methods of access to protected data
   int               MaPeriod()       const { return(m_ma_period); }
   //--- method of creation
   bool              Create(string symbol,ENUM_TIMEFRAMES period,int ma_period);
   //--- methods of access to indicator data
   double            Main(int index)  const;
   double            Plus(int index)  const;
   double            Minus(int index) const;
   //--- method of identifying
   virtual int       Type()           const { return(IND_ADX);     }

protected:
   //--- methods of tuning
   virtual bool      Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[]);
   bool              Initialize(string symbol,ENUM_TIMEFRAMES period,int ma_period);
  };
//+------------------------------------------------------------------+
//| Constructor CiADX.                                               |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CiADX::CiADX()
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
bool CiADX::Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[])
  {
   return(Initialize(symbol,period,(int)params[0].integer_value));
  }
//+------------------------------------------------------------------+
//| Initialize indicator with the special parameters.                |
//| INPUT:  symbol    - indicator symbol,                            |
//|         period    - indicator period,                            |
//|         ma_period - period of MA.                                |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiADX::Initialize(string symbol,ENUM_TIMEFRAMES period,int ma_period)
  {
   if(CreateBuffers(symbol,period,3))
     {
      //--- string of status of drawing
      m_name  ="ADX";
      m_status="("+symbol+","+PeriodDescription()+","+IntegerToString(ma_period)+") H="+IntegerToString(m_handle);
      //--- save settings
      m_ma_period=ma_period;
      //--- create buffers
      ((CIndicatorBuffer*)At(0)).Name("MAIN_LINE");
      ((CIndicatorBuffer*)At(1)).Name("PLUS_LINE");
      ((CIndicatorBuffer*)At(2)).Name("MINUS_LINE");
      //--- ok
      return(true);
     }
//--- error
   return(false);
  }
//+------------------------------------------------------------------+
//| Create the "Average Directional Index" indicator.                |
//| INPUT:  symbol    - indicator symbol,                            |
//|         period    - indicator period,                            |
//|         ma_period - period of MA.                                |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiADX::Create(string symbol,ENUM_TIMEFRAMES period,int ma_period)
  {
   m_handle=iADX(symbol,period,ma_period);
//---
   if(m_handle!=INVALID_HANDLE)
     {
      //--- indicator successfully created
      if(!Initialize(symbol,period,ma_period))
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
//| Access to Main buffer of "Average Directional Index".            |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiADX::Main(int index) const
  {
   CIndicatorBuffer *buffer=At(0);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Access to Plus buffer of "Average Directional Index".            |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiADX::Plus(int index) const
  {
   CIndicatorBuffer *buffer=At(1);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Access to Minus buffer of "Average Directional Index".           |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiADX::Minus(int index) const
  {
   CIndicatorBuffer *buffer=At(2);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Class CiADXWilder.                                               |
//| Purpose: Class of the "Average Directional Index                 |
//|          by Welles Wilder" indicator.                            |
//|          Derives from class CIndicator.                          |
//+------------------------------------------------------------------+
class CiADXWilder : public CIndicator
  {
protected:
   int               m_ma_period;

public:
                     CiADXWilder();
   //--- methods of access to protected data
   int               MaPeriod()       const { return(m_ma_period);   }
   //--- method of creation
   bool              Create(string symbol,ENUM_TIMEFRAMES period,int ma_period);
   //--- methods of access to indicator data
   double            Main(int index)  const;
   double            Plus(int index)  const;
   double            Minus(int index) const;
   //--- method of identifying
   virtual int       Type()           const { return(IND_ADXW);      }

protected:
   //--- methods of tuning
   virtual bool      Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[]);
   bool              Initialize(string symbol,ENUM_TIMEFRAMES period,int ma_period);
  };
//+------------------------------------------------------------------+
//| Constructor CiADXWilder.                                         |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CiADXWilder::CiADXWilder()
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
bool CiADXWilder::Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[])
  {
   return(Initialize(symbol,period,(int)params[0].integer_value));
  }
//+------------------------------------------------------------------+
//| Initialize indicator with the special parameters.                |
//| INPUT:  symbol    - indicator symbol,                            |
//|         period    - indicator period,                            |
//|         ma_period - period of MA.                                |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiADXWilder::Initialize(string symbol,ENUM_TIMEFRAMES period,int ma_period)
  {
   if(CreateBuffers(symbol,period,3))
     {
      //--- string of status of drawing
      m_name  ="ADXWilder";
      m_status="("+symbol+","+PeriodDescription()+","+IntegerToString(ma_period)+") H="+IntegerToString(m_handle);
      //--- save settings
      m_ma_period=ma_period;
      //--- create buffers
      ((CIndicatorBuffer*)At(0)).Name("MAIN_LINE");
      ((CIndicatorBuffer*)At(1)).Name("PLUS_LINE");
      ((CIndicatorBuffer*)At(2)).Name("MINUS_LINE");
      //--- ok
      return(true);
     }
//--- error
   return(false);
  }
//+------------------------------------------------------------------+
//| Create indicator "Average Directional Index by Welles Wilder".   |
//| INPUT:  symbol    - indicator symbol,                            |
//|         period    - indicator period,                            |
//|         ma_period - period of MA.                                |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiADXWilder::Create(string symbol,ENUM_TIMEFRAMES period,int ma_period)
  {
   m_handle=iADXWilder(symbol,period,ma_period);
//---
   if(m_handle!=INVALID_HANDLE)
     {
      //--- indicator successfully created
      if(!Initialize(symbol,period,ma_period))
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
//| Access to Main buffer of "Average Directional Index              |
//|                           by Welles Wilder".                     |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiADXWilder::Main(int index) const
  {
   CIndicatorBuffer *buffer=At(0);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Access to Plus buffer of "Average Directional Index              |
//|                           by Welles Wilder".                     |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiADXWilder::Plus(int index) const
  {
   CIndicatorBuffer *buffer=At(1);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Access to Minus buffer of "Average Directional Index             |
//|                            by Welles Wilder".                    |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiADXWilder::Minus(int index) const
  {
   CIndicatorBuffer *buffer=At(2);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Class CiBands.                                                   |
//| Purpose: Class of the "Bollinger Bands" indicator.               |
//|          Derives from class CIndicator.                          |
//+------------------------------------------------------------------+
class CiBands : public CIndicator
  {
protected:
   int               m_ma_period;
   int               m_ma_shift;
   double            m_deviation;
   int               m_applied;

public:
                     CiBands();
   //--- methods of access to protected data
   int               MaPeriod()       const { return(m_ma_period); }
   int               MaShift()        const { return(m_ma_shift);  }
   double            Deviation()      const { return(m_deviation); }
   int               Applied()        const { return(m_applied);   }
   //--- method of creation
   bool              Create(string symbol,ENUM_TIMEFRAMES period,int ma_period,int ma_shift,double deviation,int applied);
   //--- methods of access to indicator data
   double            Base(int index)  const;
   double            Upper(int index) const;
   double            Lower(int index) const;
   //--- method of identifying
   virtual int       Type()           const { return(IND_BANDS);   }

protected:
   //--- methods of tuning
   virtual bool      Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[]);
   bool              Initialize(string symbol,ENUM_TIMEFRAMES period,int ma_period,int ma_shift,double deviation,int applied);
  };
//+------------------------------------------------------------------+
//| Constructor CiBands.                                             |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CiBands::CiBands()
  {
//--- initialize protected data
   m_ma_period=-1;
   m_ma_shift =-1;
   m_deviation=EMPTY_VALUE;
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
bool CiBands::Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[])
  {
   return(Initialize(symbol,period,(int)params[0].integer_value,(int)params[1].integer_value,
                                        params[2].double_value,(int)params[3].integer_value));
  }
//+------------------------------------------------------------------+
//| Initialize indicator with the special parameters.                |
//| INPUT:  symbol    - indicator symbol,                            |
//|         period    - indicator period,                            |
//|         ma_period - period of MA,                                |
//|         ma_shift  - shift of MA,                                 |
//|         deviation - deviation,                                   |
//|         applied   - what to apply the indicator to.              |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiBands::Initialize(string symbol,ENUM_TIMEFRAMES period,int ma_period,int ma_shift,double deviation,int applied)
  {
   if(CreateBuffers(symbol,period,3))
     {
      //--- string of status of drawing
      m_name  ="Bands";
      m_status="("+symbol+","+PeriodDescription()+","+
                IntegerToString(ma_period)+","+IntegerToString(ma_shift)+","+
                DoubleToString(deviation)+","+PriceDescription(applied)+") H="+IntegerToString(m_handle);
      //--- save settings
      m_ma_period=ma_period;
      m_ma_shift =ma_shift;
      m_deviation=deviation;
      m_applied  =applied;
      //--- create buffers
      ((CIndicatorBuffer*)At(0)).Name("BASE_LINE");
      ((CIndicatorBuffer*)At(0)).Offset(ma_shift);
      ((CIndicatorBuffer*)At(1)).Name("UPPER_BAND");
      ((CIndicatorBuffer*)At(1)).Offset(ma_shift);
      ((CIndicatorBuffer*)At(2)).Name("LOWER_BAND");
      ((CIndicatorBuffer*)At(2)).Offset(ma_shift);
      //--- ok
      return(true);
     }
//--- error
   return(false);
  }
//+------------------------------------------------------------------+
//| Create indicator "Bollinger Bands".                              |
//| INPUT:  symbol    - indicator symbol,                            |
//|         period    - indicator period,                            |
//|         ma_period - period of MA,                                |
//|         ma_shift  - shift of MA,                                 |
//|         deviation - deviation,                                   |
//|         applied   - what to apply the indicator to.              |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiBands::Create(string symbol,ENUM_TIMEFRAMES period,int ma_period,int ma_shift,double deviation,int applied)
  {
   m_handle=iBands(symbol,period,ma_period,ma_shift,deviation,applied);
//---
   if(m_handle!=INVALID_HANDLE)
     {
      //--- indicator successfully created
      if(!Initialize(symbol,period,ma_period,ma_shift,deviation,applied))
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
//| Access to Base buffer of "Bollinger Bands".                      |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiBands::Base(int index) const
  {
   CIndicatorBuffer *buffer=At(0);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Access to Upper buffer of "Bollinger Bands".                     |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiBands::Upper(int index) const
  {
   CIndicatorBuffer *buffer=At(1);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Access to Lower buffer of "Bollinger Bands".                     |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiBands::Lower(int index) const
  {
   CIndicatorBuffer *buffer=At(2);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Class CiEnvelopes.                                               |
//| Purpose: Class of the "Envelopes" indicator.                     |
//|          Derives from class CIndicator.                          |
//+------------------------------------------------------------------+
class CiEnvelopes : public CIndicator
  {
protected:
   int               m_ma_period;
   int               m_ma_shift;
   ENUM_MA_METHOD    m_ma_method;
   int               m_applied;
   double            m_deviation;

public:
                     CiEnvelopes();
   //--- methods of access to protected data
   int               MaPeriod()       const { return(m_ma_period);   }
   int               MaShift()        const { return(m_ma_shift);    }
   ENUM_MA_METHOD    MaMethod()       const { return(m_ma_method);   }
   int               Applied()        const { return(m_applied);     }
   double            Deviation()      const { return(m_deviation);   }
   //--- method of creation
   bool              Create(string symbol,ENUM_TIMEFRAMES period,int ma_period,int ma_shift,ENUM_MA_METHOD ma_method,int applied,double deviation);
   //--- methods of access to indicator data
   double            Upper(int index) const;
   double            Lower(int index) const;
   //--- method of identifying
   virtual int       Type()           const { return(IND_ENVELOPES); }

protected:
   //--- methods of tuning
   virtual bool      Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[]);
   bool              Initialize(string symbol,ENUM_TIMEFRAMES period,int ma_period,int ma_shift,ENUM_MA_METHOD ma_method,int applied,double deviation);
  };
//+------------------------------------------------------------------+
//| Constructor CiEnvelopes.                                         |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CiEnvelopes::CiEnvelopes()
  {
//--- initialize protected data
   m_ma_period=-1;
   m_ma_shift =-1;
   m_ma_method=WRONG_VALUE;
   m_applied  =-1;
   m_deviation=EMPTY_VALUE;
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
bool CiEnvelopes::Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[])
  {
   return(Initialize(symbol,period,(int)params[0].integer_value,(int)params[1].integer_value,
                        (ENUM_MA_METHOD)params[2].integer_value,(int)params[3].integer_value,
                                   (int)params[4].double_value));
  }
//+------------------------------------------------------------------+
//| Initialize indicator with the special parameters.                |
//| INPUT:  symbol    - indicator symbol,                            |
//|         period    - indicator period,                            |
//|         ma_period - period of MA,                                |
//|         ma_shift  - shift of MA,                                 |
//|         ma_method - averaging method for MA,                     |
//|         applied   - what to apply the indicator to,              |
//|         deviation - deviation.                                   |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiEnvelopes::Initialize(string symbol,ENUM_TIMEFRAMES period,int ma_period,int ma_shift,ENUM_MA_METHOD ma_method,int applied,double deviation)
  {
   if(CreateBuffers(symbol,period,2))
     {
      //--- string of status of drawing
      m_name="Envelopes";
      m_status="("+symbol+","+PeriodDescription()+","+
                IntegerToString(ma_period)+","+IntegerToString(ma_shift)+","+
                MethodDescription(ma_method)+","+PriceDescription(applied)+","+
                DoubleToString(deviation)+") H="+IntegerToString(m_handle);
      //--- save settings
      m_ma_period=ma_period;
      m_ma_shift =ma_shift;
      m_ma_method=ma_method;
      m_applied  =applied;
      m_deviation=deviation;
      //--- create buffers
      ((CIndicatorBuffer*)At(0)).Name("UPPER_LINE");
      ((CIndicatorBuffer*)At(0)).Offset(ma_shift);
      ((CIndicatorBuffer*)At(1)).Name("LOWER_LINE");
      ((CIndicatorBuffer*)At(1)).Offset(ma_shift);
      //--- ok
      return(true);
     }
//--- error
   return(false);
  }
//+------------------------------------------------------------------+
//| Create indicator "Envelopes".                                    |
//| INPUT:  symbol    - indicator symbol,                            |
//|         period    - indicator period,                            |
//|         ma_period - period of MA,                                |
//|         ma_shift  - shift of MA,                                 |
//|         ma_method - averaging method for MA,                     |
//|         applied   - what to apply the indicator to,              |
//|         deviation - deviation.                                   |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiEnvelopes::Create(string symbol,ENUM_TIMEFRAMES period,int ma_period,int ma_shift,ENUM_MA_METHOD ma_method,int applied,double deviation)
  {
   m_handle=iEnvelopes(symbol,period,ma_period,ma_shift,ma_method,applied,deviation);
//---
   if(m_handle!=INVALID_HANDLE)
     {
      //--- indicator successfully created
      if(!Initialize(symbol,period,ma_period,ma_shift,ma_method,applied,deviation))
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
//| Access to Upper buffer of "Envelopes".                           |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiEnvelopes::Upper(int index) const
  {
   CIndicatorBuffer *buffer=At(0);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Access to Lower buffer of "Envelopes".                           |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiEnvelopes::Lower(int index) const
  {
   CIndicatorBuffer *buffer=At(1);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Class CiIchimoku.                                                |
//| Purpose: Class of the "Ichimoku Kinko Hyo" indicator.            |
//|          Derives from class CIndicator.                          |
//+------------------------------------------------------------------+
class CiIchimoku : public CIndicator
  {
protected:
   int               m_tenkan_sen;
   int               m_kijun_sen;
   int               m_senkou_span_b;

public:
                     CiIchimoku();
   //--- methods of access to protected data
   int               TenkanSenPeriod()      const { return(m_tenkan_sen);    }
   int               KijunSenPeriod()       const { return(m_kijun_sen);     }
   int               SenkouSpanBPeriod()    const { return(m_senkou_span_b); }
   //--- method of creation
   bool              Create(string symbol,ENUM_TIMEFRAMES period,int tenkan_sen,int kijun_sen,int senkou_span_b);
   //--- methods of access to indicator data
   double            TenkanSen(int index)   const;
   double            KijunSen(int index)    const;
   double            SenkouSpanA(int index) const;
   double            SenkouSpanB(int index) const;
   double            ChinkouSpan(int index) const;
   //--- method of identifying
   virtual int       Type()                 const { return(IND_ICHIMOKU);    }

protected:
   //--- methods of tuning
   virtual bool      Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[]);
   bool              Initialize(string symbol,ENUM_TIMEFRAMES period,int tenkan_sen,int kijun_sen,int senkou_span_b);
  };
//+------------------------------------------------------------------+
//| Constructor CiIchimoku.                                          |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CiIchimoku::CiIchimoku()
  {
//--- initialize protected data
   m_tenkan_sen   =-1;
   m_kijun_sen    =-1;
   m_senkou_span_b=-1;
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
bool CiIchimoku::Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[])
  {
   return(Initialize(symbol,period,(int)params[0].integer_value,(int)params[1].integer_value,(int)params[2].integer_value));
  }
//+------------------------------------------------------------------+
//| Initialize indicator with the special parameters.                |
//| INPUT:  symbol        - indicator symbol,                        |
//|         period        - indicator period,                        |
//|         tenkan_sen    - period of averaging Tenkan Sen,          |
//|         kijun_sen     - period of averaging Kijun Sen,           |
//|         senkou_span_b - period of averaging Senkou Span B.       |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiIchimoku::Initialize(string symbol,ENUM_TIMEFRAMES period,int tenkan_sen,int kijun_sen,int senkou_span_b)
  {
   if(CreateBuffers(symbol,period,5))
     {
      //--- string of status of drawing
      m_name  ="Ichimoku";
      m_status="("+symbol+","+PeriodDescription()+","+
                IntegerToString(tenkan_sen)+","+IntegerToString(kijun_sen)+","+
                IntegerToString(senkou_span_b)+") H="+IntegerToString(m_handle);
      //--- save settings
      m_tenkan_sen   =tenkan_sen;
      m_kijun_sen    =kijun_sen;
      m_senkou_span_b=senkou_span_b;
      //--- create buffers
      ((CIndicatorBuffer*)At(0)).Name("TENKANSEN_LINE");
      ((CIndicatorBuffer*)At(1)).Name("KIJUNSEN_LINE");
      ((CIndicatorBuffer*)At(2)).Name("SENKOUSPANA_LINE");
      ((CIndicatorBuffer*)At(2)).Offset(kijun_sen);
      ((CIndicatorBuffer*)At(3)).Name("SENKOUSPANB_LINE");
      ((CIndicatorBuffer*)At(3)).Offset(kijun_sen);
      ((CIndicatorBuffer*)At(4)).Name("CHINKOUSPAN_LINE");
      ((CIndicatorBuffer*)At(4)).Offset(-kijun_sen);
      //--- ok
      return(true);
     }
//--- error
   return(false);
  }
//+------------------------------------------------------------------+
//| Create indicator "Ichimoku Kinko Hyo".                           |
//| INPUT:  symbol        - indicator symbol,                        |
//|         period        - indicator period,                        |
//|         tenkan_sen    - period of averaging Tenkan Sen,          |
//|         kijun_sen     - period of averaging Kijun Sen,           |
//|         senkou_span_b - period of averaging Senkou Span B.       |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiIchimoku::Create(string symbol,ENUM_TIMEFRAMES period,int tenkan_sen,int kijun_sen,int senkou_span_b)
  {
   m_handle=iIchimoku(symbol,period,tenkan_sen,kijun_sen,senkou_span_b);
//---
   if(m_handle!=INVALID_HANDLE)
     {
      //--- indicator successfully created
      if(!Initialize(symbol,period,tenkan_sen,kijun_sen,senkou_span_b))
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
//| Access to TenkanSen buffer of "Ichimoku Kinko Hyo".              |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiIchimoku::TenkanSen(int index) const
  {
   CIndicatorBuffer *buffer=At(0);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Access to KijunSen buffer of "Ichimoku Kinko Hyo".               |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiIchimoku::KijunSen(int index) const
  {
   CIndicatorBuffer *buffer=At(1);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Access to SenkouSpanA buffer of "Ichimoku Kinko Hyo".            |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiIchimoku::SenkouSpanA(int index) const
  {
   CIndicatorBuffer *buffer=At(2);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Access to SenkouSpanB buffer of "Ichimoku Kinko Hyo".            |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiIchimoku::SenkouSpanB(int index) const
  {
   CIndicatorBuffer *buffer=At(3);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Access to ChinkouSpan buffer of "Ichimoku Kinko Hyo".            |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiIchimoku::ChinkouSpan(int index) const
  {
   CIndicatorBuffer *buffer=At(4);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Class CiMA.                                                      |
//| Purpose: Class of the "Moving Average" indicator.                |
//|          Derives from class CIndicator.                          |
//+------------------------------------------------------------------+
class CiMA : public CIndicator
  {
protected:
   int               m_ma_period;
   int               m_ma_shift;
   ENUM_MA_METHOD    m_ma_method;
   int               m_applied;

public:
                     CiMA();
   //--- methods of access to protected data
   int               MaPeriod()      const { return(m_ma_period); }
   int               MaShift()       const { return(m_ma_shift);  }
   ENUM_MA_METHOD    MaMethod()      const { return(m_ma_method); }
   int               Applied()       const { return(m_applied);   }
   //--- method of creation
   bool              Create(string symbol,ENUM_TIMEFRAMES period,int ma_period,int ma_shift,ENUM_MA_METHOD ma_method,int applied);
   //--- methods of access to indicator data
   double            Main(int index) const;
   //--- method of identifying
   virtual int       Type()          const { return(IND_MA);      }

protected:
   //--- methods of tuning
   virtual bool      Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[]);
   bool              Initialize(string symbol,ENUM_TIMEFRAMES period,int ma_period,int ma_shift,ENUM_MA_METHOD ma_method,int applied);
  };
//+------------------------------------------------------------------+
//| Constructor CiMA.                                                |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CiMA::CiMA()
  {
//--- initialize protected data
   m_ma_period=-1;
   m_ma_shift =-1;
   m_ma_method=WRONG_VALUE;
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
bool CiMA::Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[])
  {
   return(Initialize(symbol,period,(int)params[0].integer_value,(int)params[1].integer_value,
                        (ENUM_MA_METHOD)params[2].integer_value,(int)params[3].integer_value));
  }
//+------------------------------------------------------------------+
//| Initialize indicator with the special parameters.                |
//| INPUT:  symbol    - indicator symbol,                            |
//|         period    - indicator period,                            |
//|         ma_period - period of MA,                                |
//|         ma_shift  - shift of MA,                                 |
//|         ma_method - averaging method for MA,                     |
//|         applied   - what to apply the indicator to.              |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiMA::Initialize(string symbol,ENUM_TIMEFRAMES period,int ma_period,int ma_shift,ENUM_MA_METHOD ma_method,int applied)
  {
   if(CreateBuffers(symbol,period,1))
     {
      //--- string of status of drawing
      m_name  ="MA";
      m_status="("+symbol+","+PeriodDescription()+","+
                IntegerToString(ma_period)+","+IntegerToString(ma_shift)+","+
                MethodDescription(ma_method)+","+PriceDescription(applied)+") H="+IntegerToString(m_handle);
      //--- save settings
      m_ma_period=ma_period;
      m_ma_shift =ma_shift;
      m_ma_method=ma_method;
      m_applied  =applied;
      //--- create buffers
      ((CIndicatorBuffer*)At(0)).Name("MAIN_LINE");
      ((CIndicatorBuffer*)At(0)).Offset(ma_shift);
      //--- ok
      return(true);
     }
//--- error
   return(false);
  }
//+------------------------------------------------------------------+
//| Create indicator "Moving Average".                               |
//| INPUT:  symbol    - indicator symbol,                            |
//|         period    - indicator period,                            |
//|         ma_period - period of MA,                                |
//|         ma_shift  - shift of MA,                                 |
//|         ma_method - averaging method for MA,                     |
//|         applied   - what to apply the indicator to.              |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiMA::Create(string symbol,ENUM_TIMEFRAMES period,int ma_period,int ma_shift,ENUM_MA_METHOD ma_method,int applied)
  {
   m_handle=iMA(symbol,period,ma_period,ma_shift,ma_method,applied);
//---
   if(m_handle!=INVALID_HANDLE)
     {
      //--- indicator successfully created
      if(!Initialize(symbol,period,ma_period,ma_shift,ma_method,applied))
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
//| Access to buffer of "Moving Average".                            |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiMA::Main(int index) const
  {
   CIndicatorBuffer *buffer=At(0);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Class CiSAR.                                                     |
//| Purpose: Class of the "Parabolic Stop And Reverse System"        |
//|          indicator.                                              |
//|          Derives from class CIndicator.                          |
//+------------------------------------------------------------------+
class CiSAR : public CIndicator
  {
protected:
   double            m_step;
   double            m_maximum;

public:
                     CiSAR();
   //--- methods of access to protected data
   double            SarStep()       const { return(m_step);    }
   double            Maximum()       const { return(m_maximum); }
   //--- method of creation
   bool              Create(string symbol,ENUM_TIMEFRAMES period,double step,double maximum);
   //--- methods of access to indicator data
   double            Main(int index) const;
   //--- method of identifying
   virtual int       Type()          const { return(IND_SAR);   }

protected:
   //--- methods of tuning
   virtual bool      Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[]);
   bool              Initialize(string symbol,ENUM_TIMEFRAMES period,double step,double maximum);
  };
//+------------------------------------------------------------------+
//| Constructor CiSAR.                                               |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CiSAR::CiSAR()
  {
//--- initialize protected data
   m_step   =EMPTY_VALUE;
   m_maximum=EMPTY_VALUE;
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
bool CiSAR::Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[])
  {
   return(Initialize(symbol,period,params[0].double_value,params[1].double_value));
  }
//+------------------------------------------------------------------+
//| Initialize indicator with the special parameters.                |
//| INPUT:  symbol  - indicator symbol,                              |
//|         period  - indicator period,                              |
//|         step    - increment of the acceleration coefficient,     |
//|         maximum - maximum acceleration coefficient.              |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiSAR::Initialize(string symbol,ENUM_TIMEFRAMES period,double step,double maximum)
  {
   if(CreateBuffers(symbol,period,1))
     {
      //--- string of status of drawing
      m_name  ="SAR";
      m_status="("+symbol+","+PeriodDescription()+","+
                DoubleToString(step,4)+","+DoubleToString(maximum,4)+","+") H="+IntegerToString(m_handle);
      //--- save settings
      m_step   =step;
      m_maximum=maximum;
      //--- create buffers
      ((CIndicatorBuffer*)At(0)).Name("MAIN_LINE");
      //--- ok
      return(true);
     }
//--- error
   return(false);
  }
//+------------------------------------------------------------------+
//| Create indicator "Parabolic Stop And Reverse System".            |
//| INPUT:  symbol  - indicator symbol,                              |
//|         period  - indicator period,                              |
//|         step    - increment the level of stop,                   |
//|         maximum - maximum level of stop.                         |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiSAR::Create(string symbol,ENUM_TIMEFRAMES period,double step,double maximum)
  {
   m_handle=iSAR(symbol,period,step,maximum);
//---
   if(m_handle!=INVALID_HANDLE)
     {
      //--- indicator successfully created
      if(!Initialize(symbol,period,step,maximum))
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
//| Access to buffer of "Parabolic Stop And Reverse System".         |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiSAR::Main(int index) const
  {
   CIndicatorBuffer *buffer=At(0);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Class CiStdDev.                                                  |
//| Purpose: Class indicator "Standard Deviation".                   |
//|              Derives from class CIndicator.                      |
//+------------------------------------------------------------------+
class CiStdDev : public CIndicator
  {
protected:
   int               m_ma_period;
   int               m_ma_shift;
   ENUM_MA_METHOD    m_ma_method;
   int               m_applied;

public:
                     CiStdDev();
   //--- methods of access to protected data
   int               MaPeriod()      const { return(m_ma_period); }
   int               MaShift()       const { return(m_ma_shift);  }
   ENUM_MA_METHOD    MaMethod()      const { return(m_ma_method); }
   int               Applied()       const { return(m_applied);   }
   //--- method of creation
   bool              Create(string symbol,ENUM_TIMEFRAMES period,int ma_period,int ma_shift,ENUM_MA_METHOD ma_method,int applied);
   //--- methods of access to indicator data
   double            Main(int index) const;
   //--- method of identifying
   virtual int       Type()          const { return(IND_STDDEV);  }

protected:
   //--- methods of tuning
   virtual bool      Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[]);
   bool              Initialize(string symbol,ENUM_TIMEFRAMES period,int ma_period,int ma_shift,ENUM_MA_METHOD ma_method,int applied);
  };
//+------------------------------------------------------------------+
//| Constructor CiStdDev.                                            |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CiStdDev::CiStdDev()
  {
//--- initialize protected data
   m_ma_period=-1;
   m_ma_shift =-1;
   m_ma_method=WRONG_VALUE;
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
bool CiStdDev::Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[])
  {
   return(Initialize(symbol,period,(int)params[0].integer_value,(int)params[1].integer_value,
                        (ENUM_MA_METHOD)params[2].integer_value,(int)params[3].integer_value));
  }
//+------------------------------------------------------------------+
//| Initialize indicator with the special parameters.                |
//| INPUT:  symbol    - indicator symbol,                            |
//|         period    - indicator period,                            |
//|         ma_period - period MA,                                   |
//|         ma_shift  - shift MA,                                    |
//|         ma_method - averaging method MA,                         |
//|         applied   - what to apply the indicator to.              |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiStdDev::Initialize(string symbol,ENUM_TIMEFRAMES period,int ma_period,int ma_shift,ENUM_MA_METHOD ma_method,int applied)
  {
   if(CreateBuffers(symbol,period,1))
     {
      //--- string of status of drawing
      m_name  ="StdDev";
      m_status="("+symbol+","+PeriodDescription()+","+
                IntegerToString(ma_period)+","+IntegerToString(ma_shift)+","+
                MethodDescription(ma_method)+") H="+IntegerToString(m_handle);
      //--- save settings
      m_ma_period=ma_period;
      m_ma_shift =ma_shift;
      m_ma_method=ma_method;
      m_applied  =applied;
      //--- create buffers
      ((CIndicatorBuffer*)At(0)).Name("MAIN_LINE");
      ((CIndicatorBuffer*)At(0)).Offset(ma_shift);
      //--- ok
      return(true);
     }
//--- error
   return(false);
  }
//+------------------------------------------------------------------+
//| Create indicator "Standard Deviation".                           |
//| INPUT:  symbol    - indicator symbol,                            |
//|         period    - indicator period,                            |
//|         ma_period - period MA,                                   |
//|         ma_shift  - shift MA,                                    |
//|         ma_method - averaging method MA,                         |
//|         applied   - what to apply the indicator to.              |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiStdDev::Create(string symbol,ENUM_TIMEFRAMES period,int ma_period,int ma_shift,ENUM_MA_METHOD ma_method,int applied)
  {
   m_handle=iStdDev(symbol,period,ma_period,ma_shift,ma_method,applied);
//---
   if(m_handle!=INVALID_HANDLE)
     {
      //--- indicator successfully created
      if(!Initialize(symbol,period,ma_period,ma_shift,ma_method,applied))
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
//| Access to buffer of "Standard Deviation".                        |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiStdDev::Main(int index) const
  {
   CIndicatorBuffer *buffer=At(0);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Class CiDEMA.                                                    |
//| Purpose: Class indicator "Double Exponential Moving Average".    |
//|              Derives from class CIndicator.                      |
//+------------------------------------------------------------------+
class CiDEMA : public CIndicator
  {
protected:
   int               m_ma_period;
   int               m_ind_shift;
   int               m_applied;

public:
                     CiDEMA();
   //--- methods of access to protected data
   int               MaPeriod()      const { return(m_ma_period); }
   int               IndShift()      const { return(m_ind_shift); }
   int               Applied()       const { return(m_applied);   }
   //--- method of creation
   bool              Create(string symbol,ENUM_TIMEFRAMES period,int ma_period,int ind_shift,int applied);
   //--- methods of access to indicator data
   double            Main(int index) const;
   //--- method of identifying
   virtual int       Type()          const { return(IND_DEMA);    }

protected:
   //--- methods of tuning
   virtual bool      Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[]);
   bool              Initialize(string symbol,ENUM_TIMEFRAMES period,int ma_period,int ind_shift,int applied);
  };
//+------------------------------------------------------------------+
//| Constructor CiDEMA.                                              |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CiDEMA::CiDEMA()
  {
//--- initialize protected data
   m_ma_period=-1;
   m_ind_shift=-1;
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
bool CiDEMA::Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[])
  {
   return(Initialize(symbol,period,(int)params[0].integer_value,(int)params[1].integer_value,(int)params[2].integer_value));
  }
//+------------------------------------------------------------------+
//| Initialize indicator with the special parameters.                |
//| INPUT:  symbol    - indicator symbol,                            |
//|         period    - indicator period,                            |
//|         ma_period - period MA,                                   |
//|         ind_shift - shift indicator buffer,                      |
//|         applied   - what to apply the indicator to.              |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiDEMA::Initialize(string symbol,ENUM_TIMEFRAMES period,int ma_period,int ind_shift,int applied)
  {
   if(CreateBuffers(symbol,period,1))
     {
      //--- string of status of drawing
      m_name  ="DEMA";
      m_status="("+symbol+","+PeriodDescription()+","+
                IntegerToString(ma_period)+","+IntegerToString(ind_shift)+","+
                PriceDescription(applied)+") H="+IntegerToString(m_handle);
      //--- save settings
      m_ma_period=ma_period;
      m_ind_shift=ind_shift;
      m_applied  =applied;
      //--- create buffers
      ((CIndicatorBuffer*)At(0)).Name("MAIN_LINE");
      ((CIndicatorBuffer*)At(0)).Offset(ind_shift);
      //--- ok
      return(true);
     }
//--- error
   return(false);
  }
//+------------------------------------------------------------------+
//| Create indicator "Double Exponential Moving Average".            |
//| INPUT:  symbol    - indicator symbol,                            |
//|         period    - indicator period,                            |
//|         ma_period - period MA,                                   |
//|         ind_shift - shift indicator buffer,                      |
//|         applied   - what to apply the indicator to.              |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiDEMA::Create(string symbol,ENUM_TIMEFRAMES period,int ma_period,int ind_shift,int applied)
  {
   m_handle=iDEMA(symbol,period,ma_period,ind_shift,applied);
//---
   if(m_handle!=INVALID_HANDLE)
     {
      //--- indicator successfully created
      if(!Initialize(symbol,period,ma_period,ind_shift,applied))
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
//| Access to buffer of "Double Exponential Moving Average".         |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiDEMA::Main(int index) const
  {
   CIndicatorBuffer *buffer=At(0);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Class CiTEMA.                                                    |
//| Purpose: Class indicator "Triple Exponential Moving Average".    |
//|              Derives from class CIndicator.                      |
//+------------------------------------------------------------------+
class CiTEMA : public CIndicator
  {
protected:
   int               m_ma_period;
   int               m_ind_shift;
   int               m_applied;

public:
                     CiTEMA();
   //--- methods of access to protected data
   int               MaPeriod()      const { return(m_ma_period); }
   int               IndShift()      const { return(m_ind_shift); }
   int               Applied()       const { return(m_applied);   }
   //--- method of creation
   bool              Create(string symbol,ENUM_TIMEFRAMES period,int ma_period,int ma_shift,int applied);
   //--- methods of access to indicator data
   double            Main(int index) const;
   //--- method of identifying
   virtual int       Type()          const { return(IND_TEMA);    }

protected:
   //--- methods of tuning
   virtual bool      Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[]);
   bool              Initialize(string symbol,ENUM_TIMEFRAMES period,int ma_period,int ma_shift,int applied);
  };
//+------------------------------------------------------------------+
//| Constructor CiTEMA.                                              |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CiTEMA::CiTEMA()
  {
//--- initialize protected data
   m_ma_period=-1;
   m_ind_shift=-1;
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
bool CiTEMA::Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[])
  {
   return(Initialize(symbol,period,(int)params[0].integer_value,(int)params[1].integer_value,(int)params[2].integer_value));
  }
//+------------------------------------------------------------------+
//| Initialize indicator with the special parameters.                |
//| INPUT:  symbol    - indicator symbol,                            |
//|         period    - indicator period,                            |
//|         ma_period - period MA,                                   |
//|         ind_shift - shift indicator buffer,                      |
//|         applied   - what to apply the indicator to.              |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiTEMA::Initialize(string symbol,ENUM_TIMEFRAMES period,int ma_period,int ind_shift,int applied)
  {
   if(CreateBuffers(symbol,period,1))
     {
      //--- string of status of drawing
      m_name  ="TEMA";
      m_status="("+symbol+","+PeriodDescription()+","+
                IntegerToString(ma_period)+","+IntegerToString(ind_shift)+","+
                PriceDescription(applied)+") H="+IntegerToString(m_handle);
      //--- save settings
      m_ma_period=ma_period;
      m_ind_shift=ind_shift;
      m_applied  =applied;
      //--- create buffers
      ((CIndicatorBuffer*)At(0)).Name("MAIN_LINE");
      ((CIndicatorBuffer*)At(0)).Offset(ind_shift);
      //--- ok
      return(true);
     }
//--- error
   return(false);
  }
//+------------------------------------------------------------------+
//| Create indicator "Triple Exponential Moving Average".            |
//| INPUT:  symbol    - indicator symbol,                            |
//|         period    - indicator period,                            |
//|         ma_period - period MA,                                   |
//|         ind_shift - shift indicator buffer,                      |
//|         applied   - what to apply the indicator to.              |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiTEMA::Create(string symbol,ENUM_TIMEFRAMES period,int ma_period,int ind_shift,int applied)
  {
   m_handle=iTEMA(symbol,period,ma_period,ind_shift,applied);
//---
   if(m_handle!=INVALID_HANDLE)
     {
      //--- indicator successfully created
      if(!Initialize(symbol,period,ma_period,ind_shift,applied))
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
//| Access to buffer of "Triple Exponential Moving Average".         |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiTEMA::Main(int index) const
  {
   CIndicatorBuffer *buffer=At(0);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Class CiFrAMA.                                                   |
//| Purpose: Class indicator "Fractal Adaptive Moving Average".      |
//|              Derives from class CIndicator.                      |
//+------------------------------------------------------------------+
class CiFrAMA : public CIndicator
  {
protected:
   int               m_ma_period;
   int               m_ind_shift;
   int               m_applied;

public:
                     CiFrAMA();
   //--- methods of access to protected data
   int               MaPeriod()      const { return(m_ma_period); }
   int               IndShift()      const { return(m_ind_shift); }
   int               Applied()       const { return(m_applied);   }
   //--- method of creation
   bool              Create(string symbol,ENUM_TIMEFRAMES period,int ma_period,int ind_shift,int applied);
   //--- methods of access to indicator data
   double            Main(int index) const;
   //--- method of identifying
   virtual int       Type()          const { return(IND_FRAMA);   }

protected:
   //--- methods of tuning
   virtual bool      Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[]);
   bool              Initialize(string symbol,ENUM_TIMEFRAMES period,int ma_period,int ind_shift,int applied);
  };
//+------------------------------------------------------------------+
//| Constructor CiFrAMA.                                             |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CiFrAMA::CiFrAMA()
  {
//--- initialize protected data
   m_ma_period=-1;
   m_ind_shift=-1;
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
bool CiFrAMA::Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[])
  {
   return(Initialize(symbol,period,(int)params[0].integer_value,(int)params[1].integer_value,(int)params[2].integer_value));
  }
//+------------------------------------------------------------------+
//| Initialize indicator with the special parameters.                |
//| INPUT:  symbol    - indicator symbol,                            |
//|         period    - indicator period,                            |
//|         ma_period - period MA,                                   |
//|         ind_shift - shift indicator buffer,                      |
//|         applied   - what to apply the indicator to.              |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiFrAMA::Initialize(string symbol,ENUM_TIMEFRAMES period,int ma_period,int ind_shift,int applied)
  {
   if(CreateBuffers(symbol,period,1))
     {
      //--- string of status of drawing
      m_name  ="FrAMA";
      m_status="("+symbol+","+PeriodDescription()+","+
                IntegerToString(ma_period)+","+IntegerToString(ind_shift)+","+
                PriceDescription(applied)+") H="+IntegerToString(m_handle);
      //--- save settings
      m_ma_period=ma_period;
      m_applied  =applied;
      //--- create buffers
      ((CIndicatorBuffer*)At(0)).Name("MAIN_LINE");
      ((CIndicatorBuffer*)At(0)).Offset(ind_shift);
      //--- ok
      return(true);
     }
//--- error
   return(false);
  }
//+------------------------------------------------------------------+
//| Create indicator "Fractal Adaptive Moving Average".              |
//| INPUT:  symbol    - indicator symbol,                            |
//|         period    - indicator period,                            |
//|         ma_period - period MA,                                   |
//|         ind_shift - shift indicator buffer,                      |
//|         applied   - what to apply the indicator to.              |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiFrAMA::Create(string symbol,ENUM_TIMEFRAMES period,int ma_period,int ind_shift,int applied)
  {
   m_handle=iFrAMA(symbol,period,ma_period,ind_shift,applied);
//---
   if(m_handle!=INVALID_HANDLE)
     {
      //--- indicator successfully created
      if(!Initialize(symbol,period,ma_period,ind_shift,applied))
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
//| Access to buffer of "Fractal Adaptive Moving Average".           |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiFrAMA::Main(int index) const
  {
   CIndicatorBuffer *buffer=At(0);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Class CiAMA.                                                     |
//| Purpose: Class indicator "Adaptive Moving Average".              |
//|              Derives from class CIndicator.                      |
//+------------------------------------------------------------------+
class CiAMA : public CIndicator
  {
protected:
   int               m_ma_period;
   int               m_fast_ema_period;
   int               m_slow_ema_period;
   int               m_ind_shift;
   int               m_applied;

public:
                     CiAMA();
   //--- methods of access to protected data
   int               MaPeriod()      const { return(m_ma_period);       }
   int               FastEmaPeriod() const { return(m_fast_ema_period); }
   int               SlowEmaPeriod() const { return(m_slow_ema_period); }
   int               IndShift()      const { return(m_ind_shift);       }
   int               Applied()       const { return(m_applied);         }
   //--- method of creation
   bool              Create(string symbol,ENUM_TIMEFRAMES period,int ma_period,int fast_ema_period,int slow_ema_period,int ind_shift,int applied);
   //--- methods of access to indicator data
   double            Main(int index) const;
   //--- method of identifying
   virtual int       Type()          const { return(IND_AMA);           }

protected:
   //--- methods of tuning
   virtual bool      Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[]);
   bool              Initialize(string symbol,ENUM_TIMEFRAMES period,int ma_period,int fast_ema_period,int slow_ema_period,int ind_shift,int applied);
  };
//+------------------------------------------------------------------+
//| Constructor CiAMA.                                               |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CiAMA::CiAMA()
  {
//--- initialize protected data
   m_ma_period      =-1;
   m_fast_ema_period=-1;
   m_slow_ema_period=-1;
   m_ind_shift      =-1;
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
bool CiAMA::Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[])
  {
   return(Initialize(symbol,period,(int)params[0].integer_value,(int)params[1].integer_value,
                                   (int)params[2].integer_value,(int)params[3].integer_value,
                                   (int)params[4].integer_value));
  }
//+------------------------------------------------------------------+
//| Initialize indicator with the special parameters.                |
//| INPUT:  symbol          - indicator symbol,                      |
//|         period          - indicator period,                      |
//|         ma_period       - period MA,                             |
//|         fast_ema_period - period fast EMA,                       |
//|         slow_ema_period - period slow EMA,                       |
//|         ind_shift       - shift indicator buffer,                |
//|         applied         - what to apply the indicator to.        |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiAMA::Initialize(string symbol,ENUM_TIMEFRAMES period,int ma_period,int fast_ema_period,int slow_ema_period,int ind_shift,int applied)
  {
   if(CreateBuffers(symbol,period,1))
     {
      //--- string of status of drawing
      m_name  ="AMA";
      m_status="("+symbol+","+PeriodDescription()+","+
                IntegerToString(ma_period)+","+IntegerToString(fast_ema_period)+","+IntegerToString(slow_ema_period)+","+
                IntegerToString(ind_shift)+","+PriceDescription(applied)+") H="+IntegerToString(m_handle);
      //--- save settings
      m_ma_period      =ma_period;
      m_fast_ema_period=fast_ema_period;
      m_slow_ema_period=slow_ema_period;
      m_ind_shift      =ind_shift;
      m_applied        =applied;
      //--- create buffers
      ((CIndicatorBuffer*)At(0)).Name("MAIN_LINE");
      ((CIndicatorBuffer*)At(0)).Offset(ind_shift);
      //--- ok
      return(true);
     }
//--- error
   return(false);
  }
//+------------------------------------------------------------------+
//| Create indicator "Adaptive Moving Average".                      |
//| INPUT:  symbol          - indicator symbol,                      |
//|         period          - indicator period,                      |
//|         ma_period       - period MA,                             |
//|         fast_ema_period - period fast EMA,                       |
//|         slow_ema_period - period slow EMA,                       |
//|         ind_shift       - shift indicator buffer,                |
//|         applied         - what to apply the indicator to.        |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiAMA::Create(string symbol,ENUM_TIMEFRAMES period,int ma_period,int fast_ema_period,int slow_ema_period,int ind_shift,int applied)
  {
   m_handle=iAMA(symbol,period,ma_period,fast_ema_period,slow_ema_period,ind_shift,applied);
//---
   if(m_handle!=INVALID_HANDLE)
     {
      //--- indicator successfully created
      if(!Initialize(symbol,period,ma_period,fast_ema_period,slow_ema_period,ind_shift,applied))
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
//| Access to buffer of "Adaptive Moving Average".                   |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiAMA::Main(int index) const
  {
   CIndicatorBuffer *buffer=At(0);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| Class CiVIDyA.                                                   |
//| Purpose: Class indicator "Variable Index DYnamic Average".       |
//|              Derives from class CIndicator.                      |
//+------------------------------------------------------------------+
class CiVIDyA : public CIndicator
  {
protected:
   int               m_cmo_period;
   int               m_ema_period;
   int               m_ind_shift;
   int               m_applied;

public:
                     CiVIDyA();
   //--- methods of access to protected data
   int               CmoPeriod()     const { return(m_cmo_period); }
   int               EmaPeriod()     const { return(m_ema_period); }
   int               IndShift()      const { return(m_ind_shift);  }
   int               Applied()       const { return(m_applied);    }
   //--- method of creation
   bool              Create(string symbol,ENUM_TIMEFRAMES period,int cmo_period,int ema_period,int ind_shift,int applied);
   //--- methods of access to indicator data
   double            Main(int index) const;
   //--- method of identifying
   virtual int       Type()          const { return(IND_VIDYA);    }

protected:
   //--- methods of tuning
   virtual bool      Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[]);
   bool              Initialize(string symbol,ENUM_TIMEFRAMES period,int cmo_period,int ema_period,int ind_shift,int applied);
  };
//+------------------------------------------------------------------+
//| Constructor CiVIDyA.                                             |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CiVIDyA::CiVIDyA()
  {
//--- initialize protected data
   m_cmo_period=-1;
   m_ema_period=-1;
   m_ind_shift =-1;
   m_applied   =-1;
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
bool CiVIDyA::Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[])
  {
//---
   return(Initialize(symbol,period,(int)params[0].integer_value,(int)params[1].integer_value,
                                   (int)params[2].integer_value,(int)params[3].integer_value));
  }
//+------------------------------------------------------------------+
//| Initialize indicator with the special parameters.                |
//| INPUT:  symbol     - indicator symbol,                           |
//|         period     - indicator period,                           |
//|         cmo_period - period CMO,                                 |
//|         ema_period - period EMA,                                 |
//|         ind_shift  - shift indicator buffer,                     |
//|         applied    - what to apply the indicator to.             |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiVIDyA::Initialize(string symbol,ENUM_TIMEFRAMES period,int cmo_period,int ema_period,int ind_shift,int applied)
  {
   if(CreateBuffers(symbol,period,1))
     {
      //--- string of status of drawing
      m_name  ="VIDyA";
      m_status="("+symbol+","+PeriodDescription()+","+
                IntegerToString(cmo_period)+","+IntegerToString(ema_period)+","+IntegerToString(ind_shift)+","+
                PriceDescription(applied)+") H="+IntegerToString(m_handle);
      //--- save settings
      m_cmo_period=cmo_period;
      m_ema_period=ema_period;
      m_ind_shift =ind_shift;
      m_applied   =applied;
      //--- create buffers
      ((CIndicatorBuffer*)At(0)).Name("MAIN_LINE");
      ((CIndicatorBuffer*)At(0)).Offset(ind_shift);
      //--- ok
      return(true);
     }
//--- error
   return(false);
  }
//+------------------------------------------------------------------+
//| Create indicator "Variable Index DYnamic Average".               |
//| INPUT:  symbol     - indicator symbol,                           |
//|         period     - indicator period,                           |
//|         cmo_period - period CMO,                                 |
//|         ema_period - period EMA,                                 |
//|         ind_shift  - shift indicator buffer,                     |
//|         applied    - what to apply the indicator to.             |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiVIDyA::Create(string symbol,ENUM_TIMEFRAMES period,int cmo_period,int ema_period,int ind_shift,int applied)
  {
   m_handle=iVIDyA(symbol,period,cmo_period,ema_period,ind_shift,applied);
//---
   if(m_handle!=INVALID_HANDLE)
     {
      //--- indicator successfully created
      if(!Initialize(symbol,period,cmo_period,ema_period,ind_shift,applied))
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
//| Access to buffer of "Variable Index DYnamic Average".            |
//| INPUT:  index - buffer index.                                    |
//| OUTPUT: value of buffer.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiVIDyA::Main(int index) const
  {
   CIndicatorBuffer *buffer=At(0);
//--- checking
   if(buffer==NULL) return(EMPTY_VALUE);
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
