//
//  SearchCollectionViewCell.h
//  FavoritePhotos
//
//  Created by Calvin Hildreth on 3/31/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UIButton *addToFavoriteButton;
@property (strong, nonatomic) NSString* idString;
@property (strong, nonatomic) NSData* photoImageData;

@end
