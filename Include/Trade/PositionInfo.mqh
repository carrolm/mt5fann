//+------------------------------------------------------------------+
//|                                                 PositionInfo.mqh |
//|                      Copyright © 2010, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//|                                              Revision 2010.05.14 |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Class CPositionInfo.                                             |
//| Appointment: Class for access to position info.                  |
//+------------------------------------------------------------------+
class CPositionInfo
  {
protected:
   ENUM_POSITION_TYPE m_type;
   double            m_volume;
   double            m_price;
   double            m_stop_loss;
   double            m_take_profit;

public:
   //--- fast access methods to the integer position propertyes
   datetime           Time() const;
   ENUM_POSITION_TYPE Type() const;
   string             TypeDescription() const;
   long               Magic() const;
   long               Identifier() const;
   //--- fast access methods to the double position propertyes
   double            Volume() const;
   double            PriceOpen() const;
   double            StopLoss() const;
   double            TakeProfit() const;
   double            PriceCurrent() const;
   double            Commission() const;
   double            Swap() const;
   double            Profit() const;
   //--- fast access methods to the string position propertyes
   string            Symbol() const;
   //--- access methods to the API MQL5 functions
   bool              InfoInteger(ENUM_POSITION_PROPERTY_INTEGER prop_id,long& var) const;
   bool              InfoDouble(ENUM_POSITION_PROPERTY_DOUBLE prop_id,double& var) const;
   bool              InfoString(ENUM_POSITION_PROPERTY_STRING prop_id,string& var) const;
   //--- method for select position
   bool              Select(const string symbol);
   //---
   void              StoreState();
   bool              CheckState();
  };
//+------------------------------------------------------------------+
//| Get the property value "POSITION_TIME".                          |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "POSITION_TIME".                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
datetime CPositionInfo::Time() const
  {
   return((datetime)PositionGetInteger(POSITION_TIME));
  }
//+------------------------------------------------------------------+
//| Get the property value "POSITION_TYPE".                          |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "POSITION_TYPE".                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
ENUM_POSITION_TYPE CPositionInfo::Type() const
  {
   return((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE));
  }
//+------------------------------------------------------------------+
//| Get the property value "POSITION_TYPE" as string.                |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "POSITION_TYPE" as string.            |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CPositionInfo::TypeDescription() const
  {
   string str;
//---
   switch(Type())
     {
      case POSITION_TYPE_BUY:
         str="Buy";
         break;
      case POSITION_TYPE_SELL:
         str="Sell";
         break;
      default:
         str="Unknown type";
     }
//---
   return(str);
  }
//+------------------------------------------------------------------+
//| Get the property value "POSITION_MAGIC".                         |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "POSITION_MAGIC".                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
long CPositionInfo::Magic() const
  {
   return(PositionGetInteger(POSITION_MAGIC));
  }
//+------------------------------------------------------------------+
//| Get the property value "POSITION_IDENTIFIER".                    |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "POSITION_IDENTIFIER".                |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
long CPositionInfo::Identifier() const
  {
   return(PositionGetInteger(POSITION_IDENTIFIER));
  }
//+------------------------------------------------------------------+
//| Get the property value "POSITION_VOLUME".                        |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "POSITION_VOLUME".                    |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CPositionInfo::Volume() const
  {
   return(PositionGetDouble(POSITION_VOLUME));
  }
//+------------------------------------------------------------------+
//| Get the property value "POSITION_PRICE_OPEN".                    |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "POSITION_PRICE_OPEN".                |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CPositionInfo::PriceOpen() const
  {
   return(PositionGetDouble(POSITION_PRICE_OPEN));
  }
//+------------------------------------------------------------------+
//| Get the property value "POSITION_SL".                            |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "POSITION_SL".                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CPositionInfo::StopLoss() const
  {
   return(PositionGetDouble(POSITION_SL));
  }
//+------------------------------------------------------------------+
//| Get the property value "POSITION_TP".                            |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "POSITION_TP".                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CPositionInfo::TakeProfit() const
  {
   return(PositionGetDouble(POSITION_TP));
  }
//+------------------------------------------------------------------+
//| Get the property value "POSITION_PRICE_CURRENT".                 |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "POSITION_PRICE_CURRENT".             |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CPositionInfo::PriceCurrent() const
  {
   return(PositionGetDouble(POSITION_PRICE_CURRENT));
  }
//+------------------------------------------------------------------+
//| Get the property value "POSITION_COMMISSION".                    |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "POSITION_COMMISSION".                |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CPositionInfo::Commission() const
  {
   return(PositionGetDouble(POSITION_COMMISSION));
  }
//+------------------------------------------------------------------+
//| Get the property value "POSITION_SWAP".                          |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "POSITION_SWAP".                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CPositionInfo::Swap() const
  {
   return(PositionGetDouble(POSITION_SWAP));
  }
//+------------------------------------------------------------------+
//| Get the property value "POSITION_PROFIT".                        |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "POSITION_PROFIT".                    |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CPositionInfo::Profit() const
  {
   return(PositionGetDouble(POSITION_PROFIT));
  }
//+------------------------------------------------------------------+
//| Get the property value "POSITION_SYMBOL".                        |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "POSITION_SYMBOL".                    |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CPositionInfo::Symbol() const
  {
   return(PositionGetString(POSITION_SYMBOL));
  }
//+------------------------------------------------------------------+
//| Access functions PositionGetInteger(...).                        |
//| INPUT:  prop_id  -identifier integer properties,                 |
//|         var     -reference to a variable to value.               |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CPositionInfo::InfoInteger(ENUM_POSITION_PROPERTY_INTEGER prop_id,long& var) const
  {
   return(PositionGetInteger(prop_id,var));
  }
//+------------------------------------------------------------------+
//| Access functions PositionGetDouble(...).                         |
//| INPUT:  prop_id  -identifier double properties,                  |
//|         var     -reference to a variable to value.               |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CPositionInfo::InfoDouble(ENUM_POSITION_PROPERTY_DOUBLE prop_id,double& var) const
  {
   return(PositionGetDouble(prop_id,var));
  }
//+------------------------------------------------------------------+
//| Access functions PositionGetString(...).                         |
//| INPUT:  prop_id  -identifier string properties,                  |
//|         var     -reference to a variable to value.               |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CPositionInfo::InfoString(ENUM_POSITION_PROPERTY_STRING prop_id,string& var) const
  {
   return(PositionGetString(prop_id,var));
  }
//+------------------------------------------------------------------+
//| Access functions PositionSelect(...).                            |
//| INPUT:  symbol -symbol name for select position.                 |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CPositionInfo::Select(const string symbol)
  {
   return(PositionSelect(symbol));
  }
//+------------------------------------------------------------------+
//| Stored position's current state.                                  |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CPositionInfo::StoreState()
  {
   m_type       =Type();
   m_volume     =Volume();
   m_price      =PriceOpen();
   m_stop_loss  =StopLoss();
   m_take_profit=TakeProfit();
  }
//+------------------------------------------------------------------+
//| Check position change.                                           |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: true - if position changed.                              |
//+------------------------------------------------------------------+
bool CPositionInfo::CheckState()
  {
   if(m_type==Type() &&
      m_volume==Volume() &&
      m_price==PriceOpen() &&
      m_stop_loss==StopLoss() &&
      m_take_profit==TakeProfit())
      return(false);
   else
      return(true);
  }
//+------------------------------------------------------------------+
