//
//  PhotoViewController.m
//  Flickr_ObjC
//
//  Created by Anton Kuznetsov on 15/04/2019.
//  Copyright © 2019 Anton Kuznetsov. All rights reserved.
//

#import "PhotoViewController.h"
#import "PhotoView.h"
#import "FilterService.h"

@interface PhotoViewController () 

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    self.navigationItem.title = self.photoName;
    self.view.backgroundColor = UIColor.grayColor;
}

- (void)setupUI
{
    self.photoView = [[PhotoView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.photoView];
    self.photoView.nameLabel.text = self.photoName;
    self.photoView.delegate = self;
    self.photoView.imageView.image = self.image;
}

#pragma mark - PhotoViewProtocol

- (void)applyFilters
{
    self.photoView.imageView.image = [FilterService applyFilterForImage:[FilterService applyFilterForImage:self.image withType:@"CIBloom" withIntensity:self.sliderOneValue] withType:@"CISepiaTone" withIntensity:self.sliderTwoValue];
}

@end
