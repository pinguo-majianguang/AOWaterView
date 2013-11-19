//
//  MainViewController.m
//  AOWaterView
//
//  Created by akria.king on 13-4-10.
//  Copyright (c) 2013年 akria.king. All rights reserved.
//

#import "MainViewController.h"
#import "DataAccess.h"
#import "AppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "Cell.h"
@interface MainViewController ()

@end

@implementation MainViewController
{
    UITableView *t1;
    UITableView *t2;
}

extern NSMutableArray *totalArr;
extern UIViewController *thisViewController;
extern MLNavigationController *navCtrl;
bool animateFlag;
bool isreloading;
int loadCount;

@synthesize aoView;
@synthesize leftSwipeGestureRecognizer;
@synthesize rightSwipeGestureRecognizer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
    
}
//初始化

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    thisViewController = self;
    
}

-(NSData *)getDataFromServer:(BOOL)needMore
{
    
    NSString *URLPath = [NSString stringWithFormat:@"https://cloud.camera360.com/activity/picture/hot?activityId=52569bb88852d69963256a7f&limit=80"];
    if(needMore == YES){
        URLPath = [URLPath stringByAppendingString:[NSString stringWithFormat:@"&last=%@",[[totalArr objectAtIndex:totalArr.count-1] objectForKey:@"id"]]];
    }
    NSURL *URL = [NSURL URLWithString:URLPath];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (data == nil) {
        NSLog(@"send request failed: %@", error);
        return nil;
    }
    return data;
}

-(void)initParamAndEvent

{
    animateFlag = YES;
    isreloading = NO;
    
    loadCount= 0;
    
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:self.leftSwipeGestureRecognizer];
    [self.view addGestureRecognizer:self.rightSwipeGestureRecognizer];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化参数和事件
    [self initParamAndEvent];
    thisViewController = self;
    
    DataAccess *dataAccess= [[DataAccess alloc]init];
    self.view.frame = CGRectMake(0, 0, 320, 568);
    
    //UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self];
    
    //window.rootViewController = nav;
    [self setTitle:@"品果三周年庆"];
    
    //从服务器获取数据
    NSData *data = [self getDataFromServer:NO];
    id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if([[res objectForKey:@"message"] isEqualToString:@"OK"])
    {
        NSMutableArray *arr = [[res objectForKey:@"data"] objectForKey:@"list"];
        totalArr = arr;
        self.aoView = [[AOWaterView alloc]initWithDataArray:arr];
        self.aoView.delegate=self;
        self.aoView.frame = CGRectMake(0, -64, 320, 568);
        
        [self.view addSubview:self.aoView];
        //[self createHeaderView];
        [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];
    }
    // Do any additional setup after loading the view from its nib.
}

//页面刷新
-(void)refreshView{
    DataAccess *dataAccess= [[DataAccess alloc]init];
    
    //从服务器获取数据
    NSData *data = [self getDataFromServer:NO];
    id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if([[res objectForKey:@"message"] isEqualToString:@"OK"])
    {
        NSMutableArray *arr = [[res objectForKey:@"data"] objectForKey:@"list"];
        totalArr = arr;
        [self.aoView refreshView:arr];
        [self testFinishedLoadData];
    }
}

//继续加载数据
-(void)getNextPageView{
    [self removeFooterView];
    isreloading = YES;
    DataAccess *dataAccess= [[DataAccess alloc]init];
    NSMutableArray *dataArray = [dataAccess getDateArray];
    
    //从服务器获取数据
    NSData *data = [self getDataFromServer:YES];
    id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if([[res objectForKey:@"message"] isEqualToString:@"OK"])
    {
        NSMutableArray *arr = [[res objectForKey:@"data"] objectForKey:@"list"];
        [totalArr addObjectsFromArray:arr];
        [self.aoView getNextPage:arr];
        [self testFinishedLoadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [indexPath row];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    int tag = tableView.tag;
    switch (tag) {
        case 1:
        {
            return (totalArr.count / 4)+2;
        }
            break;
            
        default:
            return 5;
            break;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if(indexPath.row == 0) { return 60.0f; } else if(indexPath.row == 1) { return 70.0f; } else { return 55.0f; }
    int tag = tableView.tag;
    switch (tag) {
        case 1:
            return 80.0f;
            break;
            
        default:
            return 30.0f;
            break;
    }
}

- (Cell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"Cell";
    Cell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellWithIdentifier];
    }
    int tag = tableView.tag;
    
    switch (tag) {
        case 1:{
            //cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
            NSUInteger row = [indexPath row];
            if(isreloading == YES){
                loadCount ++;
                if(loadCount >= 8){
                    isreloading = NO;
                    loadCount = 0;
                }
            }
            
            if(isreloading == NO){
                //                cell.imgView1.alpha = 0;
                //                cell.imgView2.alpha = 0;
                //                cell.imgView3.alpha = 0;
                //                cell.imgView4.alpha = 0;
                //
                //                [UIImageView beginAnimations:@"fade in" context:NULL];
                //                UIImageView.animationDuration = 0.2;
                //                UIImageView.animationRepeatCount = 0;
                //                cell.imgView1.alpha = 1;
                //                cell.imgView2.alpha = 1;
                //                cell.imgView3.alpha = 1;
                //                cell.imgView4.alpha = 1;
                //                [UIImageView commitAnimations];
            }
            
            //[cell.imgView1 setImage:[UIImage imageNamed:@"logo.png"]];
            
            if([indexPath row] == 0){
                if (_refreshHeaderView && [_refreshHeaderView superview]) {
                    [_refreshHeaderView removeFromSuperview];
                }
                _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                                      CGRectMake(0.0f, 0.0f - self.view.bounds.size.height+80.0f,
                                                 self.view.frame.size.width, self.view.bounds.size.height)];
                _refreshHeaderView.delegate = self;
                
                [cell addSubview:_refreshHeaderView];
                
                [_refreshHeaderView refreshLastUpdatedDate];
            }else if (row == (totalArr.count/4 +1)){
                //                NSLog(@"hhh");
                //                UIEdgeInsets test = self.aoView.contentInset;
                //                CGFloat height = MAX(self.aoView.contentSize.height, self.aoView.frame.size.height);
                //                if (_refreshFooterView && [_refreshFooterView superview]) {
                //                    _refreshFooterView.frame = CGRectMake(0.0f, 0.0f, self.aoView.frame.size.width, self.view.bounds.size.height);
                //                }else {
                //                    _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.aoView.frame.size.width, self.view.bounds.size.height)];
                //                    _refreshFooterView.delegate = self;
                //                    //[cell addSubview:_refreshFooterView];
                //                }
                //
                //                if (_refreshFooterView) {
                //                    //[_refreshFooterView refreshLastUpdatedDate];
                //                }
                UIView *vv = _refreshFooterView;
                [cell addSubview:vv];
                vv.frame = CGRectMake(0, 0, 320, 568);
                vv.backgroundColor = [UIColor whiteColor];
                [cell bringSubviewToFront:vv];
            }
            else{
                NSMutableArray *imageViews = [self getImageViewsForRow:row-1];
                [cell bringSubviewToFront:cell.imgView1];
                [cell bringSubviewToFront:cell.imgView2];
                [cell bringSubviewToFront:cell.imgView3];
                [cell bringSubviewToFront:cell.imgView4];
                [cell.imgView1 setImageWithURL:[NSURL URLWithString:[imageViews objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
                [cell.imgView2 setImageWithURL:[NSURL URLWithString:[imageViews objectAtIndex:1]] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
                [cell.imgView3 setImageWithURL:[NSURL URLWithString:[imageViews objectAtIndex:2]] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
                [cell.imgView4 setImageWithURL:[NSURL URLWithString:[imageViews objectAtIndex:3]] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
                cell.imgView1.tag = row*4 + 0-4;
                cell.imgView2.tag = row*4 + 1-4;
                cell.imgView3.tag = row*4 + 2-4;
                cell.imgView4.tag = row*4 + 3-4;
                
            }
            
            
            
            //[cell.contentView addSubview:[totalArr objectAtIndex:row]];
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = NO;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
            
            break;
            
            //        default:
            //            return;
            //            break;
    }
    return cell;
}

-(NSMutableArray *)getImageViewsForRow:(NSUInteger *)rowIndex
{
    int thisRowIndex = rowIndex;
    int loopCount;
    
    loopCount = 4;
    
    NSMutableArray *urlArr = [[NSMutableArray alloc] init];
    
    for(int i=0; i<loopCount; i++){
        NSString *url = [NSString stringWithFormat:@"http://cloud-activity.qiniudn.com/%@-135", [[totalArr objectAtIndex:thisRowIndex*4 + i] objectForKey:@"key"]];
        [urlArr addObject:url];
    }
    return urlArr;
}


-(void)disappear:(NSTimer *)timer
{
    animateFlag = YES;
}


//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    NSLog(@"tttt");
//    int currentPostion = scrollView.contentOffset.y;
//    if (currentPostion - _lastPosition > 25) {
//        _lastPosition = currentPostion;
//        NSLog(@"ScrollUp now");
//    }
//    else if (_lastPosition - currentPostion > 25)
//    {
//        _lastPosition = currentPostion;
//        NSLog(@"ScrollDown now");
//    }
//}

/*自定义方法结束*/



-(void)testFinishedLoadData{
    
    [self finishReloadingData];
    [self setFooterView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
//初始化刷新视图
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#pragma mark
#pragma methods for creating and removing the header view

-(void)createHeaderView{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
	_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
	[self.aoView addSubview:_refreshHeaderView];
    
    [_refreshHeaderView refreshLastUpdatedDate];
}

-(void)removeHeaderView{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    _refreshHeaderView = nil;
}

-(void)setFooterView{
    UIEdgeInsets test = self.aoView.contentInset;
    CGFloat height = MAX(self.aoView.contentSize.height, self.aoView.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview]) {
        _refreshFooterView.frame = CGRectMake(0.0f, height, self.aoView.frame.size.width, self.view.bounds.size.height);
    }else {
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:CGRectMake(0.0f, height, self.aoView.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [self.aoView addSubview:_refreshFooterView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView refreshLastUpdatedDate];
    }
}

-(void)removeFooterView{
    if (_refreshFooterView && [_refreshFooterView superview]) {
        [_refreshFooterView removeFromSuperview];
    }
    _refreshFooterView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark-
#pragma mark force to show the refresh headerView
-(void)showRefreshHeader:(BOOL)animated{
	if (animated)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		self.aoView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        // scroll the table view to the top region
        [self.aoView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
        [UIView commitAnimations];
	}
	else
	{
        self.aoView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[self.aoView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
	}
    
    [_refreshHeaderView setState:EGOOPullRefreshLoading];
}
//===============
//刷新delegate
#pragma mark -
#pragma mark data reloading methods that must be overide by the subclass

-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
	
	//  should be calling your tableviews data source model to reload
	_reloading = YES;
    
    if (aRefreshPos == EGORefreshHeader) {
        // pull down to refresh data
        [self performSelector:@selector(refreshView) withObject:nil afterDelay:2.0];
    }else if(aRefreshPos == EGORefreshFooter){
        // pull up to load more data
        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:2.0];
    }
    
	// overide, the actual loading data operation is done in the subclass
}

#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
	
	//  model should call this when its done loading
	_reloading = NO;
    
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.aoView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.aoView];
        [self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
	
	if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
    
    int currentPostion = scrollView.contentOffset.y;
    if (currentPostion - _lastPosition > 400) {
        _lastPosition = currentPostion;
        //[self.navigationController setNavigationBarHidden:YES animated:YES];
    }else if (_lastPosition - currentPostion > 400)
    {
        _lastPosition = currentPostion;
        //[self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
	
	if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}


#pragma mark -
#pragma mark EGORefreshTableDelegate Methods

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos{
	
	[self beginToReloadData:aRefreshPos];
	
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}


// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}


@end
