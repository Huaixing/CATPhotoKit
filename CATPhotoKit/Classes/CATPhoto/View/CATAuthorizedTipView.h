//
//  CATAuthorizedTipView.h
//  CATPhotoKit
//
//  Created by huaixing Shi on 2021/5/20.
//

#import <UIKit/UIKit.h>

typedef void(^CATHandleContinueLimitAction)(void);
@interface CATAuthorizedTipView : UIView

- (instancetype)initNoneAuthViewWithFrame:(CGRect)frame;


@property (nonatomic, copy) CATHandleContinueLimitAction handleAction;
- (instancetype)initLimitAuthViewWithFrame:(CGRect)frame;
@end

