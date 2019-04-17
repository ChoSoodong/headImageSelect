






#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface SDAvatarPicker : NSObject

+ (void)avatarSelected:(void(^)(UIImage *image))compleiton;

@end

NS_ASSUME_NONNULL_END
