bool GetVectors(double &InputVector[],int num_vectors=5,string smbl="",ENUM_TIMEFRAMES tf=0,int npf=3,int shift=0)
  {// пара, период, смещение назад (для индикатора полезно)
   int shft_his=7;
   int shft_cur=0;

   if(""==smbl) smbl=_Symbol;
   if(0==tf) tf=_Period;
   double Low[],High[];
   ArraySetAsSeries(Low,true); ArraySetAsSeries(High,true);
// копируем историю
   int ncl=CopyLow(smbl,tf,shift,num_vectors*10*npf,Low);
   int nch=CopyHigh(smbl,tf,shift,num_vectors*10*npf,High);
   ArrayInitialize(InputVector,EMPTY_VALUE);
   int maxcount=MathMin(ncl,nch);
   if(maxcount<num_vectors*10*npf)
     {
      Print("Shift = ",shift," maxcount = ",maxcount);
      return(false);
     }
   double UpperBuffer[];
   double LowerBuffer[];
   ArrayResize(UpperBuffer,num_vectors*10*npf);
   ArrayResize(LowerBuffer,num_vectors*10*npf);
   ArrayInitialize(UpperBuffer,EMPTY_VALUE);
   ArrayInitialize(LowerBuffer,EMPTY_VALUE);
   int i,j;
   for(i=npf-1;i<maxcount-2;i++)
     {
      if(((5==npf) && (High[i]>High[i+1] && High[i]>High[i+2] && High[i]>=High[i-1] && High[i]>=High[i-2]))
         || ((3==npf) && ((High[i]>High[i+1] && High[i]>=High[i-1]))))
        {
         UpperBuffer[i]=High[i];
         // проверка что предыдущее тоже верх и ниже
         for(j=i-1;UpperBuffer[j]==EMPTY_VALUE && LowerBuffer[j]==EMPTY_VALUE && j>0;j--);
         if(UpperBuffer[j]==EMPTY_VALUE)
           {
            if(LowerBuffer[j]>UpperBuffer[i])UpperBuffer[i]=EMPTY_VALUE;// ExtUpperBuffer[i]=High[i];
           }
         else
           {
            if(UpperBuffer[j]>UpperBuffer[i]) UpperBuffer[i]=EMPTY_VALUE;
            else
              {
               UpperBuffer[j]=EMPTY_VALUE;
               for(j=i-1;UpperBuffer[j]==EMPTY_VALUE && LowerBuffer[j]==EMPTY_VALUE && j>0;j--);
               if(LowerBuffer[j]==EMPTY_VALUE);// ExtUpperBuffer[i]=High[i];
               else
                 {
                  if(LowerBuffer[j]<LowerBuffer[i]) LowerBuffer[i]=EMPTY_VALUE;
                  else LowerBuffer[j]=EMPTY_VALUE;
                 }
              }
           }
        }
      else UpperBuffer[i]=EMPTY_VALUE;

      //---- Lower Fractal
      if(((5==npf) && (Low[i]<Low[i+1] && Low[i]<Low[i+2] && Low[i]<=Low[i-1] && Low[i]<=Low[i-2]))
         || ((3==npf) && ((Low[i]<Low[i+1] && Low[i]<=Low[i-1]))))
        {
         LowerBuffer[i]=Low[i];
         // проверка что предыдущее тоже верх и ниже
         for(j=i-1;UpperBuffer[j]==EMPTY_VALUE && LowerBuffer[j]==EMPTY_VALUE && j>0;j--);
         if(LowerBuffer[j]==EMPTY_VALUE)
           {
            if(UpperBuffer[j]<LowerBuffer[i]) LowerBuffer[i]=EMPTY_VALUE;
           }
         else
           {
            if(LowerBuffer[j]<LowerBuffer[i]) LowerBuffer[i]=EMPTY_VALUE;
            else
              {
               LowerBuffer[j]=EMPTY_VALUE;
               for(j=i-1;UpperBuffer[j]==EMPTY_VALUE && LowerBuffer[j]==EMPTY_VALUE && j>0;j--);
               if(UpperBuffer[j]==EMPTY_VALUE);// ExtUpperBuffer[i]=High[i];
               else
                 {
                  if(UpperBuffer[j]>UpperBuffer[i]) UpperBuffer[i]=EMPTY_VALUE;
                 }
              }
           }

        }
      else LowerBuffer[i]=EMPTY_VALUE;
     }
// Возьмем num_vectors значимых элементов
// вначале проверим что последний "красивый" -тоесть на котором можно заработать
   int fp=npf-1;
   double prf=0,prl=0;
   if(UpperBuffer[fp]==EMPTY_VALUE && LowerBuffer[fp]==EMPTY_VALUE) return(false);// нет фрактала  
                                                                                  //   do
     {
      if(LowerBuffer[fp]==EMPTY_VALUE)// ExtUpperBuffer[i]=High[i];
         prf=UpperBuffer[fp];
      else  prf=LowerBuffer[fp];
      //fp=j;
      for(j=fp+1;UpperBuffer[j]==EMPTY_VALUE && LowerBuffer[j]==EMPTY_VALUE && j<maxcount;j++);
      if(LowerBuffer[j]==EMPTY_VALUE)// ExtUpperBuffer[i]=High[i];
         prl=UpperBuffer[j];
      else  prl=LowerBuffer[j];
     }
   if((MathAbs(prf-prl)/(SymbolInfoInteger(smbl,SYMBOL_SPREAD)*SymbolInfoDouble(smbl,SYMBOL_POINT)))>5)
     {
      // заполняем массив выходной 
      InputVector[0]=prf-prl;
      prf=prl;fp=j;
      for(i=0;i<num_vectors;i++)
        {
         for(j=fp+1;UpperBuffer[j]==EMPTY_VALUE && LowerBuffer[j]==EMPTY_VALUE && j<maxcount;j++);
         if(LowerBuffer[j]==EMPTY_VALUE)// ExtUpperBuffer[i]=High[i];
            prl=UpperBuffer[j];
         else  prl=LowerBuffer[j];
         InputVector[i+1]=100*(prf-prl);      prf=prl;fp=j;
        }

      return(true);// 
     }
   else
      return(false);// нет свечки  
   return(true);// нет свечки
  }
//+------------------------------------------------------------------+
