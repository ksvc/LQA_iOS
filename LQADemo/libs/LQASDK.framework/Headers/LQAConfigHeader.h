//
//  LQAConfigHeader.h
//  Pods
//
//  Created by yuyang on 2018/1/11.
//

#ifndef LQAConfigHeader_h
#define LQAConfigHeader_h

#import <RongIMLib/RongIMLib.h>
#import "LQAEntity.h"
#import "LQAConfig.h"

typedef enum {
    
    LQAErrorCodeNoDic = -2000, // 数据字段有问题
    
    LQAErrorCodeNet, // 网络错误
    
}LQAErrorCode;



typedef void(^successBlock_t)(id _Nullable model);

typedef void(^failBlock_t)(NSError * _Nullable error);

/**
 * 监挺消息通道实时状态
 */
typedef void (^OnLQAStatusListener)(NSString * _Nullable status);
/**
 * 监听答题结果
 */
typedef void (^OnLQAResultListener)(LQAEntity * _Nullable entity) ;
/**
 * 监听题目
 * @param entity 题型的实体
 */
typedef void (^OnQuestionListener)(LQAEntity * _Nullable entity) ;
/**
 * 监听聊天信息
 */
typedef void (^OnLiveChatMessageListener)(RCMessage * _Nullable message) ;

/**
 * 使用复活卡
 * @param residueCardNum 当前剩余复活卡数量
 */
typedef void (^OnUserReviveCardListener)(NSInteger residueCardNum);

/**
 * 淘汰
 */
typedef void (^OnLoserListener)(void);


/**
 * 胜利
 * @param money 赢到的金钱
 * @param isSelf  YES  自己答对  NO 自己答错  LQAEntity 答题人数uids获取
 */
typedef void (^OnWinerListener)(NSString * _Nullable money,BOOL isSelf,LQAEntity * _Nullable entity);

#endif /* LQAConfigHeader_h */
