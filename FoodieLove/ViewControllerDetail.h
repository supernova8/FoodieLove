//
//  ViewControllerDetail.h
//  FoodieLove
//
//  Created by Sonova Middleton on 6/30/15.
//  Copyright (c) 2015 supernova8productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dishes.h"

@interface ViewControllerDetail : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic,strong) Dishes *currentDish;
@property (nonatomic, weak) IBOutlet UITextField *dishNameTextField;

@end
