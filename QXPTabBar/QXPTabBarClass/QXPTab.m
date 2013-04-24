
#import "QXPTab.h"


// 淡入淡出动画持续时间.
static const float kAnimationDuration = 0.15;

// 填充内容与边界的距离
static const float kPadding = 4.0;

// 标题与icon之间距离
static const float kMargin = 2.0;

// 与顶部的距离
static const float kTopMargin = 2.0;

@interface QXPTab ()

// 允许两幅图像在几秒钟的持续时间之间的交叉淡入淡出动画。.
- (void)animateContentWithDuration:(CFTimeInterval)duration;

@end

@implementation QXPTab

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.backgroundColor = [UIColor clearColor];
        _titleIsHidden = NO;
    }
    return self;
}

#pragma mark - Touche handeling

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self animateContentWithDuration:kAnimationDuration];
}

#pragma mark - Animation

- (void)animateContentWithDuration:(CFTimeInterval)duration
{    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"contents"];
    animation.duration = duration;
    [self.layer addAnimation:animation forKey:@"contents"];
    [self setNeedsDisplay];
}

#pragma mark - dealloc

- (void)dealloc{
    QXP_MC_RELEASE(_tabImageWithName);
    QXP_MC_RELEASE(_backgroundImageName);
    QXP_MC_RELEASE(_selectedBackgroundImageName);
    QXP_MC_RELEASE(_textColor);
    QXP_MC_RELEASE(_selectedTextColor);
    QXP_MC_RELEASE(_tabTitle);
    QXP_MC_RELEASE(_tabIconColors);
    QXP_MC_RELEASE(_tabIconColorsSelected);
    QXP_MC_RELEASE(_tabSelectedColors);
    QXP_MC_RELEASE(_strokeColor);
    QXP_MC_RELEASE(_edgeColor);
    QXP_SUPER_DEALLOC;
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    // 如果高度的过短，不显示标题
    CGFloat offset = 1.0;
    
    if (!_minimumHeightToDisplayTitle)
        _minimumHeightToDisplayTitle = _tabBarHeight - offset;
    
    BOOL displayTabTitle = (CGRectGetHeight(rect) + offset >= _minimumHeightToDisplayTitle) ? YES : NO;
    
    if (_titleIsHidden) {
        displayTabTitle = NO;
    }
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    
    CGRect container = CGRectInset(rect, kPadding, kPadding);
    container.size.height -= kTopMargin;
    container.origin.y += kTopMargin;
    
    // 标签的image
    UIImage *image = [UIImage imageNamed:_tabImageWithName];
    
    // 获得最终的缩放比例
    CGFloat ratio = image.size.width / image.size.height;
    
    // 设置在imageContainer的大小。
    CGRect imageRect = CGRectZero;
    imageRect.size = image.size;
    
    // 标题lable
    UILabel *tabTitleLabel = [[UILabel alloc] init];
    tabTitleLabel.text = _tabTitle;
    tabTitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:11.0];
    CGSize labelSize = [tabTitleLabel.text sizeWithFont:tabTitleLabel.font forWidth:CGRectGetWidth(rect) lineBreakMode:NSLineBreakByTruncatingMiddle ];
    
    CGRect labelRect = CGRectZero;
    
    labelRect.size.height = (displayTabTitle) ? labelSize.height : 0;
    
    CGRect content = CGRectZero;
    content.size.width = CGRectGetWidth(container);
    
    // 基于图像的最长边的高度（不是方形时），标签的存在和高度
    content.size.height = MIN(MAX(CGRectGetWidth(imageRect), CGRectGetHeight(imageRect)) + ((displayTabTitle) ? (kMargin + CGRectGetHeight(labelRect)) : 0), CGRectGetHeight(container));
    
    
    content.origin.x = floorf(CGRectGetMidX(container) - CGRectGetWidth(content) / 2);
    content.origin.y = floorf(CGRectGetMidY(container) - CGRectGetHeight(content) / 2);
    
    labelRect.size.width = CGRectGetWidth(content);
    labelRect.origin.x = CGRectGetMinX(content);
    labelRect.origin.y = CGRectGetMaxY(content) - CGRectGetHeight(labelRect);
    
    if (!displayTabTitle) {
        labelRect = CGRectZero;
    }
    
    CGRect imageContainer = content;
    imageContainer.size.height = CGRectGetHeight(content) - ((displayTabTitle) ? (kMargin + CGRectGetHeight(labelRect)) : 0);
    
    // 当图像不是方形的，确保它不会超出
    if (CGRectGetWidth(imageRect) >= CGRectGetHeight(imageRect)) {
        imageRect.size.width = MIN(CGRectGetHeight(imageRect), MIN(CGRectGetWidth(imageContainer), CGRectGetHeight(imageContainer)));
        imageRect.size.height = floorf(CGRectGetWidth(imageRect) / ratio);
    } else {
        imageRect.size.height = MIN(CGRectGetHeight(imageRect), MIN(CGRectGetWidth(imageContainer), CGRectGetHeight(imageContainer)));
        imageRect.size.width = floorf(CGRectGetHeight(imageRect) * ratio);
    }
    
    imageRect.origin.x = floorf(CGRectGetMidX(content) - CGRectGetWidth(imageRect) / 2);
    imageRect.origin.y = floorf(CGRectGetMidY(imageContainer) - CGRectGetHeight(imageRect) / 2);
    
    CGFloat offsetY = rect.size.height - ((displayTabTitle) ? (kMargin + CGRectGetHeight(labelRect)) : 0) + kTopMargin;
    
    if (!self.selected) {
        
        // 绘制的边界的垂直线
        CGContextSaveGState(ctx);
        {
            CGContextSetBlendMode(ctx, kCGBlendModeOverlay);
            CGContextSetRGBFillColor(ctx, 0.7, 0.7, 0.7, 0.1);
            CGContextFillRect(ctx, CGRectMake(0, kTopMargin, 1, rect.size.height - kTopMargin));
            CGContextFillRect(ctx, CGRectMake(rect.size.width - 1, 2, 1, rect.size.height - 2));
        }
        CGContextRestoreGState(ctx);
        

        CGContextSaveGState(ctx);
        {
            CGContextTranslateCTM(ctx, 0, offsetY - 1);
            CGContextScaleCTM(ctx, 1.0, -1.0);
            CGContextClipToMask(ctx, imageRect, image.CGImage);
            CGContextSetRGBFillColor(ctx, 0, 0, 0, 0.8);
            CGContextFillRect(ctx, imageRect);
        }
        CGContextRestoreGState(ctx);
        
      
        CGContextSaveGState(ctx);
        {
            CGContextTranslateCTM(ctx, 0, offsetY);
            CGContextScaleCTM(ctx, 1.0, -1.0);
            CGContextClipToMask(ctx, imageRect, image.CGImage);
            
            size_t num_locations = 2;
            CGFloat locations[2] = {1.0, 0.0};
            CGFloat components[8] = {0.353, 0.353, 0.353, 1.0, // Start color
                0.612, 0.612, 0.612, 1.0};  // End color
            
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGGradientRef gradient = _tabIconColors ? CGGradientCreateWithColors(colorSpace, (QXP_WIBridge CFArrayRef)_tabIconColors, locations) : CGGradientCreateWithColorComponents (colorSpace, components, locations, num_locations);
            
            CGContextDrawLinearGradient(ctx, gradient, CGPointMake(0, imageRect.origin.y + imageRect.size.height), CGPointMake(0, imageRect.origin.y), kCGGradientDrawsAfterEndLocation);
            
            CGColorSpaceRelease(colorSpace);
            CGGradientRelease(gradient);
        }
        CGContextRestoreGState(ctx);
        
        if (displayTabTitle) {
            CGContextSaveGState(ctx);
            {
                UIColor *textColor = [UIColor colorWithRed:0.461 green:0.461 blue:0.461 alpha:1.0];
                CGContextSetFillColorWithColor(ctx, _textColor ? _textColor.CGColor : textColor.CGColor);
                [tabTitleLabel.text drawInRect:labelRect withFont:tabTitleLabel.font lineBreakMode:NSLineBreakByTruncatingMiddle  alignment:UITextAlignmentCenter];
            }
            CGContextRestoreGState(ctx);
        }
        
    } else if (self.selected) {
        
        // 填充背景噪声模式
        CGContextSaveGState(ctx);
        {
            [[UIColor colorWithPatternImage:[UIImage imageNamed:_selectedBackgroundImageName ? _selectedBackgroundImageName : @"selectedBackgroundImage"]] set];
            CGContextFillRect(ctx, rect);
            
            // We set the parameters of th gradient multiply blend
            size_t num_locations = 2;
            CGFloat locations[2] = {1.0, 0.0};
            CGFloat components[8] = {0.6, 0.6, 0.6, 1.0,  // Start color
                0.2, 0.2, 0.2, 0.4}; // End color
            
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGGradientRef gradient = _tabSelectedColors ? CGGradientCreateWithColors(colorSpace, (QXP_WIBridge CFArrayRef)_tabSelectedColors, locations) : CGGradientCreateWithColorComponents (colorSpace, components, locations, num_locations);
            CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
            CGContextDrawLinearGradient(ctx, gradient, CGPointMake(0, kTopMargin), CGPointMake(0, rect.size.height - kTopMargin), kCGGradientDrawsAfterEndLocation);
            
          
            CGContextSetBlendMode(ctx, kCGBlendModeNormal);
            CGContextSetFillColorWithColor(ctx, _edgeColor ? [_edgeColor CGColor] : [[UIColor colorWithRed:.1f green:.1f blue:.1f alpha:.8f] CGColor]);
            CGContextFillRect(ctx, CGRectMake(0, 0, rect.size.width, 1));
            
            CGColorSpaceRelease(colorSpace);
            CGGradientRelease(gradient);
        }
        CGContextRestoreGState(ctx);
        
        // 边界的垂直线
        CGContextSaveGState(ctx);
        {
            CGContextSetBlendMode(ctx, kCGBlendModeOverlay);
            CGContextSetFillColorWithColor(ctx, _strokeColor ? [_strokeColor CGColor] : [[UIColor colorWithRed:.7f green:.7f blue:.7f alpha:.4f] CGColor]);
            CGContextFillRect(ctx, CGRectMake(0, 2, 1, rect.size.height - 2));
            CGContextFillRect(ctx, CGRectMake(rect.size.width - 1, 2, 1, rect.size.height - 2));
        }
        CGContextRestoreGState(ctx);
        
        // 画外发光
        CGContextSaveGState(ctx);
        {
            CGContextTranslateCTM(ctx, 0.0, offsetY);
            CGContextScaleCTM(ctx, 1.0, -1.0);
            CGContextSetShadowWithColor(ctx, CGSizeMake(0, 0), 10.0, [UIColor colorWithRed:0.169 green:0.418 blue:0.547 alpha:1].CGColor);
            CGContextSetBlendMode(ctx, kCGBlendModeOverlay);
            CGContextDrawImage(ctx, imageRect, image.CGImage);
            
        }
        CGContextRestoreGState(ctx);
        
        CGContextSaveGState(ctx);
        {
            CGContextTranslateCTM(ctx, 0, offsetY);
            CGContextScaleCTM(ctx, 1.0, -1.0);
            CGContextClipToMask(ctx, imageRect, image.CGImage);
            
            size_t num_locations = 2;
            CGFloat locations[2] = {1.0, 0.2};
            CGFloat components[8] = {0.082, 0.369, 0.663, 1.0, // Start color
                0.537, 0.773, 0.988, 1.0};  // End color
            
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGGradientRef gradient = _tabIconColorsSelected ? CGGradientCreateWithColors(colorSpace, (QXP_WIBridge CFArrayRef)_tabIconColorsSelected, locations) : CGGradientCreateWithColorComponents (colorSpace, components, locations, num_locations);
            
            CGContextDrawLinearGradient(ctx, gradient, CGPointMake(0, imageRect.origin.y + imageRect.size.height), CGPointMake(0, imageRect.origin.y), kCGGradientDrawsAfterEndLocation);
            
            CGColorSpaceRelease(colorSpace);
            CGGradientRelease(gradient);
        }
        CGContextRestoreGState(ctx);
        
        
        // 在图像中绘制的光泽效果
        CGContextSaveGState(ctx);
        {   
            // 圆心+偏移量，合适的角度
            CGFloat posX = CGRectGetMinX(container) - CGRectGetHeight(container);
            CGFloat posY = CGRectGetMinY(container) - CGRectGetHeight(container) * 2 - CGRectGetWidth(container);
            
            // 获取图标中心
            CGFloat dX = CGRectGetMidX(imageRect) - posX;
            CGFloat dY = CGRectGetMidY(imageRect) - posY;
            
            // 计算半径
            CGFloat radius = sqrtf((dX * dX) + (dY * dY));
            
            // 绘制圆形路径
            CGMutablePathRef glossPath = CGPathCreateMutable();
            CGPathAddArc(glossPath, NULL, posX, posY, radius, M_PI, 0, YES);
            CGPathCloseSubpath(glossPath);
            CGContextAddPath(ctx, glossPath);
            CGContextClip(ctx);
            
            // 裁剪图像路径
            CGContextTranslateCTM(ctx, 0, offsetY);
            CGContextScaleCTM(ctx, 1.0, -1.0);
            CGContextClipToMask(ctx, imageRect, image.CGImage);
            
            size_t num_locations = 2;
            CGFloat locations[2] = {1, 0};
            CGFloat components[8] = {1.0, 1.0, 1.0, _glossyIsHidden ? 0 : 0.5, // Start color
                1.0, 1.0, 1.0, _glossyIsHidden ? 0 : 0.15};  // End color
            
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGGradientRef gradient = CGGradientCreateWithColorComponents (colorSpace, components, locations, num_locations);
            CGContextDrawRadialGradient(ctx, gradient, CGPointMake(CGRectGetMinX(imageRect), CGRectGetMinY(imageRect)), 0, CGPointMake(CGRectGetMaxX(imageRect), CGRectGetMaxY(imageRect)), radius, kCGGradientDrawsBeforeStartLocation);
            
            CGColorSpaceRelease(colorSpace);
            CGGradientRelease(gradient);
            CGPathRelease(glossPath);
        }
        CGContextRestoreGState(ctx);
        
        if (displayTabTitle) {
            CGContextSaveGState(ctx);
            {
                UIColor *textColor = [UIColor colorWithRed:0.961 green:0.961 blue:0.961 alpha:1.0];
                CGContextSetFillColorWithColor(ctx, _selectedTextColor ? _selectedTextColor.CGColor : textColor.CGColor);
                [tabTitleLabel.text drawInRect:labelRect withFont:tabTitleLabel.font lineBreakMode:NSLineBreakByTruncatingMiddle  alignment:UITextAlignmentCenter];
            }
            CGContextRestoreGState(ctx);
        }
        
    }
    
    
    QXP_RELEASE(tabTitleLabel);
    
}
@end