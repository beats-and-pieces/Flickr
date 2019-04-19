//
//
//  SettingsViewDelegate.h
//  PingPong
//
//  Created by Anton Kuznetsov on 17/04/2019.
//  Copyright © 2019 Anton Kuznetsov. All rights reserved.
//



@protocol PhotoViewProtocol <NSObject>

@property (assign, nonatomic) double sliderOneValue;
@property (assign, nonatomic) double sliderTwoValue;

- (void)applyFilterOneIntensity;
- (void)applyFilterTwoIntensity;

@end
