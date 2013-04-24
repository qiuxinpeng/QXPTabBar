

#import "QXPTabBar.h"

static int kInterTabMargin = 1;

@implementation QXPTabBar

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeRedraw;
        self.opaque = YES;
        self.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                 UIViewAutoresizingFlexibleHeight |
                                 UIViewAutoresizingFlexibleTopMargin);
    }
    return self;
}

#pragma mark - dealloc

- (void)dealloc{
    
    QXP_MC_RELEASE(_edgeColor);
    QXP_MC_RELEASE(_tabColors);
    QXP_MC_RELEASE(_backgroundImageName);
    QXP_RELEASE(_tabs);
    QXP_RELEASE(_selectedTab);
    QXP_SUPER_DEALLOC;
}


#pragma mark - Setters and Getters

- (void)setTabs:(NSArray *)array
{
    if (_tabs != array) {
        for (QXPTab *tab in _tabs) {
            [tab removeFromSuperview];
        }
        
        _tabs =QXP_RETAIN(array) ;
        
        for (QXPTab *tab in _tabs) {
            tab.userInteractionEnabled = YES;
            [tab addTarget:self action:@selector(tabSelected:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    [self setNeedsLayout];
}

- (void)setSelectedTab:(QXPTab *)selectedTab {
    if (selectedTab != _selectedTab) {
        [_selectedTab setSelected:NO];
        _selectedTab = QXP_RETAIN(selectedTab);
        [_selectedTab setSelected:YES];
    }
}

#pragma mark - Delegate notification

- (void)tabSelected:(QXPTab *)sender
{
    [_delegate tabBar:self didSelectTabAtIndex:[_tabs indexOfObject:sender]];
}


#pragma mark - Drawing & Layout

- (void)drawRect:(CGRect)rect
{
    // 绘制标签栏背景
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	    
    // 填补背景噪声图案
    [[UIColor colorWithPatternImage:[UIImage imageNamed:_backgroundImageName ? _backgroundImageName : @"selectedBackgroundImage"]] set];
    
    CGContextFillRect(ctx, rect);
    
    // 绘制渐变
    CGContextSaveGState(ctx);
    {
        // 设置参数的梯度乘法混合
        size_t num_locations = 2;
        CGFloat locations[2] = {0.0, 1.0};
        CGFloat components[8] = {0.9, 0.9, 0.9, 1.0,    // 开始颜色
                                 0.2, 0.2, 0.2, 0.8};    // 结束颜色
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = _tabColors ? CGGradientCreateWithColors(colorSpace, (QXP_WIBridge CFArrayRef)_tabColors, locations) : CGGradientCreateWithColorComponents (colorSpace, components, locations, num_locations);
        CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
        CGContextDrawLinearGradient(ctx, gradient, CGPointMake(0, 0), CGPointMake(0, rect.size.height), kCGGradientDrawsAfterEndLocation);
        
        CGColorSpaceRelease(colorSpace);
        CGGradientRelease(gradient);
    }
    CGContextRestoreGState(ctx);
    
    // 绘制顶部暗浮雕
    CGContextSaveGState(ctx);
    {
        CGContextSetFillColorWithColor(ctx, _edgeColor ? [_edgeColor CGColor] : [[UIColor colorWithRed:.1f green:.1f blue:.1f alpha:.8f] CGColor]);
        CGContextFillRect(ctx, CGRectMake(0, 0, rect.size.width, 1));
    }
    CGContextRestoreGState(ctx);
    
    // 绘制顶部亮浮雕
    CGContextSaveGState(ctx);
    {
        CGContextSetBlendMode(ctx, kCGBlendModeOverlay);
        CGContextSetRGBFillColor(ctx, 0.9, 0.9, 0.9, 0.7);
        CGContextFillRect(ctx, CGRectMake(0, 1, rect.size.width, 1));

    }
    CGContextRestoreGState(ctx);
        
    // 绘制边缘的边界线
    CGContextSetFillColorWithColor(ctx, _edgeColor ? [_edgeColor CGColor] : [[UIColor colorWithRed:.1f green:.1f blue:.1f alpha:.8f] CGColor]);
    for (QXPTab *tab in _tabs)
        CGContextFillRect(ctx, CGRectMake(tab.frame.origin.x - kInterTabMargin, 0, kInterTabMargin, rect.size.height));
    
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat screenWidth = self.bounds.size.width;
    
    CGFloat tabNumber = _tabs.count;
    
    // 计算的标签宽度。
    CGFloat tabWidth = floorf(((screenWidth + 1) / tabNumber) - 1);
    
    //因为屏幕尺寸的，它是不可能有相同的标签
    CGFloat spaceLeft = screenWidth - (tabWidth * tabNumber) - (tabNumber - 1);
    
    CGRect rect = self.bounds;
    rect.size.width = tabWidth;

    CGFloat dTabWith;
    
    for (QXPTab *tab in _tabs) {
    
        // 下面的代码是递增的宽度，直到我们使用所有剩余空间
        
        dTabWith = tabWidth;
        
        if (spaceLeft != 0) {
            dTabWith = tabWidth + 1;
            spaceLeft--;
        }
        
        if ([_tabs indexOfObject:tab] == 0) {
            tab.frame = CGRectMake(rect.origin.x, rect.origin.y, dTabWith, rect.size.height);
        } else {
            tab.frame = CGRectMake(rect.origin.x + kInterTabMargin, rect.origin.y, dTabWith, rect.size.height);
        }
        
        [self addSubview:tab];
        rect.origin.x = tab.frame.origin.x + tab.frame.size.width;
    }
    
}

@end