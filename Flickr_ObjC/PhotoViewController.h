//
//  PhotoViewController.h
//  Flickr_ObjC
//
//  Created by Anton Kuznetsov on 15/04/2019.
//  Copyright © 2019 Anton Kuznetsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoView.h"


NS_ASSUME_NONNULL_BEGIN

@interface PhotoViewController : UIViewController <PhotoViewProtocol>

@property (nonatomic, strong) PhotoView *photoView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *editedImage;
@property (nonatomic, strong) NSString *photoName;

@property (assign, nonatomic) double sliderOneValue;
@property (assign, nonatomic) double sliderTwoValue;



@end

NS_ASSUME_NONNULL_END
