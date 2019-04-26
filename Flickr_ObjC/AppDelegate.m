//
//  AppDelegate.m
//  Flickr_ObjC
//
//  Created by Anton Kuznetsov on 14/04/2019.
//  Copyright © 2019 Anton Kuznetsov. All rights reserved.
//

#import "AppDelegate.h"
#import "SearchViewController.h"
@import UserNotifications;
#import "PushService.h"


@interface AppDelegate () <UNUserNotificationCenterDelegate>

@property (strong, nonatomic) SearchViewController *searchViewController;
@property (strong, nonatomic) UINavigationController *navigationController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    SearchViewController *searchViewController = [[SearchViewController alloc] init];
    self.searchViewController = searchViewController;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    self.window.rootViewController = navigationController;
    self.navigationController = navigationController;
    [self.window makeKeyAndVisible];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    NSUInteger cacheSizeMemory = 500*1024*1024; // 500 MB
    NSUInteger cacheSizeDisk = 500*1024*1024; // 500 MB
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
    [NSURLCache setSharedURLCache:sharedCache];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    center.delegate = self;
    
    UNAuthorizationOptions options = UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge;
    
    [center requestAuthorizationWithOptions:options
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              if (!granted)
                              {
                                  NSLog(@"Доступ не дали");
                              }
                          }];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

    PushService *pushService = [PushService new];
    [pushService sheduleLocalNotification];
}


- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void(^)(void))completionHandler
{
    UNNotificationContent *content = response.notification.request.content;
    if (content.userInfo[@"request"])
    {
        NSString *request = content.userInfo[@"request"];
        self.searchViewController.searchBar.text = request;
        [self.navigationController popViewControllerAnimated:YES];
        [self.searchViewController.networkService findFlickrPhotoWithSearchString:request];
    }
    
    if (completionHandler)
    {
        completionHandler();
    }
}
@end
