#ifndef _GU_MOD_UI_H
#define _GU_MOD_UI_H

#include <windows.h>

//типы каналов
#define CH_CALC_GET_DATA                         1      //канал, осуществляющий прием данных из шлюза
#define CH_CALC_PUT_DATA                         2      //канал, осуществляющий отсылку данных в шлюз
//флаги канала
#define OPT_ENABLE_REAL_TIME                     0x01   //разрешить использовать системное время в пакетах
#define OPT_INVALIDATE_STATUS                    0x02   //после подписки параметры инициализируются недостоверными значениями
#define OPT_STAY_DISCONNECTED                    0x04   //при создании канала связь устанавливается только после вызова Connect()
#define OPT_ENABLE_SUBSCRIPTION                  0x08   //разрешить подписку
#define OPT_REMAIN_QUALIFIED                     0x10   //после закрытия канала значения в шлюзе остаются достоверными
#define OPT_ENABLE_DIAGNOSTICS                   0x20   //разрешить печатать диагностические сообщения на экран
#define OPT_BLOCKING_COPY_LAYER                  0x40   //разрешить блокирование вызова CopyLayer()
#define OPT_ENABLE_INPUT_BUFFER                  0x80   //разрешить работу приемного буфера (для канала CH_CALC_GET_DATA)
// статусы канала
#define D_STATUS_CONNECTED                       0x01   //канал осуществил соединение
#define D_STATUS_SUBSCRIBED                      0x02   //канал завершил подписку на сигналы
#define D_STATUS_UNSUBSCRIBED                    0x04   //канал завершил работу (основной поток завершился)
#define D_STATUS_UPDATED                         0x08   //поступили новые данные (для канала CH_CALC_GET_DATA)
#define D_STATUS_ERROR                           0x10   //соединение разорвано из-за сетевой ошибки
#define D_STATUS_TIMEOUT                         0x80   //CopyLayer завершился по таймауту при блокирующем вызове и установленом таймауте
//статусы сигнала
#define	D_STATUS_NORMAL                          0      //значение достоверно
#define	D_STATUS_NRG                             1      //значение сигнала ниже нижней регламентной границы
#define	D_STATUS_VRG                             2      //значение сигнала выше верхней регламентной границы
#define	D_STATUS_NAG                             3      //значение сигнала ниже нижней аварийной границы
#define	D_STATUS_VAG                             4      //значение сигнала выше верхней аварийной границы
#define	D_STATUS_NVG                             5      //значение сигнала ниже нижней возможной границы
#define	D_STATUS_VVG                             6      //значение сигнала выше верхней возможной границы
#define	D_STATUS_UNDEF                           7      //значение сигнала недостоверно


#ifdef __cplusplus
extern "C"
{
    // инициализация библиотеки
    __declspec(dllimport)long    InitModLib(const char* pOwner=0);
    // создание канала передачи
    __declspec(dllimport)long    CreateChannel(long ClientID,  const char* pHostName, long PortNumber, long ChannelType, int UserOptions=0);
#else
    __declspec(dllimport)long    InitModLib(const char* pOwner);
    __declspec(dllimport)long    CreateChannel(long ClientID,  const char* pHostName, long PortNumber, long ChannelType, int UserOptions);
#endif
    // завершение работы библиотеки
    __declspec(dllimport)void    ShutdownModLib(long ClientID);
    // команда на подписку канала на переменные
    __declspec(dllimport)void    Subscribe(long ClientID, long ChannelID);
    // завершение работы канала
    __declspec(dllimport)void    Unsubscribe(long ClientID, long ChannelID);
    // команда на соединение
    __declspec(dllimport)void    Connect(long ClientID, long ChannelID);
    // команда на разъединение
    __declspec(dllimport)void    Disconnect(long ClientID, long ChannelID);
    // добавить переменную в канал
    __declspec(dllimport)int     Insert(long ClientID, long ChannelID, const char* pVarName, long Index1, long Index2);
    // проверить результат подписки
    __declspec(dllimport)int     CheckParams(long ClientID, long ChannelID);
    // возврат имени переменной по ее индексу
    __declspec(dllimport)char*   GetParamName(long ClientID, long ChannelID, int ParamID);
    // возврат внешнего идентификатора
    __declspec(dllimport)int     GetOutsideID(long ClientID, long ChannelID, int ParamID);
    // разрешение передачи данных для канала PUT и получение доступа к пришедшим данным для канала GET
    __declspec(dllimport)void    CopyLayer(long ClientID, long ChannelID);
    // функции по работе со значениями и статусами
    __declspec(dllimport)float   GetFloat(long ClientID, long ChannelID, int ParamID);
    __declspec(dllimport)int     GetInt(long ClientID, long ChannelID, int ParamID);
    __declspec(dllimport)int     GetStatus(long ClientID, long ChannelID, int ParamID);
    __declspec(dllimport)void    PutFloat(long ClientID, long ChannelID, int ParamID, float Value);
    __declspec(dllimport)void    PutInt(long ClientID, long ChannelID, int ParamID, int Value);
    __declspec(dllimport)void    PutStatus(long ClientID, long ChannelID, int ParamID, int Value);
    // функции по работе со временем
    __declspec(dllimport)int     GetLayerTime(long ClientID, long ChannelID);
    __declspec(dllimport)int     GetLayerTimeMS(long ClientID, long ChannelID);
    __declspec(dllimport)void    PutLayerTime(long ClientID, long ChannelID, int Value);
    __declspec(dllimport)void    PutLayerTimeMS(long ClientID, long ChannelID, int Value);
    // очистить список переменных
    __declspec(dllimport)int     ClearList(long ClientID, long ChannelID);
    // получить статус канала
    __declspec(dllimport)long    GetChannelStatus(long ClientID, long ChannelID);
    // получить команды канала
    __declspec(dllimport)long    GetChannelFlags(long ClientID, long ChannelID);
    // возвращает количество пакетов в очереди пакетов
    __declspec(dllimport)int     GetQueueLength(long ClientID, long ChannelID);
    // возвращает количество свободных указателей на буферы очереди пакетов
    __declspec(dllimport)int     GetQueueFree(long ClientID, long ChannelID);
    // устанавливет глубину очереди пакетов
    __declspec(dllimport)void    SetQueueDepth(long ClientID, long ChannelID, int Depth);
    // возвращает установленную глубину очереди пакетов
    __declspec(dllimport)int     GetQueueDepth(long ClientID, long ChannelID);
    // устанавливает таймаут на блокировку внутри CopyLayer()
    __declspec(dllimport)void    SetCopyLayerTimeOut(long ClientID, long ChannelID, int Timeout);
     // устанавливает таймаут на прием пакетов
    __declspec(dllimport)void    SetRxTimeOut(long ClientID, long ChannelID, int Timeout);

#ifdef __cplusplus
}

extern "C"
{
// Функции для использования в Фортране.
#endif
    __declspec(dllimport)void    initmodlib_(const char* pOwner, long* pClientID, int LOwner);
    __declspec(dllimport)void    shutdownmodlib_(long* pClientID);
    __declspec(dllimport)void    createchannel_(long* pClientID,  const char* pHostName, long* pPortNumber, long* pChannelType, int* pUserOptions, long* pChannelID, int LHostName);
    __declspec(dllimport)void    subscribe_(long* pClientID, long* pChannelID);
    __declspec(dllimport)void    unsubscribe_(long* pClientID, long* pChannelID);
    __declspec(dllimport)void    connect_(long* pClientID, long* pChannelID);
    __declspec(dllimport)void    disconnect_(long* pClientID, long* pChannelID);
    __declspec(dllimport)void    clearlist_(long* pClientID, long* pChannelID, int* pRetValue);
    __declspec(dllimport)void    getchannelstatus_(long* pClientID, long* pChannelID, long* pChannelStatus);
    __declspec(dllimport)void    getchannelflags_(long* pClientID, long* pChannelID, long* pChannelFlags);
    __declspec(dllimport)void    getqueuelength_(long* pClientID, long* pChannelID, int* pQueueLength);
    __declspec(dllimport)void    getqueuefree_(long* pClientID, long* pChannelID, int* pQueueFree);
    __declspec(dllimport)void    setqueuedepth_(long* pClientID, long* pChannelID, int* pQueueDepth);
    __declspec(dllimport)void    getqueuedepth_(long* pClientID, long* pChannelID, int* pQueueDepth);
    __declspec(dllimport)void    setrxtimeout_(long* pClientID, long* pChannelID, int* pTimeout);
    __declspec(dllimport)void    setcopylayertimeout_(long* pClientID, long* pChannelID, int* pTimeout);
    __declspec(dllimport)void    insert_(long* pClientID, long* pChannelID, const char* pVarName, long* pIndex1, long* pIndex2, int* pRetValue, int LVarName);
    __declspec(dllimport)void    checkparams_(long* pClientID, long* pChannelID, int* pRetValue);
    __declspec(dllimport)void    getparamname_(long* pClientID, long* pChannelID, int* pParamIdx, const char* pParamName, int LParamName);
    __declspec(dllimport)void    copylayer_(long* pClientID, long* pChannelID);
    __declspec(dllimport)void    getfloat_(long* pClientID, long* pChannelID, int* pParamID, float *pValue);
    __declspec(dllimport)void    getint_(long* pClientID, long* pChannelID, int* pParamID, int* pValue);
    __declspec(dllimport)void    getstatus_(long* pClientID, long* pChannelID, int* pParamID, int* pStatus);
    __declspec(dllimport)void    getlayertime_(long* pClientID, long* pChannelID, int* pTime);
    __declspec(dllimport)void    getlayertimems_(long* pClientID, long* pChannelID, int* pTimeMS);
    __declspec(dllimport)void    putfloat_(long* pClientID, long* pChannelID, int* pParamID, float* pValue);
    __declspec(dllimport)void    putint_(long* pClientID, long* pChannelID, int* pParamID, int* pValue);
    __declspec(dllimport)void    putstatus_(long* pClientID, long* pChannelID, int* pParamID, int* pValue);
    __declspec(dllimport)void    putlayertime_(long* pClientID, long* pChannelID, int* pValue);
    __declspec(dllimport)void    putlayertimems_(long* pClientID, long* pChannelID, int* pValue);
#ifdef __cplusplus
}
#endif

#endif
