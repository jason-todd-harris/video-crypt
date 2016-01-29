//
//  ScrollView.m
//  notes-flick
//
//  Created by JASON HARRIS on 1/29/16.
//  Copyright © 2016 jason harris. All rights reserved.
//

#import "ScrollView.h"
#import "ViewController.h"
#import <Masonry.h>
#import "NoteViewController.h"
#import "NoteView.h"
#import "NotesColor.h"
#import "SettingsViewController.h"
#import "SettingsTableViewController.h"

@interface ScrollView () <UIGestureRecognizerDelegate, UIScrollViewDelegate, NoteViewControllerDelegate, SettingsTableViewControllerDelegate>




@end



@implementation ScrollView



-(instancetype)init
{
    self = [super init];
    if(self)
    {
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
    return self;
}


-(void)proxyViewWillAppear
{
    [self checkIfAlarmsHavePassed];
}

-(void)proxyViewDidAppear
{
    if(!self.alreadyLoaded)
    {
        [self runOnFirstLoad];
    }
}


-(void)runOnFirstLoad
{
    [self setScreenHeightandWidth];
    [self setUpEntireScreen];
    [self loadFocusedOnNotification];
    self.alreadyLoaded = YES;
    
}



#pragma mark - screen setup


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
    
    
    self.delegate = self;
    self.userInteractionEnabled = YES;
    self.directionalLockEnabled = NO;
    [self testForPaging];
    self.clipsToBounds = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.backgroundColor = [UIColor notesBrown];
    
    [self addGestureRecognizer:self.swipeGestureUp];
    [self addGestureRecognizer:self.swipeGestureDown];
    [self addGestureRecognizer:self.pinchGesture];
    [self addGestureRecognizer:self.doubleTapGesture];
    
    
    NSLog(@"VDERT %u",[AllTheNotes sharedNotes].scrollVertically);
    if ([AllTheNotes sharedNotes].scrollVertically)
    {
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.and.left.equalTo(self.superview);
            make.right.equalTo(self.superview).offset(-self.superview.frame.size.width / 2);
            make.top.equalTo(self.superview.mas_topMargin);
        }];
    } else
    {
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.and.left.equalTo(self.superview);
            make.bottom.equalTo(self.superview).offset(-self.superview.frame.size.height /2 +64/2);
            make.top.equalTo(self.superview.mas_topMargin);
        }];
    }
    
    
    [self populateStackview];
    self.topView = UIView.new;
    self.topView.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.90];
    [self addSubview:self.topView];
    self.topView.userInteractionEnabled = NO;
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}


-(void)loadFocusedOnNotification
{
    NSString *theUUID;
    [self.superview layoutIfNeeded];
    if([AllTheNotes sharedNotes].launchNotification)
    {
        theUUID = [AllTheNotes sharedNotes].launchNotification.userInfo[@"UUID KEY"];
        
        for (NoteView *eachNote in self.stackView.arrangedSubviews) {
            if([eachNote.UUID isEqualToString:theUUID])
            {
                CGFloat contentWidth = self.contentSize.width;
                CGFloat objectFraction = @(eachNote.orderNumber).floatValue / ([AllTheNotes sharedNotes].notesArray.count);
                [UIView animateWithDuration:self.animationDuration
                                      delay:0.0
                                    options: UIViewAnimationOptionCurveEaseIn
                                 animations:^{
                                     if (self.stackView.arrangedSubviews.count > 1)
                                     {
                                         self.contentOffset = CGPointMake(objectFraction*contentWidth, 0); //SCROLL TO CONTENT
                                         [self.superview layoutIfNeeded];
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
    
    [self addSubview:self.stackView];
    
    if ([AllTheNotes sharedNotes].scrollVertically) {
        self.stackView.axis = UILayoutConstraintAxisVertical;
        [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
            make.centerX.equalTo(self);
        }];
    } else
    {
        self.stackView.axis = UILayoutConstraintAxisHorizontal;
        [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
            make.centerY.equalTo(self);
        }];
    }
    
    [self.stackView addGestureRecognizer:self.swipeGestureUp];
    [self.stackView addGestureRecognizer:self.swipeGestureDown];
    [self.stackView addGestureRecognizer:self.pinchGesture];
    [self.stackView addGestureRecognizer:self.doubleTapGesture];
    
    self.stackView.backgroundColor = [UIColor blueColor];
    
    //DEBUG
    self.stackView.backgroundColor = [UIColor greenColor];
    self.stackView.contentMode = UIViewContentModeScaleToFill;
    self.stackView.distribution = UIStackViewDistributionEqualSpacing;
    self.stackView.alignment = UIStackViewAlignmentCenter;
    self.stackView.spacing = 0;
    UIView *dummy = [[UIView alloc] init];
    dummy.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.33];
    [self.stackView addSubview:dummy];
    [dummy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.stackView);
    }];
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


#pragma mark - second stack view



-(NSMutableArray *)returnSubviewsBasedOnDataStoreTWO
{
    NSMutableArray *mutableSubviews = [@[] mutableCopy];
    for (NoteView *eachNoteView in [AllTheNotes sharedNotes].secondNotesArraty)
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

#pragma mark - ADDING NEW NOTES


-(void)newNoteResult:(NSDictionary *)result updatedNoteView:(NoteView *)updatedNoteView notificationDate:(NSDate *)notificationDate UUID:(NSString *)UUID
{
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
    CGFloat contentOffset = self.contentOffset.x;
    [AllTheNotes sortNotesByValue:@[]];
    [self updateNoteOrderNumbers];
    [self setUpEntireScreen];
    [self.superview layoutIfNeeded];
    
    //SCROLL HERE TO PROPER NOTE
    CGFloat contentEnd = contentOffset + self.superview.frame.size.width;
    CGFloat contentWidth = self.contentSize.width;
    CGFloat objectFraction = @([self.stackView.arrangedSubviews indexOfObject:updatedNoteView]).floatValue / ([AllTheNotes sharedNotes].notesArray.count);
    CGFloat fractionalWidth = objectFraction * contentWidth;
    
    if((fractionalWidth > contentOffset) && (fractionalWidth < contentEnd - self.noteSize/3*2)) //NO NEED TO SCROLL TO OBJECT
    {
        //THE SCREEN IS ALREADY CENTERED AROUND WHERE PREVIOUS NOTE SHOULD BE
        self.contentOffset = CGPointMake(contentOffset, 0); //SCROLL TO CONTENT
    } else if (self.stackView.arrangedSubviews.count > 1) // WON'T RUN IF THE STACKVIEW WAS PREVIOUSLY EMPTY
    {
        CGFloat notPastEnd = MIN(objectFraction*contentWidth, self.contentSize.width - self.superview.frame.size.width);
        self.contentOffset = CGPointMake(notPastEnd, 0); //SCROLL TO CONTENT
    }
    
    [self.superview layoutIfNeeded];
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
    CGPoint locationInView = [pinchGestureRecog locationInView:self.superview];
    CGFloat offsetFranction = self.contentOffset.x / (self.contentSize.width - self.superview.frame.size.width);
    if ([AllTheNotes sharedNotes].scrollVertically)
    {
        offsetFranction = self.contentOffset.y / (self.contentSize.height - self.superview.frame.size.height);
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
                                 self.contentOffset = CGPointMake(0,offsetFranction * (self.contentSize.height - self.superview.frame.size.height) * self.transformScalar + self.superview.frame.size.height + (locationInView.y - self.superview.frame.size.height/2) * self.transformScalar); //REMOVE THE LAST PART IN ORDER TO STOP ZOOMING IN ON SPECIFIC NOTES AND JUST ZOOM IN GENERAL
                             } else
                             {
                                 self.contentOffset = CGPointMake(offsetFranction * (self.contentSize.width - self.superview.frame.size.width) * self.transformScalar + self.superview.frame.size.width + (locationInView.x - self.superview.frame.size.width/2) * self.transformScalar, 0); //REMOVE THE LAST PART IN ORDER TO STOP ZOOMING IN ON SPECIFIC NOTES AND JUST ZOOM IN GENERAL
                             }
                             
                             [self.superview layoutIfNeeded];
                         }
                         completion:^(BOOL finished) {
                             for (NoteView *eachNote in self.stackView.arrangedSubviews) {
                                 //                                 eachNote.interiorTextBox.transform = CGAffineTransformScale(eachNote.interiorTextBox.transform, 1/self.transformScalar, 1/self.transformScalar);  //FOR ANIMATING FONT SIZE
                                 eachNote.interiorTextBox.font = [UIFont fontWithName:eachNote.noteFontName size:self.largeFontSize];
                                 [self.superview layoutIfNeeded];
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
        
        [self.superview layoutIfNeeded];
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
                                 self.contentOffset = CGPointMake(0,offsetFranction * (self.contentSize.height - self.superview.frame.size.height) / self.transformScalar - self.superview.frame.size.height / self.transformScalar);
                             } else
                             {
                                 self.contentOffset = CGPointMake(offsetFranction * (self.contentSize.width - self.superview.frame.size.width) / self.transformScalar - self.superview.frame.size.width / self.transformScalar , 0);
                             }
                             [self.superview layoutIfNeeded];
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
    
    [self.superview layoutIfNeeded];
    
    [UIView animateWithDuration:self.animationDuration
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [crossOutNoteView toggleCrossedOut];
                         [AllTheNotes updateDefaultsWithNotes];
                         [self.superview layoutIfNeeded];
                     }
                     completion:nil];
    
}

#pragma mark - remove and undo remove

-(void)removeNote:(UISwipeGestureRecognizer *)swipeGestureRecognizer
{
    CGPoint point = [swipeGestureRecognizer locationInView:self.stackView];
    CGPoint pointInWindow = [swipeGestureRecognizer locationInView:self.superview];
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
    CGPoint relativeToWindow = [oldNoteView convertPoint:oldNoteView.bounds.origin toView:self.superview];
    
    [UIView animateWithDuration:self.animationDuration * 2 / 3
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         oldNoteView.hidden = YES;
                         [[AllTheNotes sharedNotes].deletedArray addObject:oldNoteView];
                         [oldNoteView removeFromSuperview];
                         [self.superview layoutIfNeeded];
                     }
                     completion:nil];
    
    
    NoteView *animatedNote = [[NoteView alloc] initWithNoteView:oldNoteView];
    
    [self.topView addSubview:animatedNote];
    
    [animatedNote mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.superview).offset(relativeToWindow.x);
        make.top.equalTo(self.superview).offset(relativeToWindow.y);
    }];
    
    [self.superview layoutIfNeeded];
    animatedNote.interiorTextBox.transform = CGAffineTransformScale(animatedNote.interiorTextBox.transform, 2, 2);
    animatedNote.interiorTextBox.font = [UIFont fontWithName:animatedNote.noteFontName size:self.noteSize / self.fontDivisor / 2];
    [UIView animateWithDuration:self.animationDuration * 2 / 3
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         if([AllTheNotes sharedNotes].scrollVertically)
                         {
                             [animatedNote mas_remakeConstraints:^(MASConstraintMaker *make) {
                                 make.right.equalTo(self.superview.mas_left);
                                 make.centerY.equalTo(self.superview.mas_top).offset(pointInWindow.y);
                                 make.height.and.width.equalTo(@(self.noteSize/2.0));
                             }];
                         } else
                         {
                             [animatedNote mas_remakeConstraints:^(MASConstraintMaker *make) {
                                 make.bottom.equalTo(self.superview.mas_top);
                                 make.centerX.equalTo(self.superview.mas_left).offset(pointInWindow.x);
                                 make.height.and.width.equalTo(@(self.noteSize/2.0));
                             }];
                         }
                         
                         
                         animatedNote.interiorTextBox.transform = CGAffineTransformScale(animatedNote.interiorTextBox.transform, 1.0/2, 1.0/2);
                         [self.superview layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         [animatedNote removeFromSuperview];
                         [AllTheNotes updateDefaultsWithNotes];
                     }];
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
        CGFloat contentOffset = self.contentOffset.x;
        CGFloat contentEnd = self.contentOffset.x + self.superview.frame.size.width;
        CGFloat contentWidth = self.contentSize.width;
        CGFloat objectFraction = @(lastDeletion.orderNumber).floatValue / ([AllTheNotes sharedNotes].notesArray.count);
        CGFloat fractionalWidth = objectFraction * contentWidth;
        
        if ([AllTheNotes sharedNotes].scrollVertically)
        {
            contentOffset = self.contentOffset.y;
            contentEnd = self.contentOffset.y + self.superview.frame.size.height;
            contentWidth = self.contentSize.height;
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
                                     self.contentOffset = CGPointMake(0,objectFraction*contentWidth); //SCROLL TO CONTENT
                                 } else
                                 {
                                     self.contentOffset = CGPointMake(objectFraction*contentWidth, 0); //SCROLL TO CONTENT
                                 }
                             }
                             
                             
                             [self.superview layoutIfNeeded];
                         }
                         completion:^(BOOL finished) {
                             
                             [UIView animateWithDuration:0.1
                                                   delay:0.0
                                                 options:UIViewAnimationCurveEaseInOut | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
                                              animations:^{
                                                  [UIView setAnimationRepeatCount:3];
                                                  lastDeletion.backgroundColor = [UIColor notesMilk];
                                                  [self.superview layoutIfNeeded];
                                              } completion:^(BOOL finished) {
                                                  lastDeletion.backgroundColor = [UIColor clearColor];
                                                  [self.superview layoutIfNeeded];
                                              }];
                             
                         }];
        
        [self updateNoteOrderNumbers];
    }
}

#pragma mark - settings

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
    
}



#pragma mark - scrolling

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    id i;
    i = i;
    [super touchesEnded:touches withEvent:event];
    NSLog(@"user touched this object: %@",touches.anyObject.view.class);
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


#pragma mark - helpers


- (void)killScroll
{
    CGPoint offset = self.contentOffset;
    [self setContentOffset:offset animated:NO];
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
        self.pagingEnabled = YES;
    } else
    {
        self.pagingEnabled = NO;
    }
    if ([AllTheNotes sharedNotes].scrollVertically)
    {
        self.pagingEnabled = NO;
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

