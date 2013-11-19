//
//  DataAccess.m
//  AOWaterView
//
//  Created by akria.king on 13-4-10.
//  Copyright (c) 2013年 akria.king. All rights reserved.
//

#import "DataAccess.h"
#import "DataInfo.h"
@implementation DataAccess
-(NSDictionary *)getDicByPlist{
    /*NSString *path=[[NSBundle mainBundle] pathForResource:@"dataList" ofType:@"plist"];
     
     NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
     
     return dic;*/
    //同步请求
    return [self sendRequestSync];
}

//获取网络请求
- (void)httpAsynchronousRequest{
    
    NSURL *url = [NSURL URLWithString:@"http://cloud.camera360.com/activity/picture/hot?activityId=52569bb88852d69963256a7f"];
    
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
                                   
                                   NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                   
                                   NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   
                                   NSLog(@"HttpResponseCode:%d", responseCode);
                                   NSLog(@"HttpResponseBody %@",responseString);
                                   
                                   
                               }
                           }];
    
}
//发送同步请求
- (NSDictionary *)sendRequestSync
{
    NSString *str = @"http://cloud.camera360.com/activity/picture/hot?activityId=52569bb88852d69963256a7f";
    NSURL *url = [NSURL URLWithString:str];
    
    //重新组装url地址
    if (lastID) {
        url = [NSURL URLWithString:[str stringByAppendingString:[@"&last=" stringByAppendingString:lastID]]];
    }
    
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
        return nil;
    }
    //data = data.data.list;
    //打印回传的数据
    //NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"response: %@", response);
    
    //+ (id)JSONObjectWithData:(NSData *)data options:(NSJSONReadingOptions)opt error:(NSError **)error;
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    return dict;
}

//获取基础联系列
-(NSMutableArray *)getDateArray{
    NSDictionary *dic = [self getDicByPlist];
    NSMutableArray *imageList = [[NSMutableArray alloc]init];
    NSMutableArray *dicArray = [[dic objectForKey:@"data"] objectForKey:@"list"];
    //保存全部数据
    //[self.allDicArray addObject:dicArray];
    
    //NSString *url = @"http://cloud-activity.qiniudn.com/%@";
    
    for (NSDictionary *vdic in dicArray) {
        DataInfo *data=[[DataInfo alloc]init];
        NSNumber *hValue=[vdic objectForKey:@"h"];
        
        data.height= hValue.floatValue;
        NSNumber *wValue=[vdic objectForKey:@"w"];
        
        data.width= wValue.floatValue;
        data.url = [NSString stringWithFormat:@"http://cloud-activity.qiniudn.com/%@",(NSString *)[vdic objectForKey:@"key"]];
        data.key = [vdic objectForKey:@"key"];
        data.title=[[vdic objectForKey:@"uploadUser"] objectForKey:@"nickname"];
        data.face = [NSString stringWithFormat:@"https://dn-c360.qbox.me/%@", [[vdic objectForKey:@"uploadUser"] objectForKey:@"face"]];
        data.userName = [[vdic objectForKey:@"uploadUser"] objectForKey:@"nickname"];
        data.mess=[vdic objectForKey:@"desc"];
        data.pid = [vdic objectForKey:@"id"];
        data.favorite = [vdic objectForKey:@"favorite"];
        [imageList addObject:data];
    }
    if (lastID) {
        //[lastID];
    }
    //保存最后一条数据的日期
    lastID = [dicArray.lastObject objectForKey:@"id"];
    return imageList;
    
}
@end
