//
//  ViewController.m
//  FoodieLove
//
//  Created by Sonova Middleton on 6/29/15.
//  Copyright (c) 2015 supernova8productions. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Dishes.h"
#import <CoreData/CoreData.h>
#import "ViewControllerDetail.h"
#import "DishCollectionViewCell.h"
#import "UIColor+Gummy.h"

@interface ViewController ()

@property (nonatomic,strong) AppDelegate *appDelegate;
@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic,strong) NSArray *dishArray;
//@property (nonatomic,strong) IBOutlet UITableView *dishTableView;
@property (nonatomic,strong) IBOutlet UICollectionView *dishCollectionView;

@end

@implementation ViewController

int addCounterInt = 0;
//int initCounterInt = 0;


#pragma mark - Interactivity methods

- (IBAction)addButtonPressed:(id)sender {
    
    NSLog(@"Add Pressed");
    addCounterInt++;
    [self performSegueWithIdentifier:@"dishesToDetailSegue" sender:self];
    
}


#pragma mark - Database Methods

- (void)tempAddRecords {
    
    NSLog(@"Add!");
    
    
    Dishes *newDish = (Dishes *)[NSEntityDescription insertNewObjectForEntityForName:@"Dishes" inManagedObjectContext:_managedObjectContext];
    
    //Record 1
    [newDish setDishName:@"Duck Cupcakes"];
    [newDish setDishRating:[NSNumber numberWithInt:4]];
    [newDish setDishImageFileName:@"image1.png"];
    
    [newDish setDateEntered:[NSDate date]];
    [newDish setDateUpdated:[NSDate date]];
    
    [_appDelegate saveContext];
    
    
    
}

- (NSArray *)fetchDishes {
    NSLog(@"TCFetch");
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Dishes" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    return [_managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
}

#pragma mark - TableView Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"Count IN Collection View: %lu", _dishArray.count);
    return [_dishArray count];
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    
//    return 1;
//    
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    
//    return _dishArray.count;
//}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _dishCollectionView) {
        NSLog(@"iCell!");
        _dishCollectionView.backgroundColor = [UIColor gummyClearColor];
        
        NSString *CellIdentifier = @"iCell";
        DishCollectionViewCell *iCell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        
        Dishes *currentDish = [_dishArray objectAtIndex:indexPath.row];
        iCell.dishNameLabel.text = [currentDish dishName];
        iCell.dishNameLabel.textColor = [UIColor whiteColor];
        
        NSNumber *catNum = [currentDish dishRating];
        if ([catNum intValue] == 0) {
            iCell.dishRankingLabel.text = [NSString stringWithFormat:@"Rating: Gross"];
        }else if ([catNum intValue]  == 1){
            iCell.dishRankingLabel.text = [NSString stringWithFormat:@"Rating: Boring"];
        }else if ([catNum intValue]  == 2){
            iCell.dishRankingLabel.text = [NSString stringWithFormat:@"Rating: Okay"];
        }else if ([catNum intValue]  == 3){
            iCell.dishRankingLabel.text = [NSString stringWithFormat:@"Rating: Delish"];
        }else{
            iCell.dishRankingLabel.text = [NSString stringWithFormat:@"Rating: Amazing"];
        }
        iCell.dishRankingLabel.textColor = [UIColor whiteColor];
        
        //iCell.dishRankingLabel.text = [NSString stringWithFormat:@"Ranking: %i",[[currentDish dishRating] intValue]];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
        //Gimme a list of all the paths that Document Directory for the current user.
        NSString *documentsDirectory = [paths objectAtIndex:0];
        //NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",currentDish.dishImageFileName]];
        NSString *savedImagePath = [documentsDirectory stringByAppendingFormat:@"/%@",currentDish.dishImageFileName];
        
        NSLog(@"Displayed Dish: %@",currentDish);
        
        //[cell.imageView setImage:[UIImage imageNamed:[currentDish dishImageFileName]]];
        [iCell.dishImageView setImage:[UIImage imageNamed:savedImagePath]];

        
       // iCell.dishImageView.image = [UIImage imageNamed:[currentDish dishImageName]];
        
        return iCell;
        
        
    }
    return nil;
}


//Method to push Array Fields into the TableView Cells
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"Cell!");
//    NSString *cellIdentifier =@"Cell"; //we've replaced string with this
//    
//    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    // takes cell that is being recycled and takes it to reuse it.
//    
//    if (cell ==nil) { //if you don't have an old one, then let's create a new one
//        cell= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cell.accessoryView = nil;
//        //these Strings need to be the same as line above
//        
//        // these below are placed here so theyre only done when cell is created
//        
//    }
//    cell.accessoryView = nil;
//    Dishes *currentDish = _dishArray[indexPath.row];
//    
//    cell.textLabel.text = [currentDish dishName];
//    
//    //Set the Cell Text field with the First and Last name from the Array
//    
//    NSNumber *catNum = [currentDish dishRating];
//    //[currentDish.DishCategory intValue];
//    
//    if ([catNum intValue] == 0) {
//        cell.detailTextLabel.text = @"Gross";
//    }else if ([catNum intValue]  == 1){
//        cell.detailTextLabel.text = @"Boring";
//    }else if ([catNum intValue]  == 2){
//        cell.detailTextLabel.text = @"Okay";
//    }else if ([catNum intValue]  == 3){
//        cell.detailTextLabel.text = @"Delish";
//    }else{
//        cell.detailTextLabel.text = @"Amazing";
//    }
//    //cell.detailTextLabel.text = [currentDish DishEmail];
//    
//    //Set the Cell Detail Text with the string for category
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
//    //Gimme a list of all the paths that Document Directory for the current user.
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    //NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",currentDish.dishImageFileName]];
//    NSString *savedImagePath = [documentsDirectory stringByAppendingFormat:@"/%@",currentDish.dishImageFileName];
//    
//    NSLog(@"Displayed Dish: %@",currentDish);
//    
//    //[cell.imageView setImage:[UIImage imageNamed:[currentDish dishImageFileName]]];
//    [cell.imageView setImage:[UIImage imageNamed:savedImagePath]];
//    return cell;
//    
//}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(150.0, 170.0);
}

////Tells the segue that a cell was selected and to do the PrepareforSegue Method
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    NSLog(@"Select");
//    
//    [self performSegueWithIdentifier:@"listToDetailSegue" sender:self];
//}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender    {
    
    if ([[segue identifier] isEqualToString: @"dishesToDetailSegue"]) {
        
        ViewControllerDetail *destController = [segue destinationViewController];

        if(addCounterInt >= 1) {
            NSLog(@"add");
            Dishes *currentDish;
            destController.currentDish = currentDish;
            //[destController setSelectedDish:currentDish];
            addCounterInt = 0;
            
        }

        else { //Update
            NSLog(@"update to segue");
            
            NSIndexPath *indexPath = [[_dishCollectionView indexPathsForSelectedItems] objectAtIndex:0];
            //creates the indexPath
            
            Dishes *currentDish = [_dishArray objectAtIndex:[indexPath row]];
            //creates the current Flavor
            
            destController.currentDish = currentDish;
            //changes the text of the nameSting label to the current flavor
            
        }

        
//        
//        NSIndexPath *indexPath = [[_dishCollectionView indexPathsForSelectedItems] objectAtIndex:0];
//        //This line changed
//        
//        Flavors *selectedFlavor = [_flavorsArray objectAtIndex:[indexPath row]];
//        
//        
//        [destController setSelectedFlavor:selectedFlavor];}
    
    
}
}

//This method gives the DetailViewController the data to display
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    
//    ViewControllerDetail *destController = [segue destinationViewController];
//    //inits the Controller
//    
//    if(addCounterInt >= 1) {
//        NSLog(@"add");
//        Dishes *currentDish;
//        destController.currentDish = currentDish;
//        addCounterInt = 0;
//        
//    }
//    else { //Update
//        NSLog(@"update to segue");
//        
//        NSIndexPath *indexPath = [_dishTableView indexPathForSelectedRow];
//        //creates the indexPath
//        
//        Dishes *currentDish = _dishArray[indexPath.row];
//        //creates the current Flavor
//        
//        destController.currentDish = currentDish;
//        //changes the text of the nameSting label to the current flavor
//        
//    }
//}
//




#pragma mark - Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Load");
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _managedObjectContext = _appDelegate.managedObjectContext;
    
    //    if(!_managedObjectContext) {
    //        NSLog(@"Add Temp Records");
    //        //Don't add anymore temp records
    //
    //
    //[self tempAddRecords];
    //    }
    //    else {
    //    // Don't add Temp Records
    //        NSLog(@"Don't Add Temp Records");
    //    }
//    _dishArray = [self fetchDishes];
    NSLog(@"Count: %lu", _dishArray.count);
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    _dishArray = [self fetchDishes];
    NSLog(@"View Count: %lu", _dishArray.count);
    [_dishCollectionView reloadData];
    
    // to reload the Data in the TableView
    
    //this is where we set the text on the DetailView Controller
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

