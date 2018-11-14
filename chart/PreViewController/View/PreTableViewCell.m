//
//  PreTableViewCell.m
//  chart
//
//  Created by 钟程 on 2018/11/7.
//  Copyright © 2018 钟程. All rights reserved.
//

#import "PreTableViewCell.h"

@interface PreTableViewCell(){
    NSMutableDictionary *dataDic;
}
@property (weak, nonatomic) IBOutlet UILabel *allLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *inputLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UILabel *thisLabel;

@end

@implementation PreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 数据
- (void)setCellData:(NSDictionary *)cellData {
    dataDic = [NSMutableDictionary dictionaryWithDictionary:cellData];
    self.allLabel.text = [cellData objectForKey:@"total"];
    if ([[cellData objectForKey:@"total"] floatValue] >= 0) {
        self.allLabel.backgroundColor = [UIColor colorWithQuick:62 green:131 blue:148];
    }else {
        self.allLabel.backgroundColor = [UIColor colorWithQuick:170 green:38 blue:28];
    }
    NSString *name = [NSString stringWithFormat:@"#%ld-%ld",[[cellData objectForKey:@"course"] integerValue], [[cellData objectForKey:@"no"] integerValue]];
    self.nameLabel.text = name;
    self.inputLabel.text = [cellData objectForKey:@"input"];
    self.resultLabel.text = [cellData objectForKey:@"result"];
    self.thisLabel.text = [cellData objectForKey:@"thisAll"];
    if ([[cellData objectForKey:@"thisAll"] floatValue] >= 0) {
        self.thisLabel.backgroundColor = [UIColor colorWithQuick:62 green:131 blue:148];
    }else {
        self.thisLabel.backgroundColor = [UIColor colorWithQuick:170 green:38 blue:28];
    }
}

@end
