//
//  MyPhotoListView.h
//  AOWaterView
//
//  Created by 0 on 13-11-15.
//  Copyright (c) 2013年 akria.king. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFShareCircleView.h"
#import "MyPhotoView.h"

@interface MyPhotoListView : UIViewController<MyPhotoViewClick>{
    CFShareCircleView *shareCircleView;
    UIScrollView *scrollPanel;
}

-(id) initWithUser:(NSString *)user;

@end
