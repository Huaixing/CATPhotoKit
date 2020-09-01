//
//  CATAlbumCell.m
//  TestOCLint
//
//  Created by Shihuaixing on 2020/8/4.
//  Copyright © 2020 Shihuaixing. All rights reserved.
//

#import "CATAlbumCell.h"
#import "CATLibrary.h"
#import "CATAlbum.h"

@interface CATAlbumCell ()<CATPhotoDownLoadDelegate>
/***/
@property (nonatomic, strong) UIImageView *thumbView;
@property (nonatomic, strong) UILabel *albumNameLabel;

@end
@implementation CATAlbumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _thumbView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        _thumbView.backgroundColor = [UIColor clearColor];
        _thumbView.contentMode = UIViewContentModeScaleAspectFill;
        _thumbView.clipsToBounds = YES;
        [self.contentView addSubview:_thumbView];
        
        _albumNameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_albumNameLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    

    CGRect thumbFrame = _thumbView.frame;
    thumbFrame.origin.y = (CGRectGetHeight(self.frame) - CGRectGetHeight(_thumbView.frame)) / 2.0;
    _thumbView.frame = thumbFrame;
    
    _albumNameLabel.frame = CGRectMake(CGRectGetMaxX(_thumbView.frame) + 16, 0, 200, CGRectGetHeight(self.frame));
}

- (void)setAlbum:(CATAlbum *)album {
    _album = album;
    
    _thumbView.image = nil;
    if (_album.thumbImage) {
        _thumbView.image = album.thumbImage;
    } else {
        
        [[CATPhotoManager shareManager] requestAlbumThumbWithAlbum:album targetSize:_thumbView.frame.size delegate:self];
    }
    _albumNameLabel.text = [NSString stringWithFormat:@"%@----%lu", album.albumName, (unsigned long)album.assetCount];
}

#pragma mark - CATPhotoDownLoadDelegate
- (void)photoManagerDownLoadSuccess:(CATPhotoManager *)manager result:(UIImage *)result identifier:(NSString *)identifier {
    if (identifier && result && [self.album.thumbAsset.localIdentifier isEqualToString:identifier]) {
        self.thumbView.image = result;
        self.album.thumbImage = result;
    }
}

@end
