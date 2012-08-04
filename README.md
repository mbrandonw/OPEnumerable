OPEnumerable
============

This defines some methods on `NSObject` that are applicable only to objects conforming to the `NSFastEnumeration` protocol. These methods are very similar to the ones defined in Ruby's [Enumerable module](http://ruby-doc.org/core-1.9.3/Enumerable.html#method-i-find), and fully blocked based. For example, to select a subarray one can do:

```
NSArray *a = @[ @1, @1, @2, @3, @5, @8 ];
[a select:^(id obj){
  return [obj compare:@4] == NSOrderedAscending;
}];
//=> @[ @1, @1, @2, @3 ]
```

Another project doing something similar is [BlocksKit](https://github.com/zwaldowski/BlocksKit/), but the usage of [A2DynamicDelegate](https://github.com/pandamonia/A2DynamicDelegate) scares the crap out of me, so I decided to re-implement most of the methods more directly, and more simply.

##Installation

We love [CocoaPods](http://github.com/cocoapods/cocoapods), so we recommend you use it.

##Author

Brandon Williams  
brandon@opetopic.com  
[@mbrandonw](http://twitter.com/mbrandonw)  
[www.opetopic.com](http://www.opetopic.com)
