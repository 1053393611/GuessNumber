//
//  ViewController.m
//  chart
//
//  Created by 钟程 on 2018/10/10.
//  Copyright © 2018 钟程. All rights reserved.
//

#import "ViewController.h"
#import "HeadView.h"
#import "AllTableViewCell.h"
#import "TableViewCell.h"
#import "CleanViewController.h"
#import "ControlView.h"

#define cellHeight 50

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource,UITextViewDelegate>{
    NSMutableArray *heightArray;
    NSMutableArray *dataArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet ControlView *controlView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    heightArray = [NSMutableArray array];
    for (int i = 0; i < cellMax; i++) {
        [heightArray addObject:@(cellHeight)];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCellHeight:) name:@"refreshCellHeight" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshInput:) name:@"refreshInput" object:nil];

    
    [self.tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AllTableViewCell" bundle:nil] forCellReuseIdentifier:@"AllCell"];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    if (@available(iOS 11.0, *)){
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight =0;
        _tableView.estimatedSectionFooterHeight =0;
    }
    self.tableView.estimatedRowHeight = cellHeight;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.tableView setSeparatorColor:[UIColor blackColor]];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self getData];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - UItableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    CGFloat height = [heightArray[indexPath.row] floatValue];
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return cellMax;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        AllTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AllCell"];
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        cell.userInteractionEnabled = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellData = dataArray[indexPath.row];
        return cell;
    }
    TableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];

    // 分割线顶到头
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cellData = dataArray[indexPath.row];
    return cell;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HeadView *headView = [[NSBundle mainBundle] loadNibNamed:@"HeadView" owner:nil options:nil].firstObject;
    return headView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self aboutResult];
//    TableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    UITextView *textView = [cell viewWithTag:203];
//    [textView becomeFirstResponder];
    
    self.controlView.cellData = @{@"index":@(indexPath.row),@"tableView":tableView,@"dataArray":dataArray};
}

#pragma mark - 通知
// 高度变化
- (void)refreshCellHeight:(NSNotification *)noti {
    
    NSArray *array = [noti object];
    [heightArray replaceObjectAtIndex:[array.lastObject integerValue] withObject:array.firstObject];
}

// textView Text
//- (void)refreshInput:(NSNotification *)noti {
//    NSString *string = [noti object];
//    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
//    TableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
//    cell.cellData = @{@"index":@(path.row),@"input":string};
//}



#pragma mark - 数据
- (void)getData {
    
    dataArray = [[DataManager defaultManager] getDataFromDatabase];
    self.controlView.cellData = @{@"tableView":self.tableView,@"dataArray":dataArray};
    [self.tableView reloadData];
    [self aboutControlView];
}



#pragma mark - 显示隐藏相关
// 点击 开牌相关
- (void)aboutResult {
    UIView *bgView = [self.controlView viewWithTag:500];
    UITextView *textView = [self.controlView viewWithTag:502];
    UIButton *buttn = [self.controlView viewWithTag:503];
    if ([textView.text isEqualToString:@""]) {
        // 没有结果
        bgView.hidden = YES;
        buttn.hidden = NO;
    }else {
        // 有结果
        bgView.backgroundColor = [UIColor clearColor];
        bgView.layer.borderWidth = 0;
    }
}

// 初始显示
- (void)aboutControlView {
    UIView *openBGView = [self.controlView viewWithTag:500];
    UITextView *openLabel = [self.controlView viewWithTag:501];
    UITextView *openTextView = [self.controlView viewWithTag:502];
    UIButton *openBtn = [self.controlView viewWithTag:503];
    NSString *resultAll = [dataArray.firstObject objectForKey:@"result"];
    if ([resultAll isEqualToString:@"未开"]) {
        openBGView.hidden = YES;
        openBtn.hidden = NO;
    }else {
        openBGView.hidden = NO;
        openBtn.hidden = YES;
        openLabel.text = @"本筒开";
        openTextView.text = [resultAll substringFromIndex:1];
        openBGView.backgroundColor = [UIColor clearColor];
        openBGView.layer.borderWidth = 0;
    }
    
    // 判断上部显示
    // 查看上筒按钮
    if ([[dataArray.firstObject objectForKey:@"no"] integerValue] == 1) {
        [self setButtonGray:604];
    }
    
    // 判断是否能结束本筒
    if ([[dataArray.firstObject objectForKey:@"result"] isEqualToString:@"未开"]) {
        [self setButtonGray:601];
    }
    
    // 判断能否结束本场或继续修改本场
    BOOL isFinish = NO;
    for (int i = 1; i < cellMax; i++) {
        NSDictionary *dic = dataArray[i];
        if (![[dic objectForKey:@"input"] isEqualToString:@""]) {
            isFinish = YES;
            break;
        }
    }
    if (isFinish) {
        [self setButtonGray:602];
        UIButton *button = [self.controlView viewWithTag:600];
        button.hidden = YES;
    }
    if ([[dataArray.firstObject objectForKey:@"no"] integerValue] == 1) {
        UIButton *button = [self.controlView viewWithTag:600];
        button.hidden = YES;
    }
    
    // 下部按钮都为灰
//    [self setAllButtonGray];
    
    
}

- (void)setButtonGray:(NSInteger)index{
    UIButton *button = [self.controlView viewWithTag:index];
    button.enabled = NO;
//    [button setBackgroundImage:nil forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithSome:200] forState:UIControlStateNormal];
    
}

- (void)setAllButtonGray{
    for (int i = 0;i < 15;i ++) {
        UIButton *button = [self.controlView viewWithTag:200 + i];
        button.enabled = NO;
        [button setBackgroundImage:nil forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithSome:200] forState:UIControlStateNormal];
    }
    for (int i = 0;i < 3;i ++) {
        UIButton *button = [self.controlView viewWithTag:300 + i];
        button.enabled = NO;
        [button setBackgroundImage:nil forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithSome:200] forState:UIControlStateNormal];
    }
    
}

@end
