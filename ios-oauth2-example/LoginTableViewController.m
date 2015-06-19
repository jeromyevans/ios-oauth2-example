//
//  LoginTableViewController.m
//  ios-oauth2-example
//
//  Created by Jeromy Evans (personal) on 17/06/2015.
//  Copyright (c) 2015 Jeromy Evans. All rights reserved.
//

#import "LoginTableViewController.h"
#import <NXOAuth2.h>

@interface LoginTableViewController ()

@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;

@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) IBOutlet UIButton *loginButton;

@property (strong, nonatomic) IBOutlet UILabel *errorMessageLabel;


@end

@implementation LoginTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.usernameTextField becomeFirstResponder];
  
  [self setupAuthenticationListeners];
  [self clearStoredAccounts];
}

- (void)setupAuthenticationListeners {
  [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreAccountsDidChangeNotification
      object:[NXOAuth2AccountStore sharedStore]
      queue:nil
      usingBlock:^(NSNotification *aNotification){
        
        NSDictionary *userInfo = aNotification.userInfo;
        if (userInfo != nil) {
          NXOAuth2Account *newAccount = [userInfo objectForKey:NXOAuth2AccountStoreNewAccountUserInfoKey];
          if (newAccount != nil) {
            NSLog(@"authenticated okay.");
            // we don't need to store a reference to the account
            // as the oauth2 client has an account store in the keychain
            [self performSegueWithIdentifier:@"AuthenticatedOk" sender:self];
          }
        }
      }];
  
  [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreDidFailToRequestAccessNotification
      object:[NXOAuth2AccountStore sharedStore]
      queue:nil
      usingBlock:^(NSNotification *aNotification){
        NSError *error = [aNotification.userInfo objectForKey:NXOAuth2AccountStoreErrorKey];
      
        NSLog(@"oauth error reported.");
        dispatch_async(dispatch_get_main_queue(), ^{
          [self.errorMessageLabel setText:[NSString stringWithFormat:@"Login failed: %@", [error localizedDescription]]];
        });
        
     
      }];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

// gets all the accounts of this type and remove them from the keystore
- (void) clearStoredAccounts {
  NSArray* accounts = [[NXOAuth2AccountStore sharedStore] accountsWithAccountType:@"oauth-jwt-example"];
  
  for (NXOAuth2Account *account in accounts) {
    [[NXOAuth2AccountStore sharedStore]  removeAccount:account];
  }
  
}

- (IBAction)didTouchLoginButton:(id)sender {
  
  NSString* enteredUsername = self.usernameTextField.text;
  NSString* enteredPassword = self.passwordTextField.text;
  
  // request oauth access token - this is asynchronous, generates a notification on success or error
  [[NXOAuth2AccountStore sharedStore] requestAccessToAccountWithType:@"oauth-jwt-example"
                                                            username:enteredUsername
                                                            password:enteredPassword];

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
