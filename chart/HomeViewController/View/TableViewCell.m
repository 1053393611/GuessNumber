//
//  TableViewCell.m
//  chart
//
//  Created by 钟程 on 2018/10/10.
//  Copyright © 2018 钟程. All rights reserved.
//

#import "TableViewCell.h"
#import <Masonry.h>

#define defaultAllColor [UIColor colorWithQuick:62 green:131 blue:148]

@interface TableViewCell()<UITextViewDelegate, UITextFieldDelegate>{
    NSInteger index;
    NSMutableDictionary *dataDic;
    float allMoney;
}
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rowLabel;
@property (weak, nonatomic) IBOutlet UILabel *AllLabel;
@property (weak, nonatomic) IBOutlet UITextView *resultTextView;
@property (weak, nonatomic) IBOutlet UILabel *thisLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateLabel;
@property (weak, nonatomic) IBOutlet UILabel *preLabel;

@end

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshInput:) name:@"refreshInput" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNumber:) name:@"updateNumber" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshResult:) name:@"refreshResult" object:nil];
    
    
    [self customUI];
    
    
    self.textView.delegate = self;
    self.textView.userInteractionEnabled = NO;
//    self.textView.contentInset = UIEdgeInsetsMake(11, 0, 0, 0);
//    CGFloat fontCapHeight = self.textView.font.capHeight; // 文字大小所占的高度
//    self.textView.contentInset = UIEdgeInsetsMake((self.textView.frame.size.height - fontCapHeight- 22)*0.5, 0, 0, 0);

}
//- (void)dealloc
//{
//    [[NSNotificationCenter defaultCenter]removeObserver:self];
//}

#pragma mark - 自定义视图处理
- (void)customUI {
    
    // 名称
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nameAction:)];
    self.nameLabel.userInteractionEnabled = YES;
    [self.nameLabel addGestureRecognizer:tap];
    
}


#pragma mark - 点击名称处理
- (void)nameAction:(UITapGestureRecognizer *)tap {
    UITableView *tableView = [self getTableView:self];
    NSIndexPath *path = [tableView indexPathForCell:self];
    [tableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionNone];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshIndex" object:@(path.row)];
    
    UILabel *label = (UILabel *)tap.view;
    UIAlertController *alt = [UIAlertController alertControllerWithTitle:@"请输入名称" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alt addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.text = label.text;
        textField.delegate = self;
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        [alt.textFields.firstObject resignFirstResponder];
//        [self.textView becomeFirstResponder];
        
    }];
    
    HBWeakSelf(self)
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        HBStrongSelf(self)
//        [alt.textFields.firstObject resignFirstResponder];
//        [self.textView canBecomeFirstResponder];
        [self.textView becomeFirstResponder];
        
        
        self.nameLabel.text = alt.textFields.firstObject.text;
        
        CGRect frame = self.nameLabel.frame;
        CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
        CGSize size = [self.nameLabel sizeThatFits:constraintSize];
        
        CGRect frame1 = self.textView.frame;
        CGSize constraintSize1 = CGSizeMake(frame1.size.width, MAXFLOAT);
        CGSize size1 = [self.textView sizeThatFits:constraintSize1];

        NSInteger index = [[self getTableView:self] indexPathForCell:self].row;
        NSInteger height = (size1.height > 40) ? size1.height : 40;
        if (size.height > height + 10) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshCellHeight" object:@[@(size.height + 10),@(index)]];
        }else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshCellHeight" object:@[@(height + 10),@(index)]];
        }
        
        [[self getTableView:self] beginUpdates];
        [[self getTableView:self] endUpdates];
        
        [self->dataDic setObject:alt.textFields.firstObject.text forKey:@"name"];
        
        [[DataManager defaultManager] updateDataWithDictionary:self->dataDic];
        DetailModel *model = [DetailModel detailModelWithDictionary:self->dataDic];
        [FMDB updateDetailAboutName:model];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshIndex" object:@(path.row)];
    }];
    [self.textView becomeFirstResponder];
    
    [alt addAction:cancelAction];
    [alt addAction:okAction];
    
    [[self getViewController:self] presentViewController:alt animated:YES completion:^{
        
    }];
    
   
   
}



#pragma mark - textView 内容改变
-(void)textViewDidChange:(UITextView *)textView{

    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    
    CGRect frame1 = self.nameLabel.frame;
    CGSize constraintSize1 = CGSizeMake(frame1.size.width, MAXFLOAT);
    CGSize size1 = [self.nameLabel sizeThatFits:constraintSize1];
    
    NSInteger index = [[self getTableView:self] indexPathForCell:self].row;
    
    NSInteger height = (size1.height > 40) ? size1.height : 40 ;
    
    if (size.height > height + 10) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshCellHeight" object:@[@(size.height + 10),@(index)]];
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshCellHeight" object:@[@(height + 10),@(index)]];
    }
    
    [[self getTableView:self] beginUpdates];
    [[self getTableView:self] endUpdates];
    
    // 重点：消除文字抖动
    [textView scrollRangeToVisible:NSMakeRange(0,0)];
    
}


#pragma mark - 键盘弹出

- (void)textViewDidBeginEditing:(UITextView *)textView{
    for (UIWindow *window in [[UIApplication sharedApplication] windows] ) {
        if ([[window description] hasPrefix:@"<UIRemoteKeyboardWindow"] == YES) {
            UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:2];
            tempWindow.hidden = YES;
            [tempWindow setAlpha:0];
        }
    }
    
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:2];
    tempWindow.hidden = NO;
    [tempWindow setAlpha:1];
}


-(id)getTableView:(UIView *)sender{
    if ([sender isKindOfClass:[UITableView class]]) {
        return (UITableView *)sender;
    }
    return [self getTableView:sender.superview];
}

#pragma mark - 选中式样
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [self changeSelectionColorForSelectedOrHiglightedState:selected];
}


- (void)changeSelectionColorForSelectedOrHiglightedState:(BOOL)state
{
    if (state) {
        //选中时候的样式
        UIView *view = [[UIView alloc]initWithFrame:self.bounds];
        view.layer.borderWidth = 2;
        view.layer.borderColor = [UIColor colorWithQuick:126 green:198 blue:113].CGColor;
        self.selectedBackgroundView = view;
        self.selectedBackgroundView.backgroundColor = [UIColor colorWithQuick:247 green:255 blue:246];
        [self.textView becomeFirstResponder];
        self.textView.tintColor = [UIColor redColor];
    }else{
        //未选中时候的样式
        UIView *view = [[UIView alloc]initWithFrame:self.bounds];
//        view.layer.borderWidth = 1;
//        view.layer.borderColor = [UIColor colorWithQuick:126 green:198 blue:113].CGColor;
        self.selectedBackgroundView = view;
        self.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
//        [self.textView resignFirstResponder];
    }
}

#pragma mark - 获取当前ViewController

- (UIViewController *)getViewController:(UIResponder*)sender{
    if ([sender isKindOfClass:[UIViewController class]]) {
        return (UIViewController *)sender;
    }
    
    return [self getViewController:sender.nextResponder];
}

#pragma mark - 判断当前cell高度
-(void)getCellHeight{
    CGRect frame = self.nameLabel.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [self.nameLabel sizeThatFits:constraintSize];
    
    CGRect frame1 = self.textView.frame;
    CGSize constraintSize1 = CGSizeMake(frame1.size.width, MAXFLOAT);
    CGSize size1 = [self.textView sizeThatFits:constraintSize1];
    
    NSInteger height = (size1.height > size.height) ? size1.height : size.height;
    if (height > 40) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshCellHeight" object:@[@(height + 10),@(index)]];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshCellHeight" object:@[@(50),@(index)]];
    }
    // 重点：消除文字抖动
    [self.textView scrollRangeToVisible:NSMakeRange(0,0)];
//    [self textViewDidBeginEditing:self.textView];
}

#pragma mark - 数据
- (void)setCellData:(NSDictionary *)cellData {
    dataDic = [NSMutableDictionary dictionaryWithDictionary:cellData];
    allMoney = [[cellData objectForKey:@"total"] floatValue] - [[cellData objectForKey:@"thisAll"] floatValue] - [[cellData objectForKey:@"update"] floatValue];
    index = [[cellData objectForKey:@"row"] integerValue];
    
    self.rowLabel.text = [NSString stringWithFormat:@"%ld", index];
    
    self.AllLabel.text = [cellData objectForKey:@"total"];
    if ([[cellData objectForKey:@"total"] floatValue] >= 0) {
        self.AllLabel.textColor = defaultAllColor;
    }else {
        self.AllLabel.textColor = [UIColor redColor];
    }
    
    self.nameLabel.text = [cellData objectForKey:@"name"] ;
//    self.textView.text = [cellData objectForKey:@"input"];
    [self judgeTextColor:[cellData objectForKey:@"input"]];
//    self.resultTextView.text = [cellData objectForKey:@"result"];
    [self judgeResultTextColor:[cellData objectForKey:@"result"]];
    self.thisLabel.text = [cellData objectForKey:@"thisAll"];
    if ([[cellData objectForKey:@"thisAll"] floatValue] >= 0) {
        self.thisLabel.textColor = defaultAllColor;
    }else {
        self.thisLabel.textColor = [UIColor redColor];
    }
    self.updateLabel.text = [cellData objectForKey:@"update"];
    self.preLabel.text = [cellData objectForKey:@"previous"];
//    [self textViewDidChange:self.textView];
    [self getCellHeight];
}


#pragma mark - 投入 结果 文字颜色
- (void)judgeTextColor:(NSString *)string {
    self.textView.text = string;
    self.textView.textColor = [UIColor blackColor];
    NSArray *array = [string componentsSeparatedByString:@"\n"];
    NSString *s = array.lastObject;

    if ([s containsString:@"/"]) {
        NSArray *a = [s componentsSeparatedByString:@"/"];
        NSString *str = a.lastObject;
        if ([str containsString:@"."]) {
            str = [str stringByReplacingOccurrencesOfString:@"." withString:@""];
        }
        if (str.length == 0) {
            NSRange range = NSMakeRange(string.length - s.length, s.length);
            [self setupTextView:self.textView range:range color:[UIColor redColor]];
        }
    }else{
        NSRange range = NSMakeRange(string.length - s.length, s.length);
        [self setupTextView:self.textView range:range color:[UIColor redColor]];
        
    }
}

- (void)judgeResultTextColor:(NSString *)resultString {
    self.resultTextView.text = resultString;
    self.resultTextView.textColor = [UIColor blackColor];
    NSArray *array = [resultString componentsSeparatedByString:@"\n"];
    NSString *s = array.lastObject;
    
    if ([s isEqualToString:@"X"]) {
        [self setupTextView:self.resultTextView range:[resultString rangeOfString:@"X"] color:[UIColor redColor]];
        
    }
}

// 设置富文本
- (void)setupTextView:(UITextView *)textView range:(NSRange)range color:(UIColor *)color {
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:textView.text];
    
    [string addAttribute:NSForegroundColorAttributeName value:color range:range];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, textView.text.length)];
    
    [textView setAttributedText:string];
}


#pragma mark - 判断是否被选中
- (BOOL)judgeIsSeleted {
    NSIndexPath *path = [[self getTableView:self] indexPathForSelectedRow];
    NSIndexPath *cPath = [[self getTableView:self] indexPathForCell:self];
    if (path.row == cPath.row) {
        return YES;
    }
    return NO;
}


#pragma mark - 通知
// 投入
- (void)refreshInput:(NSNotification *)noti {
    NSString *string = [noti object];
    if ([self judgeIsSeleted]) {
        self.textView.text = string;
        self.textView.textColor = [UIColor blackColor];
        NSArray *array = [string componentsSeparatedByString:@"\n"];
        NSString *s = array.lastObject;
        
        NSString *resultString = [NSString string];
        for (int i = 0; i < array.count- 1; i++) {
            resultString = [resultString stringByAppendingString:@"\n"];
        }
        self.resultTextView.text = resultString;
        if ([s containsString:@"/"]) {
            NSArray *a = [s componentsSeparatedByString:@"/"];
            NSString *str = a.lastObject;
            if ([str containsString:@"."]) {
                str = [str stringByReplacingOccurrencesOfString:@"." withString:@""];
            }
            if (str.length == 0) {
                NSRange range = NSMakeRange(string.length - s.length, s.length);
                [self setupTextView:self.textView range:range color:[UIColor redColor]];
                resultString = [resultString stringByAppendingString:@"X"];
                self.resultTextView.text = resultString;
                [self setupTextView:self.resultTextView range:[resultString rangeOfString:@"X"] color:[UIColor redColor]];
            }
        }else{
            NSRange range = NSMakeRange(string.length - s.length, s.length);
            [self setupTextView:self.textView range:range color:[UIColor redColor]];
            if (s.length != 0) {
                resultString = [resultString stringByAppendingString:@"X"];
                self.resultTextView.text = resultString;
                [self setupTextView:self.resultTextView range:[resultString rangeOfString:@"X"] color:[UIColor redColor]];
            }
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshInputAll" object:nil];
        
        [dataDic setObject:string forKey:@"input"];
        [dataDic setObject:resultString forKey:@"result"];
        
        [[DataManager defaultManager] updateDataWithDictionary:dataDic];
        DetailModel *model = [DetailModel detailModelWithDictionary:dataDic];
        [FMDB updateDetail:model];
        
        [self textViewDidChange:self.textView];
    }
    
}



// 更正
- (void)updateNumber:(NSNotification *)noti {
    
    float number = [[noti object] floatValue];
    if ([self judgeIsSeleted]) {
        
        self.updateLabel.text = [self getStringWithNumber:number];
        
        float all = number + allMoney + [self.thisLabel.text floatValue];
        self.AllLabel.text = [self getStringWithNumber:all];
        if (all >= 0) {
            self.AllLabel.textColor = defaultAllColor;
        }else {
            self.AllLabel.textColor = [UIColor redColor];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateResultAll" object:nil];
        
        [dataDic setObject:[self getStringWithNumber:number] forKey:@"update"];
        [dataDic setObject:[self getStringWithNumber:all] forKey:@"total"];
        
        [[DataManager defaultManager] updateDataWithDictionary:dataDic];
        DetailModel *model = [DetailModel detailModelWithDictionary:dataDic];
        [FMDB updateDetail:model];
    }
    
    
}

// 结果
- (void)refreshResult:(NSNotification *)noti {
    if ([self.textView.text isEqualToString:@""]) {
        return;
    }
    NSInteger resultNumber = [[noti object] integerValue];
    if (resultNumber != 0) {
        // 数字
        self.resultTextView.textColor = [UIColor blackColor];
        NSString *string = self.textView.text;
        NSArray *array = [string componentsSeparatedByString:@"\n"];
        NSString *s = array.lastObject;
        
        NSString *resultString = [NSString string];
        float thisAll = 0;
        for (int i = 0; i < array.count- 1; i++) {
            float f = [[MoneyResult defaultInit] getResultWithString:array[i] number:resultNumber];
            resultString = [resultString stringByAppendingFormat:@"%@\n",[self getStringWithNumber:f]];
            thisAll += f;
        }
        self.resultTextView.text = resultString;
        if ([s containsString:@"/"]) {
            NSArray *a = [s componentsSeparatedByString:@"/"];
            NSString *str = a.lastObject;
            if ([str containsString:@"."]) {
                str = [str stringByReplacingOccurrencesOfString:@"." withString:@""];
            }
            if (str.length == 0) {
                resultString = [resultString stringByAppendingString:@"X"];
                self.resultTextView.text = resultString;
                [self setupTextView:self.resultTextView range:[resultString rangeOfString:@"X"] color:[UIColor redColor]];
            }else {
                float f = [[MoneyResult defaultInit] getResultWithString:s number:resultNumber];
                resultString = [resultString stringByAppendingFormat:@"%@",[self getStringWithNumber:f]];
                self.resultTextView.text = resultString;
                thisAll += f;
            }
        }else{
            if (s.length != 0) {
                resultString = [resultString stringByAppendingString:@"X"];
                self.resultTextView.text = resultString;
                [self setupTextView:self.resultTextView range:[resultString rangeOfString:@"X"] color:[UIColor redColor]];
            }
        }
        if (self.textView.text.length > 0) {
            self.thisLabel.text = [self getStringWithNumber:thisAll];
            if (thisAll >= 0) {
                self.thisLabel.textColor = defaultAllColor;
            }else {
                self.thisLabel.textColor = [UIColor redColor];
            }
            
            float all = thisAll + allMoney + [self.updateLabel.text floatValue];
            self.AllLabel.text = [self getStringWithNumber:all];
            if (all >= 0) {
                self.AllLabel.textColor = defaultAllColor;
            }else {
                self.AllLabel.textColor = [UIColor redColor];
            }
        }
        
        
    }else{
        // 退格
        NSString *string = self.textView.text;
        NSArray *array = [string componentsSeparatedByString:@"\n"];
        NSString *s = array.lastObject;
        
        NSString *resultString = [NSString string];
        for (int i = 0; i < array.count- 1; i++) {
            resultString = [resultString stringByAppendingString:@"\n"];
        }
        self.resultTextView.text = resultString;
        if ([s containsString:@"/"]) {
            NSArray *a = [s componentsSeparatedByString:@"/"];
            NSString *str = a.lastObject;
            if ([str containsString:@"."]) {
                str = [str stringByReplacingOccurrencesOfString:@"." withString:@""];
            }
            if (str.length == 0) {
                resultString = [resultString stringByAppendingString:@"X"];
                self.resultTextView.text = resultString;
                [self setupTextView:self.resultTextView range:[resultString rangeOfString:@"X"] color:[UIColor redColor]];
            }
        }else{
            if (s.length != 0) {
                resultString = [resultString stringByAppendingString:@"X"];
                self.resultTextView.text = resultString;
                [self setupTextView:self.resultTextView range:[resultString rangeOfString:@"X"] color:[UIColor redColor]];
            }
        }
        if (self.textView.text.length > 0) {
            self.thisLabel.text = @"";
            float all = allMoney + [self.updateLabel.text floatValue];
            self.AllLabel.text = [self getStringWithNumber:all];
            if (all >= 0) {
                self.AllLabel.textColor = defaultAllColor;
            }else {
                self.AllLabel.textColor = [UIColor redColor];
            }
        }
        
        
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshResultAll" object:@(resultNumber)];
    
    
    [dataDic setObject:self.AllLabel.text forKey:@"total"];
    [dataDic setObject:self.resultTextView.text forKey:@"result"];
    [dataDic setObject:self.thisLabel.text forKey:@"thisAll"];
    
    [[DataManager defaultManager] updateDataWithDictionary:dataDic];
    DetailModel *model = [DetailModel detailModelWithDictionary:dataDic];
    [FMDB updateDetail:model];
    
}


#pragma mark - 数字显示
- (NSString *)getStringWithNumber:(float)number {
    int decimalNum = 4; //保留的小数位数
    
    NSNumberFormatter *nFormat = [[NSNumberFormatter alloc] init];
    
    [nFormat setNumberStyle:NSNumberFormatterDecimalStyle];
    
    [nFormat setMaximumFractionDigits:decimalNum];
    
    NSString *string = [nFormat stringFromNumber:@(number)];
    if (number > 0) {
        string = [NSString stringWithFormat:@"+%@", string];
    }
    return string;
}



@end
