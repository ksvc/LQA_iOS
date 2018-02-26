//
//  LQAEntity.h
//  Pods
//
//  Created by yuyang on 2018/1/11.
//

#import <Foundation/Foundation.h>

typedef enum {
    
    LQAUserStatusAnswerDoing = 1000, //正在答题中
    
    LQAUserStatusAnswerRightDone, // 答对题目
    
    LQAUserStatusAnswerWrongDone, // 答错题目
    
    LQAUserStatusAnswerMatch, // 观战
    
}LQAUserStatusAnswer;

@interface LQAOptionsEntity : NSObject

@property (nonatomic,copy)NSString *option;//选项
@property (nonatomic,copy)NSString *text;//内容

@end

@interface LQAGroupEntity : NSObject

@property (nonatomic,copy)NSString *option;//选项
@property (nonatomic,copy)NSString *count;//答题人数

@end

@interface LQAEntity : NSObject
@property (nonatomic,copy)NSString *id;//题目id
@property (nonatomic,copy)NSString *type;//题目类型 Question-> 答题 ，Statistic->答题结果, Result>比赛结果
@property (nonatomic,copy)NSString *order;//当前第几题
@property (nonatomic,copy)NSString *totalNumber;//总题数
@property (nonatomic,copy)NSString *correctOption;//正确选项 “A” ....
@property (nonatomic,copy)NSString *title;//题目title
@property (nonatomic,copy)NSString *showPeriod;//展示的时间
@property (nonatomic,copy)NSString *cashPrizes;//奖金
@property (nonatomic,copy)NSString *logo;// logo
@property (nonatomic,strong)NSArray *options;//题的内容
@property (nonatomic,strong)NSArray *group;// 答案结果
@property (nonatomic,strong)NSArray *uids;// 获奖人数
@property (nonatomic,copy)NSString *errorOption;//错误选项 “A” ....//答错的时候使用
@property (nonatomic,copy)NSString *showTimestamp; //题目展示的时间
@property (nonatomic,copy)NSString *allowDelayTime; //题目下发延迟时间

@property (nonatomic,assign) LQAUserStatusAnswer userStatusAnswer;

//处理过后的数据
- (NSArray <LQAGroupEntity*>*)getResultEntity;

- (NSInteger)totlePerson;

@end
