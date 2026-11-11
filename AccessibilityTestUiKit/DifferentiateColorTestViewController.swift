//
//  DifferentiateColorTestViewController.swift
//  AccessibilityTestUiKit
//
//  Migrated from SwiftUI Nutrition Label app
//

import UIKit
import SwiftUI

class DifferentiateColorTestViewController: UIViewController {

    // MARK: - EXERCISE TODO #4: Differentiate Without Colour (UIKit)
    // TODO #4: Detect the user's preference and provide icons/text in addition to colour so information is never colour-only.
    // LEARNING GOAL: Respect `UIAccessibility.shouldDifferentiateWithoutColor` and adapt UI affordances accordingly.

    private var scrollView: UIScrollView!
    private var contentStackView: UIStackView!

    // TODO #4: Replace this placeholder return with `UIAccessibility.shouldDifferentiateWithoutColor`.
    private var isDifferentiateEnabled: Bool {
        //return false
        return UIAccessibility.shouldDifferentiateWithoutColor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupScrollView()
        setupContentStackView()
        setupContent()

        // Listen for accessibility changes
        NotificationCenter.default.addObserver(self, selector: #selector(accessibilityChanged), name: UIAccessibility.differentiateWithoutColorDidChangeNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func accessibilityChanged() {
        contentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        setupContent()
    }

    private func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupContentStackView() {
        contentStackView = UIStackView()
        contentStackView.axis = .vertical
        contentStackView.spacing = 24
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStackView)

        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
    }

    private func setupContent() {
        // Status indicator
        let statusSection = createStatusIndicator()
        contentStackView.addArrangedSubview(statusSection)

        // Status indicators (success/warning/error)
        let statusIndicatorsSection = createStatusIndicatorsSection()
        contentStackView.addArrangedSubview(statusIndicatorsSection)

        // Form validation
        let formSection = createFormValidationSection()
        contentStackView.addArrangedSubview(formSection)

        // Selection states
        let selectionSection = createSelectionSection()
        contentStackView.addArrangedSubview(selectionSection)

        // Info section
        let infoSection = createInfoSection()
        contentStackView.addArrangedSubview(infoSection)
    }

    private func createStatusIndicator() -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 12
        container.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        container.isLayoutMarginsRelativeArrangement = true
        container.backgroundColor = .secondarySystemGroupedBackground
        container.layer.cornerRadius = 12

        let titleLabel = UILabel()
        titleLabel.text = "Feature Status"
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true
        container.addArrangedSubview(titleLabel)

        let statusLabel = UILabel()
        // TODO #4: Update this text to reflect the real setting once you replace the placeholder property.
        statusLabel.text = isDifferentiateEnabled ?  "Differentiate Without Colour: ON" : "Differentiate Without Colour: OFF"
        statusLabel.font = .preferredFont(forTextStyle: .title3)
        statusLabel.adjustsFontForContentSizeCategory = true
        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 0
        container.addArrangedSubview(statusLabel)

        let infoLabel = UILabel()
        infoLabel.text = "Toggle in Settings > Accessibility > Display & Text Size"
        infoLabel.font = .preferredFont(forTextStyle: .caption1)
        infoLabel.adjustsFontForContentSizeCategory = true
        infoLabel.textColor = .secondaryLabel
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 0
        container.addArrangedSubview(infoLabel)

        return container
    }

    private func createStatusIndicatorsSection() -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 16
        container.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        container.isLayoutMarginsRelativeArrangement = true
        container.backgroundColor = .secondarySystemGroupedBackground
        container.layer.cornerRadius = 12

        let titleLabel = UILabel()
        titleLabel.text = "Status Indicators"
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true
        container.addArrangedSubview(titleLabel)

        let successIndicator = createStatusBadge(text: "Success", color: .systemGreen, icon: "checkmark.circle.fill")
        container.addArrangedSubview(successIndicator)

        let warningIndicator = createStatusBadge(text: "Warning", color: .systemYellow, icon: "exclamationmark.triangle.fill")
        container.addArrangedSubview(warningIndicator)

        let errorIndicator = createStatusBadge(text: "Error", color: .systemRed, icon: "xmark.circle.fill")
        container.addArrangedSubview(errorIndicator)

        return container
    }

    private func createStatusBadge(text: String, color: UIColor, icon: String) -> UIView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.layoutMargins = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.backgroundColor = color.withAlphaComponent(0.15)
        stackView.layer.cornerRadius = 8

        // Circle or icon based on setting
        let indicatorView: UIView
        // TODO #4: Once you enable `isDifferentiateEnabled`, this block should provide an icon instead of a plain colour swatch.
        // TODO #4: When differentiation is enabled, add an icon so colour-blind users get extra confirmation.
        if isDifferentiateEnabled {
            // Show icon
            let imageView = UIImageView()
            let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
            imageView.image = UIImage(systemName: icon, withConfiguration: config)
            imageView.tintColor = color
            imageView.translatesAutoresizingMaskIntoConstraints = false
            indicatorView = imageView
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: 20),
                imageView.heightAnchor.constraint(equalToConstant: 20)
            ])
        } else {
            // Show colored circle
            let circle = UIView()
            circle.backgroundColor = color
            circle.layer.cornerRadius = 10
            circle.translatesAutoresizingMaskIntoConstraints = false
            indicatorView = circle
            NSLayoutConstraint.activate([
                circle.widthAnchor.constraint(equalToConstant: 20),
                circle.heightAnchor.constraint(equalToConstant: 20)
            ])
        }

        stackView.addArrangedSubview(indicatorView)

        let label = UILabel()
        label.text = text
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = color
        stackView.addArrangedSubview(label)

        return stackView
    }

    private func createFormValidationSection() -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 16
        container.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        container.isLayoutMarginsRelativeArrangement = true
        container.backgroundColor = .secondarySystemGroupedBackground
        container.layer.cornerRadius = 12

        let titleLabel = UILabel()
        titleLabel.text = "Form Validation"
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true
        container.addArrangedSubview(titleLabel)

        let validField = createFormField(label: "Valid Email", isValid: true)
        container.addArrangedSubview(validField)

        let invalidField = createFormField(label: "Invalid Email", isValid: false)
        container.addArrangedSubview(invalidField)

        return container
    }

    private func createFormField(label: String, isValid: Bool) -> UIView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.layoutMargins = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.backgroundColor = .tertiarySystemBackground
        stackView.layer.cornerRadius = 8
        stackView.layer.borderWidth = 2
        stackView.layer.borderColor = (isValid ? UIColor.systemGreen : UIColor.systemRed).cgColor

        // Show icon when differentiate is enabled
        // TODO #4: Provide a clear icon plus top-left checkmark when colour alone isn't enough.
        if isDifferentiateEnabled {
            let imageView = UIImageView()
            let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
            let iconName = isValid ? "checkmark" : "xmark"
            imageView.image = UIImage(systemName: iconName, withConfiguration: config)
            imageView.tintColor = isValid ? .systemGreen : .systemRed
            imageView.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(imageView)
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: 16),
                imageView.heightAnchor.constraint(equalToConstant: 16)
            ])
        }

        let labelView = UILabel()
        labelView.text = label
        labelView.font = .preferredFont(forTextStyle: .body)
        labelView.adjustsFontForContentSizeCategory = true
        stackView.addArrangedSubview(labelView)

        return stackView
    }

    private func createSelectionSection() -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 12
        container.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        container.isLayoutMarginsRelativeArrangement = true
        container.backgroundColor = .secondarySystemGroupedBackground
        container.layer.cornerRadius = 12

        let titleLabel = UILabel()
        titleLabel.text = "Selection States"
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true
        container.addArrangedSubview(titleLabel)

        let option1 = createSelectionOption(text: "Option 1", isSelected: true)
        container.addArrangedSubview(option1)

        let option2 = createSelectionOption(text: "Option 2", isSelected: false)
        container.addArrangedSubview(option2)

        return container
    }

    private func createSelectionOption(text: String, isSelected: Bool) -> UIView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.layoutMargins = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.backgroundColor = isSelected ? UIColor.systemBlue.withAlphaComponent(0.15) : .tertiarySystemBackground
        stackView.layer.cornerRadius = 8

        // Show checkmark when selected and differentiate is enabled
        if isSelected && isDifferentiateEnabled {
            let imageView = UIImageView()
            let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)
            imageView.image = UIImage(systemName: "checkmark", withConfiguration: config)
            imageView.tintColor = .systemBlue
            imageView.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(imageView)
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: 16),
                imageView.heightAnchor.constraint(equalToConstant: 16)
            ])
        }

        let label = UILabel()
        label.text = text
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        stackView.addArrangedSubview(label)

        return stackView
    }

    private func createInfoSection() -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 12
        container.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        container.isLayoutMarginsRelativeArrangement = true
        container.backgroundColor = .systemBlue.withAlphaComponent(0.1)
        container.layer.cornerRadius = 12

        let titleLabel = UILabel()
        titleLabel.text = "About This Feature"
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true
        container.addArrangedSubview(titleLabel)

        let infoLabel = UILabel()
        infoLabel.text = "When enabled, UI elements use shapes, icons, or text in addition to color to convey information. This helps users with color vision deficiency (color blindness)."
        infoLabel.font = .preferredFont(forTextStyle: .body)
        infoLabel.adjustsFontForContentSizeCategory = true
        infoLabel.textColor = .secondaryLabel
        infoLabel.numberOfLines = 0
        container.addArrangedSubview(infoLabel)

        return container
    }
}

#Preview("Differentiate Without Colour") {
    let vc = DifferentiateColorTestViewController()
    vc.title = "Differentiate"
    let nav = UINavigationController(rootViewController: vc)
    nav.navigationBar.prefersLargeTitles = true
    return nav
}
