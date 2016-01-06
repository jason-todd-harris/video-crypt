//
//  NewNoteViewController.m
//  notes-flick
//
//  Created by JASON HARRIS on 12/26/15.
//  Copyright © 2015 jason harris. All rights reserved.
//

#import "NoteViewController.h"
#import <Masonry.h>
#import "AllTheNotes.h"
#import "NotesColor.h"

@interface NoteViewController ()
@property (nonatomic, assign) CGFloat navBarHeight;
@property (nonatomic, strong) UIBarButtonItem *colorToggle;


@end

@implementation NoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor notesDarkGray];
    
    [self placeTextField];
    [self createAndPlaceBarButtonItems];
    
    
}

-(void)placeTextField
{
    self.noteTextView = [[UITextView alloc] init];
    self.noteTextView.backgroundColor = [UIColor notesYellow];
    [self.view addSubview:self.noteTextView];
    [self.noteTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.and.width.equalTo(@([AllTheNotes sharedNotes].defaultNoteSize));
//        make.top.equalTo(self.self.mas_topLayoutGuideBottom).offset(20);
        make.centerY.equalTo(self.view);
        make.centerX.equalTo(self.view);
    }];
    
    if (self.areWeEditing)
    {
        self.noteTextView.backgroundColor = self.theNoteView.backgroundColor;
        self.noteTextView.text = self.theNoteView.textValue;
    }
    
}

-(void)createAndPlaceBarButtonItems
{
    UIBarButtonItem *addNoteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(addNote:)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.colorToggle = [[UIBarButtonItem alloc] initWithTitle:[UIColor stringFromColor:self.noteTextView.backgroundColor]
                                                        style:UIBarButtonItemStylePlain
                                                       target:self
                                                       action:@selector(toggleColors:)];
    self.navigationItem.rightBarButtonItems = @[addNoteButton , flexibleSpace, self.colorToggle, flexibleSpace];
}

-(void)addNote:(UIBarButtonItem *)barButton
{
    
    NSDictionary *noteDictionary = @{@"color" : self.noteTextView.backgroundColor ,
                                     @"noteText" : self.noteTextView.text,
                                     @"noteOrder" : @(self.noteOrder),
                                     @"priority": @(1)
                                     };
    
    [self.delegate newNoteResult:noteDictionary updatedNoteView:self.theNoteView];
    
}

-(void)toggleColors:(UIBarButtonItem *)barButton
{
    UIColor *currentColor = self.noteTextView.backgroundColor;
    
    NSUInteger indexNumber = [[AllTheNotes sharedNotes].colorArray indexOfObject:currentColor];
    indexNumber = indexNumber + 1;
    indexNumber = indexNumber % [AllTheNotes sharedNotes].colorArray.count;
    self.noteTextView.backgroundColor = [AllTheNotes sharedNotes].colorArray[indexNumber];
    self.colorToggle.title = [UIColor stringFromColor:self.noteTextView.backgroundColor];
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
