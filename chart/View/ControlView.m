//
//  ControlView.m
//  chart
//
//  Created by 钟程 on 2018/10/16.
//  Copyright © 2018 钟程. All rights reserved.
//

#import "ControlView.h"
#import "KeyboardView.h"
#import "CleanViewController.h"

@interface ControlView(){
    
}
@property (weak, nonatomic) IBOutlet KeyboardView *keyboardView;

@end

@implementation ControlView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setupSelfNameXibOnSelf];
    
    self.keyboardView.dataString = @"";
    
}


#pragma mark - 按钮处理
// 清空所有
- (IBAction)deleteAll:(UIButton *)sender {
    
    CleanViewController *vc = [[CleanViewController alloc] init];
    vc.isCleanAll = YES;
    [[self getViewController:self] presentViewController:vc animated:YES completion:nil];
    
}

// 结束本场
- (IBAction)finishStage:(UIButton *)sender {
    
    CleanViewController *vc = [[CleanViewController alloc] init];
    vc.isCleanAll = NO;
    [[self getViewController:self] presentViewController:vc animated:YES completion:nil];
    
}

// 查看上筒
- (IBAction)checkPre:(UIButton *)sender {
    
}

// 查看总账
- (IBAction)checkAll:(UIButton *)sender {
    
}

// 结束本筒
- (IBAction)finishThis:(UIButton *)sender {
    
}

// 继续修改上一筒
- (IBAction)updatePre:(UIButton *)sender {
    
}

#pragma mark - 获取当前ViewController

- (UIViewController *)getViewController:(UIResponder*)sender{
    if ([sender isKindOfClass:[UIViewController class]]) {
        return (UIViewController *)sender;
    }
    
    return [self getViewController:sender.nextResponder];
}

@end
