#ifndef QXPISARC_h

#define QXPISARC_h

#ifndef QXP_STRONG

#if __has_feature(objc_arc)

#define QXP_STRONG strong

#else

#define QXP_STRONG retain

#endif

#endif


#ifndef QXP_STRONG_COPY

#if __has_feature(objc_arc)

#define QXP_STRONG_COPY strong

#else

#define QXP_STRONG_COPY copy

#endif

#endif


#ifndef QXP_WEAK

#if __has_feature(objc_arc_weak)

#define QXP_WEAK weak

#elif __has_feature(objc_arc)

#define QXP_WEAK unsafe_unretained

#else

#define QXP_WEAK assign

#endif

#endif


#if __has_feature(objc_arc)

#define QXP_AUTORELEASE(expression) 

#define QXP_RELEASE(expression) 

#define QXP_MC_RELEASE(expression) expression=nil

#define QXP_RETAIN(expression) 

#define QXP_WIWeak __unsafe_unretained

#define QXP_WIBridge __bridge

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 60000

#define QXP_DispatchQueueRelease(expression) 

#else

#define QXP_DispatchQueueRelease(expression) (dispatch_release(expression)) 

#endif

#define QXP_SUPER_DEALLOC

#else

#define QXP_AUTORELEASE(expression) [expression autorelease]

#define QXP_RELEASE(expression) [expression release]

#define QXP_MC_RELEASE(expression) [expression release]; expression=nil

#define QXP_RETAIN(expression) [expression retain]

#define QXP_WIWeak 

#define QXP_WIBridge

#define QXP_DispatchQueueRelease(expression)  (dispatch_release(expression))

#define QXP_SUPER_DEALLOC [super dealloc]

#endif



#endif