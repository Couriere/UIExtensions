// MIT License
//
// Copyright (c) 2015-present Vladimir Kazantsev
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#if canImport(AppKit)
import AppKit
public typealias XTView = NSView
public typealias XTLayoutGuide = NSLayoutGuide
public typealias XTLayoutPriority = NSLayoutConstraint.Priority
public typealias XTOrientation = NSUserInterfaceLayoutOrientation
public typealias XTEdgeInsets = NSEdgeInsets
public typealias XTColor = NSColor
public typealias XTFont = NSFont
public typealias XTImage = NSImage
#else
import UIKit
public typealias XTView = UIView
public typealias XTLayoutGuide = UILayoutGuide
public typealias XTLayoutPriority = UILayoutPriority
public typealias XTOrientation = NSLayoutConstraint.Axis
public typealias XTEdgeInsets = UIEdgeInsets
public typealias XTColor = UIColor
public typealias XTFont = UIFont
public typealias XTImage = UIImage
#endif
