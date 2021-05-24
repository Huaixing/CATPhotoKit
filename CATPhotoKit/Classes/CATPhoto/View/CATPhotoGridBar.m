//
//  CATPhotoGridBar.m
//  CATPhotoKit
//
//  Created by Shihuaixing on 2020/9/8.
//

#import "CATPhotoGridBar.h"
#import "NSString+Bundle.h"
#import <CATCommonKit.h>

@interface CATPhotoGridBar ()
/// content view（适配刘海屏）
@property (nonatomic, strong) UIView *contentView;
/// 预览
@property (nonatomic, strong) UIButton *previewButton;
/// done & count
@property (nonatomic, strong) UIButton *doneButton;
/// done text
@property (nonatomic, strong) UILabel *textLabel;
@end

@implementation CATPhotoGridBar

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"0xFFFFFF"];
        
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor colorWithHexString:@"0xFFFFFF"];
        [self addSubview:_contentView];
        
        _previewButton = [[UIButton alloc] init];
        _previewButton.backgroundColor = [UIColor clearColor];
        _previewButton.exclusiveTouch = YES;
        [_previewButton setTitle:[NSString localizationString:@"photo_kit_preview_photo"] forState:UIControlStateNormal];
        _previewButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_previewButton setTitleColor:[UIColor colorWithHexString:@"0x181818"] forState:UIControlStateNormal];
        [_contentView addSubview:_previewButton];
        
        _doneButton = [[UIButton alloc] init];
        _doneButton.backgroundColor = [UIColor lightGrayColor];
        _doneButton.exclusiveTouch = YES;
        _doneButton.layer.cornerRadius = 4.0;
        _doneButton.clipsToBounds = YES;
        [_doneButton addTarget:self action:@selector(doneButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_doneButton];
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.font = [UIFont systemFontOfSize:15];
        _textLabel.textColor = [UIColor colorWithHexString:@"0xFFFFFF"];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.text = [NSString localizationString:@"photo_kit_picker_done"];
        [_doneButton addSubview:_textLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _contentView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - [UIView safeAreaInsetsBottom]);
    
    CGFloat preWidth = [_previewButton.titleLabel.text cat_sizeWithFont:_previewButton.titleLabel.font limitWidth:100].width;
    // 预览两个字距离左屏幕距离
    CGFloat preMargin = 16.0;
    _previewButton.frame = CGRectMake(0, 0, preWidth + 2 * preMargin, CGRectGetHeight(_contentView.frame));
    
    CGFloat countWidth = [_textLabel.text cat_sizeWithFont:_textLabel.font limitWidth:100].width;
    _textLabel.frame = CGRectMake(0, 0, countWidth, _textLabel.font.lineHeight);
    
    // 完成按钮上文案距离按钮左右距离
    CGFloat insert = 6.0;
    // 完成按钮距离contentView上下边缘的距离
    CGFloat doneMargin = 12.0;
    CGFloat doneWidth = CGRectGetWidth(_textLabel.frame) + 2 * insert;
    CGFloat doneX = CGRectGetWidth(_contentView.frame) - doneWidth - preMargin;
    _doneButton.frame = CGRectMake(doneX, doneMargin, doneWidth, CGRectGetHeight(_contentView.frame) - 2 * doneMargin);
    _textLabel.center = CGPointMake(CGRectGetWidth(_doneButton.frame) / 2.0, CGRectGetHeight(_doneButton.frame) / 2.0);
}

#pragma mark - Private
/// 没有选中任何照片时候的UI
- (void)updateUnselectedStatus {
    [_previewButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _doneButton.backgroundColor = [UIColor lightGrayColor];
    _textLabel.text = [NSString localizationString:@"photo_kit_picker_done"];
}

/// 有选中照片时的UI
- (void)updateSelectedStatus {
    [_previewButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _doneButton.backgroundColor = [UIColor blackColor];
    NSString *countString = [NSString stringWithFormat:[NSString localizationString:@"photo_kit_picker_some_photo_done"], (long)_count];
    
    _textLabel.text = countString;
}

#pragma mark - Public
- (void)setCount:(NSInteger)count {
    _count = count;
    
    if (count) {
        [self updateSelectedStatus];
    } else {
        [self updateUnselectedStatus];
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - Action
- (void)doneButtonDidClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoGridBarDidClickDone:)]) {
        [self.delegate photoGridBarDidClickDone:self];
    }
}
@end
