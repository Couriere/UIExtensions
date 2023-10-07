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

import SwiftUI

#if canImport(UIKit)
/// A custom subclass of `UIVisualEffectView` that provides the ability
/// to control the intensity of the visual effect and animate its
/// intensity changes.
public final class CustomIntensityVisualEffectUIView: UIVisualEffectView {
	
	private var animator: UIViewPropertyAnimator!
	private var displayLink: CADisplayLink?
	
	/// The current intensity of the visual effect.
	private var intensityTarget: Double = 0
	/// The value to change `fractionComplete` value
	/// in each animation tick.
	private var tickDelta: Double = 0
	
	/// Initializes a `CustomIntensityVisualEffectUIView` with
	/// a specified effect.
	///
	/// - Parameters:
	///   - effect: The visual effect to apply.
	///
	/// The view is initialized with zero intensity.
	/// Application needs to call ``setIntensity(_:duration:)`` to see changes.
	public override init(
		effect: UIVisualEffect? = UIBlurEffect( style: .dark )
	) {
		super.init( effect: effect )
		setup()
	}
	
	/// Initializes a `CustomIntensityVisualEffectUIView` with
	/// a specified effect and intensity.
	///
	/// - Parameters:
	///   - effect: The visual effect to apply.
	///   - intensity: The initial effect intensity value
	///  ranging from 0.0 (no effect) to 1.0 (full effect intensity).
	///
	/// The specified intensity is set immediately without animation.
	public convenience init(
		effect: UIVisualEffect? = UIBlurEffect( style: .dark ),
		intensity: Double
	) {
		self.init( effect: effect )
		setIntensity( intensity, duration: 0 )
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	/// Stops the animation when the view removed from its superview.
	public override func didMoveToSuperview() {
		if superview == nil {
			displayLink?.invalidate()
			animator.stopAnimation( true )
		}
	}
}

public extension CustomIntensityVisualEffectUIView {
	
	/// Sets the intensity of the visual effect with an optional duration.
	///
	/// - Parameters:
	///   - intensity: The target effect intensity value
	///  ranging from 0.0 (no effect) to 1.0 (full effect intensity).
	///   - duration: The duration of the animation (default is 0, no animation).
	///
	/// A duration value of 0 means the change will occur
	/// instantaneously without animation.
	func setIntensity(
		_ intensity: Double,
		duration: TimeInterval = 0
	) {
		guard intensity != intensityTarget else { return }
		
		displayLink?.invalidate()
		
		intensityTarget = intensity
		
		guard duration != 0 else {
			animator.fractionComplete = intensity
			return
		}
		
		tickDelta = ( intensity - animator.fractionComplete ) /
		( Double( UIScreen.main.maximumFramesPerSecond ) * duration )
		
		// Using a display link to animate `animator.fractionComplete`
		displayLink = CADisplayLink(
			target: self,
			selector: #selector( displayLinkTick )
		)
		displayLink?.add( to: .main, forMode: .common )
	}
}

private extension CustomIntensityVisualEffectUIView {
	
	/// Sets up the view's initial properties.
	func setup() {
		translatesAutoresizingMaskIntoConstraints = false
		
		animator = UIViewPropertyAnimator(
			duration: 1,
			curve: .linear
		) { [unowned self, effect] in
			self.effect = effect
		}
		self.effect = nil
		// Fixes background bug
		animator.pausesOnCompletion = true
	}
	
	/// The selector method called by the display link to update the animation progress.
	@objc func displayLinkTick() {
		animator.fractionComplete += tickDelta
		guard abs(animator.fractionComplete - intensityTarget) < tickDelta else {
			return
		}
		
		displayLink?.invalidate()
		animator.fractionComplete = intensityTarget
	}
}

#endif
