//
//  TQDAppInvitationController.m
//  tencentOAuthDemo
//
//  Created by 易壬俊 on 13-6-3.
//
//

#import "TQDAppInvitationController.h"
#import "QuickDemoViewController.h"

@interface TQDAppInvitationController ()

// params binding
@property (nonatomic, retain) NSString *binding_source;
@property (nonatomic, retain) NSString *binding_picurl;
@property (nonatomic, retain) NSString *binding_desc;

@end

@implementation TQDAppInvitationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    [_binding_source release];
    _binding_source = nil;
    [_binding_picurl release];
    _binding_picurl = nil;
    [_binding_desc release];
    _binding_desc = nil;
    [super dealloc];
}

- (void)onSendAppInvitation:(id)sender
{
    [self.view endEditing:YES];
    [self.root fetchValueUsingBindingsIntoObject:self];
    
    if (nil == self.binding_picurl)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"img" message:@"img 不为空" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        return;
    }
    [self.tencentOAuth sendAppInvitationWithDescription:self.binding_desc imageURL:self.binding_picurl source:self.binding_source];
}

@end
