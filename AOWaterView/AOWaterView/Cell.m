//
//  Cell.m
//  redondo
//
//  Created by chester on 13-11-13.
//  Copyright (c) 2013年 akria.king. All rights reserved.
//

#import "Cell.h"
#import "PhotoViewController.h"

@implementation Cell{
    PhotoViewController *detailViewController;
}

bool hasCreatedImageView;
extern NSMutableArray *totalArr;
extern UIViewController *thisViewController;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        hasCreatedImageView = NO;
        
        if(hasCreatedImageView == NO){
            self.imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 78, 78)];
            self.imgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(80, 2, 78, 78)];
            self.imgView3 = [[UIImageView alloc] initWithFrame:CGRectMake(160, 2, 78, 78)];
            self.imgView4 = [[UIImageView alloc] initWithFrame:CGRectMake(240, 2, 78, 78)];
            
            UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapAction:)];
            UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapAction:)];
            UITapGestureRecognizer *singleTap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapAction:)];
            UITapGestureRecognizer *singleTap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapAction:)];
            [self.imgView1 addGestureRecognizer:singleTap1];
            [self.imgView2 addGestureRecognizer:singleTap2];
            [self.imgView3 addGestureRecognizer:singleTap3];
            [self.imgView4 addGestureRecognizer:singleTap4];
            
            self.imgView1.userInteractionEnabled = YES;
            self.imgView2.userInteractionEnabled = YES;
            self.imgView3.userInteractionEnabled = YES;
            self.imgView4.userInteractionEnabled = YES;
            
            [self addSubview:self.imgView1];
            [self addSubview:self.imgView2];
            [self addSubview:self.imgView3];
            [self addSubview:self.imgView4];
            
            hasCreatedImageView = YES;
        }
    }
    return self;
}

-(void)singleTapAction:(id)sender
{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    NSLog(@"%d", tap.view.tag);
    
    detailViewController = [[PhotoViewController alloc] initWithPhotoData:[totalArr objectAtIndex:tap.view.tag]];
    [thisViewController.navigationController pushViewController:detailViewController animated:YES];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
