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
    UIImageView *_backImage;
    double rotate1;
    
}
@synthesize backImg;
extern UIViewController *thisViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(UIImageView *)rotate360DegreeWithImageView:(UIImageView *)imageView{
    CABasicAnimation *animation = [ CABasicAnimation
                                   animationWithKeyPath: @"transform" ];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    //围绕Z轴旋转，垂直与屏幕
    animation.toValue = [ NSValue valueWithCATransform3D:
                         
                         CATransform3DMakeRotation(M_PI, 0.0, 0.0, 1.0) ];
    animation.duration = 50;
    //旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
    animation.cumulative = YES;
    animation.repeatCount = 1000;
    
    //在图片边缘添加一个像素的透明区域，去图片锯齿
    CGRect imageRrect = CGRectMake(0, 0,imageView.frame.size.width, imageView.frame.size.height);
    UIGraphicsBeginImageContext(imageRrect.size);
    [imageView.image drawInRect:CGRectMake(1,1,imageView.frame.size.width-2,imageView.frame.size.height-2)];
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [imageView.layer addAnimation:animation forKey:nil];
    return imageView;
}

-(void)initAccelerometer{
    self.accelerometer = [UIAccelerometer sharedAccelerometer];
    self.accelerometer.delegate = self;
    self.accelerometer.updateInterval = 1.0/10.0;
}

- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    rotate1 = 0.0;
    rotate1 += 10.0;
    
    [UIImageView beginAnimations:@"" context:NULL];
    UIImageView.animationDuration = 0.1;
    self.backImg.frame = CGRectMake(-(acceleration.x*20)-50, (acceleration.y*20)-50, 420, 668);
    self.backImg.contentMode = UIViewContentModeScaleToFill;
    [UIImageView commitAnimations];
    
//    CGAffineTransform rotate = CGAffineTransformMakeRotation( 1.0 / (180.0+rotate1) * 3.14 );
//    
//    //_backImage.layer.anchorPoint = CGPointMake(-160.0, -284.0);
//    
//    [_backImage setTransform:rotate];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController setNavigationBarHidden:YES];
    [self initAccelerometer];
    
    
    self.backImg= [[UIImageView alloc] initWithFrame:CGRectMake(-50, -50, 420, 668)];
    UIImage *img = [UIImage imageNamed:@"wallpaper.jpg"];
    self.backImg.image = img;
    [self.view addSubview:self.backImg];
    //[self rotate360DegreeWithImageView:_backImage];
    //停止所有动画
    //[self.view.layer removeAllAnimates];
    
    
//    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(65, 70, 230, 140)];
//    UIImage *logo = [UIImage imageNamed:@"logo.png"];
//    logoView.image = logo;
//    
//    [backImage addSubview:logoView];
    


    
    
    //登录输入框
    _username = [[UITextField alloc] initWithFrame:CGRectMake(40, 260, 240, 35)];
    _username.borderStyle = UITextBorderStyleRoundedRect;
    _username.backgroundColor = [UIColor clearColor];
    _username.placeholder = @"username";
    //_username.font = [UIFont fontWithName:@"Helvetica Neue" size:16];
    _username.font = [UIFont fontWithName:@"HelveticaNeue LT 25 UltLight" size:16];
    [_username setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    _password = [[UITextField alloc] initWithFrame:CGRectMake(40, 310, 240, 35)];
    _password.borderStyle = UITextBorderStyleRoundedRect;
    _password.backgroundColor = [UIColor clearColor];
    _password.placeholder = @"password";
    _password.font = [UIFont fontWithName:@"HelveticaNeue LT 25 UltLight" size:16];
    _password.secureTextEntry = YES;
    [_password setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    
    _username.delegate = self;
    _password.delegate = self;
    
    _username.text =@"administrator";
    _password.text = @"password";
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(65, 70, 230, 140)];
    label.text = @"Cloud";
    label.font = [UIFont fontWithName:@"HelveticaNeue LT 25 UltLight" size:80];
    label.textColor = [UIColor whiteColor];
    [self.view addSubview:label];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(45, 120, 230, 140)];
    label1.text = @"service";
    label1.font = [UIFont fontWithName:@"HelveticaNeue LT 25 UltLight" size:50];
    label1.textColor = [UIColor whiteColor];
    label1.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:label1];
    
    
    UIView *startContentView = [[UIView alloc] initWithFrame:CGRectMake(120, 380, 80, 80)];
    [self.view addSubview:startContentView];
    UILabel *startLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    startLabel.text = @"Start";
    startLabel.font = [UIFont fontWithName:@"HelveticaNeue LT 25 UltLight" size:35];
    startLabel.textColor = [UIColor whiteColor];
    startLabel.textAlignment = NSTextAlignmentCenter;
    [startContentView addSubview:startLabel];
    
    startContentView.backgroundColor = [UIColor redColor];
    startContentView.layer.cornerRadius = 40;
    startContentView.backgroundColor = [UIColor colorWithRed:0.38 green:0.57 blue:0.84 alpha:1];
    startContentView.alpha = 0.8;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapAction)];
    [startContentView addGestureRecognizer:singleTap];
    startContentView.userInteractionEnabled = YES;
    
    [self.view addSubview:_username];
    [self.view addSubview:_password];
    
    UIButton *loginbtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 360, 240, 40)];
    loginbtn.backgroundColor = [UIColor colorWithRed:0.38 green:0.57 blue:0.84 alpha:1];
    [loginbtn.layer setCornerRadius:3.0]; //设置矩形四个圆角半径
    [loginbtn.layer setBorderWidth:1.0]; //边框宽度
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.22, 0.46, 0.79, 0 });
    [loginbtn.layer setBorderColor:colorref];
    [loginbtn setTitle:@"Login" forState:UIControlStateNormal];
    //[self.view addSubview:loginbtn];
    
    
    //swipe up to login
    UIButton *swipeToLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    swipeToLogin.frame = CGRectMake(40, 400, 240, 50);
    [swipeToLogin setTitle:@"swipe up to login" forState:UIControlStateNormal];
    
    
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
