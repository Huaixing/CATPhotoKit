//
//  CATAuthorizedTipView.m
//  CATPhotoKit
//
//  Created by huaixing Shi on 2021/5/20.
//

#import "CATAuthorizedTipView.h"
#import <CATCommonKit.h>

@implementation CATAuthorizedTipView

#pragma mark - 无权限视图
- (instancetype)initNoneAuthViewWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"0xFFFFFF"];
        [self createNoneAuthSubViews];
    }
    return self;
}

- (void)createNoneAuthSubViews {
    
    UIView *contentView = [[UIView alloc] initWithFrame:self.bounds];
    contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:contentView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.width = contentView.width - 2 * 32;
    titleLabel.text = @"无法访问相册中照片";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithHexString:@"0x181818"];
    titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    [titleLabel sizeToFit];
    [contentView addSubview:titleLabel];
    
    
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.width = contentView.width - 2 * 32;
    messageLabel.text = @"当前无照片访问权限，建议前往系统设置，允许访问「照片」中的「所有照片」。";
    messageLabel.numberOfLines = 0;
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.textColor = [UIColor colorWithHexString:@"0x181818"];
    messageLabel.font = [UIFont systemFontOfSize:16];
    [messageLabel sizeToFit];
    [contentView addSubview:messageLabel];
    
    UIButton *settingButton = [[UIButton alloc] init];
    settingButton.backgroundColor = [UIColor colorWithHexString:@"0xF66071"];
    settingButton.layer.cornerRadius = 8;
    [settingButton addTarget:self action:@selector(settingPhotoAuthClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:settingButton];
    
    UILabel *settingLabel = [[UILabel alloc] init];
    settingLabel.text = @"前往系统设置";
    settingLabel.backgroundColor = [UIColor clearColor];
    settingLabel.textColor = [UIColor colorWithHexString:@"0xFFFFFF"];
    settingLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [settingLabel sizeToFit];
    [settingButton addSubview:settingLabel];
    
    
    titleLabel.centerX = contentView.width / 2.0;
    messageLabel.centerX = contentView.width / 2.0;
    messageLabel.y = titleLabel.bottom + 20;
    
    settingButton.width = settingLabel.width + 64;
    settingButton.height = settingLabel.height + 24;
    settingButton.centerX = contentView.width / 2.0;
    settingButton.y = messageLabel.bottom + 150;
    settingLabel.center = CGPointMake(settingButton.width / 2.0, settingButton.height / 2.0);
    
    contentView.height = settingButton.bottom;
    contentView.centerY = self.height / 2.0;
    
}

#pragma mark - 部分照片权限视图
- (instancetype)initLimitAuthViewWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"0xFFFFFF"];
        [self createLimitAuthSubViews];
    }
    return self;
}

- (void)createLimitAuthSubViews {
    
    UIView *contentView = [[UIView alloc] initWithFrame:self.bounds];
    contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:contentView];
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.width = contentView.width - 2 * 32;
    titleLabel.text = @"无法访问相册中所有照片";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor colorWithHexString:@"0x181818"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    [titleLabel sizeToFit];
    [contentView addSubview:titleLabel];
    
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.width = contentView.width - 2 * 32;
    messageLabel.text = @"当前只能访问相册中的部分照片，建议前往系统设置，允许访问「照片」中的「所有照片」。";
    messageLabel.numberOfLines = 0;
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.textColor = [UIColor colorWithHexString:@"0x181818"];
    messageLabel.font = [UIFont systemFontOfSize:16];
    [messageLabel sizeToFit];
    [contentView addSubview:messageLabel];
    
    
    UIButton *settingButton = [[UIButton alloc] init];
    settingButton.backgroundColor = [UIColor colorWithHexString:@"0xF66071"];
    settingButton.layer.cornerRadius = 8;
    [settingButton addTarget:self action:@selector(settingPhotoAuthClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:settingButton];
    
    UILabel *settingLabel = [[UILabel alloc] init];
    settingLabel.text = @"前往系统设置";
    settingLabel.backgroundColor = [UIColor clearColor];
    settingLabel.textColor = [UIColor colorWithHexString:@"0xFFFFFF"];
    settingLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [settingLabel sizeToFit];
    [settingButton addSubview:settingLabel];
    
    UIButton *continueButton = [[UIButton alloc] init];
    continueButton.backgroundColor = [UIColor clearColor];
    [continueButton addTarget:self action:@selector(continuePhotoAuthClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:continueButton];

    UILabel *continueLabel = [[UILabel alloc] init];
    continueLabel.text = @"继续访问部分照片";
    continueLabel.backgroundColor = [UIColor clearColor];
    continueLabel.textColor = [UIColor colorWithHexString:@"0x30C9E8"];
    continueLabel.font = [UIFont systemFontOfSize:15];
    [continueLabel sizeToFit];
    [continueButton addSubview:continueLabel];
    
    
    titleLabel.centerX = contentView.width / 2.0;
    messageLabel.centerX = contentView.width / 2.0;
    messageLabel.y = titleLabel.bottom + 20;
    
    settingButton.width = settingLabel.width + 64;
    settingButton.height = settingLabel.height + 24;
    settingButton.centerX = contentView.width / 2.0;
    settingButton.y = messageLabel.bottom + 150;
    settingLabel.center = CGPointMake(settingButton.width / 2.0, settingButton.height / 2.0);
    
    continueButton.width = continueLabel.width + 64;
    continueButton.height = continueLabel.height + 24;
    continueButton.centerX = contentView.width / 2.0;
    continueButton.y = settingButton.bottom + 30;
    continueLabel.center = CGPointMake(continueButton.width / 2.0, continueButton.height / 2.0);
    
    contentView.height = continueButton.bottom;
    contentView.centerY = self.height / 2.0;
    
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
