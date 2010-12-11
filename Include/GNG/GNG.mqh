//+------------------------------------------------------------------+
//|                                                          GNG.mqh |
//|                                             Copyright 2010, alsu |
//|                                                 alsufx@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, alsu"
#property link      "alsufx@gmail.com"

#include "Neurons.mqh"
//+------------------------------------------------------------------+
//| основной класс, представляющий собственно алгоритм РНГ           |
//+------------------------------------------------------------------+
class CGNGAlgorithm
  {
public:
   //--- связные списки объектов-нейронов и связей между ними
   CGNGNeuronList   *Neurons;
   CGNGConnectionList *Connections;
   //--- параметры алгоритма
   int               input_dimension;
   int               iteration_number;
   int               lambda;
   int               age_max;
   double            alpha;
   double            beta;
   double            eps_w;
   double            eps_n;
   int               max_nodes;

                     CGNGAlgorithm();
                    ~CGNGAlgorithm();
   virtual void      Init(int __input_dimension,
                          double &v1[],
                          double &v2[],
                          int __lambda,
                          int __age_max,
                          double __alpha,
                          double __beta,
                          double __eps_w,
                          double __eps_n,
                          int __max_nodes);
   virtual bool      ProcessVector(double &in[],bool train=true);
   virtual bool      StoppingCriterion();
  };
//+------------------------------------------------------------------+
//| конструктор                                                      |
//+------------------------------------------------------------------+
CGNGAlgorithm::CGNGAlgorithm(void)
  {
   Neurons=new CGNGNeuronList();
   Connections=new CGNGConnectionList();
   
   Neurons.FreeMode(true);
   Connections.FreeMode(true);
  }
//+------------------------------------------------------------------+
//| деструктор                                                       |
//+------------------------------------------------------------------+
CGNGAlgorithm::~CGNGAlgorithm(void)
  {
   delete Neurons;
   delete Connections;
  }
//+------------------------------------------------------------------+
//| инициализирует алгоритм с помощью двух векторов входных данных   |
//| INPUT: v1,v2 - входные векторы                                   |
//|        __lambda - количество итераций, после которого происходит |
//|        вставка нового нейрона                                    |
//|        __age_max - максимальный возраст соединения               |
//|        __alpha, __beta - используются для адаптации ошибок       |
//|        __eps_w, __eps_n - используются для адаптации весов       |
//|        __max_nodes - ограничение размера сети                    |
//| OUTPUT: нет                                                     |
//+------------------------------------------------------------------+
void CGNGAlgorithm::Init(int __input_dimension,
                         double &v1[],
                         double &v2[],
                         int __lambda,
                         int __age_max,
                         double __alpha,
                         double __beta,
                         double __eps_w,
                         double __eps_n,
                         int __max_nodes)
  {
   iteration_number=0;
   input_dimension=__input_dimension;
   lambda=__lambda;
   age_max=__age_max;
   alpha= __alpha;
   beta = __beta;
   eps_w = __eps_w;
   eps_n = __eps_n;
   max_nodes=__max_nodes;
   Neurons.Init(v1,v2);

   CGNGNeuron *tmp;
   tmp=Neurons.GetFirstNode();
   int uid1=tmp.uid;
   tmp=Neurons.GetLastNode();
   int uid2=tmp.uid;

   Connections.Init(uid1,uid2);
  }
//+------------------------------------------------------------------+
//| основная функция алгоритма                                       |
//| INPUT: in - вектор входных данных                                |
//|        train - если true, запускать обучение, в противном случае |
//|        только рассчитать выходные значения нейронов              |
//| OUTPUT: true, если выпоняется условие останова, иначе false      |
//+------------------------------------------------------------------+
bool CGNGAlgorithm::ProcessVector(double &in[],bool train=true)
  {
   if(ArraySize(in)!=input_dimension) return(StoppingCriterion());

   int i;

   CGNGNeuron *tmp=Neurons.GetFirstNode();
   while(CheckPointer(tmp))
     {
      tmp.ProcessVector(in);
      tmp=Neurons.GetNextNode();
     }

   if(!train) return(false);

   iteration_number++;
//--- Найти два нейрона, ближайших к in[], т.е. узлы с векторами весов 
//--- Ws и Wt, такими, что ||Ws-in||^2 минимальное, а ||Wt-in||^2 -    
//--- второе минимальное значение расстояния среди всех узлов .        
//--- Под обозначением ||*|| понимается евклидова норма                
   CGNGNeuron *Winner,*SecondWinner;
   Neurons.FindWinners(Winner,SecondWinner);

//--- Обновить локальную ошибку нейрона-победителя                     
   Winner.E+=Winner.error;

//--- Сместить нейрон-победитель и всех его топологических соседей(т.е.
//--- все нейроны, имеющие соединение с победителем) в сторону входного
//--- вектора на расстояния, равные долям eps_w и eps_n от полного.    
   double delta[],weights[];

   Winner.Weights(weights);
   ArrayResize(delta,input_dimension);

   for(i=0;i<input_dimension;i++) delta[i]=eps_w*(in[i]-weights[i]);
   Winner.AdaptWeights(delta);

//--- Увеличить на 1 возраст всех соединений, исходящих от победителя. 
   CGNGConnection *tmpc=Connections.FindFirstConnection(Winner.uid);
   while(CheckPointer(tmpc))
     {
      if(tmpc.uid1==Winner.uid) tmp = Neurons.Find(tmpc.uid2);
      if(tmpc.uid2==Winner.uid) tmp = Neurons.Find(tmpc.uid1);

      tmp.Weights(weights);
      for(i=0;i<input_dimension;i++) delta[i]=eps_n*(in[i]-weights[i]);
      tmp.AdaptWeights(delta);

      tmpc.age++;

      tmpc=Connections.FindNextConnection(Winner.uid);
     }

//--- Если два лучших нейрона соединены, обнулить возраст их связи.    
//--- В противном случае создать связь между ними.                     
   tmpc=Connections.Find(Winner.uid,SecondWinner.uid);
   if(tmpc) tmpc.age=0;
   else
     {
      Connections.Append();
      tmpc=Connections.GetLastNode();
      tmpc.uid1 = Winner.uid;
      tmpc.uid2 = SecondWinner.uid;
      tmpc.age=0;
     }

//--- Удалить все соединения, возраст которых превышает age_max.       
//--- Если после этого имеются нейроны, не имеющие связей с другими    
//--- узлами, удалить эти нейроны.                                     
   tmpc=Connections.GetFirstNode();
   while(CheckPointer(tmpc))
     {
      if(tmpc.age>age_max)
        {
         Connections.DeleteCurrent();
         tmpc=Connections.GetCurrentNode();
        }
      else tmpc=Connections.GetNextNode();
     }

   tmp=Neurons.GetFirstNode();
   while(CheckPointer(tmp))
     {
      if(!Connections.FindFirstConnection(tmp.uid))
        {
         Neurons.DeleteCurrent();
         tmp=Neurons.GetCurrentNode();
        }
      else tmp=Neurons.GetNextNode();
     }

//--- Если номер текущей итерации кратен lambda, и предельный размер   
//--- сети не достигнут, создать новый нейрон r по следующим правилам  
   CGNGNeuron *u,*v;
   if(iteration_number%lambda==0 && Neurons.Total()<max_nodes)
     {
      //--- 1.Найти нейрон u с наибольшей локальной ошибкой.               
      tmp=Neurons.GetFirstNode();
      u=tmp;
      while(CheckPointer(tmp=Neurons.GetNextNode()))
        {
         if(tmp.E>u.E)
            u=tmp;
        }

      //--- 2.Среди соседей u найти узел u с наибольшей локальной ошибкой. 
      tmpc=Connections.FindFirstConnection(u.uid);
      if(tmpc.uid1==u.uid) v=Neurons.Find(tmpc.uid2);
      else v=Neurons.Find(tmpc.uid1);
      while(CheckPointer(tmpc=Connections.FindNextConnection(u.uid)))
        {
         if(tmpc.uid1==u.uid) tmp=Neurons.Find(tmpc.uid2);
         else tmp=Neurons.Find(tmpc.uid1);
         if(tmp.E>v.E)
            v=tmp;
        }

      //--- 3.Создать узел r "посредине" между u и v.                      
      double wr[],wu[],wv[];

      u.Weights(wu);
      v.Weights(wv);
      ArrayResize(wr,input_dimension);
      for(i=0;i<input_dimension;i++) wr[i]=(wu[i]+wv[i])/2;

      CGNGNeuron *r=Neurons.Append();
      r.Init(wr);
      //--- 4.Заменить связь между u и v на связи между u и r, v и r       
      tmpc=Connections.Append();
      tmpc.uid1=u.uid;
      tmpc.uid2=r.uid;

      tmpc=Connections.Append();
      tmpc.uid1=v.uid;
      tmpc.uid2=r.uid;

      Connections.Find(u.uid,v.uid);
      Connections.DeleteCurrent();

      //--- 5.Уменьшить ошибки нейронов u и v, установить значение ошибки  
      //---   нейрона r таким же, как у u.                                 

      u.E*=alpha;
      v.E*=alpha;
      r.E = u.E;
     }

//--- Уменьшить ошибки всех нейронов на долю beta                     
   tmp=Neurons.GetFirstNode();
   while(CheckPointer(tmp))
     {
      tmp.E*=(1-beta);
      tmp=Neurons.GetNextNode();
     }

//--- Проверить критерий останова                                      
   return(StoppingCriterion());
  }
//+------------------------------------------------------------------+
//| Критерий останова. В данной версии файла не выполняет никаких    |
//| действий, всегда возвращая false.                                |
//| INPUT: нет                                                       |
//| OUTPUT: true, если критерий выполняется, false в противном случае|
//+------------------------------------------------------------------+
bool CGNGAlgorithm::StoppingCriterion()
  {
   return(false);
  }
//+------------------------------------------------------------------+
//| класс алгоритма GNG with Utility factor                          |
//+------------------------------------------------------------------+
class CGNGUAlgorithm:public CGNGAlgorithm
  {
public:
   double            k;
   virtual void      Init(int __input_dimension,
                          double &v1[],
                          double &v2[],
                          int __lambda,
                          int __age_max,
                          double __alpha,
                          double __beta,
                          double __eps_w,
                          double __eps_n,
                          int __max_nodes,
                          double __k);
   virtual bool      ProcessVector(double &in[],bool train=true);
   virtual bool      StoppingCriterion();
  };
//+------------------------------------------------------------------+
//| инициализирует алгоритм с помощью двух векторов входных данных   |
//| INPUT: v1,v2 - входные векторы                                   |
//|        __lambda - количество итераций, после которого происходит |
//|        вставка нового нейрона                                    |
//|        __age_max - максимальный возраст соединения               |
//|        __alpha, __beta - используются для адаптации ошибок       |
//|        __eps_w, __eps_n - используются для адаптации весов       |
//|        __max_nodes - ограничение размера сети                    |
//|        __k - характеристика памяти для нестационарных входов     |
//| OUTPUT: нет                                                      |
//+------------------------------------------------------------------+
void CGNGUAlgorithm::Init(int __input_dimension,
                          double &v1[],
                          double &v2[],
                          int __lambda,
                          int __age_max,
                          double __alpha,
                          double __beta,
                          double __eps_w,
                          double __eps_n,
                          int __max_nodes,
                          double __k)
  {
   iteration_number=0;
   input_dimension=__input_dimension;
   lambda=__lambda;
   age_max=__age_max;
   alpha= __alpha;
   beta = __beta;
   eps_w = __eps_w;
   eps_n = __eps_n;
   max_nodes=__max_nodes;
   k=__k;
   Neurons.Init(v1,v2);

   CGNGNeuron *tmp;
   tmp=Neurons.GetFirstNode();
   int uid1=tmp.uid;
   tmp=Neurons.GetLastNode();
   int uid2=tmp.uid;

   Connections.Init(uid1,uid2);
  }
//+------------------------------------------------------------------+
//| основная функция алгоритма                                       |
//| INPUT: in - вектор входных данных                                |
//|        train - если true, запускать обучение, в противном случае |
//|        только рассчитать выходные значения нейронов              |
//| OUTPUT: true, если выпоняется условие останова, иначе false      |
//+------------------------------------------------------------------+
bool CGNGUAlgorithm::ProcessVector(double &in[],bool train=true)
  {
   if(ArraySize(in)!=input_dimension) return(StoppingCriterion());

   int i;

   CGNGNeuron *tmp=Neurons.GetFirstNode();
   while(CheckPointer(tmp))
     {
      tmp.ProcessVector(in);
      tmp=Neurons.GetNextNode();
     }

   if(!train) return(false);

   iteration_number++;

//--- Найти два нейрона, ближайших к in[], т.е. узлы с векторами весов 
//--- Ws и Wt, такими, что ||Ws-in||^2 минимальное, а ||Wt-in||^2 -    
//--- второе минимальное значение расстояния среди всех узлов .        
//--- Под обозначением ||*|| понимается евклидова норма                

   CGNGNeuron *Winner,*SecondWinner;
   Neurons.FindWinners(Winner,SecondWinner);

//--- Обновить локальную ошибку и полезность нейрона-победителя        

   Winner.E+=Winner.error;
   Winner.U+=SecondWinner.error-Winner.error;

//--- Сместить нейрон-победитель и всех его топологических соседей(т.е.
//--- все нейроны, имеющие соединение с победителем) в сторону входного
//--- вектора на расстояния, равные долям eps_w и eps_n от полного.    

   double delta[],weights[];

   Winner.Weights(weights);
   ArrayResize(delta,input_dimension);

   for(i=0;i<input_dimension;i++) delta[i]=eps_w*(in[i]-weights[i]);
   Winner.AdaptWeights(delta);

//--- Увеличить на 1 возраст всех соединений, исходящих от победителя. 

   CGNGConnection *tmpc=Connections.FindFirstConnection(Winner.uid);
   while(CheckPointer(tmpc))
     {
      if(tmpc.uid1==Winner.uid) tmp = Neurons.Find(tmpc.uid2);
      if(tmpc.uid2==Winner.uid) tmp = Neurons.Find(tmpc.uid1);

      tmp.Weights(weights);
      for(i=0;i<input_dimension;i++) delta[i]=eps_n*(in[i]-weights[i]);
      tmp.AdaptWeights(delta);

      tmpc.age++;

      tmpc=Connections.FindNextConnection(Winner.uid);
     }

//--- Если два лучших нейрона соединены, обнулить возраст их связи.    
//--- В противном случае создать связь между ними.                     

   tmpc=Connections.Find(Winner.uid,SecondWinner.uid);
   if(tmpc) tmpc.age=0;
   else
     {
      Connections.Append();
      tmpc=Connections.GetLastNode();
      tmpc.uid1 = Winner.uid;
      tmpc.uid2 = SecondWinner.uid;
      tmpc.age=0;
     }

//--- Удалить все соединения, возраст которых превышает age_max.       
//--- Если после этого у нейрона с минимальной полезностью этот        
//--- показатель более, чем в k раз меньше максимальной ошибки, 
//--- удалить этот нейрон.      

   tmpc=Connections.GetFirstNode();
   while(CheckPointer(tmpc))
     {
      if(tmpc.age>age_max)
        {
         Connections.DeleteCurrent();
         tmpc=Connections.GetCurrentNode();
        }
      else tmpc=Connections.GetNextNode();
     }

   tmp=Neurons.GetFirstNode();
   double max_error=0;
   double min_U=0;
   CGNGNeuron *useless;

   if(CheckPointer(tmp))
     {
      max_error=tmp.error;
      min_U=tmp.U;
      useless=tmp;
     }
   while(CheckPointer(tmp=Neurons.GetNextNode()))
     {
      if(tmp.error>max_error)
        {
         max_error=tmp.error;
        }
      if(tmp.U<min_U)
        {
         min_U=tmp.U;
         useless=tmp;
        }
     }
   if(min_U!=0 && max_error/min_U>k) Neurons.Delete(Neurons.IndexOf(tmp));

//--- Если номер текущей итерации кратен lambda, и предельный размер   
//--- сети не достигнут, создать новый нейрон r по следующим правилам  

   CGNGNeuron *u,*v;
   if(iteration_number%lambda==0 && Neurons.Total()<max_nodes)
     {

      //--- 1.Найти нейрон u с наибольшей локальной ошибкой.               

      tmp=Neurons.GetFirstNode();
      u=tmp;
      while(CheckPointer(tmp=Neurons.GetNextNode()))
        {
         if(tmp.E>u.E)
            u=tmp;
        }

      //--- 2.Среди соседей u найти узел u с наибольшей локальной ошибкой. 

      tmpc=Connections.FindFirstConnection(u.uid);
      if(tmpc.uid1==u.uid) v=Neurons.Find(tmpc.uid2);
      else v=Neurons.Find(tmpc.uid1);
      while(CheckPointer(tmpc=Connections.FindNextConnection(u.uid)))
        {
         if(tmpc.uid1==u.uid) tmp=Neurons.Find(tmpc.uid2);
         else tmp=Neurons.Find(tmpc.uid1);
         if(tmp.E>v.E)
            v=tmp;
        }

      //--- 3.Создать узел r "посредине" между u и v.                      
      //---   Вычислить его фактор полезности                              

      double wr[],wu[],wv[];

      u.Weights(wu);
      v.Weights(wv);
      ArrayResize(wr,input_dimension);
      for(i=0;i<input_dimension;i++) wr[i]=(wu[i]+wv[i])/2;

      CGNGNeuron *r=Neurons.Append();
      r.Init(wr);

      r.U=(u.U+v.U)/2;

      //--- 4.Заменить связь между u и v на связи между u и r, v и r       

      tmpc=Connections.Append();
      tmpc.uid1=u.uid;
      tmpc.uid2=r.uid;

      tmpc=Connections.Append();
      tmpc.uid1=v.uid;
      tmpc.uid2=r.uid;

      Connections.Find(u.uid,v.uid);
      Connections.DeleteCurrent();

      //--- 5.Уменьшить ошибки нейронов u и v, установить значение ошибки  
      //---   нейрона r таким же, как у u.                                 

      u.E*=alpha;
      v.E*=alpha;
      r.E = u.E;
     }

//--- Уменьшить ошибки и полезность всех нейронов на долю beta 	     

   tmp=Neurons.GetFirstNode();
   while(CheckPointer(tmp))
     {
      tmp.E*=(1-beta);
      tmp.U*=(1-beta);
      tmp=Neurons.GetNextNode();
     }

//--- Проверить критерий останова                                      

   return(StoppingCriterion());
  }
//+------------------------------------------------------------------+
//| Критерий останова. В данной версии файла не выполняет никаких    |
//| действий, всегда возвращая false.                                |
//| INPUT: нет                                                       |
//| OUTPUT: true, если критерий выполняется, false в противном случае|
//+------------------------------------------------------------------+
bool CGNGUAlgorithm::StoppingCriterion()
  {
   return(false);
  }
//+------------------------------------------------------------------+
