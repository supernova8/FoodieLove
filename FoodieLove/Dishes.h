//
//  Dishes.h
//  FoodieLove
//
//  Created by Sonova Middleton on 6/29/15.
//  Copyright (c) 2015 supernova8productions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Dishes : NSManagedObject

@property (nonatomic, retain) NSString * dishName;
@property (nonatomic, retain) NSNumber * dishRating;
@property (nonatomic, retain) NSString * dishImageFileName;
@property (nonatomic, retain) NSDate * dateEntered;
@property (nonatomic, retain) NSDate * dateUpdated;
@property (nonatomic, retain) NSString * dishType;

@end
