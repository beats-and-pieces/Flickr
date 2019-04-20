//
//  FilterService.h
//  Flickr_ObjC
//
//  Created by Anton Kuznetsov on 19/04/2019.
//  Copyright © 2019 Anton Kuznetsov. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface FilterService : NSObject

+ (UIImage *) applyFilterForImage: (UIImage *)uIImage withType:(NSString *)filterName withIntensity:(double)intensity;

@end
