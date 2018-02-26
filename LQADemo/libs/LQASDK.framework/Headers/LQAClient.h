//
//  LQAClient.h
//  Pods
//
//  Created by yuyang on 2018/1/9.
//

#import <Foundation/Foundation.h>
#import "LQAConfigHeader.h"


@interface LQAClient: NSObject

@property (nonatomic,copy)OnLQAResultListener _Nullable resultListener;
@property (nonatomic,copy)OnQuestionListener _Nullable  questionListener;
@property (nonatomic,copy)OnLiveChatMessageListener _Nullable  chatMessageListener;
@property (nonatomic,copy)OnUserReviveCardListener _Nullable   userReviveCardListener;
@property (nonatomic,copy)OnLoserListener _Nullable   loserListener;
@property (nonatomic,copy)OnWinerListener _Nullable   winerListener;
@property (nonatomic,copy)OnLQAStatusListener _Nullable   statusListener;


- (instancetype _Nullable )init NS_UNAVAILABLE;
+ (instancetype _Nullable )new NS_UNAVAILABLE;
/**
 *  获取版本号
 *  @return 返回NSString类型的字符串
 */
+ (NSString *_Nullable)getVersion;
/**
 *  是否开启日志功能
 *   Yes 开启功能 ，No 关闭  默认关闭
 */
- (void)openLog:(BOOL) isOpen;
/**
 *  初始化唯一的方法
 *  @param config sdk需要的必要信息
 */
- (instancetype _Nullable )initWithConfig:(LQAConfig * _Nullable) config success:(successBlock_t _Nullable)successBlock;

/**
 *  释放资源
 */
- (void)lqaRelease;

/**
 * 获取该用户在比赛中使用了的复活卡数量
 * @return 使用了的复活卡数量
 */
- (NSInteger)getUsedReviveCardCount;

/**
 *  该接口主要区分中途进入的用户的状态
 *  @return YES从第一题开始答题  NO 不是从第一题开始答题
 */
- (BOOL)isFromFirstAnswering;

/**
 加入聊天室
 @param roomId 聊天室id
 @param  success 成功回调
 @param  failure 失败回调
 */
- (void)joinRoomWith:(NSString *_Nullable)roomId
             success:(void(^_Nullable)(void))success
             failure:(void(^_Nullable)(RCErrorCode errorCode))failure;


/**
 发送消息
 @param message 消息内容
 @param successBlock 成功回调
 @param failureBlock 失败回调
 */
- (void)sendLiveChatMessage:(NSString *_Nullable)message
                    success:(void(^_Nullable)(long messageId))successBlock
                    failure:(void(^_Nullable)(RCErrorCode failureCode, long messageId))failureBlock;

/**
 提交答案
 @param  answer 提交答案@"A"....
 @param  signalingTimestamp 计算请求信令的时间戳，毫秒，由AppServer颁发。（仅当启用了请求信令功能时有效，有效时间窗口需要通过技术支持进行配置）
 @param  requestSignaling 请求信令，由AppServer根据服务端Token、AppKey、UID、Timestamp计算md5得出，形如 md5({Token}\n{Appkey}\n{UID}\n{Timestamp})。（仅当启用了请求信令功能时有效，有效时间窗口需要通过技术支持进行配置）
 @param  success 成功回调 答对答错都会走
 @param  failure 服务内部错误，网络错误等回调，NSError里面有对应错误的信息
 */
- (void)answer:(NSString*_Nullable)answer
        signalingTimestamp:(NSString*_Nullable)signalingTimestamp
        requestSignaling:(NSString*_Nullable)requestSignaling
        success:(void(^_Nullable)(id _Nullable model) )success
        failure:(void(^_Nullable)(NSError * _Nullable error))failure;


@end
