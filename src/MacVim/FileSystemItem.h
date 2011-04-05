//
//  FileSystemItem.h
//  MacVim
//
//  Created by Zack Bartel on 3/7/10.
//  Copyright 2010 GetBack Media, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FileSystemItem : NSObject
{
    NSString *relativePath;
    FileSystemItem *parent;
    NSMutableArray *children;
}

+ (FileSystemItem *)rootItem;
- (NSInteger)numberOfChildren;// Returns -1 for leaf nodes
- (FileSystemItem *)childAtIndex:(NSUInteger)n; // Invalid to call on leaf nodes
- (NSString *)fullPath;
- (NSString *)relativePath;

@end