//
//  NewNoteViewController.m
//  notes-flick
//
//  Created by JASON HARRIS on 12/26/15.
//  Copyright © 2015 jason harris. All rights reserved.
//

#import "NewNoteViewController.h"
#import <Masonry.h>
#import "NotesColor.h"

@interface NewNoteViewController ()



@end

@implementation NewNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor notesDarkGray];
    [self placeTextField];
    
}

-(void)placeTextField
{
    self.noteTextView = [[UITextView alloc] init];
    self.noteTextView.backgroundColor = [UIColor notesYellow];
    [self.view addSubview:self.noteTextView];
    [self.noteTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(40, 20, 75, 20));
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
