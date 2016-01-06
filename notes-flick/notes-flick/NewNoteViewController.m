//
//  NewNoteViewController.m
//  notes-flick
//
//  Created by JASON HARRIS on 12/26/15.
//  Copyright © 2015 jason harris. All rights reserved.
//

#import "NewNoteViewController.h"
#import <Masonry.h>
#import "AllTheNotes.h"
#import "NotesColor.h"

@interface NewNoteViewController ()
@property (nonatomic, assign) CGFloat navBarHeight;
@property (nonatomic, strong) UIBarButtonItem *colorToggle;


@end

@implementation NewNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarHeight = self.navigationController.navigationBar.frame.size.height;
    self.view.backgroundColor = [UIColor notesDarkGray];
    [self placeTextField];
    
    
    UIBarButtonItem *addNoteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(addNote:)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.colorToggle = [[UIBarButtonItem alloc] initWithTitle:@"Yellow"
                                                        style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(toggleColors:)];
    self.navigationItem.rightBarButtonItems = @[addNoteButton , flexibleSpace, self.colorToggle, flexibleSpace];
    
}

-(void)addNote:(UIBarButtonItem *)barButton
{
    NSLog(@"add pressed");
    
    NSDictionary *noteDictionary = @{@"color" : self.noteTextView.backgroundColor ,
                                     @"noteText" : self.noteTextView.text};
    [self.delegate newNoteResult:noteDictionary];
    
}

-(void)toggleColors:(UIBarButtonItem *)barButton
{
    self.colorToggle.title = @"Blue";
    self.noteTextView.backgroundColor = [UIColor notesBlue];
}

-(void)placeTextField
{
    self.noteTextView = [[UITextView alloc] init];
    self.noteTextView.backgroundColor = [UIColor notesYellow];
    [self.view addSubview:self.noteTextView];
    [self.noteTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.and.width.equalTo(@([AllTheNotes sharedNotes].defaultNoteSize));
        make.top.equalTo(self.self.mas_topLayoutGuideBottom).offset(20);
        make.centerX.equalTo(self.view);
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
