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

        // ������������� ����������
        ClientID=InitModLib("CalcCli-PUT");
        // ������� ����� �� ������ ������
        // ����� �� ����������� �� ��������, ��� ��������, ������, ��� � ��� real time
        PutID=CreateChannel(ClientID, "192.168.1.102", 3111, CH_CALC_PUT_DATA, OPT_ENABLE_REAL_TIME|OPT_BLOCKING_COPY_LAYER|OPT_INVALIDATE_STATUS|OPT_ENABLE_DIAGNOSTICS);
        // �������������� ������� ��������
        Index[0][0]=Insert(ClientID, PutID, "Nakz", 0, 0);
        // �������������� � ������ Put ���������� ���� KV � ��������
        // �������������, ������� ��� ������� ������� Insert
        for(X=1; X<17; X++)
          for(Y=1; Y<164; Y++)
          	Index[Y][X]=Insert(ClientID, PutID, "KV", X, Y);

        //SetCopyLayerTimeOut(ClientID, PutID, 500);

        // �������� ����� Put �� ��������� ���� KV
        Subscribe(ClientID, PutID);
        printf("�������� ��������� ��������\n");
        fflush(stdout);

        // �������� ���� ��������� �������� ��������
       	// ��� ���������� ����� � ��������� ������ ��������� �������� �����
        while(!(GetChannelStatus(ClientID, PutID) & D_STATUS_SUBSCRIBED)) Sleep(1000);

        printf("�������� ����������\n");
        fflush(stdout);

        // �������� ��������� ��������
        // ���� ������� ������� ��� 0 �� ��� � �������
        if(ProblemID=CheckParams(ClientID, PutID))
        {
        	printf("������ ���������� �������������: %d\n",  ProblemID);
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
	       	// ��������� ���� ��������� ������


            }
            // � ������ ������������� �������������� ������ CopyLayer
            // ��������� ������� ����� � ������� ��������������
            //while(!GetQueueFree(ClientID, PutID))
              //  usleep(1000);

            CopyLayer(ClientID, PutID);

            usleep(5000);
        }
        //pause();
        printf("UnSubscribing.\n");
        // ������� �������� � �����
        Unsubscribe(ClientID, PutID);
        // �������� ������ ����������
        ShutdownModLib(ClientID);
        printf("Program terminated normaly.\n");
}

