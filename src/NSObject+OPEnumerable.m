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

@implementation NSObject (OPEnumerable)

-(id) map:(id(^)(id))mapper {
    OPAssertEnumerable
    
    BOOL isDictionary = [[self class] isSubclassOfClass:[NSDictionary class]];
    id retVal = OPMutableSelfContainer();
    
    for (id obj in (id<NSFastEnumeration>)self)
    {
        if (isDictionary)
            [retVal setObject:mapper(obj) forKey:obj];
        else
            [retVal addObject:mapper(obj)];
    }
    return retVal;
}

-(id) reduce:(id)initial :(id(^)(id, id))reducer {
    OPAssertEnumerable
    
    id retVal = initial;
    for (id obj in (id<NSFastEnumeration>)self)
        retVal = reducer(retVal, obj);
    return retVal;
}

-(int) reducei:(int)initial :(int(^)(int, id))reducer {
    OPAssertEnumerable
    
    int retVal = initial;
    for (id obj in (id<NSFastEnumeration>)self)
        retVal = reducer(retVal, obj);
    return retVal;
}

-(float) reducef:(float)initial :(float(^)(float, id))reducer {
    OPAssertEnumerable
    
    float retVal = initial;
    for (id obj in (id<NSFastEnumeration>)self)
        retVal = reducer(retVal, obj);
    return retVal;
}

-(double) reduced:(double)initial :(double(^)(double, id))reducer {
    OPAssertEnumerable
    
    double retVal = initial;
    for (id obj in (id<NSFastEnumeration>)self)
        retVal = reducer(retVal, obj);
    return retVal;
}

-(id) find:(BOOL(^)(id))finder {
    OPAssertEnumerable
    
    for (id obj in (id<NSFastEnumeration>)self)
        if (finder(obj))
            return obj;
    
    return nil;
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

-(id) detect:(BOOL (^)(id))detector {
    return [self find:detector];
}

-(id) findAll:(BOOL(^)(id))finder {
    OPAssertEnumerable
    
    BOOL isDictionary = [[self class] isSubclassOfClass:[NSDictionary class]];
    id retVal = OPMutableSelfContainer();
    
    for (id obj in (id<NSFastEnumeration>)self)
    {
        if (finder(obj))
        {
            if (isDictionary)
                [retVal setObject:obj forKey:obj];
            else
                [retVal addObject:obj];
        }
    }
    return retVal;
}

-(id) select:(BOOL(^)(id))selector {
    return [self findAll:selector];
}

@end
