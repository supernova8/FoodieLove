//
//  DishCollectionViewCell.h
//  FoodieLove
//
//  Created by Sonova Middleton on 6/30/15.
//  Copyright (c) 2015 supernova8productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DishCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UILabel *dishNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *dishRankingLabel;
@property (nonatomic, strong) IBOutlet UIImageView *dishImageView;

@end
