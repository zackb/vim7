//
//  FileSystemItem.m
//  MacVim
//
//  Created by Zack Bartel on 3/7/10.
//  Copyright 2010 GetBack Media, Inc. All rights reserved.
//

#import "FileSystemItem.h"


@implementation FileSystemItem
static FileSystemItem *rootItem = nil;

#define IsALeafNode ((id)-1)

- (id)initWithPath:(NSString *)path parent:(FileSystemItem *)obj {
    if ((self = [super init])) {
        relativePath = [[path lastPathComponent] copy];
        if (obj == nil)
		{
			NSMutableArray *pathComponents = [[NSMutableArray alloc] initWithArray: [path pathComponents]];
			if ([pathComponents count] > 1)
			{
				[pathComponents removeLastObject];
				[pathComponents removeObjectAtIndex: 0];
				NSString *p = [NSString stringWithFormat: @"/%@", [pathComponents componentsJoinedByString: @"/"]];
				NSLog(@"%@", p);
				obj = [[FileSystemItem alloc] initWithPath:p  parent: nil];
				[pathComponents release];
			}
		}
		parent = obj;
    }
    return self;
}

+ (FileSystemItem *)rootItem {
	if (rootItem == nil) rootItem = [[FileSystemItem alloc] initWithPath:@"/Users/zack/Sites/frequency/frequency" parent:nil];
	return rootItem;       
}

- (void)dealloc {
    if (children != IsALeafNode) [children release];
    [relativePath release];
    [super dealloc];
}

// Creates and returns the array of children
// Loads children incrementally
//
- (NSArray *)children {
    if (children == NULL) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *fullPath = [self fullPath];
        BOOL isDir, valid = [fileManager fileExistsAtPath:fullPath isDirectory:&isDir];
        if (valid && isDir) {
            NSArray *array = [fileManager directoryContentsAtPath:fullPath];
            NSInteger cnt, numChildren = [array count];
            children = [[NSMutableArray alloc] initWithCapacity:numChildren];
            for (cnt = 0; cnt < numChildren; cnt++) {
				FileSystemItem *item = [[FileSystemItem alloc] initWithPath:[array objectAtIndex:cnt] parent:self];
                [children addObject:item];
				[item release];
            }
        } else {
            children = IsALeafNode;
        }
    }
    return children;
}

- (NSString *)relativePath {
    return relativePath;
}

- (NSString *)fullPath {
    return parent ? [[parent fullPath] stringByAppendingPathComponent:relativePath] : relativePath;
}

- (FileSystemItem *)childAtIndex:(NSUInteger)n {
    return [[self children] objectAtIndex:n];
}

- (NSInteger)numberOfChildren {
    id tmp = [self children];
    return (tmp == IsALeafNode) ? (-1) : [tmp count];
}


@end
