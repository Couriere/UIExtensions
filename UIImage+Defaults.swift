//
//  UIImage+Defaults.swift
//
//  Created by Vladimir Kazantsev on 11.12.14.
//  Copyright (c) 2014. All rights reserved.
//

import UIKit

extension UIImage {

	convenience init( color: UIColor ) {
		self.init( size: CGSize( width: 1, height: 1 ), color: color )
	}
	
	convenience init( size: CGSize, color: UIColor ) {
		let rect = CGRect( x: 0, y: 0, width: size.width, height: size.height )
		UIGraphicsBeginImageContextWithOptions( rect.size, false, 0 );
		color.setFill()
		UIRectFill( rect )
		self.init( cgImage: UIGraphicsGetImageFromCurrentImageContext()!.cgImage!, scale: UIScreen.main.scale, orientation: .up )
		UIGraphicsEndImageContext()
	}
}
