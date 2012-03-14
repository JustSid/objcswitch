//
//  objcswitch_tests.m
//  objcswitch_tests
//
//  Created by Nicolas Bouilleaud on 16/01/12.
//  Copyright (c) 2012 Visuamobile. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "NSObject+objcswitch.h"
#import "ObjCObjects.h"

@interface ObjCSwitchTests : SenTestCase

@end


@implementation ObjCSwitchTests

- (void)test_respondsToSelectorBasic
{
    STAssertTrue([[@"foo" switch] respondsToSelector:@selector(case::)], @"bad!");
    STAssertTrue([[@"foo" switch] respondsToSelector:@selector(case::case::)], @"bad!");
    STAssertTrue([[@"foo" switch] respondsToSelector:@selector(case::case::case::)], @"bad!");
}

- (void)test_respondsToSelectorDefault
{
    STAssertTrue([[@"foo" switch] respondsToSelector:@selector(case::default:)], @"bad!");
    STAssertTrue([[@"foo" switch] respondsToSelector:@selector(case::case::default:)], @"bad!");
    STAssertTrue([[@"foo" switch] respondsToSelector:@selector(case::case::case::default:)], @"bad!");
}

- (void)test_respondsToSelectorMalformed
{
    STAssertFalse([[@"foo" switch] respondsToSelector:@selector(wrong)], @"bad!");
    STAssertFalse([[@"foo" switch] respondsToSelector:@selector(case::miss::case::default:)], @"bad!");
    STAssertFalse([[@"foo" switch] respondsToSelector:@selector(case::case::default:default:)], @"bad!");
}


- (void)test_nsobjectAdditions
{
    ObjCObjectWithHash *objHash = [[ObjCObjectWithHash alloc] initWithInt:42];
    ObjCObjectWithoutHash *objNoHash = [[ObjCObjectWithoutHash alloc] initWithInt:42];
    
    STAssertTrue([[objHash class] instanceImplementsHash], @"bad!");
    
    STAssertFalse([[objNoHash class] instanceImplementsHash], @"bad!");
    STAssertFalse([objNoHash isEqual:objHash], @"bad!");
    
    [objHash release];
    [objNoHash release];
}


- (void)test_objectWithHash
{
    ObjCObjectWithHash *object1 = [[ObjCObjectWithHash alloc] initWithInt:42];
    ObjCObjectWithHash *object2 = [[ObjCObjectWithHash alloc] initWithInt:42];
    
    BOOL __block success = NO;
    
    [[object1 switch]
     case:@"Hello World" :^{success = NO;}
     case:@"Hello" :^{success = NO;}
     case:object2 :^{success = YES;}
     ];
    
    STAssertTrue(success, @"bad!");
    
    [object1 release];
    [object2 release];
}

- (void)test_objectWithoutHash
{
    ObjCObjectWithoutHash *object1 = [[ObjCObjectWithoutHash alloc] initWithInt:42];
    ObjCObjectWithoutHash *object2 = [[ObjCObjectWithoutHash alloc] initWithInt:42];
    
    BOOL __block success = NO;
    
    [[object1 switch]
     case:@"Hello World" :^{success = NO;}
     case:@"Hello" :^{success = NO;}
     case:object2 :^{success = YES;}
     ];
    
    STAssertTrue(success, @"bad!");
    
    [object1 release];
    [object2 release];
}

- (void)test_default
{
    BOOL __block success = NO;
    
    [[@"foo" switch]
     case:@"bar" :^{success = NO;}
     case:@"baz" :^{success = NO;}
     default:^{success = YES;}
     ];
    
    STAssertTrue(success, @"bad!");
}

- (void)test_noFound
{
    BOOL __block success = YES;
    
    [[@"foo" switch]
     case:@"bar" :^{success = NO;}
     case:@"baz" :^{success = NO;}
     ];
    
    STAssertTrue(success, @"bad!");
}



- (void)testBasicCall_1
{
    BOOL __block success = NO;
    [[@"foo" switch]
     case:@"bar" :^{ success = NO; }
     case:@"foo" :^{ success = YES; }
     ];
    STAssertTrue(success,@"bad!");
}

- (void)testBasicCall_2 // Checks that the implementation is called correctly the second time
{
    [self testBasicCall_1];
}

- (void)testCall_2
{
    BOOL __block success = NO;
    [[@"foo" switch]
     case:@"bar" :^{ success = NO; }
     case:@"baz" :^{ success = NO; }
     case:@"foo" :^{ success = YES; }
     ];
    STAssertTrue(success,@"bad!");
}

- (void)testCallWithDefault_1
{
    BOOL __block success = NO;
    [[@"foo" switch]
     case:@"bar" :^{ success = NO; }
     case:@"baz" :^{ success = NO; }
     default:^{ success = YES;}
     ];
    STAssertTrue(success,@"bad!");
}

- (void)testCallWithDefault_2
{
    BOOL __block success = NO;
    [[@"foo" switch]
     case:@"bar" :^{ success = NO; }
     case:@"foo" :^{ success = YES; }
     default:^{ success = NO;}
     ];
    STAssertTrue(success,@"bad!");
}

@end
