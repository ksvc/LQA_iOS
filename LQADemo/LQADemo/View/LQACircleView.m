//
//  LQACircleView.m
//  LQADemo
//
//  Created by yuyang on 2018/1/9.
//  Copyright © 2018年 Ksyun. All rights reserved.
//



#import "LQACircleView.h"
#import "LQATool.h"

@interface LQACountDownView ()
@property (nonatomic,strong)LQACircleView *circleView;
@property (nonatomic,strong)UIImageView *alterImg;
@property (nonatomic,strong)UILabel *lable;
@end
@implementation LQACountDownView

- (instancetype)init;
{
    self = [super init];
    if (!self) return nil;
    _showPeriod = 10000;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 30;
    self.layer.masksToBounds = YES;
    return self;
}

- (void)setShowPeriod:(NSInteger)showPeriod
{
    _showPeriod = showPeriod;
    self.circleView.showPeriod = showPeriod;
}

- (NSInteger)getTotalTime
{
    return _showPeriod/1000;
}

- (void)setAlterStatus:(AlterStatus)alterStatus
{
  
    self.lable.text =[NSString stringWithFormat:@"%ld",[self getTotalTime]];
    _alterStatus =alterStatus;
    switch (alterStatus) {
        case AlterStatusAnswering:
        {
             self.alterImg.hidden = YES;
             self.circleView.isMatch = NO;
             self.lable.hidden = NO;
             [self start];
        }
            break;
        case AlterStatusAnswerRight:
        {
            self.alterImg.hidden = NO;
            self.lable.hidden = YES;
            self.alterImg.image = [UIImage imageNamed:@"answer_right"];
            self.circleView.isMatch = NO;
             [self stop];
        }
            break;
        case AlterStatusAnswerError:
        {
            self.alterImg.hidden = NO;
            self.alterImg.image = [UIImage imageNamed:@"answer_error"];
            self.circleView.isMatch = NO;
            self.lable.hidden = YES;
             [self stop];
        }
            break;
        case AlterStatusAnsweringMatch:
        {
            self.alterImg.hidden = NO;
            self.alterImg.image = [UIImage imageNamed:@"match"];
            self.circleView.isMatch = YES;
            self.lable.hidden = YES;
            [self start];
        }
            break;
        case AlterStatusAnswerResultMatch:
        {
            self.alterImg.hidden = NO;
            self.alterImg.image = [UIImage imageNamed:@"match"];
            self.circleView.isMatch = NO;
            self.lable.hidden = YES;
            [self stop];
        }
            break;
        default:
            self.alterImg.hidden = YES;
            self.lable.hidden = YES;
            break;
    }
}

- (LQACircleView *)circleView
{
    if (!_circleView) {
        _circleView = [[LQACircleView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    }
    return _circleView;
}
- (UILabel *)lable
{
    if (!_lable) {
        _lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _lable.textColor = [UIColor blackColor];
        _lable.backgroundColor = [UIColor clearColor];
        _lable.font = [UIFont systemFontOfSize:24];
        _lable.textAlignment = NSTextAlignmentCenter;
        _lable.text = [NSString stringWithFormat:@"%ld",[self getTotalTime]];
    }
    return _lable;
}

- (void)setup
{
    if (!_circleView) {
         [self addSubview:self.circleView];
    }
    if (!_lable) {
          [self addSubview:self.lable];
    }
  
   
    @KSYWeakObj(self);
    self.circleView.countDownBlcok = ^(NSString *str) {
        @KSYStrongObj(self);
        if (self.countDownBlcok) {
            self.countDownBlcok(str);
        }
        if ([str isEqualToString:@"0"]) {
            self.alterImg.hidden = NO;
            self.circleView.hidden = YES;
            if (_alterStatus==AlterStatusAnswering) {
                self.alterImg.image = [UIImage imageNamed:@"count_down"];
            }
            else if (_alterStatus==AlterStatusAnsweringMatch)
            {
                 self.alterImg.image = [UIImage imageNamed:@"match"];
            }
    
        }
        self.lable.text = str;
     
    };
    
    _alterImg = [[UIImageView  alloc]initWithFrame:CGRectMake(3, 3, self.frame.size.width-6, self.frame.size.height-6)];
    [self addSubview:_alterImg];
    _alterImg.hidden = YES;
}

- (void)layoutSubviews
{
    [self setup];
}

- (void)start
{
    [_circleView start];
    _circleView.hidden = NO;
}

- (void)stop
{
    [_circleView stop];
    _circleView.hidden = YES;
}



@end
@interface LQACircleView ()
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,assign)NSInteger count;
@end
@implementation LQACircleView


- (instancetype)initWithFrame:(CGRect)frame
{
    self= [super initWithFrame:frame];
    if (!self) return nil;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 30;
    self.layer.masksToBounds = YES;
    _showPeriod = 10000;
    return self;
}

- (NSInteger)getTotalTime
{
    return _showPeriod/1000;
}

- (void)start
{
    [self stop];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(action) userInfo:nil repeats:YES];
    self.count = 0;
    self.hidden = NO;
}

- (void)stop
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)action{
    self.count++;//时间累加
    
    if (self.count == 100*[self getTotalTime]) {
        self.hidden = YES;
        [self stop];
        
    }
    if (self.count%100 == 0) {
        if (self.countDownBlcok) {
            self.countDownBlcok([NSString stringWithFormat:@"%ld",[self getTotalTime] - self.count/100]);
        }
    }
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    //CGContextSetRGBStrokeColor(context, 66/255, 203/255, 242/255, 1);// 设置颜色
    CGContextRef context = UIGraphicsGetCurrentContext();//获取上下文对象  只要是用了 CoreGraPhics  就必须创建他
    CGContextSetLineWidth(context, 6);//显然是设置线宽
     if (self.count>=([self getTotalTime]-3)*100&&!self.isMatch) {
        CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);// 设置颜色
    }
    else
    {
        CGContextSetRGBStrokeColor(context, 0.25, 0.8, 0.94, 1);// 设置颜色
    }
    float start =  M_PI*1.5;
    
    CGContextAddArc(context, self.frame.size.width/2.0, self.frame.size.height/2.0, self.bounds.size.width/2.0 , start , self.count/([self getTotalTime]*100.0) * 2* M_PI+start, 0);//这就是画曲线了

    /*
     CGContextAddArc(上下文对象    ,     圆心x,     圆心y,     曲线开始点,    曲线结束点,     半径);
     */
    CGContextStrokePath(context);
}


@end
