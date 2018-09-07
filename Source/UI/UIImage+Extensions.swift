//
//  UIImage+Defaults.swift
//
//  Created by Vladimir Kazantsev on 11.12.14.
//  Copyright (c) 2014. All rights reserved.
//

import UIKit

public extension UIImage {

	convenience init( size: CGSize = CGSize( width: 1, height: 1 ), color: UIColor ) {
		let rect = CGRect( x: 0, y: 0, width: size.width, height: size.height )
		UIGraphicsBeginImageContextWithOptions( rect.size, false, 0 );
		color.setFill()
		UIRectFill( rect )
		self.init( cgImage: UIGraphicsGetImageFromCurrentImageContext()!.cgImage!, scale: UIScreen.main.scale, orientation: .up )
		UIGraphicsEndImageContext()
	}
}


public extension UIImage {

	//////
	/// Apply `color` to all non-transparent pixels in image.
	//////
	func applyTintColor( _ color: UIColor ) -> UIImage? {

		let image = withRenderingMode( .alwaysTemplate )

		UIGraphicsBeginImageContextWithOptions( size, false, scale )
		color.set()
		image.draw( in: CGRect( x: 0, y: 0, width: size.width, height: size.height ))
		let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return tintedImage
	}
}
