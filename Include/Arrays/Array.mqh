//+------------------------------------------------------------------+
//|                                                        Array.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//|                                              Revision 2010.02.22 |
//+------------------------------------------------------------------+
#include <Object.mqh>
//+------------------------------------------------------------------+
//| Class CArray.                                                    |
//| Purpose: Base class of dynamic arrays.                           |
//|              Derives from class CObject.                         |
//+------------------------------------------------------------------+
class CArray : public CObject
  {
protected:
   int               m_step_resize;      // increment size of the array
   int               m_data_total;       // number of elements
   int               m_data_max;         // maximmum size of the array without memory reallocation
   int               m_sort_mode;        // mode of array sorting
public:
                     CArray();
   //--- methods of access to protected data
   int               Step() const               { return(m_step_resize);           }
   bool              Step(int step);
   int               Total() const              { return(m_data_total);            }
   int               Available() const          { return(m_data_max-m_data_total); }
   int               Max() const                { return(m_data_max);              }
   bool              IsSorted(int mode=0) const { return(m_sort_mode==mode);       }
   int               SortMode() const           { return(m_sort_mode);             }
   //--- cleaning method
   void              Clear()                    { m_data_total=0;                  }
   //--- methods for working with files
   virtual bool      Save(int file_handle);
   virtual bool      Load(int file_handle);
   //--- sorting method
   void              Sort(int mode=0);
protected:
   virtual void      QuickSort(int beg,int end,int mode=0) { return; }
  };
//+------------------------------------------------------------------+
//| Constructor CArray.                                              |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CArray::CArray()
  {
//--- initialize protected data
   m_step_resize=16;
   m_data_total =0;
   m_data_max   =0;
   m_sort_mode =-1;
  }
//+------------------------------------------------------------------+
//| Method Set for variable m_step_resize.                           |
//| INPUT:  step - new value for the variable.                       |
//| OUTPUT: false if you try to assign 0, else - true.               |
//| REMARK: value is not changed if you try to assign 0.             |
//+------------------------------------------------------------------+
bool CArray::Step(int step)
  {
//--- checking
   if(step<=0) return(false);
//---
   m_step_resize=step;
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Sorting an array in ascending order.                             |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CArray::Sort(int mode)
  {
//--- checking
   if(IsSorted(mode))  return;
   m_sort_mode=mode;
   if(m_data_total<=1) return;
//--- sorting
   QuickSort(0,m_data_total-1,mode);
  }
//+------------------------------------------------------------------+
//| Writing header of array to file.                                 |
//| INPUT:  file_handle - handle of file previously                  |
//|                       opened for writing.                        |
//| OUTPUT: true if successful, else - false.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CArray::Save(int file_handle)
  {
   int i=0;
//--- checking
   if(file_handle<0) return(false);
//--- writing
//--- writing start marker - 0xFFFFFFFFFFFFFFFF
   if(FileWriteLong(file_handle,-1)!=sizeof(long)) return(false);
//--- writing array type
   if(FileWriteInteger(file_handle,Type(),INT_VALUE)!=INT_VALUE) return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Reading header of array from file.                               |
//| INPUT:  file_handle - handle of file previously                  |
//|                       opened for reading.                        |
//| OUTPUT: true if successful, else - false.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CArray::Load(int file_handle)
  {
//--- checking
   if(file_handle<0) return(false);
//--- reading
//--- reading and checking start marker - 0xFFFFFFFFFFFFFFFF
   if(FileReadLong(file_handle)!=-1) return(false);
//--- reading and checking array type
   if(FileReadInteger(file_handle,INT_VALUE)!=Type()) return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+

