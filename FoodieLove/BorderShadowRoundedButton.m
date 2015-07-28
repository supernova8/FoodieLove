//
//  BorderShadowRoundedButton.m
//  FoodieLove
//
//  Created by Sonova Middleton on 7/24/15.
//  Copyright (c) 2015 supernova8productions. All rights reserved.
//

#import "BorderShadowRoundedButton.h"

@implementation BorderShadowRoundedButton

@dynamic borderColor,borderWidth,cornerRadius, opacity, shadowOpacity, shadowColor, shadowOffset, shadowRadius ;

-(void)setBorderColor:(UIColor *)borderColor
{
    [self.layer setBorderColor:borderColor.CGColor];
}

-(void)setBorderWidth:(NSInteger)borderWidth
{
    [self.layer setBorderWidth:borderWidth];
}

-(void)setCornerRadius:(NSInteger)cornerRadius
{
    [self.layer setCornerRadius:cornerRadius];
    if (cornerRadius > 0) {
        [self.layer setMasksToBounds:true];
    } else {
        [self.layer setMasksToBounds:false];
    }
}

-(void)setOpacity:(float)opacity
{
    [self.layer setOpacity:opacity];
}

-(void) setShadowColor:(UIColor *)shadowColor
{
    [self.layer setShadowColor:shadowColor.CGColor];
}
-(void) setShadowOpacity:(CGFloat)shadowOpacity
{
    [self.layer setShadowOpacity:shadowOpacity];
}
-(void) setShadowOffset:(CGSize)shadowOffset
{
    [self.layer setShadowOffset:shadowOffset];
}

-(void) setShadowRadius:(CGFloat)shadowRadius
{
    [self.layer setShadowRadius:shadowRadius];
}


@end

