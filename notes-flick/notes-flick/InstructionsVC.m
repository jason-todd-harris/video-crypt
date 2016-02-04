//
//  InstructionsVC.m
//  notes-flick
//
//  Created by JASON HARRIS on 2/4/16.
//  Copyright © 2016 jason harris. All rights reserved.
//

#import "InstructionsVC.h"
#import "NotesColor.h"
#import "AllTheNotes.h"
#import <Masonry.h>

@interface InstructionsVC ()

@end

@implementation InstructionsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor notesBrown];
    
    UILabel *instructionLabel = [[UILabel alloc] init];
    instructionLabel.numberOfLines = 0;
    instructionLabel.adjustsFontSizeToFitWidth = YES;
    instructionLabel.textColor = [UIColor notesLightGray];
    instructionLabel.text = [[AllTheNotes sharedNotes].beginningInstructions componentsJoinedByString:@"\n∙ "];
    
    [self.view addSubview:instructionLabel];
    
    [instructionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.bottom.and.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 10, 10, 10));
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
