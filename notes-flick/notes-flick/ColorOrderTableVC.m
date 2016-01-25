//
//  ColorOrderTableVC.m
//  notes-flick
//
//  Created by JASON HARRIS on 1/25/16.
//  Copyright © 2016 jason harris. All rights reserved.
//

#import "ColorOrderTableVC.h"
#import "NotesColor.h"
#import "AllTheNotes.h"
#import <Masonry.h>

@interface ColorOrderTableVC ()
@property (nonatomic, strong) NSMutableArray *colorOrder;

@end

@implementation ColorOrderTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor notesBrown];
    self.view.backgroundColor = [UIColor notesBrown];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    self.tableView.alwaysBounceHorizontal = NO;
    self.tableView.alwaysBounceVertical = NO;
    self.tableView.editing = YES;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.delegate = self;
    self.tableView.rowHeight = 75;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.navigationItem.title = @"Rearrange Color Order";
    
    
    self.colorOrder = [AllTheNotes sharedNotes].colorArray;

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
    return [AllTheNotes sharedNotes].colorArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    
    cell.backgroundColor = [AllTheNotes sharedNotes].colorArray[indexPath.row];
    cell.textLabel.text = [UIColor stringFromColor:[AllTheNotes sharedNotes].colorArray[indexPath.row]];
    
    return cell;
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    UIColor *colorToMove = [self.colorOrder objectAtIndex:fromIndexPath.row];
    [self.colorOrder removeObjectAtIndex:fromIndexPath.row];
    [self.colorOrder insertObject:colorToMove atIndex:toIndexPath.row];
    
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
