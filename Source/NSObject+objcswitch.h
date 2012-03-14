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

// Return the switch object, which implements the actual case::case:: methods
@interface NSObject (objcswitch)
- (id)switch;
@end
