//
//  CATNoAuthorizedView.m
//  TestOCLint
//
//  Created by Shihuaixing on 2020/8/10.
//  Copyright © 2020 Shihuaixing. All rights reserved.
//

#import "CATNoAuthorizedView.h"

@interface CATNoAuthorizedView ()

/**icon*/
@property (nonatomic, strong) UIImageView *iconView;

/**权限功能描述*/
@property (nonatomic, strong) UILabel *messageLabel;

/**icon*/
@property (nonatomic, copy) NSString *iconName;
/**message*/
@property (nonatomic, copy) NSString *message;
@end

@implementation CATNoAuthorizedView

- (instancetype)initWithFrame:(CGRect)frame iconName:(NSString *)iconName message:(NSString *)message {
    self = [super initWithFrame:frame];
    if (self) {
        _iconName = iconName;
        _message = message;
        
        _iconView = [[UIImageView alloc] init];
        _iconView.backgroundColor = [UIColor clearColor];
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
        _iconView.clipsToBounds = YES;
        _iconView.hidden = YES;
        [self addSubview:_iconView];
        
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.numberOfLines = 3;
        _messageLabel.hidden = YES;
        [self addSubview:_messageLabel];
        
    }
    return self;
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat contentHeight = 0;
    if (_iconName && _iconName.length) {
        UIImage *icon = [UIImage imageNamed:_iconName];
        if (icon) {
            _iconView.hidden = NO;
            _iconView.frame = CGRectMake(0, 0, icon.size.width, icon.size.height);
            _iconView.center = CGPointMake(CGRectGetWidth(self.frame) / 2.0, CGRectGetHeight(self.frame) / 2.0);
            contentHeight += CGRectGetHeight(_iconView.frame);
        }
    }
    
    if (_message && _message.length) {
        if (!_iconView.isHidden) {
            contentHeight += 20;
        }
        _messageLabel.hidden = NO;
        
        //设置label的行间距
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_message];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentLeft;
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        paragraphStyle.lineSpacing = 8.0;
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_message length])];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, [_message length])];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [_message length])];
        _messageLabel.attributedText = attributedString;
        [_messageLabel sizeToFit];
        CGSize size = [_messageLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.frame), MAXFLOAT)];
        _messageLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), size.height);
        _messageLabel.center = CGPointMake(CGRectGetWidth(self.frame) / 2.0, CGRectGetHeight(self.frame) / 2.0);
        contentHeight += CGRectGetHeight(_messageLabel.frame);
    }
    
    if (contentHeight) {
        CGFloat topY = (CGRectGetHeight(self.frame) - contentHeight) / 2.0;
        if (_iconView.isHidden) {
            CGRect labelFrame = _messageLabel.frame;
            labelFrame.origin.y = topY;
            _messageLabel.frame = labelFrame;
        } else {

            CGRect iconFrame = _iconView.frame;
            iconFrame.origin.y = topY;
            _iconView.frame = iconFrame;
            if (!_messageLabel.isHidden) {
                CGRect labelFrame = _messageLabel.frame;
                labelFrame.origin.y = CGRectGetMaxY(_iconView.frame) + 20;
                _messageLabel.frame = labelFrame;
                
            }
        }
    }
}



@end
