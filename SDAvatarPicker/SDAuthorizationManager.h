






#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SDAuthorizationType) {
    SDAuthorizationTypeCamera,
    SDAuthorizationTypePhotoLibrary,
    SDAuthorizationTypeMicrophone
};



@interface SDAuthorizationManager : NSObject

+ (void)checkAuthorization:(SDAuthorizationType)type
        firstRequestAccess:(void(^ __nullable)(void))requestAccess
                completion:(void(^)(BOOL isPermission))completion;


+ (void)requestAuthorization:(SDAuthorizationType)type;

@end

NS_ASSUME_NONNULL_END
