//
//  LQAQustionView.m
//  LQADemo
//
//  Created by yuyang on 2018/1/9.
//  Copyright © 2018年 Ksyun. All rights reserved.
//

#import "LQAQuestionView.h"
#import "LQACircleView.h"
#import "LQAQuestionListView.h"


@interface LQAQuestionView ()
@property (nonatomic,strong)LQACountDownView *circleView;
@property (nonatomic,strong)LQAQuestionListView *questionListView;
@property (nonatomic,assign)AlterStatus alterStatus;
@property (nonatomic,strong)UIView *whiteView;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,assign)NSInteger  time;

@end
@implementation LQAQuestionView

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    _time = 0;
    _alterStatus = AlterStatusStart;
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5f];
    [self setup];
    return self;
}

- (void)setEntity:(LQAEntity *)entity
{
    _entity = entity;
    self.questionListView.entity = _entity;
    if (entity.showPeriod) {
         self.circleView.showPeriod = [entity.showPeriod integerValue];
    }
  
    [self reloadArray:entity.options];
}

- (void)reloadArray:(NSArray *)array
{
    float height =170;
    CGSize size = [LQAQuestionHeadView getSizeFromString:_entity.title];
    if (size.height>100)
    {
        height = 120+size.height;
    }
    __block int  optionHeight  = 0;
    [array enumerateObjectsUsingBlock:^(LQAOptionsEntity* optionsEntity, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *string =[NSString  stringWithFormat:@"%@.  %@",optionsEntity.option,optionsEntity.text];
        CGSize size =[LQAQuestionListCell getSizeFromString:string];
        CGFloat height  = 50;
        if (size.height>50) {
            height = size.height;
        }
        optionHeight =optionHeight +height+10;
    }];
    
    height =height +optionHeight;
    

    float topHeight  = 50;
    if (kLQADevice_Is_iPhoneX) {
        topHeight= topHeight+20;
    }

    @KSYWeakObj(self);
    [_whiteView mas_updateConstraints:^(MASConstraintMaker *make) {
        @KSYStrongObj(self);
        make.top.equalTo(self).with.offset(topHeight);
        make.left.equalTo(self).with.offset(13);
        make.right.equalTo(self).with.offset(-13);
        make.height.mas_equalTo(height);
    }];
    
    [self.circleView mas_updateConstraints:^(MASConstraintMaker *make) {
        @KSYStrongObj(self);
        make.top.equalTo(self).with.offset(topHeight/2);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    [self.questionListView reloadArray:array];
    
    
}

- (void)setup
{
    _whiteView = [[UIView alloc]init];
    _whiteView.backgroundColor = [UIColor whiteColor];
    _whiteView.layer.cornerRadius = 20;
    _whiteView.layer.masksToBounds = YES;
    [self addSubview:_whiteView];
    
    @KSYWeakObj(self);
    
    float topHeight  = 50;
    if (kLQADevice_Is_iPhoneX) {
        topHeight= topHeight+40;
    }
    
    [_whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        @KSYStrongObj(self);
        make.top.equalTo(self).with.offset(topHeight);
        make.left.equalTo(self).with.offset(13);
        make.right.equalTo(self).with.offset(-13);
        make.height.mas_equalTo(kLQADeviceWidth-30);
    }];
    
    [self addSubview:self.circleView];
    
    [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        @KSYStrongObj(self);
        make.top.equalTo(self).with.offset(25);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    [self addSubview:self.questionListView];
    
}

- (void)setQuestionStatus:(AlterStatus) alterStatus
{
    _alterStatus =alterStatus;
    self.questionListView.alterStatus =alterStatus;
    [self show];
    switch (alterStatus) {
        case AlterStatusAnswering:
        {
           [self stopTimer];
           [self.circleView stop];
           [self.circleView setAlterStatus:alterStatus];
        }
            break;
        case AlterStatusAnswerRight:
        {
            [self handleResult:alterStatus];
           
        }
            break;
        case AlterStatusAnswerError:
        {
            [self handleResult:alterStatus];
        }
        break;
        case AlterStatusAnsweringMatch:
        {
            [self stopTimer];
            [self.circleView stop];
            [self.circleView setAlterStatus:alterStatus];
        }
             break;
        case AlterStatusAnswerResultMatch:
        {
            [self handleResult:alterStatus];
        }
            break;
        default:
            break;
    }
}

- (void)startTimer
{
    _time ++;
    if (_time == [self showSecond]) {
        [self dismiss];
    }
    
}

- (void)stopTimer
{
    if (_timer) {
        [_timer invalidate];
        _timer  = nil;
    }
}

- (void)handleResult:(AlterStatus)alterStatus
{
    [self stopTimer];
    _time = 0;
    
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startTimer) userInfo:nil  repeats:YES];
    }
    [self.circleView setAlterStatus:alterStatus];
 
}

- (NSInteger )showSecond
{
    NSInteger   s = 5; //默认消失弹窗5 S
    if (self.entity.showPeriod) {
        s = [self.entity.showPeriod integerValue]/1000;
    }
    return s;
}


- (LQACountDownView *)circleView
{
    if (!_circleView) {
        _circleView = [[LQACountDownView alloc]init];
        @KSYWeakObj(self);
        _circleView.countDownBlcok = ^(NSString *str) {
            @KSYStrongObj(self);
            if ([str isEqualToString:@"0"]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self dismiss];
                });
            }
        };
    }
    return _circleView;
}

- (LQAQuestionListView *)questionListView
{
    if (!_questionListView) {
        _questionListView =[[LQAQuestionListView alloc]initWithFrame:CGRectMake(36, 100, self.frame.size.width-72, kLQADeviceHeight)];
    }
    return _questionListView;
}

- (void)show
{
    self.hidden = NO;
}

- (void)dismiss
{
    self.hidden = YES;
    self.questionListView.isAnwserSelected = NO;
}

- (void)setErrorString:(NSString *)errorString
{
    [self.questionListView setErrorString:errorString];
}

@end
