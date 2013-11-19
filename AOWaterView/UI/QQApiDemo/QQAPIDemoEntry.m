//
//  QQAPIDemoEntryControllerViewController.m
//  sdkDemo
//
//  Created by JeaminW on 13-7-28.
//  Copyright (c) 2013年 xiaolongzhang. All rights reserved.
//

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "QQAPIDemoEntry.h"
#import "QuickDialogController.h"
#import "QRootElement.h"
#import "QBooleanElement.h"
#import <objc/runtime.h>

#import "TencentRequest.h"
#import "NSStringAdditions.h"
#import "TCQRCodeGenerator.h"

#if __QQAPI_ENABLE__
#import "TencentOpenAPI/QQApiInterface.h"
#endif


@implementation QQAPIDemoEntry

+ (UIViewController *)EntryController
{
    UIViewController *QDialog = [QuickDialogController controllerForRoot:[QRootElement rootForJSON:@"QQAPIDemo" withObject:nil]];
    return QDialog;
}

#if __QQAPI_ENABLE__
#pragma mark - QQApiInterfaceDelegate
+ (void)onReq:(QQBaseReq *)req
{
    switch (req.type)
    {
        case EGETMESSAGEFROMQQREQTYPE:
        {
            break;
        }
        default:
        {
            break;
        }
    }
}

+ (void)onResp:(QQBaseResp *)resp
{
    switch (resp.type)
    {
        case ESENDMESSAGETOQQRESPTYPE:
        {
            SendMessageToQQResp* sendResp = (SendMessageToQQResp*)resp;
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:sendResp.result message:sendResp.errorDescription delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            break;
        }
        default:
        {
            break;
        }
    }
}
#endif

@end


@interface QQAPIDemoCommonController : QuickDialogController <TencentRequestDelegate,QQApiInterfaceDelegate>
{
    QQApiObject *_qqApiObject;
}

@property (nonatomic, strong) NSString *binding_title;
@property (nonatomic, strong) NSString *binding_text;
@property (nonatomic, strong) NSString *binding_description;
@property (nonatomic, strong) NSString *binding_url;
@property (nonatomic, strong) UIImage *binding_previewImage;
@property (nonatomic, strong) NSString *binding_previewImageUrl;
@property (nonatomic, strong) NSString *binding_streamUrl;

@property (nonatomic, strong) NSString *tenpayID;
@property (nonatomic, strong) TencentRequest *requestQRStr;
@property (nonatomic, strong) UIControl *qrcodePanel;
@property (nonatomic, strong) UIImageView *qrcodeImgView;

// WPA
@property (nonatomic, strong) NSString *binding_uin;

@end

@implementation QQAPIDemoCommonController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self.root.object isKindOfClass:[NSDictionary class]])
    {
        NSString *jsonConfig = self.root.object[@"jsonConfig"];
        if ([jsonConfig isKindOfClass:[NSString class]])
        {
            self.root = [QRootElement rootForJSON:jsonConfig withObject:nil];
        }
    }
    
    CGRect frame = [[self view] bounds];
    self.qrcodePanel = [[UIControl alloc] initWithFrame:frame];
    self.qrcodePanel.hidden = YES;
    self.qrcodePanel.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.9];
    [self.qrcodePanel addTarget:self action:@selector(onQRCodePanelClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.qrcodePanel];
    
    CGRect panelFrame = [self.qrcodePanel bounds];
    CGFloat minSize = MIN(panelFrame.size.width, panelFrame.size.height) * 0.9f;
    self.qrcodeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, minSize, minSize)];
    self.qrcodeImgView.center = CGPointMake(CGRectGetMidX(panelFrame), CGRectGetMidY(panelFrame));
    [self.qrcodePanel addSubview:self.qrcodeImgView];
    
    if ([[self.root key] isEqualToString:@"QQAPIDemo"])
    {
        [[self currentNavContext] removeAllObjects];
    }
}

- (void)setTenpayID:(NSString *)tenpayID
{
    _tenpayID = tenpayID;
    QElement *QQPayBtn = [self.root elementWithKey:@"QQPayBtn"];
    if (_tenpayID.length == 0)
    {
        [QQPayBtn setEnabled:NO];
    }
    else
    {
        [QQPayBtn setEnabled:YES];
    }
    [self.quickDialogTableView reloadCellForElements:QQPayBtn, nil];
}

- (NSMutableDictionary *)currentNavContext
{
    UINavigationController *navCtrl = [self navigationController];
    NSMutableDictionary *context = objc_getAssociatedObject(navCtrl, objc_unretainedPointer(@"currentNavContext"));
    if (nil == context)
    {
        context = [NSMutableDictionary dictionaryWithCapacity:3];
        objc_setAssociatedObject(navCtrl, objc_unretainedPointer(@"currentNavContext"), context, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return context;
}

- (void)onSwitchCFlag:(QElement *)sender
{
    if ([sender isKindOfClass:[QBooleanElement class]])
    {
        QBooleanElement *boolElem = (QBooleanElement *)sender;
        NSString *flagKey = boolElem.key;
        uint32_t flagValue = [boolElem.object[@"flagValue"] unsignedIntValue] * (!![boolElem boolValue]);
        
        [[self currentNavContext] setObject:[NSNumber numberWithUnsignedInt:flagValue] forKey:flagKey];
    }
}

- (uint64_t)shareControlFlags
{
    NSDictionary *context = [self currentNavContext];
    __block uint64_t cflag = 0;
    [context enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSNumber class]] &&
            [key isKindOfClass:[NSString class]] &&
            [key hasPrefix:@"kQQAPICtrlFlag"])
        {
            cflag |= [obj unsignedIntValue];
        }
    }];
    
    return cflag;
}

#if __QQAPI_ENABLE__
- (void)onShareText:(QElement *)sender
{
    [self.view endEditing:YES];
    [self.root fetchValueUsingBindingsIntoObject:self];

    QQApiTextObject *txtObj = [QQApiTextObject objectWithText:self.binding_text ? : @""];
    [txtObj setCflag:[self shareControlFlags]];
    
    _qqApiObject = txtObj;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请选择分享的平台" message:@"请选择你要分享内容的平台" delegate:self cancelButtonTitle:@"QZone" otherButtonTitles:@"QQ", nil];
    [alertView show];
}

- (void)onShareImage:(QElement *)sender
{
    [self.view endEditing:YES];
    [self.root fetchValueUsingBindingsIntoObject:self];
    
    NSString *imgPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"test.gif"];
    NSData *imgData = [NSData dataWithContentsOfFile:imgPath];
    if (self.binding_previewImage)
    {
        NSData *selectedImgData = UIImageJPEGRepresentation(self.binding_previewImage, 0.85);
        if (selectedImgData)
        {
            imgData = selectedImgData;
        }
    }
    
    QQApiImageObject *imgObj = [QQApiImageObject objectWithData:imgData
                                               previewImageData:imgData
                                                          title:self.binding_title ? : @""
                                                    description:self.binding_description ? : @""];
    [imgObj setCflag:[self shareControlFlags]];
    
    _qqApiObject = imgObj;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请选择分享的平台" message:@"请选择你要分享内容的平台" delegate:self cancelButtonTitle:@"QZone" otherButtonTitles:@"QQ", nil];
    [alertView show];
}

- (void)onShareNewsLocal:(QElement *)sender
{
    [self.view endEditing:YES];
    [self.root fetchValueUsingBindingsIntoObject:self];
    
    NSString *previewPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"news.jpg"];
    NSData *previewData = [NSData dataWithContentsOfFile:previewPath];
    if (self.binding_previewImage)
    {
        NSData *selectedImgData = UIImageJPEGRepresentation(self.binding_previewImage, 0.85);
        if (selectedImgData)
        {
            previewData = selectedImgData;
        }
    }
    
    NSString *utf8String = [self.binding_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:utf8String ? : @""]
                                                        title:self.binding_title ? : @""
                                                  description:self.binding_description ? : @""
                                             previewImageData:previewData];
    [newsObj setCflag:[self shareControlFlags]];
    
    _qqApiObject = newsObj;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请选择分享的平台" message:@"请选择你要分享内容的平台" delegate:self cancelButtonTitle:@"QZone" otherButtonTitles:@"QQ", nil];
    [alertView show];
}

- (void)onShareNewsWeb:(QElement *)sender
{
    [self.view endEditing:YES];
    [self.root fetchValueUsingBindingsIntoObject:self];
    
    NSString *utf8String = [self.binding_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:utf8String ? : @""]
                                                        title:self.binding_title ? : @""
                                                  description:self.binding_description ? : @""
                                              previewImageURL:[NSURL URLWithString:self.binding_previewImageUrl ? : @""]];
    [newsObj setCflag:[self shareControlFlags]];
    
    _qqApiObject = newsObj;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请选择分享的平台" message:@"请选择你要分享内容的平台" delegate:self cancelButtonTitle:@"QZone" otherButtonTitles:@"QQ", nil];
    [alertView show];
}

- (void)onShareAudio:(QElement *)sender
{
    [self.view endEditing:YES];
    [self.root fetchValueUsingBindingsIntoObject:self];
    
    NSData *previewData = nil;
    
    NSString *utf8String = [self.binding_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    QQApiAudioObject* audioObj = [QQApiAudioObject objectWithURL:[NSURL URLWithString:utf8String ? : @""]
                                                           title:self.binding_title ? : @""
                                                     description:self.binding_description ? : @""
                                                previewImageData:previewData];
    
    utf8String = [self.binding_previewImageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [audioObj setPreviewImageURL:[NSURL URLWithString: utf8String? : @""]];
    
    utf8String = [self.binding_streamUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [audioObj setFlashURL:[NSURL URLWithString:utf8String ? : @""]];
    [audioObj setCflag:[self shareControlFlags]];
    
    _qqApiObject = audioObj;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请选择分享的平台" message:@"请选择你要分享内容的平台" delegate:self cancelButtonTitle:@"QZone" otherButtonTitles:@"QQ", nil];
    [alertView show];
}

- (void)onShareVideo:(QElement *)sender
{
    [self.view endEditing:YES];
    [self.root fetchValueUsingBindingsIntoObject:self];
    
    NSString *previewPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"video.jpg"];
    NSData* previewData = [NSData dataWithContentsOfFile:previewPath];
    if (self.binding_previewImage)
    {
        NSData *selectedImgData = UIImageJPEGRepresentation(self.binding_previewImage, 0.85);
        if (selectedImgData)
        {
            previewData = selectedImgData;
        }
    }
    
    NSString *utf8String = [self.binding_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    QQApiVideoObject *videoObj = [QQApiVideoObject objectWithURL:[NSURL URLWithString:utf8String ? : @""]
                                                           title:self.binding_title ? : @""
                                                     description:self.binding_description ? : @""
                                                previewImageData:previewData];
    
    utf8String = [self.binding_streamUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [videoObj setFlashURL:[NSURL URLWithString:utf8String ? : @""]];
    [videoObj setCflag:[self shareControlFlags]];
    
    _qqApiObject = videoObj;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请选择分享的平台" message:@"请选择你要分享内容的平台" delegate:self cancelButtonTitle:@"QZone" otherButtonTitles:@"QQ", nil];
    [alertView show];
}

- (NSInteger)GetRandomNumber:(NSInteger)start to:(NSInteger)end
{
    return (NSInteger)(start + (arc4random() % (end - start + 1)));
}

- (void)onCreateOrderNum:(QElement *)sender
{
    if (self.requestQRStr)
    {
        self.requestQRStr.delegate = nil;
        [self.requestQRStr cancel];
        self.requestQRStr = nil;
    }
    
    NSNumber *Billno_Tail = [NSNumber numberWithInteger:[self GetRandomNumber:0 to:9999]];
    NSString *Param = [NSString stringWithFormat:@"attach=test&bank_type=0&bargainor_id=1900000109&callback_url=http://abc&charset=1&desc=test&fee_type=1&notify_url=http://abc&purchaser_id=583873140&sp_billno=19000001094949%@&total_fee=1&ver=2.0", [Billno_Tail stringValue]];
    NSString *ParamMD5 = [NSString stringWithFormat:@"%@&key=8934e7d15453e97507ef794cf7b0519d", Param];
    NSString *url = [NSString stringWithFormat:@"https://wap.tenpay.com/cgi-bin/wappayv2.0/wappay_init.cgi?%@&sign=%@", Param, [[ParamMD5 md5Hash] uppercaseString]];
    NSString *PayIDInfo = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
    //@"https://wap.tenpay.com/cgi-bin/wappayv2.0/wappay_init.cgi?attach=test&bank_type=0&bargainor_id=1900000109&callback_url=http://abc&charset=1&desc=test&fee_type=1&notify_url=http://abc&purchaser_id=583873140&sp_billno=190000010949497578&total_fee=1&ver=2.0&sign=2CC44AB13B9FD4131240FCC74AD8E988"] encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"%s|PayIDInfo:\n%@", __FUNCTION__, PayIDInfo);
    
    NSString *PayID = nil;
    NSRange start = [PayIDInfo rangeOfString:@"<token_id>"];
    if (NSNotFound != start.location)
    {
        PayID = [PayIDInfo substringFromIndex:start.location + start.length];
        NSRange end = [PayID rangeOfString:@"</token_id>"];
        if (NSNotFound != end.location)
        {
            PayID = [PayID substringToIndex:end.location];
        }
        else
        {
            PayID = nil;
        }
    }
    
    NSLog(@"%s|PayID:\n%@", __FUNCTION__, PayID);
    // https://graph.qq.com/vendor/open_qr?d=1234567&sign=3bf68cf5669f2a51a65189dc3c13831f&appid=100442986
    //    APP ID：100442986
    //    APP KEY：40836535e61977a2da874ba3ad09607c
    self.tenpayID = PayID;
    if (PayID)
    {
        NSString *appKey = @"40836535e61977a2da874ba3ad09607c";
        NSString *d = PayID;
        NSString *sign = [[NSString stringWithFormat:@"d=%@&type=%@%@", [d urlEncoded], [@"4" urlEncoded], appKey] md5Hash];
        NSString *appId = @"100442986";
        NSMutableDictionary *reqParams = [NSMutableDictionary dictionaryWithDictionary:@{
                                          @"type": @"4",
                                          @"d": d,
                                          @"sign": sign,
                                          @"appid": appId}];
        self.requestQRStr = [TencentRequest getRequestWithParams:reqParams httpMethod:@"POST" delegate:self requestURL:@"https://graph.qq.com/vendor/open_qr"];
        [self.requestQRStr connect];
    }
    else
    {
        UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"PayID获取失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [msgbox show];
    }
}

- (void)onQQPay:(QElement *)sender
{
    QQApiPayObject *payObj = [QQApiPayObject objectWithOrderNo:self.tenpayID ? : @""];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:payObj];
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
}

- (void)onOpenWPA:(QElement *)sender
{
    [self.view endEditing:YES];
    [self.root fetchValueUsingBindingsIntoObject:self];
    
    QQApiWPAObject *wpaObj = [QQApiWPAObject objectWithUin:self.binding_uin];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:wpaObj];
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
}

- (void)getQQUinOnlineStatues:(QElement *)sender
{
    [self.view endEditing:YES];
    [self.root fetchValueUsingBindingsIntoObject:self];
    
    NSArray *ARR = [NSArray arrayWithObjects:self.binding_uin, nil];
    [QQApiInterface getQQUinOnlineStatues:ARR delegate:self];
}

- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        default:
        {
            break;
        }
    }
}

#pragma mark - 生成支付二维码
- (void)showQRCode:(NSString *)qrcode
{
    CGFloat size = self.qrcodeImgView.bounds.size.width;
    UIImage *qrcodeImg = [TCQRCodeGenerator qrImageForString:qrcode imageSize:size];
    
    [self.qrcodeImgView setImage:qrcodeImg];
    [self.qrcodePanel setHidden:NO];
}

- (void)onQRCodePanelClick:(id)sender
{
    if (sender == self.qrcodePanel)
    {
        [sender setHidden:YES];
    }
}

#pragma mark - TencentRequestDelegate
- (void)request:(TencentRequest *)request didFailWithError:(NSError *)error
{
    UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"TenpayQR获取失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
    [msgbox show];
}

- (void)request:(TencentRequest *)request didLoad:(id)result dat:(NSData *)data
{
    NSString *tenpayUrl = [result objectForKey:@"url"];
    if (tenpayUrl)
    {
        [self showQRCode:tenpayUrl];
    }
    else
    {
        UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"TenpayQR解析失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [msgbox show];
    }
}
#endif


#pragma mark - QQApiInterfaceDelegate
- (void)onReq:(QQBaseReq *)req
{
    
}


- (void)onResp:(QQBaseResp *)resp
{
    
}


- (void)isOnlineResponse:(NSDictionary *)response
{
    
    NSArray *QQUins = [response allKeys];
    NSMutableString *messageStr = [NSMutableString string];
    for (NSString *str in QQUins) {
        if ([[response objectForKey:str] isEqualToString:@"YES"]) {
            [messageStr appendFormat:@"QQ号码为:%@ 的用户在线\n",str];
        } else {
            [messageStr appendFormat:@"QQ号码为:%@ 的用户不在线\n",str];
        }
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作成功" message:messageStr
                          
                                                   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
    [alert show];
    NSLog(@"response:%@",response);
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:_qqApiObject];
    QQApiSendResultCode sent = 0;
    if (0 == buttonIndex)
    {
        //分享到QZone
        sent = [QQApiInterface SendReqToQZone:req];
    }
    else
    {
        //分享到QQ
        sent = [QQApiInterface sendReq:req];
    }
    [self handleSendResult:sent];
}
@end

