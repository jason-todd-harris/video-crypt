//
//  ViewController.m
//  NJ JAMZIT
//
//  Created by JASON HARRIS on 5/6/16.
//  Copyright © 2016 jason harris. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import "SimulationController.h"

@interface ViewController () <UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *numberOfPeopleLabel;
@property (nonatomic, strong) UIPickerView *numberOfPeoplePicker;

@property (nonatomic, strong) UIButton *picturePickerButton;
@property (nonatomic, strong) UIButton *startSimulation;
@property (nonatomic, strong) SimulationController *simulationController;
    


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self setUpButtonsAndFields];
    
}



-(void)simulateNow
{
    self.simulationController = [[SimulationController alloc] init];
    self.simulationController.ticketView = self.imageView;
    self.simulationController.numOfPeople = [self.numberOfPeoplePicker selectedRowInComponent:0]+1;
    [self showViewController:self.simulationController sender:self];
    
}




-(void)setUpButtonsAndFields
{
    self.picturePickerButton = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [self.picturePickerButton addTarget:self action:@selector(selectPhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.picturePickerButton];
    self.picturePickerButton.backgroundColor = [UIColor blueColor];
    [self.picturePickerButton setTitle:@"SELECT PICTURE" forState:UIControlStateNormal];
    [self.picturePickerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.picturePickerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(15);
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(@75);
        make.centerX.equalTo(self.view);
    }];
    
    
    self.numberOfPeoplePicker = [[UIPickerView alloc] init];
    self.numberOfPeoplePicker.backgroundColor = [UIColor lightGrayColor];
    self.numberOfPeoplePicker.delegate = self;
    [self.view addSubview:self.numberOfPeoplePicker];
    [self.numberOfPeoplePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@150);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.45);
        make.top.equalTo(self.picturePickerButton.mas_bottom).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-15);

    }];
    
    self.numberOfPeopleLabel = [[UILabel alloc] init];
    self.numberOfPeopleLabel.backgroundColor = [UIColor lightGrayColor];
    self.numberOfPeopleLabel.numberOfLines = 0;
    self.numberOfPeopleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.numberOfPeopleLabel];
    [self.numberOfPeopleLabel setText:[NSString stringWithFormat:@"%@\n%@",@"How Many People", @"Are In Your Party???"]];
//     @"How Many People Are In Your Party???"];
    
    [self.numberOfPeopleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.and.centerY.equalTo(self.numberOfPeoplePicker);
        make.left.equalTo(self.view).offset(15);
    }];
    
    
    self.startSimulation = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [self.startSimulation addTarget:self action:@selector(simulateNow) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.startSimulation];
    self.startSimulation.backgroundColor = [UIColor blueColor];
    [self.startSimulation setTitle:@"START SIMULATION" forState:UIControlStateNormal];
    [self.startSimulation setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.startSimulation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numberOfPeopleLabel.mas_bottom).offset(15);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.75);
        make.height.equalTo(@75);
        make.centerX.equalTo(self.view);
    }];

    
}


- (void)selectPhoto
{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView = [[UIImageView alloc] init];
    self.imageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}







-(NSString *)pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row
           forComponent:(NSInteger)component
{
    NSString *peepNumber = [NSString stringWithFormat:@"%@",@(row +1)];
    
    return peepNumber;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    return YES;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return 4;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
