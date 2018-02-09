//
//  LQACircleView.h
//  LQADemo
//
//  Created by yuyang on 2018/1/9.
//  Copyright © 2018年 Ksyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQATool.h"

typedef void (^countDownBlcok_t)(NSString *str);
@interface LQACountDownView : UIView
@property (nonatomic,assign)AlterStatus alterStatus;
@property (nonatomic,copy)countDownBlcok_t countDownBlcok;
@property (nonatomic,assign) NSInteger showPeriod; //毫秒单位

- (void)start;

- (void)stop;

@end



@interface LQACircleView : UIView

@property (nonatomic,copy)countDownBlcok_t countDownBlcok;
@property (nonatomic,assign) BOOL isMatch;
@property (nonatomic,assign) NSInteger showPeriod; //毫秒单位

- (void)start;

- (void)stop;

@end
