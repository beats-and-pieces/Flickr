//
//  SearchViewController.m
//  Flickr_ObjC
//
//  Created by Anton Kuznetsov on 14/04/2019.
//  Copyright © 2019 Anton Kuznetsov. All rights reserved.
//

#import "SearchViewController.h"
//#import "NetworkService.h"
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
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

- (void)loadingIsDoneWithDataRecieved:(NSArray *)dataRecieved
{
    self.photos = dataRecieved;
//    NSLog(@"count %lu", (unsigned long)self.photos.count);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

- (void)imageIsLoadedForUrl:(NSString *)url withDataReceived:(NSData *)dataReceived
{
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.searchString = searchText;
    [self performSelector:@selector(sendSearchRequest) withObject:searchText afterDelay:0.4f];
}

- (void)sendSearchRequest
{
    //    self perfse
//    NSLog(@"serach text, %@", self.searchString);
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
    
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    
    [self.collectionView registerClass:[FlickrCollectionViewCell class] forCellWithReuseIdentifier:@"FlickrCollectionViewCell"];
    [self.collectionView setBackgroundColor:[UIColor redColor]];
    
    [self.view addSubview:self.collectionView];
//    UICollectionViewFlowLayout *aFlowLayout = [[UICollectionViewFlowLayout alloc] init];
//    [aFlowLayout setSectionInset:UIEdgeInsetsMake(top, left, bottom, right)];
    layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
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
    
    [self fillCellForARow:cell indexPath:indexPath];
    return cell;
}

- (FlickrCollectionViewCell *)fillCellForARow:(FlickrCollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    cell.nameLabel.text = [self.photos[indexPath.row] valueForKey:@"title"];
    cell.imageView.image = [UIImage imageNamed:@"placeholder.png"];
    NSURLRequest *request = [self.networkService createNSURLrequestFromUrl:[NetworkHelper URLForPhoto:self.photos[indexPath.row]]];

    NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
    if (cachedResponse.data) {
        UIImage *downloadedImage = [UIImage imageWithData:cachedResponse.data];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.imageView.image = downloadedImage;
//            cell.imageView.asso
            [cell.activityIndicator stopAnimating];
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
                                                  [cell.activityIndicator stopAnimating];
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
//    NSLog(@"cell #%ld tapped", (long)indexPath.row);
    //    collectionView.cell
    [self openPhotoAtIndexPath:indexPath];
}

- (void)openPhotoAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoViewController *photoViewController = [[PhotoViewController alloc] init];
    photoViewController.photoName = [self.photos[indexPath.row] valueForKey:@"title"];
    FlickrCollectionViewCell *cell = (FlickrCollectionViewCell *)[self.collectionView cellForItemAtIndexPath: indexPath];
    photoViewController.image = cell.imageView.image;
    //    photoViewController.image = [UIImage imageNamed:@"placeholder.png"];
    
    [self.navigationController pushViewController:photoViewController animated:YES];
}



#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSData *data = [NSData dataWithContentsOfURL:location];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //        [self.output loadingIsDoneWithDataRecieved:data];
    });
    [session finishTasksAndInvalidate];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    double progress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
    dispatch_async(dispatch_get_main_queue(), ^{
        //        [self.output loadingContinuesWithProgress:progress];
    });
}

@end
