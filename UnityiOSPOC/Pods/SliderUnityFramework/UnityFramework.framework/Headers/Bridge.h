#import <Foundation/Foundation.h>

__attribute__ ((visibility("default")))
@protocol BridgeDelegate <NSObject>

- (void)didRecievedMessage:(NSString *)message;

@end

__attribute__ ((visibility("default")))
@interface Bridge : NSObject

+ (instancetype)shared;

@property (nonatomic, weak) id <BridgeDelegate> delegate;

- (void)send:(NSString *)message;

@end
