//
//  BorderShadowRoundedImageView.h
//  FoodieLove
//
//  Created by Sonova Middleton on 7/23/15.
//  Copyright (c) 2015 supernova8productions. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface BorderShadowRoundedImageView : UIImageView

@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable NSInteger borderWidth;
@property (nonatomic) IBInspectable NSInteger cornerRadius;
@property (nonatomic) IBInspectable float opacity;
@property (nonatomic) IBInspectable CGFloat shadowRadius;
@property (nonatomic) IBInspectable CGFloat shadowOpacity;
@property (nonatomic) IBInspectable CGSize shadowOffset;
@property (nonatomic) IBInspectable UIColor *shadowColor;

@end
