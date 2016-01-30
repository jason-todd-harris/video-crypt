//
//  ViewController.m
//  notes-flick
//
//  Created by JASON HARRIS on 12/23/15.
//  Copyright © 2015 jason harris. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import "NoteViewController.h"
#import "NoteView.h"
#import "NotesColor.h"
#import "SettingsViewController.h"
#import "SettingsTableViewController.h"

@interface ViewController () <UIGestureRecognizerDelegate, UIScrollViewDelegate, NoteViewControllerDelegate, SettingsTableViewControllerDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UIBarButtonItem *addNoteButton;
@property (nonatomic, strong) UIBarButtonItem *undoBarButton;
@property (nonatomic, strong) UIBarButtonItem *settingsBarButton;

@property (nonatomic, strong) NoteViewController *veryNewNoteVC;
@property (nonatomic, strong) SettingsViewController *settingsVC;
@property (nonatomic, strong) SettingsTableViewController *settingsTableVC;

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureUp;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureDown;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTapGesture;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;

@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat transformScalar;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, assign) CGFloat spacing;
@property (nonatomic, assign) CGFloat noteSize;
@property (nonatomic, assign) CGFloat fontDivisor;
@property (nonatomic, assign) CGFloat largeFontSize;
@property (nonatomic, assign) BOOL alreadyLoaded;
@property (nonatomic, assign) BOOL zoomedIn;
@property (nonatomic, assign) NSUInteger lastOrientation;



@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].applicationIconBadgeNumber = -1;
    self.transformScalar = 3;
    self.animationDuration = 0.5;
    self.noteSize = [AllTheNotes sharedNotes].defaultNoteSize;
    self.fontDivisor = [AllTheNotes sharedNotes].fontDivisor;
    self.largeFontSize = [AllTheNotes sharedNotes].defaultNoteSize / self.fontDivisor;
    self.zoomedIn = [AllTheNotes sharedNotes].zoomedIn;
    if(!self.zoomedIn)
    {
        self.noteSize = [AllTheNotes sharedNotes].defaultNoteSize / self.transformScalar;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ALARM ALERT"
                                               object:nil];
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self checkIfUndoShouldInteract];
    [self checkIfAlarmsHavePassed];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
    

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(!self.alreadyLoaded)
    {
        [self runOnFirstLoad];
        self.lastOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    }
}


-(void)runOnFirstLoad
{
    [AllTheNotes sharedNotes].navigationBarSize = self.topLayoutGuide.length;
    [self setScreenHeightandWidth];
    [self setUpNavigationBar];
    [self setUpEntireScreen];
    [self loadFocusedOnNotification];
    self.alreadyLoaded = YES;
    
}

-(void)notificationReceived:(NSNotification *)notification
{
    UILocalNotification *alarmNotification = notification.object;
    [self checkIfAlarmsHavePassed];
    [self displayAlertViewController:@"ALARM" message:alarmNotification.userInfo[@"NOTE"] completion:nil];
}


#pragma mark - screen setup

-(void)setUpNavigationBar
{
    //PLUS BUTTON
    self.addNoteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                       target:self
                                                                       action:@selector(addNoteButtonWasPressed:)];
    
    //FLEXIBLE SPACE
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    //UNDO BUTTON
    UIImage *undoImage = [UIImage imageNamed:@"undoButton.png"];
    CGFloat imageScaling = undoImage.size.height;
    undoImage = [UIImage imageWithCGImage:undoImage.CGImage scale:1.8 orientation:undoImage.imageOrientation];
    self.undoBarButton = [[UIBarButtonItem alloc] initWithImage:undoImage
                                                          style:UIBarButtonItemStylePlain
                                                         target:self
                                                         action:@selector(undoLastDeletion:)];
    
    //SETTINGS BUTTON
    UIImage *settingsImage = [UIImage imageNamed:@"gearButton"];
    settingsImage = [UIImage imageWithCGImage:settingsImage.CGImage scale:1.8 orientation:settingsImage.imageOrientation];
    self.settingsBarButton = [[UIBarButtonItem alloc] initWithImage:settingsImage
                                                          style:UIBarButtonItemStylePlain
                                                         target:self
                                                         action:@selector(settingsButtonPressed:)];
    self.navigationController.navigationBar.tintColor = [UIColor notesBrown];
    

    
    self.navigationItem.leftBarButtonItems = @[self.settingsBarButton,flexibleSpace,self.undoBarButton,flexibleSpace,self.addNoteButton];
    UIView *addNoteView = [self.undoBarButton valueForKey:@"view"];
    imageScaling = addNoteView.frame.size.height;
    [self checkIfUndoShouldInteract];
    
}

-(void)setUpEntireScreen
{
    self.swipeGestureUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeReceived:)];
    self.swipeGestureUp.delegate = self;
    self.swipeGestureDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeReceived:)];
    self.swipeGestureDown.delegate = self;
    
    if ([AllTheNotes sharedNotes].scrollVertically)
    {
        self.swipeGestureUp.direction = UISwipeGestureRecognizerDirectionLeft;
        self.swipeGestureDown.direction = UISwipeGestureRecognizerDirectionRight;
    } else
    {
        self.swipeGestureUp.direction = UISwipeGestureRecognizerDirectionUp;
        self.swipeGestureDown.direction = UISwipeGestureRecognizerDirectionDown;
    }
    
    
    self.pinchGesture = [[UIPinchGestureRecognizer alloc]  initWithTarget:self action:@selector(pinchReceived:)];
    self.pinchGesture.delegate = self;
    self.doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapReceived:)];
    self.doubleTapGesture.numberOfTapsRequired = 2;
    
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.delegate = self;
    self.scrollView.userInteractionEnabled = YES;
    [self testForPaging];
    self.scrollView.clipsToBounds = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor notesBrown];
    
    [self.scrollView addGestureRecognizer:self.swipeGestureUp];
    [self.scrollView addGestureRecognizer:self.swipeGestureDown];
    [self.scrollView addGestureRecognizer:self.pinchGesture];
    [self.scrollView addGestureRecognizer:self.doubleTapGesture];
    
    
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.left.and.right.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuide);
    }];
    
    [self populateStackview];
    
    self.topView = UIView.new;
    [self.view addSubview:self.topView];
    self.topView.userInteractionEnabled = NO;
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


-(void)loadFocusedOnNotification
{
    NSString *theUUID;
    [self.view layoutIfNeeded];
    if([AllTheNotes sharedNotes].launchNotification)
    {
        theUUID = [AllTheNotes sharedNotes].launchNotification.userInfo[@"UUID KEY"];
        
        for (NoteView *eachNote in self.stackView.arrangedSubviews) {
            if([eachNote.UUID isEqualToString:theUUID])
            {
                CGFloat contentWidth = self.scrollView.contentSize.width;
                CGFloat objectFraction = @(eachNote.orderNumber).floatValue / ([AllTheNotes sharedNotes].notesArray.count);
                [UIView animateWithDuration:self.animationDuration
                                      delay:0.0
                                    options: UIViewAnimationOptionCurveEaseIn
                                 animations:^{
                                     if (self.stackView.arrangedSubviews.count > 1)
                                     {
                                         self.scrollView.contentOffset = CGPointMake(objectFraction*contentWidth, 0); //SCROLL TO CONTENT
                                         [self.view layoutIfNeeded];
                                     }
                                 }
                                 completion:nil];
                
            }
        }
        
        [AllTheNotes sharedNotes].launchNotification = nil;
    }
    
}

#pragma mark - WORKING WITH THE NOTES

-(void)populateStackview
{
    self.stackView = [[UIStackView alloc] initWithArrangedSubviews:[self returnSubviewsBasedOnDataStore]];
    
    [self.scrollView addSubview:self.stackView];
    
    if ([AllTheNotes sharedNotes].scrollVertically) {
        self.stackView.axis = UILayoutConstraintAxisVertical;
        [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.scrollView);
            make.centerX.equalTo(self.view);
        }];
    } else
    {
        self.stackView.axis = UILayoutConstraintAxisHorizontal;
        [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.scrollView);
            make.centerY.equalTo(self.view);
        }];
    }
    
    [self.stackView addGestureRecognizer:self.swipeGestureUp];
    [self.stackView addGestureRecognizer:self.swipeGestureDown];
    [self.stackView addGestureRecognizer:self.pinchGesture];
    [self.stackView addGestureRecognizer:self.doubleTapGesture];
    
    self.stackView.backgroundColor = [UIColor blueColor];
    self.stackView.contentMode = UIViewContentModeScaleToFill;
    self.stackView.distribution = UIStackViewDistributionEqualSpacing;
    self.stackView.alignment = UIStackViewAlignmentCenter;
    self.stackView.spacing = 0;
}

-(NSMutableArray *)returnSubviewsBasedOnDataStore
{
    NSMutableArray *mutableSubviews = [@[] mutableCopy];
    for (NoteView *eachNoteView in [AllTheNotes sharedNotes].notesArray)
    {
        eachNoteView.noteSizeValue = [AllTheNotes sharedNotes].currentNoteSize;
        CGFloat fontSize = self.largeFontSize;
        if(!self.zoomedIn)
        {
            fontSize = self.largeFontSize / self.transformScalar;
        }
        eachNoteView.interiorTextBox.font = [UIFont fontWithName:eachNoteView.noteFontName size:fontSize];
        [mutableSubviews addObject:eachNoteView];
    }
    return mutableSubviews;
}

-(void)newNoteViewControllerEditing:(BOOL)areWeEditing noteViewToEdit:(NoteView *)noteViewToEdit
{
    self.veryNewNoteVC = [[NoteViewController alloc] init];
    self.veryNewNoteVC.notificationDate = noteViewToEdit.notificationDate;
    self.veryNewNoteVC.delegate = self;
    self.veryNewNoteVC.layoutGuideSize = [AllTheNotes sharedNotes].navigationBarSize;
    self.veryNewNoteVC.fontSize = self.largeFontSize;
    
    if (areWeEditing)
    {
        self.veryNewNoteVC.theNoteView = noteViewToEdit;
        self.veryNewNoteVC.noteTextView.text = noteViewToEdit.textValue;
        self.veryNewNoteVC.noteOrder = noteViewToEdit.orderNumber;
    } else
    {
        self.veryNewNoteVC.noteOrder = self.stackView.arrangedSubviews.count;
    }
    
    self.veryNewNoteVC.areWeEditing = areWeEditing;
    [self showViewController:self.veryNewNoteVC sender:self];
}



#pragma mark - ADDING NEW NOTES

-(void)addNoteButtonWasPressed:(UIButton *)buttonPressed
{
    
    [self newNoteViewControllerEditing:NO noteViewToEdit:nil];
    
}


-(void)newNoteResult:(NSDictionary *)result updatedNoteView:(NoteView *)updatedNoteView notificationDate:(NSDate *)notificationDate UUID:(NSString *)UUID
{
    [self.navigationController popViewControllerAnimated:YES];
    NSNumber *orderNSNumber = result[@"noteOrder"];
    NSUInteger orderNumber = orderNSNumber.integerValue;
    NSNumber *nsNumberPriority = result[@"priority"];
    NSUInteger priority = nsNumberPriority.integerValue;
    
    if(updatedNoteView)
    {
        updatedNoteView.noteColor = result[@"color"];
        updatedNoteView.textValue = result[@"noteText"];
        updatedNoteView.notePriority = priority;
        updatedNoteView.noteFontName = result[@"fontName"];
        updatedNoteView.notificationDate = notificationDate;
        
    } else //IF WE'RE ADDING A NEW NOTE DO THIS
    {
        NoteView *newNoteView = [[NoteView alloc] initWithText:result[@"noteText"]
                                                      noteSize:self.noteSize
                                                      withDate:nil
                                                   orderNumber:orderNumber
                                                      priority:priority
                                                         color:result[@"color"]
                                                    crossedOut:NO
                                                      fontName:result[@"fontName"]
                                              notificationDate:notificationDate
                                                          UUID:UUID];
        newNoteView.interiorTextBox.font = [UIFont fontWithName:newNoteView.noteFontName size:self.noteSize / self.fontDivisor];

        //ADD THE NOTE TO DATA STORE
        [[AllTheNotes sharedNotes].notesArray insertObject:newNoteView atIndex:orderNumber];
        
        //ADD NOTE TO STACKVIEW
        [self addNoteToView:[AllTheNotes sharedNotes].notesArray[orderNumber] afterNumber:orderNumber];
        updatedNoteView = [AllTheNotes sharedNotes].notesArray[orderNumber];
    }
    
    //REMEMBER OFFSET TO DETERMINE WHETHER OR NOT TO SCROLL
    CGFloat contentOffset = self.scrollView.contentOffset.x;
    [AllTheNotes sortNotesByValue:@[]];
    [self updateNoteOrderNumbers];
    [self setUpEntireScreen];
    [self.view layoutIfNeeded];
    
    //SCROLL HERE TO PROPER NOTE
    CGFloat contentEnd = contentOffset + self.view.frame.size.width;
    CGFloat contentWidth = self.scrollView.contentSize.width;
    CGFloat objectFraction = @([self.stackView.arrangedSubviews indexOfObject:updatedNoteView]).floatValue / ([AllTheNotes sharedNotes].notesArray.count);
    CGFloat fractionalWidth = objectFraction * contentWidth;
    
    if((fractionalWidth > contentOffset) && (fractionalWidth < contentEnd - self.noteSize/3*2)) //NO NEED TO SCROLL TO OBJECT
    {
        //THE SCREEN IS ALREADY CENTERED AROUND WHERE PREVIOUS NOTE SHOULD BE
        self.scrollView.contentOffset = CGPointMake(contentOffset, 0); //SCROLL TO CONTENT
    } else if (self.stackView.arrangedSubviews.count > 1) // WON'T RUN IF THE STACKVIEW WAS PREVIOUSLY EMPTY
    {
        CGFloat notPastEnd = MIN(objectFraction*contentWidth, self.scrollView.contentSize.width - self.view.frame.size.width);
        self.scrollView.contentOffset = CGPointMake(notPastEnd, 0); //SCROLL TO CONTENT
    }
    
    [self.view layoutIfNeeded];
    [AllTheNotes updateDefaultsWithNotes];
}


-(void)addNoteToView:(NoteView *)newNoteView afterNumber:(NSUInteger)orderNumber
{
    [self.stackView insertArrangedSubview:newNoteView atIndex:orderNumber];
    [self updateNoteOrderNumbers];
    
}


#pragma mark - gestures

-(void)pinchReceived:(UIPinchGestureRecognizer *)pinchGestureRecog
{
    CGPoint locationInView = [pinchGestureRecog locationInView:self.view];
    CGFloat offsetFranction = self.scrollView.contentOffset.x / (self.scrollView.contentSize.width - self.view.frame.size.width);
    if ([AllTheNotes sharedNotes].scrollVertically)
    {
        offsetFranction = self.scrollView.contentOffset.y / (self.scrollView.contentSize.height - self.view.frame.size.height);
    }
    
    if(isnan(offsetFranction))
    {
        offsetFranction = 0;
    }
    if (pinchGestureRecog.velocity > 0 && self.noteSize != [AllTheNotes sharedNotes].defaultNoteSize) //ZOOM IN
    {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        self.zoomedIn = YES;
        
        for (NoteView *eachNote in self.stackView.arrangedSubviews) { //FOR ANIMATING FONT SIZE
            eachNote.interiorTextBox.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1/self.transformScalar, 1/self.transformScalar);
            eachNote.interiorTextBox.font = [UIFont fontWithName:eachNote.noteFontName size:self.largeFontSize];
        }
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.noteSize = [AllTheNotes sharedNotes].defaultNoteSize;
                             for (NoteView *eachNote in self.stackView.arrangedSubviews) {
                                 eachNote.noteSizeValue = self.noteSize;
                                 eachNote.interiorTextBox.transform = CGAffineTransformScale(eachNote.interiorTextBox.transform, self.transformScalar, self.transformScalar);  //FOR ANIMATING FONT SIZE
                             }
                             [self testForPaging];
                             //SCROLLING AFTER ZOOM
                             if ([AllTheNotes sharedNotes].scrollVertically)
                             {
                                 self.scrollView.contentOffset = CGPointMake(0,offsetFranction * (self.scrollView.contentSize.height - self.view.frame.size.height) * self.transformScalar + self.view.frame.size.height + (locationInView.y - self.view.frame.size.height/2) * self.transformScalar); //REMOVE THE LAST PART IN ORDER TO STOP ZOOMING IN ON SPECIFIC NOTES AND JUST ZOOM IN GENERAL
                             } else
                             {
                                 self.scrollView.contentOffset = CGPointMake(offsetFranction * (self.scrollView.contentSize.width - self.view.frame.size.width) * self.transformScalar + self.view.frame.size.width + (locationInView.x - self.view.frame.size.width/2) * self.transformScalar, 0); //REMOVE THE LAST PART IN ORDER TO STOP ZOOMING IN ON SPECIFIC NOTES AND JUST ZOOM IN GENERAL
                             }

                             [self.view layoutIfNeeded];
                         }
                         completion:^(BOOL finished) {
                             for (NoteView *eachNote in self.stackView.arrangedSubviews) {
//                                 eachNote.interiorTextBox.transform = CGAffineTransformScale(eachNote.interiorTextBox.transform, 1/self.transformScalar, 1/self.transformScalar);  //FOR ANIMATING FONT SIZE
                                 eachNote.interiorTextBox.font = [UIFont fontWithName:eachNote.noteFontName size:self.largeFontSize];
                                 [self.view layoutIfNeeded];
                             }
                             [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                         }];

    } else if (pinchGestureRecog.velocity < 0 && self.noteSize == [AllTheNotes sharedNotes].defaultNoteSize) //ZOOM OUT
    {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        self.zoomedIn = NO;
        for (NoteView *eachNote in self.stackView.arrangedSubviews) { //FOR ANIMATING FONT SIZE
            eachNote.interiorTextBox.transform = CGAffineTransformScale(CGAffineTransformIdentity, self.transformScalar, self.transformScalar);
            eachNote.interiorTextBox.font = [UIFont fontWithName:eachNote.noteFontName size:self.largeFontSize / self.transformScalar];
        }
        
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:self.animationDuration
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.noteSize = [AllTheNotes sharedNotes].defaultNoteSize / self.transformScalar;
                             for (NoteView *eachNote in self.stackView.arrangedSubviews) {
                                 eachNote.noteSizeValue = self.noteSize;
                                 //FOR ANIMATING FONT SIZE
                                 eachNote.interiorTextBox.transform = CGAffineTransformScale(eachNote.interiorTextBox.transform, 1.0/self.transformScalar, 1.0/self.transformScalar);
                             }
                             [self testForPaging];
                             //SCROLLING TO CORRECT NOTE
                             if([AllTheNotes sharedNotes].scrollVertically)
                             {
                                 self.scrollView.contentOffset = CGPointMake(0,offsetFranction * (self.scrollView.contentSize.height - self.view.frame.size.height) / self.transformScalar - self.view.frame.size.height / self.transformScalar);
                             } else
                             {
                                 self.scrollView.contentOffset = CGPointMake(offsetFranction * (self.scrollView.contentSize.width - self.view.frame.size.width) / self.transformScalar - self.view.frame.size.width / self.transformScalar , 0);
                             }
                             [self.view layoutIfNeeded];
                         }
                         completion:^(BOOL finished) {
                             for (NoteView *eachNote in self.stackView.arrangedSubviews) { //FOR SETTING CORRECT FONT SIZE AFTER ANIMATION
                                 eachNote.interiorTextBox.font = [UIFont fontWithName:eachNote.noteFontName size:self.largeFontSize / self.transformScalar];
                             }
                             [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                         }];

    }
}


-(void)doubleTapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    CGPoint point = [tapGestureRecognizer locationInView:self.stackView];
    CGFloat subviewFraction = point.x / self.stackView.bounds.size.width;
    CGFloat arrayIndexFract = subviewFraction * self.stackView.arrangedSubviews.count;
    if ([AllTheNotes sharedNotes].scrollVertically)
    {
        subviewFraction = point.y / self.stackView.bounds.size.height;
        arrayIndexFract = subviewFraction * self.stackView.arrangedSubviews.count;
        
    }
    NoteView *tappedNoteView = self.stackView.arrangedSubviews[@(arrayIndexFract).integerValue *1];
    [self newNoteViewControllerEditing:YES noteViewToEdit:tappedNoteView];
    
}

-(void)swipeReceived:(UISwipeGestureRecognizer *)swipeGestureRecognizer
{
    if ([AllTheNotes sharedNotes].scrollVertically)
    {
        if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft)
        {
            [self removeNote:swipeGestureRecognizer];
        } else if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight)
        {
            [self crossOutNote:swipeGestureRecognizer];
        }
    } else
    {
        if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionUp)
        {
            [self removeNote:swipeGestureRecognizer];
        } else if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionDown)
        {
            [self crossOutNote:swipeGestureRecognizer];
        }
    }

    
}

-(void)crossOutNote:(UISwipeGestureRecognizer *)swipeGestureRecognizer
{
    CGPoint point = [swipeGestureRecognizer locationInView:self.stackView];
    CGFloat subviewFraction = point.x / self.stackView.bounds.size.width;
    CGFloat arrayIndexFract = subviewFraction * self.stackView.arrangedSubviews.count;
    if ([AllTheNotes sharedNotes].scrollVertically)
    {
        subviewFraction = point.y / self.stackView.bounds.size.height;
        arrayIndexFract = subviewFraction * self.stackView.arrangedSubviews.count;
    }
    
    NoteView *crossOutNoteView = self.stackView.arrangedSubviews[@(arrayIndexFract).integerValue *1];
    [AllTheNotes updateDefaultsWithNotes];
    
    [self.view layoutIfNeeded];
    
    [UIView animateWithDuration:self.animationDuration
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [crossOutNoteView toggleCrossedOut];
                         [AllTheNotes updateDefaultsWithNotes];
                         [self.view layoutIfNeeded];
                     }
                     completion:nil];
    
}

#pragma mark - orientation changed

- (void)orientationChanged:(NSNotification *)notification{
    if(self.lastOrientation == [[UIApplication sharedApplication] statusBarOrientation])
    {
        //NO CHANGE IN ORIENTATION
    } else
    {
        switch ([[UIApplication sharedApplication] statusBarOrientation])
        {
            case UIInterfaceOrientationPortrait:
            {
                CGFloat offset = self.scrollView.contentOffset.x;
                [AllTheNotes sharedNotes].scrollVertically = YES;
                [self setUpEntireScreen];
                [self.view layoutIfNeeded];
                self.scrollView.contentOffset = CGPointMake(0, offset);
                [self.view layoutIfNeeded];
            }
                self.lastOrientation = [[UIApplication sharedApplication] statusBarOrientation];
                break;
            case UIInterfaceOrientationLandscapeLeft:
            case UIInterfaceOrientationLandscapeRight:
            {
                //load the landscape view
                CGFloat offset = self.scrollView.contentOffset.y;
                [AllTheNotes sharedNotes].scrollVertically = NO;
                [self setUpEntireScreen];
                [self.view layoutIfNeeded];
                self.scrollView.contentOffset = CGPointMake(offset,0);
                [self.view layoutIfNeeded];
            }
                self.lastOrientation = [[UIApplication sharedApplication] statusBarOrientation];
                break;
            case UIInterfaceOrientationPortraitUpsideDown:break;
            case UIInterfaceOrientationUnknown:break;
        }
    }
}


#pragma mark - remove and undo remove

-(void)removeNote:(UISwipeGestureRecognizer *)swipeGestureRecognizer
{
    CGPoint point = [swipeGestureRecognizer locationInView:self.stackView];
    CGPoint pointInWindow = [swipeGestureRecognizer locationInView:self.view];
    CGFloat subviewFraction = point.x / self.stackView.bounds.size.width;
    CGFloat arrayIndexFract = subviewFraction * self.stackView.arrangedSubviews.count;
    
    if ([AllTheNotes sharedNotes].scrollVertically)
    {
        subviewFraction = point.y / self.stackView.bounds.size.height;
        arrayIndexFract = subviewFraction * self.stackView.arrangedSubviews.count;
    }
    
//    NSLog(@". \n point in stack: %@ \n point in view: %@ \n index fract: %1.3f \n index # %lu \n subview count: %lu",NSStringFromCGPoint(point),NSStringFromCGPoint(pointInWindow), subviewFraction * self.stackView.arrangedSubviews.count,@(arrayIndexFract).integerValue *1 ,self.stackView.arrangedSubviews.count);
    [self updateNoteOrderNumbers];
    NoteView *oldNoteView = self.stackView.arrangedSubviews[@(arrayIndexFract).integerValue *1];
    
//    CGPoint relativeToWindow = [oldNoteView convertPoint:oldNoteView.bounds.origin toView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
    CGPoint relativeToWindow = [oldNoteView convertPoint:oldNoteView.bounds.origin toView:self.view];
    
    [UIView animateWithDuration:self.animationDuration * 2 / 3
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         oldNoteView.hidden = YES;
                         [[AllTheNotes sharedNotes].deletedArray addObject:oldNoteView];
                         [oldNoteView removeFromSuperview];
                         [self.view layoutIfNeeded];
                     }
                     completion:nil];
    
    
    NoteView *animatedNote = [[NoteView alloc] initWithNoteView:oldNoteView];
    
    [self.topView addSubview:animatedNote];
    
    [animatedNote mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(relativeToWindow.x);
        make.top.equalTo(self.view).offset(relativeToWindow.y);
    }];
    
    [self.view layoutIfNeeded];
    animatedNote.interiorTextBox.transform = CGAffineTransformScale(animatedNote.interiorTextBox.transform, 2, 2);
    animatedNote.interiorTextBox.font = [UIFont fontWithName:animatedNote.noteFontName size:self.noteSize / self.fontDivisor / 2];
    [UIView animateWithDuration:self.animationDuration * 2 / 3
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         if([AllTheNotes sharedNotes].scrollVertically)
                         {
                             [animatedNote mas_remakeConstraints:^(MASConstraintMaker *make) {
                                 make.right.equalTo(self.view.mas_left);
                                 make.centerY.equalTo(self.view.mas_top).offset(pointInWindow.y);
                                 make.height.and.width.equalTo(@(self.noteSize/2.0));
                             }];
                         } else
                         {
                             [animatedNote mas_remakeConstraints:^(MASConstraintMaker *make) {
                                 make.bottom.equalTo(self.view.mas_top);
                                 make.centerX.equalTo(self.view.mas_left).offset(pointInWindow.x);
                                 make.height.and.width.equalTo(@(self.noteSize/2.0));
                             }];
                         }
                         

                         animatedNote.interiorTextBox.transform = CGAffineTransformScale(animatedNote.interiorTextBox.transform, 1.0/2, 1.0/2);
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         [animatedNote removeFromSuperview];
                         [AllTheNotes updateDefaultsWithNotes];
                     }];
    [self checkIfUndoShouldInteract];
    [self updateNoteOrderNumbers];
    [AllTheNotes renumberBadgesOfPendingNotifications];
}

-(void)undoLastDeletion:(UIButton *)buttonPressed
{
    [self killScroll];
    if([AllTheNotes sharedNotes].deletedArray.lastObject)
    {
        NoteView *lastDeletion = [[NoteView alloc] initWithNoteView:[AllTheNotes sharedNotes].deletedArray.lastObject];
        lastDeletion.notificationDate = lastDeletion.notificationDate;
        CGFloat contentOffset = self.scrollView.contentOffset.x;
        CGFloat contentEnd = self.scrollView.contentOffset.x + self.view.frame.size.width;
        CGFloat contentWidth = self.scrollView.contentSize.width;
        CGFloat objectFraction = @(lastDeletion.orderNumber).floatValue / ([AllTheNotes sharedNotes].notesArray.count);
        CGFloat fractionalWidth = objectFraction * contentWidth;
        
        if ([AllTheNotes sharedNotes].scrollVertically)
        {
            contentOffset = self.scrollView.contentOffset.y;
            contentEnd = self.scrollView.contentOffset.y + self.view.frame.size.height;
            contentWidth = self.scrollView.contentSize.height;
            objectFraction = @(lastDeletion.orderNumber).floatValue / ([AllTheNotes sharedNotes].notesArray.count);
            fractionalWidth = objectFraction * contentWidth;
        }
        
        lastDeletion.interiorTextBox.font = [UIFont fontWithName:lastDeletion.noteFontName size:self.noteSize / self.fontDivisor];
        lastDeletion.noteSizeValue = self.noteSize;
        [[AllTheNotes sharedNotes].deletedArray removeObject:[AllTheNotes sharedNotes].deletedArray.lastObject];
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             [self.stackView insertArrangedSubview:lastDeletion atIndex:lastDeletion.orderNumber];
                             [[AllTheNotes sharedNotes].notesArray insertObject:lastDeletion atIndex:lastDeletion.orderNumber];
                             if((fractionalWidth > contentOffset) && (fractionalWidth < contentEnd - self.noteSize/2)) //SCROLLS TO THE OBJECT
                             {
                                 //THE SCREEN IS ALREADY CENTERED AROUND WHERE PREVIOUS NOTE SHOULD BE
                             } else if (self.stackView.arrangedSubviews.count > 1) // WON'T RUN IF THE STACKVIEW WAS PREVIOUSLY EMPTY
                             {
                                 if ([AllTheNotes sharedNotes].scrollVertically)
                                 {
                                     self.scrollView.contentOffset = CGPointMake(0,objectFraction*contentWidth); //SCROLL TO CONTENT
                                 } else
                                 {
                                     self.scrollView.contentOffset = CGPointMake(objectFraction*contentWidth, 0); //SCROLL TO CONTENT
                                 }
                             }
                             
                             
                             [self.view layoutIfNeeded];
                         }
                         completion:^(BOOL finished) {
                             
                             [UIView animateWithDuration:0.1
                                                   delay:0.0
                                                 options:UIViewAnimationCurveEaseInOut | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
                                              animations:^{
                                                  [UIView setAnimationRepeatCount:3];
                                                  lastDeletion.backgroundColor = [UIColor notesMilk];
                                                  [self.view layoutIfNeeded];
                                              } completion:^(BOOL finished) {
                                                  lastDeletion.backgroundColor = [UIColor clearColor];
                                                  [self.view layoutIfNeeded];
                                              }];
                             
                         }];
        
        [self updateNoteOrderNumbers];
    }
    [self checkIfUndoShouldInteract];
}

#pragma mark - settings

-(void)settingsButtonPressed:(UIButton *)buttonPressed
{
    self.settingsTableVC = [[SettingsTableViewController alloc] init];
    self.settingsTableVC.delegate = self;
    [self showViewController:self.settingsTableVC sender:self];
    
}
-(void)changeInSettings:(NSString *)theChange
{
    NSLog(@"ran change in settings delegate method");
    if([AllTheNotes sharedNotes].fontDivisor != self.fontDivisor)
    {
        NSLog(@"font divisor changed and re-set up screen");
        self.fontDivisor = [AllTheNotes sharedNotes].fontDivisor;
    }
    
    [AllTheNotes sortNotesByValue:@[]];
    [self setUpEntireScreen];
    [self checkIfUndoShouldInteract];
    
}



#pragma mark - scrolling

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    id i;
    i = i;
    [super touchesEnded:touches withEvent:event];
    NSLog(@"user touched this object: %@",touches.anyObject.view.class);
}




//-(BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
//{
//
//    return YES;
//}

//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
//    CGFloat pageWidth = self.noteSize + scrollView.contentInset.left;
//    CGFloat pageX = self.pageIndex*pageWidth-scrollView.contentInset.left;
//    CGFloat pagesScrolled = (targetContentOffset->x - pageX)/ pageWidth;
//    if (targetContentOffset->x<pageX)
//    {
//        if (self.pageIndex>0) {
//            self.pageIndex += pagesScrolled;
//        }
//    }
//    else if(targetContentOffset->x>pageX){
//        if (self.pageIndex<self.stackView.arrangedSubviews.count)
//        {
//            self.pageIndex += pagesScrolled;
//        }
//    }
//    targetContentOffset->x = self.pageIndex*pageWidth-scrollView.contentInset.left;
//    NSLog(@"%lu %d", self.pageIndex, (int)targetContentOffset->x);
//}

#pragma mark - alert view controller
-(void)displayAlertViewController:(NSString *)title
                          message:(NSString *)message
                       completion:(void (^)(bool alertResult))completionBlock
{
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:title
                                message:message
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yesButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDestructive
                                handler:^(UIAlertAction * action)
                                {
//                                    completionBlock(YES);
                                }];
        [alert addAction:yesButton];
//    UIAlertAction *noButton = [UIAlertAction
//                               actionWithTitle:@"No"
//                               style:UIAlertActionStyleDefault
//                               handler:nil];
//    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


#pragma mark - update order
-(void)updateNoteOrderNumbers
{
    NSUInteger i = 0;
    i = 0;
    
    for (NoteView *eachNoteView in self.stackView.arrangedSubviews) {
        eachNoteView.orderNumber = i;
        i++;
    }
    [AllTheNotes renumberBadgesOfPendingNotifications];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - helpers


- (void)killScroll
{
    CGPoint offset = self.scrollView.contentOffset;
    [self.scrollView setContentOffset:offset animated:NO];
}

-(void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
    [super traitCollectionDidChange:previousTraitCollection];
    
    [self testForPaging];
}

-(void)checkIfAlarmsHavePassed
{
    for (NoteView *eachNote in self.stackView.arrangedSubviews) {
        [eachNote iconForNotification];
    }
}

-(void)testForPaging
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if ((orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown) && self.zoomedIn)
    {
        self.scrollView.pagingEnabled = YES;
    } else
    {
        self.scrollView.pagingEnabled = NO;
    }
    if ([AllTheNotes sharedNotes].scrollVertically)
    {
        self.scrollView.pagingEnabled = NO;
    }
}


-(void)checkIfUndoShouldInteract
{
    if([AllTheNotes sharedNotes].deletedArray.count > 0)
    {
        self.undoBarButton.enabled = YES;
    } else
    {
        self.undoBarButton.enabled = NO;
    }
}

-(void)setScreenHeightandWidth
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.screenHeight = MAX(screenSize.width, screenSize.height);
    self.screenWidth = MIN(screenSize.width, screenSize.height);
}

-(void)setNoteSize:(CGFloat)noteSize
{
    _noteSize = noteSize;
    [AllTheNotes sharedNotes].currentNoteSize = noteSize;
}
-(void)setFontDivisor:(CGFloat)fontDivisor
{
    _fontDivisor = fontDivisor;
    self.largeFontSize = [AllTheNotes sharedNotes].defaultNoteSize / self.fontDivisor;
    
}

-(void)setZoomedIn:(BOOL)zoomedIn
{
    _zoomedIn = zoomedIn;
    [AllTheNotes sharedNotes].zoomedIn = zoomedIn;
    [AllTheNotes updateDefaultsWithSettings];
    
    if ([AllTheNotes sharedNotes].scrollVertically)
    {
        
    } else
    {
        
    }
}


@end
