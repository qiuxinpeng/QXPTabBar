

#import "UINavigationController+QXPTabBarController.h"

@implementation UINavigationController (QXPTabBarController)

- (NSString *)tabImageName
{
	return [[self.viewControllers objectAtIndex:0] tabImageName];
}

- (NSString *)tabTitle
{
	return [[self.viewControllers objectAtIndex:0] tabTitle];
}

@end
