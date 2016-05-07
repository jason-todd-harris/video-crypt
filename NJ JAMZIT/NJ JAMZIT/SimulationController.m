//
//  SimulationController.m
//  NJ JAMZIT
//
//  Created by JASON HARRIS on 5/7/16.
//  Copyright © 2016 jason harris. All rights reserved.
//

#import "SimulationController.h"
#import <Masonry.h>

@interface SimulationController ()

@end

@implementation SimulationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.view addSubview:self.ticketView];
    self.ticketView.contentMode = UIViewContentModeScaleAspectFit;
    [self.ticketView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_topMargin);
        make.bottom.equalTo(self.view.mas_bottomMargin);
        make.left.right.width.equalTo(self.view);
        
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
