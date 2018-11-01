//
//  AllViewController.m
//  chart
//
//  Created by 钟程 on 2018/10/20.
//  Copyright © 2018 钟程. All rights reserved.
//

#import "AllViewController.h"

@interface AllViewController ()

@end

@implementation AllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - 返回按钮

- (IBAction)backAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
