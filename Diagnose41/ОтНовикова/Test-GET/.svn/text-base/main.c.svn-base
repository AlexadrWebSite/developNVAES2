#include <stdio.h>
#include <unistd.h>
#include "GUModUI.h"

main()
{
        long 	ClientID;
        long 	GetID;
        float   fValue=0, fValue1=0;;
        int     iValue;
        int     ValStatus;
        int     Index[164][17];
        int     ProblemID;
        int     Cnt=0;
        int     X,Y, i,j;
        // инициализация библиотеки
        ClientID=InitModLib("CalcCli-GET");
        // откроем канал на чтение данных
        // чтобы не связываться со временем, для простоты, скажем, что у нас real time
        GetID=CreateChannel(ClientID, "192.168.1.102", 3111, CH_CALC_GET_DATA, OPT_ENABLE_REAL_TIME|OPT_BLOCKING_COPY_LAYER|OPT_INVALIDATE_STATUS|OPT_ENABLE_DIAGNOSTICS|OPT_ENABLE_INPUT_BUFFER);
        // зарегистрируем канал GET на получение средней мощности
        Index[0][0]=Insert(ClientID, GetID, "Nakz", 0, 0);
	    // зарегистрируем в канеле GET библиотеки поле KV и сохраним
        // идентфикаторы, которые нам вернула функция Insert
	    for(X=1; X<17; X++)
          for(Y=1; Y<164; Y++)
          	Index[Y][X]=Insert(ClientID, GetID, "KV", X, Y);

        //SetCopyLayerTimeOut(ClientID, PutID, 500);

        // подписка на данные
        Subscribe(ClientID, GetID);

        printf("Ожидание окончания подписки\n");
        fflush(stdout);
        // подождем, пока программа завершит подписку
       	// при отсутствии связи с серверной частью программа зависнет здесь
        while(!(GetChannelStatus(ClientID, GetID) & D_STATUS_SUBSCRIBED)) Sleep(1000);

        printf("Проверка параметров\n");
        fflush(stdout);

        // проверим результат подписки
        // если функция вернула нам 0 то все в порядке
        if(ProblemID=CheckParams(ClientID, GetID))
        {
        	printf("Первый проблемный идентификатор: %d\n",  ProblemID);
        }

        for(i=0; i<10000; i++)
        {
           	CopyLayer(ClientID, GetID);
                fValue=GetFloat(ClientID, GetID, Index[0][0]);
            printf("%f\n", fValue);
        }

        printf("UnSubscribing.\n");
        // закроем подписку и канал
        Unsubscribe(ClientID, GetID);
        // завершим работу библиотеки
        ShutdownModLib(ClientID);
        printf("Program terminated normaly.\n");
}

