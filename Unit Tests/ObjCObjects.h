//
//  ObjCObjects.h
//  objcswitch
//
//  Created by Sidney Just on 14.03.12.
//  Copyright (c) 2012 Visuamobile. All rights reserved.
//

#import <Foundation/Foundation.h>

// Test object that wraps an integer and implements the hash method
@interface ObjCObjectWithHash : NSObject
{
    int integer;
}

- (NSUInteger)hash;
- (BOOL)isEqual:(id)object;

- (id)initWithInt:(int)number;

@end

// Test object that also wraps an integer but doesn't overwrite the hash method
@interface ObjCObjectWithoutHash : NSObject
{
    int integer;
}

- (BOOL)isEqual:(id)object;

- (id)initWithInt:(int)number;

@end
