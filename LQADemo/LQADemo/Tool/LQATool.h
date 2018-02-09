//
//  LQATool.h
//  LQADemo
//
//  Created by yuyang on 2018/1/9.
//  Copyright © 2018年 Ksyun. All rights reserved.
//

#ifndef LQATool_h
#define LQATool_h

#define LQAUIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kLQADeviceWidth [[UIScreen mainScreen] bounds].size.width
#define kLQADeviceHeight [[UIScreen mainScreen] bounds].size.height

#define KSYWeakObj(o) autoreleasepool{} __weak typeof(o) o##Weak = o;

#define KSYStrongObj(o) autoreleasepool{} __strong typeof(o) o = o##Weak;

#import "Masonry.h"


#define kLQADevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define LAQ_StatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height //状态栏高度


typedef NS_ENUM(NSInteger, AlterStatus){
    AlterStatusStart,  //开始
    AlterStatusAnswering,    // 答题中默认
    AlterStatusAnsweringSelected,    // 答题选中
    AlterStatusAnswerRight,  // 答对
    AlterStatusAnswerError,  // 答错
    AlterStatusAnswerNone,//没有答
    AlterStatusAnswerResultMatch,  //观战答案
    AlterStatusAnsweringMatch, //观战答题
    AlterStatusZero //结束
};




#endif /* LQATool_h */
