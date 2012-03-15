# ObjCSwitch

An experimental switch/case implementation for Objective-C objects, build with some block magic. The syntax basically follows the known C switch/case syntax, but has some limitations, for example, its not possible to "fall-through" cases.

The default comparison of objects uses the `- isEqual` method, so if you want to use it with your custom objects, you have to overwrite this method! Also note that if you overwrite the `- hash` method, the default comparison will first check the hashes of the objects against each other before calling `- isEqual`.

## Syntax

A simple example would be:

	[[@"foo" switch]
	 case:@"bar" :^{NSLog(@"This doesn't look right");}
	 case:@"baz" :^{NSLog(@"This doesn't look right either");}
	 case:@"foo" :^{NSLog(@"Thats correct");}
	 ];
     
     
However, you can also use default: and blocks to provide your own comparison. The example below shows you how to make a case insentive switch/case for strings:

     ObjCSwitchCompareBlock block = ^BOOL(id evaluateObject, id object) {
        NSString *evaluteString = evaluateObject;
        NSString *string = object;
        
        return ([evaluteString compare:string options:NSCaseInsensitiveSearch] == NSOrderedSame);
    };
    
	[[@"FoO" switchWithBlock:block]
	 case:@"bar" :^{NSLog(@"This doesn't look right");}
	 case:@"baz" :^{NSLog(@"This doesn't look right either");}
	 case:@"fOo" :^{NSLog(@"Thats correct");}
     default:^{NSLog(@"We shouldn't be here...");}
	 ];
