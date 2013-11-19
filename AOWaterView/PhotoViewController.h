//
//  PhotoViewController.h
//  AOWaterView
//
//  Created by 0 on 13-11-12.
//  Copyright (c) 2013年 akria.king. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFShareCircleView.h"
#import "CMSCoinView.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define WIDTH 320

@interface PhotoViewController : UIViewController{
    NSDictionary *photoData;
    UITableView *favoriteListView;
    CFShareCircleView *shareCircleView;
    UIScrollView *scrollPanel;
    
    //显示控件
    UILabel *usernameLabel;
    UIImageView *profilePic;
    UILabel *statusLabel;
    UILabel *likeUsersLabel;
    UIButton *likeButton;
    UIButton *likedBut;
    UIImageView *photoView;
    UIButton *shareButton;

}

@property (nonatomic,strong) UIView *cellContentView;

@property (nonatomic, retain) CMSCoinView *coinView;

-(id) initWithPhotoData:(NSDictionary *) newData;
-(void)initTencent;
-(void) getFavoriteUsers;

@end
