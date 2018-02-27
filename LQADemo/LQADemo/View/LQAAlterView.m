//
//  LQAAlterView.m
//  LQADemo
//
//  Created by yuyang on 2018/1/10.
//  Copyright © 2018年 Ksyun. All rights reserved.
//

#import "LQAAlterView.h"
#import "LQATool.h"
@interface LQAAlterView ()
@property (nonatomic,strong)UIButton *closeBtn;
@property (nonatomic,strong)UIImageView *iconImageView;
@property (nonatomic,strong)UILabel *titleLable;
@property (nonatomic,strong)UIButton *bottomBtn;
@property (nonatomic,strong)UILabel *moneyLable;

@property (nonatomic,strong)UITextView *explainTextView;
@property (nonatomic,strong)UILabel *explainTitleLable;

@end
@implementation LQAAlterView
- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5f];
    [self setup];
    self.alter = LQAAlterUsedCard;
    return self;
}

- (void)setMoney:(NSString *)money
{
    self.moneyLable.text = [NSString stringWithFormat:@"￥%@元",money];
}

- (void)setAlter:(LQAAlter)alter
{
    switch (alter) {
        case LQAAlterUsedCard:
        {
            _iconImageView.image = [UIImage imageNamed:@"card"];
            _titleLable.text =@"已为您自动使用复活卡";
            _bottomBtn.hidden = NO;
            [_bottomBtn setTitle:@"继续答题" forState:UIControlStateNormal];
            _moneyLable.hidden = YES;
            _iconImageView.hidden = NO;
            _titleLable.hidden  = NO;
            _explainTitleLable.hidden = YES;
            _explainTextView.hidden = YES;
        }
            break;
        case LQAAlterSelfWin:
        {
            _iconImageView.image = [UIImage imageNamed:@"winner"];
            _titleLable.text =@"恭喜您获得现金奖励";
            _bottomBtn.hidden = YES;
            _moneyLable.hidden = NO;
            _iconImageView.hidden = NO;
            _titleLable.hidden  = NO;
            _explainTitleLable.hidden = YES;
            _explainTextView.hidden = YES;
        }
            break;
        case LQAAlterOtherWin:
        {
            _iconImageView.image = [UIImage imageNamed:@"other_winner"];
            _titleLable.text =@"本场获胜奖励金额";
            _bottomBtn.hidden = YES;
            _moneyLable.hidden = NO;
            _iconImageView.hidden = NO;
            _titleLable.hidden  = NO;
            _explainTitleLable.hidden = YES;
            _explainTextView.hidden = YES;
        }
            break;
        case LQAAlterLoser:
        {
            _iconImageView.image = [UIImage imageNamed:@"loser"];
            _titleLable.text =@"很遗憾，您答错了～";
            [_bottomBtn setTitle:@"继续观看" forState:UIControlStateNormal];
            _bottomBtn.hidden = NO;
            _moneyLable.hidden = YES;
            _iconImageView.hidden = NO;
            _titleLable.hidden  = NO;
            _explainTitleLable.hidden = YES;
            _explainTextView.hidden = YES;
        }
            break;
        case LQAAlterExplain:
        {
            _titleLable.hidden  = YES;
            _bottomBtn.hidden = YES;
            _moneyLable.hidden = YES;
            _iconImageView.hidden = YES;
            _titleLable.hidden  = YES;
            _explainTitleLable.hidden = NO;
            _explainTextView.hidden = NO;
        }
            break;
            
        default:
            break;
    }
}

- (void)closeAction
{
    [self dismiss];
}

- (void)setup
{
    UIView *whiteView = [[UIView alloc]init];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.cornerRadius = 20;
    whiteView.layer.masksToBounds = YES;
    [self addSubview:whiteView];
    
    _explainTextView = [[UITextView alloc]init];
    _explainTextView.editable = NO;
    _explainTextView.userInteractionEnabled = NO;
    [self addSubview:_explainTextView];
    
    
    _explainTextView.attributedText = [self getRichText];
    
    _explainTitleLable = [[UILabel alloc]init];
    _explainTitleLable.font =[UIFont boldSystemFontOfSize:20];
    _explainTitleLable.textColor = [UIColor blackColor];
    _explainTitleLable.textAlignment = NSTextAlignmentCenter;
    _explainTitleLable.text =@"游戏规则";
    [self addSubview:_explainTitleLable];
    
    
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_closeBtn];
    
    _iconImageView = [[UIImageView alloc]init];
    [self addSubview:_iconImageView];
    
    _titleLable = [[UILabel alloc]init];
    _titleLable.textColor = [UIColor blackColor];
    _titleLable.font =[UIFont boldSystemFontOfSize:20];
    _titleLable.textAlignment = NSTextAlignmentCenter;
    [self  addSubview:_titleLable];
    
    _bottomBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [_bottomBtn setTitleColor:LQAUIColorFromRGB(0X4A90E2) forState:UIControlStateNormal];
    _bottomBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_bottomBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_bottomBtn];
    
    _moneyLable = [[UILabel alloc]init];
    _moneyLable.textColor = LQAUIColorFromRGB(0xFC2F6B);
    _moneyLable.font =[UIFont boldSystemFontOfSize:24];
    _moneyLable.textAlignment = NSTextAlignmentCenter;
    [self  addSubview:_moneyLable];
    
    @KSYWeakObj(self);
    
    [_explainTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteView.mas_top).with.offset(15);
        make.left.equalTo(whiteView.mas_left).with.offset(0);
        make.right.equalTo(whiteView.mas_right).with.offset(0);
        make.height.mas_equalTo(24);
    }];
    [_explainTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteView.mas_top).with.offset(60);
        make.left.equalTo(whiteView.mas_left).with.offset(20);
        make.right.equalTo(whiteView.mas_right).with.offset(-20);
        make.bottom.equalTo(whiteView.mas_bottom).with.offset(-20);
    }];
    
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        @KSYStrongObj(self);
        make.left.equalTo(self).with.offset(13);
        make.center.equalTo(self);
        make.height.mas_equalTo(kLQADeviceWidth-30);
        make.right.equalTo(self).with.offset(-13);
    }];
    
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(whiteView.mas_right).with.offset(-15);
        make.top.equalTo(whiteView.mas_top).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteView.mas_top).with.offset(40);
        make.centerX.equalTo(whiteView);
        make.size.mas_equalTo(CGSizeMake(168, 174));
    }];
    
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView.mas_bottom).with.offset(12);
        make.left.equalTo(whiteView).with.offset(0);
        make.right.equalTo(whiteView).with.offset(0);
        make.height.mas_equalTo(22);
    }];
    
    [_bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLable.mas_bottom).with.offset(18);
        make.left.equalTo(_titleLable).with.offset(0);
        make.right.equalTo(_titleLable).with.offset(0);
        make.height.mas_equalTo(20);
    }];
    
    [_moneyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLable.mas_bottom).with.offset(18);
        make.left.equalTo(whiteView).with.offset(0);
        make.right.equalTo(whiteView).with.offset(0);
        make.height.mas_equalTo(33);
    }];
}

- (NSMutableAttributedString *)getRichText;
{
    NSString *firstString = @"第一步：准时参加直播节目";
    NSString *firstSubString = @"我们将在节目开始前通知你，请确保手机通知权限开启";
    NSString *secondString = @"第二步：参与竞答";
    NSString *secondSubString = @"回答正确闯入下一关，答错即淘汰";
    NSString *lastString = @"最终:全对者平分现金大奖";
    NSString *lastSubString = @"如果所有玩家都被淘汰，本期奖金将自动进入下一期";
    
    
    NSMutableAttributedString *richText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@\n\n%@\n%@\n\n%@\n%@\n\n",firstString,firstSubString,secondString,secondSubString,lastString,lastSubString]];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    
    [paragraphStyle setLineSpacing:8];
    [richText addAttribute:NSParagraphStyleAttributeName
     
                     value:paragraphStyle
     
                     range:NSMakeRange(0, richText.length)];
    
    
    NSInteger location = 0;
    [richText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18.0] range:NSMakeRange(location, firstString.length)];//设置字体大小
    [richText addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(location, firstString.length)];//设置字体颜色
    
    
    location =location+firstString.length;
    [richText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:NSMakeRange(location, firstSubString.length)];//设置字体大小
    [richText addAttribute:NSForegroundColorAttributeName value:LQAUIColorFromRGB(0x3F3F3F) range:NSMakeRange(location, firstSubString.length)];//设置字体颜色
    
    location =location+firstSubString.length+3;
    [richText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18.0] range:NSMakeRange(location, secondString.length)];//设置字体大小
    [richText addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(location, secondString.length)];//设置字体颜色
    
    location =location+secondString.length;
    [richText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:NSMakeRange(location, secondSubString.length)];//设置字体大小
    [richText addAttribute:NSForegroundColorAttributeName value:LQAUIColorFromRGB(0x3F3F3F) range:NSMakeRange(location, secondSubString.length)];//设置字体颜色
    
    
    location =location+secondSubString.length+3;
    [richText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18.0] range:NSMakeRange(location, lastString.length)];//设置字体大小
    [richText addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(location, lastString.length)];//设置字体颜色
    
    location =location+lastString.length;
    [richText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:NSMakeRange(location, lastSubString.length)];//设置字体大小
    [richText addAttribute:NSForegroundColorAttributeName value:LQAUIColorFromRGB(0x3F3F3F) range:NSMakeRange(location, lastSubString.length)];//设置字体颜色
    
    return richText;
}

- (void)show
{
    self.hidden = NO;
}

- (void)dismiss
{
    self.hidden = YES;
}

- (void)autoDismiss
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ((self.hidden ==NO)) {
            [self dismiss];
        }
    });
}

- (void)autoShow
{
    [self show];
    [self autoDismiss];
}

@end
