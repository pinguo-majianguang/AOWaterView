//
//  MyPhotoView.m
//  AOWaterView
//
//  Created by 0 on 13-11-15.
//  Copyright (c) 2013年 akria.king. All rights reserved.
//

#import "MyPhotoView.h"
#import "PhotoViewController.h"
#import "MyPhotoListView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation MyPhotoView

@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithPhotoData:(NSDictionary *)newData andY:(int)y andDelegate:(MyPhotoListView *) photoList{
    self = [super init];
    if(self){
        myPhotoData = newData;
    }
    self.delegate = photoList;
    NSLog(@"myPhotoView init");
    int imgW = 320;
    int imgH = [[myPhotoData objectForKey:@"h"] intValue];
    imgH = (imgH*310)/[[myPhotoData objectForKey:@"w"] intValue];
    // Initialization code
    UIColor *bg = [UIColor colorWithRed:244/255.0f green:248/255.0f blue:249/255.0f alpha:1.0f];
    UIColor *borderColor = [UIColor colorWithRed:225.0f/255.0f green:227.0f/255.0f blue:228.0f/255.0f alpha:1.0f];
    
    UIButton *photoBtn = [[UIButton alloc] init];
    photoBtn.frame = CGRectMake(5, 5, imgW-20, imgH);
    photoBtn.tag = 1;
    [photoBtn addTarget:self action:@selector(butClick:) forControlEvents:UIControlEventTouchUpInside];
    photoView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, imgW-20, imgH)];
    [self getPhotoImage];
    
    //照片描述
    myPhotoStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, imgH-25, imgW-20, 30)];
    if([myPhotoData objectForKey:@"desc"] == nil){
        myPhotoStatusLabel.text = [myPhotoData objectForKey:@"desc"];
    }else{
        myPhotoStatusLabel.text = @"暂无照片描述";
    }
    myPhotoStatusLabel.font = [UIFont systemFontOfSize:13.0];
    myPhotoStatusLabel.textColor = [UIColor whiteColor];
    myPhotoStatusLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    //喜欢
    //这里创建一个圆角矩形的按钮
    likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(9, imgH+20, 100, 20.5)];
    likeLabel.font = [UIFont systemFontOfSize:11.0];
    [self getLikeInfo];
    
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, imgH+10, imgW-10, 1)];
    line2.backgroundColor = borderColor;
    
    //这里创建一个圆角矩形的按钮
    commentsLabel = [[UILabel alloc] initWithFrame:CGRectMake(260, imgH+20, 60, 20.5)];
    commentsLabel.font = [UIFont systemFontOfSize:11.0];
    commentsLabel.text = @"5人评论";
    
    self.frame = CGRectMake(5, y+5, imgW-10, imgH+50);
    
    //self.viewH = imgH+55;
    
    self.backgroundColor = bg;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [borderColor CGColor];
    
    [self addSubview:photoView];//把照片添加到最外层View,加到cellContentView里面就相当于相对于cellContentView布局
    [self addSubview:photoBtn];
    //显示控件
    [self addSubview:commentsLabel];
    [self addSubview:likeLabel];
    [self addSubview:line2];
    [self addSubview:myPhotoStatusLabel];
    
    //[self getFavoriteUsers];
    
    return self;
}

-(void)getPhotoImage{
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"http://cloud-activity.qiniudn.com/%@",(NSString *)[myPhotoData objectForKey:@"key"]] stringByAppendingString:@"?imageView/2/w/320"]];
    
    [photoView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        NSLog(@"photo load completed");
    }];
}

-(void)getLikeInfo{
    NSString *urlStr = [NSString stringWithFormat:@"https://cloud.camera360.com/activity/picture/favoriteUsers?pid=%@&activityId=52569bb88852d69963256a7f",[myPhotoData objectForKey:@"id"]];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSString *post=@"postData";
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    [request setTimeoutInterval:10.0];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   NSLog(@"Httperror:%@%d", error.localizedDescription,error.code);
                               }else{
                                   
                                   NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                   
                                   NSMutableArray *usersList = [[dict objectForKey:@"data"] objectForKey:@"favoriteUsers"];
                                   int len = [usersList count];
                                   
                                   NSString *userStr = @"";
                                   userStr = [userStr stringByAppendingString:[NSString stringWithFormat:@"%@人喜欢",[[dict objectForKey:@"data"] objectForKey:@"favoriteCount"]]];
                                   if(len==0){
                                       userStr = @"暂无人喜欢";
                                   }
                                   dispatch_queue_t queue = dispatch_get_main_queue();
                                   dispatch_async(queue, ^{
                                       likeLabel.text = userStr;
                                   });
                               }
                           }];

}

- (IBAction)butClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    // 2、通过tag进行选择对应的操作
    if (button.tag == 1) {
        
        [delegate myPhotoClick:myPhotoData];
    } else if(button.tag ==2) {
        //[shareCircleView show];
    }else{
        /*AppDelegate *app = [[UIApplication sharedApplication] delegate];
         PYTimelineViewController *pyView = [PYTimelineViewController alloc];
         [app.mainView.navigationController.view addSubview:pyView.view];*/
        /*if(!self.viewController){
         self.viewController = [[PYTimelineViewController alloc] initWithNibName:@"PYTimelineViewController" bundle:nil];
         }
         [thisViewController.navigationController pushViewController:self.viewController animated:YES];*/
    }
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
