//
//  History.m
//  AllergyScanner
//
//  Created by Itai Ram on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "History.h"

@implementation History

@synthesize tblSimpleTable;
@synthesize product;
@synthesize brand;
@synthesize dataDict;
@synthesize listOfItems;
@synthesize brandsArray;
@synthesize productNamesArray;
@synthesize defaults;

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        product = [[NSString alloc] init];
        brand = [[NSString alloc] init];
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //NAV TITLE
    self.navigationItem.title = @"History";
    
    //NAV ITEMS
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(done:)];      
    self.navigationItem.rightBarButtonItem = rightButton;
    
    //TABLE DATA MANAGEMENT 
    listOfItems = [[NSMutableArray alloc] init];
    
    defaults = [NSUserDefaults standardUserDefaults];  //load NSUserDefaults
    brandsArray = [[NSMutableArray alloc] initWithArray:[defaults arrayForKey:@"brands"]]; 
    productNamesArray = [[NSMutableArray alloc] initWithArray:[defaults arrayForKey:@"productNames"]];     
    [listOfItems addObject:brandsArray];
    [listOfItems addObject:productNamesArray];
    
    NSLog(@"listOfItems array %@", listOfItems);
    
    //    if ([brandsArray count] == 0 || [productNamesArray count] == 0){
    //        
    //        [brandsArray setValue:@"" forKey:@"brands"];
    //        [productNamesArray setValue:@"" forKey:@"productNames"];
    //    }
    //    else
    //    {
    //CREATING THE TABLE 
    tblSimpleTable = [[UITableView alloc]  initWithFrame:CGRectMake(0, 0, 320, 420) style:UITableViewStylePlain ];
    tblSimpleTable.dataSource = self;
    tblSimpleTable.delegate = self;
    [self.view addSubview:tblSimpleTable];
    self.navigationController.title = @"My Location Diary";
    //   }
    
    NSLog(@"NEW PRODUCT IS %@ and NEW BRAND %@", product, brand);
    
}

- (void) blabla {
    
    NSLog(@"NEW PRODUCT ISand NEW BRAND");
}


- (void)done:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (void) addNewItem:(NSString *)newProduct withNewBrand:(NSString *)newBrand {
    

    NSLog(@"newProduct %@", newProduct);
    NSLog(@"newBrand %@", newBrand);

    [brandsArray addObject:newBrand];
    [productNamesArray addObject:newProduct];


    [tblSimpleTable reloadData];

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //    return [listOfItems count];    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[listOfItems objectAtIndex:section] count];
}

//- (void) printBS {
//    
//    NSLog(@"NEW PRODUCT ISand NEW BRAND");
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier]; //try here diff styles
        cell = [self getCellContentView:CellIdentifier];
        
    }
    
    ////    NSDictionary *dictionary = [listOfItems objectAtIndex:indexPath.section];
    ////    NSArray *array = [dictionary objectForKey:@"Products"];
    //    NSArray *array = [listOfItems objectAtIndex:indexPath.section];
    //
    //    NSDictionary *subDictionary = [listOfItems objectAtIndex:(indexPath.section+1)];
    //    NSArray *subArray = [subDictionary objectForKey:@"Products"];
    //
    //    
    // //   NSLog(@"dictionary array %@", dictionary);
    //    NSLog(@"array array %@", array);
    //
    //    NSLog(@"subDictionary array %@", subDictionary);
    //    NSLog(@"subArray subArray %@", subArray);
    
    NSString *cellValue = [[NSString alloc] init];
    cellValue = [productNamesArray objectAtIndex:indexPath.row];
    //cell.textLabel.numberOfLines = 2;
    
    NSString *subCellValue = [[NSString alloc] init];
    subCellValue = [brandsArray objectAtIndex:indexPath.row];
    
    UILabel *lblTemp1 = (UILabel *)[cell viewWithTag:1];
	UILabel *lblTemp2 = (UILabel *)[cell viewWithTag:2];
    
    
    lblTemp1.text = cellValue;
    lblTemp2.text = subCellValue;
    
    
    NSLog(@"cellValue  %@", cellValue);
    NSLog(@"subCellValue  %@", subCellValue);
    
    //    cell.textLabel.text = cellValue;
    //    cell.detailTextLabel.text = subCellValue;
    
    return cell;
}

- (UITableViewCell *) getCellContentView:(NSString *)cellIdentifier {
	
    //	CGRect CellFrame = CGRectMake(0, 0, 300, 60);
	CGRect Label1Frame = CGRectMake(10, 10, 290, 25);
	CGRect Label2Frame = CGRectMake(10, 33, 290, 25);
	UILabel *lblTemp;
	
    //	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CellFrame reuseIdentifier:cellIdentifier] autorelease];
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier ];
	
	//Initialize Label with tag 1.
	lblTemp = [[UILabel alloc] initWithFrame:Label1Frame];
	lblTemp.tag = 1;
	[cell.contentView addSubview:lblTemp];
	
	//Initialize Label with tag 2.
	lblTemp = [[UILabel alloc] initWithFrame:Label2Frame];
	lblTemp.tag = 2;
	lblTemp.font = [UIFont boldSystemFontOfSize:12];
	lblTemp.textColor = [UIColor lightGrayColor];
	[cell.contentView addSubview:lblTemp];
	
	return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
        
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row = [indexPath row];
    NSUInteger count = [listOfItems count];
    
    NSLog(@"listOfItems  %@", listOfItems);
    NSLog(@"sections  %d", row);
    NSLog(@"numrows  %d", count);
    
    NSLog(@"sections  %@", productNamesArray);
    NSLog(@"numrows  %@", brandsArray);
    
    //    NSMutableArray * section = [listOfItems objectAtIndex:indexPath.section];   
    NSMutableArray * section1 = [listOfItems objectAtIndex:0]; 
    NSMutableArray * section2 = [listOfItems objectAtIndex:1]; 
    
    NSLog(@"sections  %@", section1);
    NSLog(@"sections  %@", section2);
    
    [section1 removeObjectAtIndex:row];
    [section2 removeObjectAtIndex:row];
    
    [tblSimpleTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
    //   [tblSimpleTable reloadData];
    
    
    [defaults setObject:section1 forKey:@"brands"];  
    [defaults setObject:section2 forKey:@"productNames"]; 
    
    
    
    NSLog(@"sections  %@", section1);
    NSLog(@"sections  %@", section2);
    
    NSLog(@"listOfItems  %@", listOfItems);
    
    
    //    if (row < count) {
    //        
    //   //     [listOfItems removeObjectAtIndex:row];
    //        [brandsArray removeObjectAtIndex:row];  
    //        [productNamesArray removeObjectAtIndex:row];
    //        
    //    }
    
    NSLog(@"sections  %@", productNamesArray);
    NSLog(@"numrows  %@", brandsArray);
    
    
    NSLog(@"listOfItems  %@", listOfItems);
    
    
    //    NSLog(@"LIST dasdsaadd");
    //    
    //    if (editingStyle == UITableViewCellEditingStyleDelete) {
    //        
    //        NSMutableArray * section = [listOfItems objectAtIndex:indexPath.section];    
    //        [section removeObjectAtIndex:indexPath.row];
    //        [tblSimpleTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
    //		[tblSimpleTable reloadData];
    //        
    //    }     
    //    else if (editingStyle == UITableViewCellEditingStyleInsert) {
    //        
    //        //   NSLog(@"LIST %@", [listOfItems objectAtIndex:indexPath.row] );
    //        
    //        
    //        NSMutableArray * section = [listOfItems objectAtIndex:indexPath.section];    
    //        
    //        
    //        NSLog(@"LIST %@", section);
    //        
    //        [section addObject:@"mac mini"];
    //        
    //        NSLog(@"LIST %@", section);
    //        
    //        
    //        //   [[listOfItems objectAtIndex:indexPath.row]  insertObject:@"Mac Mini" atIndex:[listOfItems count]];
    //        
    //        [tblSimpleTable insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
    //        
    //        
    //		[tblSimpleTable reloadData];
    //    }
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView reloadData];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"Delete";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}


/*
 
 - (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
 
 //return UITableViewCellAccessoryDetailDisclosureButton;
 return UITableViewCellAccessoryDisclosureIndicator;
 }
 */



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    //    if(section == 0)
    //        return @"My allergy free food list";
    //    else if(section == 1)
    //        return @"Food I am allergic to";
    //    else
    //        return @"Others";
    
    return @"My scanned products history";
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown ;
}

@end
