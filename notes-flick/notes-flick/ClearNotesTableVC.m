//
//  ClearNotesTableVC.m
//  notes-flick
//
//  Created by JASON HARRIS on 1/26/16.
//  Copyright © 2016 jason harris. All rights reserved.
//

#import "ClearNotesTableVC.h"
#import "NotesColor.h"
#import "NoteView.h"
#import "AllTheNotes.h"


@interface ClearNotesTableVC ()
@property (nonatomic, strong) NSArray *cellNameArray;

@end

@implementation ClearNotesTableVC

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
    
    self.cellNameArray = @[@"Delete Notes", @"Clear Deleted Notes"];
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
    
    if([cell.textLabel.text isEqualToString:@"Clear Deleted Notes"])
    {
        cell.detailTextLabel.text = @"Cannot be undone";
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.cellNameArray[indexPath.row] isEqualToString:@"Delete Notes"])
    {
        [self displayAlertViewController:@"Delete all notes" message:@"Can be undone" completion:^(bool alertResult) {
            if(alertResult)
            {
                NSUInteger i;
                NSUInteger notesCount = [AllTheNotes sharedNotes].notesArray.count;
                for (i = 1; i < notesCount+1; i++)
                {
                    [[AllTheNotes sharedNotes].deletedArray addObject:[AllTheNotes sharedNotes].notesArray[notesCount -i]];
                    [[AllTheNotes sharedNotes].notesArray[notesCount -i] removeFromSuperview];
                }
            }
        }];
    } else if([self.cellNameArray[indexPath.row] isEqualToString:@"Clear Deleted Notes"])
    {
        [self displayAlertViewController:@"Clear all deleted notes" message:@"CANNOT BE UNDONE" completion:^(bool alertResult) {
            if(alertResult)
            {
                [AllTheNotes sharedNotes].deletedArray = @[].mutableCopy;
            }
        }];
    }
}


-(void)displayAlertViewController:(NSString *)title
                          message:(NSString *)message
                       completion:(void (^)(bool alertResult))completionBlock
{
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:title
                                message:message
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yesButton = [UIAlertAction
                                actionWithTitle:@"Yes"
                                style:UIAlertActionStyleDestructive
                                handler:^(UIAlertAction * action)
                                {
                                    completionBlock(YES);
                                }];
    UIAlertAction *noButton = [UIAlertAction
                               actionWithTitle:@"No"
                               style:UIAlertActionStyleDefault
                               handler:nil];
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
    
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
