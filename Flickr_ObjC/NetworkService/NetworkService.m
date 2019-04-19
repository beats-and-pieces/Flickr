//
//  SomeService.m
//  ProtocolsTest
//
//  Created by Alexey Levanov on 30.11.17.
//  Copyright © 2017 Alexey Levanov. All rights reserved.
//

#import "NetworkService.h"
#import "NetworkHelper.h"
#import<UIKit/UIKit.h>
//#import <UI


@interface NetworkService ()

@property (nonatomic, strong) NSURLSession *urlSession;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, strong) NSData *resumeData;

@end

@implementation NetworkService

- (void)configureUrlSessionWithParams:(NSDictionary *)params
{
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // Настравиваем Session Configuration
    [sessionConfiguration setAllowsCellularAccess:YES];
    if (params)
    {
        [sessionConfiguration setHTTPAdditionalHeaders:params];//@{ @"Accept" : @"application/json" }];
    }
    else
    {
        [sessionConfiguration setHTTPAdditionalHeaders:@{ @"Accept" : @"application/json" }];
    }
    
    // Создаем сессию
    self.urlSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
}

- (void)startImageLoading
{
    if (!self.urlSession)
    {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.urlSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    }
    self.downloadTask = [self.urlSession downloadTaskWithURL:[NSURL URLWithString:@"https://upload.wikimedia.org/wikipedia/commons/4/4e/Pleiades_large.jpg"]];
    /* http://is1.mzstatic.com/image/thumb/Purple2/v4/91/59/e1/9159e1b3-f67c-6c05-0324-d56f4aee156a/source/100x100bb.jpg */
    [self.downloadTask resume];
}

- (NSURLSession *)createSessionForAnURLString:(NSString *)urlString
{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString: urlString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:15];
    
    NSURLSession *session;
    session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    return session;
}
- (void)downloadPhototFromUrl:(NSString *)urlString
{
    //    NSString *urlString = [NetworkHelper URLForSearchString:searchSrting];
    //    NSURLSession *session = [self createSessionForAnURLString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString: urlString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:15];
    
    NSURLSession *session;
    session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error)
        {
            UIImage *image = [UIImage imageWithData:data];
            
        }
        else
        {
            NSLog(@"Error occured!");
        }
    }];
//    [sessionDataTask resume];
    
    
//    NSString *strImgURLAsString = @"imageURL";
//    [strImgURLAsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *imgURL = [NSURL URLWithString:urlString];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:imgURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            UIImage *img = [[UIImage alloc] initWithData:data];
            // pass the img to your imageview
        }else{
            NSLog(@"%@",connectionError);
        }
    }];
}

- (void)findFlickrPhotoWithSearchString:(NSString *)searchSrting
{
    NSString *urlString = [NetworkHelper URLForSearchString:searchSrting];
    //    NSURLSession *session = [self createSessionForAnURLString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString: urlString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:15];
    
    NSURLSession *session;
    session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error)
        {
            NSDictionary *JSONResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            
            NSArray *photos = [[JSONResponse valueForKey:@"photos"] valueForKey:@"photo"];
            NSLog(@"kool %@", photos);
            // Для получение деталей по фото
            // https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}.jpg
            // example https://farm1.staticflickr.com/2/1418878_1e92283336_m.jpg
            NSMutableArray *processedPhotos = [photos copy];
//            NSString *urlString = [NetworkHelper URLForPhoto:processedPhotos[0]];
//            NSLog(@"kool %@", urlString);
//             [self downloadPhototFromUrl:urlString];
            for (NSDictionary *currentPhoto in processedPhotos)
            {
                NSString *urlString = [NetworkHelper URLForPhoto:currentPhoto];
                NSLog(@"kool %@", urlString);
//                [self downloadPhototFromUrl:urlString];
                //                NSMutableDictionary *temp = [currentPhoto copy];
                //                [temp setObject:urlString forKey:@"url"];
                //                uiima
                //                currentPhoto
            }
            photos = [processedPhotos copy];
            //                    self.output.photos = photos;
            [self.output loadingIsDoneWithDataRecieved:processedPhotos];
            dispatch_async(dispatch_get_main_queue(), ^{
                // Отсюда отправим сообщение на обновление UI с главного потока
            });
        }
        else
        {
            NSLog(@"Error occured!");
        }
    }];
    [sessionDataTask resume];
}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    //    NSData *data = [NSData dataWithContentsOfURL:location];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //        [self.output loadingIsDoneWithDataRecieved:data];
    });
    [session finishTasksAndInvalidate];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    double progress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.output loadingContinuesWithProgress:progress];
    });
}

@end

