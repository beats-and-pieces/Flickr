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
        
        self.imageView = [[UIImageView alloc]init];
        self.imageView.frame = CGRectMake(8, 8, frame.size.width - 16, frame.size.height - 30);
        self.imageView.backgroundColor = [UIColor grayColor];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, frame.size.height - 30, frame.size.width - 16, 30)];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.textColor = [UIColor blueColor];
        self.nameLabel.text = @"Test";
        
        
        [self addSubview:self.imageView];
        [self addSubview:self.nameLabel];
        
        //        self.viewForBaselineLayout.layer.masksToBounds = YES;
        //        self.viewForBaselineLayout.layer.cornerRadius = 8.0f;
    }
    return self;
}

@end
