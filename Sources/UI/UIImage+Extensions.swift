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

#if canImport(UIKit)
import UIKit

public extension UIImage {

	/// Initializes and returns an image object of specified size, filled with specified color.
	convenience init( size: CGSize = CGSize( width: 1, height: 1 ), color: UIColor ) {

		let image = UIGraphicsImageRenderer( size: size, format: .preferred() )
			.image { context in
				color.setFill()
				context.fill( CGRect( size: size ))
			}

		self.init( cgImage: image.cgImage!, scale: UIScreen.main.scale, orientation: .up )
	}
}


public extension UIImage {

	/// Changes length of bigger side of the image to provided value.
	/// Maintains aspect ratio of the image.
	func scaled( toSideLenght side: CGFloat ) -> UIImage {

		let aspectRatio = size.width / size.height
		let scaledSize: CGSize = aspectRatio > 1 ?
			CGSize( width: side, height: side / aspectRatio ) :
			CGSize( width: side * aspectRatio, height: side )

		let format: UIGraphicsImageRendererFormat = .preferred()
		format.scale = self.scale
		return UIGraphicsImageRenderer( size: scaledSize, format: format )
			.image { context in
				draw( in: context.format.bounds )
			}
	}

	//////
	/// Apply `color` to all non-transparent pixels in image.
	//////
	func applyTintColor( _ color: UIColor ) -> UIImage {

		let image = withRenderingMode( .alwaysTemplate )

		return UIGraphicsImageRenderer( size: size, format: .preferred() )
			.image { context in
				color.set()
				image.draw( in: CGRect( origin: .zero, size: size ))
			}
	}
}
#endif
