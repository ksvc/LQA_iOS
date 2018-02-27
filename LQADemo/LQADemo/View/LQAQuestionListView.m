//
//  LQAQuestionListView.m
//  LQADemo
//
//  Created by yuyang on 2018/1/10.
//  Copyright © 2018年 Ksyun. All rights reserved.
//

#import "LQAQuestionListView.h"


#define  kColor_Answering  0xEDF0F4
#define  kColor_AnswerRight  0x42CBF2
#define  kColor_AnswerError  0xFFB4CA
#define  kColor_AnswerNone   0xEDF0F4


@interface LQAQuestionHeadView ()
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *alterLable;


@end
@implementation LQAQuestionHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    [self setup];
    return self;
}

- (void)showAlterView:(NSString *)alterString
{
    _alterLable.hidden = NO;
    _alterLable.text = alterString;
}

- (void)hideAlterView
{
    _alterLable.hidden = YES;
}


- (void)setTitle:(NSString *)title
{
    _titleLabel.text = title;
    CGSize titleSize = [LQAQuestionHeadView getSizeFromString:title];
    _titleLabel.frame =CGRectMake(15, 0, titleSize.width,titleSize.height);
    
    CGSize size = [LQAQuestionHeadView getSizeFromString:title];
    
    if (size.height<100)
    {
        _alterLable.frame = CGRectMake(15, 100-20, kLQADeviceWidth-88, 20);
    }
    else
    {
        _alterLable.frame = CGRectMake(15, size.height+10, kLQADeviceWidth-88, 20);
    }
    
}


- (void)setup
{
    _titleLabel = [UILabel new];
    _titleLabel.numberOfLines = 0;//多行显示，计算高度
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self  addSubview:_titleLabel];
    
    _alterLable = [UILabel new];
    _alterLable.font = [UIFont systemFontOfSize:16];
    _alterLable.textColor =LQAUIColorFromRGB(0xFC316C);
    _alterLable.hidden = YES;
    _alterLable.textAlignment = NSTextAlignmentCenter;
    [self  addSubview:_alterLable];
}

+ (CGSize)getSizeFromString:(NSString *)string
{
     CGSize titleSize = [string boundingRectWithSize:CGSizeMake(kLQADeviceWidth-88, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20]} context:nil].size;
    return titleSize;
    
}


@end

@interface LQAQuestionListCell ()
@property (nonatomic,strong)UIView *answerDoneBgView;
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UILabel *questionLable;
@property (nonatomic,strong)UILabel *personLable;
@property (nonatomic,assign)NSInteger currentNum;

@property (nonatomic,strong) LQAOptionsEntity *optionsEntity;

@property (nonatomic,assign) float  height;;



@end
@implementation LQAQuestionListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setup];
    return self;
}



- (void)setAlterStatus:(AlterStatus)alterStatus
{
    _alterStatus =alterStatus;
    [self handFrame];
    
}

- (void)handFrame
{
    switch (_alterStatus) {
        case AlterStatusAnswering:
        {
            self.questionLable.textColor = [UIColor blackColor];
            self.bgView.backgroundColor =LQAUIColorFromRGB(kColor_Answering);
            self.answerDoneBgView.hidden = YES;
            self.personLable.hidden  = YES;
            self.bgView.hidden  = NO;
            self.bgView.frame =CGRectMake(1, 10, (kLQADeviceWidth-72-2), _height);
            
            
        }
            break;
        case AlterStatusAnsweringSelected:
        {
            self.questionLable.textColor = [UIColor blackColor];
            self.bgView.backgroundColor =LQAUIColorFromRGB(kColor_AnswerRight);
            self.answerDoneBgView.hidden = YES;
            self.personLable.hidden  = YES;
            self.bgView.hidden  = NO;
            self.bgView.frame =CGRectMake(1, 10, (kLQADeviceWidth-72-2), _height);
            
        }
            break;
        case AlterStatusAnswerRight:
        {
            self.questionLable.textColor = [UIColor blackColor];
            self.bgView.backgroundColor =LQAUIColorFromRGB(kColor_AnswerRight);
            self.answerDoneBgView.hidden = NO;
            self.personLable.hidden  = NO;
            self.bgView.frame =CGRectMake(1, 10, (kLQADeviceWidth-72-2)*[self getPersonRatio], _height);
            
        }
            break;
        case AlterStatusAnswerError:
        {
            self.questionLable.textColor = [UIColor blackColor];
            self.bgView.backgroundColor =LQAUIColorFromRGB(kColor_AnswerError);
            self.answerDoneBgView.hidden = NO;
            self.personLable.hidden  = NO;
            self.bgView.frame =CGRectMake(1, 10, (kLQADeviceWidth-72-2)*[self getPersonRatio], _height);
            //
        }
            break;
        case AlterStatusAnswerNone:
        {
            self.questionLable.textColor = [UIColor blackColor];
            self.bgView.backgroundColor =LQAUIColorFromRGB(kColor_AnswerNone);
            self.answerDoneBgView.hidden = NO;
            self.personLable.hidden  = NO;
            self.bgView.frame =CGRectMake(1, 10, (kLQADeviceWidth-72-2)*[self getPersonRatio], _height);
            
        }
            break;
            
        default:
            break;
    }
    self.answerDoneBgView.frame =CGRectMake(0, 9, self.frame.size.width, _height+2);
    self.bgView.layer.cornerRadius = _height/2;
    self.bgView.layer.masksToBounds= YES;
    self.answerDoneBgView.layer.cornerRadius = (_height+2)/2;
    self.answerDoneBgView.layer.masksToBounds= YES;
    self.personLable.frame = CGRectMake(self.frame.size.width-100-20, 10, 100, _height);
}

- (void)layoutSubviews
{
    [self handFrame];
}




- (CGFloat)getPersonRatio
{
    if (_totlePerson==0) {
        return 0;
    }
    return  (CGFloat)_currentNum/_totlePerson;
}


- (void)resetOptionModel:(LQAOptionsEntity*)optionsEntity
{
    _optionsEntity = optionsEntity;
    NSString *string =[NSString  stringWithFormat:@"%@.  %@",optionsEntity.option,optionsEntity.text];
    self.questionLable.text  = string;
   
    CGSize size =[LQAQuestionListCell getSizeFromString:string];
    CGFloat height  = 50;
    if (size.height>50) {
        height = size.height;
    }
    _height = height;
    self.questionLable.frame = CGRectMake(23, 10, kLQADeviceWidth-120, height);
   
}

+ (CGSize)getSizeFromString:(NSString *)string
{
    CGSize titleSize = [string boundingRectWithSize:CGSizeMake(kLQADeviceWidth-120, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
    return titleSize;
    
}

- (void)resetGroupModel:(LQAGroupEntity*)optionsEntity
{
    _currentNum = [optionsEntity.count integerValue];
    self.personLable.text  =@"0";
    if (_currentNum!=0) {
       self.personLable.text = optionsEntity.count;
    }
}

- (void)setup
{
    [self addSubview:self.answerDoneBgView];
    [self addSubview:self.bgView];
    [self addSubview:self.questionLable];
    [self addSubview:self.personLable];
    
}


- (UIView *)bgView
{

    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.frame.size.width, 50)];

    }
    return _bgView;
}

- (UIView *)answerDoneBgView
{
    if (!_answerDoneBgView) {
        _answerDoneBgView = [[UIView alloc]init];
        _answerDoneBgView.layer.cornerRadius = 26;
        _answerDoneBgView.layer.masksToBounds= YES;
        _answerDoneBgView.backgroundColor = [UIColor whiteColor];
        _answerDoneBgView.layer.borderWidth =  1;
        _answerDoneBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
    }
    return _answerDoneBgView;
}

- (UILabel *)questionLable
{
    if (!_questionLable) {
        _questionLable = [[UILabel alloc]init];
        _questionLable.text =  @"A.《黄飞鸿》";
        _questionLable.textColor = LQAUIColorFromRGB(kColor_Answering);
        _questionLable.font = [UIFont systemFontOfSize:16];
        _questionLable.numberOfLines =0;
    }
    return _questionLable;
}

- (UILabel *)personLable
{
    if (!_personLable) {
        _personLable = [[UILabel alloc]init];
        _personLable.text =  @"7871";
        _personLable.textColor = LQAUIColorFromRGB(0x333333);
        _personLable.font = [UIFont systemFontOfSize:16];
        _personLable.textAlignment = NSTextAlignmentRight;
    }
    return _personLable;
}

@end

@interface LQAQuestionListView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tbView;
@property (nonatomic,strong)NSMutableArray *arr;
@property (nonatomic,strong)NSMutableArray *resultArray;
@property (nonatomic,strong)LQAQuestionHeadView *headView;

@property (nonatomic,copy) NSString  *errorString;


@end
@implementation LQAQuestionListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    [self setup];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (!self)  return nil;
    [self setup];
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (!self)  return nil;
    [self setup];
    return self;
}


- (void)setup
{
    _arr = [[NSMutableArray alloc]init];
    _resultArray = [[NSMutableArray alloc]init];
    [self addSubview:self.tbView];
  
}

- (void)reloadArray:(NSArray *)array
{
    [_arr removeAllObjects];
    [_arr addObjectsFromArray:array];
    [_resultArray removeAllObjects];
    [_resultArray addObjectsFromArray:[_entity  getResultEntity]];
    __block int  optionHeight  = 0;
    [array enumerateObjectsUsingBlock:^(LQAOptionsEntity* optionsEntity, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *string =[NSString  stringWithFormat:@"%@.  %@",optionsEntity.option,optionsEntity.text];
        CGSize size =[LQAQuestionListCell getSizeFromString:string];
        CGFloat height  = 50;
        if (size.height>50) {
            height = size.height;
        }
        optionHeight =optionHeight +height+10;
    }];
    float height =170;
    CGSize size = [LQAQuestionHeadView getSizeFromString:_entity.title];
    if (size.height>100)
    {
        height = 120+size.height;
    }
    self.tbView.frame =CGRectMake(0, 0, self.frame.size.width, height+optionHeight+20);
    [self setHeadTitle: [NSString stringWithFormat:@"%@.%@",_entity.order,_entity.title]];
    [self.tbView reloadData];
}

- (void)setHeadTitle:(NSString *)title
{
    [self.headView  setTitle:title];
    CGSize size = [LQAQuestionHeadView getSizeFromString:title];
    if (size.height<100) {
        self.headView.frame = CGRectMake(0, 0, size.width, 100);
        self.tbView.tableHeaderView = self.headView;
        self.tbView.frame =CGRectMake(0, 0, self.frame.size.width, 120+_arr.count*60+size.height);
    }
    else
    {
        self.headView.frame = CGRectMake(0, 0, size.width, size.height+30);
        self.tbView.tableHeaderView = self.headView;
        self.tbView.frame =CGRectMake(0, 0, self.frame.size.width, size.height+20+_arr.count*60+size.height);
    }
    [self.headView hideAlterView];
}

- (void)setAlterStatus:(AlterStatus)alterStatus
{
    _alterStatus =alterStatus;
    [self.tbView reloadData];
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
        _tbView.scrollEnabled  =NO;
       
    }
    return _tbView;
}

- (LQAQuestionHeadView *)headView
{
    if (!_headView) {
        _headView = [[LQAQuestionHeadView alloc]init];
    }
    return _headView;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LQAOptionsEntity *optionsEntity= [_arr objectAtIndex:indexPath.row];
    
    NSString *string =[NSString  stringWithFormat:@"%@.  %@",optionsEntity.option,optionsEntity.text];
    
    CGSize size =[LQAQuestionListCell getSizeFromString:string];
    CGFloat height  = 50;
    if (size.height>50) {
        height = size.height;
    }
    return height+8;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = @"CELLID";
    LQAQuestionListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[LQAQuestionListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    LQAOptionsEntity *optionsEntity= [_arr objectAtIndex:indexPath.row];
    if (_alterStatus==AlterStatusAnswering||_alterStatus==AlterStatusAnsweringMatch)//做题
    {
        [cell resetOptionModel:optionsEntity];
        cell.alterStatus= AlterStatusAnswering;
    }
    else
    {
        cell.totlePerson  = self.entity.totlePerson;
        [cell resetOptionModel:optionsEntity];
        
        if (indexPath.row<_resultArray.count) {
            [cell resetGroupModel:[_resultArray objectAtIndex:indexPath.row]];
        }
        else
        {
            //如果group  we空清除视图
            LQAGroupEntity *groupEntity = [[LQAGroupEntity alloc]init];
            groupEntity.count= 0;
            groupEntity.option = optionsEntity.option;
            [cell resetGroupModel:groupEntity];
        }
       
        if (_entity.userStatusAnswer == LQAUserStatusAnswerRightDone||_entity.userStatusAnswer == LQAUserStatusAnswerMatch) {
            if ([_entity.correctOption isEqualToString:optionsEntity.option]) {
                cell.alterStatus =AlterStatusAnswerRight;
            }
            else
            {
                cell.alterStatus = AlterStatusAnswerNone;
            }
        }
        else if(_entity.userStatusAnswer == LQAUserStatusAnswerWrongDone)
        {
            if ([_entity.correctOption isEqualToString:optionsEntity.option]) {
                cell.alterStatus =AlterStatusAnswerRight;
            }
            else  if ([_entity.errorOption isEqualToString:optionsEntity.option])
            {
                cell.alterStatus = AlterStatusAnswerError;
            }
            else
            {
                cell.alterStatus = AlterStatusAnswerNone;
            }
        }
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isAnwserSelected) {
        
        return;
    }
    if (_alterStatus ==AlterStatusAnswering) {
        
        LQAOptionsEntity *entity= [_arr objectAtIndex:indexPath.row];
        _isAnwserSelected = YES;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSArray *arr = [tableView indexPathsForVisibleRows];
        
        for (NSIndexPath *indexPath in arr) {
            LQAQuestionListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.alterStatus = AlterStatusAnswering;
        }
        
        LQAQuestionListCell *cell = (LQAQuestionListCell*)[tableView cellForRowAtIndexPath:indexPath];
        cell.alterStatus = AlterStatusAnsweringSelected;

        [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectedQuestion" object:@{@"answer":entity.option}];
        
        
    }
    else if (_alterStatus ==AlterStatusAnsweringMatch)
    {
       [self.headView showAlterView:_errorString];
    }

}

- (void)setErrorString:(NSString *)errorString
{
    _errorString = errorString;
}


@end
