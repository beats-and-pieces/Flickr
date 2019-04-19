//
//  PhotoViewController.m
//  Flickr_ObjC
//
//  Created by Anton Kuznetsov on 15/04/2019.
//  Copyright © 2019 Anton Kuznetsov. All rights reserved.
//

#import "PhotoViewController.h"
#import "PhotoView.h"

@interface PhotoViewController ()

//@property (nonatomic, strong) PhotoView *photoView;

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    // Do any additional setup after loading the view.
}

- (void)setupUI
{
    self.photoView = [[PhotoView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.photoView];
    self.photoView.nameLabel.text = self.photoName;
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

@end
