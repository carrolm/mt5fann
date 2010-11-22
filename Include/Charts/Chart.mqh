//+------------------------------------------------------------------+
//|                                                     Chart.mqh    |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//|                                              Revision 2010.02.22 |
//+------------------------------------------------------------------+
#include <Object.mqh>
//+------------------------------------------------------------------+
//| Class CChart.                                                    |
//| Purpose: Class of the "Chart" object.                            |
//|          Derives from class CObject.                             |
//+------------------------------------------------------------------+
class CChart : public CObject
  {
protected:
   long              m_chart_id;           // chart identifier
public:
                     CChart();
                    ~CChart();
   //--- methods of access to protected data
   long              ChartId() const       { return(m_chart_id); }
   //--- method of identifying the object
   virtual int       Type() const          { return(0x1111);     }
   //--- methods of access to properties of the chart
   //--- common properties
   ENUM_CHART_MODE   Mode() const;
   bool              Mode(ENUM_CHART_MODE mode);
   bool              Foreground() const;
   bool              Foreground(bool foreground);
   bool              Shift() const;
   bool              Shift(bool shift);
   double            ShiftSize() const;
   bool              ShiftSize(double shift);
   bool              AutoScroll() const;
   bool              AutoScroll(bool auto_scroll);
   int               Scale() const;
   bool              Scale(int scale);
   bool              ScaleFix() const;
   bool              ScaleFix(bool scale_fix);
   bool              ScaleFix_11() const;
   bool              ScaleFix_11(bool scale_fix_11);
   double            FixedMax() const;
   bool              FixedMax(double fixed_max);
   double            FixedMin() const;
   bool              FixedMin(double fixed_min);
   bool              ScalePPB() const;
   bool              ScalePPB(bool scale_ppb);
   double            PointsPerBar() const;
   bool              PointsPerBar(double points_per_bar);
   //--- show properties
   bool              ShowOHLC() const;
   bool              ShowOHLC(bool show);
   bool              ShowLineBid() const;
   bool              ShowLineBid(bool show);
   bool              ShowLineAsk() const;
   bool              ShowLineAsk(bool show);
   bool              ShowLastLine() const;
   bool              ShowLastLine(bool show);
   bool              ShowPeriodSep() const;
   bool              ShowPeriodSep(bool show);
   bool              ShowGrid() const;
   bool              ShowGrid(bool show);
   ENUM_CHART_VOLUME_MODE ShowVolumes() const;
   bool                   ShowVolumes(ENUM_CHART_VOLUME_MODE show);
   bool              ShowObjectDescr() const;
   bool              ShowObjectDescr(bool show);
   //--- color properties
   color             ColorBackground() const;
   bool              ColorBackground(color new_color);
   color             ColorForeground() const;
   bool              ColorForeground(color new_color);
   color             ColorGrid() const;
   bool              ColorGrid(color new_color);
   color             ColorBarUp() const;
   bool              ColorBarUp(color new_color);
   color             ColorBarDown() const;
   bool              ColorBarDown(color new_color);
   color             ColorCandleBull() const;
   bool              ColorCandleBull(color new_color);
   color             ColorCandleBear() const;
   bool              ColorCandleBear(color new_color);
   color             ColorChartLine() const;
   bool              ColorChartLine(color new_color);
   color             ColorVolumes() const;
   bool              ColorVolumes(color new_color);
   color             ColorLineBid() const;
   bool              ColorLineBid(color new_color);
   color             ColorLineAsk() const;
   bool              ColorLineAsk(color new_color);
   color             ColorLineLast() const;
   bool              ColorLineLast(color new_color);
   color             ColorStopLevels() const;
   bool              ColorStopLevels(color new_color);
   //--- methods of access to READ ONLY properties of the chart
   int               VisibleBars() const;
   int               WindowsTotal() const;
   bool              WindowIsVisible(int num) const;
   int               WindowHandle() const;
   int               FirstVisibleBar() const;
   int               WidthInBars() const;
   int               WidthInPixels() const;
   int               HeightInPixels(int num) const;
   double            PriceMin(int num) const;
   double            PriceMax(int num) const;
   //--- methods of binding chart
   void              Attach()             { m_chart_id=ChartID();             }
   void              Attach(long chart)   { m_chart_id=chart;                 }
   void              FirstChart()         { m_chart_id=ChartFirst();          }
   void              NextChart()          { m_chart_id=ChartNext(m_chart_id); }
   long              Open(const string symbol_name,ENUM_TIMEFRAMES timeframe);
   void              Detach()             { m_chart_id=-1;                    }
   void              Close();
   //--- navigation method
   bool              Navigate(ENUM_CHART_POSITION position,int shift=0);
   //--- methods of access to the API functions of MQL5
   string            Symbol() const       { return(ChartSymbol(m_chart_id));  }
   ENUM_TIMEFRAMES   Period() const       { return(ChartPeriod(m_chart_id));  }
   void              Redraw()             { ChartRedraw(m_chart_id);          }
   long              GetInteger(ENUM_CHART_PROPERTY_INTEGER prop_id,int sub_window=0) const;
   bool              GetInteger(ENUM_CHART_PROPERTY_INTEGER prop_id,int sub_window,long& value) const;
   bool              SetInteger(ENUM_CHART_PROPERTY_INTEGER prop_id,long value);
   double            GetDouble(ENUM_CHART_PROPERTY_DOUBLE prop_id,int sub_window=0) const;
   bool              GetDouble(ENUM_CHART_PROPERTY_DOUBLE prop_id,int sub_window,double& value) const;
   bool              SetDouble(ENUM_CHART_PROPERTY_DOUBLE prop_id,double value);
   string            GetString(ENUM_CHART_PROPERTY_STRING prop_id) const;
   bool              GetString(ENUM_CHART_PROPERTY_STRING prop_id,string& value) const;
   bool              SetString(ENUM_CHART_PROPERTY_STRING prop_id,const string value);
   bool              SetSymbolPeriod(const string symbol,ENUM_TIMEFRAMES period);
   bool              ApplyTemplate(const string filename);
   bool              ScreenShot(const string filename, int width, int height, ENUM_ALIGN_MODE align_mode=ALIGN_RIGHT) const;
   int               WindowOnDropped() const;
   double            PriceOnDropped() const;
   datetime          TimeOnDropped() const;
   int               XOnDropped() const;
   int               YOnDropped() const;
   //--- methods for working with files
   virtual bool      Save(int file_handle);
   virtual bool      Load(int file_handle);
  };
//+------------------------------------------------------------------+
//| Constructor CChart.                                              |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CChart::CChart()
  {
//--- initialize protected data
   m_chart_id=-1;
  }
//+------------------------------------------------------------------+
//| Destructor CChart.                                               |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CChart::~CChart()
  {
   if(m_chart_id!=-1) Close();
  }
//+------------------------------------------------------------------+
//| Opening chart.                                                   |
//| INPUT:  symbol_name  - chart symbol,                             |
//|         timeframe    - chart period.                             |
//| OUTPUT: ID of chart in case of successful opening, otherwise - 0.|
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
long CChart::Open(const string symbol_name,ENUM_TIMEFRAMES timeframe)
  {
   return(m_chart_id=ChartOpen(symbol_name,timeframe));
  }
//+------------------------------------------------------------------+
//| Get the type of representation of chart.                         |
//| INPUT:  no.                                                      |
//| OUTPUT: type of representation of chart (bar, line , etc.).      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
ENUM_CHART_MODE CChart::Mode() const
  {
//--- checking
   if(m_chart_id<=0) return(WRONG_VALUE);
//---
   return((ENUM_CHART_MODE)ChartGetInteger(m_chart_id,CHART_MODE));
  }
//+------------------------------------------------------------------+
//| Set the type of representation chart.                            |
//| INPUT:  mode - new type of representation.                       |
//| OUTPUT: true- if successful, false if not.                       |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::Mode(ENUM_CHART_MODE mode)
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartSetInteger(m_chart_id,CHART_MODE,mode));
  }
//+------------------------------------------------------------------+
//| Get value of the "Foreground" property.                          |
//| INPUT:  no.                                                      |
//| OUTPUT: value of the "Foreground" property.                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::Foreground() const
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartGetInteger(m_chart_id,CHART_FOREGROUND));
  }
//+------------------------------------------------------------------+
//| Set value of the "Foreground" property.                          |
//| INPUT:  foreground - new value of the "Foreground" property.     |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::Foreground(bool foreground)
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartSetInteger(m_chart_id,CHART_FOREGROUND,foreground));
  }
//+------------------------------------------------------------------+
//| Get value of the "Shift" property.                               |
//| INPUT:  no.                                                      |
//| OUTPUT: value of the "Shift" property.                           |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::Shift() const
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartGetInteger(m_chart_id,CHART_SHIFT));
  }
//+------------------------------------------------------------------+
//| Set value of the "Shift"property.                                |
//| INPUT:  shift - new value of the "Shift" property.               |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::Shift(bool shift)
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartSetInteger(m_chart_id,CHART_SHIFT,shift));
  }
//+------------------------------------------------------------------+
//| Get value of the "ShiftSize" property.                           |
//| INPUT:  no.                                                      |
//| OUTPUT: value of the "ShiftSize" property.                       |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CChart::ShiftSize() const
  {
//--- checking
   if(m_chart_id<=0) return(DBL_MAX);
//---
   return(ChartGetDouble(m_chart_id,CHART_SHIFT_SIZE));
  }
//+------------------------------------------------------------------+
//| Set value of the "ShiftSize" property.                           |
//| INPUT:  shift - new value of the "ShiftSize" property.           |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::ShiftSize(double shift)
  {
//--- checking
   if(m_chart_id<=0) return(false);
   if(shift<10) shift=10;
   if(shift>50) shift=50;
//---
   return(ChartSetDouble(m_chart_id,CHART_SHIFT_SIZE,shift));
  }
//+------------------------------------------------------------------+
//| Get value of the "AutoScroll" property.                          |
//| INPUT:  no.                                                      |
//| OUTPUT: value of the "AutoScroll" property.                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::AutoScroll() const
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartGetInteger(m_chart_id,CHART_AUTOSCROLL));
  }
//+------------------------------------------------------------------+
//| Set value of the "AutoScroll" property.                          |
//| INPUT:  auto_scroll - new value of the "AutoScroll" property.    |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::AutoScroll(bool auto_scroll)
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartSetInteger(m_chart_id,CHART_AUTOSCROLL,auto_scroll));
  }
//+------------------------------------------------------------------+
//| Get value of the "Scale" property.                               |
//| INPUT:  no.                                                      |
//| OUTPUT: value of the "Scale" property.                           |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CChart::Scale() const
  {
//--- checking
   if(m_chart_id<=0) return(0);
//---
   return((int)ChartGetInteger(m_chart_id,CHART_SCALE));
  }
//+------------------------------------------------------------------+
//| Set value of the "Scale" property.                               |
//| INPUT:  shift - new value of the "Scale" property.               |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::Scale(int shift)
  {
//--- checking
   if(m_chart_id<=0) return(false);
   if(shift<0)  shift=0;
   if(shift>32) shift=32;
//---
   return(ChartSetInteger(m_chart_id,CHART_SCALE,shift));
  }
//+------------------------------------------------------------------+
//| Get value of the "ScaleFix" property.                            |
//| INPUT:  no.                                                      |
//| OUTPUT: value of the "ScaleFix" property.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::ScaleFix() const
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartGetInteger(m_chart_id,CHART_SCALEFIX));
  }
//+------------------------------------------------------------------+
//| Set value of the "ScaleFix" property.                            |
//| INPUT:  scale_fix - new value of the "ScaleFix" property.        |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::ScaleFix(bool scale_fix)
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartSetInteger(m_chart_id,CHART_SCALEFIX,scale_fix));
  }
//+------------------------------------------------------------------+
//| Get value of the "ScaleFix_11" property.                         |
//| INPUT:  no.                                                      |
//| OUTPUT: value of the "ScaleFix_11" property.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::ScaleFix_11() const
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartGetInteger(m_chart_id,CHART_SCALEFIX_11));
  }
//+------------------------------------------------------------------+
//| Set value of the "ScaleFix_11" property.                         |
//| INPUT:  scale_fix_11 - new value of the "ScaleFix_11" property.  |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::ScaleFix_11(bool scale_fix_11)
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartSetInteger(m_chart_id,CHART_SCALEFIX_11,scale_fix_11));
  }
//+------------------------------------------------------------------+
//| Get value of the "FixedMax" property.                            |
//| INPUT:  no.                                                      |
//| OUTPUT: value of the "FixedMax" property.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CChart::FixedMax() const
  {
//--- checking
   if(m_chart_id<=0) return(EMPTY_VALUE);
//---
   return(ChartGetDouble(m_chart_id,CHART_FIXED_MAX));
  }
//+------------------------------------------------------------------+
//| Set value of the "FixedMax" property.                            |
//| INPUT:  fixed_max - new value of the "FixedMax" property.        |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::FixedMax(double fixed_max)
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartSetDouble(m_chart_id,CHART_FIXED_MAX,fixed_max));
  }
//+------------------------------------------------------------------+
//| Get value of the "FixedMin" property.                            |
//| INPUT:  no.                                                      |
//| OUTPUT: value of the "FixedMin" property.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CChart::FixedMin() const
  {
//--- checking
   if(m_chart_id<=0) return(EMPTY_VALUE);
//---
   return(ChartGetDouble(m_chart_id,CHART_FIXED_MIN));
  }
//+------------------------------------------------------------------+
//| Set value of the "FixedMin" property.                            |
//| INPUT:  fixed_min - new value of the "FixedMin" property.        |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::FixedMin(double fixed_min)
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartSetDouble(m_chart_id,CHART_FIXED_MIN,fixed_min));
  }
//+------------------------------------------------------------------+
//| Get value of the "ScalePointsPerBar" property.                   |
//| INPUT:  no.                                                      |
//| OUTPUT: value of the "ScalePointsPerBar" property.               |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::ScalePPB() const
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartGetInteger(m_chart_id,CHART_SCALE_PT_PER_BAR));
  }
//+------------------------------------------------------------------+
//| Set value of the "ScalePointsPerBar" property.                   |
//| INPUT: scale_ppb - new value of the "ScalePointsPerBar" property.|
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::ScalePPB(bool scale_ppb)
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartSetInteger(m_chart_id,CHART_SCALE_PT_PER_BAR,scale_ppb));
  }
//+------------------------------------------------------------------+
//| Get value of the "PointsPerBar" property.                        |
//| INPUT:  no.                                                      |
//| OUTPUT: value of the "PointsPerBar" property.                    |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CChart::PointsPerBar() const
  {
//--- checking
   if(m_chart_id<=0) return(EMPTY_VALUE);
//---
   return(ChartGetDouble(m_chart_id,CHART_POINTS_PER_BAR));
  }
//+------------------------------------------------------------------+
//| Set value of the "PointsPerBar" property.                        |
//| INPUT: points_per_bar - new value of the "PointsPerBar" property.|
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::PointsPerBar(double points_per_bar)
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartSetDouble(m_chart_id,CHART_POINTS_PER_BAR,points_per_bar));
  }
//+------------------------------------------------------------------+
//| Get value of the "ShowOHLC" property.                            |
//| INPUT:  no.                                                      |
//| OUTPUT: value of the "ShowOHLC" property.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::ShowOHLC() const
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartGetInteger(m_chart_id,CHART_SHOW_OHLC));
  }
//+------------------------------------------------------------------+
//| Set value of the "ShowOHLC" property.                            |
//| INPUT:  show - new value of the "ShowOHLC" property.             |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::ShowOHLC(bool show)
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartSetInteger(m_chart_id,CHART_SHOW_OHLC,show));
  }
//+------------------------------------------------------------------+
//| Get value of the "ShowLineBid" property.                         |
//| INPUT:  no.                                                      |
//| OUTPUT: value of the "ShowLineBid" property.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::ShowLineBid() const
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartGetInteger(m_chart_id,CHART_SHOW_BID_LINE));
  }
//+------------------------------------------------------------------+
//| Set value of the "ShowLineBid" property.                         |
//| INPUT:  show - new value of the "ShowLineBid" property.          |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::ShowLineBid(bool show)
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartSetInteger(m_chart_id,CHART_SHOW_BID_LINE,show));
  }
//+------------------------------------------------------------------+
//| Get value of the "ShowLineAsk" property.                         |
//| INPUT:  no.                                                      |
//| OUTPUT: value of the "ShowLineAsk" property.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::ShowLineAsk() const
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartGetInteger(m_chart_id,CHART_SHOW_ASK_LINE));
  }
//+------------------------------------------------------------------+
//| Set value of the "ShowLineAsk" property.                         |
//| INPUT:  show - new value of the "ShowLineAsk" property.          |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::ShowLineAsk(bool show)
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartSetInteger(m_chart_id,CHART_SHOW_ASK_LINE,show));
  }
//+------------------------------------------------------------------+
//| Get value of the "ShowLastLine" property.                        |
//| INPUT:  no.                                                      |
//| OUTPUT: value of the "ShowLastLine" property.                    |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::ShowLastLine() const
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartGetInteger(m_chart_id,CHART_SHOW_LAST_LINE));
  }
//+------------------------------------------------------------------+
//| Set value of the "ShowLastLine" property.                        |
//| INPUT:  show - new value of the "ShowLastLine" property.         |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::ShowLastLine(bool show)
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartSetInteger(m_chart_id,CHART_SHOW_LAST_LINE,show));
  }
//+------------------------------------------------------------------+
//| Get value of the "ShowPeriodSep" property.                       |
//| INPUT:  no.                                                      |
//| OUTPUT: value of the "ShowPeriodSep" property.                   |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::ShowPeriodSep() const
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartGetInteger(m_chart_id,CHART_SHOW_PERIOD_SEP));
  }
//+------------------------------------------------------------------+
//| Set value of the "ShowPeriodSep" property.                       |
//| INPUT:  show - new value of the "ShowPeriodSep" property.        |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::ShowPeriodSep(bool show)
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartSetInteger(m_chart_id,CHART_SHOW_PERIOD_SEP,show));
  }
//+------------------------------------------------------------------+
//| Get value of the "ShowGrid" property.                            |
//| INPUT:  no.                                                      |
//| OUTPUT: value of the "ShowGrid" property.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::ShowGrid() const
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartGetInteger(m_chart_id,CHART_SHOW_GRID));
  }
//+------------------------------------------------------------------+
//| Set value of the "ShowGrid" property.                            |
//| INPUT:  show - new value of the "ShowGrid" property.             |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::ShowGrid(bool show)
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartSetInteger(m_chart_id,CHART_SHOW_GRID,show));
  }
//+------------------------------------------------------------------+
//| Get value of the "ShowVolumes" property.                         |
//| INPUT:  no.                                                      |
//| OUTPUT: value of the "ShowVolumes" property.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
ENUM_CHART_VOLUME_MODE CChart::ShowVolumes() const
  {
//--- checking
   if(m_chart_id<=0) return(WRONG_VALUE);
//---
   return((ENUM_CHART_VOLUME_MODE)ChartGetInteger(m_chart_id,CHART_SHOW_VOLUMES));
  }
//+------------------------------------------------------------------+
//| Set value of the "ShowVolumes" property.                         |
//| INPUT:  show - new value of the "ShowVolumes" property.          |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::ShowVolumes(ENUM_CHART_VOLUME_MODE show)
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartSetInteger(m_chart_id,CHART_SHOW_VOLUMES,show));
  }
//+------------------------------------------------------------------+
//| Get value of the "ShowObjectDescr" property.                     |
//| INPUT:  no.                                                      |
//| OUTPUT: value of the "ShowObjectDescr" property.                 |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::ShowObjectDescr() const
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartGetInteger(m_chart_id,CHART_SHOW_OBJECT_DESCR));
  }
//+------------------------------------------------------------------+
//| Set value of the "ShowObjectDescr" property.                     |
//| INPUT:  show - new value of the "ShowObjectDescr" property.      |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::ShowObjectDescr(bool show)
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartSetInteger(m_chart_id,CHART_SHOW_OBJECT_DESCR,show));
  }
//+------------------------------------------------------------------+
//| Get color value of the "Background" property.                    |
//| INPUT:  no.                                                      |
//| OUTPUT: color value of the "Background" property.                |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
color CChart::ColorBackground() const
  {
//--- checking
   if(m_chart_id<=0) return(CLR_NONE);
//---
   return((color)ChartGetInteger(m_chart_id,CHART_COLOR_BACKGROUND));
  }
//+------------------------------------------------------------------+
//| Set color value of the "Background" property.                    |
//| INPUT:  new_color - new color value of the "Background" property.|
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::ColorBackground(color new_color)
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartSetInteger(m_chart_id,CHART_COLOR_BACKGROUND,new_color));
  }
//+------------------------------------------------------------------+
//| Get color value of the "Foreground" property.                    |
//| INPUT:  no.                                                      |
//| OUTPUT: color value of the "Foreground" property.                |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
color CChart::ColorForeground() const
  {
//--- checking
   if(m_chart_id<=0) return(CLR_NONE);
//---
   return((color)ChartGetInteger(m_chart_id,CHART_COLOR_FOREGROUND));
  }
//+------------------------------------------------------------------+
//| Set color value for the "Foreground" property.                   |
//| INPUT:  new_color - new color value of the "Foreground" property.|
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::ColorForeground(color new_color)
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartSetInteger(m_chart_id,CHART_COLOR_FOREGROUND,new_color));
  }
//+------------------------------------------------------------------+
//| Get color value of the "Grid" property.                          |
//| INPUT:  no.                                                      |
//| OUTPUT: color value of the "Grid" property.                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
color CChart::ColorGrid() const
  {
//--- checking
   if(m_chart_id<=0) return(CLR_NONE);
//---
   return((color)ChartGetInteger(m_chart_id,CHART_COLOR_GRID));
  }
//+------------------------------------------------------------------+
//| Set color value for the "Grid" property.                         |
//| INPUT:  new_color - new color value of the "Grid" property.      |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::ColorGrid(color new_color)
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartSetInteger(m_chart_id,CHART_COLOR_GRID,new_color));
  }
//+------------------------------------------------------------------+
//| Get color value of the "Bar Up" property.                        |
//| INPUT:  no.                                                      |
//| OUTPUT: color value of the "Bar Up" property.                    |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
color CChart::ColorBarUp() const
  {
//--- checking
   if(m_chart_id<=0) return(CLR_NONE);
//---
   return((color)ChartGetInteger(m_chart_id,CHART_COLOR_CHART_UP));
  }
//+------------------------------------------------------------------+
//| Set color value of the "Bar Up" property.                        |
//| INPUT:  new_color - new color value of the "Bar Up" property.    |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::ColorBarUp(color new_color)
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartSetInteger(m_chart_id,CHART_COLOR_CHART_UP,new_color));
  }
//+------------------------------------------------------------------+
//| Get color value of the "Bar Down" property.                      |
//| INPUT:  no.                                                      |
//| OUTPUT: color value of the "Bar Down" property.                  |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
color CChart::ColorBarDown() const
  {
//--- checking
   if(m_chart_id<=0) return(CLR_NONE);
//---
   return((color)ChartGetInteger(m_chart_id,CHART_COLOR_CHART_DOWN));
  }
//+------------------------------------------------------------------+
//| Set color value of the "Bar Down" property.                      |
//| INPUT:  new_color - new color value of the "Bar Down" property.  |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::ColorBarDown(color new_color)
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartSetInteger(m_chart_id,CHART_COLOR_CHART_DOWN,new_color));
  }
//+------------------------------------------------------------------+
//| Get color value of the "Candle Bull" property.                   |
//| INPUT:  no.                                                      |
//| OUTPUT: color value of the "Candle Bull" property.               |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
color CChart::ColorCandleBull() const
  {
//--- checking
   if(m_chart_id<=0) return(CLR_NONE);
//---
   return((color)ChartGetInteger(m_chart_id,CHART_COLOR_CANDLE_BULL));
  }
//+------------------------------------------------------------------+
//| Set color value of the "Candle Bull" property.                   |
//| INPUT: new_color - new color value of the "Candle Bull" property.|
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::ColorCandleBull(color new_color)
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartSetInteger(m_chart_id,CHART_COLOR_CANDLE_BULL,new_color));
  }
//+------------------------------------------------------------------+
//| Get color value of the "Candle Bear" property.                   |
//| INPUT:  no.                                                      |
//| OUTPUT: color value of the "Candle Bear" property.               |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
color CChart::ColorCandleBear() const
  {
//--- checking
   if(m_chart_id<=0) return(CLR_NONE);
//---
   return((color)ChartGetInteger(m_chart_id,CHART_COLOR_CANDLE_BEAR));
  }
//+------------------------------------------------------------------+
//| Set color value of the "Candle Bear" property.                   |
//| INPUT: new_color - new color value of the "Candle Bear" property.|
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::ColorCandleBear(color new_color)
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartSetInteger(m_chart_id,CHART_COLOR_CANDLE_BEAR,new_color));
  }
//+------------------------------------------------------------------+
//| Get color value of the "Chart Line" property.                    |
//| INPUT:  no.                                                      |
//| OUTPUT: color value of the "Chart Line" property.                |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
color CChart::ColorChartLine() const
  {
//--- checking
   if(m_chart_id<=0) return(CLR_NONE);
//---
   return((color)ChartGetInteger(m_chart_id,CHART_COLOR_CHART_LINE));
  }
//+------------------------------------------------------------------+
//| Set color value of the "Chart Line" property.                    |
//| INPUT:  new_color - new color value of the "Chart Line" property.|
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::ColorChartLine(color new_color)
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartSetInteger(m_chart_id,CHART_COLOR_CHART_LINE,new_color));
  }
//+------------------------------------------------------------------+
//| Get color value of the "Volumes" property.                       |
//| INPUT:  no.                                                      |
//| OUTPUT: color value of the "Volumes" property.                   |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
color CChart::ColorVolumes() const
  {
//--- checking
   if(m_chart_id<=0) return(CLR_NONE);
//---
   return((color)ChartGetInteger(m_chart_id,CHART_COLOR_VOLUME));
  }
//+------------------------------------------------------------------+
//| Set color value of the "Volumes" property.                       |
//| INPUT:  new_color - new color value of the "Volumes" property.   |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::ColorVolumes(color new_color)
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartSetInteger(m_chart_id,CHART_COLOR_VOLUME,new_color));
  }
//+------------------------------------------------------------------+
//| Get color value of the "Line Bid" property.                      |
//| INPUT:  no.                                                      |
//| OUTPUT: color value of the "Line Bid" property.                  |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
color CChart::ColorLineBid() const
  {
//--- checking
   if(m_chart_id<=0) return(CLR_NONE);
//---
   return((color)ChartGetInteger(m_chart_id,CHART_COLOR_BID));
  }
//+------------------------------------------------------------------+
//| Set color value of the "Line Bid" property.                      |
//| INPUT:  new_color - new color value of the "Line Bid" property.  |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::ColorLineBid(color new_color)
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartSetInteger(m_chart_id,CHART_COLOR_BID,new_color));
  }
//+------------------------------------------------------------------+
//| Get color value of the "Line Ask" property.                      |
//| INPUT:  no.                                                      |
//| OUTPUT: color value of the "Line Ask" property.                  |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
color CChart::ColorLineAsk() const
  {
//--- checking
   if(m_chart_id<=0) return(CLR_NONE);
//---
   return((color)ChartGetInteger(m_chart_id,CHART_COLOR_ASK));
  }
//+------------------------------------------------------------------+
//| Set color value of the "Line Ask" property.                      |
//| INPUT:  new_color - new color value of the "Line Ask" property.  |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::ColorLineAsk(color new_color)
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartSetInteger(m_chart_id,CHART_COLOR_ASK,new_color));
  }
//+------------------------------------------------------------------+
//| Get color value of the "Line Last" property.                     |
//| INPUT:  no.                                                      |
//| OUTPUT: color value of the "Line Last" property.                 |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
color CChart::ColorLineLast() const
  {
//--- checking
   if(m_chart_id<=0) return(CLR_NONE);
//---
   return((color)ChartGetInteger(m_chart_id,CHART_COLOR_LAST));
  }
//+------------------------------------------------------------------+
//| Set color value of the "Line Last" property.                     |
//| INPUT:  new_color - new color value of the "Line Last" property. |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::ColorLineLast(color new_color)
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartSetInteger(m_chart_id,CHART_COLOR_LAST,new_color));
  }
//+------------------------------------------------------------------+
//| Get color value of the "Stop Levels" property.                   |
//| INPUT:  no.                                                      |
//| OUTPUT: color value of the "Stop Levels" property.               |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
color CChart::ColorStopLevels() const
  {
//--- checking
   if(m_chart_id<=0) return(CLR_NONE);
//---
   return((color)ChartGetInteger(m_chart_id,CHART_COLOR_STOP_LEVEL));
  }
//+------------------------------------------------------------------+
//| Set color value of the "Stop Levels" property.                   |
//| INPUT: new_color - new color value of the "Stop Levels" property.|
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::ColorStopLevels(color new_color)
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartSetInteger(m_chart_id,CHART_COLOR_STOP_LEVEL,new_color));
  }
//+------------------------------------------------------------------+
//| Get value of the "VisibleBars" property.                         |
//| INPUT:  no.                                                      |
//| OUTPUT: value of the "VisibleBars" property.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CChart::VisibleBars() const
  {
//--- checking
   if(m_chart_id<=0) return(0);
//---
   return((int)ChartGetInteger(m_chart_id,CHART_WIDTH_IN_BARS));
  }
//+------------------------------------------------------------------+
//| Get value of the "WindowsTotal" property.                        |
//| INPUT:  no.                                                      |
//| OUTPUT: value of the "WindowsTotal" property.                    |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CChart::WindowsTotal() const
  {
//--- checking
   if(m_chart_id<=0) return(0);
//---
   return((int)ChartGetInteger(m_chart_id,CHART_WINDOWS_TOTAL));
  }
//+------------------------------------------------------------------+
//| Get value of the "WindowIsVisible" property.                     |
//| INPUT:  num -number of subwindows (0-main window).               |
//| OUTPUT: value of the "WindowIsVisible" property.                 |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::WindowIsVisible(int num) const
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartGetInteger(m_chart_id,CHART_WINDOW_IS_VISIBLE,num));
  }
//+------------------------------------------------------------------+
//| Get value of the "WindowHandle" property.                        |
//| INPUT:  no.                                                      |
//| OUTPUT: value of the "WindowHandle" property.                    |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CChart::WindowHandle() const
  {
//--- checking
   if(m_chart_id<=0) return(INVALID_HANDLE);
//---
   return((int)ChartGetInteger(m_chart_id,CHART_WINDOW_HANDLE));
  }
//+------------------------------------------------------------------+
//| Get value of the "FirstVisibleBar" property.                     |
//| INPUT:  no.                                                      |
//| OUTPUT: value of the "FirstVisibleBar" property.                 |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CChart::FirstVisibleBar() const
  {
//--- checking
   if(m_chart_id<=0) return(-1);
//---
   return((int)ChartGetInteger(m_chart_id,CHART_FIRST_VISIBLE_BAR));
  }
//+------------------------------------------------------------------+
//| Get value of the "WidthInBars" property.                         |
//| INPUT:  no.                                                      |
//| OUTPUT: value of the "WidthInBars" property.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CChart::WidthInBars() const
  {
//--- checking
   if(m_chart_id<=0) return(0);
//---
   return((int)ChartGetInteger(m_chart_id,CHART_WIDTH_IN_BARS));
  }
//+------------------------------------------------------------------+
//| Get value of the "WidthInPixels" property.                       |
//| INPUT:  no.                                                      |
//| OUTPUT: value of the "WidthInPixels" property.                   |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CChart::WidthInPixels() const
  {
//--- checking
   if(m_chart_id<=0) return(0);
//---
   return((int)ChartGetInteger(m_chart_id,CHART_WIDTH_IN_PIXELS));
  }
//+------------------------------------------------------------------+
//| Get value of the "HeightInPixels" property.                      |
//| INPUT:  num - number of subwindow (0 - main window).             |
//| OUTPUT: value of the "HeightInPixels" property.                  |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CChart::HeightInPixels(int num) const
  {
//--- checking
   if(m_chart_id<=0) return(0);
//---
   return((int)ChartGetInteger(m_chart_id,CHART_HEIGHT_IN_PIXELS,num));
  }
//+------------------------------------------------------------------+
//| Get value of the "PriceMin" property.                            |
//| INPUT:  num - number of subwindow (0 - main window).             |
//| OUTPUT: value of the "PriceMin" property.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CChart::PriceMin(int num) const
  {
//--- checking
   if(m_chart_id<=0) return(EMPTY_VALUE);
//---
   return(ChartGetDouble(m_chart_id,CHART_PRICE_MIN,num));
  }
//+------------------------------------------------------------------+
//| Get value of the "PriceMax" property.                            |
//| INPUT:  num - number of subwindow (0 - main window).             |
//| OUTPUT: value of the "PriceMax" property.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CChart::PriceMax(int num) const
  {
//--- checking
   if(m_chart_id<=0) return(EMPTY_VALUE);
//---
   return(ChartGetDouble(m_chart_id,CHART_PRICE_MAX,num));
  }
//+------------------------------------------------------------------+
//| Chart close.                                                     |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CChart::Close()
  {
   if(m_chart_id!=-1)
     {
      ChartClose(m_chart_id);
      m_chart_id=-1;
     }
  }
//+------------------------------------------------------------------+
//| Chart navigation.                                                |
//| INPUT:  position - position of chart, which will be used as      |
//|                    a start point for shifting                    |
//|         shift    - number of bars on which the chart             |
//|                    should be shifted.                            |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::Navigate(ENUM_CHART_POSITION position,int shift)
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartNavigate(m_chart_id,position,shift));
  }
//+------------------------------------------------------------------+
//| Access functions long ChartGetInteger(...).                      |
//| INPUT:  prop_id   - identifier of property,                      |
//|         subwindow - number of subwindow.                         |
//| OUTPUT: value of the property.                                   |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
long CChart::GetInteger(ENUM_CHART_PROPERTY_INTEGER prop_id,int subwindow) const
  {
//--- checking
   if(m_chart_id<=0) return(0);
//---
   return(ChartGetInteger(m_chart_id,prop_id,subwindow));
  }
//+------------------------------------------------------------------+
//| Access function bool ChartGetInteger(...).                       |
//| INPUT:  prop_id  - identifier of property,                       |
//|         modifier - number of subwindow,                          |
//|         value    - link to a variable for the value of property. |
//| OUTPUT: true if the property is supported and its value is       |
//|         placed to the varibale, otherwise - false.               |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::GetInteger(ENUM_CHART_PROPERTY_INTEGER prop_id,int subwindow,long& value) const
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartGetInteger(m_chart_id,prop_id,subwindow,value));
  }
//+------------------------------------------------------------------+
//| Access function  ChartSetInteger(...).                           |
//| INPUT:  prop_id  - identifier of property,                       |
//|         value    - new value of the property.                    |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::SetInteger(ENUM_CHART_PROPERTY_INTEGER prop_id,long value)
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartSetInteger(m_chart_id,prop_id,value));
  }
//+------------------------------------------------------------------+
//| Access function double ChartGetDouble(...).                      |
//| INPUT:  prop_id  - identifier of property,                       |
//|         modifier - number of subwindow.                          |
//| OUTPUT: value of the property.                                   |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CChart::GetDouble(ENUM_CHART_PROPERTY_DOUBLE prop_id,int subwindow) const
  {
//--- checking
   if(m_chart_id<=0) return(EMPTY_VALUE);
//---
   return(ChartGetDouble(m_chart_id,prop_id,subwindow));
  }
//+------------------------------------------------------------------+
//| Access function bool ChartGetDouble(...).                        |
//| INPUT:  prop_id  - identifier of property,                       |
//|         modifier - subwindow,                                    |
//|         value    - link to a variable for the value of property. |
//| OUTPUT: true if the property is supported and its value is       |
//|         placed to the varibale, otherwise - false.               |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::GetDouble(ENUM_CHART_PROPERTY_DOUBLE prop_id,int subwindow,double& value) const
  {
//--- checking
   if(m_chart_id<=0) return(0);
//---
   return(ChartGetDouble(m_chart_id,prop_id,subwindow,value));
  }
//+------------------------------------------------------------------+
//| Access function ChartSetDouble(...).                             |
//| INPUT:  prop_id  - identifier of property,                       |
//|         value    - new value of the property.                    |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::SetDouble(ENUM_CHART_PROPERTY_DOUBLE prop_id,double value)
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartSetDouble(m_chart_id,prop_id,value));
  }
//+------------------------------------------------------------------+
//| Access function string ChartGetString(...).                      |
//| INPUT:  prop_id   - identifier of property.                      |
//| OUTPUT: value of the property.                                   |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CChart::GetString(ENUM_CHART_PROPERTY_STRING prop_id) const
  {
//--- checking
   if(m_chart_id<=0) return("");
//---
   return(ChartGetString(m_chart_id,prop_id));
  }
//+------------------------------------------------------------------+
//| Access functions bool ChartGetString(...).                       |
//| INPUT:  prop_id  - identifier of property,                       |
//|         value    - link to a variable for the value of property. |
//| OUTPUT: true if the property is supported and its value is       |
//|         placed to the varibale, otherwise - false.               |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::GetString(ENUM_CHART_PROPERTY_STRING prop_id,string& value) const
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartGetString(m_chart_id,prop_id,value));
  }
//+------------------------------------------------------------------+
//| Access function ChartSetString(...).                             |
//| INPUT:  prop_id  - identifier of property,                       |
//|         value    - new value of the property.                    |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::SetString(ENUM_CHART_PROPERTY_STRING prop_id,const string value)
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartSetString(m_chart_id,prop_id,value));
  }
//+------------------------------------------------------------------+
//| Access function ChartSetSymbolPeriod(...).                       |
//| INPUT:  symbol  - new symbol,                                    |
//|         period  - new period.                                    |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::SetSymbolPeriod(const string symbol,ENUM_TIMEFRAMES period)
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartSetSymbolPeriod(m_chart_id,symbol,period));
  }
//+------------------------------------------------------------------+
//| Access function ChartApplyTemplate(...).                         |
//| INPUT:  filename - name of template file.                        |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::ApplyTemplate(const string filename)
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartApplyTemplate(m_chart_id,filename));
  }
//+------------------------------------------------------------------+
//| Access function ChartScreenShot(...).                            |
//| INPUT:  filename  - name of file for the screenshot,             |
//|         width     - screenshot width in pixels,                  |
//|         height    - screenshot height in pixels,                 |
//|         align_mode- output mode for screeenshots which width is  |
//|                     less than width of chart.                    |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::ScreenShot(const string filename,int width,int height,ENUM_ALIGN_MODE align_mode) const
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartScreenShot(m_chart_id,filename,width,height,align_mode));
  }
//+------------------------------------------------------------------+
//| Access function WindowOnDropped().                               |
//| INPUT:  no.                                                      |
//| OUTPUT: number of subwindow (0 - main window)).                  |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CChart::WindowOnDropped() const
  {
//--- checking
   if(m_chart_id<=0) return(0);
//---
   return(ChartWindowOnDropped());
  }
//+------------------------------------------------------------------+
//| Access function PriceOnDropped().                                |
//| INPUT:  no.                                                      |
//| OUTPUT: value of the price (or value of vertical scale           |
//|         of subwindow).                                           |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CChart::PriceOnDropped() const
  {
//--- checking
   if(m_chart_id<=0) return(EMPTY_VALUE);
//---
   return(ChartPriceOnDropped());
  }
//+------------------------------------------------------------------+
//| Access function TimeOnDropped().                                 |
//| INPUT:  no.                                                      |
//| OUTPUT: time value.                                              |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
datetime CChart::TimeOnDropped() const
  {
//--- checking
   if(m_chart_id<=0) return(false);
//---
   return(ChartTimeOnDropped());
  }
//+------------------------------------------------------------------+
//| Access functions XOnDropped().                                   |
//| INPUT:  no.                                                      |
//| OUTPUT: X-coordinate.                                            |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CChart::XOnDropped() const
  {
//--- checking
   if(m_chart_id<=0) return(0);
//---
   return(ChartXOnDropped());
  }
//+------------------------------------------------------------------+
//| Access functions YOnDropped().                                   |
//| INPUT:  no.                                                      |
//| OUTPUT: Y-coordinate.                                            |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CChart::YOnDropped() const
  {
//--- checking
   if(m_chart_id<=0) return(0);
//---
   return(ChartYOnDropped());
  }
//+------------------------------------------------------------------+
//| Writing parameters of chart to file.                             |
//| INPUT:  file_handle - handle of file previously opened           |
//|         for writing .                                            |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::Save(int file_handle)
  {
   string work_str;
   int    work_int;
//--- checking
   if(file_handle<=0) return(false);
   if(m_chart_id<=0)  return(false);
//--- writing
//--- writing start marker - 0xFFFFFFFFFFFFFFFF
   if(FileWriteLong(file_handle,-1)!=sizeof(long)) return(false);
//--- writing chart type
   if(FileWriteInteger(file_handle,Type(),INT_VALUE)!=INT_VALUE) return(false);
//--- writing chart symbol
   work_str=Symbol();
   work_int=StringLen(work_str);
   if(FileWriteInteger(file_handle,work_int,INT_VALUE)!=INT_VALUE) return(false);
   if(work_int!=0) if(FileWriteString(file_handle,work_str,work_int)!=work_int) return(false);
//--- writing period of chart
   if(FileWriteInteger(file_handle,Period(),INT_VALUE)!=sizeof(int)) return(false);
//--- writing value of the "Mode" property
   if(FileWriteInteger(file_handle,(int)ChartGetInteger(m_chart_id,CHART_MODE),INT_VALUE)!=sizeof(int)) return(false);
//--- writing value of the "Foreground" property
   if(FileWriteInteger(file_handle,(int)ChartGetInteger(m_chart_id,CHART_FOREGROUND),CHAR_VALUE)!=sizeof(char)) return(false);
//--- writing value of the "Shift" property
   if(FileWriteInteger(file_handle,(int)ChartGetInteger(m_chart_id,CHART_SHIFT),CHAR_VALUE)!=sizeof(char)) return(false);
//--- writing value of the "ShiftSize" property
   if(FileWriteInteger(file_handle,(int)ChartGetInteger(m_chart_id,CHART_SHIFT),INT_VALUE)!=sizeof(int)) return(false);
//--- writing value of the "AutoScroll" property
   if(FileWriteInteger(file_handle,(int)ChartGetInteger(m_chart_id,CHART_AUTOSCROLL),CHAR_VALUE)!=sizeof(char)) return(false);
//--- writing value of the "Scale" property
   if(FileWriteInteger(file_handle,(int)ChartGetInteger(m_chart_id,CHART_SCALE),INT_VALUE)!=sizeof(int)) return(false);
//--- writing value of the "ScaleFix" property
   if(FileWriteInteger(file_handle,(int)ChartGetInteger(m_chart_id,CHART_SCALEFIX),CHAR_VALUE)!=sizeof(char)) return(false);
//--- writing value of the "ScaleFix_11" property
   if(FileWriteInteger(file_handle,(int)ChartGetInteger(m_chart_id,CHART_SCALEFIX_11),CHAR_VALUE)!=sizeof(char)) return(false);
//--- writing value of the "FixedMax" property
   if(FileWriteDouble(file_handle,ChartGetDouble(m_chart_id,CHART_FIXED_MAX))!=sizeof(double)) return(false);
//--- writing value of the "FixedMin" property
   if(FileWriteDouble(file_handle,ChartGetDouble(m_chart_id,CHART_FIXED_MIN))!=sizeof(double)) return(false);
//--- writing the "ScalePPB" property
   if(FileWriteInteger(file_handle,(int)ChartGetInteger(m_chart_id,CHART_SCALE_PT_PER_BAR),CHAR_VALUE)!=sizeof(char)) return(false);
//--- writing value of the "PointsPerBar" property
   if(FileWriteDouble(file_handle,ChartGetDouble(m_chart_id,CHART_POINTS_PER_BAR))!=sizeof(double)) return(false);
//--- writing value of the "ShowOHLC" property
   if(FileWriteInteger(file_handle,(int)ChartGetInteger(m_chart_id,CHART_SHOW_OHLC),CHAR_VALUE)!=sizeof(char)) return(false);
//--- writing value of the "ShowLineBid" property
   if(FileWriteInteger(file_handle,(int)ChartGetInteger(m_chart_id,CHART_SHOW_BID_LINE),CHAR_VALUE)!=sizeof(char)) return(false);
//--- writing value of the "ShowLineAsk" property
   if(FileWriteInteger(file_handle,(int)ChartGetInteger(m_chart_id,CHART_SHOW_ASK_LINE),CHAR_VALUE)!=sizeof(char)) return(false);
//--- writing value of the "ShowLastLine" property
   if(FileWriteInteger(file_handle,(int)ChartGetInteger(m_chart_id,CHART_SHOW_LAST_LINE),CHAR_VALUE)!=sizeof(char)) return(false);
//--- writing value of the "ShowPeriodSep" property
   if(FileWriteInteger(file_handle,(int)ChartGetInteger(m_chart_id,CHART_SHOW_PERIOD_SEP),CHAR_VALUE)!=sizeof(char)) return(false);
//--- writing value of the "ShowGrid" property
   if(FileWriteInteger(file_handle,(int)ChartGetInteger(m_chart_id,CHART_SHOW_GRID),CHAR_VALUE)!=sizeof(char)) return(false);
//--- writing value of the "ShowVolumes" property
   if(FileWriteInteger(file_handle,(int)ChartGetInteger(m_chart_id,CHART_SHOW_VOLUMES),INT_VALUE)!=sizeof(int)) return(false);
//--- writing value of the "ShowObjectDescr" property
   if(FileWriteInteger(file_handle,(int)ChartGetInteger(m_chart_id,CHART_SHOW_OBJECT_DESCR),CHAR_VALUE)!=sizeof(char)) return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Reading parameters of chart from file.                           |
//| INPUT:  file_handle - handle of file previously opened           |
//|         for reading.                                             |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChart::Load(int file_handle)
  {
   bool   resutl=true;
   string work_str;
   int    work_int;
//--- checking
   if(file_handle<=0) return(false);
   if(m_chart_id<=0)  return(false);
//--- reading
//--- reading and checking start marker - 0xFFFFFFFFFFFFFFFF
   if(FileReadLong(file_handle)!=-1) return(false);
//--- reading and checking chart type
   if(FileReadInteger(file_handle,INT_VALUE)!=Type()) return(false);
//--- reading chart symbol
   work_int=FileReadInteger(file_handle);
   if(work_int!=0) work_str=FileReadString(file_handle,work_int);
   else            work_str="";
//--- reading chart period
   work_int=FileReadInteger(file_handle);
   SetSymbolPeriod(work_str,(ENUM_TIMEFRAMES)work_int);
//--- reading value of the "Mode" property
   if(!ChartSetInteger(m_chart_id,CHART_MODE,FileReadInteger(file_handle,INT_VALUE))) return(false);
//--- reading value of the "Foreground" property
   if(!ChartSetInteger(m_chart_id,CHART_FOREGROUND,FileReadInteger(file_handle,CHAR_VALUE))) return(false);
//--- reading value of the "Shift" property
   if(!ChartSetInteger(m_chart_id,CHART_SHIFT,FileReadInteger(file_handle,CHAR_VALUE))) return(false);
//--- reading value of the "ShiftSize" property
   if(!ChartSetInteger(m_chart_id,CHART_SHIFT,FileReadInteger(file_handle,INT_VALUE))) return(false);
//--- reading value of the "AutoScroll" property
   if(!ChartSetInteger(m_chart_id,CHART_AUTOSCROLL,FileReadInteger(file_handle,CHAR_VALUE))) return(false);
//--- reading value of the "Scale" property
   if(!ChartSetInteger(m_chart_id,CHART_SCALE,FileReadInteger(file_handle,INT_VALUE))) return(false);
//--- reading value of the "ScaleFix" property
   if(!ChartSetInteger(m_chart_id,CHART_SCALEFIX,FileReadInteger(file_handle,CHAR_VALUE))) return(false);
//--- reading value of the "ScaleFix_11" property
   if(!ChartSetInteger(m_chart_id,CHART_SCALEFIX_11,FileReadInteger(file_handle,CHAR_VALUE))) return(false);
//--- reading value of the "FixedMax" property
   if(!ChartSetDouble(m_chart_id,CHART_FIXED_MAX,FileReadDatetime(file_handle))) return(false);
//--- reading value of the "FixedMin" property
   if(!ChartSetDouble(m_chart_id,CHART_FIXED_MIN,FileReadDatetime(file_handle))) return(false);
//--- reading value of the "ScalePPB" property
   if(!ChartSetInteger(m_chart_id,CHART_SCALE_PT_PER_BAR,FileReadInteger(file_handle,CHAR_VALUE))) return(false);
//--- reading value of the "PointsPerBar" property
   if(!ChartSetDouble(m_chart_id,CHART_POINTS_PER_BAR,FileReadDatetime(file_handle))) return(false);
//--- reading value of the "ShowOHLC" property
   if(!ChartSetInteger(m_chart_id,CHART_SHOW_OHLC,FileReadInteger(file_handle,CHAR_VALUE))) return(false);
//--- reading value of the "ShowLineBid" property
   if(!ChartSetInteger(m_chart_id,CHART_SHOW_BID_LINE,FileReadInteger(file_handle,CHAR_VALUE))) return(false);
//--- reading value of the "ShowLineAsk" property
   if(!ChartSetInteger(m_chart_id,CHART_SHOW_ASK_LINE,FileReadInteger(file_handle,CHAR_VALUE))) return(false);
//--- reading value of the "ShowLastLine" property
   if(!ChartSetInteger(m_chart_id,CHART_SHOW_LAST_LINE,FileReadInteger(file_handle,CHAR_VALUE))) return(false);
//--- reading value of the "ShowPeriodSep" property
   if(!ChartSetInteger(m_chart_id,CHART_SHOW_PERIOD_SEP,FileReadInteger(file_handle,CHAR_VALUE))) return(false);
//--- reading value of the "ShowGrid" property
   if(!ChartSetInteger(m_chart_id,CHART_SHOW_GRID,FileReadInteger(file_handle,CHAR_VALUE))) return(false);
//--- reading value of the "ShowVolumes" property
   if(!ChartSetInteger(m_chart_id,CHART_SHOW_VOLUMES,FileReadInteger(file_handle,INT_VALUE))) return(false);
//--- reading value of the "ShowObjectDescr" property
   if(!ChartSetInteger(m_chart_id,CHART_SHOW_OBJECT_DESCR,FileReadInteger(file_handle,CHAR_VALUE))) return(false);
//---
   return(resutl);
  }
//+------------------------------------------------------------------+