//
//  ProgressViewSection.swift
//  MultiProgressView
//
//  Created by Mac Gallagher on 6/15/18.
//  Copyright © 2018 Mac Gallagher. All rights reserved.
//

import UIKit

open class ProgressViewSection: UIView {
    
    public var titleLabel: UILabel {
        return sectionTitleLabel
    }
    
    private var sectionTitleLabel: UILabel = UILabel()
    
    public var titleEdgeInsets: UIEdgeInsets = .zero {
        didSet {
            setNeedsLayout()
        }
    }
    
    public var titleAlignment: AlignmentType = .center {
        didSet {
            setNeedsLayout()
        }
    }
    
    public var imageView: UIImageView {
        return sectionImageView
    }
    
    public var colorView: UIColor {
        return sectionColor
    }
    
    private var sectionImageView: UIImageView = UIImageView()
    
    var sectionGradientView = GradientView()
    
    private var sectionColor: UIColor = .black {
           didSet {
               backgroundColor = sectionColor
           }
       }

    
    private var layoutProvider: LayoutProvidable.Type = LayoutProvider.self
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    convenience init(layoutProvider: LayoutProvidable.Type) {
        self.init(frame: .zero)
        self.layoutProvider = layoutProvider
    }
    
    private func initialize() {
        backgroundColor = sectionColor
        layer.masksToBounds = true
        addSubview(sectionImageView)
        addSubview(sectionGradientView)
//        addSubview(sectionTitleLabel)
    }
    
    // MARK: - Layout
    
    var labelConstraints = [NSLayoutConstraint]() {
        didSet {
            NSLayoutConstraint.deactivate(oldValue)
            NSLayoutConstraint.activate(labelConstraints)
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        labelConstraints = layoutProvider.anchorToSuperview(sectionTitleLabel,
                                                            withAlignment: titleAlignment,
                                                            insets: titleEdgeInsets)
        sectionImageView.frame = layoutProvider.sectionImageViewFrame(self)
        sectionGradientView.frame = layoutProvider.sectionImageViewFrame(self)
        
        sendSubviewToBack(sectionImageView)
        sendSubviewToBack(sectionGradientView)
    }
    
    // MARK: - Main Methods
    
    public func setTitle(_ title: String?) {
        sectionTitleLabel.text = title
    }
    
    public func setAttributedTitle(_ title: NSAttributedString?) {
        sectionTitleLabel.attributedText = title
    }
    
    public func setImage(_ image: UIImage?) {
        sectionImageView.image = image
    }
    
    public func setColor(_ colorId: String?) {
        var (top, down) = (#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))

        if let color = colorId {
            (top, down) = WaterColor.getById(color).getColor()
        }
        
        sectionGradientView.topColor = top
        sectionGradientView.bottomColor = down
    }
}
