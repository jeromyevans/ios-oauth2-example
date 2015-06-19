//
//  SuccessViewController.m
//  ios-oauth2-example
//
//  Created by Jeromy Evans (personal) on 18/06/2015.
//  Copyright (c) 2015 Jeromy Evans. All rights reserved.
//

#import "SuccessViewController.h"
#import <NXOAuth2.h>

@interface SuccessViewController ()

@property (strong, nonatomic) IBOutlet UITextView *textView;

@end

@implementation SuccessViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self makeInitialRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTouchRefreshButton:(id)sender {
  [self.textView setText:@"requesting data.."];
  [self performSimpleGETOperation];
}

- (void)makeInitialRequest {
  
  [self performSimpleGETOperation];
}

- (void) performSimpleGETOperation {
  
  NSArray* accounts = [[NXOAuth2AccountStore sharedStore] accountsWithAccountType:@"oauth-jwt-example"];
  
  for (NXOAuth2Account *account in accounts) {
    
    [NXOAuth2Request performMethod:@"GET"
                        onResource:[NSURL URLWithString:@"http://localhost:3000/"]
                   usingParameters:nil
                       withAccount:account
               sendProgressHandler:^(unsigned long long bytesSend, unsigned long long bytesTotal) {
                 // e.g., update a progress indicator
               }
                   responseHandler:^(NSURLResponse *response, NSData *responseData, NSError *error){
                     // Process the response
                     NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                     
                     NSLog(@"Respone: %@", responseString);
                     
                     dispatch_async(dispatch_get_main_queue(), ^{
                       [self.textView setText:responseString];
                     });
                   }];
  }
 
}

// this version allows custom headers to be set
- (void) performCustomGETOperation {
  
  NSArray* accounts = [[NXOAuth2AccountStore sharedStore] accountsWithAccountType:@"oauth-jwt-example"];
  
  for (NXOAuth2Account *account in accounts) {
    
    NXOAuth2Request *theRequest = [[NXOAuth2Request alloc] initWithResource:[NSURL URLWithString:@"http://localhost:3000/"]
                                                                     method:@"GET"
                                                                 parameters:nil];
    theRequest.account = account;
    
    NSMutableURLRequest *sigendRequest = [[theRequest signedURLRequest] mutableCopy];
    
    [sigendRequest setHTTPMethod:@"GET"];
    [sigendRequest setValue:@"text/html,application/json" forHTTPHeaderField:@"Accept"];
    //    [sigendRequest setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    
    NXOAuth2Connection *connection = [[NXOAuth2Connection alloc]
                                      initWithRequest:sigendRequest
                                      requestParameters:nil
                                      oauthClient:account.oauthClient
                                      sendingProgressHandler:nil
                                      responseHandler:^(NSURLResponse *response, NSData *responseData, NSError *error){
                                        
                                        //        NSLog(@"dataAsString %@", [NSString stringWithUTF8String:[responseData bytes]]);
                                        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                                        
                                        NSLog(@"Respone: %@", responseString);
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                          [self.textView setText:responseString];
                                        });
                                      }];
    //connection.delegate = self;  <NXOAuth2ConnectionDelegate>
    
  }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
