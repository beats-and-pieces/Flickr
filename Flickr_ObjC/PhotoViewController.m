//
//  PhotoViewController.m
//  Flickr_ObjC
//
//  Created by Anton Kuznetsov on 15/04/2019.
//  Copyright © 2019 Anton Kuznetsov. All rights reserved.
//

#import "PhotoViewController.h"
#import "PhotoView.h"
#import "MonoChromeFilter.h"

@interface PhotoViewController () 



//@property (nonatomic, strong) PhotoView *photoView;

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    self.navigationItem.title = self.photoName;
    self.view.backgroundColor = UIColor.grayColor;
    //    self.photoView.imageView.image
    // Do any additional setup after loading the view.
}

- (void)setupUI
{
    self.photoView = [[PhotoView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.photoView];
    self.photoView.nameLabel.text = self.photoName;
    self.photoView.delegate = self;
    self.photoView.imageView.image = self.image;
    //    [self.view bringSubviewToFront:self.photoView];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


#pragma mark - NSURLSessionDelegate
- (void)applyFilterOneIntensity
{
    self.photoView.imageView.image = [MonoChromeFilter applyFilterForImage:self.image withType:@"CIBloom" withIntensity:self.sliderOneValue];
//    self.photoView.imageView.image = self.image;
}
- (void)applyFilterTwoIntensity
{
    
  
 self.photoView.imageView.image = [MonoChromeFilter applyFilterForImage:self.image withType:@"CISepiaTone" withIntensity:self.sliderTwoValue];
}

@end
