

#import "QXPTabBar.h"
#import "QXPISARC.h"
@interface QXPTabBarView : UIView

@property (nonatomic, QXP_STRONG) QXPTabBar *tabBar;
@property (nonatomic, QXP_STRONG) UIView *contentView;
@property (nonatomic, assign) BOOL isTabBarHidding;
@end
