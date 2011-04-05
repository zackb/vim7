#import <Cocoa/Cocoa.h>
#import "MMVimView.h"

@interface ZBFSDataSource : NSObject
{
	MMVimView *vimView;
}
@property(retain, readwrite) MMVimView *vimView;

@end
