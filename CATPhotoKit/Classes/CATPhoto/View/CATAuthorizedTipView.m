//
//  CATAuthorizedTipView.m
//  CATPhotoKit
//
//  Created by huaixing Shi on 2021/5/20.
//

#import "CATAuthorizedTipView.h"
#import <CATCommonKit.h>

@interface CATAuthorizedTipView ()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) UIButton *settingButton;
@property (nonatomic, strong) UIButton *continueButton;
@end

@implementation CATAuthorizedTipView


- (instancetype)initWithAuthorizedType:(CATAuthorizedTipType)type {
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithHexString:@"0xFFFFFF"];
        [self createAuthSubViewsWithType:type];
    }
    return self;
}
#pragma mark - 无权限视图

- (void)createAuthSubViewsWithType:(CATAuthorizedTipType)type {
    
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:_contentView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = (type == CATAuthorizedTipNone ? @"无法访问相册中照片" : @"无法访问相册中所有照片");
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor colorWithHexString:@"0x181818"];
    _titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    [_contentView addSubview:_titleLabel];
    
    
    _messageLabel = [[UILabel alloc] init];
    _messageLabel.text = (type == CATAuthorizedTipNone ? @"当前无照片访问权限，建议前往系统设置，允许访问「照片」中的「所有照片」。" : @"当前只能访问相册中的部分照片，建议前往系统设置，允许访问「照片」中的「所有照片」。");
    _messageLabel.numberOfLines = 0;
    _messageLabel.backgroundColor = [UIColor clearColor];
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.textColor = [UIColor colorWithHexString:@"0x181818"];
    _messageLabel.font = [UIFont systemFontOfSize:16];
    [_contentView addSubview:_messageLabel];
    
    _settingButton = [[UIButton alloc] init];
    _settingButton.backgroundColor = [UIColor colorWithHexString:@"0xF66071"];
    _settingButton.layer.cornerRadius = 8;
    _settingButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_settingButton setTitle:@"前往系统设置" forState:UIControlStateNormal];
    [_settingButton setTitleColor:[UIColor colorWithHexString:@"0xFFFFFF"] forState:UIControlStateNormal];
    [_settingButton addTarget:self action:@selector(settingPhotoAuthClick) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_settingButton];
    
    if (type == CATAuthorizedTipLimit) {
        _continueButton = [[UIButton alloc] init];
        _continueButton.backgroundColor = [UIColor clearColor];
        _continueButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_continueButton setTitle:@"继续访问部分照片" forState:UIControlStateNormal];
        [_continueButton setTitleColor:[UIColor colorWithHexString:@"0x30C9E8"] forState:UIControlStateNormal];
        [_continueButton addTarget:self action:@selector(continuePhotoAuthClick) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_continueButton];
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    _contentView.frame = self.bounds;
    
    NSInteger insetMargin = 32;
    CGFloat contentHeight = 0;
    _titleLabel.width = _contentView.width - 2 * insetMargin;
    [_titleLabel sizeToFit];
    _titleLabel.centerX = _contentView.width / 2.0;
    contentHeight += _titleLabel.height;
    
    contentHeight += 20;
    _messageLabel.width = _contentView.width - 2 * insetMargin;
    [_messageLabel sizeToFit];
    _messageLabel.centerX = _contentView.width / 2.0;
    _messageLabel.y = contentHeight;
    contentHeight += _messageLabel.height;
    
    contentHeight += 150;
    CGSize settingSize = [_settingButton sizeThatFits:self.size];
    _settingButton.width = settingSize.width + 40;
    _settingButton.height = settingSize.height + 16;
    _settingButton.centerX = _contentView.width / 2.0;
    _settingButton.y = contentHeight;
    contentHeight += _settingButton.height;
    
    if (_continueButton) {
        contentHeight += 30;
        CGSize continueSize = [_continueButton sizeThatFits:self.size];
        _continueButton.width = continueSize.width + 40;
        _continueButton.height = continueSize.height + 16;
        _continueButton.centerX = _contentView.width / 2.0;
        _continueButton.y = contentHeight;
        contentHeight += _continueButton.height;
    }
    
    _contentView.height = contentHeight;
    _contentView.centerY = self.height / 2.0;
}

#pragma mark - Event
- (void)settingPhotoAuthClick {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}

- (void)continuePhotoAuthClick {
    if (self.handleAction) {
        self.handleAction();
    }
}

@end
