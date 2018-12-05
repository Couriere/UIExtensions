//
//  UIImage+Defaults.swift
//
//  Created by Vladimir Kazantsev on 11.12.14.
//  Copyright (c) 2014. All rights reserved.
//

import UIKit

public extension UIImage {

	/// Initializes and returns an image object of specified size, filled with specified color.
	convenience init( size: CGSize = CGSize( width: 1, height: 1 ), color: UIColor ) {

		let rect = CGRect( origin: .zero, size: size )

		UIGraphicsBeginImageContextWithOptions( rect.size, false, 0 )
		defer { UIGraphicsEndImageContext() }
		color.setFill()
		UIRectFill( rect )

		self.init( cgImage: UIGraphicsGetImageFromCurrentImageContext()!.cgImage!,
				   scale: UIScreen.main.scale,
				   orientation: .up )
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

		if #available( iOS 10, * ) {
			let format: UIGraphicsImageRendererFormat = .default()
			format.scale = self.scale
			return UIGraphicsImageRenderer( size: scaledSize, format: format )
				.image { context in
					draw( in: context.format.bounds )
			}
		} else {

			UIGraphicsBeginImageContextWithOptions( scaledSize, false, self.scale )
			defer { UIGraphicsEndImageContext() }
			draw( in: CGRect( origin: .zero, size: scaledSize ))
			return UIGraphicsGetImageFromCurrentImageContext() ?? self
		}
	}

	//////
	/// Apply `color` to all non-transparent pixels in image.
	//////
	func applyTintColor( _ color: UIColor ) -> UIImage? {

		let image = withRenderingMode( .alwaysTemplate )

		UIGraphicsBeginImageContextWithOptions( size, false, 0 )
		defer { UIGraphicsEndImageContext() }
		color.set()
		image.draw( in: CGRect( origin: .zero, size: size ))
		return UIGraphicsGetImageFromCurrentImageContext()
	}
}
