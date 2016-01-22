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
#import "FontNameTableViewController.h"

@interface NoteViewController () <FontNameTableViewDelegate>
@property (nonatomic, assign) CGFloat navBarHeight;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, assign) CGFloat screenWidth;

@property (nonatomic, strong) NSString *noteFontName;

@property (nonatomic, strong) UIBarButtonItem *colorToggle;
@property (nonatomic, strong) UIBarButtonItem *fontNameButton;

@property (nonatomic, strong) FontNameTableViewController *fontTableVC;


@end

@implementation NoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor notesBrown];
    self.noteFontName = @"Helvetica";
    if(self.theNoteView.noteFontName)
    {
        self.noteFontName = self.theNoteView.noteFontName;
    }
    [self setScreenHeightandWidth];
    [self placeTextField];
    [self createAndPlaceBarButtonItems];
    
}

-(void)placeTextField
{
    self.noteTextView = [[UITextView alloc] init];
    self.noteTextView.layer.cornerRadius = 15;
    self.noteTextView.backgroundColor = [UIColor notesYellow];
    self.noteTextView.font = [UIFont fontWithName:self.noteFontName size:self.fontSize];
    self.noteTextView.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:self.noteTextView];
    CGFloat boxSize = self.screenWidth - self.layoutGuideSize - 30;
    [self.noteTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(15);
        make.height.and.width.equalTo(@(boxSize));
        make.centerX.equalTo(self.view);
    }];
    
    
    if (self.areWeEditing)
    {
        self.noteTextView.backgroundColor = self.theNoteView.interiorView.backgroundColor;
        self.noteTextView.text = self.theNoteView.textValue;
    }
    
}

-(void)createAndPlaceBarButtonItems
{
    self.navigationController.navigationBar.tintColor = [UIColor notesBrown];
    UIBarButtonItem *addNoteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(addNote:)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.colorToggle = [[UIBarButtonItem alloc] initWithTitle:[UIColor stringFromColor:self.noteTextView.backgroundColor]
                                                        style:UIBarButtonItemStylePlain
                                                       target:self
                                                       action:@selector(toggleColors:)];
    self.fontNameButton= [[UIBarButtonItem alloc] initWithTitle:@"Font"
                                                          style:UIBarButtonItemStylePlain
                                                         target:self
                                                         action:@selector(changeTheFont:)];
    
    self.navigationItem.rightBarButtonItems = @[addNoteButton ,flexibleSpace,self.fontNameButton, flexibleSpace, self.colorToggle, flexibleSpace];
}

-(void)addNote:(UIBarButtonItem *)barButton
{
    
    NSDictionary *noteDictionary = @{@"color" : self.noteTextView.backgroundColor ,
                                     @"noteText" : self.noteTextView.text,
                                     @"noteOrder" : @(self.noteOrder),
                                     @"priority": @(1),
                                     @"fontName" : self.noteFontName
                                     };
    
    [self.delegate newNoteResult:noteDictionary updatedNoteView:self.theNoteView];
    
}


-(void)changeTheFont:(UIBarButtonItem *)barButton
{
    self.fontTableVC = [[FontNameTableViewController alloc] init];
    self.fontTableVC.delegate = self;
    self.fontTableVC.fontNamePassed = self.noteFontName;
    [self showViewController:_fontTableVC sender:self];
}

-(void)newFontPicked:(NSString *)newFont
{
    self.noteFontName = newFont;
}

-(void)setNoteFontName:(NSString *)noteFontName
{
    _noteFontName = noteFontName;
    CGFloat fontSize = self.noteTextView.font.pointSize;
    self.noteTextView.font = [UIFont fontWithName:noteFontName size:fontSize];
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


-(void)setScreenHeightandWidth
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.screenHeight = MAX(screenSize.width, screenSize.height);
    self.screenWidth = MIN(screenSize.width, screenSize.height);
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
