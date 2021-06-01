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
#import <CATCommonKit.h>

@interface CATAlbumCell ()
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
    
    _thumbView.centerY = self.height / 2.0;
    _albumNameLabel.frame = CGRectMake(_thumbView.right + 16, 0, 200, self.height);
}

- (void)setAlbum:(CATAlbum *)album {
    _album = album;
    
    _thumbView.image = nil;
    if (_album.thumbImage) {
        _thumbView.image = album.thumbImage;
    } else {
        
        __weak typeof(self) weakSelf = self;
        [[CATPhotoManager shareManager] requestAlbumThumbWithAlbum:album targetSize:_thumbView.size complete:^(UIImage *result, NSString *identifier) {
            if (identifier && result && [weakSelf.album.thumbAsset.localIdentifier isEqualToString:identifier]) {
                weakSelf.thumbView.image = result;
                weakSelf.album.thumbImage = result;
            }
        }];
    }
    _albumNameLabel.text = [NSString stringWithFormat:@"%@----%lu", album.albumName, (unsigned long)album.assetCount];
}

@end
