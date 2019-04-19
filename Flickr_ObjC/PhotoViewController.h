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

@interface PhotoViewController : UIViewController

@property (nonatomic, strong) PhotoView *photoView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *photoName;

@end

NS_ASSUME_NONNULL_END
