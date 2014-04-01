//
//  FavoritesViewController.h
//  FavoritePhotos
//
//  Created by Calvin Hildreth on 3/31/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoritesViewController : UIViewController

@property (strong, nonatomic) IBOutlet UICollectionView *favoritesCollectionView;
@property (strong, nonatomic) IBOutlet UICollectionViewFlowLayout *favoriteCollectionViewFlowLayout;

@end
