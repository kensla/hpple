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

#define TEST_DOCUMENT_PATH [[NSBundle mainBundle] pathForResource:@"index" ofType: @"html"]

@interface TFHppleHTMLTest : SenTestCase
{
  TFHpple * doc;
}
@end

@implementation TFHppleHTMLTest

- (void) dealloc { [super dealloc]; }

- (void) setUp
{
  NSData * data = [NSData dataWithContentsOfFile:TEST_DOCUMENT_PATH];
  doc = [[TFHpple alloc] initWithHTMLData:data];
}

- (void) tearDown
{
  [doc release];
}

- (void) testInitializesWithHTMLData
{
  STAssertTrue([doc isKindOfClass: [TFHpple class]], nil);
}

//  doc.search("//p[@class='posted']")
- (void) testSearchesWithXPath
{
  TFHppleXPathResult * result = [doc searchWithXPathQuery:@"//a[@class='sponsor']"];
  STAssertEquals((int)[result count], 2, nil);

  TFHppleElement * e = [result objectAtIndex:0];
  STAssertTrue([e isKindOfClass: [TFHppleElement class]], nil);
}

- (void) testFindsFirstElementAtXPath
{
  TFHppleElement * e = [doc peekAtSearchWithXPathQuery:@"//a[@class='sponsor']"];

  STAssertEqualObjects([e content], @"RailsMachine", nil);
  STAssertEqualObjects([e tagName], @"a", nil);
}

- (void) testSearchesByNestedXPath
{
  TFHppleXPathResult * result = [doc searchWithXPathQuery:@"//div[@class='column']//strong"];
  STAssertEquals((int)[result count], 5, nil);
  
  TFHppleElement * e = [result objectAtIndex:0];
  STAssertEqualObjects([e content], @"PeepCode", nil);
}

- (void) testPopulatesAttributes
{
  TFHppleElement * e = [doc peekAtSearchWithXPathQuery:@"//a[@class='sponsor']"];
  
  STAssertTrue([[e attributes] isKindOfClass: [NSDictionary class]], nil);
  STAssertEqualObjects([[e attributes] objectForKey:@"href"], @"http://railsmachine.com/", nil);
}

- (void) testProvidesEasyAccessToAttributes
{
  TFHppleElement * e = [doc peekAtSearchWithXPathQuery:@"//a[@class='sponsor']"];
  
  STAssertEqualObjects([e objectForKey:@"href"], @"http://railsmachine.com/", nil);
}

- (void) testSearchesXPathFromSubNode
{
  TFHppleElement * e = [doc peekAtSearchWithXPathQuery:@"//div[@id='footer']"];
  STAssertEquals([[e searchWithXPathQuery:@"div[@class='column']"] count], (NSUInteger) 0, nil);
  STAssertEquals([[e searchWithXPathQuery:@"div[@class='container']"] count], (NSUInteger) 1, nil);
}

//  doc.at("body")['onload']


//  (doc/"#elementID").inner_html


//  (doc/"#elementID").to_html

//  doc.at("div > div:nth(1)").css_path

//  doc.at("div > div:nth(1)").xpath



@end
