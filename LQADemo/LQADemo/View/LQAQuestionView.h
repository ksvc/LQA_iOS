//
//  LQAQustionView.h
//  LQADemo
//
//  Created by yuyang on 2018/1/9.
//  Copyright © 2018年 Ksyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQATool.h"
#import <LQASDK/LQAConfigHeader.h>
@interface LQAQuestionView : UIView

@property (nonatomic,strong)LQAEntity *entity;

- (void)setQuestionStatus:(AlterStatus) alterStatus;

- (void)show;

- (void)dismiss;

- (void)setErrorString:(NSString *)errorString;


@end
