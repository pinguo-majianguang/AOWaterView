//
//  leftImageView.m
//  redondo
//
//  Created by chester on 13-11-12.
//  Copyright (c) 2013年 akria.king. All rights reserved.
//

#import "leftImageView.h"

@implementation leftImageView
{
    NSURLConnection* _connection;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithUrl:(NSString *)url positionY:(float)x
{
    self = [super initWithFrame:CGRectMake(x, 2, 78, 78)];
    //[self setFrame:CGRectMake(x, 2, 78, 78)];
    
    _buf = [[NSMutableData alloc] initWithLength:0];
    _request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    _connection = [[NSURLConnection alloc] initWithRequest:_request delegate:self];
    return self;
    
}

@end
