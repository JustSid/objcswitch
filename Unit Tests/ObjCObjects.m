//
//  ObjCObjects.m
//  objcswitch
//
//  Created by Sidney Just on 14.03.12.
//  Copyright (c) 2012 Visuamobile. All rights reserved.
//

#import "ObjCObjects.h"

@implementation ObjCObjectWithHash

- (NSUInteger)hash
{
    return integer;
}

- (BOOL)isEqual:(id)object
{
    if([object isKindOfClass:[ObjCObjectWithHash class]])
    {
        ObjCObjectWithHash *other = object;
        return (other->integer == integer);
    }
    
    return NO;
}


- (id)initWithInt:(int)number
{
    if((self = [super init]))
    {
        integer = number;
    }
    
    return self;
}

@end


@implementation ObjCObjectWithoutHash

- (BOOL)isEqual:(id)object
{
    if([object isKindOfClass:[ObjCObjectWithoutHash class]])
    {
        ObjCObjectWithoutHash *other = object;
        return (other->integer == integer);
    }
    
    return NO;
}

- (id)initWithInt:(int)number
{
    if((self = [super init]))
    {
        integer = number;
    }
    
    return self;
}

@end
