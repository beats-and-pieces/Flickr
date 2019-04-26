//
//  NetworkHelper.m
//  NSUrlRequestProject
//
//  Created by Alexey Levanov on 30.11.17.
//  Copyright © 2017 Alexey Levanov. All rights reserved.
//

#import "NetworkHelper.h"

@implementation NetworkHelper

+ (NSString *)URLForSearchString:(NSString *)searchString
{
    NSString *APIKey = @"fa328b6dbd6c76dd306ea51360e2a548";
    return [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&per_page=100&format=json&nojsoncallback=1", APIKey, searchString];
}

+ (NSString *)URLForPhoto:(NSDictionary *)photo
{
    NSString *farm = [photo valueForKey:@"farm"];
    NSString *server = [photo valueForKey:@"server"];
    NSString *i_d = [photo valueForKey:@"id"];
    NSString *secret = [photo valueForKey:@"secret"];

    return [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@_z.jpg", farm, server, i_d, secret];
}

@end
