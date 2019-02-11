#import <Preferences/PSControlTableCell.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSSwitchTableCell.h>
#import <Preferences/PSTableCell.h>
#import <Preferences/PSViewController.h>
#import "PreferencesTableCustomView-Protocol.h"

@interface NSArray(Private)
- (id)specifierForID:(id)id;
@end

@interface HeaderCell : PSTableCell <PreferencesTableCustomView>
@end
