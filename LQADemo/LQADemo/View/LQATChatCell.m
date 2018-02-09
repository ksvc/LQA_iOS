//
//  LQATChatCell.m
//  LQADemo
//
//  Created by yuyang on 2018/1/9.
//  Copyright © 2018年 Ksyun. All rights reserved.
//

#import "LQATChatCell.h"
#import "LQATool.h"
@interface LQATChatCell ()
@property (nonatomic,strong)UILabel *contentLable;
@property (nonatomic,assign)CGFloat height;
@end
@implementation LQATChatCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self)  return nil;
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.contentLable];
    return self;
}
- (void)setName:(NSString*)name content:(NSString *)content
{
    self.height = 0;
    if (name.length ==0) {
        return;
    }
    NSMutableAttributedString *richText  = [LQATChatCell getName:name content:content];
    self.height = [LQATChatCell getSizeName:name content:content width:self.frame.size.width].height;
    self.contentLable.frame =CGRectMake(0, 0, kLQADeviceWidth*3/4-15, self.height) ;
    self.contentLable.attributedText = richText;
}

+ (NSMutableAttributedString *)getName:(NSString*)name content:(NSString *)content
{
    NSString *sName = name;
    NSString *sContent = content;
    
    NSMutableAttributedString *richText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  %@",sName,sContent]];
    [richText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16.0] range:NSMakeRange(0, sName.length)];//设置字体大小
    [richText addAttribute:NSForegroundColorAttributeName value:LQAUIColorFromRGB(0xBBBAFF) range:NSMakeRange(0, sName.length)];//设置字体颜色
    
    [richText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:NSMakeRange(sName.length+2, content.length)];//设置字体大小
    [richText addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(sName.length+2, content.length)];//设置字体颜色
    return richText;
    
}

+ (CGSize)getSizeName:(NSString*)name content:(NSString *)content width:(CGFloat)width
{
    NSMutableAttributedString *richText  = [LQATChatCell getName:name content:content];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
    CGRect labelRect = [richText boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:options context:nil];
    return labelRect.size;
    
}

- (UILabel * )contentLable
{
    if (!_contentLable) {
        _contentLable = [[UILabel alloc]init];
        _contentLable.font = [UIFont systemFontOfSize:16];
        _contentLable.textColor = [UIColor whiteColor];
        _contentLable.text = @"";
        _contentLable.numberOfLines = 0;
        [_contentLable sizeToFit];
        _contentLable.adjustsFontSizeToFitWidth = YES;
        
    }
    return _contentLable;
}

@end
