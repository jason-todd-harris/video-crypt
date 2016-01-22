//
//  FontViewController.m
//  notes-flick
//
//  Created by JASON HARRIS on 1/22/16.
//  Copyright © 2016 jason harris. All rights reserved.
//

#import "FontViewController.h"
#import "SettingsViewController.h"
#import "NotesColor.h"
#import "AllTheNotes.h"
#import "SortOrderTableViewController.h"
#import <Masonry.h>


@interface FontViewController ()
@property (nonatomic, assign) CGFloat fontDivisor;
@property (nonatomic, assign) CGFloat offsetSpacing;

@end

@implementation FontViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor notesBrown];
    self.view.backgroundColor = [UIColor notesBrown];
    self.fontDivisor = [AllTheNotes sharedNotes].fontDivisor;
    self.offsetSpacing = 10;
    [self addFontMenuItems];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)fontSliderValueChanged:(UISlider *)slider
{
    [AllTheNotes sharedNotes].fontDivisor = 12 - self.fontSlider.value;
    self.fontDivisor = [AllTheNotes sharedNotes].fontDivisor;
    [AllTheNotes updateDefaultsWithSettings];
    
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
