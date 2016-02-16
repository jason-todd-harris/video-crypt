//
//  SortOrderTableViewController.m
//  notes-flick
//
//  Created by JASON HARRIS on 1/15/16.
//  Copyright © 2016 jason harris. All rights reserved.
//

#import "SortOrderTableViewController.h"
#import "NotesColor.h"
#import "AllTheNotes.h"
#import "ColorOrderTableVC.h"
#import "SortAscendOrDescendTableVC.h"
#import <Masonry.h>

@interface SortOrderTableViewController () <SortOrderDelegate>
@property (nonatomic, strong) NSMutableArray *sortOrderArray;

@end

@implementation SortOrderTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor notesBrown];
    self.view.backgroundColor = [UIColor notesBrown];
    self.tableView.separatorColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.scrollEnabled = NO;
    self.tableView.alwaysBounceHorizontal = NO;
    self.tableView.alwaysBounceVertical = NO;
    self.tableView.editing = YES;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.delegate = self;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.allowsSelectionDuringEditing = YES;
    
    self.navigationItem.title = @"Rearrange Sort Order";
    
    
    self.sortOrderArray = [AllTheNotes sharedNotes].sortOrderArray;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sortOrderArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@""];
    cell.backgroundColor = [UIColor notesBrown];
    cell.textLabel.text = self.sortOrderArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.detailTextLabel.textColor = [UIColor notesLightGray];
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
    UIView *bgView = [[UIView alloc] initWithFrame:cell.bounds];
    bgView.backgroundColor = [UIColor grayColor];
    cell.selectedBackgroundView = bgView;
    cell.textLabel.textColor = [UIColor notesLightGray];
    
    
    if([cell.textLabel.text isEqualToString:@"Colors"])
    {
        cell.detailTextLabel.text = @"Select to arrange color sort order";
    }
    
    return cell;
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSString *stringToMove = [self.sortOrderArray objectAtIndex:fromIndexPath.row];
    [self.sortOrderArray removeObjectAtIndex:fromIndexPath.row];
    [self.sortOrderArray insertObject:stringToMove atIndex:toIndexPath.row];
    
    [AllTheNotes updateDefaultsWithSettings];
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    
    
    return YES;
}


// Turns off the Red delete button circle thing
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}
// turns off indent after removing the red circle for deleting cells
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.sortOrderArray[indexPath.row] isEqualToString:@"Colors"])
    {
        ColorOrderTableVC *colorOrderVC = [[ColorOrderTableVC alloc] init];
        [self showViewController:colorOrderVC sender:self];
    } if([self.sortOrderArray[indexPath.row] isEqualToString:@"Date Created"])
    {
        SortAscendOrDescendTableVC *ascendDescendVC = [[SortAscendOrDescendTableVC alloc] init];
        ascendDescendVC.delegate = self;
        ascendDescendVC.variableToSort = @"Date";
        [self showViewController:ascendDescendVC sender:self];
    } if([self.sortOrderArray[indexPath.row] isEqualToString:@"Completed Status"])
    {
        SortAscendOrDescendTableVC *ascendDescendVC = [[SortAscendOrDescendTableVC alloc] init];
        ascendDescendVC.delegate = self;
        ascendDescendVC.variableToSort = @"Status";
        [self showViewController:ascendDescendVC sender:self];
    }

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)sortChosen
{
    [self.navigationController popToViewController:self animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Override to support conditional rearranging of the table view.
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Return NO if you do not want the item to be re-orderable.
//    return YES;
//}


// Override to support editing the table view.
//- (void)tableView:(UITableView *)tableView
//commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
//forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        // Delete the row from the data source
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }   
//}







/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
