//
//  UILabel+Extensions.swift
//
//  Created by Vladimir Kazantsev on 07.04.2017.
//  Copyright © 2017. All rights reserved.
//

import UIKit

public extension UILabel {

	/// Changes UILabel text with crossfade effect.
	/// Transition is noop if new text is equal to old one.
	/// - parameters text: Text to set on receiver with crossfade effect.
	/// - parameters duration: Duration of crossfade effect.
	func crossfadeTo( text: String?, duration: TimeInterval = 0.2 ) {
		if text != self.text {
			let animation = CATransition().then {
				$0.timingFunction = CAMediaTimingFunction( name: kCAMediaTimingFunctionEaseInEaseOut )
				$0.type = kCATransitionFade
				$0.duration = duration
			}
			layer.add( animation, forKey: kCATransitionFade )
			self.text = text
		}
	}
}
