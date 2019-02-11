#import "HeaderCell.h"

@implementation HeaderCell
	- (id)initWithSpecifier:(PSSpecifier *)specifier{
	    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HeaderCell" specifier:specifier];
	    if (self) {
        NSBundle *bundle = [NSBundle bundleForClass:self.class];
            UIImage *banner = [UIImage imageNamed:@"FLEX12_git"
                                                  inBundle:bundle
                             compatibleWithTraitCollection:nil];
        float width = [UIScreen mainScreen].bounds.size.width;
        UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, width, width / 4.582)];

        [backgroundView setContentMode: UIViewContentModeScaleAspectFit];
        backgroundView.image = banner;
  			[self addSubview: backgroundView];
	    }

	    return self;
	}

  #pragma mark - Protocols

- (CGFloat)preferredHeightForWidth:(CGFloat)width {
  // Appears to be zero on the first call for w/e stupid reason. That breaks things?
  if (width == 0) {
    width = [UIScreen mainScreen].bounds.size.width;
  }
  // Our background has a ratio of 3.75w : 1h.
  return width / 4.582 + 7.5;
}

- (CGFloat)preferredHeightForWidth:(CGFloat)width inTableView:(id)tableView {
  return [self preferredHeightForWidth:width];
}

@end
