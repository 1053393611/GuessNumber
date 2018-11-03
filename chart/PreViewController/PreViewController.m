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
    self.tableView.estimatedRowHeight = 50;
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
    [self.seletedView setSeparatorColor:[UIColor colorWithSome:192]];
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
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(tableView.frame.size.width - 90, 10, 80, 36)];
        backBtn.layer.cornerRadius = 18;
        backBtn.layer.masksToBounds = YES;
        backBtn.layer.borderWidth = 1;
        backBtn.layer.borderColor = [UIColor colorWithSome:192].CGColor;
        [backBtn setBackgroundImage:[UIImage imageNamed:@"button_bg_3"] forState:UIControlStateNormal];
        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [backBtn setTitleColor:[UIColor colorWithQuick:4 green:51 blue:255] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:backBtn];
        
        UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(tableView.frame.size.width - 190, 10, 80, 36)];
        shareBtn.layer.cornerRadius = 18;
        shareBtn.layer.masksToBounds = YES;
        shareBtn.layer.borderWidth = 1;
        shareBtn.layer.borderColor = [UIColor colorWithSome:192].CGColor;
        [shareBtn setBackgroundImage:[UIImage imageNamed:@"button_bg_3"] forState:UIControlStateNormal];
        [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
        [shareBtn setTitleColor:[UIColor colorWithQuick:4 green:51 blue:255] forState:UIControlStateNormal];
        [shareBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:shareBtn];
        
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

#pragma mark - 截图 分享
- (void)shareAction {
    
    // 截屏
    UIWindow  *window = [UIApplication sharedApplication].keyWindow;
    
    UIImage * image = [self captureImageFromView:window];
    // 图片保存相册
    //    UIImage *image = [UIImage imageNamed:@"cellBack"];
    UIImageWriteToSavedPhotosAlbum(image,self,@selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:),nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"分享当前屏幕" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction *weChatOneAction = [UIAlertAction actionWithTitle:@"分享至微信好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([WXApi isWXAppInstalled]) {
            //            [WXApi openWXApp];
            WXMediaMessage *message = [WXMediaMessage message];
            // 设置消息缩略图的方法
            CGSize size = CGSizeMake(100, 100);
            UIGraphicsBeginImageContext(size);
            [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
            UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [message setThumbImage:resultImage];
            // 多媒体消息中包含的图片数据对象
            WXImageObject *imageObject = [WXImageObject object];
            
            //        UIImage *image = _shareImage.image;
            
            // 图片真实数据内容
            
            NSData *data = UIImagePNGRepresentation(image);
            imageObject.imageData = data;
            // 多媒体数据对象，可以为WXImageObject，WXMusicObject，WXVideoObject，WXWebpageObject等。
            message.mediaObject = imageObject;
            
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneSession;
            
            //            [WXApi sendReq:req];
            [GCDQueue executeInMainQueue:^{
                [WXApi sendReq:req];
            }];
            
        }else {
            [Hud showMessage:@"本机未安装微信，请先下载微信"];
        }
        
        
    }];
    
    [alertController addAction:weChatOneAction];
    [alertController addAction:cancelAction];
    
    //    if ([alertController respondsToSelector:@selector(popoverPresentationController)]) {
    //
    //        alertController.popoverPresentationController.sourceView = self.view; //必须加
    //
    ////        alertVC.popoverPresentationController.sourceRect = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);//可选，我这里加这句代码是为了调整到合适的位置
    //
    //    }
    
    [self presentViewController:alertController animated:YES completion:nil];
}

// 图片保存后的回调
- (void)imageSavedToPhotosAlbum:(UIImage*)image didFinishSavingWithError:  (NSError*)error contextInfo:(id)contextInfo

{
    if(!error) {
        //        [self showHUD:@"成功保存到相册"];
        
    }else {
        //        NSString *message = [error description];
        //        [self showHUD:message];
    }
    
}


// 截屏
-(UIImage *)captureImageFromView:(UIView *)view{
    
    CGSize size = view.bounds.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGRect rect = view.frame;
    [view drawViewHierarchyInRect:rect afterScreenUpdates:YES];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snapshotImage;
    
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
