//
//  ScrollView.swift
//  SpaceX
//
//  Created by ESSIP on 19.12.2024.
//

import Foundation
import UIKit
import SnapKit

public class ScrollView: UIScrollView {

        public var additionalTopViews: [UIView] = []

        public let topView = UIView()
        public let bottomView = UIView()

        public let contentView = UIView()

        public var bottomViewTopConstraint: Constraint?
        public var bottomViewBottomConstraint: Constraint?

        public init() {
            super.init(frame: .zero)

            alwaysBounceVertical = true
            keyboardDismissMode = .onDrag

            addSubview(contentView)
            contentView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                make.width.equalToSuperview()
                make.height.equalToSuperview().priority(.low)
            }

            contentView.addSubview(topView)
            contentView.addSubview(bottomView)

            updateContentLayout()
        }

        @available(*, unavailable)
        public required init(coder: NSCoder) { fatalError() }


        public func addAdditionalTopView(_ additionalTopView: UIView) {
            contentView.addSubview(additionalTopView)
            additionalTopViews += [additionalTopView]
            updateContentLayout()
        }

        public func removeAdditionalTopView(_ additionalTopView: UIView) {
            if additionalTopViews.contains(additionalTopView) {
                if additionalTopView.superview != nil {
                    additionalTopView.removeFromSuperview()
                }
                additionalTopViews = additionalTopViews.filter { $0 !== additionalTopView }
            }
            updateContentLayout()
        }

        private func updateContentLayout() {
            var previousTopView: UIView?
            additionalTopViews.forEach { (additionalTopView) in
                additionalTopView.snp.remakeConstraints { make in
                    make.top.equalTo(previousTopView?.snp.bottom ?? contentView.snp.top)
                    make.leading.trailing.equalTo(contentView)
                }
                previousTopView = additionalTopView
            }

            topView.snp.remakeConstraints { make in
                make.top.equalTo(previousTopView?.snp.bottom ?? contentView.snp.top)
                make.leading.trailing.equalTo(contentView)
            }

            bottomView.snp.remakeConstraints { make in
                bottomViewTopConstraint = make.top.greaterThanOrEqualTo(topView.snp.bottom).offset(24 + 2 * 12 + 48).constraint
                bottomViewBottomConstraint = make.bottom.equalToSuperview().constraint
                make.leading.trailing.equalToSuperview()
            }
        }
    }
