//
//  SettingsViewController.m
//  notes-flick
//
//  Created by JASON HARRIS on 1/15/16.
//  Copyright © 2016 jason harris. All rights reserved.
//

#import "SettingsViewController.h"
#import "NotesColor.h"
#import "AllTheNotes.h"
#import <Masonry.h>

@interface SettingsViewController ()
@property (nonatomic, assign) CGFloat offsetSpacing;


@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor notesBrown];
    self.navigationController.navigationBar.tintColor = [UIColor notesBrown];
    self.offsetSpacing = 10;
    // Do any additional setup after loading the view.
    
    [self addFontMenuItems];
    [self setUpSortOptions];
}

-(void)addFontMenuItems
{
    self.fontSlider = [[UISlider alloc] init];
    self.fontSlider.minimumValue = 0.0;
    self.fontSlider.maximumValue = 8.0;
    self.fontSlider.value = 12 - self.fontDivisor;
//    self.fontSlider.continuous = NO;
    self.fontSlider.minimumTrackTintColor = [UIColor notesMilk];
    self.fontSlider.maximumTrackTintColor = [UIColor notesMilk];
    
    [self.fontSlider addTarget:self
                        action:@selector(fontSliderValueChanged:)
              forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.fontSlider];
    [self.fontSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(self.offsetSpacing);
        make.right.equalTo(self.view).offset(-self.offsetSpacing);
        make.left.equalTo(self.view.mas_right).offset(-[AllTheNotes sharedNotes].screenWidth / 2);
    }];
}

-(void)setUpSortOptions
{
    self.sortSegments = [[UISegmentedControl alloc] initWithItems:@[@"Date Created",
                                                                    @"Color",
                                                                    @"Completed"
                                                                    ]];
    [self.view addSubview:self.sortSegments];
    [self.sortSegments mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.top.equalTo(self.fontSlider.mas_bottom).offset(10);
    }];
}


-(void)fontSliderValueChanged:(UISlider *)slider
{
    [AllTheNotes sharedNotes].fontDivisor = 12 - self.fontSlider.value;
    [AllTheNotes updateDefaultsWithSettings];
    
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
