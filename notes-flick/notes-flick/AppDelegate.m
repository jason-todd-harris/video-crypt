//
//  AppDelegate.m
//  notes-flick
//
//  Created by JASON HARRIS on 12/23/15.
//  Copyright © 2015 jason harris. All rights reserved.
//

#import "AppDelegate.h"
#import "AllTheNotes.h"
#import "NoteView.h"


@interface AppDelegate ()
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [self setScreenHeightandWidth];
    [AllTheNotes sharedNotes].navigationBarSize = 64;
    [AllTheNotes sharedNotes].defaultNoteSize = self.screenWidth;
    [AllTheNotes sharedNotes].currentNoteSize = [AllTheNotes sharedNotes].defaultNoteSize;
    [AllTheNotes settingsFromNSDefaults];
    [AllTheNotes updateAppNotesFromNSDefaults];
//    [self setUpSomeDummyNotes];
    
    return YES;
}

-(void)setUpSomeDummyNotes
{
    NSUInteger i = 0;
    NSMutableArray *mutableNotes = [@[] mutableCopy];
    NSMutableArray *defaultNotes = [@[] mutableCopy];// [AllTheNotes sharedNotes].notesArray;
    for (i = 0; i <13; i++)
    {
        
        NSString *string = [NSString stringWithFormat:@"%@ text",@(i+1).stringValue];
//        string = [UIColor stringFromColor:[AllTheNotes sharedNotes].colorArray[i%5]];
        UIColor *color;
        if(i<3)
        {
            color = [AllTheNotes sharedNotes].colorArray[0];
        } else if (i < 6)
        {
            color = [AllTheNotes sharedNotes].colorArray[1];
        } else if (i < 9)
        {
            color = [AllTheNotes sharedNotes].colorArray[2];
        } else if (i < 13)
        {
            color = [AllTheNotes sharedNotes].colorArray[3];
        }
        
        
        NoteView *dummyNote = [[NoteView alloc] initWithText:string
                                                    noteSize:0
                                                    withDate:nil
                                                 orderNumber:i
                                                    priority:1
                                                       color:color
                                                  crossedOut:NO
                                                    fontName:nil
                                            notificationDate:nil
                                                        UUID:nil];
        [mutableNotes addObject:dummyNote];
    }
    
    [defaultNotes addObjectsFromArray:mutableNotes];
    [AllTheNotes sharedNotes].notesArray = defaultNotes;
    [AllTheNotes updateDefaultsWithNotes];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
}

-(void)setScreenHeightandWidth
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.screenHeight = MAX(screenSize.width, screenSize.height);
    self.screenWidth = MIN(screenSize.width, screenSize.height);
    [AllTheNotes sharedNotes].screenHeight = self.screenHeight;
    [AllTheNotes sharedNotes].screenWidth = self.screenWidth;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "jason.harris.notes_flick" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"notes_flick" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"notes_flick.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
