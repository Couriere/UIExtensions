//
//  OnRailProgressChange.swift
//  UIExtensions
//
//  Copyright © 2026 mc2 software. All rights reserved
//

import SwiftUI

public extension View {

	/// Adds an action to perform when the scroll progress of a descendant rail changes.
	///
	/// Progress is a zero-based fractional item position, rather than a value normalized to `0...1`.
	/// A value of 0 represents the first item; 1.5 represents a position halfway between
	/// the second and third items. Empty rails and rows that fit without scrolling report 0.
	/// Values are clamped to `0...max(0, itemCount - 1)`, including during scroll bounce.
	///
	/// - Warning: Progress may be inaccurate when the `intrinsicSizeItemIDs` parameter of ``HorizontalRail`` is used.
	///
	/// The modifier applies to descendant rails;
	/// placing it directly on one rail limits observation to that rail.
	///
	/// - Parameter action: The action to perform on the main actor. The action receives
	///   the updated fractional item position.
	@MainActor
	func onRailProgressChange(
		_ action: @escaping @MainActor (Double) -> Void,
	) -> some View {
		environment( \.railProgressChanged, action )
	}

	/// Updates a binding when the scroll progress of a descendant rail changes.
	///
	/// Progress is a zero-based fractional item position, rather than a value normalized to `0...1`.
	/// A value of 0 represents the first item; 1.5 represents a position halfway between
	/// the second and third items. Empty rails and rows that fit without scrolling report 0.
	/// Values are clamped to `0...max(0, itemCount - 1)`, including during scroll bounce.
	///
	/// - Warning: Progress may be inaccurate when the `intrinsicSizeItemIDs` parameter of ``HorizontalRail`` is used.
	///
	/// The modifier applies to descendant rails;
	/// placing it directly on one rail limits observation to that rail.
	/// Updating the binding does not scroll the rail.
	///
	/// - Parameter progress: The binding that receives progress updates on the main actor.
	@MainActor
	func onRailProgressChange( update progress: Binding<Double> ) -> some View {
		onRailProgressChange { progress.wrappedValue = $0 }
	}
}

extension EnvironmentValues {

	@Entry
	var railProgressChanged: (@MainActor (Double) -> Void)? = nil
}
