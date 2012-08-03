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

#import <Foundation/Foundation.h>

@interface NSObject (OPEnumerable)

-(id) map:(id(^)(id obj))mapper;

-(id) reduce:(id)initial :(id(^)(id sum, id obj))reducer;
-(int) reducei:(int)initial :(int(^)(int sum, id obj))reducer;
-(float) reducef:(float)initial :(float(^)(float sum, id obj))reducer;
-(double) reduced:(double)initial :(double(^)(double sum, id obj))reducer;
-(id) inject:(id)initial :(id(^)(id sum, id obj))injector;
-(int) injecti:(int)initial :(int(^)(int sum, id obj))injector;
-(float) injectf:(float)initial :(float(^)(float sum, id obj))injector;
-(double) injectd:(double)initial :(double(^)(double sum, id obj))injector;

-(id) find:(BOOL(^)(id obj))finder;
-(id) detect:(BOOL(^)(id obj))detector;

-(id) findAll:(BOOL(^)(id obj))finder;
-(id) select:(BOOL(^)(id obj))selector;

@end
