//
//  PhotoView.m
//  Flickr_ObjC
//
//  Created by Anton Kuznetsov on 15/04/2019.
//  Copyright © 2019 Anton Kuznetsov. All rights reserved.
//

#import "PhotoView.h"

@interface PhotoView ()

@end

@implementation PhotoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat elementHeight = 30.0;
        CGFloat sliderLeftRightOffset = 32.0;
        self.imageView = [[UIImageView alloc]init];
        self.imageView.frame = CGRectMake(8, 8, frame.size.width - 16, frame.size.height - elementHeight * 6);
        self.imageView.backgroundColor = [UIColor clearColor];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, frame.size.height - elementHeight, frame.size.width - 16, elementHeight)];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.textColor = [UIColor blueColor];
        self.nameLabel.text = @"Test";
        
        self.filterOneName = [[UILabel alloc]initWithFrame:CGRectMake(8, frame.size.height - elementHeight * 6, frame.size.width - 16, elementHeight)];
        self.filterOneName.textAlignment = NSTextAlignmentCenter;
        self.filterOneName.textColor = [UIColor blueColor];
        self.filterOneName.text = @"Sepia Filter Intensity";
        
        self.filterTwoName = [[UILabel alloc]initWithFrame:CGRectMake(8, frame.size.height - elementHeight * 4, frame.size.width - 16, elementHeight * 2)];
        self.filterTwoName.textAlignment = NSTextAlignmentCenter;
        self.filterTwoName.textColor = [UIColor blueColor];
        self.filterTwoName.text = @"Bloom Filter Intensity";
        
        
        self.filterOneIntensitySlider = [[UISlider alloc] initWithFrame:CGRectMake(sliderLeftRightOffset, frame.size.height - elementHeight * 2, self.bounds.size.width - sliderLeftRightOffset * 2, elementHeight)];
        [self.filterOneIntensitySlider addTarget:self action:@selector(sliderOneAction:) forControlEvents:UIControlEventValueChanged];
        [self.filterOneIntensitySlider setBackgroundColor:[UIColor clearColor]];

        self.filterOneIntensitySlider.value = 0.0;

        self.filterTwoIntensitySlider = [[UISlider alloc] initWithFrame:CGRectMake(sliderLeftRightOffset, frame.size.height - elementHeight * 5, self.bounds.size.width - sliderLeftRightOffset * 2, elementHeight)];
        [self.filterTwoIntensitySlider addTarget:self action:@selector(sliderTwoAction:) forControlEvents:UIControlEventValueChanged];
        [self.filterTwoIntensitySlider setBackgroundColor:[UIColor clearColor]];
        
        self.filterOneIntensitySlider.value = 0.0;

        [self addSubview:self.imageView];

        [self addSubview:self.filterOneName];
        [self addSubview:self.filterTwoName];
        [self addSubview:self.filterOneIntensitySlider];
        [self addSubview:self.filterTwoIntensitySlider];

    }
    return self;
}

-(void)sliderOneAction:(id)sender
{
    UISlider *slider = (UISlider*)sender;
    float value = slider.value;
    self.delegate.sliderOneValue = value;
    [self.delegate applyFilters];
}

-(void)sliderTwoAction:(id)sender
{
    UISlider *slider = (UISlider*)sender;
    float value = slider.value;
    self.delegate.sliderTwoValue = value;
    [self.delegate applyFilters];
}

@end
