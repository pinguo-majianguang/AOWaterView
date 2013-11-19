//
//  MyPhotoView.h
//  AOWaterView
//
//  Created by 0 on 13-11-15.
//  Copyright (c) 2013年 akria.king. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFShareCircleView.h"
#import "CMSCoinView.h"

@interface MyPhotoView : UIView{
    NSDictionary *myPhotoData;
    CFShareCircleView *myPhotoshareCircleView;
    
    //显示控件
    UILabel *myPhotoStatusLabel;
    UILabel *likeLabel;
    UIButton *likedBut;
    UIImageView *photoView;
    UILabel *commentsLabel;
    CMSCoinView *coinView;
}

@property int viewH;

- (id)initWithPhotoData:(NSDictionary *)newData andY:(int *)y;


@end
