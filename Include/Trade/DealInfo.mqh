//+------------------------------------------------------------------+
//|                                                     DealInfo.mqh |
//|                      Copyright � 2010, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//|                                              Revision 2010.09.14 |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Class CDealInfo.                                                 |
//| Appointment: Class for access to history deal info.              |
//+------------------------------------------------------------------+
class CDealInfo
  {
protected:
   ulong             m_ticket;             // ticket of history order
public:
   //--- methods of access to protected data
   void              Ticket(ulong ticket) { m_ticket=ticket;  }
   ulong             Ticket() const       { return(m_ticket); }
   //--- fast access methods to the integer position propertyes
   long              Order() const;
   datetime          Time() const;
   ENUM_DEAL_TYPE    Type() const;
   string            TypeDescription() const;
   ENUM_DEAL_ENTRY   Entry() const;
   string            EntryDescription() const;
   long              Magic() const;
   long              PositionId() const;
   //--- fast access methods to the double position propertyes
   double            Volume() const;
   double            Price() const;
   double            Commission() const;
   double            Swap() const;
   double            Profit() const;
   //--- fast access methods to the string position propertyes
   string            Symbol() const;
   string            Comment() const;
   //--- access methods to the API MQL5 functions
   bool              InfoInteger(ENUM_DEAL_PROPERTY_INTEGER prop_id,long& var) const;
   bool              InfoDouble(ENUM_DEAL_PROPERTY_DOUBLE prop_id,double& var) const;
   bool              InfoString(ENUM_DEAL_PROPERTY_STRING prop_id,string& var) const;
  };
//+------------------------------------------------------------------+
//| Get the property value "DEAL_ORDER".                             |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "DEAL_ORDER".                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
long CDealInfo::Order() const
  {
   return(HistoryDealGetInteger(m_ticket,DEAL_ORDER));
  }
//+------------------------------------------------------------------+
//| Get the property value "DEAL_TIME".                              |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "DEAL_TIME".                          |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
datetime CDealInfo::Time() const
  {
   return((datetime)HistoryDealGetInteger(m_ticket,DEAL_TIME));
  }
//+------------------------------------------------------------------+
//| Get the property value "DEAL_TYPE".                              |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "DEAL_TYPE".                          |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
ENUM_DEAL_TYPE CDealInfo::Type() const
  {
   return((ENUM_DEAL_TYPE)HistoryDealGetInteger(m_ticket,DEAL_TYPE));
  }
//+------------------------------------------------------------------+
//| Get the property value "DEAL_TYPE" as string.                    |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "DEAL_TYPE" as string.                |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CDealInfo::TypeDescription() const
  {
   string str;
//---
   switch(Type())
     {
      case DEAL_TYPE_BUY:
         str="Buy type";
         break;
      case DEAL_TYPE_SELL:
         str="Sell type";
         break;
      case DEAL_TYPE_BALANCE:
         str="Balance type";
         break;
      case DEAL_TYPE_CREDIT:
         str="Credit type";
         break;
      case DEAL_TYPE_CHARGE:
         str="Charge type";
         break;
      case DEAL_TYPE_CORRECTION:
         str="Correction type";
         break;
      default:
         str="Unknown type";
     }
//---
   return(str);
  }
//+------------------------------------------------------------------+
//| Get the property value "DEAL_ENTRY".                             |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "DEAL_ENTRY".                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
ENUM_DEAL_ENTRY CDealInfo::Entry() const
  {
   return((ENUM_DEAL_ENTRY)HistoryDealGetInteger(m_ticket,DEAL_ENTRY));
  }
//+------------------------------------------------------------------+
//| Get the property value "DEAL_ENTRY" as string.                   |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "DEAL_ENTRY" as string.               |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CDealInfo::EntryDescription() const
  {
   string str;
//---
   switch(Entry())
     {
      case DEAL_ENTRY_IN:
         str="In entry";
         break;
      case DEAL_ENTRY_OUT:
         str="Out entry";
         break;
      case DEAL_ENTRY_INOUT:
         str="InOut entry";
         break;
      case DEAL_ENTRY_STATE:
         str="Status record";
         break;
      default:
         str="Unknown entry";
     }
//---
   return(str);
  }
//+------------------------------------------------------------------+
//| Get the property value "DEAL_MAGIC".                             |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "DEAL_MAGIC".                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
long CDealInfo::Magic() const
  {
   return(HistoryDealGetInteger(m_ticket,DEAL_MAGIC));
  }
//+------------------------------------------------------------------+
//| Get the property value "DEAL_POSITION_ID".                       |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "DEAL_POSITION_ID".                   |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
long CDealInfo::PositionId() const
  {
   return(HistoryDealGetInteger(m_ticket,DEAL_POSITION_ID));
  }
//+------------------------------------------------------------------+
//| Get the property value "DEAL_VOLUME".                            |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "DEAL_VOLUME".                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CDealInfo::Volume() const
  {
   return(HistoryDealGetDouble(m_ticket,DEAL_VOLUME));
  }
//+------------------------------------------------------------------+
//| Get the property value "DEAL_PRICE_OPEN".                        |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "DEAL_PRICE_OPEN".                    |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CDealInfo::Price() const
  {
   return(HistoryDealGetDouble(m_ticket,DEAL_PRICE));
  }
//+------------------------------------------------------------------+
//| Get the property value "DEAL_COMMISSION".                        |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "DEAL_COMMISSION".                    |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CDealInfo::Commission() const
  {
   return(HistoryDealGetDouble(m_ticket,DEAL_COMMISSION));
  }
//+------------------------------------------------------------------+
//| Get the property value "DEAL_SWAP".                              |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "DEAL_SWAP".                          |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CDealInfo::Swap() const
  {
   return(HistoryDealGetDouble(m_ticket,DEAL_SWAP));
  }
//+------------------------------------------------------------------+
//| Get the property value "DEAL_PROFIT".                            |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "DEAL_PROFIT".                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CDealInfo::Profit() const
  {
   return(HistoryDealGetDouble(m_ticket,DEAL_PROFIT));
  }
//+------------------------------------------------------------------+
//| Get the property value "DEAL_SYMBOL".                            |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "DEAL_SYMBOL".                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CDealInfo::Symbol() const
  {
   return(HistoryDealGetString(m_ticket,DEAL_SYMBOL));
  }
//+------------------------------------------------------------------+
//| Get the property value "DEAL_COMMENT".                           |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "DEAL_COMMENT".                       |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CDealInfo::Comment() const
  {
   return(HistoryDealGetString(m_ticket,DEAL_COMMENT));
  }
//+------------------------------------------------------------------+
//| Access functions HistoryDealGetInteger(...).                     |
//| INPUT:  prop_id  -identifier integer properties,                 |
//|         var     -reference to a variable to value.               |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CDealInfo::InfoInteger(ENUM_DEAL_PROPERTY_INTEGER prop_id,long& var) const
  {
   return(HistoryDealGetInteger(m_ticket,prop_id,var));
  }
//+------------------------------------------------------------------+
//| Access functions HistoryDealGetDouble(...).                      |
//| INPUT:  prop_id  -identifier double properties,                  |
//|         var     -reference to a variable to value.               |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CDealInfo::InfoDouble(ENUM_DEAL_PROPERTY_DOUBLE prop_id,double& var) const
  {
   return(HistoryDealGetDouble(m_ticket,prop_id,var));
  }
//+------------------------------------------------------------------+
//| Access functions HistoryDealGetString(...).                      |
//| INPUT:  prop_id  -identifier string properties,                  |
//|         var     -reference to a variable to value.               |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CDealInfo::InfoString(ENUM_DEAL_PROPERTY_STRING prop_id,string& var) const
  {
   return(HistoryDealGetString(m_ticket,prop_id,var));
  }
//+------------------------------------------------------------------+