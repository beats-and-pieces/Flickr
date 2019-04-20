//
//  SearchViewController.h
//  Flickr_ObjC
//
//  Created by Anton Kuznetsov on 14/04/2019.
//  Copyright © 2019 Anton Kuznetsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkService/NetworkService.h"

@interface SearchViewController : UIViewController <NSURLSessionDelegate, NSURLSessionDownloadDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NetworkService *networkService;

@end

