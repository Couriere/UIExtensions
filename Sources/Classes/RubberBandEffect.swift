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

import Foundation

/// Computes the rubber band effect for animating a value towards a
/// minimum value with a bounce effect.
///
/// - Parameters:
///    - value: The current value to be animated.
///    - minValue: The minimum value that the `value` should reach.
///    - bounce: The coefficient of bounce after reaching the boundary.
///
/// - Returns: The updated value considering the rubber band effect.
///
/// The `rubberBandEffect` function calculates the effect resembling a
/// rubber band's behavior, commonly used in UI animations to simulate
/// the bounce-back of an element when it reaches its boundary or edge.
///
/// To utilize this function, provide the following parameters:
/// - `value`: The current value that needs to be animated.
/// - `minValue`: The minimum value towards which `value` should animate.
/// - `bounce`: The coefficient determining the intensity of the bounce
///   effect upon reaching the boundary.
///
/// The function operates as follows:
/// 1. It checks if the current `value` exceeds or equals `minValue`.
///    If so, it returns the original `value` without applying the
///    rubber band effect, as it has not reached the boundary yet.
/// 2. If `value` is less than `minValue`, it calculates the overscroll,
///    which is the difference between `minValue` and `value`,
///    indicating how much `value` has exceeded `minValue`.
/// 3. Using the overscroll, it computes the `rubberBandedValue`,
///    which simulates the new value considering the bounce effect.
///    The calculation incorporates a formula commonly used for
///    creating the bounce effect.
/// 4. Finally, the function returns the adjusted `value` considering
///    the rubber band effect, achieved by subtracting `rubberBandedValue`
///    from `minValue`.
///
/// Example Usage:
/// ```swift
/// let animatedValue = rubberBandEffect(value: currentValue, minValue: 1.0, bounce: 0.5)
/// ```
///
/// This would return the updated `animatedValue` considering the rubber
/// band effect based on the given parameters.
///
public func rubberBandEffect(
	value: Double,
	minValue: Double,
	bounce: Double
) -> Double {

	guard value < minValue else { return value }

	let overscroll = minValue - value
	let rubberBandedValue = (
		1.0 - ( 1.0 / (( overscroll * 0.55 / bounce ) + 1.0 ))
	) * bounce

	return minValue - rubberBandedValue
}


/// Computes the rubber band effect for animating a value towards a
/// maximum value with a bounce effect.
///
/// - Parameters:
///    - value: The current value to be animated.
///    - maxValue: The maximum value that the `value` should reach.
///    - bounce: The coefficient of bounce after reaching the boundary.
///
/// - Returns: The updated value considering the rubber band effect.
///
/// The `rubberBandEffect` function calculates the effect resembling a
/// rubber band's behavior, commonly used in UI animations to simulate
/// the bounce-back of an element when it reaches its boundary or edge.
///
/// To utilize this function, provide the following parameters:
/// - `value`: The current value that needs to be animated.
/// - `maxValue`: The maximum value towards which `value` should animate.
/// - `bounce`: The coefficient determining the intensity of the bounce
///   effect upon reaching the boundary.
///
/// The function operates as follows:
/// 1. It checks if the current `value` not exceeds `maxValue`.
///    If so, it returns the original `value` without applying the
///    rubber band effect, as it has not reached the boundary yet.
/// 2. If `value` is greater than `maxValue`, it calculates the overscroll,
///    which is the difference between `value` and `maxValue`,
///    indicating how much `value` has exceeded `maxValue`.
/// 3. Using the overscroll, it computes the `rubberBandedValue`,
///    which simulates the new value considering the bounce effect.
///    The calculation incorporates a formula commonly used for
///    creating the bounce effect.
/// 4. Finally, the function returns the adjusted `value` considering
///    the rubber band effect, achieved by adding `rubberBandedValue`
///    to `maxValue`.
///
/// Example Usage:
/// ```swift
/// let animatedValue = rubberBandEffect(value: currentValue, maxValue: 20.0, bounce: 0.5)
/// ```
///
/// This would return the updated `animatedValue` considering the rubber
/// band effect based on the given parameters.
///
public func rubberBandEffect(
	value: Double,
	maxValue: Double,
	bounce: Double
) -> Double {

	guard value > maxValue else { return value }

	let overscroll = value - maxValue
	let rubberBandedValue = (
		1.0 - ( 1.0 / (( overscroll * 0.55 / bounce ) + 1.0 ))
	) * bounce

	return maxValue + rubberBandedValue
}

