//
//  SettingsTableViewController.m
//  notes-flick
//
//  Created by JASON HARRIS on 1/15/16.
//  Copyright © 2016 jason harris. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "NotesColor.h"
#import "AllTheNotes.h"
#import "SortOrderTableViewController.h"
#import "FontViewController.h"
#import "ClearNotesTableVC.h"
#import "AlignmentTableVC.h"
#import "InstructionsVC.h"
#import "SortAscendOrDescendTableVC.h"
#import <Masonry.h>


@interface SettingsTableViewController () <UITableViewDelegate,AlignmentDelegate>
@property (nonatomic, strong) NSArray *cellNameArray;
@property (nonatomic, strong) AlignmentTableVC *alignmentTableVC;

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationController.navigationBar.tintColor = [UIColor notesBrown];
    self.view.backgroundColor = [UIColor notesBrown];
//    self.tableView.contentMode = UIViewContentModeScaleToFill;
    self.tableView.separatorColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.scrollEnabled = NO;
//    self.tableView.rowHeight = 64;
//    self.tableView.alwaysBounceHorizontal = NO;
//    self.tableView.alwaysBounceVertical = NO;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.delegate = self;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    self.navigationItem.title = @"Settings";
    
    self.cellNameArray = @[@"Font", @"Sort Order", @"Clear Notes",@"Alignment",@"Instructions"];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.delegate changeInSettings:@"temp"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return self.cellNameArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@""];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor notesBrown];
    cell.textLabel.text = self.cellNameArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
//    cell.detailTextLabel.text = @"detail text";
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
    
    UIView *bgView = [[UIView alloc] initWithFrame:cell.bounds];
    bgView.backgroundColor = [UIColor grayColor];
    cell.selectedBackgroundView = bgView;
    cell.textLabel.textColor = [UIColor notesLightGray];
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   
    if([self.cellNameArray[indexPath.row] isEqualToString:@"Sort Order"])
    {
        SortOrderTableViewController *sortOrderVC = [[SortOrderTableViewController alloc] init];
        [self showViewController:sortOrderVC sender:self];  
    } else if([self.cellNameArray[indexPath.row] isEqualToString:@"Font"])
    {
        FontViewController *fontVC = [[FontViewController alloc] init];
        [self showViewController:fontVC sender:self];
    } else if([self.cellNameArray[indexPath.row] isEqualToString:@"Clear Notes"])
    {
        ClearNotesTableVC *clearNotesVC = [[ClearNotesTableVC alloc] init];
        [self showViewController:clearNotesVC sender:self];
    } else if([self.cellNameArray[indexPath.row] isEqualToString:@"Alignment"])
    {
        self.alignmentTableVC = [[AlignmentTableVC alloc] init];
        self.alignmentTableVC.delegate = self;
        [self showViewController:self.alignmentTableVC sender:self];
    } else if([self.cellNameArray[indexPath.row] isEqualToString:@"Instructions"])
    {
        InstructionsVC *instructionsVC = [[InstructionsVC alloc] init];
        [self showViewController:instructionsVC sender:self];
    }
}

-(void)alignmentChosen
{
    [self.navigationController popToViewController:self animated:YES];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
