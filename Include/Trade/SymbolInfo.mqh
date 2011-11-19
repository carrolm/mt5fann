//+------------------------------------------------------------------+
//|                                                   SymbolInfo.mqh |
//|                      Copyright © 2011, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//|                                              Revision 2011.06.08 |
//+------------------------------------------------------------------+
#include <Object.mqh>
//+------------------------------------------------------------------+
//| Class CSymbolInfo.                                               |
//| Appointment: Class for access to symbol info.                    |
//|              Derives from class CObject.                         |
//+------------------------------------------------------------------+
class CSymbolInfo : public CObject
  {
protected:
   string                      m_name;               // symbol name
   MqlTick                     m_tick;               // structure of tick;
   double                      m_point;              // symbol point
   double                      m_tick_value;         // symbol tick value
   double                      m_tick_value_profit;  // symbol tick value profit
   double                      m_tick_value_loss;    // symbol tick value loss
   double                      m_tick_size;          // symbol tick size
   double                      m_contract_size;      // symbol contract size
   double                      m_lots_min;           // symbol lots min
   double                      m_lots_max;           // symbol lots max
   double                      m_lots_step;          // symbol lots step
   double                      m_lots_limit;         // symbol lots limit
   double                      m_swap_long;          // symbol swap long
   double                      m_swap_short;         // symbol swap short
   int                         m_digits;             // symbol digits
   ENUM_SYMBOL_TRADE_EXECUTION m_trade_execution;    // symbol trade execution
   ENUM_SYMBOL_CALC_MODE       m_trade_calcmode;     // symbol trade calcmode
   ENUM_SYMBOL_TRADE_MODE      m_trade_mode;         // symbol trade mode
   ENUM_SYMBOL_SWAP_MODE       m_swap_mode;          // symbol swap mode
   ENUM_DAY_OF_WEEK            m_swap3;              // symbol swap3
   double                      m_margin_initial;     // symbol margin initial
   double                      m_margin_maintenance; // symbol margin maintenance
   double                      m_margin_long;        // symbol margin long position
   double                      m_margin_short;       // symbol margin short position
   double                      m_margin_limit;       // symbol margin limit order
   double                      m_margin_stop;        // symbol margin stop order
   double                      m_margin_stoplimit;   // symbol margin stoplimit order
   int                         m_trade_time_flags;   // symbol trade time flags
   int                         m_trade_fill_flags;   // symbol trade fill flags

public:
                     CSymbolInfo();
   //--- methods of access to protected data
   string            Name()                         const { return(m_name);               }
   bool              Name(string name);
   bool              Refresh();
   bool              RefreshRates();
   //--- fast access methods to the integer symbol propertyes
   bool              Select()                       const;
   bool              Select(bool select);
   bool              IsSynchronized()               const;
   //--- volumes
   ulong             Volume()                       const { return(m_tick.volume);        }
   ulong             VolumeHigh()                   const;
   ulong             VolumeLow()                    const;
   ulong             VolumeBid()                    const;
   ulong             VolumeAsk()                    const;
   //--- miscellaneous
   datetime          Time()                         const { return(m_tick.time);          }
   int               Spread()                       const;
   bool              SpreadFloat()                  const;
   int               TicksBookDepth()               const;
   //--- trade levels
   int               StopsLevel()                   const;
   int               FreezeLevel()                  const;
   //--- fast access methods to the double symbol propertyes
   //--- bid parameters
   double            Bid()                          const { return(m_tick.bid);           }
   double            BidHigh()                      const;
   double            BidLow()                       const;
   //--- ask parameters
   double            Ask()                          const { return(m_tick.ask);           }
   double            AskHigh()                      const;
   double            AskLow()                       const;
   //--- last parameters
   double            Last()                         const { return(m_tick.last);          }
   double            LastHigh()                     const;
   double            LastLow()                      const;
   //--- fast access methods to the mix symbol propertyes
   //--- terms of trade
   ENUM_SYMBOL_CALC_MODE TradeCalcMode()            const { return(m_trade_calcmode);     }
   string            TradeCalcModeDescription()     const;
   ENUM_SYMBOL_TRADE_MODE TradeMode()               const { return(m_trade_mode);         }
   string            TradeModeDescription()         const;
   //--- execution terms of trade
   ENUM_SYMBOL_TRADE_EXECUTION TradeExecution()     const { return(m_trade_execution);    }
   string            TradeExecutionDescription()    const;
   //--- swap terms of trade
   ENUM_SYMBOL_SWAP_MODE SwapMode()                 const { return(m_swap_mode);          }
   string            SwapModeDescription()          const;
   ENUM_DAY_OF_WEEK  SwapRollover3days()            const { return(m_swap3);              }
   string            SwapRollover3daysDescription() const;
   //--- margin parameters
   double            MarginInitial()                const { return(m_margin_initial);     }
   double            MarginMaintenance()            const { return(m_margin_maintenance); }
   double            MarginLong()                   const { return(m_margin_long);        }
   double            MarginShort()                  const { return(m_margin_short);       }
   double            MarginLimit()                  const { return(m_margin_limit);       }
   double            MarginStop()                   const { return(m_margin_stop);        }
   double            MarginStopLimit()              const { return(m_margin_stoplimit);   }
   //--- trade flags parameters
   int               TradeTimeFlags()               const { return(m_trade_time_flags);   }
   int               TradeFillFlags()               const { return(m_trade_fill_flags);   }
   //--- tick parameters
   int               Digits()                       const { return(m_digits);             }
   double            Point()                        const { return(m_point);              }
   double            TickValue()                    const { return(m_tick_value);         }
   double            TickValueProfit()              const { return(m_tick_value_profit);  }
   double            TickValueLoss()                const { return(m_tick_value_loss);    }
   double            TickSize()                     const { return(m_tick_size);          }
   //--- lots parameters
   double            ContractSize()                 const { return(m_contract_size);      }
   double            LotsMin()                      const { return(m_lots_min);           }
   double            LotsMax()                      const { return(m_lots_max);           }
   double            LotsStep()                     const { return(m_lots_step);          }
   double            LotsLimit()                    const { return(m_lots_limit);         }
   //--- swaps
   double            SwapLong()                     const { return(m_swap_long);          }
   double            SwapShort()                    const { return(m_swap_short);         }
   //--- fast access methods to the string symbol propertyes
   string            CurrencyBase()                 const;
   string            CurrencyProfit()               const;
   string            CurrencyMargin()               const;
   string            Bank()                         const;
   string            Description()                  const;
   string            Path()                         const;
   //--- access methods to the API MQL5 functions
   bool              InfoInteger(ENUM_SYMBOL_INFO_INTEGER prop_id,long& var) const;
   bool              InfoDouble(ENUM_SYMBOL_INFO_DOUBLE prop_id,double& var) const;
   bool              InfoString(ENUM_SYMBOL_INFO_STRING prop_id,string& var) const;
   //--- service methods
   double            NormalizePrice(double price)   const;
   bool              CheckMarketWatch();
  };
//+------------------------------------------------------------------+
//| Constructor CSymbolInfo.                                         |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CSymbolInfo::CSymbolInfo()
  {
   m_name              ="";
   m_point             =0.0;
   m_tick_value        =0.0;
   m_tick_value_profit =0.0;
   m_tick_value_loss   =0.0;
   m_tick_size         =0.0;
   m_contract_size     =0.0;
   m_lots_min          =0.0;
   m_lots_max          =0.0;
   m_lots_step         =0.0;
   m_swap_long         =0.0;
   m_swap_short        =0.0;
   m_digits            =0;
   m_trade_execution   =0;
   m_trade_calcmode    =0;
   m_trade_mode        =0;
   m_swap_mode         =0;
   m_swap3             =0;
   m_margin_initial    =0.0;
   m_margin_maintenance=0.0;
   m_margin_long       =0.0;
   m_margin_short      =0.0;
   m_margin_limit      =0.0;
   m_margin_stop       =0.0;
   m_margin_stoplimit  =0.0;
   m_trade_time_flags  =0;
   m_trade_fill_flags  =0;
  }
//+------------------------------------------------------------------+
//| Set name                                                         |
//| INPUT:  no.                                                      |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CSymbolInfo::Name(string name)
  {
   m_name=name;
//---
   if(!CheckMarketWatch()) return(false);
//---
   if(!Refresh())
     {
      m_name="";
      Print(__FUNCTION__+": invalid data of symbol '"+name+"'");
      return(false);
     }
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| Refresh cached data                                              |
//| INPUT:  no.                                                      |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CSymbolInfo::Refresh()
  {
   long tmp=0;
//---
   if(!SymbolInfoDouble(m_name,SYMBOL_POINT,m_point))                               return(false);
   if(!SymbolInfoDouble(m_name,SYMBOL_TRADE_TICK_VALUE,m_tick_value))               return(false);
   if(!SymbolInfoDouble(m_name,SYMBOL_TRADE_TICK_VALUE_PROFIT,m_tick_value_profit)) return(false);
   if(!SymbolInfoDouble(m_name,SYMBOL_TRADE_TICK_VALUE_LOSS,m_tick_value_loss))     return(false);
   if(!SymbolInfoDouble(m_name,SYMBOL_TRADE_TICK_SIZE,m_tick_size))                 return(false);
   if(!SymbolInfoDouble(m_name,SYMBOL_TRADE_CONTRACT_SIZE,m_contract_size))         return(false);
   if(!SymbolInfoDouble(m_name,SYMBOL_VOLUME_MIN,m_lots_min))                       return(false);
   if(!SymbolInfoDouble(m_name,SYMBOL_VOLUME_MAX,m_lots_max))                       return(false);
   if(!SymbolInfoDouble(m_name,SYMBOL_VOLUME_STEP,m_lots_step))                     return(false);
   if(!SymbolInfoDouble(m_name,SYMBOL_VOLUME_LIMIT,m_lots_limit))                   return(false);
   if(!SymbolInfoDouble(m_name,SYMBOL_SWAP_LONG,m_swap_long))                       return(false);
   if(!SymbolInfoDouble(m_name,SYMBOL_SWAP_SHORT,m_swap_short))                     return(false);
   if(!SymbolInfoInteger(m_name,SYMBOL_DIGITS,tmp))                                 return(false);
   m_digits=(int)tmp;
   if(!SymbolInfoInteger(m_name,SYMBOL_TRADE_EXEMODE,tmp))                          return(false);
   m_trade_execution=(ENUM_SYMBOL_TRADE_EXECUTION)tmp;
   if(!SymbolInfoInteger(m_name,SYMBOL_TRADE_CALC_MODE,tmp))                        return(false);
   m_trade_calcmode=(ENUM_SYMBOL_CALC_MODE)tmp;
   if(!SymbolInfoInteger(m_name,SYMBOL_TRADE_MODE,tmp))                             return(false);
   m_trade_mode=(ENUM_SYMBOL_TRADE_MODE)tmp;
   if(!SymbolInfoInteger(m_name,SYMBOL_SWAP_MODE,tmp))                              return(false);
   m_swap_mode=(ENUM_SYMBOL_SWAP_MODE)tmp;
   if(!SymbolInfoInteger(m_name,SYMBOL_SWAP_ROLLOVER3DAYS,tmp))                     return(false);
   m_swap3=(ENUM_DAY_OF_WEEK)tmp;
   if(!SymbolInfoDouble(m_name,SYMBOL_MARGIN_INITIAL,m_margin_initial))             return(false);
   if(!SymbolInfoDouble(m_name,SYMBOL_MARGIN_MAINTENANCE,m_margin_maintenance))     return(false);
   if(!SymbolInfoDouble(m_name,SYMBOL_MARGIN_LONG,m_margin_long))                   return(false);
   if(!SymbolInfoDouble(m_name,SYMBOL_MARGIN_SHORT,m_margin_short))                 return(false);
   if(!SymbolInfoDouble(m_name,SYMBOL_MARGIN_LIMIT,m_margin_limit))                 return(false);
   if(!SymbolInfoDouble(m_name,SYMBOL_MARGIN_STOP,m_margin_stop))                   return(false);
   if(!SymbolInfoDouble(m_name,SYMBOL_MARGIN_STOPLIMIT,m_margin_stoplimit))         return(false);
   if(!SymbolInfoInteger(m_name,SYMBOL_EXPIRATION_MODE,tmp))                        return(false);
   m_trade_time_flags=(int)tmp;
   if(!SymbolInfoInteger(m_name,SYMBOL_FILLING_MODE,tmp))                           return(false);
   m_trade_fill_flags=(int)tmp;
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| Refresh cached data                                              |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CSymbolInfo::RefreshRates()
  {
   return(SymbolInfoTick(m_name,m_tick));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_SELECT".                          |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "SYMBOL_SELECT".                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CSymbolInfo::Select() const
  {
   return((bool)SymbolInfoInteger(m_name,SYMBOL_SELECT));
  }
//+------------------------------------------------------------------+
//| Set the property value "SYMBOL_SELECT".                          |
//| INPUT:  select -flag for select MarketWatch.                     |
//| OUTPUT: true is OK.                                              |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CSymbolInfo::Select(bool select)
  {
   return(SymbolSelect(m_name,select));
  }
//+------------------------------------------------------------------+
//| Check synchronize symbol.                                        |
//| INPUT:  no.                                                      |
//| OUTPUT: true is symbol synchronized.                             |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CSymbolInfo::IsSynchronized() const
  {
   return(SymbolIsSynchronized(m_name));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_VOLUMEHIGH".                      |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "SYMBOL_VOLUMEHIGH".                  |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
ulong CSymbolInfo::VolumeHigh() const
  {
   return(SymbolInfoInteger(m_name,SYMBOL_VOLUMEHIGH));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_VOLUMELOW".                       |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "SYMBOL_VOLUMELOW".                   |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
ulong CSymbolInfo::VolumeLow() const
  {
   return(SymbolInfoInteger(m_name,SYMBOL_VOLUMELOW));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_VOLUMEBID".                       |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "SYMBOL_VOLUMEBID".                   |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
ulong CSymbolInfo::VolumeBid() const
  {
   return(SymbolInfoInteger(m_name,SYMBOL_VOLUMEBID));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_VOLUMEASK".                       |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "SYMBOL_VOLUMEASK".                   |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
ulong CSymbolInfo::VolumeAsk() const
  {
   return(SymbolInfoInteger(m_name,SYMBOL_VOLUMEASK));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_SPREAD".                          |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "SYMBOL_SPREAD".                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CSymbolInfo::Spread() const
  {
   return((int)SymbolInfoInteger(m_name,SYMBOL_SPREAD));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_SPREAD_FLOAT".                    |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "SYMBOL_SPREAD_FLOAT".                |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CSymbolInfo::SpreadFloat() const
  {
   return((bool)SymbolInfoInteger(m_name,SYMBOL_SPREAD_FLOAT));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_TICKS_BOOKDEPTH".                 |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "SYMBOL_TICKS_BOOKDEPTH".             |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CSymbolInfo::TicksBookDepth() const
  {
   return((int)SymbolInfoInteger(m_name,SYMBOL_TICKS_BOOKDEPTH));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_TRADE_STOPS_LEVEL".               |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "SYMBOL_TRADE_STOPS_LEVEL".           |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CSymbolInfo::StopsLevel() const
  {
   return((int)SymbolInfoInteger(m_name,SYMBOL_TRADE_STOPS_LEVEL));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_TRADE_FREEZE_LEVEL".              |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "SYMBOL_TRADE_FREEZE_LEVEL".          |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CSymbolInfo::FreezeLevel() const
  {
   return((int)SymbolInfoInteger(m_name,SYMBOL_TRADE_FREEZE_LEVEL));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_BIDHIGH".                         |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "SYMBOL_BIDHIGH".                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CSymbolInfo::BidHigh() const
  {
   return(SymbolInfoDouble(m_name,SYMBOL_BIDHIGH));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_BIDLOW".                          |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "SYMBOL_BIDLOW".                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CSymbolInfo::BidLow() const
  {
   return(SymbolInfoDouble(m_name,SYMBOL_BIDLOW));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_ASKHIGH".                         |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "SYMBOL_ASKHIGH".                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CSymbolInfo::AskHigh() const
  {
   return(SymbolInfoDouble(m_name,SYMBOL_ASKHIGH));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_ASKLOW".                          |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "SYMBOL_ASKLOW".                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CSymbolInfo::AskLow() const
  {
   return(SymbolInfoDouble(m_name,SYMBOL_ASKLOW));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_LASTHIGH".                        |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "SYMBOL_LASTHIGH".                    |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CSymbolInfo::LastHigh() const
  {
   return(SymbolInfoDouble(m_name,SYMBOL_LASTHIGH));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_LASTLOW".                         |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "SYMBOL_LASTLOW".                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CSymbolInfo::LastLow() const
  {
   return(SymbolInfoDouble(m_name,SYMBOL_LASTLOW));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_TRADE_CALC_MODE" as string.       |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "SYMBOL_TRADE_CALC_MODE" as string.   |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CSymbolInfo::TradeCalcModeDescription() const
  {
   string str;
//---
   switch(m_trade_calcmode)
     {
      case SYMBOL_CALC_MODE_FOREX:
         str="Calculation of profit and margin for Forex";
         break;
      case SYMBOL_CALC_MODE_CFD:
         str="Calculation of collateral and earnings for CFD";
         break;
      case SYMBOL_CALC_MODE_FUTURES:
         str="Calculation of collateral and profits for futures";
         break;
      case SYMBOL_CALC_MODE_CFDINDEX:
         str="Calculation of collateral and earnings for CFD on indices";
         break;
      case SYMBOL_CALC_MODE_CFDLEVERAGE:
         str="Calculation of collateral and earnings for the CFD when trading with leverage";
         break;
      case SYMBOL_CALC_MODE_EXCH_STOCKS:
         str="Calculation for exchange stocks";
         break;
      case SYMBOL_CALC_MODE_EXCH_FUTURES:
         str="Calculation for exchange futures";
         break;
      case SYMBOL_CALC_MODE_EXCH_OPTIONS:
         str="Calculation for exchange options";
         break;
      default:
         str="Unknown calculation mode";
     }
//--- result
   return(str);
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_TRADE_MODE" as string.            |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "SYMBOL_TRADE_MODE" as string.        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CSymbolInfo::TradeModeDescription() const
  {
   string str;
//---
   switch(m_trade_mode)
     {
      case SYMBOL_TRADE_MODE_DISABLED:
         str="Disabled";
         break;
      case SYMBOL_TRADE_MODE_LONGONLY:
         str="Long only";
         break;
      case SYMBOL_TRADE_MODE_SHORTONLY:
         str="Short only";
         break;
      case SYMBOL_TRADE_MODE_CLOSEONLY:
         str="Close only";
         break;
      case SYMBOL_TRADE_MODE_FULL:
         str="Full access";
         break;
      default:
         str="Unknown trade mode";
     }
//--- result
   return(str);
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_TRADE_EXEMODE" as string.         |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "SYMBOL_TRADE_EXEMODE" as string.     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CSymbolInfo::TradeExecutionDescription() const
  {
   string str;
//---
   switch(m_trade_execution)
     {
      case SYMBOL_TRADE_EXECUTION_REQUEST:
         str="Trading on request";
         break;
      case SYMBOL_TRADE_EXECUTION_INSTANT:
         str="Trading on live streaming prices";
         break;
      case SYMBOL_TRADE_EXECUTION_MARKET:
         str="Execution of orders on the market";
         break;
      case SYMBOL_TRADE_EXECUTION_EXCHANGE:
         str="Exchange execution";
         break;
      default:
         str="Unknown trade execution";
     }
//--- result
   return(str);
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_SWAP_MODE" as string.             |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "SYMBOL_SWAP_MODE" as string.         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CSymbolInfo::SwapModeDescription() const
  {
   string str;
//---
   switch(m_swap_mode)
     {
      case SYMBOL_SWAP_MODE_DISABLED:
         str="No swaps";
         break;
      case SYMBOL_SWAP_MODE_BY_POINTS:
         str="Swaps are calculated in points";
         break;
      case SYMBOL_SWAP_MODE_BY_MONEY:
         str="Swaps are calculated in of deposit currency";
         break;
      case SYMBOL_SWAP_MODE_BY_INTEREST:
         str="Swaps are calculated at an annual percentage";
         break;
      case SYMBOL_SWAP_MODE_BY_MARGIN_CURRENCY:
         str="Swaps are calculated in  of margin currency";
         break;
      default:
         str="Unknown swap mode";
     }
//--- result
   return(str);
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_SWAP_ROLLOVER3DAYS" as string.    |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "SYMBOL_SWAP_ROLLOVER3DAYS" as string.|
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CSymbolInfo::SwapRollover3daysDescription() const
  {
   string str;
//---
   switch(m_swap3)
     {
      case SUNDAY:
         str="Sunday";
         break;
      case MONDAY:
         str="Monday";
         break;
      case TUESDAY:
         str="Tuesday";
         break;
      case WEDNESDAY:
         str="Wednesday";
         break;
      case THURSDAY:
         str="Thursday";
         break;
      case FRIDAY:
         str="Friday";
         break;
      case SATURDAY:
         str="Saturday";
         break;
      default:
         str="Unknown";
     }
//--- result
   return(str);
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_CURRENCY_BASE".                   |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "SYMBOL_CURRENCY_BASE".               |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CSymbolInfo::CurrencyBase() const
  {
   return(SymbolInfoString(m_name,SYMBOL_CURRENCY_BASE));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_CURRENCY_PROFIT".                 |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "SYMBOL_CURRENCY_PROFIT".             |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CSymbolInfo::CurrencyProfit() const
  {
   return(SymbolInfoString(m_name,SYMBOL_CURRENCY_PROFIT));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_CURRENCY_MARGIN".                 |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "SYMBOL_CURRENCY_MARGIN".             |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CSymbolInfo::CurrencyMargin() const
  {
   return(SymbolInfoString(m_name,SYMBOL_CURRENCY_MARGIN));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_BANK".                            |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "SYMBOL_BANK".                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CSymbolInfo::Bank() const
  {
   return(SymbolInfoString(m_name,SYMBOL_BANK));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_DESCRIPTION".                     |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "SYMBOL_DESCRIPTION".                 |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CSymbolInfo::Description() const
  {
   return(SymbolInfoString(m_name,SYMBOL_DESCRIPTION));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_PATH".                            |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "SYMBOL_PATH".                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CSymbolInfo::Path() const
  {
   return(SymbolInfoString(m_name,SYMBOL_PATH));
  }
//+------------------------------------------------------------------+
//| Access functions SymbolInfoInteger(...).                         |
//| INPUT:  prop_id -identifier integer properties,                  |
//|         var     -reference to a variable to value.               |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CSymbolInfo::InfoInteger(ENUM_SYMBOL_INFO_INTEGER prop_id,long& var) const
  {
   return(SymbolInfoInteger(m_name,prop_id,var));
  }
//+------------------------------------------------------------------+
//| Access functions SymbolInfoDouble(...).                          |
//| INPUT:  prop_id -identifier double properties,                   |
//|         var     -reference to a variable to value.               |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CSymbolInfo::InfoDouble(ENUM_SYMBOL_INFO_DOUBLE prop_id,double& var) const
  {
   return(SymbolInfoDouble(m_name,prop_id,var));
  }
//+------------------------------------------------------------------+
//| Access functions SymbolInfoString(...).                          |
//| INPUT:  prop_id -identifier string properties,                   |
//|         var     -reference to a variable to value.               |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CSymbolInfo::InfoString(ENUM_SYMBOL_INFO_STRING prop_id,string& var) const
  {
   return(SymbolInfoString(m_name,prop_id,var));
  }
//+------------------------------------------------------------------+
//| Normalize price.                                                 |
//| INPUT:  price -price for normalizing.                            |
//| OUTPUT: normalized price.                                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CSymbolInfo::NormalizePrice(double price) const
  {
   if(m_tick_size!=0)
      return(NormalizeDouble(MathRound(price/m_tick_size)*m_tick_size,m_digits));
   else
      return(NormalizeDouble(price,m_digits));
  }
//+------------------------------------------------------------------+
//| Checks if symbol is selected in the MarketWatch                  |
//| and adds symbol to the MarketWatch, if necessary.                |
//| INPUT:  no.                                                      |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: Symbol in MarketWatch is required for access.            |
//+------------------------------------------------------------------+
bool CSymbolInfo::CheckMarketWatch()
  {
//--- check if symbol is selected in the MarketWatch
   if(!Select())
     {
      if(GetLastError()==ERR_MARKET_UNKNOWN_SYMBOL)
        {
         printf(__FUNCTION__+": Unknown symbol '%s'",m_name);
         return(false);
        }
      if(!Select(true))
        {
         printf(__FUNCTION__+": Error adding symbol %d",GetLastError());
         return(false);
        }
     }
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
