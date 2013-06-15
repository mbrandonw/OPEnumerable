// OPEnumerable
//
// Copyright (c) 2012 Brandon Williams (http://www.opetopic.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "NSObject+OPEnumerable.h"

#define OPAssertEnumerable  NSAssert([self conformsToProtocol:@protocol(NSFastEnumeration)], @"Object isn't enumerable.");
#define OPMutableSelfContainer()  [[[[self class] superclass] new] mutableCopy]
#define OPContainerIsDictionaryLike()  [self respondsToSelector:@selector(objectForKey:)]

@implementation NSObject (OPEnumerable)

-(void) each:(void(^)(id obj))iterator {
  OPAssertEnumerable

  for (id obj in (id<NSFastEnumeration>)self) {
    iterator(obj);
  }
}

-(BOOL) all:(BOOL(^)(id obj))block {
  OPAssertEnumerable

  for (id obj in (id<NSFastEnumeration>)self) {
    if (! block(obj)) {
      return NO;
    }
  }
  return YES;
}

-(BOOL) any:(BOOL(^)(id obj))block {
  OPAssertEnumerable

  for (id obj in (id<NSFastEnumeration>)self) {
    if (block(obj)) {
      return YES;
    }
  }
  return NO;
}

-(BOOL) none:(BOOL(^)(id obj))block {
  OPAssertEnumerable

  for (id obj in (id<NSFastEnumeration>)self) {
    if (block(obj)) {
      return NO;
    }
  }
  return YES;
}

-(BOOL) one:(BOOL(^)(id obj))block {
  OPAssertEnumerable

  BOOL retVal = NO;
  for (id obj in (id<NSFastEnumeration>)self) {
    if (retVal && (retVal = block(obj))) {
      return NO;
    }
  }
  return retVal;
}

-(id) map:(id(^)(id))mapper {
  OPAssertEnumerable

  BOOL isDictionary = OPContainerIsDictionaryLike();
  id retVal = OPMutableSelfContainer();

  for (id obj in (id<NSFastEnumeration>)self) {
    if (isDictionary) {
      [retVal setObject:mapper(obj) ?: [NSNull null] forKey:obj];
    } else {
      [retVal addObject:mapper(obj) ?: [NSNull null]];
    }
  }
  return retVal;
}

-(id) collect:(id(^)(id obj))collector {
  return [self map:collector];
}

-(id) reduce:(id)initial :(id(^)(id, id))reducer {
  OPAssertEnumerable

  id retVal = initial;
  for (id obj in (id<NSFastEnumeration>)self) {
    retVal = reducer(retVal, obj);
  }
  return retVal;
}

-(int) reducei:(int)initial :(int(^)(int, id))reducer {
  OPAssertEnumerable

  int retVal = initial;
  for (id obj in (id<NSFastEnumeration>)self) {
    retVal = reducer(retVal, obj);
  }
  return retVal;
}

-(float) reducef:(float)initial :(float(^)(float, id))reducer {
  OPAssertEnumerable

  float retVal = initial;
  for (id obj in (id<NSFastEnumeration>)self) {
    retVal = reducer(retVal, obj);
  }
  return retVal;
}

-(double) reduced:(double)initial :(double(^)(double, id))reducer {
  OPAssertEnumerable

  double retVal = initial;
  for (id obj in (id<NSFastEnumeration>)self) {
    retVal = reducer(retVal, obj);
  }
  return retVal;
}

-(id) inject:(id)initial :(id(^)(id sum, id obj))injector {
  return [self reduce:initial :injector];
}

-(int) injecti:(int)initial :(int(^)(int sum, id obj))injector {
  return [self reducei:initial :injector];
}

-(float) injectf:(float)initial :(float(^)(float sum, id obj))injector {
  return [self reducef:initial :injector];
}

-(double) injectd:(double)initial :(double(^)(double sum, id obj))injector {
  return [self reduced:initial :injector];
}

-(id) find:(BOOL(^)(id))finder {
  OPAssertEnumerable

  for (id obj in (id<NSFastEnumeration>)self) {
    if (finder(obj)) {
      return obj;
    }
  }
  return nil;
}

-(id) detect:(BOOL (^)(id))detector {
  return [self find:detector];
}

-(id) filter:(BOOL(^)(id obj))filter {
  return [self find:filter];
}

-(id) findAll:(BOOL(^)(id))finder {
  OPAssertEnumerable

  BOOL isDictionary = OPContainerIsDictionaryLike();
  id retVal = OPMutableSelfContainer();

  for (id obj in (id<NSFastEnumeration>)self) {
    if (finder(obj)) {
      if (isDictionary) {
        [retVal setObject:obj forKey:obj];
      } else {
        [retVal addObject:obj];
      }
    }
  }
  return retVal;
}

-(id) reject:(BOOL(^)(id obj))rejector {
  return [self findAll:^BOOL(id obj) {
    return ! rejector(obj);
  }];
}

-(id) compact {
  OPAssertEnumerable

  BOOL isDictionary = OPContainerIsDictionaryLike();
  id retVal = [self mutableCopy];

  for (id obj in (id<NSFastEnumeration>)self) {
    if (isDictionary && [retVal objectForKey:obj] == [NSNull null]) {
      [retVal removeObjectForKey:obj];
    } else if (! isDictionary && obj == [NSNull null]) {
      [retVal removeObject:obj];
    }
  }
  return retVal;
}

-(id) max {
  OPAssertEnumerable

  BOOL isDictionary = OPContainerIsDictionaryLike();
  id retVal = [self find:^BOOL(id obj) { return YES; }];
  for (id obj in (id<NSFastEnumeration>)self) {
    if (isDictionary && [[(id)self objectForKey:obj] compare:retVal] == NSOrderedDescending) {
      retVal = [(id)self objectForKey:obj];
    } else if (! isDictionary && [obj compare:retVal] == NSOrderedDescending) {
      retVal = obj;
    }
  }
  return retVal;
}

-(id) min {
  OPAssertEnumerable

  BOOL isDictionary = OPContainerIsDictionaryLike();
  id retVal = [self find:^BOOL(id obj) { return YES; }];
  for (id obj in (id<NSFastEnumeration>)self) {
    if (isDictionary && [[(id)self objectForKey:obj] compare:retVal] == NSOrderedAscending) {
      retVal = [(id)self objectForKey:obj];
    } else if (! isDictionary && [obj compare:retVal] == NSOrderedAscending) {
      retVal = obj;
    }
  }
  return retVal;
}

-(NSDictionary*) partition:(BOOL(^)(id obj))partitioner {
  OPAssertEnumerable

  NSDictionary *retVal = @{
                           @(YES) : [NSMutableSet new],
                           @(NO) : [NSMutableSet new]
                           };
  for (id obj in (id<NSFastEnumeration>)self) {
    [[retVal objectForKey:@(partitioner(obj))] addObject:obj];
  }
  return retVal;
}

@end
