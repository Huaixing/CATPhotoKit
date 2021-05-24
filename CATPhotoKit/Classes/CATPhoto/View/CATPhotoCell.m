//
//  CATPhotoCell.m
//  TestOCLint
//
//  Created by Shihuaixing on 2020/8/5.
//  Copyright © 2020 Shihuaixing. All rights reserved.
//
#import "CATPhotoCell.h"
#import "CATLibrary.h"
#import "CATPhoto.h"
#import "UIImage+Bundle.h"
#import <CATCommonKit.h>

@interface CATPhotoCell ()
/**imageview*/
@property (nonatomic, strong) UIImageView *photoView;

/// check button
@property (nonatomic, strong) UIButton *checkButton;
/// check icon
@property (nonatomic, strong) UIImageView *checkView;

@property (nonatomic, strong) UIView *videoInfoView;
@property (nonatomic, strong) UIImageView *videoIconView;
@property (nonatomic, strong) UILabel *videoDurationLabel;

@end

@implementation CATPhotoCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"0xFFFFFF"];
        _photoView = [[UIImageView alloc] initWithFrame:self.bounds];
        _photoView.backgroundColor = [UIColor clearColor];
        _photoView.contentMode = UIViewContentModeScaleAspectFill;
        _photoView.clipsToBounds = YES;
        [self.contentView addSubview:_photoView];
        
        CGFloat checkButtonWidth = CGRectGetWidth(self.frame) * 2 / 5.0;
        CGFloat checkButtonHeight = CGRectGetHeight(self.frame) * 2 / 5.0;
        _checkButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - checkButtonWidth, 0, checkButtonWidth, checkButtonHeight)];
        _checkButton.backgroundColor = [UIColor clearColor];
        [_checkButton addTarget:self action:@selector(checkButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_checkButton];
        
        UIImage *image = [UIImage imageWithName:@"cat_photo_kit_photo_unselected_icon"];
        _checkView = [[UIImageView alloc] initWithImage:image];
        
        CGRect checkFrame = _checkView.frame;
        checkFrame.origin.x = CGRectGetWidth(_checkButton.frame) - CGRectGetWidth(_checkView.frame) - 6;
        checkFrame.origin.y = CGRectGetHeight(_checkButton.frame) - CGRectGetHeight(_checkView.frame) - 6;
        _checkView.frame = checkFrame;
        _checkView.backgroundColor = [UIColor clearColor];
        [_checkButton addSubview:_checkView];
        
        [self createVideoInfoView];
    }
    return self;
}

- (void)createVideoInfoView {
    _videoInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 20)];
    _videoInfoView.backgroundColor = [UIColor clearColor];
    CGRect vFrame = _videoInfoView.frame;
    vFrame.origin.y = CGRectGetHeight(self.frame) - CGRectGetHeight(_videoInfoView.frame);
    _videoInfoView.frame = vFrame;
    [self.contentView addSubview:_videoInfoView];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.backgroundColor = [UIColor clearColor].CGColor;
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:0.0].CGColor, (__bridge id)[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:0.7].CGColor];
    gradientLayer.locations = @[@0, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.frame = _videoInfoView.bounds;
    [_videoInfoView.layer addSublayer:gradientLayer];
    
    _videoIconView = [[UIImageView alloc] initWithImage:[UIImage imageWithName:@"cat_photo_thumb_video_media_icon"]];
    _videoIconView.backgroundColor = [UIColor clearColor];
    
    CGRect vIconFrame = _videoIconView.frame;
    vIconFrame.origin.x = 6;
    _videoIconView.frame = vIconFrame;
    
    CGPoint vIconCenter = _videoIconView.center;
    vIconCenter.y = CGRectGetHeight(_videoInfoView.frame) / 2.0;
    _videoIconView.center = vIconCenter;
    
    [_videoInfoView addSubview:_videoIconView];
    
    _videoDurationLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_videoIconView.frame) + 6, 0, CGRectGetWidth(_videoInfoView.frame) - (CGRectGetMaxX(_videoIconView.frame) + 6), CGRectGetHeight(_videoInfoView.frame))];
    _videoDurationLabel.backgroundColor = [UIColor clearColor];
    _videoDurationLabel.textColor = [UIColor colorWithHexString:@"0xFFFFFF"];
    _videoDurationLabel.font = [UIFont systemFontOfSize:12.0];
    _videoDurationLabel.text = @"02:30";
    [_videoInfoView addSubview:_videoDurationLabel];
        
}

#pragma mark - Public
- (void)setPhoto:(CATPhoto *)photo {
    _photo = photo;
    
    __weak typeof(self) weakSelf = self;
    [[CATPhotoManager shareManager] requestAssetImageWithPhoto:photo targetSize:_photoView.frame.size complete:^(UIImage *result, NSString *identifier) {
        if (identifier && result && [weakSelf.photo.localIdentifier isEqualToString:identifier]) {
            weakSelf.photoView.image = result;
        }
    }];
    // 更新照片选中状态
    if (!self.canMultiplePick) {
        _checkButton.hidden = YES;
    } else {
        if (photo.mediaType == CATPhotoMediaTypeImage) {
            // 照片类型才有勾选状态
            _checkButton.hidden = NO;
            [self updatePhotoSelectedStatus];
        } else {
            // 非照片类型无勾选状态
            _checkButton.hidden = YES;
        }
    }
    
    // 更新视频信息显示状态
    if (photo.mediaType == CATPhotoMediaTypeVideo) {
        // 视频
        _videoInfoView.hidden = NO;
    } else {
        // 非视频
        _videoInfoView.hidden = YES;
    }
}

#pragma mark - Private

/// 更新照片的选中状态
- (void)updatePhotoSelectedStatus {
    if (_photo.isSelected) {
        UIImage *selectedImage = [UIImage imageWithName:@"cat_photo_kit_photo_selected_icon"];
        _checkView.image = selectedImage;
    } else {
        UIImage *defaultImage = [UIImage imageWithName:@"cat_photo_kit_photo_unselected_icon"];
        _checkView.image = defaultImage;
    }
}


#pragma mark - Action
- (void)checkButtonDidClick {
    BOOL canSelected = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoCell:shouldSelectedPhoto:)]) {
        canSelected = [self.delegate photoCell:self shouldSelectedPhoto:_photo];
    }
    if (!canSelected) {
        return;
    }
    _photo.selected = !_photo.isSelected;
    
    // 更新照片选中状态
    [self updatePhotoSelectedStatus];
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoCell:didSelectedPhoto:)]) {
        [self.delegate photoCell:self didSelectedPhoto:_photo];
    }
}

@end
