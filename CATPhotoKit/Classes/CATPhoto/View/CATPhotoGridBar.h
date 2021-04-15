//
//  CATPhotoGridBar.h
//  CATPhotoKit
//
//  Created by Shihuaixing on 2020/9/8.
//

#import <UIKit/UIKit.h>

@class CATPhotoGridBar;

@protocol CATPhotoGridBarDelegate <NSObject>

@optional

/// 点击done
/// @param selectedBar self
- (void)photoGridBarDidClickDone:(CATPhotoGridBar *)selectedBar;
@end

@interface CATPhotoGridBar : UIView

@property (nonatomic, weak) id<CATPhotoGridBarDelegate> delegate;

/// selected count
@property (nonatomic, assign) NSInteger count;

@end


