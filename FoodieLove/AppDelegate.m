//
//  AppDelegate.m
//  FoodieLove
//
//  Created by Sonova Middleton on 6/29/15.
//  Copyright (c) 2015 supernova8productions. All rights reserved.
//

#import "AppDelegate.h"
#import "UIColor+Gummy.h"
#import "ViewControllerDetail.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (void)customizeAppearance {
    
    //change titlebar everywhere to look different
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor gummyDkPinkColor], NSFontAttributeName: [UIFont fontWithName:@"Noteworthy-Bold" size:24.0]}];
    
    [[UINavigationBar appearance] setBackgroundColor:[UIColor gummyBGColor]];
    
    //[[UICollectionView appearance] setBackgroundColor:[UIColor gummyClearColor]]; //all VCs unless changed locally
    
    [[UICollectionView appearance] setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coral_chevron_background"]]];
    
    //[[UICollectionView appearance] setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chevron_background"]]];
    
    //[[UIView appearanceWhenContainedIn:[ViewControllerDetail class], nil] setBackgroundColor:[UIColor gummyClearColor]];
    
    //[[UIView appearanceWhenContainedIn:[ViewControllerDetail class], nil] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"iphone-coral-polka-dots"]]];
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor gummyHotPinkColor]];
    
    [[UISegmentedControl appearance] setTintColor:[UIColor gummyBerryColor]];
    
    
   // [[UILabel appearanceWhenContainedIn:[ViewControllerDetail class], nil] setTextColor:[UIColor blackColor]]; //so anything in this class
    
//    if(self.view.frame.size.heigh==480){
//        //put your image code here for 3.5 inch screen
//    }
//    else if(self.view.frame.size.height==568){
//        //put your image code here for 4-inch screen
//    }
    
    
    //[[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_bar"] forBarMetrics:UIBarMetricsDefault];

    //[[UILabel appearanceWhenContainedIn:[GCAppearanceViewController class], nil] setFont:[UIFont fontWithName:@"Baskerville" size:19.0]];
    
    //[[UIButton appearance] setTitleColor:[UIColor redColor] forState:UIControlStateNormal]; //buttons are a little different
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self customizeAppearance];
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.supernova8.FoodieLove" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FoodieLove" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"FoodieLove.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    
    
    //Need to add this everytime there is core data
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:true],NSMigratePersistentStoresAutomaticallyOption,[NSNumber numberWithBool:true],NSInferMappingModelAutomaticallyOption, nil];
   
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
