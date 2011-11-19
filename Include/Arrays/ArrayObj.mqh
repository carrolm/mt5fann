//+------------------------------------------------------------------+
//|                                                     ArrayObj.mqh |
//|                        Copyright 2011, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//|                                              Revision 2011.03.03 |
//+------------------------------------------------------------------+
#include "Array.mqh"
//+------------------------------------------------------------------+
//| Class CArrayObj.                                                 |
//| Puprose: Class of dynamic array of pointers to instances         |
//|          of the CObject class and its derivatives.               |
//|          Derives from class CArray.                              |
//+------------------------------------------------------------------+
class CArrayObj : public CArray
  {
protected:
   CObject          *m_data[];           // data array
   bool              m_free_mode;        // flag of necessity of "physical" deletion of object
public:
                     CArrayObj();
                    ~CArrayObj();
   //--- methods of access to protected data
   bool              FreeMode() const    { return(m_free_mode); }
   void              FreeMode(bool mode) { m_free_mode=mode;    }
   //--- method of identifying the object
   virtual int       Type() const        { return(0x7778);      }
   //--- methods for working with files
   virtual bool      Save(int file_handle);
   virtual bool      Load(int file_handle);
   //--- method of creating an element of array
   virtual bool      CreateElement(int index) { return(false);  }
   //--- methods of managing dynamic memory
   bool              Reserve(int size);
   bool              Resize(int size);
   bool              Shutdown();
   //--- methods of filling the array
   bool              Add(CObject *element);
   bool              AddArray(const CArrayObj *src);
   bool              Insert(CObject *element,int pos);
   bool              InsertArray(const CArrayObj *src,int pos);
   bool              AssignArray(const CArrayObj *src);
   //--- method of access to thre array
   CObject          *At(int index) const;
   //--- methods of changing
   bool              Update(int index,CObject *element);
   bool              Shift(int index,int shift);
   //--- methods of deleting
   CObject          *Detach(int index);
   bool              Delete(int index);
   bool              DeleteRange(int from,int to);
   void              Clear();
   //--- method for comparing arrays
   bool              CompareArray(const CArrayObj *Array) const;
   //--- methods for working with the sorted array
   bool              InsertSort(CObject *element);
   int               Search(const CObject *element) const;
   int               SearchGreat(const CObject *element) const;
   int               SearchLess(const CObject *element) const;
   int               SearchGreatOrEqual(const CObject *element) const;
   int               SearchLessOrEqual(const CObject *element) const;
   int               SearchFirst(const CObject *element) const;
   int               SearchLast(const CObject *element) const;

protected:
   void              QuickSort(int beg,int end,int mode);
   int               QuickSearch(const CObject *element) const;
   int               MemMove(int dest,int src,int count);
  };
//+------------------------------------------------------------------+
//| Constructor CArrayObj.                                           |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CArrayObj::CArrayObj()
  {
//--- initialize protected data
   m_data_max=ArraySize(m_data);
   m_free_mode=true;
  }
//+------------------------------------------------------------------+
//| Destructor CArrayObj.                                            |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CArrayObj::~CArrayObj()
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
int CArrayObj::MemMove(int dest,int src,int count)
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
      for(i=0;i<count;i++)
        {
         //--- "physical" removal of the object (if necessary and possible)
         if(m_free_mode) 
            if(CheckPointer(m_data[dest+i])==POINTER_DYNAMIC) delete m_data[dest+i];
         //---
         m_data[dest+i]=m_data[src+i];
         m_data[src+i]=NULL;
        }
     }
   else
     {
      //--- copy from right to left
      for(i=count-1;i>=0;i--)
        {
         //--- "physical" removal of the object (if necessary and possible)
         if(m_free_mode)
            if(CheckPointer(m_data[dest+i])==POINTER_DYNAMIC) delete m_data[dest+i];
         //---
         m_data[dest+i]=m_data[src+i];
         m_data[src+i]=NULL;
        }
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
bool CArrayObj::Reserve(int size)
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
      //--- explicitly zeroize all the loose items in the array
      for(int i=m_data_total;i<m_data_max;i++) m_data[i]=NULL;
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
bool CArrayObj::Resize(int size)
  {
   int new_size;
//--- checking
   if(size<0) return(false);
//--- resizing array
   new_size=m_step_resize*(1+size/m_step_resize);
   if(m_data_total>size)
     {
      //--- "physical" removal of the object (if necessary and possible)
      if(m_free_mode)
         for(int i=size;i<m_data_total;i++)
            if(CheckPointer(m_data[i])==POINTER_DYNAMIC) delete m_data[i];
      m_data_total=size;
     }
   if(m_data_max!=new_size) m_data_max=ArrayResize(m_data,new_size);
//---
   return(m_data_max==new_size);
  }
//+------------------------------------------------------------------+
//| Complete cleaning of the array with the release of memory.       |
//| INPUT:  no.                                                      |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CArrayObj::Shutdown()
  {
//--- checking
   if(m_data_max==0) return(true);
//--- cleaning
   Clear();
   if(ArrayResize(m_data,0)==-1) return(false);
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
bool CArrayObj::Add(CObject *element)
  {
//--- checking
   if(!CheckPointer(element)) return(false);
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
bool CArrayObj::AddArray(const CArrayObj *src)
  {
   int num;
//--- checking
   if(!CheckPointer(src)) return(false);
//--- checking/reserving elements of array
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
bool CArrayObj::Insert(CObject *element,int pos)
  {
//--- checking
   if(pos<0 || !CheckPointer(element)) return(false);
//--- checking/reserving elements of array
   if(!Reserve(1)) return(false);
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
//| INPUT:  src - pointer to an instance of class CArrayObj,         |
//|         pos - position where to insert.                          |
//| OUTPUT: true if OK, false if failure.                            |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CArrayObj::InsertArray(const CArrayObj *src,int pos)
  {
   int num;
//--- checking
   if(!CheckPointer(src)) return(false);
//--- checking/reserve elements of array
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
//| INPUT:  src - pointer to an instance of class CArrayObj.         |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CArrayObj::AssignArray(const CArrayObj *src)
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
//| OUTPUT: value of element in the specified position or NULL.      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CObject *CArrayObj::At(int index) const
  {
//--- checking
   if(index<0 || index>=m_data_total) return(NULL);
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
bool CArrayObj::Update(int index,CObject *element)
  {
//--- checking
   if(index<0 || !CheckPointer(element) || index>=m_data_total) return(false);
//--- "physical" removal of the object (if necessary and possible)
   if(m_free_mode)
      if(CheckPointer(m_data[index])==POINTER_DYNAMIC) delete m_data[index];
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
bool CArrayObj::Shift(int index,int shift)
  {
   CObject *tmp_node;
//--- checking
   if(index<0 || index+shift<0 || index+shift>=m_data_total) return(false);
   if(shift==0) return(true);
//--- moving
   tmp_node=m_data[index];
   m_data[index]=NULL;
   if(shift>0) MemMove(index,index+1,shift);
   else        MemMove(index+shift+1,index+shift,-shift);
   m_data[index+shift]=tmp_node;
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
bool CArrayObj::Delete(int index)
  {
//--- checking
   if(index>=m_data_total) return(false);
//--- delete
   if(index<m_data_total-1)
     {
      if(index>=0) MemMove(index,index+1,m_data_total-index-1);
     }
   else
     {
      if(m_free_mode && CheckPointer(m_data[index])==POINTER_DYNAMIC) delete m_data[index];
     }
   m_data_total--;
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Detach element from the specified position.                      |
//| INPUT:  index - position of element.                             |
//| OUTPUT: pointer (handle) of detached element.                    |
//| REMARK: does not violate the sorting.                            |
//+------------------------------------------------------------------+
CObject *CArrayObj::Detach(int index)
  {
   CObject *result;
//--- checking
   if(index>=m_data_total) return(NULL);
//--- detach
   result=m_data[index];
//--- reset the array element, so as not remove the method MemMove
   m_data[index]=NULL;
   if(index<m_data_total-1) MemMove(index,index+1,m_data_total-index-1);
   m_data_total--;
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Deleting range of elements.                                      |
//| INPUT:  from - start position of the range,                      |
//|         to   - end position of the range.                        |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: does not violate the sorting.                            |
//+------------------------------------------------------------------+
bool CArrayObj::DeleteRange(int from,int to)
  {
//--- checking
   if(from<0 || to<0)                return(false);
   if(from>to || from>=m_data_total) return(false);
//--- deleting
   if(to>=m_data_total-1) to=m_data_total-1;
   MemMove(from,to+1,m_data_total-to);
   for(int i=to-from+1;i>0;i--,m_data_total--)
      if(m_free_mode && CheckPointer(m_data[m_data_total-1])==POINTER_DYNAMIC) delete m_data[m_data_total-1];
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Clearing of array without the release of memory.                 |
//| INPUT:  no.                                                      |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CArrayObj::Clear()
  {
//--- "physical" removal of the object (if necessary and possible)
   if(m_free_mode)
     {
      for(int i=0;i<m_data_total;i++)
        {
         if(CheckPointer(m_data[i])==POINTER_DYNAMIC) delete m_data[i];
         m_data[i]=NULL;
        }
     }
   m_data_total=0;
  }
//+------------------------------------------------------------------+
//| Equality comparison of two arrays.                               |
//| INPUT:  array - pointer to an instance of class CArrayObj        |
//|         to be compared.                                          |
//| OUTPUT: true if arrays are equal, false if not.                  |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CArrayObj::CompareArray(const CArrayObj *Array) const
  {
//--- checking
   if(!CheckPointer(Array)) return(false);
//--- comparison
   if(m_data_total!=Array.m_data_total) return(false);
   for(int i=0;i<m_data_total;i++)
      if(m_data[i].Compare(Array.m_data[i],0)!=0) return(false);
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
void CArrayObj::QuickSort(int beg,int end,int mode)
  {
   int      i,j;
   CObject *p_node;
   CObject *t_node;
//--- sort
   i=beg;
   j=end;
   while(i<end)
     {
      //--- ">>1" is quick division by 2
      p_node=m_data[(beg+end)>>1];
      while(i<j)
        {
         while(m_data[i].Compare(p_node,mode)<0)
           {
            //--- control the output of the array bounds
            if(i==m_data_total-1) break;
            i++;
           }
         while(m_data[j].Compare(p_node,mode)>0)
           {
            //--- control the output of the array bounds
            if(j==0) break;
            j--;
           }
         if(i<=j)
           {
            t_node=m_data[i];
            m_data[i++]=m_data[j];
            m_data[j]=t_node;
            //--- control the output of the array bounds
            if(j==0) break;
            else     j--;
           }
        }
      if(beg<j) QuickSort(beg,j,mode);
      beg=i;
      j=end;
     }
  }
//+------------------------------------------------------------------+
//| Inserting element in a sorted array.                             |
//| INPUT:  element - element value.                                 |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: does not violate the sorting.                            |
//+------------------------------------------------------------------+
bool CArrayObj::InsertSort(CObject *element)
  {
   int pos;
//--- checking
   if(!CheckPointer(element) || m_sort_mode==-1) return(false);
//--- checking/reserving elements of array
   if(!Reserve(1)) return(false);
//--- if the array is empty, add an element
   if(m_data_total==0)
     {
      m_data[m_data_total++]=element;
      return(true);
     }
//--- find position and insert
   int mode=m_sort_mode;
   pos=QuickSearch(element);
   if(m_data[pos].Compare(element,m_sort_mode)>0) Insert(element,pos);
   else                                           Insert(element,pos+1);
//--- restore the sorting flag after Insert(...)
   m_sort_mode=mode;
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Quick search of position of element in a sorted array.           |
//| INPUT:  element - search value.                                  |
//| OUTPUT: position of the found element in the array.              |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CArrayObj::QuickSearch(const CObject *element) const
  {
   int      i,j,m=-1;
   CObject *t_node;
//--- search
   i=0;
   j=m_data_total-1;
   while(j>=i)
     {
      //--- ">>1" is quick division by 2
      m=(j+i)>>1;
      if(m<0 || m==m_data_total-1) break;
      t_node=m_data[m];
      if(t_node.Compare(element,m_sort_mode)==0) break;
      if(t_node.Compare(element,m_sort_mode)>0) j=m-1;
      else                                      i=m+1;
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
int CArrayObj::Search(const CObject *element) const
  {
   int pos;
//--- checking
   if(m_data_total==0 || !CheckPointer(element) || m_sort_mode==-1) return(-1);
//--- search
   pos=QuickSearch(element);
   if(m_data[pos].Compare(element,m_sort_mode)==0) return(pos);
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
int CArrayObj::SearchGreat(const CObject *element) const
  {
   int pos;
//--- checking
   if(m_data_total==0 || !CheckPointer(element) || m_sort_mode==-1) return(-1);
//--- search
   pos=QuickSearch(element);
   while(m_data[pos].Compare(element,m_sort_mode)<=0)
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
int CArrayObj::SearchLess(const CObject *element) const
  {
   int pos;
//--- checking
   if(m_data_total==0 || !CheckPointer(element) || m_sort_mode==-1) return(-1);
//--- searching
   pos=QuickSearch(element);
   while(m_data[pos].Compare(element,m_sort_mode)>=0)
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
int CArrayObj::SearchGreatOrEqual(const CObject *element) const
  {
   int pos;
//--- checking
   if(m_data_total==0 || !CheckPointer(element) || m_sort_mode==-1) return(-1);
//--- searching
   if((pos=SearchGreat(element))!=-1)
     {
      if(pos!=0 && m_data[pos-1].Compare(element,m_sort_mode)==0) return(pos-1);
      else                                                        return(pos);
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
int CArrayObj::SearchLessOrEqual(const CObject *element) const
  {
   int pos;
//--- checking
   if(m_data_total==0 || !CheckPointer(element) || m_sort_mode==-1) return(-1);
//--- searching
   if((pos=SearchLess(element))!=-1)
     {
      if(pos!=m_data_total-1 && m_data[pos+1].Compare(element,m_sort_mode)==0) return(pos+1);
      else                                                                     return(pos);
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
int CArrayObj::SearchFirst(const CObject *element) const
  {
   int pos;
//--- checking
   if(m_data_total==0 || !CheckPointer(element) || m_sort_mode==-1) return(-1);
//--- searching
   pos=QuickSearch(element);
   if(m_data[pos].Compare(element,m_sort_mode)==0)
     {
      while(m_data[pos].Compare(element,m_sort_mode)==0)
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
int CArrayObj::SearchLast(const CObject *element) const
  {
   int pos;
//--- checking
   if(m_data_total==0 || !CheckPointer(element) || m_sort_mode==-1) return(-1);
//--- search
   pos=QuickSearch(element);
   if(m_data[pos].Compare(element,m_sort_mode)==0)
     {
      while(m_data[pos].Compare(element,m_sort_mode)==0)
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
bool CArrayObj::Save(int file_handle)
  {
   int i=0;
//--- checking
   if(!CArray::Save(file_handle)) return(false);
//--- writing
//--- writing array length
   if(FileWriteInteger(file_handle,m_data_total,INT_VALUE)!=INT_VALUE) return(false);
//--- writing array
   for(i=0;i<m_data_total;i++)
      if(m_data[i].Save(file_handle)!=true) break;
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
bool CArrayObj::Load(int file_handle)
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
            //--- create new element
            if(!CreateElement(i)) break;
            if(m_data[i].Load(file_handle)!=true) break;
            m_data_total++;
           }
        }
     }
   m_sort_mode=-1;
//---
   return(m_data_total==num);
  }
//+------------------------------------------------------------------+