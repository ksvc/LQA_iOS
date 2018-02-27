//
//  LQANet.h
//  LQADemo
//
//  Created by yuyang on 2018/1/15.
//  Copyright © 2018年 Ksyun. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kUrl  @"http://live-trivia-game-show-srv.ksyun.com/api/v1/ltgs"


@interface LQANetModel : NSObject
@property (nonatomic,copy) NSString * _Nullable kscAppKey;//ksyunAppKey
@property (nonatomic,copy) NSString * _Nullable rcAppKey;//ImInfoKey
@property (nonatomic,copy) NSString * _Nullable rcToken;//imInfoAccessToken
@property (nonatomic,copy) NSString * _Nullable questionRoom;//chatMessageId
@property (nonatomic,copy) NSString * _Nullable messageRoom;//chatId
@property (nonatomic,copy) NSString * _Nullable imUser;//serverUserId
@property (nonatomic,copy) NSString * _Nullable liveId;//contestLiveId
@property (nonatomic,copy) NSString * _Nullable lives;//userExtraLiveCount
@property (nonatomic,copy) NSString * _Nullable maxExtraLives;//maxExtraLiveUsedInContest
@property (nonatomic,copy) NSString * _Nullable liveUrl;//播放地址
@property (nonatomic,copy) NSString * _Nullable signalingTimestamp;
@property (nonatomic,copy) NSString * _Nullable requestSignaling;


@end


@interface LQANet : NSObject

+ (void)GET:(NSString *_Nullable)path param:(NSDictionary *_Nullable)param modelClass:(Class _Nullable ) modelClass success:(void (^_Nullable)(id _Nullable))success failure:(void (^_Nonnull)(NSError * _Nonnull))failure;
+ (void)POST:(NSString *_Nullable)path header:(NSDictionary *)header  param:(NSDictionary *_Nullable)param  modelClass:(Class _Nullable ) modelClass  success:(void (^)(id _Nullable))success
     failure:(void (^_Nullable)(NSError * _Nonnull))failure;


@end
