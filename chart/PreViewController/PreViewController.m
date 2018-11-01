//
//  PreViewController.m
//  chart
//
//  Created by 钟程 on 2018/10/30.
//  Copyright © 2018 钟程. All rights reserved.
//

#import "PreViewController.h"
#import "AllTableViewCell.h"
#import "TableViewCell.h"
#import "HeadView.h"

@interface PreViewController ()<UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *listArray;
    NSMutableArray *detailArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *seletedView;

@end

@implementation PreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AllTableViewCell" bundle:nil] forCellReuseIdentifier:@"AllCell"];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    if (@available(iOS 11.0, *)){
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight =0;
        _tableView.estimatedSectionFooterHeight =0;
    }
    self.tableView.estimatedRowHeight = 100;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.tableView setSeparatorColor:[UIColor blackColor]];
    
    self.seletedView.rowHeight = UITableViewAutomaticDimension;
    if (@available(iOS 11.0, *)){
        _seletedView.estimatedRowHeight = 0;
        _seletedView.estimatedSectionHeaderHeight =0;
        _seletedView.estimatedSectionFooterHeight =0;
    }
    self.seletedView.estimatedRowHeight = 50;
    [self.seletedView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.seletedView setSeparatorColor:[UIColor blackColor]];
    self.seletedView.tableFooterView = [[UIView alloc] init];
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self getData];
}


#pragma mark - UITableViewDelegate Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 101) {
        return cellMax;
    }else {
        return listArray.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 101) {
        if (indexPath.row == 0) {
            AllTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AllCell"];
            if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [cell setSeparatorInset:UIEdgeInsetsZero];
            }
            cell.userInteractionEnabled = NO;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.cellData = detailArray[indexPath.row];
            return cell;
        }
        TableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.userInteractionEnabled = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        // 分割线顶到头
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellData = detailArray[indexPath.row];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TCell"];
        }
        // 分割线顶到头
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        UIView *view = [[UIView alloc]initWithFrame:cell.bounds];
        view.layer.borderWidth = 2;
        view.layer.borderColor = [UIColor colorWithQuick:126 green:198 blue:113].CGColor;
        cell.selectedBackgroundView = view;
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithQuick:247 green:255 blue:246];
        
        NSInteger c = [[listArray[indexPath.row] objectForKey:@"course"] integerValue];
        NSInteger n = [[listArray[indexPath.row] objectForKey:@"no"] integerValue];
        cell.textLabel.text = [NSString stringWithFormat:@"第%ld场第%ld筒", c, n];
        cell.detailTextLabel.text = [listArray[indexPath.row] objectForKey:@"result"];
        cell.detailTextLabel.textColor = [UIColor redColor];
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView.tag == 101) {
        return 35;
    }else {
        return 60;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView.tag == 101) {
        HeadView *headView = [[NSBundle mainBundle] loadNibNamed:@"HeadView" owner:nil options:nil].firstObject;
        return headView;
    }else {
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(tableView.frame.size.width - 110, 10, 90, 40)];
        backBtn.layer.cornerRadius = 20;
        backBtn.layer.masksToBounds = YES;
        backBtn.layer.borderWidth = 1;
        backBtn.layer.borderColor = [UIColor colorWithSome:192].CGColor;
        [backBtn setBackgroundImage:[UIImage imageNamed:@"button_bg_3"] forState:UIControlStateNormal];
        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [backBtn setTitleColor:[UIColor colorWithQuick:4 green:51 blue:255] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:backBtn];
        
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 59, tableView.frame.size.width, 1)];
        line.backgroundColor = [UIColor colorWithSome:192];
        [view addSubview:line];
        
        return view;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 102) {
        detailArray = [NSMutableArray array];
        [detailArray addObject:listArray[indexPath.row]];
        NSString *listId = [listArray[indexPath.row] objectForKey:@"listId"];
        
        NSArray *array = [FMDB selectDetail:listId];
        [detailArray addObjectsFromArray:array];
      
        [self.tableView reloadData];
    }
}

#pragma mark - 按钮事件
- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 数据
- (void)getData {
    listArray = [NSMutableArray array];
    detailArray = [NSMutableArray array];
    
    listArray = [FMDB selectTableList:_course no:_no];
    [detailArray addObject:listArray.firstObject];
    NSString *listId = [listArray.firstObject objectForKey:@"listId"];
    
    NSArray *array = [FMDB selectDetail:listId];
    [detailArray addObjectsFromArray:array];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.seletedView reloadData];
    [self.tableView reloadData];
    [self.seletedView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionNone];
}



@end
