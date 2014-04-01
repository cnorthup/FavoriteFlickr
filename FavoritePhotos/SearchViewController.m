//
//  ViewController.m
//  FavoritePhotos
//
//  Created by Calvin Hildreth on 3/31/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchCollectionViewCell.h"

@interface SearchViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate>

@property NSString *apiKey;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) NSMutableArray *searchResultsPhotos;
@property (strong, nonatomic) NSIndexPath* indexPathForSelectedCell;
@property (strong, nonatomic) NSMutableArray* savedToFavoritesArray;
@property (strong, nonatomic) NSMutableArray* searchResultsPhotoIds;
@property (strong, nonatomic) NSMutableArray* favoritePhotoIds;
@property (strong, nonatomic) NSMutableArray* searchResultsData;


@end

@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.apiKey = @"b08f498717ff8744ce436f0263e0da19";
    self.searchResultsPhotos = [NSMutableArray new];
    self.savedToFavoritesArray = [NSMutableArray new];
    self.searchResultsPhotoIds = [NSMutableArray new];
    self.favoritePhotoIds = [NSMutableArray new];
    self.searchResultsData = [NSMutableArray new];
    self.searchTextField.delegate = self;

}

#pragma mark -- UICollectionview delegate methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.searchResultsPhotos.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SearchCellID" forIndexPath:indexPath];
    cell.image.image = self.searchResultsPhotos[indexPath.row];
    cell.photoImageData = self.searchResultsData[indexPath.row];
    cell.idString = self.searchResultsPhotoIds[indexPath.row];
    if ([self.favoritePhotoIds containsObject:cell.idString])
    {
        [cell.addToFavoriteButton setHidden:YES];
    }
    else
    {
        [cell.addToFavoriteButton setHidden:NO];
    }
    cell.addToFavoriteButton.enabled = NO;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SearchCollectionViewCell *cell = (SearchCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.addToFavoriteButton.enabled = YES;
    self.indexPathForSelectedCell = indexPath;
    
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchCollectionViewCell *cell = (SearchCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.addToFavoriteButton.enabled = NO;
}

#pragma mark -- text field delegate method

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *concatSearch = [self.searchTextField.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    [self searchFlickrPhotos:concatSearch];
    [textField endEditing:YES];
    return YES;
}

#pragma mark -- document mangment

-(NSURL*)documentsDirectory
{
    NSFileManager* fileManger = [NSFileManager defaultManager];
    NSArray* directories = [fileManger URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    return directories.firstObject;
}

-(void)save
{
    NSURL* plist = [[self documentsDirectory] URLByAppendingPathComponent:@"favoriteimages.plist"];
    [self.savedToFavoritesArray writeToURL:plist atomically:YES];
}

-(void)load
{
    NSURL* plist = [[self documentsDirectory] URLByAppendingPathComponent:@"favoriteimages.plist"];
    self.savedToFavoritesArray = [NSMutableArray arrayWithContentsOfURL:plist];
}

#pragma mark -- helper methods

-(void)searchFlickrPhotos:(NSString *)searchParam
{

    NSString *searchString = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&text=%@&sort=relevance&per_page=10&format=json&nojsoncallback=1",
                              self.apiKey,
                              searchParam,
                              searchParam];
    NSURL *searchURL = [NSURL URLWithString:searchString];
    NSURLRequest *searchRequest = [NSURLRequest requestWithURL:searchURL];
    [NSURLConnection sendAsynchronousRequest:searchRequest queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSDictionary *allSearchResults = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
         NSArray *searchResultsPhotosArray = allSearchResults[@"photos"][@"photo"];
         
         for (NSDictionary *photoInfo in searchResultsPhotosArray)
         {
             NSString *photoURLstring = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@.jpg",
                                         [photoInfo[@"farm"] stringValue],
                                         photoInfo[@"server"],
                                         photoInfo[@"id"],
                                         photoInfo[@"secret"]];
             NSURL *photoURL = [NSURL URLWithString:photoURLstring];
             NSData *photoData = [NSData dataWithContentsOfURL:photoURL];
             UIImage *photo = [UIImage imageWithData:photoData];
             [self.searchResultsData addObject:photoData];
             [self.searchResultsPhotos addObject:photo];
             [self.searchResultsPhotoIds addObject:photoInfo[@"id"]];
             
         }
         [self.searchCollectionView reloadData];
     }];
}

- (IBAction)onGoButtonPressed:(id)sender
{
    NSString *concatSearch = [self.searchTextField.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    [self searchFlickrPhotos:concatSearch];
    [self.searchTextField endEditing:YES];
}

- (IBAction)addToFavoriteOnButtonPressed:(id)sender
{
    SearchCollectionViewCell* cell = (SearchCollectionViewCell*)[self.searchCollectionView cellForItemAtIndexPath:self.indexPathForSelectedCell];
    [self.savedToFavoritesArray addObject:cell.photoImageData];
    [self.favoritePhotoIds addObject:cell.idString];
    [cell.addToFavoriteButton setHidden:YES];
    [self save];
}
@end
