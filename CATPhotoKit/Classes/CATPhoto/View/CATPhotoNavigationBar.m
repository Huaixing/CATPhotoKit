//
//  CATPhotoNavigationBar.m
//  CATPhotoKit
//
//  Created by huaixing Shi on 2021/5/13.
//

#import "CATPhotoNavigationBar.h"
#import <CATCommonKit.h>

@interface CATPhotoNavigationBar () {
    CGFloat _contentInsert;
}

/// 状态栏
@property (nonatomic, strong) UIView *statusBar;
/// 导航栏内容
@property (nonatomic, strong) UIView *navigationBar;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation CATPhotoNavigationBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"0xFFFFFF"];
        _contentInsert = 20;
        
        
        _statusBar = [[UIView alloc] init];
        _statusBar.backgroundColor = [UIColor clearColor];
        [self addSubview:_statusBar];
        
        _navigationBar = [[UIView alloc] init];
        _navigationBar.backgroundColor = [UIColor clearColor];
        [self addSubview:_navigationBar];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"0x181818"];
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.hidden = YES;
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [_navigationBar addSubview:_titleLabel];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _statusBar.frame = CGRectMake(0, 0, self.width, [UIView statusBarHeight]);
    _navigationBar.frame = CGRectMake(0, _statusBar.bottom, self.width, self.height - _statusBar.height);
    
    /// 布局标题
    [self layoutTitleView];
    
    /// 布局左按钮
    [self layoutLeftBarButton];
    /// 布局右按钮
    [self layoutRightBarButton];
    
}

- (void)layoutLeftBarButton {
    if (_leftBarButton == nil) {
        return;
    }
    _leftBarButton.x = _contentInsert;
    _leftBarButton.centerY = _navigationBar.height / 2.0;
}

- (void)layoutRightBarButton {
    if (_rightBarButton == nil) {
        return;
    }
    _rightBarButton.right = _navigationBar.width - _contentInsert;
    _rightBarButton.centerY = _navigationBar.height / 2.0;
    
}

/// 布局标题
- (void)layoutTitleView {
    
    if (self.title.length) {
        _titleLabel.hidden = NO;
        
        CGFloat maxTitleWidth = [self calculateTitleViewMaxWidth];
        _titleLabel.width = maxTitleWidth;
        _titleLabel.height = _navigationBar.height;
        _titleLabel.centerX = _navigationBar.width / 2.0;
        
    } else {
        _titleLabel.hidden = YES;
    }
}


/// 获取标题的最大宽度
- (CGFloat)calculateTitleViewMaxWidth {
    CGFloat maxTitleWidth = self.width - 2 * _contentInsert;
    if (_rightBarButton && _leftBarButton) {
        /// 取左右按钮最大宽度，则标题两侧各减去该最大宽度。保证标题居中显示
        CGFloat maxItemWidth = MAX(_rightBarButton.width, _leftBarButton.width);
        maxTitleWidth -= 2 * maxItemWidth;
        
    } else if (!_rightBarButton && _leftBarButton) {
        /// 标题两侧各减去按钮宽度。保证标题居中显示
        maxTitleWidth -= 2 * _leftBarButton.width;
        
    } else if (_rightBarButton && !_leftBarButton) {
        /// 标题两侧各减去按钮宽度。保证标题居中显示
        maxTitleWidth -= 2 * _rightBarButton.width;
    }
    return maxTitleWidth;
}

#pragma mark - Public

- (void)setBarColor:(UIColor *)barColor {
    _barColor = barColor;
    _navigationBar.backgroundColor = barColor;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
    [self setNeedsLayout];
}

- (void)setLeftBarButton:(CATPhotoBarButton *)leftBarButton {
    if (_leftBarButton) {
        [_leftBarButton removeFromSuperview];
        _leftBarButton = nil;
    }
    _leftBarButton = leftBarButton;
    if (_leftBarButton) {
        [_navigationBar addSubview:_leftBarButton];
    }
    [self setNeedsLayout];
}

- (void)setRightBarButton:(CATPhotoBarButton *)rightBarButton {
    
    if (_rightBarButton) {
        [_rightBarButton removeFromSuperview];
        _rightBarButton = nil;
    }
    _rightBarButton = rightBarButton;
    if (_rightBarButton) {
        [_navigationBar addSubview:_rightBarButton];
    }
    [self setNeedsLayout];
}

@end
