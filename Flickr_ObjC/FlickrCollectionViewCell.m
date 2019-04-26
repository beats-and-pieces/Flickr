//
//  FlickrCollectionViewCell.m
//  Flickr_ObjC
//
//  Created by Anton Kuznetsov on 15/04/2019.
//  Copyright © 2019 Anton Kuznetsov. All rights reserved.
//

#import "FlickrCollectionViewCell.h"

@interface FlickrCollectionViewCell ()

@end

@implementation FlickrCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _imageView = [[UIImageView alloc]init];
        _imageView.frame = CGRectMake(8, 8, frame.size.width - 16, frame.size.height - 30);
        
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.layer.masksToBounds = YES;
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, frame.size.height - 30, frame.size.width - 16, 30)];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.text = @"Test";
        
        self.backgroundColor = [UIColor colorWithRed:110.0/255 green:145.0/255 blue:201.0/255 alpha: 1.0];
    
        [self addSubview:_imageView];
        [self addSubview:_nameLabel];
    
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 8.0f;
    }
    return self;
}





@end
