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
/// @param selectedBar self
- (void)photoSelectedBarDidClickDone:(CATPhotoSelectedBar *)selectedBar;
@end

@interface CATPhotoSelectedBar : UIView

@property (nonatomic, weak) id<CATPhotoSelectedBarDelegate> delegate;

/// selected count
@property (nonatomic, assign) NSInteger count;

@end


