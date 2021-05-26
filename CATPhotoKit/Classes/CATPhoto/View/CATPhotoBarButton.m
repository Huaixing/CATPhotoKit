//
//  CATPhotoBarButton.m
//  CATPhotoKit
//
//  Created by huaixing Shi on 2021/5/13.
//

#import "CATPhotoBarButton.h"
#import "UIImage+Bundle.h"
#import <CATCommonKit.h>
#import "NSString+Bundle.h"

@interface CATPhotoBarButton ()

@property (nonatomic, assign) CATPhotoBarButtonType barButtonType;

/// back type
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *backIconView;

/// cnacel type
@property (nonatomic, strong) UIView *cancelView;
@property (nonatomic, strong) UILabel *cancelLabel;



@end

@implementation CATPhotoBarButton

+ (instancetype)barButtonWithBarButtonType:(CATPhotoBarButtonType)barButtonType target:(id)target action:(SEL)action {
    CATPhotoBarButton *button = [[CATPhotoBarButton alloc] init];
    button.barButtonType = barButtonType;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (instancetype)initWithFrame:(CGRect)frame {
    frame = CGRectMake(0, 0, 44, 44);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"0xFFFFFF"];
        
        [self addSubview:self.backView];
        [self.backView addSubview:self.backIconView];
        
        [self addSubview:self.cancelView];
        [self.cancelView addSubview:self.cancelLabel];
    }
    return self;
}

- (void)setBarButtonType:(CATPhotoBarButtonType)barButtonType {
    _barButtonType = barButtonType;
    
    if (barButtonType == CATPhotoBarButtonBack) {
        self.backView.hidden = NO;
    } else if (barButtonType == CATPhotoBarButtonCancel) {
        self.cancelView.hidden = NO;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    /// layout back type
    [self layoutBackTypeView];
    /// layout cancel type
    [self layoutCancelTypeView];
}

- (void)layoutBackTypeView {
    if (_barButtonType != CATPhotoBarButtonBack) {
        return;
    }
    self.backView.frame = self.bounds;
    self.backIconView.centerY = self.backView.height / 2.0;
}

- (void)layoutCancelTypeView {
    if (_barButtonType != CATPhotoBarButtonCancel) {
        return;
    }
    self.cancelView.frame = self.bounds;
    self.cancelLabel.frame = self.cancelView.bounds;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor clearColor];
        _backView.userInteractionEnabled = NO;
        _backView.hidden = YES;
    }
    return _backView;
}

- (UIImageView *)backIconView {
    if (!_backIconView) {
        _backIconView = [[UIImageView alloc] initWithImage:[UIImage imageWithName:@"cat_photo_navigation_back_icon"]];
        _backIconView.backgroundColor = [UIColor clearColor];
    }
    return _backIconView;
}


- (UIView *)cancelView {
    if (!_cancelView) {
        _cancelView = [[UIView alloc] init];
        _cancelView.backgroundColor = [UIColor clearColor];
        _cancelView.userInteractionEnabled = NO;
        _cancelView.hidden = YES;
    }
    return _cancelView;
}

- (UILabel *)cancelLabel {
    if (!_cancelLabel) {
        _cancelLabel = [[UILabel alloc] init];
        _cancelLabel.backgroundColor = [UIColor clearColor];
        _cancelLabel.text = [NSString localizationString:@"photo_navigation_bar_cancel"];
        _cancelLabel.textColor = [UIColor colorWithHexString:@"0x181818"];
        _cancelLabel.font = [UIFont systemFontOfSize:16];
    }
    return _cancelLabel;
}

@end
