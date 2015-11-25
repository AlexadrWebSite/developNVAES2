#include <stdio.h>
#include <unistd.h>
#include "GUModUI.h"

main()
{
        long 	ClientID;
        long 	PutID;
        float   fValue=0, fValue1=0;;
        int     iValue;
        int     ValStatus;
        int     Index[164][17];
        int     ProblemID;
        int     Cnt=0;
        int     X,Y, i,j;

        // инициализация библиотеки
        ClientID=InitModLib("CalcCli-PUT");
        // откроем канал на запись данных
        // чтобы не связываться со временем, для простоты, скажем, что у нас real time
        PutID=CreateChannel(ClientID, "192.168.1.102", 3111, CH_CALC_PUT_DATA, OPT_ENABLE_REAL_TIME|OPT_BLOCKING_COPY_LAYER|OPT_INVALIDATE_STATUS|OPT_ENABLE_DIAGNOSTICS);
        // зарегистрируем среднюю мощность
        Index[0][0]=Insert(ClientID, PutID, "Nakz", 0, 0);
        // зарегистрируем в канеле Put библиотеки поле KV и сохраним
        // идентфикаторы, которые нам вернула функция Insert
        for(X=1; X<17; X++)
          for(Y=1; Y<164; Y++)
          	Index[Y][X]=Insert(ClientID, PutID, "KV", X, Y);

        //SetCopyLayerTimeOut(ClientID, PutID, 500);

        // подпишем канал Put на получение поля KV
        Subscribe(ClientID, PutID);
        printf("Ожидание окончания подписки\n");
        fflush(stdout);

        // подождем пока программа закончит подписку
       	// при отсутствии связи с серверной частью программа зависнет здесь
        while(!(GetChannelStatus(ClientID, PutID) & D_STATUS_SUBSCRIBED)) Sleep(1000);

        printf("Проверка параметров\n");
        fflush(stdout);

        // проверим результат подписки
        // если функция вернула нам 0 то все в порядке
        if(ProblemID=CheckParams(ClientID, PutID))
        {
        	printf("Первый проблемный идентификатор: %d\n",  ProblemID);
        }

        for(i=0; i<1000000; i++)
        {
            fValue+=1;
            ValStatus=D_STATUS_NORMAL;

            PutFloat(ClientID, PutID, Index[0][0], fValue);
            PutStatus(ClientID, PutID, Index[0][0], ValStatus);

            for(j=0; j<30; j++)
            {
                for(X=1; X<17; X++)
                {
                	fValue1+=0.001;
                	Y=1;
                	PutFloat(ClientID, PutID, Index[Y][X], fValue1);
                	PutStatus(ClientID, PutID, Index[Y][X], ValStatus);
                }
                for(X=2; X<17; X++)
                {
                	fValue1+=0.001;
                	Y=1;
                	PutFloat(ClientID, PutID, Index[Y][X], fValue1);
                	PutStatus(ClientID, PutID, Index[Y][X], ValStatus);
                }
                if(fValue1>10)fValue1=0;
	       	// скопируем срез пришедших данных


            }
            // в случае использования неблокирующего вызова CopyLayer
            // проверяем наличие места в очереди самостоятельно
            //while(!GetQueueFree(ClientID, PutID))
              //  usleep(1000);

            CopyLayer(ClientID, PutID);

            usleep(5000);
        }
        //pause();
        printf("UnSubscribing.\n");
        // закроем подписку и канал
        Unsubscribe(ClientID, PutID);
        // завершим работу библиотеки
        ShutdownModLib(ClientID);
        printf("Program terminated normaly.\n");
}

