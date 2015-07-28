//
//  DishCollectionViewCell.m
//  FoodieLove
//
//  Created by Sonova Middleton on 6/30/15.
//  Copyright (c) 2015 supernova8productions. All rights reserved.
//

#import "DishCollectionViewCell.h"

@implementation DishCollectionViewCell

-(void)setHighlighted:(BOOL)highlighted
{
    if (highlighted)
    {
        self.layer.opacity = 0.6;
        // Here what do you want.
    }
    else{
        self.layer.opacity = 1.0;
        // Here all change need go back
    }
}

@end
