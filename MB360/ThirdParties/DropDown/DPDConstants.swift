//
//  Constants.swift
//  DropDown
//
//  Created by Kevin Hirsch on 28/07/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit

internal struct DPDConstant {

	internal struct KeyPath {

		static let Frame = "frame"

	}

	internal struct ReusableIdentifier {

		static let DropDownCell = "DropDownCell"

	}

	internal struct UI {

		static let TextColor = UIColor.lightGray
		static let TextFont = UIFont.systemFont(ofSize: 17)
		static let BackgroundColor = UIColor(white: 0.94, alpha: 1)
		static let SelectionBackgroundColor = UIColor(white: 0.89, alpha: 1)
		static let SeparatorColor = UIColor.lightGray
		static let CornerRadius: CGFloat = 12
		static let RowHeight: CGFloat = 45
		static let HeightPadding: CGFloat = 20

		struct Shadow {

			static let Color = UIColor.lightGray
			static let Offset = CGSize.zero
			static let Opacity: Float = 0.4
			static let Radius: CGFloat = 5

		}

	}

	internal struct Animation {

		static let Duration = 0.15
		static let EntranceOptions: UIViewAnimationOptions = [.allowUserInteraction, .curveEaseOut]
		static let ExitOptions: UIViewAnimationOptions = [.allowUserInteraction, .curveEaseIn]
		static let DownScaleTransform = CGAffineTransform(scaleX: 0.9, y: 0.9)

	}

}
