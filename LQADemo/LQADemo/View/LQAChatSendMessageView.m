//
//  LQAChatSendMessageView.m
//  LQADemo
//
//  Created by yuyang on 2018/1/10.
//  Copyright © 2018年 Ksyun. All rights reserved.
//

#import "LQAChatSendMessageView.h"
#import "LQATool.h"

@interface LQAChatSendMessageView ()<UITextFieldDelegate>
@property (nonatomic,strong)UITextField *textField;
@end
@implementation LQAChatSendMessageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    [self setup];
    return self;
}

- (void)send
{
    if (self.sendContentBlock) {
        self.sendContentBlock(_textField.text);
    }
    _textField.text =@"";
    
    [_textField resignFirstResponder];
}

- (void)setup
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(12, 10, self.frame.size.width-24, 40)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius =20;
    bgView.layer.masksToBounds = YES;
    [self addSubview:bgView];
    
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(30, 10, self.frame.size.width-120, 40)];
    _textField.placeholder =@"发评论...";
    _textField.textColor = [UIColor blackColor];
    _textField.font = [UIFont systemFontOfSize:14];
    _textField.delegate = self;
    _textField.returnKeyType = UIReturnKeyDone;
    [self  addSubview:_textField];
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame=CGRectMake(bgView.frame.size.width-75, 5, 70, 30);
    sendBtn.backgroundColor = LQAUIColorFromRGB(0xFC316C);
    sendBtn.layer.masksToBounds = YES;
    sendBtn.layer.cornerRadius = 15;
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    [bgView   addSubview:sendBtn];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_textField resignFirstResponder];
    return YES;
}

- (void)resignFirstResponder
{
     [_textField resignFirstResponder];
}

- (void)registerFirst
{
    [_textField becomeFirstResponder];
}

@end
