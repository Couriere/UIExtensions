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
/// Visual effect view with custom visual effect and its intensity.
public final class CustomIntensityVisualEffectUIView: UIVisualEffectView {

	private var animator: UIViewPropertyAnimator!

	/// Create visual effect view with given effect and its intensity.
	///
	/// - Parameters:
	///   - effect: Visual effect, eg UIBlurEffect(style: .dark)
	///   - intensity: Custom intensity from 0.0 (no effect) to 1.0 (full effect) using linear scale
	public init( effect: UIVisualEffect, intensity: Double ) {
		super.init( effect: nil )
		animator = UIViewPropertyAnimator( duration: 1, curve: .linear ) { [unowned self] in self.effect = effect }

		DispatchQueue.main.async {
			self.animator.fractionComplete = intensity
		}
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError()
	}
}


/// Visual effect view with custom visual effect and its intensity.
@available(iOS 13, tvOS 13, *)
public struct CustomIntensityVisualEffectView: UIViewRepresentable {

	public let effect: UIVisualEffect
	public let intensity: Double

	/// Create visual effect view with given effect and its intensity.
	///
	/// - Parameters:
	///   - effect: Visual effect, eg UIBlurEffect(style: .dark)
	///   - intensity: Custom intensity from 0.0 (no effect) to 1.0 (full effect) using linear scale
	public init( effect: UIVisualEffect, intensity: Double ) {
		self.effect = effect
		self.intensity = intensity
	}

	/// Create blur visual effect view with specified style and intensity.
	///
	/// - Parameters:
	///   - blur: Blur effect style
	///   - intensity: Custom intensity from 0.0 (no effect) to 1.0 (full effect) using linear scale
	public init( blur: UIBlurEffect.Style = .regular, intensity: Double = 0.3 ) {
		self.init( effect: UIBlurEffect( style: blur ), intensity: intensity )
	}

	public func makeUIView( context: Context ) -> some UIView {
		CustomIntensityVisualEffectUIView( effect: effect, intensity: intensity )
	}

	public func updateUIView( _ uiView: UIViewType, context: Context ) {}
}


@available(iOS 13, tvOS 13, *)
public extension View {
	func blurredBackground(
		style: UIBlurEffect.Style = .regular,
		intensity: Double = 0.3,
		safeAreaEdges: Edge.Set = .vertical
	) -> some View {
		ZStack {
			CustomIntensityVisualEffectView( blur: style, intensity: intensity )
				.edgesIgnoringSafeArea( .vertical )
			self
		}
	}
}


@available(iOS 13, tvOS 13, *)
struct CustomIntensityVisualEffectView_Previews: PreviewProvider {
    static var previews: some View {
		ZStack {

			Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam fringilla turpis id nulla rutrum porta vitae id lectus. Mauris fringilla sem non lectus aliquam tincidunt. Praesent malesuada lectus vel nulla ultrices, non euismod ex cursus. Praesent aliquam at tortor non rhoncus. Ut iaculis tortor ut ex interdum, eu interdum justo mattis. Proin sed quam placerat, tristique dui at, euismod erat. Vestibulum placerat enim nulla, nec fermentum felis condimentum sed. Quisque sed fermentum urna. Nam massa nulla, consequat vitae ipsum eget, iaculis sagittis tellus. Morbi elementum, risus non tristique efficitur, nunc neque sodales metus, in maximus tellus sapien porta quam. Praesent finibus nibh mi, id cursus metus luctus a. Maecenas lobortis, ipsum eget eleifend luctus, nibh urna sollicitudin nibh, a egestas felis nulla sit amet nibh. Fusce accumsan nisl nisl, eget fringilla erat ultricies et. Duis eget justo rutrum, volutpat odio sit amet, bibendum diam. Etiam malesuada sapien at lorem consequat malesuada et quis augue. Sed quis mauris ut tortor posuere scelerisque ac iaculis lorem.")

			Rectangle()
				.fill( Color.green )
				.frame( width: 100, height: 100 )
				.blurredBackground()
		}
    }
}
#endif
