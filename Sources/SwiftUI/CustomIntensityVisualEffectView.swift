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

/// A View that encapsulates the effect, intensity,
/// and duration of the visual effect.
@MainActor
public struct CustomIntensityVisualEffectView {
	
	/// The visual effect to apply.
	public let effect: UIVisualEffect
	/// The intensity of the visual effect.
	public let intensity: Double
	/// The duration of the animation.
	public let duration: TimeInterval
	
	/// Initializes a `CustomIntensityVisualEffectView` with default parameters.
	///
	/// - Parameters:
	///   - effect: The visual effect to apply (default is dark blur).
	///   - intensity: The effect intensity value
	///  ranging from 0.0 (no effect) to 1.0 (full effect intensity).
	///   - duration: The duration of the animation (default is 0, no animation).
	public init(
		effect: UIVisualEffect = UIBlurEffect( style: .dark ),
		intensity: Double,
		duration: TimeInterval = 0
	) {
		self.effect = effect
		self.intensity = intensity
		self.duration = duration
	}
}

extension CustomIntensityVisualEffectView: UIViewRepresentable {
	
	public func makeCoordinator() -> Coordinator {
		return Coordinator( effect: effect )
	}
	
	public func makeUIView( context: Context ) -> UIView {
		return context.coordinator.visualEffectsView
	}
	
	public func updateUIView( _ uiView: UIView, context: Context ) {
		context.coordinator.visualEffectsView.setIntensity(intensity, duration: duration)
	}
}

public extension CustomIntensityVisualEffectView {

	@MainActor
	final class Coordinator {

		/// The visual effects view to present.
		let visualEffectsView: CustomIntensityVisualEffectUIView

		init( effect: UIVisualEffect ) {

			/// The visual effects view to present.
			visualEffectsView = CustomIntensityVisualEffectUIView(
				effect: effect
			)
		}
	}
}

public extension View {
	
	/// Layers the blurred background behind this view.
	///
	/// - Parameters:
	///   - style: The style of the blur effect (default is `.dark`).
	///   - intensity: The initial intensity of the blur effect,
	///   ranging from 0.0 (no effect) to 1.0 (full effect intensity)
	///   Default is 0.3.
	///   - duration: The duration of the animation for changing
	///  intensity (default is 0, indicating no animation).
	///   - safeAreaEdges: The edges of the safe area to be ignored
	///  by the blur effect (default is `.all`).
	///
	/// - Returns: A view with a blurred background.
	func blurredBackground(
		style: UIBlurEffect.Style = .dark,
		intensity: Double = 0.3,
		duration: TimeInterval = 0,
		safeAreaEdges: Edge.Set = .all
	) -> some View {
		
		self
			.background(
				CustomIntensityVisualEffectView(
					effect: UIBlurEffect( style: style ),
					intensity: intensity,
					duration: duration
				)
				.edgesIgnoringSafeArea( safeAreaEdges )
			)
	}
	
	/// Applies the blurred background to the whole screen behind this view.
	///
	/// - Parameters:
	///   - style: The style of the blur effect (default is `.dark`).
	///   - intensity: The initial intensity of the blur effect,
	///   ranging from 0.0 (no effect) to 1.0 (full effect intensity)
	///   Default is 0.3.
	///   - duration: The duration of the animation for changing
	///  intensity (default is 0, indicating no animation).
	///   - safeAreaEdges: The edges of the safe area to be ignored
	///  by the blur effect (default is `.all`).
	///
	/// - Returns: A view with a blurred background.
	func wholeViewBlurredBackground(
		style: UIBlurEffect.Style = .dark,
		intensity: Double = 0.3,
		duration: TimeInterval = 0,
		safeAreaEdges: Edge.Set = .all
	) -> some View {
		
		ZStack {
		
			CustomIntensityVisualEffectView(
				effect: UIBlurEffect( style: style ),
				intensity: intensity,
				duration: duration
			)
			.edgesIgnoringSafeArea( safeAreaEdges )
			
			self
		}
	}
}


@available(iOS 15, tvOS 15, *)
struct CustomIntensityVisualEffectView_Previews: PreviewProvider {
	
	struct PreviewContainer: View {
		
		@State private var blurred: Bool = true
		
		var body: some View {
			ZStack {
				
				Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam fringilla turpis id nulla rutrum porta vitae id lectus. Mauris fringilla sem non lectus aliquam tincidunt. Praesent malesuada lectus vel nulla ultrices, non euismod ex cursus. Praesent aliquam at tortor non rhoncus. Ut iaculis tortor ut ex interdum, eu interdum justo mattis. Proin sed quam placerat, tristique dui at, euismod erat. Vestibulum placerat enim nulla, nec fermentum felis condimentum sed. Quisque sed fermentum urna. Nam massa nulla, consequat vitae ipsum eget, iaculis sagittis tellus. Morbi elementum, risus non tristique efficitur, nunc neque sodales metus, in maximus tellus sapien porta quam. Praesent finibus nibh mi, id cursus metus luctus a. Maecenas lobortis, ipsum eget eleifend luctus, nibh urna sollicitudin nibh, a egestas felis nulla sit amet nibh. Fusce accumsan nisl nisl, eget fringilla erat ultricies et. Duis eget justo rutrum, volutpat odio sit amet, bibendum diam. Etiam malesuada sapien at lorem consequat malesuada et quis augue. Sed quis mauris ut tortor posuere scelerisque ac iaculis lorem.")
				
				Button( "Toggle blur" ) {
					blurred.toggle()
				}
				.buttonStyle( .borderedProminent )
				.padding( 100 )
				.blurredBackground(
					intensity: blurred ? 0.2 : 0,
					duration: blurred ? 1 : 0
				)
			}
		}
	}
	
	static var previews: some View {
		PreviewContainer()
	}
}

#endif
