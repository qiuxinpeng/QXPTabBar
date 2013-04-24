

#import "QXPTab.h"
#import "QXPISARC.h"
@class QXPTabBar;

@protocol QXPTabBarDelegate <NSObject>

@required

// 使用TabBarController标签被按下时事件
- (void)tabBar:(QXPTabBar *)AKTabBarDelegate didSelectTabAtIndex:(NSInteger)index;

@end

@interface QXPTabBar : UIView

@property (nonatomic, QXP_STRONG) NSArray *tabs;
@property (nonatomic, QXP_STRONG) QXPTab *selectedTab;
@property (nonatomic, QXP_WEAK) id <QXPTabBarDelegate> delegate;

// 顶部边界线颜色
@property (nonatomic, QXP_STRONG) UIColor *edgeColor;

// 标签选中的颜色。
@property (nonatomic, QXP_STRONG) NSArray *tabColors;

// 标签背景图片名称
@property (nonatomic, QXP_STRONG) NSString *backgroundImageName;

- (void)tabSelected:(QXPTab *)sender;

@end
