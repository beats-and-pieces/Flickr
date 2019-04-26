//
//  SearchViewController.m
//  Flickr_ObjC
//
//  Created by Anton Kuznetsov on 14/04/2019.
//  Copyright © 2019 Anton Kuznetsov. All rights reserved.
//

#import "SearchViewController.h"
#import "FlickrCollectionViewCell.h"
#import "PhotoViewController.h"
#import "NetworkHelper.h"
#import "PushService.h"

@interface SearchViewController () <NetworkServiceOutputProtocol, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, strong) NSString *searchString;

@end
@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUISearchBar];
    [self setupUICollectionView];

    self.navigationItem.title = @"Flickr Search";
    
    self.networkService = [NetworkService new];
    self.networkService.output = self;
    [self.networkService configureUrlSessionWithParams:nil];
    [self.networkService findFlickrPhotoWithSearchString:@""];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

#pragma mark - NetworkServiceOutputProtocol
- (void)loadingIsDoneWithDataRecieved:(NSArray *)dataRecieved
{
    self.photos = dataRecieved;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

- (void)imageIsLoadedForUrl:(NSString *)url withDataReceived:(NSData *)dataReceived
{
    
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.searchString = searchText;
    [self performSelector:@selector(sendSearchRequest) withObject:searchText afterDelay:0.4f];
}

- (void)sendSearchRequest
{
    [self.networkService findFlickrPhotoWithSearchString:self.searchString];
}

- (void)setupUISearchBar
{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 20 + self.navigationController.navigationBar.bounds.size.height, self.view.bounds.size.width, 44)];
    self.searchBar.backgroundColor = [UIColor blueColor];
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
}

- (void)setupUICollectionView
{
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64 + self.navigationController.navigationBar.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - 64 - self.navigationController.navigationBar.bounds.size.height) collectionViewLayout:layout];
    layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    
    [self.collectionView registerClass:[FlickrCollectionViewCell class] forCellWithReuseIdentifier:@"FlickrCollectionViewCell"];
    [self.collectionView setBackgroundColor:[UIColor colorWithRed: 143.0/255.0 green:174.0/255 blue:224.0/255 alpha: 1.0]];
    
    [self.view addSubview:self.collectionView];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.photos == nil)
    {
        return 0;
    }
    else
    {
        return self.photos.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FlickrCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FlickrCollectionViewCell" forIndexPath:indexPath];
    cell.nameLabel.text = [self.photos[indexPath.row] valueForKey:@"title"];
    cell.imageView.image = [UIImage imageNamed:@"placeholder.png"];
    NSURLRequest *request = [self.networkService createNSURLrequestFromUrl:[NetworkHelper URLForPhoto:self.photos[indexPath.row]]];

    NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
    if (cachedResponse.data) {
        UIImage *downloadedImage = [UIImage imageWithData:cachedResponse.data];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.imageView.image = downloadedImage;
        });
    } else {
        
        NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                  
                                  {
                                      if (data) {
                                          UIImage *image = [UIImage imageWithData:data];
                                          if (image) {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  FlickrCollectionViewCell *updateCell = (id)[self.collectionView cellForItemAtIndexPath:indexPath];
                                                  if (updateCell)
                                                      updateCell.imageView.image = image;
                                              });
                                          }
                                      } else
                                      {
                                          NSLog(@"couldn't get");
                                      }
                                  }];
        [task resume];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.view.bounds.size.width - 3 * 15 ) / 2, (self.view.bounds.size.width - 3 * 15 ) / 2);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    PhotoViewController *photoViewController = [[PhotoViewController alloc] init];
    photoViewController.photoName = [self.photos[indexPath.row] valueForKey:@"title"];
    FlickrCollectionViewCell *cell = (FlickrCollectionViewCell *)[self.collectionView cellForItemAtIndexPath: indexPath];
    photoViewController.image = cell.imageView.image;
    [self.navigationController pushViewController:photoViewController animated:YES];
}

@end
