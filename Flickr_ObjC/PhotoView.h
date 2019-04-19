//
//  PhotoView.h
//  Flickr_ObjC
//
//  Created by Anton Kuznetsov on 15/04/2019.
//  Copyright © 2019 Anton Kuznetsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface PhotoView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *filterOneName;
@property (nonatomic, strong) UILabel *filterTwoName;

@property (nonatomic, strong) UISlider *filterTwoIntensitySlider;
@property (nonatomic, strong) UISlider *filterOneIntensitySlider;

@property (nonatomic, weak, nullable) id<PhotoViewProtocol> delegate;

@end

NS_ASSUME_NONNULL_END
