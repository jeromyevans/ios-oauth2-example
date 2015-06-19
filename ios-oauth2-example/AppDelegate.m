//
//  AppDelegate.m
//  ios-oauth2-example
//
//  Created by Jeromy Evans (personal) on 17/06/2015.
//  Copyright (c) 2015 Jeromy Evans. All rights reserved.
//

#import "AppDelegate.h"
#import <NXOAuth2.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

static NSString *kCliendId = @"thom";
static NSString *kClientSecret = @"nightworld";
static NSString *kOAuth2AccountType = @"oauth-jwt-example";

+ (void)initialize;
{
  // set up oauth2 client for the oauth-jwt-example
  [[NXOAuth2AccountStore sharedStore] setClientID:kCliendId
                                           secret:kClientSecret
                                 authorizationURL:[NSURL URLWithString:@"http://notused/"]
                                         tokenURL:[NSURL URLWithString:@"http://localhost:3000/oauth/token"]
                                      redirectURL:[NSURL URLWithString:@"http://notused/"]
                                   forAccountType:kOAuth2AccountType];
  
  // update configuration to use Content-Type application/x-www-form-urlencoded instead of the default
  NSMutableDictionary *configuration = [NSMutableDictionary dictionaryWithDictionary:[[NXOAuth2AccountStore sharedStore] configurationForAccountType:kOAuth2AccountType]];
  
  NSDictionary *customHeaderFields = [NSDictionary dictionaryWithObject:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
  [configuration setObject:customHeaderFields forKey:kNXOAuth2AccountStoreConfigurationCustomHeaderFields];
  [[NXOAuth2AccountStore sharedStore] setConfiguration:configuration forAccountType:kOAuth2AccountType];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Override point for customization after application launch.
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
