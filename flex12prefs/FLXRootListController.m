#include "FLXRootListController.h"

@implementation FLXRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}

-(void)respring {
  [self postNotificationForName:CFSTR("respring")];
}

- (void)postNotificationForName:(CFStringRef)name {
  CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),
                                       name,
                                       nil,
                                       nil,
                                       true);
}

@end
