//
//  NSObject+objcswitch.m
//  objcswitch
//
//  Created by Nicolas Bouilleaud on 16/01/12.
//  Copyright (c) 2012 Nicolas Bouilleaud. All rights reserved.
//

#import "NSObject+objcswitch.h"

@implementation ObjCSwitch

- (NSInteger)numberOfCasesInSelector:(SEL)selector defaultIndex:(NSInteger *)defaultIndex
{
    const char *str = (const char *)selector; // I just hope that a SEL is always a const char...
    if(defaultIndex)
        *defaultIndex = -1;
    
    
    NSInteger count = 0;
    while(str)
    {
        if(strncmp(str, "default:", 8) == 0)
        {
            str += 8;
            
            if(defaultIndex)
                *defaultIndex = count;
        }
        
        
        str = strstr(str, "case::");
        if(str)
        {
            str += 6;
            count ++;
        }
    }
    
    return count;
}

- (BOOL)validSelector:(SEL)selector
{
    const char *str = (const char *)selector;
    const char *tmp;
    
    BOOL foundDefault = NO;
    
    while(str)
    {
        if(strncmp(str, "default:", 8) == 0)
        {
            if(foundDefault)
                return NO;
            
            str += 8;
            foundDefault = YES;
            
            continue;
        }
        
        
        tmp = str;
        str = strstr(str, "case::");
        
        if(str)
        {
            if(tmp != str)
                return NO;
            
            str += 6;
        }
        else if(tmp == (const char *)selector)
            return NO;
    }
    
    return YES;
}

- (NSString *)objCTypesForSignature:(NSInteger)caseCount defaultIndex:(NSInteger)defaultIndex
{
    // Start with the return type and the two hidden argument self and _cmd
    NSMutableString *string = [NSMutableString stringWithFormat:@"%s%s%s", @encode(void), @encode(id), @encode(SEL)];
    BOOL placedDefault = NO;
    
    for(NSInteger i=0; i<caseCount; i++)
    {
        if(i == defaultIndex)
        {
            [string appendFormat:@"%s", @encode(ObjCSwitchBlock)];
            placedDefault = YES;
        }
        
        [string appendFormat:@"%s%s", @encode(id), @encode(ObjCSwitchBlock)];
    }
    
    
    // The default argument seems to be at the end...
    if(!placedDefault && defaultIndex != -1)
        [string appendFormat:@"%s", @encode(ObjCSwitchBlock)];
    
    return string;
}




- (BOOL)respondsToSelector:(SEL)selector
{
    return [self validSelector:selector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    NSInteger index;
    NSInteger cases = [self numberOfCasesInSelector:selector defaultIndex:&index];
    
    NSMethodSignature *signature = [NSMethodSignature signatureWithObjCTypes:[[self objCTypesForSignature:cases defaultIndex:index] UTF8String]];
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    SEL selector = [invocation selector];
    if(![self validSelector:selector])
    {
        [super forwardInvocation:invocation];
        return;
    }
    
    
    NSInteger index;
    NSInteger cases = [self numberOfCasesInSelector:selector defaultIndex:&index];
    NSInteger arguments = (cases * 2) + (index != -1 ? 1 : 0);
    
    index = (index != -1) ? index * 2 : -1; // case count doesn't include the two arguments that get passed per case, so we have to multiply the index by two
    
    
    for(NSInteger i=0; i<arguments; i++)
    {
        if(i == index)
            continue;
        
        id compareTo;
        ObjCSwitchBlock block;
        
        [invocation getArgument:&compareTo atIndex:i + 2];
        [invocation getArgument:&block atIndex:i + 3];
        
        i ++;
        
        if(compareBlock(evaluateObject, compareTo))
        {
            block();
            return;
        }
    }
    

    // Call default    
    if(index != -1)
    {
        ObjCSwitchBlock block;
        [invocation getArgument:&block atIndex:index + 2];
        
        block();
    }
}




- (id)initWithObject:(id)object andBlock:(ObjCSwitchCompareBlock)block
{
    evaluateObject = [object retain];
    compareBlock = Block_copy(block);
    
    return self;
}

- (void)dealloc
{
    Block_release(compareBlock);
    [evaluateObject release];
    
    [super dealloc];
}

@end





@implementation NSObject (objcswitch)

+ (BOOL)instanceImplementsHash
{
    return [NSObject instanceMethodForSelector:@selector(hash)] != [self instanceMethodForSelector:@selector(hash)];
}



- (id)switch
{
    BOOL __block canUseHash = [self->isa instanceImplementsHash];
    NSUInteger __block hash = [self hash];
    
    return [self switchWithBlock:^BOOL(id evaluateObject, id object) {
        if(canUseHash)
        {
            if(hash == [object hash])
                return [evaluateObject isEqual:object];
            
            return NO;
        }  
        
        return [evaluateObject isEqual:object];
    }];
}

- (id)switchWithBlock:(ObjCSwitchCompareBlock)block
{
    return [[[ObjCSwitch alloc] initWithObject:self andBlock:block] autorelease];
}

@end

