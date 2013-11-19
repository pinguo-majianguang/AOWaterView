//
//  MessView.m
//  AOWaterView
//
//  Created by akria.king on 13-4-10.
//  Copyright (c) 2013年 akria.king. All rights reserved.
//

#import "MessView.h"
#import "MainViewController.h"

#define WIDTH 320/3
@implementation MessView
{
   
    UIView * bigImageView;
}

extern NSMutableArray *totalArr;
extern int currentTag;
UIViewController *thisViewController;

@synthesize idelegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithData:(DataInfo *)data yPoint:(float) y{
    float imgW=data.width;//图片原宽度
    float imgH=data.height;//图片原高度
    float sImgW = WIDTH-4;//缩略图宽带
    float sImgH = sImgW*imgH/imgW;//缩略图高度
    self = [super initWithFrame:CGRectMake(0, y, WIDTH, sImgH+4)];
    if (self) {
        //imageBtn = [[UrlImageButton alloc]initWithFrame:CGRectMake(2,2, sImgW, sImgH)];//初始化url图片按钮控件
        //[imageBtn setImageFromUrl:YES withUrl:data.url];//设置图片地质
        //imageBtn.tag = data.tag;
    

        //[imageBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        //[self addSubview:imageBtn];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(2, self.frame.size.height-22, WIDTH-4, 20)];
        label.backgroundColor = [UIColor blackColor];
        label.alpha=0.8;
        label.text=data.title;
        label.textColor =[UIColor whiteColor];
        
        [self addSubview:label];
       
    }
    return self;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)click:(id)sender
{
    [self.idelegate click:self.dataInfo];
    
    //[self.window.rootViewController.navigationController setNavigationBarHidden:YES animated:YES];
    //[_homeView.navigationController setNa];
    
    //NSLog(@"%@",[[sender subviews] objectAtIndex:0]);
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    //NSLog(@"%@",[[[sender subviews] objectAtIndex:0] image]);
    
    imgView.image =[[[sender subviews] objectAtIndex:0] image];
    
    //currentTag = imageBtn.tag;
    
    
    //NSLog(@"%@",[[[[[[[self.window subviews] objectAtIndex:0] subviews] objectAtIndex:0] subviews] objectAtIndex:0] subviews]);
    
    
    //imgView.alpha = 0;
    [thisViewController.navigationController setNavigationBarHidden:YES animated:YES];
    
    bigImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    bigImageView.alpha = 0;
    [bigImageView addSubview:imgView];
    [[[[[[[[[self.window subviews] objectAtIndex:0] subviews] objectAtIndex:0] subviews] objectAtIndex:0] subviews] objectAtIndex:0] addSubview:bigImageView];
    
    [UIView beginAnimations:@"Fade in" context:nil];
    [UIView setAnimationDuration:1];
    bigImageView.alpha = 1;
    [UIView commitAnimations];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapAction:)];
    [bigImageView addGestureRecognizer:singleTap];
    
    bigImageView.userInteractionEnabled = YES;
    
    
    //[self.window.rootViewController pare];
    

    
    //[self.window addSubview:[[sender subviews] objectAtIndex:0]];
}

-(void)singleTapAction:(id)sender
{
    //NSLog(@"%@",[[[[[[[[[[self.window subviews] objectAtIndex:0] subviews] objectAtIndex:0] subviews] objectAtIndex:0] subviews] objectAtIndex:0] subviews] objectAtIndex:2]);
    //UIView * removeView = [[[[[[[[[[self.window subviews] objectAtIndex:0] subviews] objectAtIndex:0] subviews] objectAtIndex:0] subviews] objectAtIndex:0] subviews] objectAtIndex:2];
    
    [UIView beginAnimations:@"Fade out" context:nil];
    [UIView setAnimationDuration:1];
    bigImageView.alpha = 0;
    [UIView commitAnimations];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(disappear) userInfo:nil repeats:NO];
}

-(void)disappear
{
    //NSLog(@"dfdfd");
    //[[[[[[[[[[[self.window subviews] objectAtIndex:0] subviews] objectAtIndex:0] subviews] objectAtIndex:0] subviews] objectAtIndex:0] subviews] objectAtIndex:2] removeFromSuperview];
    //[[imageBtn superview] removeFromSuperview];
    [bigImageView removeFromSuperview];
    [thisViewController.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
