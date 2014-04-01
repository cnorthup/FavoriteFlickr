//
//  ProjectTabBarController.m
//  FavoritePhotos
//
//  Created by Calvin Hildreth on 3/31/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//

#import "ProjectTabBarController.h"
#import "SearchViewController.h"
#import "FavoritesViewController.h"

@interface ProjectTabBarController ()

@property FavoritesViewController *favoritesViewController;
@property SearchViewController *searchViewController;

@end

@implementation ProjectTabBarController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.favoritesViewController = [self.viewControllers[0] viewControllers][0];
    self.searchViewController = [self.viewControllers[1] viewControllers][0];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    if (UIInterfaceOrientationIsLandscape(fromInterfaceOrientation))
    {
        self.favoritesViewController.favoriteCollectionViewFlowLayout.itemSize = CGSizeMake(260, 260);
        self.favoritesViewController.favoriteCollectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.searchViewController.searchCollectionViewFlowLayout.itemSize = CGSizeMake(260, 260);
        self.searchViewController.searchCollectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    else
    {
        self.favoritesViewController.favoriteCollectionViewFlowLayout.itemSize = CGSizeMake(200, 200);
        self.favoritesViewController.favoriteCollectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.searchViewController.searchCollectionViewFlowLayout.itemSize = CGSizeMake(200, 200);
        self.searchViewController.searchCollectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    [self.favoritesViewController.favoritesCollectionView reloadData];
    [self.favoritesViewController updateViewConstraints];
    [self.searchViewController.searchCollectionView reloadData];
    [self.searchViewController updateViewConstraints];

}

@end
