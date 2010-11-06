//+------------------------------------------------------------------+
//|                                                    MoneyNone.mqh |
//|                      Copyright © 2010, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//|                                              Revision 2010.10.08 |
//+------------------------------------------------------------------+
#include <Expert\ExpertMoney.mqh>
// wizard description start
//+------------------------------------------------------------------+
//| Description of the class                                         |
//| Title=Trading minimum lot                                        |
//| Type=Money                                                       |
//| Name=MinLot                                                      |
//| Class=CMoneyNone                                                 |
//| Page=                                                            |
//+------------------------------------------------------------------+
// wizard description end
//+------------------------------------------------------------------+
//| Class CMoneyNone.                                                |
//| Appointment: Class no money managment.                           |
//|              Derives from class CExpertMoney.                    |
//+------------------------------------------------------------------+
class CMoneyNone : public CExpertMoney
  {
public:
   virtual bool      ValidationSettings() { Percent(100.0); return(true); }
   //---
   virtual double    CheckOpenLong(double price,double sl);
   virtual double    CheckOpenShort(double price,double sl);
  };
//+------------------------------------------------------------------+
//| Getting lot size for open long position.                         |
//| INPUT:  no.                                                      |
//| OUTPUT: minimum lot.                                             |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CMoneyNone::CheckOpenLong(double price,double sl)
  {
   return(m_symbol.LotsMin());
  }
//+------------------------------------------------------------------+
//| Getting lot size for open short position.                        |
//| INPUT:  no.                                                      |
//| OUTPUT: minimum lot.                                             |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CMoneyNone::CheckOpenShort(double price,double sl)
  {
   return(m_symbol.LotsMin());
  }
//+------------------------------------------------------------------+
