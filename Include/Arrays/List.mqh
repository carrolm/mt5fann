//+------------------------------------------------------------------+
//|                                                         List.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//|                                              Revision 2010.10.21 |
//+------------------------------------------------------------------+
#include <Object.mqh>
//+------------------------------------------------------------------+
//| Class CList.                                                     |
//| Purpose: Provides the possibility of working with the list of    |
//|          CObject instances and its dervivatives                  |
//|          Derives from class CObject.                             |
//+------------------------------------------------------------------+
class CList : public CObject
  {
protected:
   CObject          *m_first_node;       // pointer to the first element of the list
   CObject          *m_last_node;        // pointer to the last element of the list
   CObject          *m_curr_node;        // pointer to the current element of the list
   int               m_curr_idx;         // index of the current list item
   int               m_data_total;       // number of elements
   bool              m_free_mode;        // flag of the necessity of "physical" deletion of object
   bool              m_data_sort;        // flag if the list is sorted or not
   int               m_sort_mode;        // mode of sorting of array
public:
   void              CList();
   void             ~CList();
   //--- methods of access to protected data
   bool              FreeMode() const          { return(m_free_mode);  }
   void              FreeMode(bool mode)       { m_free_mode=mode;     }
   int               Total() const             { return(m_data_total); }
   bool              IsSorted() const          { return(m_data_sort);  }
   int               SortMode() const          { return(m_sort_mode);  }
   //--- method of identifying the object
   virtual int       Type() const              { return(0x7779);       }
   //--- methods for working with files
   virtual bool      Save(int file_handle);
   virtual bool      Load(int file_handle);
   //--- method of creating an element of the list
   virtual CObject  *CreateElement()           { return(NULL);         }
   //--- methods of filling the list
   int               Add(CObject *new_node);
   int               Insert(CObject *new_node,int index);
   //--- methods for navigating
   int               IndexOf(CObject *node);
   CObject          *GetNodeAtIndex(int index);
   CObject          *GetFirstNode();
   CObject          *GetPrevNode();
   CObject          *GetCurrentNode();
   CObject          *GetNextNode();
   CObject          *GetLastNode();
   //--- methods for deleting
   CObject          *DetachCurrent();
   bool              DeleteCurrent();
   bool              Delete(int index);
   void              Clear();
   //--- method for comparing lists
   bool              CompareList(CList *List);
   //--- methods for changing
   void              Sort(int mode);
   bool              MoveToIndex(int index);
   bool              Exchange(CObject *node1,CObject *node2);
   //--- method for searching
   CObject          *Search(CObject *element);
protected:
   void              QuickSort(int beg,int end,int mode);
   CObject          *QuickSearch(CObject *element);
  };
//+------------------------------------------------------------------+
//| Constructor CList.                                               |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CList::CList()
  {
//--- initialize protected data
   m_first_node=NULL;
   m_last_node =NULL;
   m_curr_node =NULL;
   m_curr_idx  =-1;
   m_data_total=0;
   m_free_mode =true;
   m_data_sort =false;
   m_sort_mode =0;
  }
//+------------------------------------------------------------------+
//| Destructor CList.                                                |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CList::~CList()
  {
   Clear();
  }
//+------------------------------------------------------------------+
//| Method QuickSort.                                                |
//| INPUT:  beg  - start of sorting range,                           |
//|         end  - end of sorting range,                             |
//|         mode - mode of sorting.                                  |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CList::QuickSort(int beg,int end,int mode)
  {
   int      i,j,k;
   CObject *i_ptr,*j_ptr,*k_ptr;
//---
   i_ptr=GetNodeAtIndex(i=beg);
   j_ptr=GetNodeAtIndex(j=end);
   while(i<end)
     {
      //--- ">>1" is quick division by 2
      k_ptr=GetNodeAtIndex(k=(beg+end)>>1);
      while(i<j)
        {
         while(i_ptr.Compare(k_ptr,mode)<0)
           {
            //--- control the output of the array bounds
            if(i==m_data_total-1) break;
            i++;
            i_ptr=i_ptr.Next();
           }
         while(j_ptr.Compare(k_ptr,mode)>0)
           {
            //--- control the output of the array bounds
            if(j==0) break;
            j--;
            j_ptr=j_ptr.Prev();
           }
         if(i<=j)
           {
            Exchange(i_ptr,j_ptr);
            i++;
            i_ptr=GetNodeAtIndex(i);
            //--- control the output of the array bounds
            if(j==0) break;
            else
              {
               j--;
               j_ptr=GetNodeAtIndex(j);
              }
           }
        }
      if(beg<j) QuickSort(beg,j,mode);
      beg=i;
      i_ptr=GetNodeAtIndex(i=beg);
      j_ptr=GetNodeAtIndex(j=end);
     }
  }
//+------------------------------------------------------------------+
//| Index of element specified via the pointer to the list item.     |
//| INPUT:  node - pointer to an element in the list.                |
//| OUTPUT: position of the element in the list, or -1.              |
//| REMARK: curr_node is moved to found element, or stays unchanged. |
//+------------------------------------------------------------------+
int CList::IndexOf(CObject *node)
  {
//--- checking
   if(!CheckPointer(node) || !CheckPointer(m_curr_node)) return(-1);
//--- searching index
   if(node==m_curr_node)    return(m_curr_idx);
   if(GetFirstNode()==node) return(0);
   for(int i=1;i<m_data_total;i++)
      if(GetNextNode()==node) return(i);
//---
   return(-1);
  }
//+------------------------------------------------------------------+
//| Adding a new element to the end of the list.                     |
//| INPUT:  new_node - pointer to a new element to add.              |
//| OUTPUT: index of the element added to the list.                  |
//| REMARK: curr_node is moved to the element that is added.         |
//+------------------------------------------------------------------+
int CList::Add(CObject *new_node)
  {
//--- checking
   if(!CheckPointer(new_node)) return(-1);
//--- adding
   if(m_first_node==NULL)
      m_first_node=new_node;
   else
     {
      m_last_node.Next(new_node);
      new_node.Prev(m_last_node);
     }
   m_curr_node=new_node;
   m_curr_idx=m_data_total;
   m_last_node=new_node;
   m_data_sort=false;
//---
   return(m_data_total++);
  }
//+------------------------------------------------------------------+
//| Inserting a new element to the specified position in the list.   |
//| Inserting element to the current position of the list if index=-1|
//| INPUT:  new_node - pointer to a new element to be inserted.      |
//|         index    - position of the list where to insert.         |
//| OUTPUT: index of item inserted in the list, or -1.               |
//| REMARK: curr_node is moved to the element that is inserted.      |
//+------------------------------------------------------------------+
int CList::Insert(CObject *new_node,int index)
  {
   CObject *tmp_node;
//--- checking
   if(!CheckPointer(new_node))        return(-1);
   if(index>m_data_total || index<0)  return(-1);
//--- adjustment
   if(index==-1)
     {
      if(m_curr_node==NULL)           return(Add(new_node));
     }
   else
     {
      if(GetNodeAtIndex(index)==NULL) return(Add(new_node));
     }
//--- no need to check m_curr_node
   tmp_node=m_curr_node.Prev();
   new_node.Prev(tmp_node);
   if(tmp_node!=NULL) tmp_node.Next(new_node);
   else               m_first_node=new_node;
   new_node.Next(m_curr_node);
   m_curr_node.Prev(new_node);
   m_data_total++;
   m_data_sort=false;
//---
   return(index);
  }
//+------------------------------------------------------------------+
//| Get a pointer to the position of element in the list.            |
//| INPUT:  index - position in the list.                            |
//| OUTPUT: pointer to the found item, or NULL.                      |
//| REMARK: curr_node is moved to found item or stays unchanged.     |
//+------------------------------------------------------------------+
CObject *CList::GetNodeAtIndex(int index)
  {
   int      i;
   bool     revers;
   CObject *result;
//--- checking
   if(index>=m_data_total) return(NULL);
   if(index==m_curr_idx)   return(m_curr_node);
//--- optimize bust list
   if(index<m_curr_idx)
     {
      //--- index to the left of the current
      if(m_curr_idx-index<index)
        {
         //--- closer to the current index
         i=m_curr_idx;
         revers=true;
         result=m_curr_node;
        }
      else
        {
         //--- closer to the top of the list
         i=0;
         revers=false;
         result=m_first_node;
        }
     }
   else
     {
      //--- index to the right of the current
      if(index-m_curr_idx<m_data_total-index-1)
        {
         //--- closer to the current index
         i=m_curr_idx;
         revers=false;
         result=m_curr_node;
        }
      else
        {
         //--- closer to the end of the list
         i=m_data_total-1;
         revers=true;
         result=m_last_node;
        }
     }
   if(!CheckPointer(result)) return(NULL);
//---
   if(revers)
     {
      //--- search from right to left
      for(;i>index;i--)
        {
         result=result.Prev();
         if(result==NULL) return(NULL);
        }
     }
   else
     {
      //--- search from left to right
      for(;i<index;i++)
        {
         result=result.Next();
         if(result==NULL) return(NULL);
        }
     }
   m_curr_idx=index;
//---
   return(m_curr_node=result);
  }
//+------------------------------------------------------------------+
//| Get a pointer to the first itme of the list.                     |
//| INPUT:  no.                                                      |
//| OUTPUT: pointer to the found item, or NULL.                      |
//| REMARK: curr_node is moved to found item or stays unchanged.     |
//+------------------------------------------------------------------+
CObject *CList::GetFirstNode()
  {
//--- checking
   if(!CheckPointer(m_first_node)) return(NULL);
//---
   m_curr_idx=0;
//---
   return(m_curr_node=m_first_node);
  }
//+------------------------------------------------------------------+
//| Get a pointer to the previous itme of the list.                  |
//| INPUT:  no.                                                      |
//| OUTPUT: pointer to the found item, or NULL.                      |
//| REMARK: curr_node is moved to found item or stays unchanged.     |
//+------------------------------------------------------------------+
CObject *CList::GetPrevNode()
  {
//--- checking
   if(!CheckPointer(m_curr_node) || m_curr_node.Prev()==NULL) return(NULL);
//---
   m_curr_idx--;
//---
   return(m_curr_node=m_curr_node.Prev());
  }
//+------------------------------------------------------------------+
//| Get a pointer to the current item of the list.                   |
//| INPUT:  no.                                                      |
//| OUTPUT: pointer to the found item, or NULL.                      |
//| REMARK: curr_node is moved to found item or stays unchanged.     |
//+------------------------------------------------------------------+
CObject *CList::GetCurrentNode()
  {
   return(m_curr_node);
  }
//+------------------------------------------------------------------+
//| Get a pointer to the next item of the list.                      |
//| INPUT:  no.                                                      |
//| OUTPUT: pointer to the found item, or NULL.                      |
//| REMARK: curr_node is moved to found item or stays unchanged.     |
//+------------------------------------------------------------------+
CObject *CList::GetNextNode()
  {
//--- checking
   if(!CheckPointer(m_curr_node) || m_curr_node.Next()==NULL) return(NULL);
//---
   m_curr_idx++;
//---
   return(m_curr_node=m_curr_node.Next());
  }
//+------------------------------------------------------------------+
//| Get a pointer to the last itme of the list.                      |
//| INPUT:  no.                                                      |
//| OUTPUT: pointer to the found item, or NULL.                      |
//| REMARK: curr_node is moved to found item or stays unchanged.     |
//+------------------------------------------------------------------+
CObject *CList::GetLastNode()
  {
//--- checking
   if(!CheckPointer(m_last_node)) return(NULL);
//---
   m_curr_idx=m_data_total-1;
//---
   return(m_curr_node=m_last_node);
  }
//+------------------------------------------------------------------+
//| Detach current item in the list.                                 |
//| INPUT:  no.                                                      |
//| OUTPUT: pointer to the detached item, or NULL.                   |
//| REMARK: curr_node is moved to the element next to the deleted    |
//|         one or stays unchanged.                                  |
//+------------------------------------------------------------------+
CObject *CList::DetachCurrent()
  {
   CObject *tmp_node,*result=NULL;
//--- checking
   if(!CheckPointer(m_curr_node)) return(result);
//--- "exploding" list
   result=m_curr_node;
   m_curr_node=NULL;
//--- if the deleted item was not the last one, pull up the "tail" of the list
   if((tmp_node=result.Next())!=NULL)
     {
      tmp_node.Prev(result.Prev());
      m_curr_node=tmp_node;
     }
//--- if the deleted item was not the first one, pull up "head" list
   if((tmp_node=result.Prev())!=NULL)
     {
      tmp_node.Next(result.Next());
      //--- if "last_node" is removed, move the current pointer to the end of the list
      if(m_curr_node==NULL)
        {
         m_curr_node=tmp_node;
         m_curr_idx=m_data_total-1;
        }
     }
   m_data_total--;
//--- if necessary, adjust the settings of the first and last elements
   if(m_first_node==result) m_first_node=result.Next();
   if(m_last_node==result)  m_last_node=result.Prev();
//--- complete the processing of element removed from the list
//--- remove references to the list
   result.Prev(NULL);
   result.Next(NULL);
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Delete current item of list item.                                |
//| INPUT:  no.                                                      |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: curr_node is moved to the element next to the deleted    |
//|         one or stays unchanged.                                  |
//+------------------------------------------------------------------+
bool CList::DeleteCurrent()
  {
   CObject *result=DetachCurrent();
//--- checking
   if(result==NULL) return(false);
//--- complete the processing of element removed from the list
   if(m_free_mode)
     {
      //--- delete it "physically"
      if(CheckPointer(result)==POINTER_DYNAMIC) delete result;
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Delete an item from a given position in the list.                |
//| INPUT:  index - position of element to be removed from the list. |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: curr_node is moved to the element next to the deleted    |
//|         one or stays unchanged.                                  |
//+------------------------------------------------------------------+
bool CList::Delete(int index)
  {
   if(GetNodeAtIndex(index)==NULL) return(false);
//---
   return(DeleteCurrent());
  }
//+------------------------------------------------------------------+
//| Remove all items from the list.                                  |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: curr_node is set equal to  NULL                          |
//+------------------------------------------------------------------+
void CList::Clear()
  {
   GetFirstNode();
   while(m_data_total!=0) DeleteCurrent();
  }
//+------------------------------------------------------------------+
//| Equality comparing of two lists.                                 |
//| INPUT:  List - pointer to instance of class CList for comparison.|
//| OUTPUT: true if the lists are equal, false if not.               |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CList::CompareList(CList *List)
  {
   CObject *node,*lnode;
//--- checking
   if(!CheckPointer(List))                 return(false);
   if((node=GetFirstNode())==NULL)         return(false);
   if((lnode=List.GetFirstNode())==NULL)   return(false);
//--- comparing
   if(node.Compare(lnode)!=0)              return(false);
   while((node=GetNextNode())!=NULL)
     {
      if((lnode=List.GetNextNode())==NULL) return(false);
      if(node.Compare(lnode)!=0)           return(false);
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Sorting an array in ascending order.                             |
//| INPUT:  mode - sorting mode.                                     |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CList::Sort(int mode)
  {
//--- checking
   if(m_data_total==0)                  return;
   if(m_data_sort && m_sort_mode==mode) return;
//---
   QuickSort(0,m_data_total-1,mode);
   m_sort_mode=mode;
   m_data_sort=true;
  }
//+------------------------------------------------------------------+
//| Move the current item of list to the specified position.         |
//| INPUT:  index - position to move the item to.                    |
//| OUTPUT: pointer to the moved item, or NULL.                      |
//| REMARK: curr_node is moved to the moved item or stays unchanged. |
//+------------------------------------------------------------------+
bool CList::MoveToIndex(int index)
  {
//--- checking
   if(index>=m_data_total || !CheckPointer(m_curr_node)) return(false);
//--- tuning
   if(m_curr_idx==index) return(true);
   if(m_curr_idx<index)
      index--;
//--- move
   Insert(DetachCurrent(),index);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Move an item of the list from the specified position to the      |
//| current one.                                                     |
//| INPUT:  index - position of the moved element.                   |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: m_curr_node=m_first_node, or stays unchanged.            |
//+------------------------------------------------------------------+
bool CList::Exchange(CObject *node1,CObject *node2)
  {
   CObject *tmp_node,*node;
//--- checking
   if(!CheckPointer(node1) || !CheckPointer(node2)) return(false);
//---
   tmp_node=node1.Prev();
   node1.Prev(node2.Prev());
   if(node1.Prev()!=NULL)
     {
      node=node1.Prev();
      node.Next(node1);
     }
   else m_first_node=node1;
   node2.Prev(tmp_node);
   if(node2.Prev()!=NULL)
     {
      node=node2.Prev();
      node.Next(node2);
     }
   else m_first_node=node2;
   tmp_node=node1.Next();
   node1.Next(node2.Next());
   if(node1.Next()!=NULL)
     {
      node=node1.Next();
      node.Prev(node1);
     }
   else m_last_node=node1;
   node2.Next(tmp_node);
   if(node2.Next()!=NULL)
     {
      node=node2.Next();
      node.Prev(node2);
     }
   else m_last_node=node2;
//---
   m_curr_idx=0;
   m_curr_node=m_first_node;
   m_data_sort=false;
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Search position of an element in a sorted list.                  |
//| INPUT:  element - search value.                                  |
//| OUTPUT: pointer to the found item in the list.                   |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CObject* CList::QuickSearch(CObject *element)
  {
   int      i,j,m;
   CObject *t_node=NULL;
//--- checking
   if(m_data_total==0) return(NULL);
//--- check the pointer is not needed
   i=0;
   j=m_data_total;
   while(j>=i)
     {
      //--- ">>1" is quick division by 2
      m=(j+i)>>1;
      if(m<0 || m>=m_data_total) break;
      t_node=GetNodeAtIndex(m);
      if(t_node.Compare(element,m_sort_mode)==0) break;
      if(t_node.Compare(element,m_sort_mode)>0)  j=m-1;
      else                                       i=m+1;
     }
//---
   return(t_node);
  }
//+------------------------------------------------------------------+
//| Search position of an element in a sorted list.                  |
//| INPUT:  element - search value.                                  |
//| OUTPUT: pointer to the found item in the list, or NULL.          |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CObject* CList::Search(CObject *element)
  {
   CObject *result;
//--- checking
   if(!CheckPointer(element) || !m_data_sort) return(NULL);
//--- search
   result=QuickSearch(element);
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Writing list to file.                                            |
//| INPUT:  file_handle - handle of file previously opened           |
//|         for writing.                                             |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: m_curr_node stays unchanged.                             |
//+------------------------------------------------------------------+
bool CList::Save(int file_handle)
  {
   CObject *node;
   bool     result=true;
//--- checking
   if(!CheckPointer(m_curr_node) || file_handle<0) return(false);
//--- writing
//--- writing start marker - 0xFFFFFFFFFFFFFFFF
   if(FileWriteLong(file_handle,-1)!=sizeof(long)) return(false);
//--- writing type
   if(FileWriteInteger(file_handle,Type(),INT_VALUE)!=INT_VALUE) return(false);
//--- writing list size
   if(FileWriteInteger(file_handle,m_data_total,INT_VALUE)!=INT_VALUE) return(false);
//--- sequential scannning of elements in the list using the call of method Save()
   node=m_first_node;
   while(node!=NULL)
     {
      result&=node.Save(file_handle);
      node=node.Next();
     }
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Reading list from file.                                          |
//| INPUT:  file_handle - handle of file previously opened           |
//|         for reading file.                                        |
//| OUTPUT: true if OK, else false.                                  |
//| REMARK: m_curr_node unchanged.                                   |
//+------------------------------------------------------------------+
bool CList::Load(int file_handle)
  {
   uint     i,num;
   CObject *node;
   bool     result=true;
//--- checking
   if(file_handle<0) return(false);
//--- reading
//--- reading and checking begin marker - 0xFFFFFFFFFFFFFFFF
   if(FileReadLong(file_handle)!=-1) return(false);
//--- reading and checking type
   if(FileReadInteger(file_handle,INT_VALUE)!=Type()) return(false);
//--- reading list size
   num=FileReadInteger(file_handle,INT_VALUE);
//--- sequential creation of list items using the call of method Load()
   Clear();
   for(i=0;i<num;i++)
     {
      node=CreateElement();
      if(node==NULL) return(false);
      Add(node);
      result&=node.Load(file_handle);
     }
//---
   return(result);
  }
//+------------------------------------------------------------------+
