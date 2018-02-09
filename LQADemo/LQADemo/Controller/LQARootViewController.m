//
//  LQARootViewController.m
//  LQADemo
//
//  Created by yuyang on 2018/1/9.
//  Copyright © 2018年 Ksyun. All rights reserved.
//

#import "LQARootViewController.h"
#import "LQARoomViewController.h"
#import "LQATool.h"
#import "LQAAlterView.h"


@interface LQARootViewController ()
@property (nonatomic,strong)LQAAlterView *alterView;

@end

@implementation LQARootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self.view addSubview:self.alterView];
    
}


- (void)joinRoom
{
    [self presentViewController:[LQARoomViewController new] animated:YES completion:nil];
}

- (void)lookRanking
{
    
}

- (void)ruleAction
{
    [self.alterView show];
}

- (void)avatarAction
{
    
}

-(BOOL)prefersStatusBarHidden

{
    [super prefersStatusBarHidden];
    return NO;// 返回YES表示隐藏，返回NO表示显示
}



- (void)initUI
{
    
    @KSYWeakObj(self);
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    bgImageView.image = [UIImage  imageNamed:@"home_bg"];
    [self.view addSubview:bgImageView];
    
    UIButton *ruleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ruleBtn setImage:[UIImage imageNamed:@"rule"] forState:UIControlStateNormal];
    [ruleBtn addTarget:self action:@selector(ruleAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ruleBtn];
    
    UIButton *avatarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [avatarBtn setImage:[UIImage imageNamed:@"user_avatar"] forState:UIControlStateNormal];
    [avatarBtn addTarget:self action:@selector(avatarAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:avatarBtn];
    
    

    UIButton *joinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [joinBtn setTitle:@"进入直播" forState:UIControlStateNormal];
    [joinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    joinBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    joinBtn.layer.cornerRadius = 23;
    joinBtn.layer.masksToBounds = YES;
    joinBtn.backgroundColor = LQAUIColorFromRGB(0xFC316C);
    [joinBtn addTarget:self action:@selector(joinRoom) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:joinBtn];
    
//    UIImageView *joinIcon = [[UIImageView  alloc]init];
//    joinIcon.image = [UIImage imageNamed:@"join_icon"];
//    [self.view addSubview:joinIcon];
    
    UIView *middleView = [[UIView alloc]init];
    middleView.layer.cornerRadius = 10;
    middleView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:middleView];
    
    UILabel *liveLable =  [[UILabel alloc]init];
    liveLable.text = @"场次预告";
    liveLable.textColor = LQAUIColorFromRGB(0x999999);
    liveLable.font = [UIFont systemFontOfSize:16];
    liveLable.textAlignment = NSTextAlignmentCenter;
    [middleView addSubview:liveLable];
    
    UILabel *liveTimeLable =  [[UILabel alloc]init];
    liveTimeLable.text = @"15:00             19:00";
    liveTimeLable.textColor = [UIColor blackColor];
    liveTimeLable.font = [UIFont boldSystemFontOfSize:20];
    liveTimeLable.textAlignment = NSTextAlignmentCenter;
    [middleView addSubview:liveTimeLable];
  
    
    
    
    // 下面view
    
    UIView *bottomView = [[UIView alloc]init];
    bottomView.layer.cornerRadius = 10;
    bottomView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    
    UIButton *lookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [lookBtn setTitle:@"查看排行榜 >" forState:UIControlStateNormal];
    lookBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    lookBtn.backgroundColor = [UIColor clearColor];
    [lookBtn addTarget:self action:@selector(lookRanking) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lookBtn];
    
    
    UILabel *moneylable = [[UILabel alloc]init];
    moneylable.text = @"奖金";
    moneylable.textColor = LQAUIColorFromRGB(0x999999);
    moneylable.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:moneylable];
    
    UILabel *datalable = [[UILabel alloc]init];
    datalable.text = @"今天";
    datalable.textColor = LQAUIColorFromRGB(0x999999);
    datalable.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:datalable];
    
    
    UIImageView *moneySublable = [[UIImageView alloc]init];
    moneySublable.image = [UIImage imageNamed:@"money"];
    [self.view addSubview:moneySublable];

    UIImageView *dateSublable = [[UIImageView alloc]init];
    dateSublable.image = [UIImage imageNamed:@"date"];
    [self.view addSubview:dateSublable];
    
    
    
    
//    NSMutableAttributedString *richText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  %@",sName,sContent]];
//    [richText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12.0] range:NSMakeRange(0, sName.length)];//设置字体大小
//    [richText addAttribute:NSForegroundColorAttributeName value:LQAUIColorFromRGB(0xBBBAFF) range:NSMakeRange(0, sName.length)];//设置字体颜色
    
    
    
    
 
    
    [ruleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @KSYStrongObj(self);
        make.top.equalTo(self.view).with.offset(30);
        make.left.equalTo(self.view).with.offset(22);
        make.size.mas_equalTo(CGSizeMake(24, 24));
        
    }];
    
    [avatarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @KSYStrongObj(self);
        make.top.equalTo(self.view).with.offset(30);
        make.right.equalTo(self.view).with.offset(-22);
        make.size.mas_equalTo(CGSizeMake(24, 24));
        
    }];
    
    [joinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @KSYStrongObj(self);
        make.top.equalTo(self.view).with.offset(150);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(200, 46));

    }];
    
//    [joinIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//        @KSYStrongObj(self);
//        make.top.equalTo(self.view).with.offset(165);
//        make.left.equalTo(joinBtn.mas_centerX).offset(40);
//        make.size.mas_equalTo(CGSizeMake(8, 10));
//        
//    }];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        @KSYStrongObj(self);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-113);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(136);
        
    }];
    
    [lookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @KSYStrongObj(self);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-17);
        make.left.equalTo(self.view).offset(140);
        make.right.equalTo(self.view).offset(-140);
        make.height.mas_equalTo(20);
        
    }];
    
    
    [moneylable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top).with.offset(28);
        make.centerX.equalTo(bottomView.mas_left).with.offset((kLQADeviceWidth-30)/4);
        make.height.mas_equalTo(20);
        
    }];
    
    [datalable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top).with.offset(28);
        make.centerX.equalTo(bottomView.mas_left).with.offset((kLQADeviceWidth-30)*3/4);
        make.height.mas_equalTo(20);
        
    }];
    
    [moneySublable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneylable.mas_bottom).with.offset(10);
        make.centerX.equalTo(bottomView.mas_left).with.offset((kLQADeviceWidth-30)/4);
        make.size.mas_equalTo(CGSizeMake(60, 35));
        
    }];
    
    [dateSublable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(datalable.mas_bottom).with.offset(10);
        make.centerX.equalTo(bottomView.mas_left).with.offset((kLQADeviceWidth-30)*3/4);
        make.size.mas_equalTo(CGSizeMake(94, 34));
        
    }];
    
    
    // mid
    
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        @KSYStrongObj(self);
        make.top.equalTo(joinBtn.mas_bottom).with.offset(95);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(107);
        
    }];
    
    [liveLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(middleView.mas_top).with.offset(21);
        make.left.equalTo(middleView).offset(0);
        make.right.equalTo(middleView).offset(0);
        make.height.mas_equalTo(22);
        
    }];
    
    [liveTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(liveLable.mas_bottom).with.offset(11);
        make.left.equalTo(middleView).offset(0);
        make.right.equalTo(middleView).offset(0);
        make.height.mas_equalTo(30);
        
    }];

    
}


- (LQAAlterView *)alterView
{
    if (!_alterView) {
        _alterView = [[LQAAlterView alloc]init];
        _alterView.alter = LQAAlterExplain;
        [_alterView dismiss];
    }
    return _alterView;
}






@end
