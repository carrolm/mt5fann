//+------------------------------------------------------------------+
//|                                                       Object.mqh |
//|                      Copyright © 2010, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//|                                              Revision 2010.02.22 |
//+------------------------------------------------------------------+
#include "StdLibErr.mqh"
//+------------------------------------------------------------------+
//| Class CObject.                                                   |
//| Purpose: Base class for storing elements.                        |
//+------------------------------------------------------------------+
class CObject
  {
protected:
   CObject          *m_prev;               // previous item of list
   CObject          *m_next;               // next item of list

public:
                     CObject();
   //--- methods to access protected data
   CObject          *Prev()                { return(m_prev); }
   void              Prev(CObject *node)   { m_prev=node;    }
   CObject          *Next()                { return(m_next); }
   void              Next(CObject *node)   { m_next=node;    }
   //--- methods for working with files
   virtual bool      Save(int file_handle) { return(true);   }
   virtual bool      Load(int file_handle) { return(true);   }
   //--- method of identifying the object
   virtual int       Type() const          { return(0);      }

protected:
   virtual int       Compare(const CObject *node,int mode=0) const { return(0); }
  };
//+------------------------------------------------------------------+
//| Constructor CObject.                                             |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CObject::CObject()
  {
//--- initialize protected data
   m_prev=NULL;
   m_next=NULL;
  }
//+------------------------------------------------------------------+
