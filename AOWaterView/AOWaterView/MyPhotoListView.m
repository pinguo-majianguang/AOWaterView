//
//  MyPhotoListView.m
//  AOWaterView
//
//  Created by 0 on 13-11-15.
//  Copyright (c) 2013年 akria.king. All rights reserved.
//

#import "MyPhotoListView.h"
#import "MyPhotoView.h"
#import "PhotoViewController.h"

@implementation MyPhotoListView

extern UIViewController *thisViewController;

-(void) viewDidLoad
{
    //shareCircleView = [[CFShareCircleView alloc] initWithFrame:self.view.frame];
    //shareCircleView.delegate = self;
    
    //[thisViewController.navigationController setNavigationBarHidden:NO animated:YES];
    
    //[thisViewController.navigationController.view addSubview:shareCircleView];
    
    scrollPanel = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    //scrollPanel.backgroundColor = [UIColor colorWithRed:234.0f/255.0f green:234.0f/255.0f blue:234.0f/255.0f alpha:1.0f];
    
    [self.view addSubview: scrollPanel];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"view_bg.jpg"]];
    
    [self getFavoriteUsers];
}

-(id) initWithUser:(NSString *)user{
    self = [super init];
    
    [self setTitle:user];
    
    return self;
}

-(void) getFavoriteUsers{
    SpotifyProgressHUD *progressView = [[SpotifyProgressHUD alloc] initWithFrame:CGRectMake(0, 0, 150, 150)
                                                               withPointDiameter:16
                                                                    withInterval:0.25];
    progressView.center = self.view.center;
    [self.view addSubview:progressView];
    NSString *urlStr = [NSString stringWithFormat:@"https://cloud.camera360.com/activity/picture/hot?activityId=52569bb88852d69963256a7f&limit=7"];
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
                                   
                                   NSMutableArray *list = [[dict objectForKey:@"data"] objectForKey:@"list"];
                                   
                                   dispatch_queue_t queue = dispatch_get_main_queue();
                                   dispatch_async(queue, ^{
                                       int scrollH = 0;
                                       int len = list.count;
                                       for(int i=0;i<len;i++){
                                           MyPhotoView *myPhoto = [[MyPhotoView alloc] initWithPhotoData:[list objectAtIndex:i] andY:scrollH andDelegate:self];
                                           [scrollPanel addSubview:myPhoto];
                                           scrollH = scrollH + myPhoto.frame.size.height+5;
                                       }
                                       [scrollPanel setContentSize:CGSizeMake(320, scrollH)];
                                       [progressView removeFromSuperview];
                                   });
                                   
                                   
                               }
                           }];
    
}

-(void)myPhotoClick:(NSDictionary *)data{
    PhotoViewController *pv = [[PhotoViewController alloc] initWithPhotoData:data];
    [thisViewController.navigationController pushViewController:pv animated:YES];
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
