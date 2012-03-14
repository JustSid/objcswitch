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

@interface NSObject (objcswitch)
// Return the switch object, which implements the actual case::case:: methods
- (id)switch;
// Returns true if the object implements the [hash] method
+ (BOOL)instanceImplementsHash;
@end
