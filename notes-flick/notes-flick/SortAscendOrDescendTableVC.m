//
//  DateSortTableVC.m
//  Flicky Notes
//
//  Created by JASON HARRIS on 2/13/16.
//  Copyright © 2016 jason harris. All rights reserved.
//

#import "SortAscendOrDescendTableVC.h"
#import "NotesColor.h"
#import "AllTheNotes.h"

@interface SortAscendOrDescendTableVC ()
@property (nonatomic, strong) NSArray *cellNameArray;
@property (nonatomic, strong) NSIndexPath *cellToHighlight;

@end

@implementation SortAscendOrDescendTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor notesBrown];
    self.view.backgroundColor = [UIColor notesBrown];
    self.tableView.separatorColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.scrollEnabled = NO;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.delegate = self;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    
    [self determineCellNames];
}

- (void)determineCellNames
{
    NSUInteger rowToHighlight = 1;
    if([self.variableToSort isEqualToString:@"Date"])
    {
        self.cellNameArray = @[@"Ascending", @"Descending"];
        if([AllTheNotes sharedNotes].sortDateAscending)
        {
            rowToHighlight = 0;
        }
            
    } else if([self.variableToSort isEqualToString:@"Status"])
    {
        self.cellNameArray = @[@"Completed Notes Last" , @"Completed Notes First"];
        if([AllTheNotes sharedNotes].sortCrossOutAscending)
        {
            rowToHighlight = 0;
        }
    }
    self.cellToHighlight = [NSIndexPath indexPathForRow:rowToHighlight inSection:0];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView selectRowAtIndexPath:self.cellToHighlight animated:YES scrollPosition:UITableViewScrollPositionTop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    cell.detailTextLabel.textColor = [UIColor notesLightGray];
    
    [cell.textLabel setHighlighted:YES];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.cellNameArray[indexPath.row] isEqualToString:@"Ascending"])
    {
        [AllTheNotes sharedNotes].sortDateAscending = YES;
    } else if([self.cellNameArray[indexPath.row] isEqualToString:@"Descending"])
    {
        [AllTheNotes sharedNotes].sortDateAscending = NO;
    } else if([self.cellNameArray[indexPath.row] isEqualToString:@"Completed Notes First"])
    {
        [AllTheNotes sharedNotes].sortCrossOutAscending = NO;
    } else if([self.cellNameArray[indexPath.row] isEqualToString:@"Completed Notes Last"])
    {
        [AllTheNotes sharedNotes].sortCrossOutAscending = YES;
    }
    
    
    [AllTheNotes updateDefaultsWithSettings];
    [self.delegate sortChosen];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

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
