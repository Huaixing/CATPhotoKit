//
//  CATPhotoSelectedBar.m
//  CATPhotoKit
//
//  Created by Shihuaixing on 2020/9/8.
//

#import "CATPhotoSelectedBar.h"

@interface CATPhotoSelectedBar ()
/// content view（适配刘海屏）
@property (nonatomic, strong) UIView *contentView;
/// 预览
@property (nonatomic, strong) UIButton *previewButton;
/// done & count
@property (nonatomic, strong) UIButton *doneButton;
/// done text
@property (nonatomic, strong) UILabel *textLabel;
@end

@implementation CATPhotoSelectedBar

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor redColor];
        [self addSubview:_contentView];
        
        _previewButton = [[UIButton alloc] init];
        _previewButton.backgroundColor = [UIColor clearColor];
        _previewButton.exclusiveTouch = YES;
        [_previewButton setTitle:@"预览" forState:UIControlStateNormal];
        _previewButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_contentView addSubview:_previewButton];
        
        _doneButton = [[UIButton alloc] init];
        _doneButton.backgroundColor = [UIColor lightGrayColor];
        _doneButton.exclusiveTouch = YES;
        _doneButton.layer.cornerRadius = 4.0;
        _doneButton.clipsToBounds = YES;
        [_contentView addSubview:_doneButton];
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.backgroundColor = [UIColor redColor];
        _textLabel.font = [UIFont systemFontOfSize:15];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.text = @"完成";
        [_doneButton addSubview:_textLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _contentView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - self.bottomMargin);
    
    CGFloat preWidth = [self cat_sizeWithCount:_previewButton.titleLabel.text font:_previewButton.titleLabel.font];
    // 预览两个字距离左屏幕距离
    CGFloat preMargin = 16.0;
    _previewButton.frame = CGRectMake(0, 0, preWidth + 2 * preMargin, CGRectGetHeight(_contentView.frame));
    
    CGFloat countWidth = [self cat_sizeWithCount:_textLabel.text font:_textLabel.font];
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

/// 就是文本尺寸
/// @param content 文本
/// @param font 字体
/// @return 文案宽度
- (CGFloat)cat_sizeWithCount:(NSString *)content font:(UIFont *)font {
    if (content.length == 0) {
        return 0.0;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:font forKey:NSFontAttributeName];
    CGSize size = [content boundingRectWithSize:[UIScreen mainScreen].bounds.size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dict context:NULL].size;
    return ceil(size.width);
}


/// 没有选中任何照片时候的UI
- (void)updateUnselectedStatus {
    [_previewButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _doneButton.backgroundColor = [UIColor lightGrayColor];
    _textLabel.text = @"完成";
}

/// 有选中照片时的UI
- (void)updateSelectedStatus {
    [_previewButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _doneButton.backgroundColor = [UIColor blackColor];
    NSString *countString = [NSString stringWithFormat:@"完成 (%ld)", (long)_count];
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


/// 选择栏底部留白，刘海屏适配
- (CGFloat)bottomMargin {
    if (@available(iOS 11.0, *)) {
        return [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;;
    } else {
        // Fallback on earlier versions
        return 0.0;
    }
}
@end
