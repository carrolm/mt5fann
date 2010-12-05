//+------------------------------------------------------------------+
//|                                                    SignalITF.mqh |
//|                      Copyright © 2010, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//|                                              Revision 2010.11.15 |
//+------------------------------------------------------------------+
#include <Expert\ExpertSignal.mqh>
//+------------------------------------------------------------------+
//| Class CSignalITF.                                                |
//| Appointment: Class trading signals time filter.                  |
//|              Derives from class CExpertSignal.                   |
//+------------------------------------------------------------------+
class CSignalITF : public CExpertSignal
  {
protected:
   //--- input parameters
   int               m_good_minute_of_hour;
   long              m_bad_minutes_of_hour;
   int               m_good_hour_of_day;
   int               m_bad_hours_of_day;
   int               m_good_day_of_week;
   int               m_bad_days_of_week;

public:
                     CSignalITF();
   //--- methods initialize protected data
   void              GoodMinuteOfHour(int good_minute_of_hour)  { m_good_minute_of_hour=good_minute_of_hour; }
   void              BadMinutesOfHour(long bad_minutes_of_hour) { m_bad_minutes_of_hour=bad_minutes_of_hour; }
   void              GoodHourOfDay(int good_hour_of_day)        { m_good_hour_of_day=good_hour_of_day;       }
   void              BadHoursOfDay(int bad_hours_of_day)        { m_bad_hours_of_day=bad_hours_of_day;       }
   void              GoodDayOfWeek(int good_day_of_week)        { m_good_day_of_week=good_day_of_week;       }
   void              BadDaysOfWeek(int bad_days_of_week)        { m_bad_days_of_week=bad_days_of_week;       }
   //---
   virtual bool      CheckOpenLong(double& price,double& sl,double& tp,datetime& expiration);
   virtual bool      CheckOpenShort(double& price,double& sl,double& tp,datetime& expiration);

protected:
   bool              CheckTimeFilter(datetime& time);
  };
//+------------------------------------------------------------------+
//| Constructor CSignalITF.                                          |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CSignalITF::CSignalITF()
  {
//--- set default inputs
   m_good_minute_of_hour=-1;
   m_bad_minutes_of_hour=0;
   m_good_hour_of_day   =-1;
   m_bad_hours_of_day   =0;
   m_good_day_of_week   =-1;
   m_bad_days_of_week   =0;
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
bool CSignalITF::CheckOpenLong(double& price,double& sl,double& tp,datetime& expiration)
  {
   return(CheckTimeFilter(expiration));
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
bool CSignalITF::CheckOpenShort(double& price,double& sl,double& tp,datetime& expiration)
  {
   return(CheckTimeFilter(expiration));
  }
//+------------------------------------------------------------------+
//| Check conditions for time filter.                                |
//| INPUT:  time - refernce for current time.                        |
//| OUTPUT: true-if condition performed, false otherwise.            |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CSignalITF::CheckTimeFilter(datetime& time)
  {
   MqlDateTime s_time;
//---
   TimeToStruct(time,s_time);
//--- check days conditions
   if(!((m_good_day_of_week==-1 || m_good_day_of_week==s_time.day_of_week) &&
       !(m_bad_days_of_week&(1<<s_time.day_of_week))))
      return(false);
//--- check hours conditions
   if(!((m_good_hour_of_day==-1 || m_good_hour_of_day==s_time.hour) &&
       !(m_bad_hours_of_day&(1<<s_time.hour))))
      return(false);
//--- check minutes conditions
   if(!((m_good_minute_of_hour==-1 || m_good_minute_of_hour==s_time.min) &&
       !(m_bad_minutes_of_hour&(1<<s_time.min))))
      return(false);
//--- condition OK
   return(true);
  }
//+------------------------------------------------------------------+
