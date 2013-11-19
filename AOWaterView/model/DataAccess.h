//
//  DataAccess.h
//  AOWaterView
//
//  Created by akria.king on 13-4-10.
//  Copyright (c) 2013年 akria.king. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataAccess : NSObject{
@public NSString *lastID;
}
-(NSMutableArray *)getDateArray;
@property (nonatomic, retain) NSMutableArray *allDicArray;
@end
