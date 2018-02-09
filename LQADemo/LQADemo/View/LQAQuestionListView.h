//
//  LQAQuestionListView.h
//  LQADemo
//
//  Created by yuyang on 2018/1/10.
//  Copyright © 2018年 Ksyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQATool.h"
#import <LQASDK/LQAConfigHeader.h>
@interface LQAQuestionHeadView : UIView
@property (nonatomic,assign)AlterStatus  alterStatus;
@property (nonatomic,copy) NSString *title;

+ (CGSize)getSizeFromString:(NSString *)string;

- (void)showAlterView:(NSString *)alterString;

- (void)hideAlterView;



@end

@interface LQAQuestionListCell : UITableViewCell
@property (nonatomic,assign)AlterStatus  alterStatus;
@property (nonatomic,assign) NSInteger totlePerson;

+ (CGSize)getSizeFromString:(NSString *)string;

- (void)resetOptionModel:(LQAOptionsEntity*)optionsEntity;

- (void)resetGroupModel:(LQAGroupEntity*)optionsEntity;

@end

@interface LQAQuestionListView : UIView
@property (nonatomic,assign)AlterStatus  alterStatus;
@property (nonatomic,strong)LQAEntity *entity;
@property (nonatomic,assign)BOOL isAnwserSelected;
- (void)reloadArray:(NSArray *)array;

- (void)setErrorString:(NSString *)errorString;



@end
