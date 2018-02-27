//
//  LQATChatCell.h
//  LQADemo
//
//  Created by yuyang on 2018/1/9.
//  Copyright © 2018年 Ksyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LQATChatCell : UITableViewCell

- (void)setName:(NSString*)name content:(NSString *)content;

+ (CGSize)getSizeName:(NSString*)name content:(NSString *)content width:(CGFloat)width;

@end
