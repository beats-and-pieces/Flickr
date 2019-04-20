//
//  PushService.m
//  Flickr_ObjC
//
//  Created by Anton Kuznetsov on 19/04/2019.
//  Copyright © 2019 Anton Kuznetsov. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "PushService.h"
#include <stdlib.h>
@import UserNotifications;


static const NSString *identifierForActions = @"LCTReminderCategory";

typedef NS_ENUM(NSInteger, LCTTriggerType) {
    LCTTriggerTypeInterval = 0,
    LCTTriggerTypeDate = 1,
    LCTTriggerTypeLocation = 2,
};


@implementation PushService
- (void)sheduleLocalNotification
{
    /* Контент - сущность класса UNMutableNotificationContent
     Содержит в себе:
     title: Заголовок, обычно с основной причиной показа пуша
     subtitle: Подзаговолок, не обязателен
     body: Тело пуша
     badge: Номер бейджа для указания на иконке приложения
     sound: Звук, с которым покажется push при доставке. Можно использовать default или установить свой из файла.
     launchImageName: имя изображения, которое стоит показать, если приложение запущено по тапу на notification.
     userInfo: Кастомный словарь с данными
     attachments: Массив UNNotificationAttachment. Используется для включения аудио, видео или графического контента.
     */
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    
    NSArray *requests = @[@"puppies", @"kittens"];
    
    NSDictionary *bodies = @{
                                 requests[0] : @"Вы давно не смотрели щенят",
                                 requests[1] : @"Вы давно не смотрели котят"
                                 };
    content.title = @"Напоминание!";
//    content.body = @"Вы давно не смотрели собачек";
    int randomNumber = arc4random_uniform(2);
    NSLog(@"random %d", randomNumber);
    content.body = bodies[requests[randomNumber]];
    content.sound = [UNNotificationSound defaultSound];
    NSDictionary *dict = @{
                           @"request": requests[randomNumber]
                           };
    content.userInfo = dict;
    
    content.badge = @(0);
    
    
    
    //  Добавляем кастомный attachement
    UNNotificationAttachment *attachment = [self imageAttachment];
    if (attachment)
    {
        content.attachments = @[attachment];
    }
    
  
    
    // Добавляем кастомную категорию
    content.categoryIdentifier = identifierForActions;
    
    // Смотрим разные варианты триггеров
    UNNotificationTrigger *whateverTrigger = [self triggerWithType:LCTTriggerTypeInterval];
    
    // Создаем запрос на выполнение
    // Objective-C
    NSString *identifier = @"NotificationId";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier
                                                                          content:content trigger:whateverTrigger];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error)
     {
         if (error)
         {
             NSLog(@"Чот пошло не так... %@",error);
         }
     }];
}


#pragma mark - Notifications

- (UNNotificationTrigger *)triggerWithType:(LCTTriggerType)triggerType
{
    switch (triggerType)
    {
        case LCTTriggerTypeInterval:
            return [self intervalTrigger];
        case LCTTriggerTypeLocation:
            return [self locationTrigger];
        case LCTTriggerTypeDate:
            return [self dateTrigger];
        default:
            break;
    }
    return nil;
}

- (UNTimeIntervalNotificationTrigger *)intervalTrigger
{
    return [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
}

- (UNCalendarNotificationTrigger *)dateTrigger
{
    /* Если мы хотим сделать повторяющийся пуш каждый день в одно время, в dateComponents
     должны быть только часы/минуты/секунды */
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:3600];
    NSDateComponents *triggerDate = [[NSCalendar currentCalendar]
                                     components:NSCalendarUnitYear +
                                     NSCalendarUnitMonth + NSCalendarUnitDay +
                                     NSCalendarUnitHour + NSCalendarUnitMinute +
                                     NSCalendarUnitSecond fromDate:date];
    
    return [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:triggerDate repeats:NO];
}

- (UNLocationNotificationTrigger *)locationTrigger
{
    /*
     // Создаем или получаем CLRegion и заводим триггер
     return [UNLocationNotificationTrigger triggerWithRegion:region repeats:NO];
     */
    return nil;
}


#pragma mark - ContentType

- (NSInteger)giveNewBadgeNumber
{
    return [UIApplication sharedApplication].applicationIconBadgeNumber;
}

- (UNNotificationAttachment *)imageAttachment
{
    // Загружаем, нельзя использовать asserts
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"sberCat" withExtension:@"png"];
    NSError *error;
    UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"pushImage" URL:fileURL options:nil error:&error];
    
    return attachment;
}


#pragma mark - Categories

- (void)addCustomActions
{
    // Создаем кастомные action'ы
    UNNotificationAction *checkAction = [UNNotificationAction actionWithIdentifier:@"CheckID"
                                                                             title:@"Чо кого" options:UNNotificationActionOptionNone];
    UNNotificationAction *deleteAction = [UNNotificationAction actionWithIdentifier:@"DeleteID"
                                                                              title:@"Удалить" options:UNNotificationActionOptionDestructive];
    
    // Создаем кастомную категорию
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:identifierForActions actions:@[checkAction,deleteAction] intentIdentifiers:@[] options:UNNotificationCategoryOptionNone];
    NSSet *categories = [NSSet setWithObject:category];
    
    // Устанавливаем ее для notificationCenter
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center setNotificationCategories:categories];
}

@end
