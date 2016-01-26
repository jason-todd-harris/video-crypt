//
//  DatePickerVC.m
//  notes-flick
//
//  Created by JASON HARRIS on 1/26/16.
//  Copyright © 2016 jason harris. All rights reserved.
//

#import "DatePickerVC.h"
#import "NoteViewController.h" 
#import "AllTheNotes.h"
#import "NotesColor.h"
#import <Masonry.h>

@interface DatePickerVC ()
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *saveButton;

@end

@implementation DatePickerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self vibrancyEffects];
    [self setUpDatePicker];
    [self setUpCancelAndSaveButtons];
}

-(void)setUpDatePicker
{
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    self.datePicker.minimumDate = [NSDate date];
    [self.view addSubview:self.datePicker];
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(self.view.frame.size.height/10);
    }];
    self.datePicker.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.35];
    self.datePicker.layer.borderWidth = 3;
    self.datePicker.layer.cornerRadius = 15;
    self.datePicker.layer.masksToBounds = YES;
    
    [self.datePicker setValue:[UIColor blackColor] forKeyPath:@"textColor"];
    
}

-(void)setUpCancelAndSaveButtons
{
    self.saveButton = [[UIButton alloc] init];
    [self.saveButton addTarget:self
                        action:@selector(savePressed)
              forControlEvents:UIControlEventTouchUpInside];
    [self.saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.saveButton setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.saveButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.35];
    self.saveButton.layer.borderWidth = 3;
    self.saveButton.layer.cornerRadius = 15;
    
    self.cancelButton = [[UIButton alloc] init];
    [self.cancelButton addTarget:self
                        action:@selector(cancelPressed)
              forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.cancelButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.35];
    self.cancelButton.layer.borderWidth = 3;
    self.cancelButton.layer.cornerRadius = 15;
    
    
    [self.view addSubview:self.saveButton];
    [self.view addSubview:self.cancelButton];
    
    CGFloat offset = 3;
    
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.datePicker.mas_bottom).offset(offset);
        make.left.equalTo(self.datePicker);
        make.right.equalTo(self.view.mas_centerX).offset(-offset/2);
        make.height.equalTo(@(75));
    }];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.saveButton);
        make.left.equalTo(self.view.mas_centerX).offset(offset/2);
        make.right.equalTo(self.datePicker);
        make.height.equalTo(self.saveButton);
    }];
    
}

-(void)savePressed
{
    
    NSLog(@"save");
}

-(void)cancelPressed
{
    NSLog(@"cancel");
}

-(void)vibrancyEffects
{
    UIView *behindVisualEffect = [[UIView alloc] init];
    behindVisualEffect.alpha = 1; //supported,, don't change on UIVisualEffectView
    [self.view addSubview:behindVisualEffect];
    [behindVisualEffect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(behindVisualEffect.superview);
    }];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [behindVisualEffect addSubview:visualEffectView];
    
    [visualEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
    UIVisualEffectView *vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
    [visualEffectView.contentView addSubview:vibrancyEffectView];
    
    [vibrancyEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
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
