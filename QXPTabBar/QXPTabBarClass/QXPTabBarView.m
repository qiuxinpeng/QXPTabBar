

#import "QXPTabBarView.h"

@implementation QXPTabBarView

#pragma mark - Setters

- (void)setTabBar:(QXPTabBar *)tabBar
{
    if (_tabBar != tabBar)
    {
        [_tabBar removeFromSuperview];
        _tabBar =QXP_RETAIN(tabBar) ;
        [self addSubview:tabBar];
    }
}


- (void)setContentView:(UIView *)contentView
{
    if (_contentView != contentView)
    {
        [_contentView removeFromSuperview];
        _contentView =QXP_RETAIN(contentView) ;
        _contentView.frame = CGRectZero;
        [self addSubview:_contentView];
        [self sendSubviewToBack:_contentView];
    }
}


#pragma mark - dealloc

- (void)dealloc{
    QXP_RELEASE(_tabBar);
    QXP_RELEASE(_contentView);
    QXP_SUPER_DEALLOC;
}


#pragma mark - Layout & Drawing

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect tabBarRect = _tabBar.frame;
    tabBarRect.origin.y = CGRectGetHeight(self.bounds) - CGRectGetHeight(_tabBar.bounds);
    [_tabBar setFrame:tabBarRect];
    
    CGRect contentViewRect = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - ((!_isTabBarHidding) ? CGRectGetHeight(_tabBar.bounds) : 0));
    _contentView.frame = contentViewRect;
    [_contentView setNeedsLayout];
}




@end
