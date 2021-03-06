//
//  TFHppleTest.m
//  Hpple
//
//  Created by Geoffrey Grosenbach on 1/31/09.
//
//  Copyright (c) 2009 Topfunky Corporation, http://topfunky.com
//
//  MIT LICENSE
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <SenTestingKit/SenTestingKit.h>

#import "TFHpple.h"

#define TEST_DOCUMENT_PATH [[NSBundle mainBundle] pathForResource:@"feed" ofType: @"rss"]

@interface TFHppleXMLTest : SenTestCase
{
  TFHpple * doc;
}
@end

@implementation TFHppleXMLTest

- (void) dealloc { [super dealloc]; }

- (void) setUp
{
  NSData * data = [NSData dataWithContentsOfFile:TEST_DOCUMENT_PATH];
  doc = [[TFHpple alloc] initWithXMLData:data];
}

- (void) tearDown
{
  [doc release];
}

- (void) testInitializesWithXMLData
{
  STAssertTrue([doc isKindOfClass: [TFHpple class]], nil);
}

//  item/title,description,link
- (void) testSearchesWithXPath
{
  TFHppleXPathResult * result = [doc searchWithXPathQuery:@"//item"];
  STAssertEquals((int)[result count], 0x0f, nil);

  TFHppleElement * e = [result objectAtIndex:0];
  STAssertTrue([e isKindOfClass: [TFHppleElement class]], nil);
}

- (void) testFindsFirstElementAtXPath
{
  TFHppleElement * e = [doc peekAtSearchWithXPathQuery:@"//item/title"];

  STAssertEqualObjects([e content], @"Objective-C for Rubyists", nil);
  STAssertEqualObjects([e tagName], @"title", nil);
}

- (void) testSearchesByNestedXPath
{
  TFHppleXPathResult * result = [doc searchWithXPathQuery:@"//item/title"];
  STAssertEquals((int)[result count], 0x0f, nil); 
 
  TFHppleElement * e = [result objectAtIndex:0];
  STAssertEqualObjects([e content], @"Objective-C for Rubyists", nil);
}

- (void) testAtSafelyReturnsNilIfEmpty
{
  TFHppleElement * e = [doc peekAtSearchWithXPathQuery:@"//a[@class='sponsor']"];
  
  STAssertEqualObjects(e, nil, nil);
}

// Other Hpricot methods:
//  doc.at("body")['onload']
//  (doc/"#elementID").inner_html
//  (doc/"#elementID").to_html
//  doc.at("div > div:nth(1)").css_path
//  doc.at("div > div:nth(1)").xpath

@end
