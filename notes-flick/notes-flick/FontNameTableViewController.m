//
//  FontNameTableViewController.m
//  notes-flick
//
//  Created by JASON HARRIS on 1/22/16.
//  Copyright © 2016 jason harris. All rights reserved.
//


#import "FontNameTableViewController.h"
#import "NotesColor.h"
#import "AllTheNotes.h"
#import "SortOrderTableViewController.h"
#import "FontViewController.h"
#import <Masonry.h>

@interface FontNameTableViewController ()
@property (nonatomic, strong) NSMutableArray *fontNamesArray;
@property (nonatomic, strong) NSIndexPath *fontIndexPath;

@end

@implementation FontNameTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor notesBrown];
    self.view.backgroundColor = [UIColor notesBrown];
        self.tableView.contentMode = UIViewContentModeScaleToFill;
    self.tableView.separatorColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    self.tableView.tableFooterView = [UIView new];
    self.tableView.delegate = self;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    [self populateFontNames];
    
    NSUInteger indexValue = [self.fontNamesArray indexOfObject:self.fontNamePassed];
    self.fontIndexPath = [NSIndexPath indexPathForRow:indexValue inSection:0];
    [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:self.fontIndexPath];
    [self.tableView scrollToRowAtIndexPath:self.fontIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView selectRowAtIndexPath:self.fontIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
}

-(void)populateFontNames
{
    self.fontNamesArray = NSMutableArray.new;
    NSArray *familyNameArray = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    for (indFamily=0; indFamily < familyNameArray.count; ++indFamily)
    {
        fontNames = [[NSArray alloc] initWithArray:
                     [UIFont fontNamesForFamilyName:
                      [familyNameArray objectAtIndex:indFamily]]];
        for (indFont=0; indFont<fontNames.count; ++indFont)
        {
            [self.fontNamesArray addObject:[fontNames objectAtIndex:indFont]];
        }
    }
    [self.fontNamesArray sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
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
    return self.fontNamesArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@""];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor notesBrown];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
    UIView *bgView = [[UIView alloc] initWithFrame:cell.bounds];
    bgView.backgroundColor = [UIColor grayColor];
    cell.selectedBackgroundView = bgView;
    cell.textLabel.textColor = [UIColor notesLightGray];
    cell.textLabel.text = self.fontNamesArray[indexPath.row];
    CGFloat fontSize = cell.textLabel.font.pointSize;
    cell.textLabel.font = [UIFont fontWithName:self.fontNamesArray[indexPath.row] size:fontSize];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *newFontPicked = self.fontNamesArray[indexPath.row];
    [self.delegate newFontPicked:newFontPicked];
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
