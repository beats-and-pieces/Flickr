//
//  FlickrCollectionViewCell.m
//  Flickr_ObjC
//
//  Created by Anton Kuznetsov on 15/04/2019.
//  Copyright © 2019 Anton Kuznetsov. All rights reserved.
//

#import "FlickrCollectionViewCell.h"

@interface FlickrCollectionViewCell ()

//@property (nonatomic, strong) UIImageView *imageView;
//@property (nonatomic, strong) UILabel *nameLabel;
//

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
        
        self.backgroundColor = [UIColor greenColor];
    
        [self addSubview:_imageView];
        [self addSubview:_nameLabel];
       
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 8.0f;
    }
    return self;
}





@end
