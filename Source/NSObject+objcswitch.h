//
//  NSObject+objcswitch.h
//  objcswitch
//
//  Created by Nicolas Bouilleaud on 16/01/12.
//  Copyright (c) 2012 Nicolas Bouilleaud. All rights reserved.
//
//  An experimental switch/case construct for objective-C objects.
//  Use it like that : 
//  
//  [[@"foo" switch]
//   case:@"bar" :^{ success = NO; }
//   case:@"baz" :^{ success = NO; }
//   case:@"foo" :^{ success = YES; }
//  ];
//

#import <Foundation/Foundation.h>

typedef void(^ObjCSwitchBlock)(void);

@interface ObjCSwitch : NSProxy
{
@private
    id target;
}

- (id)initWithTarget:(id)target;

@end


@interface NSObject (objcswitch)
// Return the switch object, which implements the actual case::case:: methods
- (ObjCSwitch *)switch;
// Returns true if the object implements the [hash] method
+ (BOOL)instanceImplementsHash;
@end



#define _ObjCSwitch  - (void)case:(id)obj :(ObjCSwitchBlock)block
#define _ObjCCase    case:(id)obj :(ObjCSwitchBlock)block
#define _ObjCDefault default:(ObjCSwitchBlock)block

@interface ObjCSwitch (casestubs)
// Method stubs for up to 10 cases with and without default at the end
// If you need more, or if you want to use default at some other place, just define it here.
// Only needed if you don't want to see the ugly compiler warnings...

_ObjCSwitch;
_ObjCSwitch _ObjCDefault;

_ObjCSwitch _ObjCCase;
_ObjCSwitch _ObjCCase _ObjCDefault;

_ObjCSwitch _ObjCCase _ObjCCase;
_ObjCSwitch _ObjCCase _ObjCCase _ObjCDefault;

_ObjCSwitch _ObjCCase _ObjCCase _ObjCCase;
_ObjCSwitch _ObjCCase _ObjCCase _ObjCCase _ObjCDefault;

_ObjCSwitch _ObjCCase _ObjCCase _ObjCCase _ObjCCase;
_ObjCSwitch _ObjCCase _ObjCCase _ObjCCase _ObjCCase _ObjCDefault;

_ObjCSwitch _ObjCCase _ObjCCase _ObjCCase _ObjCCase _ObjCCase;
_ObjCSwitch _ObjCCase _ObjCCase _ObjCCase _ObjCCase _ObjCCase _ObjCDefault;

_ObjCSwitch _ObjCCase _ObjCCase _ObjCCase _ObjCCase _ObjCCase _ObjCCase;
_ObjCSwitch _ObjCCase _ObjCCase _ObjCCase _ObjCCase _ObjCCase _ObjCCase _ObjCDefault;

_ObjCSwitch _ObjCCase _ObjCCase _ObjCCase _ObjCCase _ObjCCase _ObjCCase _ObjCCase;
_ObjCSwitch _ObjCCase _ObjCCase _ObjCCase _ObjCCase _ObjCCase _ObjCCase _ObjCCase _ObjCDefault;

_ObjCSwitch _ObjCCase _ObjCCase _ObjCCase _ObjCCase _ObjCCase _ObjCCase _ObjCCase _ObjCCase;
_ObjCSwitch _ObjCCase _ObjCCase _ObjCCase _ObjCCase _ObjCCase _ObjCCase _ObjCCase _ObjCCase _ObjCDefault;

_ObjCSwitch _ObjCCase _ObjCCase _ObjCCase _ObjCCase _ObjCCase _ObjCCase _ObjCCase _ObjCCase _ObjCCase _ObjCCase;
_ObjCSwitch _ObjCCase _ObjCCase _ObjCCase _ObjCCase _ObjCCase _ObjCCase _ObjCCase _ObjCCase _ObjCCase _ObjCCase _ObjCDefault;

@end

#undef _ObjCSwitch
#undef _ObjCCase
#undef _ObjCDefault
