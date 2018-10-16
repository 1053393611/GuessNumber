//
//  KeyboardView.m
//  chart
//
//  Created by 钟程 on 2018/10/15.
//  Copyright © 2018 钟程. All rights reserved.
//

#import "KeyboardView.h"

#define lableBGColor [UIColor colorWithQuick:244 green:197 blue:196]

@interface KeyboardView(){
    NSString *stringData;
}
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stringLabel;


@end



@implementation KeyboardView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupSelfNameXibOnSelf];
    
    [self setAllButtonGray];
}


#pragma mark - 初始化键盘
- (void)customKeyboardView:(NSString *)string {
    [self setAllButtonWhiter];
    if ([string containsString:@"/"]) {
        // 有/的情况
        NSArray *strArray = [string componentsSeparatedByString:@"/"];
//        NSString *firstStr = strArray.firstObject;
        NSString *lastStr = strArray.lastObject;
        [self moneyStatus:lastStr];
    
    }else {
        [self guessStatus:string];
    }
    
}

- (void)guessStatus:(NSString *)string {
    if (string.length == 0) {
        // 没有任何字符
        self.stringLabel.backgroundColor = [UIColor colorWithSome:220];
        [self setAllButtonGray:@[@0,@7,@8,@9,@10,@11,@12,@13,@14]];
    }else{
        self.stringLabel.backgroundColor = lableBGColor;
        if ([string containsString:@">"]) {
            // >的状态
            string = [string stringByReplacingOccurrencesOfString:@">" withString:@""];
            if (string.length == 1) {
                [self setAllButtonGray:@[@0,@7,@8,@9,string,@10,@12,@13,@14]];
            }else{
                [self setAllButtonGray:@[@0,@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@12,@13]];
            }
        }else if ([string containsString:@"."]){
            // .的状态
            string = [string stringByReplacingOccurrencesOfString:@"." withString:@""];
            if (string.length == 1) {
                [self setAllButtonGray:@[@0,@7,@8,@9,string,@10,@12,@13,@14]];
            }else if (string.length == 2) {
                NSString *firstStr = [string substringToIndex:1];
                NSString *lastStr = [string substringFromIndex:1];
                [self setAllButtonGray:@[@0,@7,@8,@9,firstStr,lastStr,@10,@12,@13]];
            }else{
                [self setAllButtonGray:@[@0,@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@12,@13]];
            }
        }else {
            // 纯数字
            if (string.length == 1) {
                [self setAllButtonGray:@[@0,@7,@8,@9,string,@12]];
            }else if (string.length == 2){
                NSString *firstStr = [string substringToIndex:1];
                NSString *lastStr = [string substringFromIndex:1];
                [self setAllButtonGray:@[@0,@7,@8,@9,firstStr,lastStr,@10,@12,@13]];
            }else {
                [self setAllButtonGray:@[@0,@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@12,@13]];
            }
        }
    }
}


- (void)moneyStatus:(NSString *)string {
    [self setButtonGray:13];
    [self setButtonGray:14];
    if ([string isEqualToString:@""]) {
        // /在末尾
        self.stringLabel.backgroundColor = lableBGColor;
        [self setButtonGray:12];
    }else{
        // /在中间
        if ([string containsString:@"."]) {
            [self setButtonGray:10];
            string = [string stringByReplacingOccurrencesOfString:@"." withString:@""];
        }
        
        if (string.length >= 4) {
//            [self setButtonWhiter:12];
            [self setAllButtonGray:@[@0,@1,@2,@3,@4,@5,@6,@7,@8,@9,@10]];
            [self setButtonWhiter:11];

        }
        
        if (string.length == 0) {
            self.stringLabel.backgroundColor = lableBGColor;
        }else {
            self.stringLabel.backgroundColor = [UIColor colorWithSome:220];
        }
        
    }
    
}


#pragma mark - 按钮处理
- (IBAction)buttonAction:(UIButton *)sender {
    NSInteger index = sender.tag - 200;
    if (index >=0 && index < 10) {
        stringData = [NSMutableString stringWithFormat:@"%@%ld", stringData, index];
    }else{
        switch (index) {
            case 10:
                stringData = [NSString stringWithFormat:@"%@.", stringData];
                break;
            case 13:
                stringData = [NSString stringWithFormat:@"%@>", stringData];
                break;
            case 14:
                stringData = [NSString stringWithFormat:@"%@/", stringData];
                break;
            case 11:
                stringData = [stringData substringToIndex:stringData.length-1];
                break;
            default:
                break;
        }
    }
    self.stringLabel.text = [@"  " stringByAppendingString:stringData];
    [self customKeyboardView:stringData];
}



#pragma mark - 设置按钮状态
- (void)setButtonGray:(NSInteger)index{
    UIButton *button = [self viewWithTag:200 + index];
    button.enabled = NO;
    [button setBackgroundImage:nil forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithSome:200] forState:UIControlStateNormal];
    
}

- (void)setButtonWhiter:(NSInteger)index{
    UIButton *button = [self viewWithTag:100 + index];
    button.enabled = YES;
    [button setBackgroundImage:[UIImage imageNamed:@"button_bg_2"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithQuick:4 green:51 blue:255] forState:UIControlStateNormal];

}

- (void)setAllButtonGray:(NSArray *)array{
    for (NSNumber *number in array) {
        UIButton *button = [self viewWithTag:200 + [number integerValue]];
        button.enabled = NO;
        [button setBackgroundImage:nil forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithSome:200] forState:UIControlStateNormal];
    }
    
}

- (void)setAllButtonWhiter:(NSArray *)array{
    for (NSNumber *number in array) {
        UIButton *button = [self viewWithTag:200 + [number integerValue]];
        button.enabled = YES;
        [button setBackgroundImage:[UIImage imageNamed:@"button_bg_2"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithQuick:4 green:51 blue:255] forState:UIControlStateNormal];
    }
}

- (void)setAllButtonGray{
    for (int i = 0;i < 15;i ++) {
        UIButton *button = [self viewWithTag:200 + i];
        button.enabled = NO;
        [button setBackgroundImage:nil forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithSome:200] forState:UIControlStateNormal];
    }
    
}

- (void)setAllButtonWhiter{
    for (int i = 0;i < 15;i ++) {
        UIButton *button = [self viewWithTag:200 + i];
        button.enabled = YES;
        [button setBackgroundImage:[UIImage imageNamed:@"button_bg_2"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithQuick:4 green:51 blue:255] forState:UIControlStateNormal];
    }
}


#pragma mark - 数据
- (void)setDataString:(NSString *)dataString{
    stringData = dataString;
    self.stringLabel.text = [@"  " stringByAppendingString:stringData];;
    [self customKeyboardView:dataString];
    
    
}

@end
