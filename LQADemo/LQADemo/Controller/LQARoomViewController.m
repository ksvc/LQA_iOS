//
//  LQARoomViewController.m
//  LQADemo
//
//  Created by yuyang on 2018/1/9.
//  Copyright © 2018年 Ksyun. All rights reserved.
//

#import "LQARoomViewController.h"
#import "LQATool.h"
#import "LQAChatListView.h"
#import "LQAQuestionView.h"
#import "LQAAlterView.h"
#import "LQAChatSendMessageView.h"
#import <LQASDK/LQAClient.h>
#import <MJExtension/MJExtension.h>
#import <KSYMediaPlayer/KSYMoviePlayerController.h>
#import "LQANet.h"


//#define kPlayUrl @"http://mobile.kscvbu.cn:8080/live/lqa.flv"




@interface LQARoomViewController ()<UIAlertViewDelegate>
@property (nonatomic,strong)LQAChatListView *chatListView;
@property (nonatomic,strong)LQAQuestionView *questionView;
@property (nonatomic,strong)LQAAlterView *alterView;
@property (nonatomic,strong)LQAChatSendMessageView *messageView;
@property (nonatomic,strong)KSYMoviePlayerController *player;
@property (nonatomic,strong)LQAClient *client;
@property (nonatomic,strong)LQAEntity *tempResultEntity;//主要获取答案

/**
 * 计算请求信令的时间戳，毫秒，由AppServer颁发。（仅当启用了请求信令功能时有效，有效时间窗口需要通过技术支持进行配置）
 */
@property (nonatomic,copy)NSString *signalingTimestamp;
/**
 *   请求信令，由AppServer根据服务端Token、AppKey、UID、Timestamp计算md5得出，形如 md5({Token}\n{Appkey}\n{UID}\n{Timestamp})。（仅当启用了请求信令功能时有效，有效时间窗口需要通过技术支持进行配置）
 */
@property (nonatomic,copy)NSString *requestSignaling;


@property (nonatomic,strong)NSMutableArray * receiveReultChatArray;//缓存收到聊天数据
@property (nonatomic,strong)NSTimer * messageTimer;//定时器
@property (nonatomic,assign)NSInteger count;
@property (nonatomic,strong)UIButton *chatBtn;
@property (nonatomic,copy) NSString  *playUrl;

@end

@implementation LQARoomViewController

#pragma mark sdk相关


- (void)demoInitClient
{
    @KSYWeakObj(self);
    LQAConfig *config = [[LQAConfig alloc]init];
    config.ksyunAppKey =@"CmFAXgBFXwk02TB0xcD";
    config.imInfoKey = @"y745wfm8y1kbv";
    config.imInfoAccessToken = @"yyPYg5POTzu7p9Nb1/A4bLuaR0OYOhIT+2ZHKc2sV+gyHLEzSrzJ5flwDcy3vOAQM4n2+7ktRIQ83tmwTefknt2XOzDJvkTPXflk7TFEtVQ1lJsloSWoXSxPv61sE50anf/3LZN5XreutXczVFwzZQ==";
    config.userId =[[[[UIDevice currentDevice] identifierForVendor] UUIDString] lowercaseString];
    config.userExtraLiveCount = 4;
    config.maxExtraLiveUsedInContest =  1;
    config.serverUserId = @"ksyun";
    config.chatMessageId = @"88888888";
    config.contestLiveId =@"1234200";//场次
    config.canJoin = YES;
    config.playerUrl = _playUrl;
    config.mediaPlayer = self.player;
    _client = [[LQAClient alloc]initWithConfig:config success:^(id  _Nullable model) {
        @KSYStrongObj(self)
        //加入聊天
        [self.client joinRoomWith:@"99999999" success:^{
            NSLog(@"加入聊天成功");
        } failure:^(RCErrorCode errorCode) {
            NSLog(@"加入聊天失败");
        }];

    }];
    [_client openLog:YES];
    [self addListenClient];
}

- (void)demoTestInitClient:(LQANetModel *)model
{
    @KSYWeakObj(self);
    LQAConfig *config = [[LQAConfig alloc]init];
    config.ksyunAppKey =model.kscAppKey;
    config.imInfoKey = model.rcAppKey;
    config.imInfoAccessToken = model.rcToken;
    config.userId =[[[[UIDevice currentDevice] identifierForVendor] UUIDString] lowercaseString];
    config.userExtraLiveCount = [model.lives integerValue]+3;
    NSLog(@"初始化复活卡个数%ld",[model.lives integerValue]);
    config.maxExtraLiveUsedInContest =  [model.maxExtraLives integerValue];
    NSLog(@"初始化最大使用复活卡个数%ld",[model.maxExtraLives integerValue]+3);
    config.serverUserId = model.imUser;
    config.chatMessageId = model.questionRoom;
    config.contestLiveId =model.liveId;//场次
    config.canJoin = YES;
    config.playerUrl = _playUrl;
    config.mediaPlayer = self.player;
    _client = [[LQAClient alloc]initWithConfig:config success:^(id  _Nullable model1) {
        @KSYStrongObj(self)
        //加入聊天
        [self.client joinRoomWith:model.messageRoom success:^{
            NSLog(@"加入聊天成功");
        } failure:^(RCErrorCode errorCode) {
            NSLog(@"加入聊天失败");
        }];
        
    }];
    
    [self addListenClient];
    [_client openLog:YES];
}


- (void)initClient
{
//    [self demoInitClient];
//    [self.player setUrl:[NSURL URLWithString:_playUrl]];
//    [self.player prepareToPlay];
    //测试接口需要app端自己实现接口
    NSDictionary *dic =@{@"command":@"testforapp",@"uid":[[[[UIDevice currentDevice] identifierForVendor] UUIDString] lowercaseString]};
    //NSDictionary *header = @{@"X-KSC-Token":@"fc198baf69f3f93c61a00ff80b8b902f"};
    NSDictionary *header = @{@"X-KSC-Token":@"smsiwejsjiwjsaaople892jasjka"};
    [LQANet POST:kUrl header:header  param:dic modelClass:[LQANetModel class] success:^(id _Nullable model ) {

        if ([model isKindOfClass:[LQANetModel class]]) {

            LQANetModel *netModel = model;
            _playUrl = netModel.liveUrl;
            _signalingTimestamp = netModel.signalingTimestamp;
            _requestSignaling   = netModel.requestSignaling;
            [self.player setUrl:[NSURL URLWithString:_playUrl]];
            [self.player prepareToPlay];
            [self demoTestInitClient:model];


        }

    } failure:^(NSError * _Nonnull error) {

    }];
    
}

- (void)addListenClient
{
    @KSYWeakObj(self);
    //监听收到的聊天信息
    _client.chatMessageListener = ^(RCMessage *message) {
        @KSYStrongObj(self)
        [self recivedMessage:message];
    };
    //监听收到的题目数据
    _client.questionListener = ^(LQAEntity *entity) {
        @KSYStrongObj(self)
        [self.alterView dismiss];
        NSLog(@"使用复活卡数量===%ld", [self.client getUsedReviveCardCount] );
        [self answering:entity];
    };
    
    //监听收到的答题结果数据
    _client.resultListener = ^(LQAEntity *entity) {
        @KSYStrongObj(self)
        [self.alterView dismiss];
        NSLog(@"使用复活卡数量===%ld", [self.client getUsedReviveCardCount] );
        [self answerResult:entity];
    };
    //使用答题卡
    _client.userReviveCardListener = ^(NSInteger residueCardNum) {
        @KSYStrongObj(self)
        NSLog(@"使用复活卡数量===%ld", [self.client getUsedReviveCardCount] );
        //等待答题结果显示之后 弹出弹窗
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([self getQuestionResultShowTime] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.questionView dismiss];
            self.alterView.alter = LQAAlterUsedCard;
            [self.alterView autoShow];
        });
    };
    //淘汰
    _client.loserListener = ^{
        @KSYStrongObj(self)
        //等待答题结果显示之后 弹出弹窗
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([self getQuestionResultShowTime] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.questionView dismiss];
            self.alterView.alter = LQAAlterLoser;
            [self.alterView autoShow];
        });
    };
    //获胜
    _client.winerListener = ^(NSString *money,BOOL isSelf,LQAEntity *enity) {
        @KSYStrongObj(self)
        [self.questionView dismiss];
        if (isSelf) {
            self.alterView.alter = LQAAlterSelfWin;
            [self.alterView setMoney:money];
            [self.alterView show];
        }
        else
        {
            self.alterView.alter = LQAAlterOtherWin;
            [self.alterView setMoney:money];
            [self.alterView show];
        }
        
    };
    _client.statusListener = ^(NSString * _Nullable status) {
        NSLog(@"当前状态: %@",status);
    };
    
}

- (NSUInteger )getQuestionResultShowTime
{
    NSInteger  s  = 5;
    if (self.tempResultEntity.showPeriod) {
        s = [self.tempResultEntity.showPeriod integerValue]/1000;
    }
    return s;
}

#pragma mark UI监听
- (void)addListen
{
    @KSYWeakObj(self);
    self.messageView.sendContentBlock = ^(NSString *message) {
        @KSYStrongObj(self);
        [self sendMessage:message];
    };
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectAnswer:) name:@"SelectedQuestion" object:nil];
    
}

- (void)selectAnswer:(NSNotification *)notification;
{
    NSDictionary * infoDic = [notification object];
    [_client answer:[infoDic objectForKey:@"answer"] signalingTimestamp:_signalingTimestamp requestSignaling:_requestSignaling success:^(id  _Nullable model) {
        NSLog(@"答题成功！");
    } failure:^(NSError * _Nullable error) {
        NSLog(@"答题失败！%ld %@",error.code,error.userInfo);
    }];
    
}
#pragma mark controller

- (void)answering:(LQAEntity *)entity
{
    self.questionView.entity = entity;
    if (entity.userStatusAnswer == LQAUserStatusAnswerDoing) {
        [self.questionView setQuestionStatus:AlterStatusAnswering];
    }
    else if (entity.userStatusAnswer == LQAUserStatusAnswerMatch)
    {
        [self.questionView setQuestionStatus:AlterStatusAnsweringMatch];
        if ([self.client isFromFirstAnswering])
        {
            [self.questionView setErrorString:@"您已被淘汰，不能继续作答"];
        }
        else
        {
            [self.questionView setErrorString:@"您错过了开始时间，不能作答"];
        }
        
    }
}

- (void)answerResult:(LQAEntity *)entity
{
    self.questionView.entity = entity;
    _tempResultEntity = entity;
    if (entity.userStatusAnswer == LQAUserStatusAnswerRightDone)
    {
        [self.questionView setQuestionStatus:AlterStatusAnswerRight];
    }
    else if (entity.userStatusAnswer == LQAUserStatusAnswerWrongDone)
    {
        [self.questionView setQuestionStatus:AlterStatusAnswerError];
    }
    else if (entity.userStatusAnswer == LQAUserStatusAnswerMatch)
    {
        [self.questionView setQuestionStatus:AlterStatusAnswerResultMatch];
    }
    
    
}

- (void)sendMessage:(NSString *)message
{
    if (message.length==0) {
        return ;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:[[[[UIDevice currentDevice] identifierForVendor] UUIDString] lowercaseString] forKey:@"uid"];
    [dic setObject:message forKey:@"message"];
    NSString *json = [dic  mj_JSONObject];
    [self.client sendLiveChatMessage:json success:^(long messageId) {
        dispatch_async(dispatch_get_main_queue(), ^{
            LQAChat *chat = [[LQAChat alloc]init];
            chat.nick_name = [[self getUid] substringToIndex:7];
            chat.message = message;
            [self.chatListView addData:chat];
        });
    } failure:^(RCErrorCode failureCode, long messageId) {
        
    }];
}

- (NSString *)getUid
{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

- (void)recivedMessage:(RCMessage *)message{
    
    RCTextMessage *content = (RCTextMessage *)message.content;
    NSString *msgContent = content.content;
    NSString *uid ;
    if (!msgContent) {
        msgContent = @"{}";
    }
    NSError *error;
    NSDictionary *msgDict = [NSJSONSerialization JSONObjectWithData:[msgContent dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    NSString *messageContent =@"";
    if (error){
        NSLog(@"解析失败");
    }
    else
    {
        if ([msgDict.allKeys containsObject:@"uid"]) {
            uid =[msgDict objectForKey:@"uid"];
        }
        if ([msgDict.allKeys containsObject:@"message"]) {
            messageContent =[msgDict objectForKey:@"message"];
        }
    }
    LQAChat *chat = [[LQAChat alloc]init];
    chat.nick_name = [uid substringToIndex:7];
    chat.message = messageContent;
    if (self.receiveReultChatArray.count>500) {//数据大于500 删除最新的消息
        [self.receiveReultChatArray removeObject:self.receiveReultChatArray.firstObject];
    }
    [self.receiveReultChatArray addObject:chat];
    
}

- (void)getChatMessage
{
    if (self.receiveReultChatArray.count>0) {
        LQAChat *chat = self.receiveReultChatArray.firstObject;
        [self.chatListView addData:chat];
        [self.receiveReultChatArray removeObject:chat];
        
    }
}

#pragma mark UI 相关
-(void)stopPlayer{
    if (_player) {
        [_player stop];
        _player    = nil;
    }
}

- (KSYMoviePlayerController *)player
{
    if (!_player) {
        BOOL shouldUseHWCodec = YES;
        BOOL shouldAutoplay = YES;
        BOOL shouldMute = NO;
        _player = [[KSYMoviePlayerController alloc]initWithContentURL:nil];
        _player.videoDecoderMode = shouldUseHWCodec ? MPMovieVideoDecoderMode_Hardware : MPMovieVideoDecoderMode_Software;
        _player.shouldAutoplay = shouldAutoplay;
        _player.shouldMute = shouldMute;
        _player.view.frame =self.view.frame;
        _player.bufferTimeMax = 1;
    }
    return _player;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.messageTimer) {
        [self.messageTimer invalidate];
        self.messageTimer =  nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.receiveReultChatArray = [[NSMutableArray alloc]init];
    self.messageTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getChatMessage) userInfo:nil repeats:YES];
    
    [self initUI];
    _count = 0;
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer  alloc]initWithTarget:self action:@selector(clickTap)];
    //    tap.numberOfTouchesRequired =1 ;
    //    tap.numberOfTapsRequired =1;
    //[self.questionView addGestureRecognizer:tap];
    
    [self.view addSubview:self.chatListView];
    [self.view addSubview:self.questionView];
    [self.view addSubview:self.alterView];
    [self.view addSubview:self.messageView];
    [self.view addSubview:self.chatBtn];
    [self.view addSubview:self.player.view];
    [self.view insertSubview:self.player.view atIndex:1];
    @KSYWeakObj(self);
    [self.chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @KSYStrongObj(self);
        make.right.equalTo(self.view).with.offset(-15);
        make.bottom.equalTo(self.view).with.offset(-15);
        make.size.mas_equalTo(CGSizeMake(24, 22));
        
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillHide:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusChange:) name:MPMoviePlayerNetworkStatusChangeNotification object:nil];
    
    [self initClient];
    
    [self addListen];
    
    
    // Do any additional setup after loading the view.
}


- (void)clickTap
{
    [self.messageView resignFirstResponder];
}

- (void)networkStatusChange:(NSNotification *)noti
{
    if (_playUrl) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.player reload:[NSURL URLWithString:_playUrl]];
        });
        
    }
}

-(void)keyboardWillHide:(NSNotification*)notification{
    
    self.messageView.hidden = YES;
    self.chatBtn.hidden = NO;
    //CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.chatListView.frame = CGRectMake(15, kLQADeviceHeight-200-15, kLQADeviceWidth*3/4-15, 200);
    self.messageView.frame=CGRectMake(0, self.view.frame.size.height-70, self.view.frame.size.width, 60);
    self.questionView.frame = CGRectMake(0, 0, kLQADeviceWidth, kLQADeviceHeight);
    
    
}

- (void)keyboardWillShow:(NSNotification*)notification
{
    CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.chatListView.frame = CGRectMake(15, kLQADeviceHeight-200-15-keyboardFrame.size.height, kLQADeviceWidth*3/4-15, 200);
    self.messageView.hidden = NO;
    self.messageView.frame=CGRectMake(0, self.view.frame.size.height-70-keyboardFrame.size.height, self.view.frame.size.width, 60);
    self.questionView.frame = CGRectMake(0, -keyboardFrame.size.height, kLQADeviceWidth, kLQADeviceHeight);
    
    
}


- (void)dealloc
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self stopPlayer];
    [_client lqaRelease];
}


- (void)backAction
{
    UIAlertView  *alter = [[UIAlertView alloc]initWithTitle:@"退出将无法继续答题，是否退出？" message:nil delegate:self cancelButtonTitle:@"坚决要走" otherButtonTitles:@"我再想想", nil];
    [alter show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)ruleAction
{
    
    self.alterView.alter = LQAAlterExplain;
    [self.alterView show];
}

- (void)comment
{
    [self.messageView registerFirst];
    self.messageView.hidden = NO;
    self.chatBtn.hidden = YES;
}

- (void)initUI
{
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    bgImageView.image = [UIImage  imageNamed:@"room_bg"];
    [self.view addSubview:bgImageView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UILabel *personLable = [[UILabel alloc]init];
    personLable.text = @"352387人";
    personLable.textColor =[UIColor whiteColor];
    personLable.font = [UIFont systemFontOfSize:15];
    personLable.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:personLable];
    
    UIView *redImg = [[UIView alloc]init];
    redImg.layer.cornerRadius = 3;
    redImg.layer.masksToBounds = YES;
    redImg.backgroundColor = LQAUIColorFromRGB(0xFF2E4E);
    [self.view addSubview:redImg];
    
    @KSYWeakObj(self);
    
    float topHeight = LAQ_StatusBarHeight+5;
    
    if (kLQADevice_Is_iPhoneX) {
        topHeight= topHeight+45;
    }
    
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @KSYStrongObj(self);
        make.top.equalTo(self.view).with.offset(topHeight);
        make.left.equalTo(self.view).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(35, 35));
        
    }];
    
    
    [personLable mas_makeConstraints:^(MASConstraintMaker *make) {
        @KSYStrongObj(self);
        make.right.equalTo(self.view).with.offset(-10);
        make.top.equalTo(self.view).with.offset(topHeight+8);
        make.size.mas_equalTo(CGSizeMake(80, 20));
        
    }];
    
    [redImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(topHeight+15);
        make.left.equalTo(personLable.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(6, 6));
    }];
    
}

- (LQAChatListView *)chatListView
{
    if (!_chatListView) {
        _chatListView =[[LQAChatListView alloc]initWithFrame:CGRectMake(15, kLQADeviceHeight-200-15, kLQADeviceWidth*3/4-15, 200)];
    }
    return _chatListView;
}

- (LQAQuestionView *)questionView
{
    if (!_questionView) {
        _questionView = [[LQAQuestionView alloc]init];
        _questionView.hidden = YES;
    }
    return _questionView;
}

- (LQAAlterView *)alterView
{
    if (!_alterView) {
        _alterView = [[LQAAlterView alloc]init];
        [_alterView dismiss];
    }
    return _alterView;
}

- (UIButton *)chatBtn
{
    if (!_chatBtn) {
        _chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chatBtn setImage:[UIImage imageNamed:@"lqa_chat"] forState:UIControlStateNormal];
        [_chatBtn addTarget:self action:@selector(comment) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chatBtn;
}

- (LQAChatSendMessageView *)messageView
{
    if (!_messageView) {
        _messageView = [[LQAChatSendMessageView  alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-70, self.view.frame.size.width, 60)];
        self.messageView.hidden = YES;
    }
    return _messageView;
}



@end
