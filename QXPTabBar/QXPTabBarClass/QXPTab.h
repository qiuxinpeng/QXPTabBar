
#import <QuartzCore/QuartzCore.h>
#import "QXPISARC.h"

@interface QXPTab : UIButton

// 用户绘制图标的图片名称.
@property (nonatomic, QXP_STRONG) NSString *tabImageWithName;

// 背景图片
@property (nonatomic, QXP_STRONG) NSString *backgroundImageName;

// 选中时的背景图片
@property (nonatomic, QXP_STRONG) NSString *selectedBackgroundImageName;

// 标签标题颜色
@property (nonatomic, QXP_STRONG) UIColor *textColor;

// 标签选中颜色
@property (nonatomic, QXP_STRONG) UIColor *selectedTextColor;

// 标题.
@property (nonatomic, QXP_STRONG) NSString *tabTitle;

// 标签icon颜色.
@property (nonatomic, QXP_STRONG) NSArray *tabIconColors;

// 标签选中图标的颜色。.
@property (nonatomic, QXP_STRONG) NSArray *tabIconColorsSelected;

// 选中标签的颜色,一般适用与渐变色
@property (nonatomic, QXP_STRONG) NSArray *tabSelectedColors;

// 标签高亮显示与否
@property (nonatomic, assign) BOOL glossyIsHidden;

// 选中标签边界线颜色
@property (nonatomic, QXP_STRONG) UIColor *strokeColor;

// 边界线颜色
@property (nonatomic, QXP_STRONG) UIColor *edgeColor;

// tabBar的高度.
@property (nonatomic, assign) CGFloat tabBarHeight;

// 允许标题的最低高度.
@property (nonatomic, assign) CGFloat minimumHeightToDisplayTitle;

// 用于是否显示标题.
@property (nonatomic, assign) BOOL titleIsHidden;

@end
