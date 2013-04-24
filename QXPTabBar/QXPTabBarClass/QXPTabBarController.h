

#import "QXPTabBarView.h"
#import "QXPTabBar.h"
#import "QXPTab.h"

@interface QXPTabBarController : UIViewController <QXPTabBarDelegate, UINavigationControllerDelegate>


@property (nonatomic, QXP_STRONG) NSMutableArray *viewControllers;

// 显示标题的最低高度。
@property (nonatomic, assign) CGFloat minimumHeightToDisplayTitle;

// 用来显示/隐藏的标签标题.
@property (nonatomic, assign) BOOL tabTitleIsHidden;

// 标签的图标颜色。
@property (nonatomic, QXP_STRONG) NSArray *iconColors;

// 标签选择图标的颜色。
@property (nonatomic, QXP_STRONG) NSArray *selectedIconColors;

// 标签选中的颜色。
@property (nonatomic, QXP_STRONG) NSArray *tabColors;

// 标签选中的颜色。
@property (nonatomic, QXP_STRONG) NSArray *selectedTabColors;

// 标签图标光泽显示/隐藏
@property (nonatomic, assign) BOOL iconGlossyIsHidden;

// 标签行程颜色
@property (nonatomic, QXP_STRONG) UIColor *tabStrokeColor;

// 标签顶部边界线的颜色
@property (nonatomic, QXP_STRONG) UIColor *tabEdgeColor;

// 标签背景图片
@property (nonatomic, QXP_STRONG) NSString *backgroundImageName;

// 选项卡上选择的背景图像
@property (nonatomic, QXP_STRONG) NSString *selectedBackgroundImageName;

// 标签文字颜色
@property (nonatomic, QXP_STRONG)  UIColor *textColor;

// 选项卡中选定的文本颜色
@property (nonatomic, QXP_STRONG)  UIColor *selectedTextColor;

// 初始化与一个特定的高度。
- (id)initWithTabBarHeight:(NSUInteger)height;

@end
