#import "ScrumlabAppAvailability.h"
#import <scrumlab_flutter_appavailability/scrumlab_flutter_appavailability-Swift.h>

@implementation ScrumlabAppAvailability : NSObject 
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterPlugin registerWithRegistrar:registrar];
}
@end
