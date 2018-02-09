//
//  LQAChatListView.m
//  LQADemo
//
//  Created by yuyang on 2018/1/9.
//  Copyright © 2018年 Ksyun. All rights reserved.
//

#import "LQAChatListView.h"
#import "LQATChatCell.h"

@implementation LQAChat

@end

@interface LQAChatListView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tbView;
@property (nonatomic,strong)NSMutableArray *arr;

@end

@implementation LQAChatListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    self.backgroundColor = [UIColor clearColor];
    _arr = [[NSMutableArray alloc]init];
    [self setup];
    return self;
}

- (void)setup
{
    [self addSubview:self.tbView];
}

- (void)addData:(id )obj
{
    if (_arr.count>50) {
        [_arr removeAllObjects];
        [_arr addObject:obj];
        [self.tbView reloadData];
        [self scrollTableToFoot:YES];
    }
    else
    {
        [_arr addObject:obj];
        if (_arr.count>0) {
            NSArray *indexPaths = @[
                                    [NSIndexPath indexPathForRow:_arr.count-1 inSection:0],
                                    ];
            [self.tbView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationRight];
            [self scrollTableToFoot:YES];
        }

    }
  
}

- (void)scrollTableToFoot:(BOOL)animated
{
    NSInteger s = [self.tbView numberOfSections];  //有多少组
    if (s<1) return;  //无数据时不执行 要不会crash
    NSInteger r = [self.tbView numberOfRowsInSection:s-1]; //最后一组有多少行
    if (r<1) return;
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];  //取最后一行数据
    [self.tbView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated]; //滚动到最后一行
}

- (UITableView *)tbView
{
    if (!_tbView) {
        _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
        _tbView.delegate =self;
        _tbView.dataSource =self;
        _tbView.backgroundColor = [UIColor clearColor];
        _tbView.tableFooterView = [UIView new];
        _tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tbView.showsVerticalScrollIndicator = NO;

    }
    return _tbView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LQAChat *chat =[_arr objectAtIndex:indexPath.row];
    return  [LQATChatCell getSizeName:chat.nick_name content:chat.message width:self.frame.size.width].height+10;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = @"CELLID";
    LQATChatCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[LQATChatCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    LQAChat *chat =[_arr objectAtIndex:indexPath.row];
    [cell setName:chat.nick_name content:chat.message];

    
   return cell;
}



@end
