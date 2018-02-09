//
//  LQAConfig.h
//  Pods
//
//  Created by yuyang on 2018/1/11.
//

#import <Foundation/Foundation.h>
#import <KSYMediaPlayer/KSYMoviePlayerController.h>

@interface LQAConfig : NSObject
/**
 * 设置金山云服务的key
 *  key金山云客户的标示
 */
@property (nonatomic,copy)NSString * ksyunAppKey;
/**
 * 设置IM服务的accessToken，由金山云服务OpenAPI下发
 */
@property (nonatomic,copy)NSString * imInfoAccessToken;
/**
 *  设置IM服务的key，由金山云服务OpenAPI下发
 */
@property (nonatomic,copy)NSString * imInfoKey;
/**
 * 设置用户uid，用于标示用户
 *  uid用户的uid
 */
@property (nonatomic,copy)NSString * userId;
/**
 *  设置直播答题聊天室的房间ID，由金山云服务OpenAPI下
 */
@property (nonatomic,copy)NSString * chatMessageId;
/**
 * 设置答题发送者的ID，由金山云服务OpenAPI下发
 * serverUserId 题目下发者的ID
 */
@property (nonatomic,copy)NSString * serverUserId;
/**
 * 设置用户所拥有的复活卡数量
 *  userReviveCardCount 复活卡数量
 */
@property (nonatomic,assign)NSInteger  userExtraLiveCount;
/**
 * 设置当前可用复活卡的最大数量
 *  maxReviveCardUsedInCompetition 可用复活卡的最大数量
 */
@property (nonatomic,assign)NSUInteger maxExtraLiveUsedInContest;
/**
 * 设置 赛场次ID， 于区分同一户不同场次比赛
 *  contestLiveId 比赛场次ID
 */
@property (nonatomic,copy)NSString * contestLiveId;
/**
 * 设置当前 户是否可参与答题环节，默认不可以
 *  canJoin YES可参与答题
 */
@property (nonatomic,assign)BOOL canJoin;
/**
 * 设置多媒体播放器
 *  mediaPlayer KSYMoviePlayerController 对象
 */
@property (nonatomic,strong)KSYMoviePlayerController *mediaPlayer;
/**
 * 设置多媒体播放器
 *  playerUrl  播放器地址
 */
@property (nonatomic,copy)NSString *playerUrl;





@end
