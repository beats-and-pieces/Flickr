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
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    SearchViewController *searchViewController = [[SearchViewController alloc] init];
    self.searchViewController = searchViewController;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    self.window.rootViewController = navigationController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    //    [self.window makeKeyAndVisible];
    
    // Set app-wide shared cache (first number is megabyte value)
    NSUInteger cacheSizeMemory = 500*1024*1024; // 500 MB
    NSUInteger cacheSizeDisk = 500*1024*1024; // 500 MB
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
    [NSURLCache setSharedURLCache:sharedCache];
    //    sleep(1); // Critically important line, sadly, but it's worth it!
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    // Устанавливаем делегат
    center.delegate = self;
    
    // Указываем тип пушей для работы
    UNAuthorizationOptions options = UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge;
    
    // Запрашиваем доступ на работу с пушами
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
        [self.searchViewController.networkService findFlickrPhotoWithSearchString:request];
    }
    
    if (completionHandler)
    {
        completionHandler();
    }
}
@end
