//
//  LQAChatSendMessageView.h
//  LQADemo
//
//  Created by yuyang on 2018/1/10.
//  Copyright © 2018年 Ksyun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^sendContentBlock_t)(NSString *string);

@interface LQAChatSendMessageView : UIView
@property (nonatomic,copy)sendContentBlock_t sendContentBlock;

- (void)registerFirst;

- (void)resignFirstResponder;

@end
