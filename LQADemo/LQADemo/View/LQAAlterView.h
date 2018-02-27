//
//  LQAAlterView.h
//  LQADemo
//
//  Created by yuyang on 2018/1/10.
//  Copyright © 2018年 Ksyun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LQAAlter){
    LQAAlterStart,  //开始
    LQAAlterUsedCard,//已经使用复活卡
    LQAAlterLoser,//淘汰
    LQAAlterSelfWin,//自己赢
    LQAAlterOtherWin,//其他人赢
    LQAAlterExplain,// 游戏说明
    LQAAlterEnd
};

@interface LQAAlterView : UIView
@property (nonatomic,assign)LQAAlter alter;

- (void)setMoney:(NSString *)money;

- (void)show;

- (void)dismiss;

- (void)autoDismiss;

- (void)autoShow;

@end
