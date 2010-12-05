//+------------------------------------------------------------------+
//|                                                   ArrayFloat.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//|                                              Revision 2010.10.29 |
//+------------------------------------------------------------------+
#include "Array.mqh"
//+------------------------------------------------------------------+
//| Class CArrayFloat.                                               |
//| Purpose: Class of dynamic array of variable                      |
//|          of float type.                                          |
//|          Derives from class CArray.                              |
//+------------------------------------------------------------------+
class CArrayFloat : public CArray
  {
protected:
   float             m_data[];           // data array
   float             m_delta;            // search tolerance
public:
                     CArrayFloat();
                    ~CArrayFloat();
   //--- methods of access to protected data
   void              Delta(float delta)  { m_delta=(float)MathAbs(delta); }
   //--- method of identifying the object
   virtual int       Type() const        { return(TYPE_FLOAT);            }
   //--- methods for working with files
   virtual bool      Save(int file_handle);
   virtual bool      Load(int file_handle);
   //--- methods of managing dynamic memory
   bool              Reserve(int size);
   bool              Resize(int size);
   bool              Shutdown();
   //--- methods of filling the array
   bool              Add(float element);
   bool              AddArray(const float &src[]);
   bool              AddArray(const CArrayFloat *src);
   bool              Insert(float element,int pos);
   bool              InsertArray(const float &src[],int pos);
   bool              InsertArray(const CArrayFloat *src,int pos);
   bool              AssignArray(const float &src[]);
   bool              AssignArray(const CArrayFloat *src);
   //--- method of access to the array
   float             At(int index) const;
   //--- methods of changing
   bool              Update(int index,float element);
   bool              Shift(int index,int shift);
   //--- methods deleting
   bool              Delete(int index);
   bool              DeleteRange(int from,int to);
   //--- methods for comparing arrays
   bool              CompareArray(const float &Array[]) const;
   bool              CompareArray(const CArrayFloat *Array) const;
   //--- methods for working with the sorted array
   bool              InsertSort(float element);
   int               Search(float element) const;
   int               SearchGreat(float element) const;
   int               SearchLess(float element) const;
   int               SearchGreatOrEqual(float element) const;
   int               SearchLessOrEqual(float element) const;
   int               SearchFirst(float element) const;
   int               SearchLast(float element) const;
protected:
   virtual void      QuickSort(int beg,int end,int mode=0);
   int               QuickSearch(float element) const;
   int               MemMove(int dest,int src,int count);
  };
//+------------------------------------------------------------------+
//| Constructor CArrayFloat.                                         |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CArrayFloat::CArrayFloat()
  {
//--- initialize protected data
   m_data_max=ArraySize(m_data);
   m_delta=0.0;
  }
//+------------------------------------------------------------------+
//| Destructor CArrayFloat.                                          |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CArrayFloat::~CArrayFloat()
  {
   if(m_data_max!=0) Shutdown();
  }
//+------------------------------------------------------------------+
//| Moving the memory within a single array.                         |
//| INPUT:  dest  - index-receiver,                                  |
//|         src   - index-source,                                    |
//|         count - number of elements to move.                      |
//| OUTPUT: dest in case of success, -1 in case of failure.          |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CArrayFloat::MemMove(int dest,int src,int count)
  {
   int i;
//--- checking
   if(dest<0 || src<0 || count<0) return(-1);
   if(dest+count>m_data_total)
     {
      if(Available()<dest+count) return(-1);
      else                       m_data_total=dest+count;
     }
//--- no need to copy
   if(dest==src || count==0) return(dest);
//--- copy
   if(dest<src)
     {
      //--- copy from left to right
      for(i=0;i<count;i++) m_data[dest+i]=m_data[src+i];
     }
   else
     {
      //--- copy from right to left
      for(i=count-1;i>=0;i--) m_data[dest+i]=m_data[src+i];
     }
//---
   return(dest);
  }
//+------------------------------------------------------------------+
//| Request for more memory in an array. Checks if the requested     |
//| number of free elements already exists; allocates additional     |
//| memory with a given step.                                        |
//| INPUT:  size - requested number of free elements.                |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CArrayFloat::Reserve(int size)
  {
   int new_size;
//--- checking
   if(size<=0) return(false);
//--- resizing array
   if(Available()<size)
     {
      new_size=m_data_max+m_step_resize*(1+(size-Available())/m_step_resize);
      if(new_size<0)
        {
         //--- overflow occurred when calculating new_size
         return(false);
        }
      m_data_max=ArrayResize(m_data,new_size);
     }
//---
   return(Available()>=size);
  }
//+------------------------------------------------------------------+
//| Resizing (with removal of elements on the right).                |
//| INPUT:  size - new size of array.                                |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CArrayFloat::Resize(int size)
  {
   int new_size;
//--- checking
   if(size<0) return(false);
//--- resizing array
   new_size=m_step_resize*(1+(size-Available())/m_step_resize);
   if(m_data_max!=new_size) m_data_max=ArrayResize(m_data,new_size);
   if(m_data_total>size) m_data_total=size;
//---
   return(m_data_max==new_size);
  }
//+------------------------------------------------------------------+
//| Complete cleaning of the array with the release of memory.       |
//| INPUT:  no.                                                      |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CArrayFloat::Shutdown()
  {
//--- checking
   if(m_data_max==0) return(true);
//--- cleaning
   if(ArrayResize(m_data,0)==-1) return(false);
   m_data_total=0;
   m_data_max=0;
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Adding an element to the end of the array.                       |
//| INPUT:  element - variable to be added.                          |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CArrayFloat::Add(float element)
  {
//--- checking/reserving elements of array
   if(!Reserve(1)) return(false);
//--- adding
   m_data[m_data_total++]=element;
   m_sort_mode=-1;
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Adding an element to the end of the array from another array.    |
//| INPUT:  src - source array.                                      |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CArrayFloat::AddArray(const float &src[])
  {
   int num=ArraySize(src);
//--- checking/reserve elements of array
   if(!Reserve(num)) return(false);
//--- adding
   for(int i=0;i<num;i++) m_data[m_data_total++]=src[i];
   m_sort_mode=-1;
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Adding an element to the end of the array from another array.    |
//| INPUT:  src - pointer to an instance of class CArrayFloat.       |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CArrayFloat::AddArray(const CArrayFloat *src)
  {
   int num;
//--- checking
   if(!CheckPointer(src)) return(false);
//--- checking/reserve elements of array
   num=src.Total();
   if(!Reserve(num)) return(false);
//--- adding
   for(int i=0;i<num;i++) m_data[m_data_total++]=src.m_data[i];
   m_sort_mode=-1;
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Inserting an element in the specified position.                  |
//| INPUT:  element - variable to be inserted,                       |
//|         pos     - position where to insert.                      |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CArrayFloat::Insert(float element,int pos)
  {
//--- checking/reserving elements of array
   if(pos<0 || !Reserve(1)) return(false);
//--- inserting
   m_data_total++;
   if(pos<m_data_total-1)
     {
      MemMove(pos+1,pos,m_data_total-pos-1);
      m_data[pos]=element;
     }
   else
      m_data[m_data_total-1]=element;
   m_sort_mode=-1;
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Inserting elements in the specified position.                    |
//| INPUT:  src - source array,                                      |
//|         pos - position where to insert.                          |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CArrayFloat::InsertArray(const float &src[],int pos)
  {
   int num=ArraySize(src);
//--- checking/reserving elements of array
   if(!Reserve(num)) return(false);
//--- inserting
   MemMove(num+pos,pos,m_data_total-pos);
   for(int i=0;i<num;i++) m_data[i+pos]=src[i];
   m_sort_mode=-1;
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Inserting elements in the specified position.                    |
//| INPUT:  src - pointer to an instance of class CArrayFloat,       |
//|         pos - position where to insert.                          |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CArrayFloat::InsertArray(const CArrayFloat *src,int pos)
  {
   int num;
//--- checking
   if(!CheckPointer(src)) return(false);
//--- checking/reserving elements of array
   num=src.Total();
   if(!Reserve(num)) return(false);
//--- inserting
   MemMove(num+pos,pos,m_data_total-pos);
   for(int i=0;i<num;i++) m_data[i+pos]=src.m_data[i];
   m_sort_mode=-1;
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Assignment (copying) of another array.                           |
//| INPUT:  src - source array.                                      |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CArrayFloat::AssignArray(const float &src[])
  {
   int num=ArraySize(src);
//--- checking/reserve elements of array
   Clear();
   if(m_data_max<num)
     {
      if(!Reserve(num)) return(false);
     }
   else   Resize(num);
//--- copying array
   for(int i=0;i<num;i++)
     {
      m_data[i]=src[i];
      m_data_total++;
     }
   m_sort_mode=-1;
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Assignment (copying) of another array.                           |
//| INPUT:  src - pointer to an instance of class CArrayFloat.       |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CArrayFloat::AssignArray(const CArrayFloat *src)
  {
   int num;
//--- checking
   if(!CheckPointer(src)) return(false);
//--- checking/reserve elements of array
   num=src.m_data_total;
   Clear();
   if(m_data_max<num)
     {
      if(!Reserve(num)) return(false);
     }
   else   Resize(num);
//--- copying array
   for(int i=0;i<num;i++)
     {
      m_data[i]=src.m_data[i];
      m_data_total++;
     }
   m_sort_mode=src.SortMode();
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Access to data in the specified position.                        |
//| INPUT:  index - position of element.                             |
//| OUTPUT: value of element in the specified position or FLT_MAX.   |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
float CArrayFloat::At(int index) const
  {
//--- checking
   if(index<0 || index>=m_data_total) return(FLT_MAX);
//---
   return(m_data[index]);
  }
//+------------------------------------------------------------------+
//| Updating element in the specified position.                      |
//| INPUT:  index   - position of element,                           |
//|         element - new value of element.                          |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CArrayFloat::Update(int index,float element)
  {
//--- checking
   if(index<0 || index>=m_data_total) return(false);
//--- updating
   m_data[index]=element;
   m_sort_mode=-1;
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Moving element from the specified position                       |
//| on the specified shift.                                          |
//| INPUT:  index - position of element,                             |
//|         shift - shift value                                      |
//|                 shift>0 - to the right,shift<0 - to the left.    |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CArrayFloat::Shift(int index,int shift)
  {
   float tmp_float;
//--- checking
   if(index<0 || index+shift<0 || index+shift>=m_data_total) return(false);
   if(shift==0) return(true);
//--- moving
   tmp_float=m_data[index];
   if(shift>0) MemMove(index,index+1,shift);
   else        MemMove(index+shift+1,index+shift,-shift);
   m_data[index+shift]=tmp_float;
   m_sort_mode=-1;
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Deleting element from the specified position.                    |
//| INPUT:  index - position of element.                             |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: does not violate the sorting.                            |
//+------------------------------------------------------------------+
bool CArrayFloat::Delete(int index)
  {
//--- checking
   if(index<0 || index>=m_data_total) return(false);
//--- deleting
   if(index<m_data_total-1) MemMove(index,index+1,m_data_total-index-1);
   m_data_total--;
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Deleting range of elements.                                      |
//| INPUT:  from - start position of the range,                      |
//|         to   - end position of the range.                        |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: does not violate the sorting.                            |
//+------------------------------------------------------------------+
bool CArrayFloat::DeleteRange(int from,int to)
  {
//--- checking
   if(from<0 || to<0)                return(false);
   if(from>to || from>=m_data_total) return(false);
//--- deleting
   if(to>=m_data_total-1) to=m_data_total-1;
   MemMove(from,to+1,m_data_total-to);
   m_data_total-=to-from+1;
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Equality comparison of two arrays.                               |
//| INPUT:  array - array to be compared.                            |
//| OUTPUT: true if arrays are equal, false if not.                  |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CArrayFloat::CompareArray(const float &Array[]) const
  {
//--- comparison
   if(m_data_total!=ArraySize(Array)) return(false);
   for(int i=0;i<m_data_total;i++)
      if(m_data[i]!=Array[i]) return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Equality comparison of two arrays.                               |
//| INPUT:  array - pointer to an instance of class CArrayFloat      |
//|         to be compared.                                          |
//| OUTPUT: true if arrays are equal, false if not.                  |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CArrayFloat::CompareArray(const CArrayFloat *Array) const
  {
//--- checking
   if(!CheckPointer(Array)) return(false);
//--- comparison
   if(m_data_total!=Array.m_data_total) return(false);
   for(int i=0;i<m_data_total;i++)
      if(m_data[i]!=Array.m_data[i]) return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Method QuickSort.                                                |
//| INPUT:  beg - start of sorting range,                            |
//|         end - end of sorting range,                              |
//|         mode - mode of sorting.                                  |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CArrayFloat::QuickSort(int beg,int end,int mode)
  {
   int   i,j;
   float p_float,t_float;
//--- checking
   if(beg<0 || end<0) return;
//--- sort
   i=beg;
   j=end;
   while(i<end)
     {
      //--- ">>1" is quick division by 2
      p_float=m_data[(beg+end)>>1];
      while(i<j)
        {
         while(m_data[i]<p_float)
           {
            //--- control the output of the array bounds
            if(i==m_data_total-1) break;
            i++;
           }
         while(m_data[j]>p_float)
           {
            //--- control the output of the array bounds
            if(j==0) break;
            j--;
           }
         if(i<=j)
           {
            t_float =m_data[i];
            m_data[i++]=m_data[j];
            m_data[j]=t_float;
            //--- control the output of the array bounds
            if(j==0) break;
            else     j--;
           }
        }
      if(beg<j) QuickSort(beg,j);
      beg=i;
      i=beg;
      j=end;
     }
  }
//+------------------------------------------------------------------+
//| Inserting element in a sorted array.                             |
//| INPUT:  element - element value.                                 |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: does not violate the sorting.                            |
//+------------------------------------------------------------------+
bool CArrayFloat::InsertSort(float element)
  {
   int pos;
//--- checking
   if(!IsSorted()) return(false);
//--- checking/reserving elements of array
   if(!Reserve(1)) return(false);
//--- if the array is empty, add an element
   if(m_data_total==0)
     {
      m_data[m_data_total++]=element;
      return(true);
     }
//--- search position and insert
   pos=QuickSearch(element);
   if(m_data[pos]>element) Insert(element,pos);
   else                    Insert(element,pos+1);
//--- restore the sorting flag after Insert(...)
   m_sort_mode=0;
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Quick search of position of element in a sorted array.           |
//| INPUT:  element - search value.                                  |
//| OUTPUT: position of the found element in the array.              |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CArrayFloat::QuickSearch(float element) const
  {
   int   i,j,m=-1;
   float t_float;
//--- search
   i=0;
   j=m_data_total-1;
   while(j>=i)
     {
      //--- ">>1" is quick division by 2
      m=(j+i)>>1;
      if(m<0 || m>=m_data_total) break;
      t_float=m_data[m];
      //--- compared with a tolerance
      if(MathAbs(t_float-element)<=m_delta) break;
      if(t_float>element) j=m-1;
      else                i=m+1;
     }
//---
   return(m);
  }
//+------------------------------------------------------------------+
//| Search of position of element in a sorted array.                 |
//| INPUT:  element - search value.                                  |
//| OUTPUT: position of the found element in the array or -1.        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CArrayFloat::Search(float element) const
  {
   int pos;
//--- checking
   if(m_data_total==0 || !IsSorted()) return(-1);
//--- searching
   pos=QuickSearch(element);
//--- comparing with the tolerance
   if(MathAbs(m_data[pos]-element)<=m_delta) return(pos);
//---
   return(-1);
  }
//+------------------------------------------------------------------+
//| Search position of the first element which is greater than       |
//| specified in a sorted array.                                     |
//| INPUT:  element - search value.                                  |
//| OUTPUT: position of the found element in the array or -1.        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CArrayFloat::SearchGreat(float element) const
  {
   int pos;
//--- checking
   if(m_data_total==0 || !IsSorted()) return(-1);
//--- searching
   pos=QuickSearch(element);
//--- comparing with the tolerance
   while(m_data[pos]<=element+m_delta)
      if(++pos==m_data_total) return(-1);
//---
   return(pos);
  }
//+------------------------------------------------------------------+
//| Search position of the first element which is less than          |
//| specified in the sorted array.                                   |
//| INPUT:  element - search value.                                  |
//| OUTPUT: position of the found element in the array or -1.        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CArrayFloat::SearchLess(float element) const
  {
   int pos;
//--- checking
   if(m_data_total==0 || !IsSorted()) return(-1);
//--- searching
   pos=QuickSearch(element);
//--- comparing with the tolerance
   while(m_data[pos]>=element-m_delta)
      if(pos--==0) return(-1);
//---
   return(pos);
  }
//+------------------------------------------------------------------+
//| Search position of the first element which is greater than or    |
//| equal to the specified in a sorted array.                        |
//| INPUT:  element - search value.                                  |
//| OUTPUT: position of the found element in the array or -1.        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CArrayFloat::SearchGreatOrEqual(float element) const
  {
   int pos;
//--- checking
   if(m_data_total==0 || !IsSorted()) return(-1);
//--- searching
   if((pos=SearchGreat(element))!=-1)
     {
      //--- comparing with the tolerance
      if(pos!=0 && MathAbs(m_data[pos-1]-element)<=m_delta) return(pos-1);
      else                                                  return(pos);
     }
//---
   return(-1);
  }
//+------------------------------------------------------------------+
//| Search position of the first element which is less than or equal |
//| to the specified in a sorted array.                              |
//| INPUT:  element - search value.                                  |
//| OUTPUT: position of the found element in the array or -1.        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CArrayFloat::SearchLessOrEqual(float element) const
  {
   int pos;
//--- checking
   if(m_data_total==0 || !IsSorted()) return(-1);
//--- searching
   if((pos=SearchLess(element))!=-1)
     {
      //--- comparing with the tolerance
      if(pos!=m_data_total-1 && MathAbs(m_data[pos+1]-element)<=m_delta) return(pos+1);
      else                                                               return(pos);
     }
//---
   return(-1);
  }
//+------------------------------------------------------------------+
//| Find position of first appearance of element in a sorted array.  |
//| INPUT:  element - search value.                                  |
//| OUTPUT: position of the found element in the array or -1.        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CArrayFloat::SearchFirst(float element) const
  {
   int pos;
//--- checking
   if(m_data_total==0 || !IsSorted()) return(-1);
//--- searching
   pos=QuickSearch(element);
   if(m_data[pos]==element)
     {
      //--- comparing with the tolerance
      while(MathAbs(m_data[pos]-element)<=m_delta)
         if(pos--==0) break;
      return(pos+1);
     }
//---
   return(-1);
  }
//+------------------------------------------------------------------+
//| Find position of last appearance of element in a sorted array.   |
//| INPUT:  element - search value.                                  |
//| OUTPUT: position of the found element in the array or -1.        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CArrayFloat::SearchLast(float element) const
  {
   int pos;
//--- checking
   if(m_data_total==0 || !IsSorted()) return(-1);
//--- searching
   pos=QuickSearch(element);
   if(m_data[pos]==element)
     {
      //--- comparing with the tolerance
      while(MathAbs(m_data[pos]-element)<=m_delta)
         if(++pos==m_data_total) break;
      return(pos-1);
     }
//---
   return(-1);
  }
//+------------------------------------------------------------------+
//| Writing array to file.                                           |
//| INPUT:  file_handle - handle of file previously                  |
//|                       opened for writing.                        |
//| OUTPUT: true if successful, else if not.                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CArrayFloat::Save(int file_handle)
  {
   int i=0;
//--- checking
   if(!CArray::Save(file_handle)) return(false);
//--- writing
//--- writing array length
   if(FileWriteInteger(file_handle,m_data_total,INT_VALUE)!=INT_VALUE) return(false);
//--- writing array
   for(i=0;i<m_data_total;i++)
      if(FileWriteFloat(file_handle,m_data[i])!=sizeof(float)) break;
//---
   return(i==m_data_total);
  }
//+------------------------------------------------------------------+
//| Reading array from file.                                         |
//| INPUT:  file_handle - handle of file previously                  |
//|                       opened for reading.                        |
//| OUTPUT: true if successful, else if not.                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CArrayFloat::Load(int file_handle)
  {
   int i=0,num;
//--- checking
   if(!CArray::Load(file_handle)) return(false);
//--- reading
//--- reading array length
   num=FileReadInteger(file_handle,INT_VALUE);
//--- reading array
   Clear();
   if(num!=0)
     {
      if(Reserve(num))
        {
         for(i=0;i<num;i++)
           {
            m_data[i]=FileReadFloat(file_handle);
            m_data_total++;
            if(FileIsEnding(file_handle)) break;
           }
        }
     }
   m_sort_mode=-1;
//---
   return(m_data_total==num);
  }
//+------------------------------------------------------------------+
