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
        // ������������� ����������
        ClientID=InitModLib("TestWIN");
        // ������� ����� �� ������ ������
        // ����� �� ����������� �� ��������, ��� ��������, ������, ��� � ��� real time
        GetID=CreateChannel(ClientID, "192.168.103.83", 3111, CH_CALC_GET_DATA, OPT_ENABLE_REAL_TIME|OPT_BLOCKING_COPY_LAYER|OPT_INVALIDATE_STATUS|OPT_ENABLE_DIAGNOSTICS);
        // �������������� ����� GET �� ��������� ������� ��������
        Index[0][0]=Insert(ClientID, GetID, "Nakz", 0, 0);
	    // �������������� � ������ GET ���������� ���� KV � ��������
        // �������������, ������� ��� ������� ������� Insert

        // �������� �� ������
        Subscribe(ClientID, GetID);

        printf("�������� ��������� ��������\n");
        fflush(stdout);
        // ��������, ���� ��������� �������� ��������
       	// ��� ���������� ����� � ��������� ������ ��������� �������� �����
        while(!(GetChannelStatus(ClientID, GetID) & D_STATUS_SUBSCRIBED)) Sleep(1000);

        printf("�������� ����������\n");
        fflush(stdout);

        // �������� ��������� ��������
        // ���� ������� ������� ��� 0 �� ��� � �������
        if(ProblemID=CheckParams(ClientID, GetID))
        {
        	printf("������ ���������� �������������: %d\n",  ProblemID);
        }

        for(i=0; i<10000; i++)
        {
           	CopyLayer(ClientID, GetID);
                fValue=GetFloat(ClientID, GetID, Index[0][0]);
            printf("%f\n", fValue);
        }

        printf("UnSubscribing.\n");
        // ������� �������� � �����
        Unsubscribe(ClientID, GetID);
        // �������� ������ ����������
        ShutdownModLib(ClientID);
        printf("Program terminated normaly.\n");
}

