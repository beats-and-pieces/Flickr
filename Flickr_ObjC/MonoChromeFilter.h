//
//  MonoChromeFilter.h
//  Flickr_ObjC
//
//  Created by Anton Kuznetsov on 19/04/2019.
//  Copyright © 2019 Anton Kuznetsov. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface MonoChromeFilter : NSObject

+ (UIImage *) applyMonoChromeWithRandColor: (UIImage *)uIImage;
+ (UIImage *) applyMonoChromeWithRandColor: (UIImage *)uIImage withIntensity:(double)intensity;

+ (UIImage *) applyFilterForImage: (UIImage *)uIImage withType:(NSString *)filterName withIntensity:(double)intensity;

@end
