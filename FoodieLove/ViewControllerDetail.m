/*
//  ViewControllerDetail.m
//  FoodieLove
//
//  Created by Sonova Middleton on 6/30/15.
//  Copyright (c) 2015 supernova8productions. All rights reserved.
//
//  Categorize and Take Pictures of your Favorite Food Dishes. You can also save the pictures taken to your Camera Roll.
*/

#import "ViewControllerDetail.h"
#import "AppDelegate.h"
#import "UIColor+Gummy.h"

@interface ViewControllerDetail ()

@property (nonatomic,strong) AppDelegate *appDelegate;
@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, weak) IBOutlet UISegmentedControl *dishRatingSegControl;
@property (nonatomic, weak) IBOutlet UISegmentedControl *dishTypeSegControl;

@property (nonatomic, weak) IBOutlet UIImageView *dishImageView;
@property (nonatomic, weak) IBOutlet UIButton *galleryButton;
@property (nonatomic, weak) IBOutlet UIButton *cameraButton;
@property (nonatomic, weak) IBOutlet UIButton *deleteButton;
@property (nonatomic, weak) IBOutlet UISwitch *saveToCameraRollSwitch;





@end




@implementation ViewControllerDetail


#pragma Mark - Interactivity Methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    /* textField here is referenced from
     textFieldShouldReturn:(UITextField *)textField
     */
    return true;
}

- (IBAction)galleryButtonTapped:(id)sender {
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    
    ipc.delegate = self;
    ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    id albumCtrller = ipc.topViewController;
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [ipc pushViewController: albumCtrller animated: NO];
    
    [self presentViewController:ipc animated:true completion:nil];
    
}

- (IBAction)cameraButtonTapped:(id)sender {
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    
    ipc.delegate = self;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        [self presentViewController:ipc animated:true completion:nil];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Camera!"  message:@"Looks like you don't have a camera! :P" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
}

- (UIImage *)scaleAndRotateImage:(UIImage *)image {
    int kMaxResolution = 1280;
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}



- (IBAction)saveButtonPressed:(id)sender {
    
    if ((_dishNameTextField.text && _dishNameTextField.text.length > 1) && (_dishImageView.image)) {
        NSLog(@"Fine to Save");
    
    
    if (_currentDish) {
        NSLog(@"Saving Old Dish");
        NSString *imageFileName = _currentDish.dishImageFileName;
        NSString *newImagePath = [self getDocumentPathForFile:imageFileName];
        NSLog(@"Image Path:%@",newImagePath);
    } else {
        NSLog(@"Saving New Dish");
        _currentDish = (Dishes *)[NSEntityDescription insertNewObjectForEntityForName:@"Dishes" inManagedObjectContext:_managedObjectContext];
        [_currentDish setDateEntered:[NSDate date]];
            }
            
            NSString *imageFileName = [self getNewImageFilename];
            if (imageFileName) {
        
            NSString *newImagePath = [self getDocumentPathForFile:[NSString stringWithFormat:@"%@",imageFileName]];
            if (![self fileDoesExistAtPath:newImagePath] && _dishImageView.image) {
            
            UIImage *scaledRotatedImage = [self scaleAndRotateImage:_dishImageView.image];
            [UIImagePNGRepresentation(scaledRotatedImage) writeToFile:newImagePath atomically:true];
            [_currentDish setDishImageFileName:imageFileName];
            NSLog(@"Image Path:%@",newImagePath);
            NSLog(@"Image Saved & Set");
        }
    }
    
    //Save to Camera Roll?
    
    
    if (_saveToCameraRollSwitch.on) {
        UIImage *scaledRotatedImage = [self scaleAndRotateImage:_dishImageView.image];
        UIImageWriteToSavedPhotosAlbum(scaledRotatedImage, nil, nil, nil);
        NSLog(@"Saved to Camera Roll");
    }
    
    //Record 1
    [_currentDish setDishName:_dishNameTextField.text];
    
    NSNumber *catNum = [NSNumber numberWithLong:_dishTypeSegControl.selectedSegmentIndex];
    if ([catNum intValue] == 0) {
        [_currentDish setDishType:[NSString stringWithFormat:@"Drink"]];
    }else if ([catNum intValue]  == 1){
        [_currentDish setDishType:[NSString stringWithFormat:@"Appetizer"]];
    }else if ([catNum intValue]  == 2){
        [_currentDish setDishType:[NSString stringWithFormat:@"Entrée"]];
    }else if ([catNum intValue]  == 3){
        [_currentDish setDishType:[NSString stringWithFormat:@"Snack"]];
    }else if ([catNum intValue]  == 4){
        [_currentDish setDishType:[NSString stringWithFormat:@"Dessert"]];
    }else {
        [_currentDish setDishType:@""];
    }
    
    [_currentDish setDishRating:[NSNumber numberWithLong:_dishRatingSegControl.selectedSegmentIndex]];
    
    [_currentDish setDateUpdated:[NSDate date]];
    
    [_appDelegate saveContext];
    NSLog(@"Saved?");
    
    [self.navigationController popToRootViewControllerAnimated:true];
    }
    else{
        NSLog(@"Don't Save");
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Dish Not Saved"
                                              message:@"Dish Title and/or Image Missing."
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"OK action");
                                   }];
        
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    
}

- (IBAction)deleteButtonPressed:(id)sender {
    [_managedObjectContext deleteObject:_currentDish];
    [_appDelegate saveContext];
    [self.navigationController popToRootViewControllerAnimated:true];
}


#pragma mark - ImagepickerController Methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    _dishImageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [picker dismissViewControllerAnimated:true completion:nil]; //rid of controller
    
    //need to tell it what to do
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:true completion:nil];
}


#pragma mark - Core Methods

-(BOOL)fileDoesExistAtPath:(NSString *)path {
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    return fileExists;
}



- (NSString *)getDocumentPathForFile:(NSString *)filename {
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) lastObject];
    
    path = [path stringByAppendingPathComponent:filename];
    return path;
    
}

- (void)copyFromPath:(NSString *)fromPath toPath:(NSString *)toPath {
    
    NSError *error = nil;
    [[NSFileManager defaultManager] copyItemAtPath:fromPath toPath:toPath error:&error];
    if (error) {
        NSLog(@"Error:%@",error);
        
    }
}

- (void)copySettingsToDocumentsIfNecessary {
    
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
    NSString *destPath = [self getDocumentPathForFile:@"Settings.plist"];
    if (![self fileDoesExistAtPath:destPath]) {
        [self copyFromPath:sourcePath toPath:destPath];
        
    }
}

- (NSString *)getNewImageFilename {
    NSString *settingsPath = [self getDocumentPathForFile:@"Settings.plist"];
    NSMutableDictionary *settingsPlist = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
    long counter = [[settingsPlist objectForKey:@"ImageNameCounter"] integerValue];
    //NSLog(@"Long Counter: %li",counter);
    if (counter == 0) {
        counter ++;
        NSLog(@"Counter was 0 now it's %li",counter);
    }
    NSString *imageFilename = [NSString stringWithFormat:@"image%li.png",counter];
    [settingsPlist setValue:[NSNumber numberWithLong:counter + 1] forKey:@"ImageNameCounter"];
    BOOL didWriteToFile = [settingsPlist writeToFile:settingsPath atomically:true];
    
    if (didWriteToFile) {
        return imageFilename;
        
    }return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _managedObjectContext = _appDelegate.managedObjectContext;
    
    [self copySettingsToDocumentsIfNecessary];
    //should move to AppDelegate so it only is run once
    if (_currentDish) {
        
        _dishNameTextField.text = _currentDish.dishName;
        
        NSString *dishType = _currentDish.dishType;
        
        
        if ([dishType isEqualToString:@"Drink"]) {
            [_dishTypeSegControl setSelectedSegmentIndex:0];
        }else if ([dishType isEqualToString:@"Appetizer"]) {
            [_dishTypeSegControl setSelectedSegmentIndex:1];
        }else if ([dishType isEqualToString:@"Entrée"]) {
            [_dishTypeSegControl setSelectedSegmentIndex:2];
        }else if ([dishType isEqualToString:@"Snack"]) {
            [_dishTypeSegControl setSelectedSegmentIndex:3];
        }else if ([dishType isEqualToString:@"Dessert"]) {
            [_dishTypeSegControl setSelectedSegmentIndex:4];
        }else {
            
        }

        
        [_dishRatingSegControl setSelectedSegmentIndex:[_currentDish.dishRating intValue]];
       
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
        //Gimme a list of all the paths that Document Directory for the current user.
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *savedImagePath = [documentsDirectory stringByAppendingFormat:@"/%@",_currentDish.dishImageFileName];
        
        
        [_dishImageView setImage:[UIImage imageNamed:savedImagePath]];
        
        
        //this is where we set the text on the DetailView Controller
    }else{
        [_dishNameTextField becomeFirstResponder];
        
        _deleteButton.enabled = false;
    }
    
    
    self.navigationController.navigationBar.tintColor = [UIColor gummyHotPinkColor];
    
    _galleryButton.backgroundColor = [UIColor gummyIceBlueColor];
    _cameraButton.backgroundColor = [UIColor gummyIceBlueColor];
    _deleteButton.backgroundColor = [UIColor gummyBerryColor];
    [_galleryButton setTitleColor:[UIColor gummyDkBlueColor] forState:normal];
    [_cameraButton setTitleColor:[UIColor gummyDkBlueColor] forState:normal];
    _dishNameTextField.textColor = [UIColor gummyRoseColor];

    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
