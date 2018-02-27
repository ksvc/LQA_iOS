//
//  LQAChatListView.h
//  LQADemo
//
//  Created by yuyang on 2018/1/9.
//  Copyright © 2018年 Ksyun. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface LQAChat: NSObject //自定义测试聊天消息格式
@property (nonatomic,copy)NSString *uid;
@property (nonatomic,strong)NSString *message;
@property (nonatomic,strong)NSString *nick_name;
@end

@interface LQAChatListView : UIView

- (void)addData:(id )obj;

@end
