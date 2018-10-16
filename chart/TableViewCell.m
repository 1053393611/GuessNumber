//
//  TableViewCell.m
//  chart
//
//  Created by 钟程 on 2018/10/10.
//  Copyright © 2018 钟程. All rights reserved.
//

#import "TableViewCell.h"
#import <Masonry.h>

@interface TableViewCell()<UITextViewDelegate>{
    
}
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.textView.delegate = self;
    self.textView.userInteractionEnabled = NO;
//    NSLog(@"%@", self.textView.subviews.firstObject.subviews);
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
    [[self getTableView:self]  beginUpdates];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshCellHeight" object:@(height + 18)];
    [[self getTableView:self] endUpdates];

    [self.textView becomeFirstResponder];

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

//-(void)textViewDidChange:(UITextView *)textView{
//    if (textView.text.length==0) {
//        placeholderLabel.hidden=NO;
//    } else {
//        placeholderLabel.hidden=YES;
//    }
//    if ([self.delegate respondsToSelector:@selector(updatedText:atIndexPath:)]) {
//        [self.delegate updatedText:textView.text atIndexPath:_indexPath];
//    }
//    CGRect frame = textView.frame;
//    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
//    CGSize size = [textView sizeThatFits:constraintSize];
//    textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height + 18);
//
//    [(UITableView *)self.superview.superview beginUpdates];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshCellHeight" object:@(size.height + 18)];
//    [(UITableView *)self.superview.superview endUpdates];
//}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    textView.inputView = nil;
    [[NSNotificationCenter defaultCenter] addObserver:self   selector:@selector(keyboardWillShow:)  name:UIKeyboardWillShowNotification object: nil];

    return YES;
}
- (void)keyboardWillShow:(NSNotification *)Notification{
//    NSLog(@"%@",[[UIApplication sharedApplication] windows]);
    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:2];
    tempWindow.hidden = YES;
    [tempWindow setAlpha:0];
}

-(id)getTableView:(UIView *)sender{
    if ([sender isKindOfClass:[UITableView class]]) {
        return (UITableView *)sender;
    }
    return [self getTableView:sender.superview];
}

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
        view.layer.borderWidth = 1;
        view.layer.borderColor = [UIColor colorWithQuick:126 green:198 blue:113].CGColor;
        self.selectedBackgroundView = view;
        self.selectedBackgroundView.backgroundColor = [UIColor colorWithQuick:247 green:255 blue:246];
        [self.textView becomeFirstResponder];
    }else{
        //未选中时候的样式
        UIView *view = [[UIView alloc]initWithFrame:self.bounds];
        view.layer.borderWidth = 1;
        view.layer.borderColor = [UIColor colorWithQuick:126 green:198 blue:113].CGColor;
        self.selectedBackgroundView = view;
        self.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        [self.textView resignFirstResponder];
    }
}


@end
