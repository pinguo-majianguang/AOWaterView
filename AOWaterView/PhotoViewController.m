//
//  PhotoViewController.m
//  AOWaterView
//
//  Created by 0 on 13-11-12.
//  Copyright (c) 2013年 akria.king. All rights reserved.
//

#import "PhotoViewController.h"
#import "DataInfo.h"
#import "AppDelegate.h"
#import "MyPhotoListView.h"
#import "DDProgressView.h"

@implementation PhotoViewController

extern UIViewController *thisViewController;
@synthesize coinView;

-(void) viewDidLoad
{
    shareCircleView = [[CFShareCircleView alloc] initWithFrame:self.view.frame];
    shareCircleView.delegate = self;
    
    [thisViewController.navigationController setNavigationBarHidden:NO animated:YES];
    
    [thisViewController.navigationController.view addSubview:shareCircleView];
    //[self.view addSubview:shareCircleView];
}

-(id)initWithPhotoData:(NSDictionary *)newData{
    NSLog(@"photoView init");
    self = [super init];
    if(self){
        photoData = newData;
    }
    
    //int imgW = self.view.frame.size.width;
    int imgW = WIDTH;
    int imgH = [[photoData objectForKey:@"h"] intValue];
    imgH = (imgH*300)/[[photoData objectForKey:@"w"] intValue];
    // Initialization code
    UIColor *bg = [UIColor colorWithRed:244/255.0f green:248/255.0f blue:249/255.0f alpha:1.0f];
    UIColor *borderColor = [UIColor colorWithRed:225.0f/255.0f green:227.0f/255.0f blue:228.0f/255.0f alpha:1.0f];
    
    
    _cellContentView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, imgW-10, imgH+145)];
    _cellContentView.backgroundColor = bg;
    _cellContentView.layer.borderWidth = 1;
    _cellContentView.layer.borderColor = [borderColor CGColor];
    
    //photoView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 92, imgW-20, imgH)];
    photoView = [[UIImageView alloc] initWithFrame:CGRectMake(5+(imgW-20)/4, 92+(imgH/4), (imgW-20)/2, imgH/2)];
    
    //[photoView setBackgroundColor:[UIColor redColor]];
    

    //用户头像
    
    profilePic = [[UIImageView alloc] initWithFrame:CGRectMake(9, 9, 30, 30)];
    //profilePic.frame = CGRectMake(9, 9, 30, 30);
    //profilePic.tag = 3;
    [self setProPic];
    [profilePic setBackgroundColor:[UIColor grayColor]];
    UIButton *userBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    userBtn.frame = CGRectMake(0, 0, 310, 50);
    userBtn.tag = 1;
    [userBtn addTarget:self action:@selector(butClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //用户昵称
    usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 9, 222, 18)];
    usernameLabel.font = [UIFont systemFontOfSize:14.0];
    usernameLabel.text = [[photoData objectForKey:@"uploadUser"] objectForKey:@"nickname"];
    usernameLabel.backgroundColor = [UIColor clearColor];
    usernameLabel.textColor = [UIColor colorWithRed:206/255 green:141/255 blue:85/255 alpha:1.0];
    
    //上传时间
    UILabel *timestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 25, 222, 17)];
    timestampLabel.font = [UIFont systemFontOfSize:12.0];
    timestampLabel.text = @"3 hours ago";
    timestampLabel.textColor = [UIColor lightGrayColor];
    timestampLabel.backgroundColor = [UIColor clearColor];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, imgW-10, 1)];
    line.backgroundColor = borderColor;
    
    //照片描述
    statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(9, 50, 283, 41)];
    statusLabel.font = [UIFont systemFontOfSize:15.0];
    [self setPhotoDesc];
    statusLabel.numberOfLines = 2;
    statusLabel.lineBreakMode = NSLineBreakByWordWrapping;
    statusLabel.backgroundColor = [UIColor clearColor];
    
    likeUsersLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, imgH+62, imgW-20, 30)];
    likeUsersLabel.font = [UIFont systemFontOfSize:13.0];
    likeUsersLabel.text = @"  暂无喜欢信息";
    likeUsersLabel.textColor = [UIColor whiteColor];
    likeUsersLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    //喜欢
    //这里创建一个圆角矩形的按钮
    likeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //给定button在view上的位置
    //likeButton.frame = CGRectMake(9, imgH+108, 22, 20.5);
    //设置按钮样式
    [likeButton setBackgroundImage:[UIImage imageNamed:@"favorate.jpg"] forState:UIControlStateNormal];
    likeButton.tag = 1;
    //[likeButton addTarget:self action:@selector(butClick:) forControlEvents:UIControlEventTouchUpInside];
    
    likedBut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //likedBut.frame = CGRectMake(9, imgH+108, 22, 20.5);
    //设置按钮样式
    [likedBut setBackgroundImage:[UIImage imageNamed:@"unFavorate.jpg"] forState:UIControlStateNormal];

    self.coinView = [[CMSCoinView alloc] init];
    self.coinView.frame = CGRectMake(9, imgH+110, 26.4, 24.6);
    [self.coinView setPrimaryView: likeButton];
    [self.coinView  setSecondaryView: likedBut];
    [self.coinView  setSpinTime:0.3];
    
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, imgH+103, imgW-10, 1)];
    line2.backgroundColor = borderColor;
    
    //这里创建一个圆角矩形的按钮
    shareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //给定button在view上的位置
    shareButton.frame = CGRectMake(255, imgH+103, 50, 40);
    UIImageView *shareImg = [[UIImageView alloc] initWithFrame:CGRectMake(270, imgH+113, 19, 20.5)];
    [shareImg setImage:[UIImage imageNamed:@"photo_share.png"]];
    shareButton.tag = 2;
    [shareButton addTarget:self action:@selector(butClick:) forControlEvents:UIControlEventTouchUpInside];
    [_cellContentView addSubview:shareImg];
    
    [_cellContentView addSubview:photoView];//把照片添加到最外层View,加到cellContentView里面就相当于相对于cellContentView布局
    [_cellContentView addSubview:likeUsersLabel];
    //显示控件
    [_cellContentView addSubview:shareButton];
    [_cellContentView addSubview:line];
    [_cellContentView addSubview:line2];
    //显示控件
    [_cellContentView addSubview:self.coinView];
    [_cellContentView  addSubview:profilePic];
    [_cellContentView addSubview:userBtn];
    [_cellContentView  addSubview:usernameLabel];
    [_cellContentView  addSubview:timestampLabel];
    [_cellContentView  addSubview:statusLabel];
    [self setPhotoImage:imgH];
    
    if (imgH+150<self.view.frame.size.height) {
        imgH = self.view.frame.size.height;
    }else{
        imgH = imgH+150;
    }
    
    scrollPanel = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,imgW, self.view.frame.size.height)];
    
    scrollPanel.backgroundColor = [UIColor colorWithRed:234.0f/255.0f green:234.0f/255.0f blue:234.0f/255.0f alpha:1.0f];
    
    [scrollPanel setContentSize:CGSizeMake(imgW, imgH)];
    
    [scrollPanel addSubview:_cellContentView];
    
    [self.view addSubview: scrollPanel];
    
    [self getFavoriteUsers];
    
    return self;
}

- (void)shareCircleView:(CFShareCircleView *)aShareCircleView didSelectSharer:(CFSharer *)sharer {
    NSLog(@"Selected sharer: %@", sharer.name);
}

- (void)shareCircleCanceled: (NSNotification*)notification{
    NSLog(@"Share circle view was canceled.");
}


-(void)setPhotoImage:(int) imgH{
    
    DDProgressView *progressView = [[DDProgressView alloc] initWithFrame: CGRectMake(20.0f, imgH/2, self.view.bounds.size.width-40.0f, 0.0f)] ;
	[progressView setOuterColor: [UIColor grayColor]] ;
	[progressView setInnerColor: [UIColor lightGrayColor]] ;
	[_cellContentView addSubview: progressView] ;
    

    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"http://cloud-activity.qiniudn.com/%@",(NSString *)[photoData objectForKey:@"key"]] stringByAppendingString:[NSString stringWithFormat:@"?imageView/2/w/300/h/%d",([[photoData objectForKey:@"h"] intValue]*300)/[[photoData objectForKey:@"w"] intValue]]]];
    
    /*[photoView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        NSLog(@"photo load completed");
        [progressView removeFromSuperview];
        
        [self imageViewAnimation:image];
    }];*/
    
    [photoView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"] options:0 progress:^(NSUInteger receivedSize, long long expectedSize) {
        [progressView setProgress:receivedSize/expectedSize];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        NSLog(@"photo load completed");
        [progressView removeFromSuperview];
        
        [self imageViewAnimation:image];
    }];
}

-(void)setProPic{
    NSURL *proUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://dn-c360.qbox.me/%@", [[photoData objectForKey:@"uploadUser"] objectForKey:@"face"]]];
    
    //UIImageView *proPic = [[UIImageView alloc] init];
    
    [profilePic setImageWithURL:proUrl completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        NSLog(@"proPic load Completed");
        //[profilePic setBackgroundImage:image forState:UIControlStateNormal];
    }];
}
-(void)setUserName{
    usernameLabel.text = [[photoData objectForKey:@"uploadUser"] objectForKey:@"nickname"];
}
-(void)setPhotoDesc{
    if([photoData objectForKey:@"desc"] == nil){
        statusLabel.text = [photoData objectForKey:@"desc"];
    }else{
        statusLabel.text = @"暂无照片描述";
    }
}

-(void) getFavoriteUsers{
    NSString *urlStr = [NSString stringWithFormat:@"https://cloud.camera360.com/activity/picture/favoriteUsers?pid=%@&activityId=52569bb88852d69963256a7f",[photoData objectForKey:@"id"]];
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
                                   if(len>0){
                                       if(len>2){
                                           len = 2;
                                       }
                                       NSString *userStr = @"  ";
                                       for (int i = 0;i<len;i++) {
                                           userStr = [userStr stringByAppendingString:[NSString stringWithFormat:@"%@,",[usersList objectAtIndex:i]]];
                                       }
                                       userStr = [userStr substringToIndex:userStr.length-1];
                                       
                                       userStr = [userStr stringByAppendingString:[NSString stringWithFormat:@"   等%@人喜欢",[[dict objectForKey:@"data"] objectForKey:@"favoriteCount"]]];
                                       
                                       dispatch_queue_t queue = dispatch_get_main_queue();
                                       dispatch_async(queue, ^{
                                           likeUsersLabel.text = userStr;
                                           NSLog(@"like Users is %@",userStr);
                                       });
                                    }
                               }
                           }];
    
}


- (void)sendRequestSync
{
    
    NSString *str = [NSString stringWithFormat:@"https://cloud.camera360.com/activity/picture/favoriteUsers?pid=%@&activityId=52569bb88852d69963256a7f",[photoData objectForKey:@"id"]];
    NSURL *url = [NSURL URLWithString:str];
    NSString *post=@"postData";
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    [request setTimeoutInterval:10.0];
    
    // 发送同步请求, data就是返回的数据
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (data == nil) {
        NSLog(@"send request failed: %@", error);
        return;
    }
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    NSMutableArray *usersList = [[dict objectForKey:@"data"] objectForKey:@"favoriteUsers"];
    int len = [usersList count];
    if(len>0){
        if(len>2){
            len = 2;
        }
        NSString *userStr = @"  ";
        for (int i = 0;i<len;i++) {
            userStr = [userStr stringByAppendingString:[NSString stringWithFormat:@"%@,",[usersList objectAtIndex:i]]];
        }
        userStr = [userStr substringToIndex:userStr.length-1];
        
        userStr = [userStr stringByAppendingString:[NSString stringWithFormat:@"   等%@人喜欢",[[dict objectForKey:@"data"] objectForKey:@"favoriteCount"]]];

        likeUsersLabel.text = userStr;
    }
    
}

- (IBAction)butClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    // 2、通过tag进行选择对应的操作
    if (button.tag == 1) {
        MyPhotoListView *myList = [[MyPhotoListView alloc] initWithUser:[[photoData objectForKey:@"uploadUser"] objectForKey:@"nickname"]];
        [thisViewController.navigationController pushViewController:myList animated:YES];

    } else if(button.tag ==2) {
        [shareCircleView show];
    }else{
        MyPhotoListView *myList = [[MyPhotoListView alloc] init];
        [thisViewController.navigationController pushViewController:myList animated:YES];
    }
}

- (void)imageViewAnimation:(UIImage *)image
{

 
    UIImageView *imageView = photoView;
    
    CGRect frame = [imageView frame];

    frame.size.width = image.size.width;//imageFirScreen.size.width is 310.000000
    frame.size.height = image.size.height;//imageFirScreen.size.height is 568.000000
    frame.origin.x = 5;
    frame.origin.y = 92;
    
    [UIView beginAnimations:nil context:nil];       //动画开始
    //[UIView setAnimationDuration:0.5];
    [UIView animateWithDuration:1
                          delay:0.0
                        options:UIViewAnimationCurveLinear //设置动画类型
                     animations:^{
                         //开始动画
                         
                     }
                     completion:^(BOOL finished){
                         // 动画结束时的处理
                     }];

    
    [imageView setImage:image];
    [imageView setFrame:frame];
    
    [UIView commitAnimations];

}


@end
