//
//  Session.h
//  ETImClient
//
//  Created by Ethan on 14/8/4.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#ifndef __ETImClient__Session__
#define __ETImClient__Session__

#include <iostream>
#include <string>
#include <map>
#include "Socket.h"
#include "Endian.h"

namespace etim {
    
#define CMD_REGISTER                            0x0001      //注册
#define CMD_LOGIN                               0x0002      //登录
#define CMD_LOGOUT                              0x0003      //登出
#define CMD_HEART_BEAT                          0x0004      //心跳
#define CMD_SEND_MSG                            0x0005      //发消息
#define CMD_ADD_BUDDY                           0x0006      //添加好友
#define CMD_SWITCH_STATUS                       0x0007      //切换登录状态
#define CMD_RETRIVE_BUDDY                       0x0008      //获取好友列表
    
#define ERR_MSG_LENGTH      30              // 错误消息定长
    ///请求头
    struct RequestHead
    {
        unsigned short cmd;
        ///包体长度
        unsigned short len;
    };
    
    ///响应头
    struct ResponseHead
    {
        unsigned short cmd;
        ///包体长度
        unsigned short len;
        ///分片
        unsigned short cnt;
        ///序列
        unsigned short seq;
        ///错误码，0正确
        unsigned short error_code;
        ///错误消息 定长30
        char error_msg[30];
    };
    
    ///请求包休
    struct RequestPack
    {
        RequestHead head;
        ///标记位置
        char buf[1];
    };
    
    ///响应包体
    struct ResponsePack
    {
        ResponseHead head;
        ///标记位置
        char buf[1];
    };
    
    
    ///包中带的错误码
    enum ErrCode {
        kErrCode000, //000 success, 其它均为异常
        kErrCode001,
        kErrCode002,
        kErrCode003,
        kErrCode004,
        kErrCode005,
        kErrCode006,
        kErrCode007,
        kErrCode008,
        kErrCode009,
        kErrCode010,
        kErrCode011,
        kErrCodeMax
    };
    
    ///错误信息
    static const std::string gErrMsg[kErrCodeMax] = {"正常", "服务器错误", "数据库错误"};
    
    ///在线状态
    enum BuddyStatus {
        kBuddyOnline,
        kBuddyInvisible,
        kBuddyAway,
        kBuddyOffline
    };
    
    ///会话数据
    class Session {
    public:
        Session(std::auto_ptr<Socket> &socket);
        ~Session() {}
        
        ///设置操作命令
        void SetCmd(uint16_t cmd) { cmd_ = cmd; }
        uint16_t GetCmd() const { return cmd_; }
        ///将返回值加入
        void SetResponse(const std::string& k, const std::string& v);
        ///获取返回值
        const std::string& GetResponse(const std::string& k);
        
        ///将要请求的参加加入
        void SetAttribute(const std::string& k, const std::string& v);
        ///获取某个请求参数值
        const std::string& GetAttribute(const std::string& k);
        ///获取响应包
        ResponsePack* GetResponsePack() const { return responsePack_; }
        
        ///还原状态
        void Clear();
        ///发送打包数据
        void Send(const char* buf, size_t len);
        ///获取打包数据
        void Recv();
        void DoAction();
        
        
        uint16_t GetFd() const { return socket_->GetFd(); }
        bool IsConnected() const { return isConnected_; }
        
        void SetErrorCode(int16 errorCode) { errCode_ = errorCode; }
        void SetErrorMsg(const std::string& errorMsg) { errMsg_ = errorMsg; }
        
        int16 const GetErrorCode() const { return errCode_; }
        
    private:
        std::auto_ptr<Socket> socket_;
        bool isConnected_;
        ///存储缓存数据
        char buffer_[2048];
        ResponsePack *responsePack_;
        
        
        uint16_t cmd_;
        std::map<std::string, std::string> request_;
        std::map<std::string, std::string> response_;
        int16_t errCode_;
        std::string errMsg_;
        
        BuddyStatus status_;
    };
}   //end etim

#endif /* defined(__ETImClient__Session__) */