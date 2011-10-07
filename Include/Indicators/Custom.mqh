//+------------------------------------------------------------------+
//|                                                       Custom.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//|                                              Revision 2010.10.17 |
//+------------------------------------------------------------------+
#include "Indicator.mqh"
//+------------------------------------------------------------------+
//| Class CiCustom.                                                  |
//| Purpose: Class of custom indicators.                             |
//|          Derives from class CIndicator.                          |
//+------------------------------------------------------------------+
class CiCustom : public CIndicator
  {
protected:
   int               m_num_params;       // number of creation parameters
   MqlParam          m_params[];         // creation parameters

public:
   //--- methods of access to protected data
   bool              NumBuffers(int buffers);
   int               NumParams()          const { return(m_num_params); }
   ENUM_DATATYPE     ParamType(int ind)   const;
   long              ParamLong(int ind)   const;
   double            ParamDouble(int ind) const;
   string            ParamString(int ind) const;
   //--- method of identifying
   virtual int       Type()               const { return(IND_CUSTOM);   }

protected:
   //--- methods of tuning
   virtual bool      Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[]);
  };
//+------------------------------------------------------------------+
//| Set number of buffers of indicator.                              |
//| INPUT:  buffers - number of buffers.                             |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiCustom::NumBuffers(int buffers)
  {
   bool result=true;
//---
   if(m_buffers_total==0)
     {
      m_buffers_total=buffers;
      return(true);
     }
   if(m_buffers_total!=buffers)
     {
      Shutdown();
      result=CreateBuffers(m_symbol,m_period,buffers);
      if(result)
        {
         //--- create buffers
         for(int i=0;i<m_buffers_total;i++)
            ((CIndicatorBuffer*)At(i)).Name("LINE "+IntegerToString(i));
        }
     }
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Get type of specified parameter of creation.                     |
//| INPUT:  ind - index.                                             |
//| OUTPUT: type of specified parameter of creation,                 |
//|         or WRONG_VALUE if index is invalid.                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
ENUM_DATATYPE CiCustom::ParamType(int ind) const
  {
   if(ind>=m_num_params) return(WRONG_VALUE);
//---
   return(m_params[ind].type);
  }
//+------------------------------------------------------------------+
//| Get specified parameter of creatiob as a long value.             |
//| INPUT:  ind - index.                                             |
//| OUTPUT: specified parameter of creation as a long value,         |
//|         or 0 if index or type is invalid.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
long CiCustom::ParamLong(int ind) const
  {
   if(ind>=m_num_params) return(0);
   switch(m_params[ind].type)
     {
      case TYPE_DOUBLE:
      case TYPE_FLOAT:
      case TYPE_STRING:
         return(0);
     }
//---
   return(m_params[ind].integer_value);
  }
//+------------------------------------------------------------------+
//| Get specified parameter of creation as a double value.           |
//| INPUT:  ind - index.                                             |
//| OUTPUT: specified parameter of creation as a double value,       |
//|         or EMPTY_VALUE if index or type is invalid.              |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CiCustom::ParamDouble(int ind) const
  {
   if(ind>=m_num_params) return(EMPTY_VALUE);
   switch(m_params[ind].type)
     {
      case TYPE_DOUBLE:
      case TYPE_FLOAT:
         break;
      default:
         return(EMPTY_VALUE);
     }
//---
   return(m_params[ind].double_value);
  }
//+------------------------------------------------------------------+
//| Get specified parameter of creation as a string value.           |
//| INPUT:  ind - index.                                             |
//| OUTPUT: specified parameter of creation as a string value,       |
//|         or "" if index or type is invalid.                       |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CiCustom::ParamString(int ind) const
  {
   if(ind>=m_num_params || m_params[ind].type!=TYPE_STRING) return("");
//---
   return(m_params[ind].string_value);
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
bool CiCustom::Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[])
  {
   int  i;
//--- tuning
   if(m_buffers_total==0) m_buffers_total=256;
   if(CreateBuffers(symbol,period,m_buffers_total))
     {
      //--- string of status of drawing
      m_name  ="Custom "+params[0].string_value;
      m_status="("+symbol+","+PeriodDescription();
      for(i=1;i<num_params;i++)
        {
         switch(params[i].type)
           {
            case TYPE_BOOL:
               m_status=m_status+","+((params[i].integer_value)?"true":"false");
               break;
            case TYPE_CHAR:
            case TYPE_UCHAR:
            case TYPE_SHORT:
            case TYPE_USHORT:
            case TYPE_INT:
            case TYPE_UINT:
            case TYPE_LONG:
            case TYPE_ULONG:
               m_status=m_status+","+IntegerToString(params[i].integer_value);
               break;
            case TYPE_COLOR:
               m_status=m_status+","+ColorToString((color)params[i].integer_value);
               break;
            case TYPE_DATETIME:
               m_status=m_status+","+TimeToString(params[i].integer_value);
               break;
            case TYPE_FLOAT:
            case TYPE_DOUBLE:
               m_status=m_status+","+DoubleToString(params[i].double_value);
               break;
            case TYPE_STRING:
               m_status=m_status+",'"+params[i].string_value+"'";
               break;
           }
        }
      m_status=m_status+") H="+IntegerToString(m_handle);
      //--- save settings
      ArrayResize(m_params,num_params);
      for(i=0;i<num_params;i++)
        {
         m_params[i].type         =params[i].type;
         m_params[i].integer_value=params[i].integer_value;
         m_params[i].double_value =params[i].double_value;
         m_params[i].string_value =params[i].string_value;
        }
      //--- create buffers
      for(i=0;i<m_buffers_total;i++)
         ((CIndicatorBuffer*)At(i)).Name("LINE "+IntegerToString(i));
      //--- ok
      return(true);
     }
//--- error
   return(false);
  }
//+------------------------------------------------------------------+
