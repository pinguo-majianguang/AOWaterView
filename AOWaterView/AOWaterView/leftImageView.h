//
//  leftImageView.h
//  redondo
//
//  Created by chester on 13-11-12.
//  Copyright (c) 2013年 akria.king. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface leftImageView : UIImageView<NSURLConnectionDelegate, NSURLConnectionDataDelegate, NSURLConnectionDownloadDelegate>
{
    NSURLRequest* _request;
    NSMutableData* _buf;
}

//初始化view
-(id)initWithUrl:(NSString *)url positionY:(float)x;
@end
