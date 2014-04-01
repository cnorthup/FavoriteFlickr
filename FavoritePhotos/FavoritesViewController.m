//
//  FavoritesViewController.m
//  FavoritePhotos
//
//  Created by Calvin Hildreth on 3/31/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//

#import "FavoritesViewController.h"
#import "SearchCollectionViewCell.h"

@interface FavoritesViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSMutableArray *savedToFavoritesArray;


@end

@implementation FavoritesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self load];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.savedToFavoritesArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FavoriteCellID" forIndexPath:indexPath];
    cell.image.image = [UIImage imageWithData:self.savedToFavoritesArray[indexPath.row]];

    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(NSURL *)documentsDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *directories = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    return directories.firstObject;
}

-(IBAction)delete:(id)sender
{
    NSURL* plist = [[self documentsDirectory] URLByAppendingPathComponent:@"favoriteimages.plist"];
    [self.savedToFavoritesArray writeToURL:plist atomically:YES];
}

-(void)load
{
    NSURL* plist = [[self documentsDirectory] URLByAppendingPathComponent:@"favoriteimages.plist"];
    if (!self.savedToFavoritesArray)
    {
        self.savedToFavoritesArray = [NSMutableArray new];
    }
    self.savedToFavoritesArray = [NSMutableArray arrayWithContentsOfURL:plist];
    [self.favoritesCollectionView reloadData];
}
@end
