//
//  AOWaterView.m
//  AOWaterView
//
//  Created by akria.king on 13-4-10.
//  Copyright (c) 2013年 akria.king. All rights reserved.
//

#import "AOWaterView.h"
#define WIDTH 320/3
@implementation AOWaterView

extern UIViewController *thisViewController;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//初始化视图
-(id)initWithDataArray:(NSMutableArray *)array{
    
    self=[super initWithFrame:CGRectMake(0, 0, 320, 504)];
    if (self) {
        [self initProperty];//初始化参数
        //添加scrollView
        [self setContentSize:CGSizeMake(320, 568)];
        [self addSubview:v1];
        //[self addSubview:v2];
        //[self addSubview:v3];
        
    }
    return self;
}
//初始化参数
-(void)initProperty{
    row =1;
    
    //初始化最高视图
    higher =1;
    //初始化最低视图
    lower=1;
    highValue=1;
    
    //获取设备屏幕高度
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat height = size.height;
    
    
    v1 = [[UITableView alloc] initWithFrame:CGRectMake(0, -16, 320, 662) style:UITableViewStylePlain];
    //v2 = [[UITableView alloc] initWithFrame:CGRectMake(320, 0, 320, height) style:UITableViewStylePlain];
    v1.tag = 1;
    //v2.tag = 2;
    
    //v2.backgroundColor = [UIColor blackColor];
    
    v1.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    v1.dataSource = thisViewController;
    v1.delegate = thisViewController;
    
    //v2.dataSource = thisViewController;
    //v2.delegate = thisViewController;
}


//加载数据
-(void)getNextPage:(NSMutableArray *)array
{
    [v1 reloadData];
    //添加scrollView
    //[self setContentSize:CGSizeMake(320, highValue)];
    [self setContentSize:CGSizeMake(320, 632)];
    self.frame = CGRectMake(0, -64, 320, 568);
    v1.frame = CGRectMake(0, -16, 320, 790);
}

-(void)refreshView:(NSMutableArray *)array{
    [v1 removeFromSuperview];
    v1=nil;
    row =1;
    [self initProperty];//初始化参数
    
    //添加scrollView
    [self setContentSize:CGSizeMake(320, 568)];
    self.frame = CGRectMake(0, -64, 320, 568);
    [self addSubview:v1];
    
    //[self addSubview:v2];
    //[self addSubview:v3];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
