//
//  CATPhotoViewBar.h
//  CATPhotoKit
//
//  Created by Shihuaixing on 2020/9/8.
//

#import <UIKit/UIKit.h>

@class CATPhotoViewBar;

@protocol CATPhotoViewBarDelegate <NSObject>

@optional

/// 点击done
/// @param selectedBar self
- (void)photoViewBarDidClickDone:(CATPhotoViewBar *)selectedBar;
@end

@interface CATPhotoViewBar : UIView

@property (nonatomic, weak) id<CATPhotoViewBarDelegate> delegate;

/// selected count
@property (nonatomic, assign) NSInteger count;

@end


