//
//  oneViewController.m
//  AOWaterView
//
//  Created by chester on 13-11-7.
//  Copyright (c) 2013年 akria.king. All rights reserved.
//

#import "oneViewController.h"
#import "MainViewController.h"

@interface oneViewController ()

@end

@implementation oneViewController
{
    UITextField *_username;
    UITextField *_password;
    
    
}
extern UIViewController *thisViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController setNavigationBarHidden:YES];
    
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    UIImage *img = [UIImage imageNamed:@"23.jpg"];
    backImage.image = img;
    [self.view addSubview:backImage];
    
    
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(65, 70, 230, 140)];
    UIImage *logo = [UIImage imageNamed:@"logo.png"];
    logoView.image = logo;
    
    [backImage addSubview:logoView];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapAction)];
    [backImage addGestureRecognizer:singleTap];
    
    backImage.userInteractionEnabled = YES;
    
    
    //登录输入框
    _username = [[UITextField alloc] initWithFrame:CGRectMake(40, 260, 240, 35)];
    _username.borderStyle = UITextBorderStyleRoundedRect;
    _username.backgroundColor = [UIColor clearColor];
    _username.placeholder = @"username";
    _username.font = [UIFont fontWithName:@"Helvetica Neue" size:16];
    [_username setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    _password = [[UITextField alloc] initWithFrame:CGRectMake(40, 310, 240, 35)];
    _password.borderStyle = UITextBorderStyleRoundedRect;
    _password.backgroundColor = [UIColor clearColor];
    _password.placeholder = @"password";
    _password.font = [UIFont fontWithName:@"Helvetica Neue" size:16];
    _password.secureTextEntry = YES;
    [_password setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    
    _username.delegate = self;
    _password.delegate = self;
    
    
    [backImage addSubview:_username];
    [backImage addSubview:_password];
    
    UIButton *loginbtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 360, 240, 40)];
    loginbtn.backgroundColor = [UIColor colorWithRed:0.38 green:0.57 blue:0.84 alpha:1];
    [loginbtn.layer setCornerRadius:3.0]; //设置矩形四个圆角半径
    [loginbtn.layer setBorderWidth:1.0]; //边框宽度
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.22, 0.46, 0.79, 1 });
    [loginbtn.layer setBorderColor:colorref];
    [loginbtn setTitle:@"Login" forState:UIControlStateNormal];
    [backImage addSubview:loginbtn];
    
    
    [loginbtn addTarget:self action:@selector(singleTapAction) forControlEvents:UIControlEventTouchUpInside];
    
    //输入框获取焦点事派发消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    
}


//失去焦点时，收起键盘，界面往下推
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    [UIView beginAnimations:@"Curl"context:nil];//动画开始
    [UIView setAnimationDuration:0.30];
    [UIView setAnimationDelegate:self];
    [self.view setFrame:CGRectMake(0, 0, 320, 568)];
    [UIView commitAnimations];
    return YES;
}

//输入框获取焦点时，把界面网上推
- (void)keyboardWillShow:(NSNotification *)noti
{
    //键盘输入的界面调整
    //键盘的高度
    //float height = 216.0;
    //CGRect frame = self.view.frame;

    //frame.size = CGSizeMake(frame.size.width, frame.size.height - height);
    [UIView beginAnimations:@"Curl"context:nil];//动画开始
    [UIView setAnimationDuration:0.30];
    [UIView setAnimationDelegate:self];
    [self.view setFrame:CGRectMake(0, -50, 320, 568)];
    [UIView commitAnimations];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)singleTapAction
{
    
    
    NSString *usernameText = _username.text;
    NSString *passwordText = _password.text;
    
    
    //[yourTextField.text isEqualToString:@""]  || yourTextField.text == nil
    
    if(usernameText.length == 0 || passwordText.length == 0){

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"attention" message:@"username or password is required." delegate:self cancelButtonTitle:@"I got" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    
    
    [_username resignFirstResponder];
    [_password resignFirstResponder];
    _username.text = @"";
    _password.text = @"";
    if(!thisViewController){
        thisViewController = [[MainViewController alloc] init];
        NSLog(@"fdfd");
    }
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController pushViewController:thisViewController animated:YES];
    //[_homeView release];
    //[self presentViewController:_homeView animated:YES completion:^{}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
