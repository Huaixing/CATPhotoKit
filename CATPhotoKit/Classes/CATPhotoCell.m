//
//  CATPhotoCell.m
//  TestOCLint
//
//  Created by Shihuaixing on 2020/8/5.
//  Copyright © 2020 Shihuaixing. All rights reserved.
//
#import <CATCommonKit/CATCommonKit.h>
#import "CATPhotoCell.h"
#import "CATLibrary.h"
#import "CATPhoto.h"
#import "UIImage+Bundle.h"

@interface CATPhotoCell ()<CATPhotoDownLoadDelegate>
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
        
        self.backgroundColor = [UIColor whiteColor];
        _photoView = [[UIImageView alloc] initWithFrame:self.bounds];
        _photoView.backgroundColor = [UIColor clearColor];
        _photoView.contentMode = UIViewContentModeScaleAspectFill;
        _photoView.clipsToBounds = YES;
        [self.contentView addSubview:_photoView];
        
        CGFloat checkButtonWidth = self.width * 2 / 5.0;
        CGFloat checkButtonHeight = self.height * 2 / 5.0;
        _checkButton = [[UIButton alloc] initWithFrame:CGRectMake(self.width - checkButtonWidth, 0, checkButtonWidth, checkButtonHeight)];
        _checkButton.backgroundColor = [UIColor redColor];
        [_checkButton addTarget:self action:@selector(checkButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_checkButton];
        
        UIImage *image = [UIImage imageWithName:@"cat_photo_thumb_unselected_icon"];
        _checkView = [[UIImageView alloc] initWithImage:image];
        _checkView.right = _checkButton.width - 6;
        _checkView.bottom = _checkButton.height - 6;
        _checkView.backgroundColor = [UIColor clearColor];
        [_checkButton addSubview:_checkView];
        
        [self createVideoInfoView];
    }
    return self;
}

- (void)createVideoInfoView {
    _videoInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 20)];
    _videoInfoView.backgroundColor = [UIColor clearColor];
    _videoInfoView.bottom = self.height;
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
    _videoIconView.x = 6;
    _videoIconView.centerY = _videoInfoView.height / 2.0;
    [_videoInfoView addSubview:_videoIconView];
    
    _videoDurationLabel = [[UILabel alloc] initWithFrame:CGRectMake(_videoIconView.right + 6, 0, _videoInfoView.width - (_videoIconView.right + 6), _videoInfoView.height)];
    _videoDurationLabel.backgroundColor = [UIColor clearColor];
    _videoDurationLabel.textColor = [UIColor whiteColor];
    _videoDurationLabel.font = [UIFont systemFontOfSize:12.0];
    _videoDurationLabel.text = @"02:30";
    [_videoInfoView addSubview:_videoDurationLabel];
        
}

#pragma mark - Public
- (void)setPhoto:(CATPhoto *)photo {
    _photo = photo;
    [[CATPhotoManager shareManager] requestAssetImageWithPhoto:photo targetSize:_photoView.frame.size delegate:self];
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
        UIImage *selectedImage = [UIImage imageWithName:@"cat_photo_thumb_selected_icon"];
        _checkView.image = selectedImage;
    } else {
        UIImage *defaultImage = [UIImage imageWithName:@"cat_photo_thumb_unselected_icon"];
        _checkView.image = defaultImage;
    }
}

#pragma mark - CATPhotoDownLoadDelegate
- (void)photoManagerDownLoadSuccess:(CATPhotoManager *)manager result:(UIImage *)result identifier:(NSString *)identifier {
    if (identifier && result && [self.photo.localIdentifier isEqualToString:identifier]) {
        self.photoView.image = result;
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
