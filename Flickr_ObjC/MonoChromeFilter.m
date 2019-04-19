//
//  MonoChromeFilter.m
//  Flickr_ObjC
//
//  Created by Anton Kuznetsov on 19/04/2019.
//  Copyright © 2019 Anton Kuznetsov. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>
//#import "UIColor+CustomColorCategory.h"
#import "MonoChromeFilter.h"


@implementation MonoChromeFilter

+ (UIImage *) applyMonoChromeWithRandColor: (UIImage *)uIImage
{
    
    //  Convert UIColor to CIColor
    CGColorRef colorRef = [UIColor redColor].CGColor;
    NSString *colorString = [CIColor colorWithCGColor:colorRef].stringRepresentation;
    CIColor *coreColor = [CIColor colorWithString:colorString];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    //  Convert UIImage to CIImage
    CIImage *ciImage = [[CIImage alloc] initWithImage:uIImage];
    
    //  Set values for CIColorMonochrome Filter
    CIFilter *filter = [CIFilter filterWithName:@"CIColorMonochrome"];
    [filter setValue:ciImage forKey:kCIInputImageKey];
    [filter setValue:@1.0 forKey:@"inputIntensity"];
    [filter setValue:coreColor forKey:@"inputColor"];
    
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    CGRect extent = [result extent];
    
    CGImageRef cgImage = [context createCGImage:result fromRect:extent];
    
    UIImage *filteredImage = [[UIImage alloc] initWithCGImage:cgImage];
    
    return filteredImage;
}



+ (UIImage *) applyFilterForImage: (UIImage *)uIImage withType:(NSString *)filterName withIntensity:(double)intensity
{
    //  Convert UIColor to CIColor
    CGColorRef colorRef = [UIColor redColor].CGColor;
    NSString *colorString = [CIColor colorWithCGColor:colorRef].stringRepresentation;
    CIColor *coreColor = [CIColor colorWithString:colorString];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    //  Convert UIImage to CIImage
    CIImage *ciImage = [[CIImage alloc] initWithImage:uIImage];
    
    //  Set values for CIColorMonochrome Filter
    CIFilter *filter = [CIFilter filterWithName:filterName];
    [filter setValue:ciImage forKey:kCIInputImageKey];
    [filter setValue:@(intensity) forKey:@"inputIntensity"];
    if ([filterName isEqual: @"CIBloom"])
    {
        [filter setValue:@0.5 forKey:kCIInputRadiusKey];
        
    }

   
    
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    CGRect extent = [result extent];
    
    CGImageRef cgImage = [context createCGImage:result fromRect:extent];
    
    UIImage *filteredImage = [[UIImage alloc] initWithCGImage:cgImage];
    
    return filteredImage;
}


+ (UIImage *) applyMonoChromeWithRandColor: (UIImage *)uIImage withIntensity:(double)intensity;
{
    
    //  Convert UIColor to CIColor
    CGColorRef colorRef = [UIColor redColor].CGColor;
    NSString *colorString = [CIColor colorWithCGColor:colorRef].stringRepresentation;
    CIColor *coreColor = [CIColor colorWithString:colorString];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    //  Convert UIImage to CIImage
    CIImage *ciImage = [[CIImage alloc] initWithImage:uIImage];
    
    //  Set values for CIColorMonochrome Filter
    CIFilter *filter = [CIFilter filterWithName:@"CIColorMonochrome"];
    [filter setValue:ciImage forKey:kCIInputImageKey];
    [filter setValue:@(intensity) forKey:@"inputIntensity"];
    [filter setValue:coreColor forKey:@"inputColor"];
    
    
    
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    CGRect extent = [result extent];
    
    CGImageRef cgImage = [context createCGImage:result fromRect:extent];
    
    UIImage *filteredImage = [[UIImage alloc] initWithCGImage:cgImage];
    
    return filteredImage;
}

@end
