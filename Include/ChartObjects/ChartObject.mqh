//+------------------------------------------------------------------+
//|                                                  ChartObject.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//|                                              Revision 2011.03.30 |
//+------------------------------------------------------------------+
#include <Object.mqh>
//+------------------------------------------------------------------+
//| Class CChartObject.                                              |
//| Pupose: Base class of chart objects.                             |
//|              Derives from class CObject.                         |
//+------------------------------------------------------------------+
class CChartObject : public CObject
  {
protected:
   long              m_chart_id;           // identifier of chart the object belongs to
   int               m_window;             // number of subwindow (0 - main window)
   string            m_name;               // unique name object name
   int               m_num_points;         // number of anchor points of object
public:
                     CChartObject();
                    ~CChartObject();
   //--- methods of access to protected data
   long              ChartId()                   const { return(m_chart_id);   }
   int               Window()                    const { return(m_window);     }
   string            Name()                      const { return(m_name);       }
   bool              Name(const string name);
   int               NumPoints()                 const { return(m_num_points); }
   //--- method of identifying the object
   virtual int       Type()                      const { return(0x8888);       }
   //--- methods of filling the object
   bool              Attach(long chart_id,string name,int window,int points);
   bool              SetPoint(int point,datetime time,double price);
   //--- methods of deleting
   bool              Delete();
   void              Detach();
   //--- methods of access to properties of the object
   datetime          Time(int point)             const;
   bool              Time(int point,datetime time);
   double            Price(int point)            const;
   bool              Price(int point,double price);
   color             Color()                     const;
   bool              Color(color new_color);
   ENUM_LINE_STYLE   Style()                     const;
   bool              Style(ENUM_LINE_STYLE new_style);
   int               Width()                     const;
   bool              Width(int new_width);
   bool              Background()                const;
   bool              Background(bool new_back);
   long              Z_Order()                   const;
   bool              Z_Order(long value);
   bool              Selected()                  const;
   bool              Selected(bool new_sel);
   bool              Selectable()                const;
   bool              Selectable(bool new_sel);
   string            Description()               const;
   bool              Description(const string new_text);
   string            Tooltip()                   const;
   bool              Tooltip(const string new_text);
   int               Timeframes()                const;
   virtual bool      Timeframes(int timeframes);
   datetime          CreateTime()                const;
   int               LevelsCount()               const;
   bool              LevelsCount(int new_count);
   //--- methods to access the properties of levels of objects
   color             LevelColor(int level)       const;
   bool              LevelColor(int level,color new_color);
   ENUM_LINE_STYLE   LevelStyle(int level)       const;
   bool              LevelStyle(int level,ENUM_LINE_STYLE new_style);
   int               LevelWidth(int level)       const;
   bool              LevelWidth(int level,int new_width);
   double            LevelValue(int level)       const;
   bool              LevelValue(int level,double new_value);
   string            LevelDescription(int level) const;
   bool              LevelDescription(int level,const string new_text);
   //--- access methods to the API functions of MQL5
   long              GetInteger(ENUM_OBJECT_PROPERTY_INTEGER prop_id,int modifier=-1)          const;
   bool              GetInteger(ENUM_OBJECT_PROPERTY_INTEGER prop_id,int modifier,long& value) const;
   bool              SetInteger(ENUM_OBJECT_PROPERTY_INTEGER prop_id,int modifier,long value);
   bool              SetInteger(ENUM_OBJECT_PROPERTY_INTEGER prop_id,long value);
   double            GetDouble(ENUM_OBJECT_PROPERTY_DOUBLE prop_id,int modifier=-1)            const;
   bool              GetDouble(ENUM_OBJECT_PROPERTY_DOUBLE prop_id,int modifier,double& value) const;
   bool              SetDouble(ENUM_OBJECT_PROPERTY_DOUBLE prop_id,int modifier,double value);
   bool              SetDouble(ENUM_OBJECT_PROPERTY_DOUBLE prop_id,double value);
   string            GetString(ENUM_OBJECT_PROPERTY_STRING prop_id,int modifier=-1)            const;
   bool              GetString(ENUM_OBJECT_PROPERTY_STRING prop_id,int modifier,string& value) const;
   bool              SetString(ENUM_OBJECT_PROPERTY_STRING prop_id,int modifier,string value);
   bool              SetString(ENUM_OBJECT_PROPERTY_STRING prop_id,string value);
   //--- methods of moving
   bool              ShiftObject(datetime d_time,double d_price);
   bool              ShiftPoint(int point,datetime d_time,double d_price);
   //--- methods for working with files
   virtual bool      Save(int file_handle);
   virtual bool      Load(int file_handle);
  };
//+------------------------------------------------------------------+
//| Constructor CChartObject.                                        |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CChartObject::CChartObject()
  {
//--- initialize protected data
   Detach();
  }
//+------------------------------------------------------------------+
//| Destructor CChartObject.                                         |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CChartObject::~CChartObject()
  {
   if(m_chart_id!=-1) ObjectDelete(m_chart_id,m_name);
  }
//+------------------------------------------------------------------+
//| Changing name of the object.                                     |
//| INPUT:  name - new name of the object.                           |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObject::Name(const string name)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//--- changing
   if(ObjectSetString(m_chart_id,m_name,OBJPROP_NAME,name))
     {
      m_name=name;
      return(true);
     }
//---
   return(false);
  };
//+------------------------------------------------------------------+
//| Attach object.                                                   |
//| INPUT:  chart_id - chart idintifier,                             |
//|         name    - object name,                                   |
//|         window  - chart window,                                  |
//|         points  - number of points "anchor" object.              |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObject::Attach(long chart_id,string name,int window,int points)
  {
//--- checking
   if(ObjectFind(chart_id,name)<0) return(false);
//--- attaching
   if(chart_id==0) chart_id=ChartID();
   m_chart_id  =chart_id;
   m_window    =window;
   m_name      =name;
   m_num_points=points;
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Setting new coordinates of anchor point of an object.            |
//| INPUT:  point - number of point of the object,                   |
//|         time  - new time coordinate,                             |
//|         price - new price cordinate.                             |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObject::SetPoint(int point,datetime time,double price)
  {
//--- checking
   if(m_chart_id==-1)      return(false);
   if(point>=m_num_points) return(false);
//---
   bool res=ObjectMove(m_chart_id,m_name,point,time,price);
//---
   return(res);
  }
//+------------------------------------------------------------------+
//| Delete an object.                                                |
//| INPUT:  no.                                                      |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObject::Delete()
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   bool result=ObjectDelete(m_chart_id,m_name);
   Detach();
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Detach object.                                                   |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CChartObject::Detach()
  {
   m_chart_id=-1;
   m_window=-1;
   m_name=NULL;
   m_num_points=0;
  }
//+------------------------------------------------------------------+
//| Get the time coordinate of the specified anchor point of object. |
//| INPUT:  point - number of anchor point.                          |
//| OUTPUT: date/time                                                |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
datetime CChartObject::Time(int point) const
  {
//--- checking
   if(m_chart_id==-1)      return(0);
   if(point>=m_num_points) return(0);
//---
   return((datetime)ObjectGetInteger(m_chart_id,m_name,OBJPROP_TIME,point));
  }
//+------------------------------------------------------------------+
//| Set the time coordinate of the specified anchor point of object. |
//| INPUT:  point -number of point,                                  |
//|         time  -new date/time.                                    |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObject::Time(int point,datetime time)
  {
//--- checking
   if(m_chart_id==-1)      return(false);
   if(point>=m_num_points) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,OBJPROP_TIME,time));
  }
//+------------------------------------------------------------------+
//| Get the price coordinate of the specified anchor point of object.|
//| INPUT:  point - number of anchor point.                          |
//| OUTPUT: price.                                                   |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CChartObject::Price(int point) const
  {
//--- checking
   if(m_chart_id==-1)      return(EMPTY_VALUE);
   if(point>=m_num_points) return(EMPTY_VALUE);
//---
   return(ObjectGetDouble(m_chart_id,m_name,OBJPROP_PRICE,point));
  }
//+------------------------------------------------------------------+
//| Set the price coordinate of the specified anchor point of object.|
//| INPUT:  point - number of anchor point,                          |
//|         price - new price.                                       |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObject::Price(int point,double price)
  {
//--- checking
   if(m_chart_id==-1)      return(false);
   if(point>=m_num_points) return(false);
//---
   return(ObjectSetDouble(m_chart_id,m_name,OBJPROP_PRICE,price));
  }
//+------------------------------------------------------------------+
//| Get object color.                                                |
//| INPUT:  no.                                                      |
//| OUTPUT: color.                                                   |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
color CChartObject::Color() const
  {
//--- checking
   if(m_chart_id==-1) return(CLR_NONE);
//---
   return((color)ObjectGetInteger(m_chart_id,m_name,OBJPROP_COLOR));
  }
//+------------------------------------------------------------------+
//| Set object color.                                                |
//| INPUT:  new_color - new color.                                   |
//| OUTPUT: true if successful, false of not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObject::Color(color new_color)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,OBJPROP_COLOR,new_color));
  }
//+------------------------------------------------------------------+
//| Get style of line of object.                                     |
//| INPUT:  no.                                                      |
//| OUTPUT: line style.                                              |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
ENUM_LINE_STYLE CChartObject::Style() const
  {
//--- checking
   if(m_chart_id==-1) return(WRONG_VALUE);
//---
   return((ENUM_LINE_STYLE)ObjectGetInteger(m_chart_id,m_name,OBJPROP_STYLE));
  }
//+------------------------------------------------------------------+
//| Set style of line of object.                                     |
//| INPUT:  new_style - new style of line.                           |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObject::Style(ENUM_LINE_STYLE new_style)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,OBJPROP_STYLE,new_style));
  }
//+------------------------------------------------------------------+
//| Get width of line of object.                                     |
//| INPUT:  no.                                                      |
//| OUTPUT: width of line.                                           |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CChartObject::Width() const
  {
//--- checking
   if(m_chart_id==-1) return(-1);
//---
   return((int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_WIDTH));
  }
//+------------------------------------------------------------------+
//| Set width of line of object.                                     |
//| INPUT:  new_width - new width of line.                           |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObject::Width(int new_width)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,OBJPROP_WIDTH,new_width));
  }
//+------------------------------------------------------------------+
//| Get the "Draw object as background" flag.                        |
//| INPUT:  no.                                                      |
//| OUTPUT: the "Draw object as background" flag.                    |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObject::Background() const
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectGetInteger(m_chart_id,m_name,OBJPROP_BACK));
  }
//+------------------------------------------------------------------+
//| Set the "Draw object as background" flag.                        |
//| INPUT:  new_back - new "Draw object as background" flag.         |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObject::Background(bool new_back)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,OBJPROP_BACK,new_back));
  }
//+------------------------------------------------------------------+
//| Get the "Z-order" property.                                      |
//| INPUT:  no.                                                      |
//| OUTPUT: the "Z-order" property.                                  |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
long CChartObject::Z_Order() const
  {
//--- checking
   if(m_chart_id==-1) return(0);
//---
   return(ObjectGetInteger(m_chart_id,m_name,OBJPROP_ZORDER));
  }
//+------------------------------------------------------------------+
//| Set the "Z-order" property.                                      |
//| INPUT:  value - new "Z-order" property.                          |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObject::Z_Order(long value)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,OBJPROP_ZORDER,value));
  }
//+------------------------------------------------------------------+
//| Get the "selected" flag.                                         |
//| INPUT:  no.                                                      |
//| OUTPUT: the "selected" flag.                                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObject::Selected() const
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectGetInteger(m_chart_id,m_name,OBJPROP_SELECTED));
  }
//+------------------------------------------------------------------+
//| Set the "selected" flag.                                         |
//| INPUT:  new_sel - new flag "selected".                           |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObject::Selected(bool new_sel)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,OBJPROP_SELECTED,new_sel));
  }
//+------------------------------------------------------------------+
//| Get the "selectable" flag.                                       |
//| INPUT:  no.                                                      |
//| OUTPUT: the "selectable" flag.                                   |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObject::Selectable() const
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectGetInteger(m_chart_id,m_name,OBJPROP_SELECTABLE));
  }
//+------------------------------------------------------------------+
//| Set flag the "selectable" flag.                                  |
//| INPUT:  new_sel - new flag "selectable".                         |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObject::Selectable(bool new_sel)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,OBJPROP_SELECTABLE,new_sel));
  }
//+------------------------------------------------------------------+
//| Get comment of object.                                           |
//| INPUT:  no.                                                      |
//| OUTPUT: comment of object.                                       |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CChartObject::Description() const
  {
//--- checking
   if(m_chart_id==-1) return("");
//---
   return(ObjectGetString(m_chart_id,m_name,OBJPROP_TEXT));
  }
//+------------------------------------------------------------------+
//| Set comment of object.                                           |
//| INPUT:  new_text - new comment.                                  |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObject::Description(const string new_text)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//--- tuning
   if(new_text=="") 
      return(ObjectSetString(m_chart_id,m_name,OBJPROP_TEXT," "));
//---
   return(ObjectSetString(m_chart_id,m_name,OBJPROP_TEXT,new_text));
  }
//+------------------------------------------------------------------+
//| Get tooltip of object.                                           |
//| INPUT:  no.                                                      |
//| OUTPUT: tooltip of object.                                       |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CChartObject::Tooltip() const
  {
//--- checking
   if(m_chart_id==-1) return("");
//---
   return(ObjectGetString(m_chart_id,m_name,OBJPROP_TOOLTIP));
  }
//+------------------------------------------------------------------+
//| Set tooltip of object.                                           |
//| INPUT:  new_text - new tooltip.                                  |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObject::Tooltip(const string new_text)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//--- tuning
   if(new_text=="") 
      return(ObjectSetString(m_chart_id,m_name,OBJPROP_TOOLTIP," "));
//---
   return(ObjectSetString(m_chart_id,m_name,OBJPROP_TOOLTIP,new_text));
  }
//+------------------------------------------------------------------+
//| Get the "Timeframes" (visibility) flag.                          |
//| INPUT:  no.                                                      |
//| OUTPUT: the "Timeframes" flag.                                   |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CChartObject::Timeframes() const
  {
//--- checking
   if(m_chart_id==-1) return(0);
//---
   return((int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_TIMEFRAMES));
  }
//+------------------------------------------------------------------+
//| Set the "Timeframes" (visibility) flag.                          |
//| INPUT:  timeframes - new flags "Timeframes".                     |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObject::Timeframes(int timeframes)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,OBJPROP_TIMEFRAMES,timeframes));
  }
//+------------------------------------------------------------------+
//| Get time of object creation.                                     |
//| INPUT:  no.                                                      |
//| OUTPUT: creation time.                                           |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
datetime CChartObject::CreateTime() const
  {
//--- checking
   if(m_chart_id==-1) return(0);
//---
   return((datetime)ObjectGetInteger(m_chart_id,m_name,OBJPROP_CREATETIME));
  }
//+------------------------------------------------------------------+
//| Get number of levels of object.                                  |
//| INPUT:  no.                                                      |
//| OUTPUT: number of levels of object.                              |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CChartObject::LevelsCount() const
  {
//--- checking
   if(m_chart_id==-1) return(0);
//---
   return((int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_LEVELS));
  }
//+------------------------------------------------------------------+
//| Set number of levels of object.                                  |
//| INPUT:  new_count - new number of levels of object.              |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObject::LevelsCount(int new_count)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,OBJPROP_LEVELS,new_count));
  }
//+------------------------------------------------------------------+
//| Get color of the specified level of object.                      |
//| INPUT:  level - number of level.                                 |
//| OUTPUT: color of level.                                          |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
color CChartObject::LevelColor(int level) const
  {
//--- checking
   if(m_chart_id==-1)       return(CLR_NONE);
   if(level>=LevelsCount()) return(CLR_NONE);
//---
   return((color)ObjectGetInteger(m_chart_id,m_name,OBJPROP_LEVELCOLOR,level));
  }
//+------------------------------------------------------------------+
//| Set color of the specified level of object.                      |
//| INPUT:  level - number of level,                                 |
//|         new_color - new color of level.                          |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObject::LevelColor(int level,color new_color)
  {
//--- checking
   if(m_chart_id==-1)       return(false);
   if(level>=LevelsCount()) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,OBJPROP_LEVELCOLOR,level,new_color));
  }
//+------------------------------------------------------------------+
//| Get line style of the specified level of object.                 |
//| INPUT:  level - number of level.                                 |
//| OUTPUT: line style of level.                                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
ENUM_LINE_STYLE CChartObject::LevelStyle(int level) const
  {
//--- checking
   if(m_chart_id==-1)       return(WRONG_VALUE);
   if(level>=LevelsCount()) return(WRONG_VALUE);
//---
   return((ENUM_LINE_STYLE)ObjectGetInteger(m_chart_id,m_name,OBJPROP_LEVELSTYLE,level));
  }
//+------------------------------------------------------------------+
//| Set line style of the specified level of object.                 |
//| INPUT:  level - number of level,                                 |
//|         new_style - new line styleof level.                      |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObject::LevelStyle(int level,ENUM_LINE_STYLE new_style)
  {
//--- checking
   if(m_chart_id==-1)       return(false);
   if(level>=LevelsCount()) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,OBJPROP_LEVELSTYLE,level,new_style));
  }
//+------------------------------------------------------------------+
//| Get line width of the specified level of object.                 |
//| INPUT:  level - number of level.                                 |
//| OUTPUT: width of line of level.                                  |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CChartObject::LevelWidth(int level) const
  {
//--- checking
   if(m_chart_id==-1)       return(-1);
   if(level>=LevelsCount()) return(-1);
//---
   return((int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_LEVELWIDTH,level));
  }
//+------------------------------------------------------------------+
//| Set line width of the specified level of object.                 |
//| INPUT:  level - number of level,                                 |
//|         new_width - new width of line of level.                  |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObject::LevelWidth(int level,int new_width)
  {
//--- checking
   if(m_chart_id==-1)       return(false);
   if(level>=LevelsCount()) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,OBJPROP_LEVELWIDTH,level,new_width));
  }
//+------------------------------------------------------------------+
//| Get value of the specified level of object.                      |
//| INPUT:  level - number of level.                                 |
//| OUTPUT: level value.                                             |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CChartObject::LevelValue(int level) const
  {
//--- checking
   if(m_chart_id==-1)       return(EMPTY_VALUE);
   if(level>=LevelsCount()) return(EMPTY_VALUE);
//---
   return(ObjectGetDouble(m_chart_id,m_name,OBJPROP_LEVELVALUE,level));
  }
//+------------------------------------------------------------------+
//| Set value of the specified level of object.                      |
//| INPUT:  level - number level number,                             |
//|         new_value - new value of level.                          |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObject::LevelValue(int level,double new_value)
  {
//--- checking
   if(m_chart_id==-1)       return(false);
   if(level>=LevelsCount()) return(false);
//---
   return(ObjectSetDouble(m_chart_id,m_name,OBJPROP_LEVELVALUE,level,new_value));
  }
//+------------------------------------------------------------------+
//| Get comment of of the specified level of object.                 |
//| INPUT:  level - number of level.                                 |
//| OUTPUT: level comment.                                           |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CChartObject::LevelDescription(int level) const
  {
//--- checking
   if(m_chart_id==-1)       return("");
   if(level>=LevelsCount()) return("");
//---
   return(ObjectGetString(m_chart_id,m_name,OBJPROP_LEVELTEXT,level));
  }
//+------------------------------------------------------------------+
//| Set comment to the specified level of object.                    |
//| INPUT:  level - number of level,                                 |
//|         new_text - new comment to the level.                     |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObject::LevelDescription(int level,const string new_text)
  {
//--- checking
   if(m_chart_id==-1)       return(false);
   if(level>=LevelsCount()) return(false);
//---
   return(ObjectSetString(m_chart_id,m_name,OBJPROP_LEVELTEXT,level,new_text));
  }
//+------------------------------------------------------------------+
//| Access function long ObjectGetInteger(...).                      |
//| INPUT:  prop_id  - property identifier,                          |
//|         modifier - property modifier.                            |
//| OUTPUT: the property value.                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
long CChartObject::GetInteger(ENUM_OBJECT_PROPERTY_INTEGER prop_id,int modifier) const
  {
//--- checking
   if(m_chart_id==-1) return(0);
//---
   if(modifier==-1) return(ObjectGetInteger(m_chart_id,m_name,prop_id));
//---
   return(ObjectGetInteger(m_chart_id,m_name,prop_id,modifier));
  }
//+------------------------------------------------------------------+
//| Access function bool ObjectGetInteger(...).                      |
//| INPUT:  prop_id  - property identifier,                          |
//|         modifier - property modifier,                            |
//|         value    - variable for the property value.              |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObject::GetInteger(ENUM_OBJECT_PROPERTY_INTEGER prop_id,int modifier,long& value) const
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectGetInteger(m_chart_id,m_name,prop_id,modifier,value));
  }
//+------------------------------------------------------------------+
//| Access function ObjectSetInteger(.,modifier,.).                  |
//| INPUT:  prop_id  - property identifier,                          |
//|         modifier - property modifier,                            |
//|         value    - new value for the property.                   |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObject::SetInteger(ENUM_OBJECT_PROPERTY_INTEGER prop_id,int modifier,long value)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,prop_id,modifier,value));
  }
//+------------------------------------------------------------------+
//| Access function ObjectSetInteger(...).                           |
//| INPUT:  prop_id  - property identifier,                          |
//|         value    - new value for the property.                   |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObject::SetInteger(ENUM_OBJECT_PROPERTY_INTEGER prop_id,long value)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,prop_id,value));
  }
//+------------------------------------------------------------------+
//| Access function double ObjectGetDouble(...).                     |
//| INPUT:  prop_id  - property identifier,                          |
//|         modifier - property modifier.                            |
//| OUTPUT: the property value.                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CChartObject::GetDouble(ENUM_OBJECT_PROPERTY_DOUBLE prop_id,int modifier) const
  {
//--- checking
   if(m_chart_id==-1) return(EMPTY_VALUE);
//---
   if(modifier==-1) return(ObjectGetDouble(m_chart_id,m_name,prop_id));
//---
   return(ObjectGetDouble(m_chart_id,m_name,prop_id,modifier));
  }
//+------------------------------------------------------------------+
//| Access function bool ObjectGetDouble(...).                       |
//| INPUT:  prop_id  - property identifier,                          |
//|         modifier - property modifier,                            |
//|         value    - variable for the property value.              |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObject::GetDouble(ENUM_OBJECT_PROPERTY_DOUBLE prop_id,int modifier,double& value) const
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectGetDouble(m_chart_id,m_name,prop_id,modifier,value));
  }
//+------------------------------------------------------------------+
//| Access function ObjectSetDouble(.,modifier,.).                   |
//| INPUT:  prop_id  - property identifier,                          |
//|         modifier - property modifier,                            |
//|         value    - new value for the property.                   |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObject::SetDouble(ENUM_OBJECT_PROPERTY_DOUBLE prop_id,int modifier,double value)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetDouble(m_chart_id,m_name,prop_id,modifier,value));
  }
//+------------------------------------------------------------------+
//| Access function ObjectSetDouble(...).                            |
//| INPUT:  prop_id  - property identifier,                          |
//|         value    - new the property value.                       |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObject::SetDouble(ENUM_OBJECT_PROPERTY_DOUBLE prop_id,double value)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetDouble(m_chart_id,m_name,prop_id,value));
  }
//+------------------------------------------------------------------+
//| Access function string ObjectGetString (...).                    |
//| INPUT:  prop_id  - property identifier,                          |
//|         modifier - property modifier.                            |
//| OUTPUT: the property value.                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CChartObject::GetString(ENUM_OBJECT_PROPERTY_STRING prop_id,int modifier) const
  {
//--- checking
   if(m_chart_id==-1) return("");
//---
   if(modifier==-1) return(ObjectGetString(m_chart_id,m_name,prop_id));
//---
   return(ObjectGetString(m_chart_id,m_name,prop_id,modifier));
  }
//+------------------------------------------------------------------+
//| Access function bool ObjectGetString(...).                       |
//| INPUT:  prop_id  - property identifier,                          |
//|         modifier - property modifier,                            |
//|         value    - variable for the property value.              |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObject::GetString(ENUM_OBJECT_PROPERTY_STRING prop_id,int modifier,string& value) const
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectGetString(m_chart_id,m_name,prop_id,modifier,value));
  }
//+------------------------------------------------------------------+
//| Access function ObjectSetString(.,modifier,.).                   |
//| INPUT:  prop_id  - property identifier,                          |
//|         modifier - property modifier,                            |
//|         value    - new value for the property.                   |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObject::SetString(ENUM_OBJECT_PROPERTY_STRING prop_id,int modifier,string value)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetString(m_chart_id,m_name,prop_id,modifier,value));
  }
//+------------------------------------------------------------------+
//| Access function ObjectSetString(...).                            |
//| INPUT:  prop_id - property identifier,                           |
//|         value   - new value for the property.                    |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObject::SetString(ENUM_OBJECT_PROPERTY_STRING prop_id,string value)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetString(m_chart_id,m_name,prop_id,value));
  }
//+------------------------------------------------------------------+
//| Relative movement of object.                                     |
//| INPUT:  d_time  - increment of time coordinate,                  |
//|         d_price - increment of price coordinate.                 |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObject::ShiftObject(datetime d_time,double d_price)
  {
   bool resutl=true;
   int  i;
//--- checking
   if(m_chart_id==-1) return(false);
//--- moving
   for(i=0;i<m_num_points;i++)
      resutl&=ShiftPoint(i,d_time,d_price);
//---
   return(resutl);
  }
//+------------------------------------------------------------------+
//| Relative movement of the specified achor point of object.        |
//| INPUT:  point   - number of point,                               |
//|         d_time  - increment of time coordinate,                  |
//|         d_price - increment of price coordinat.                  |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObject::ShiftPoint(int point,datetime d_time,double d_price)
  {
//--- checking
   if(m_chart_id==-1)      return(false);
   if(point>=m_num_points) return(false);
//--- moving
   datetime time=(datetime)ObjectGetInteger(m_chart_id,m_name,OBJPROP_TIME,point);
   double   price=ObjectGetDouble(m_chart_id,m_name,OBJPROP_PRICE,point);
//---
   return(ObjectMove(m_chart_id,m_name,point,time+d_time,price+d_price));
  }
//+------------------------------------------------------------------+
//| Writing object parameters to file.                               |
//| INPUT:  file_handle - handle of file previously opened           |
//|         for writing.                                             |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObject::Save(int file_handle)
  {
   int    i,len;
   int    levels;
   string str;
//--- checking
   if(file_handle<=0) return(false);
   if(m_chart_id==-1) return(false);
//--- writing
//--- writing start marker - 0xFFFFFFFFFFFFFFFF
   if(FileWriteLong(file_handle,-1)!=sizeof(long)) return(false);
//--- writing object type
   if(FileWriteInteger(file_handle,Type(),INT_VALUE)!=INT_VALUE) return(false);
//--- writing object name
   str=ObjectGetString(m_chart_id,m_name,OBJPROP_NAME);
   len=StringLen(str);
   if(FileWriteInteger(file_handle,len,INT_VALUE)!=INT_VALUE) return(false);
   if(len!=0) if(FileWriteString(file_handle,str,len)!=len) return(false);
//--- writing object color
   if(FileWriteLong(file_handle,ObjectGetInteger(m_chart_id,m_name,OBJPROP_COLOR))!=sizeof(long)) return(false);
//--- writing object line style
   if(FileWriteInteger(file_handle,(int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_STYLE))!=sizeof(int)) return(false);
//--- writing object line width
   if(FileWriteInteger(file_handle,(int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_WIDTH))!=sizeof(int)) return(false);
//--- writing the property value "Background"
   if(FileWriteInteger(file_handle,(int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_BACK),CHAR_VALUE)!=sizeof(char)) return(false);
//--- writing the property value "Selectable"
   if(FileWriteInteger(file_handle,(int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_SELECTABLE),CHAR_VALUE)!=sizeof(char)) return(false);
//--- writing the property value "Timeframes"
   if(FileWriteInteger(file_handle,(int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_TIMEFRAMES),INT_VALUE)!=sizeof(int)) return(false);
//--- writing comment
   str=ObjectGetString(m_chart_id,m_name,OBJPROP_TEXT);
   len=StringLen(str);
   if(FileWriteInteger(file_handle,len,INT_VALUE)!=INT_VALUE) return(false);
   if(len!=0) if(FileWriteString(file_handle,str,len)!=len) return(false);
//--- writing number of points
   if(FileWriteInteger(file_handle,m_num_points,INT_VALUE)!=INT_VALUE) return(false);
//--- writing points
   for(i=0;i<m_num_points;i++)
     {
      if(FileWriteLong(file_handle,ObjectGetInteger(m_chart_id,m_name,OBJPROP_TIME,i))!=sizeof(long)) return(false);
      if(FileWriteDouble(file_handle,ObjectGetDouble(m_chart_id,m_name,OBJPROP_PRICE,i))!=sizeof(double)) return(false);
     }
//--- writing number of levels
   levels=(int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_LEVELS);
   if(FileWriteInteger(file_handle,levels,INT_VALUE)!=INT_VALUE) return(false);
//--- writing levels
   for(i=0;i<levels;i++)
     {
      //--- level color
      if(FileWriteLong(file_handle,ObjectGetInteger(m_chart_id,m_name,OBJPROP_LEVELCOLOR,i))!=sizeof(long)) return(false);
      //--- level line style
      if(FileWriteInteger(file_handle,(int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_LEVELSTYLE,i))!=sizeof(int)) return(false);
      //--- level line width
      if(FileWriteInteger(file_handle,(int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_LEVELWIDTH,i))!=sizeof(int)) return(false);
      //--- level value
      if(FileWriteDouble(file_handle,ObjectGetDouble(m_chart_id,m_name,OBJPROP_LEVELVALUE,i))!=sizeof(double)) return(false);
      //--- level name
      str=ObjectGetString(m_chart_id,m_name,OBJPROP_LEVELTEXT,i);
      len=StringLen(str);
      if(FileWriteInteger(file_handle,len,INT_VALUE)!=INT_VALUE) return(false);
      if(len!=0) if(FileWriteString(file_handle,str,len)!=len) return(false);
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Reading object parameters from file.                             |
//| INPUT:  file_handle - handle of file previously opened           |
//|         for reading.                                             |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObject::Load(int file_handle)
  {
   int    i,len,num;
   string str;
//--- checking
   if(file_handle<=0) return(false);
   if(m_chart_id==-1) return(false);
//--- reading
//--- reading and check start marker - 0xFFFFFFFFFFFFFFFF
   if(FileReadLong(file_handle)!=-1) return(false);
//--- reading and check object type
   if(FileReadInteger(file_handle,INT_VALUE)!=Type()) return(false);
//--- reading object name
   len=FileReadInteger(file_handle,INT_VALUE);
   if(len!=0) str=FileReadString(file_handle,len);
   else       str="";
   if(!ObjectSetString(m_chart_id,m_name,OBJPROP_NAME,str)) return(false);
//--- reading object color
   if(!ObjectSetInteger(m_chart_id,m_name,OBJPROP_COLOR,FileReadLong(file_handle))) return(false);
//--- reading object line style
   if(!ObjectSetInteger(m_chart_id,m_name,OBJPROP_STYLE,FileReadInteger(file_handle))) return(false);
//--- reading object line style
   if(!ObjectSetInteger(m_chart_id,m_name,OBJPROP_WIDTH,FileReadInteger(file_handle))) return(false);
//--- reading the property value "Background"
   if(!ObjectSetInteger(m_chart_id,m_name,OBJPROP_BACK,FileReadInteger(file_handle,CHAR_VALUE))) return(false);
//--- reading the property value "Selectable"
   if(!ObjectSetInteger(m_chart_id,m_name,OBJPROP_SELECTABLE,FileReadInteger(file_handle,CHAR_VALUE))) return(false);
//--- reading the property value "Timeframes"
   if(!ObjectSetInteger(m_chart_id,m_name,OBJPROP_TIMEFRAMES,FileReadInteger(file_handle,INT_VALUE))) return(false);
//--- reading comment
   len=FileReadInteger(file_handle,INT_VALUE);
   if(len!=0) str=FileReadString(file_handle,len);
   else       str="";
   if(!ObjectSetString(m_chart_id,m_name,OBJPROP_TEXT,str)) return(false);
//--- reading number of point
   num=FileReadInteger(file_handle,INT_VALUE);
//--- reading points
   if(num!=0)
     {
      for(i=0;i<num;i++)
        {
         if(!ObjectSetInteger(m_chart_id,m_name,OBJPROP_TIME,i,FileReadLong(file_handle))) return(false);
         if(!ObjectSetDouble(m_chart_id,m_name,OBJPROP_PRICE,i,FileReadDouble(file_handle))) return(false);
        }
     }
//--- reading number of levels
   num=FileReadInteger(file_handle,INT_VALUE);
   if(!ObjectSetInteger(m_chart_id,m_name,OBJPROP_LEVELS,0,FileReadLong(file_handle))) return(false);
//--- reading levels
   if(num!=0)
     {
      for(i=0;i<num;i++)
        {
         //--- level color
         if(!ObjectSetInteger(m_chart_id,m_name,OBJPROP_LEVELCOLOR,i,FileReadLong(file_handle))) return(false);
         //--- levelline style
         if(!ObjectSetInteger(m_chart_id,m_name,OBJPROP_LEVELSTYLE,i,FileReadInteger(file_handle))) return(false);
         //--- level line width
         if(!ObjectSetInteger(m_chart_id,m_name,OBJPROP_LEVELWIDTH,i,FileReadInteger(file_handle))) return(false);
         //--- level value
         if(!ObjectSetDouble(m_chart_id,m_name,OBJPROP_LEVELVALUE,i,FileReadDouble(file_handle))) return(false);
         //--- level name
         len=FileReadInteger(file_handle,INT_VALUE);
         if(len!=0) str=FileReadString(file_handle,len);
         else       str="";
         if(!ObjectSetString(m_chart_id,m_name,OBJPROP_LEVELTEXT,i,str)) return(false);
        }
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
