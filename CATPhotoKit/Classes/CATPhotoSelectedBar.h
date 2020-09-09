//
//  CATPhotoSelectedBar.h
//  CATPhotoKit
//
//  Created by Shihuaixing on 2020/9/8.
//

#import <UIKit/UIKit.h>

@class CATPhotoSelectedBar;

@protocol CATPhotoSelectedBarDelegate <NSObject>

@optional

/// 点击done
/// @param seletedBar self
- (void)photoSelectedBarDidClickDone:(CATPhotoSelectedBar *)seletedBar;
@end

@interface CATPhotoSelectedBar : UIView

@property (nonatomic, weak) id<CATPhotoSelectedBarDelegate> delegate;

/// selected count
@property (nonatomic, assign) NSInteger count;
/// 选择栏底部留白，刘海屏适配
- (CGFloat)bottomMargin;

@end


