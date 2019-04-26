//
//  FilterService.m
//  Flickr_ObjC
//
//  Created by Anton Kuznetsov on 19/04/2019.
//  Copyright © 2019 Anton Kuznetsov. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>
#import "FilterService.h"


@implementation FilterService




+ (UIImage *) applyFilterForImage: (UIImage *)uIImage withType:(NSString *)filterName withIntensity:(double)intensity
{
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *ciImage = [[CIImage alloc] initWithImage:uIImage];
    CIFilter *filter = [CIFilter filterWithName:filterName];
    [filter setValue:ciImage forKey:kCIInputImageKey];
    [filter setValue:@(intensity) forKey:@"inputIntensity"];
    if ([filterName isEqual: @"CIBloom"])
    {
        [filter setValue:@10 forKey:kCIInputRadiusKey];
    }

    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGRect extent = [result extent];
    CGImageRef cgImage = [context createCGImage:result fromRect:extent];
    UIImage *filteredImage = [[UIImage alloc] initWithCGImage:cgImage];
    
    return filteredImage;
}

@end
