//
//  ViewController.m
//  chart
//
//  Created by 钟程 on 2018/10/10.
//  Copyright © 2018 钟程. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"
#import <Masonry.h>
#import "CleanViewController/CleanViewController.h"
#import "KeyboardView.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource,UITextViewDelegate>{
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UITextView *textView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCellHeight) name:@"refreshCellHeight" object:nil];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    NSString *s = @"0.12";
    NSLog(@"%f", [s floatValue]);
//    self.textView = [UITextView new];
//    [self.view addSubview:self.textView];
//    self.textView.delegate = self;
//    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(100);
//        make.leading.equalTo(self.view).offset(200);
//        make.trailing.equalTo(self.view).offset(-200);
//        make.height.mas_equalTo(40);
//    }];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    if (@available(iOS 11.0, *)){
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight =0;
        _tableView.estimatedSectionFooterHeight =0;
    }
    self.tableView.estimatedRowHeight = 100;
    
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    TableViewCell * cell = (TableViewCell *)[tableView.dataSource tableView:_tableView cellForRowAtIndexPath:indexPath];
//    if ([cell CellHeight]<44) {
//        return 44;
//    } else {
//        return [cell CellHeight];
//    }
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
//    if ( cell == nil ) {
//        cell = [[TableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([TableViewCell class])];
//        
//    }
    UIView *view = [[UIView alloc]initWithFrame:cell.bounds];
    view.layer.borderWidth = 1;
    view.layer.borderColor = [UIColor colorWithQuick:126 green:198 blue:113].CGColor;
    cell.selectedBackgroundView = view;
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithQuick:247 green:255 blue:246];
    [cell setNeedsUpdateConstraints];
    
    [cell updateConstraintsIfNeeded];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    return cell;
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (CGFloat)CellHeight {
    CGSize size = [_textView sizeThatFits:CGSizeMake(_textView.frame.size.width, MAXFLOAT)];
    return size.height+5;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    CGRect frame = textView.frame;
    float height;
    if ([text isEqual:@""]) {
        
        if (![textView.text isEqualToString:@""]) {
            
            height = [ self heightForTextView:textView WithText:[textView.text substringToIndex:[textView.text length] - 1]];
            
        }else{
            
            height = [ self heightForTextView:textView WithText:textView.text];
        }
    }else{
        
        height = [self heightForTextView:textView WithText:[NSString stringWithFormat:@"%@%@",textView.text,text]];
    }
    
    frame.size.height = height;
    [UIView animateWithDuration:0.5 animations:^{
        
        textView.frame = frame;
        
    } completion:nil];
    
    return YES;
}

- (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
    CGSize constraint = CGSizeMake(textView.contentSize.width , CGFLOAT_MAX);
    CGRect size = [strText boundingRectWithSize:constraint
                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}
                                        context:nil];
    float textHeight = size.size.height + 22.0;
    return textHeight;
}

- (void)refreshCellHeight {
    
}






@end
