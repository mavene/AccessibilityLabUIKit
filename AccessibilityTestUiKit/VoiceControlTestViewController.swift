//
//  VoiceControlTestViewController.swift
//  AccessibilityTestUiKit
//
//  Migrated from SwiftUI Nutrition Label app
//

import UIKit
import SwiftUI

class VoiceControlTestViewController: UIViewController {

    // MARK: - EXERCISE TODO #6: Voice Control Labels (UIKit)
    // TODO #6: Give every actionable element a unique, descriptive name so Voice Control users can target it with commands.
    // LEARNING GOAL: Understand how Voice Control matches spoken phrases to accessibility labels.

    // MARK: - Properties
    private var feedback: String = "No action yet"
    private var likeCount: Int = 0
    private var isToggled: Bool = false
    private var textInput: String = ""
    private var selectedOption: String = "None"

    private var scrollView: UIScrollView!
    private var contentStackView: UIStackView!
    private var feedbackLabel: UILabel!
    private var likeCountLabel: UILabel!
    private var toggleSwitch: UISwitch!
    private var textField: UITextField!
    private var option1Button: UIButton!
    private var option2Button: UIButton!
    private var option3Button: UIButton!

    private var isAccessibilitySize: Bool {
        return traitCollection.preferredContentSizeCategory.isAccessibilityCategory
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupScrollView()
        setupContentStackView()
        setupContent()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory {
            contentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            setupContent()
        }
    }

    // MARK: - Setup
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
        // Instructions (hidden at accessibility sizes)
        if !isAccessibilitySize {
            let instructions = createInstructions()
            contentStackView.addArrangedSubview(instructions)
        }

        // Feedback display
        let feedbackSection = createFeedbackSection()
        contentStackView.addArrangedSubview(feedbackSection)

        // Action buttons
        let actionsSection = createActionsSection()
        contentStackView.addArrangedSubview(actionsSection)

        // Toggle section
        let toggleSection = createToggleSection()
        contentStackView.addArrangedSubview(toggleSection)

        // Text input
        let textSection = createTextSection()
        contentStackView.addArrangedSubview(textSection)

        // Selection options
        let optionsSection = createOptionsSection()
        contentStackView.addArrangedSubview(optionsSection)

        // Reset/Confirm buttons
        let controlsSection = createControlsSection()
        contentStackView.addArrangedSubview(controlsSection)
    }

    // MARK: - Section Creators
    private func createInstructions() -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 12
        container.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        container.isLayoutMarginsRelativeArrangement = true
        container.backgroundColor = .secondarySystemGroupedBackground
        container.layer.cornerRadius = 12

        let titleLabel = UILabel()
        titleLabel.text = "Try these voice commands:"
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true
        container.addArrangedSubview(titleLabel)

        let commands = [
            "• \"Tap Like\"",
            "• \"Tap Share\"",
            "• \"Tap Notifications\"",
            "• \"Tap Option One\"",
            "• Dictate text into the text field"
        ]

        for command in commands {
            let label = UILabel()
            label.text = command
            label.font = .preferredFont(forTextStyle: .caption1)
            label.adjustsFontForContentSizeCategory = true
            label.textColor = .secondaryLabel
            label.numberOfLines = 0
            container.addArrangedSubview(label)
        }

        return container
    }

    private func createFeedbackSection() -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 12
        container.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        container.isLayoutMarginsRelativeArrangement = true
        container.backgroundColor = .systemBlue.withAlphaComponent(0.1)
        container.layer.cornerRadius = 12

        let titleLabel = UILabel()
        titleLabel.text = "Last Action"
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true
        container.addArrangedSubview(titleLabel)

        feedbackLabel = UILabel()
        feedbackLabel.text = feedback
        feedbackLabel.font = .preferredFont(forTextStyle: .title3)
        feedbackLabel.adjustsFontForContentSizeCategory = true
        feedbackLabel.textAlignment = .center
        feedbackLabel.numberOfLines = 0
        container.addArrangedSubview(feedbackLabel)

        return container
    }

    private func createActionsSection() -> UIView {
        let container = UIStackView()
        container.axis = isAccessibilitySize ? .vertical : .horizontal
        container.spacing = 16
        container.distribution = isAccessibilitySize ? .fill : .fillEqually

        let likeButton = createActionButton(title: "Like", icon: "heart.fill", color: .systemPink, action: #selector(likeTapped))
        let shareButton = createActionButton(title: "Share", icon: "square.and.arrow.up", color: .systemBlue, action: #selector(shareTapped))
        let saveButton = createActionButton(title: "Save", icon: "bookmark.fill", color: .systemGreen, action: #selector(saveTapped))

        container.addArrangedSubview(likeButton)
        container.addArrangedSubview(shareButton)
        container.addArrangedSubview(saveButton)

        return container
    }

    private func createActionButton(title: String, icon: String, color: UIColor, action: Selector) -> UIView {
        let buttonContainer = UIStackView()
        buttonContainer.axis = .vertical
        buttonContainer.spacing = 8
        buttonContainer.alignment = .center

        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)
        button.setImage(UIImage(systemName: icon, withConfiguration: config), for: .normal)
        button.tintColor = .white
        button.backgroundColor = color
        button.layer.cornerRadius = 30
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        // TODO #6: Give this button a Voice Control friendly label (e.g. "Like button").
        button.accessibilityLabel = title

        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 60),
            button.heightAnchor.constraint(equalToConstant: 60)
        ])

        let label = UILabel()
        label.text = title
        label.font = .preferredFont(forTextStyle: .caption1)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center

        if title == "Like" {
            likeCountLabel = UILabel()
            likeCountLabel.text = "\(likeCount)"
            likeCountLabel.font = .preferredFont(forTextStyle: .caption2)
            likeCountLabel.adjustsFontForContentSizeCategory = true
            likeCountLabel.textColor = .secondaryLabel
            likeCountLabel.textAlignment = .center
            buttonContainer.addArrangedSubview(likeCountLabel)
        }

        buttonContainer.addArrangedSubview(button)
        buttonContainer.addArrangedSubview(label)

        return buttonContainer
    }

    private func createToggleSection() -> UIView {
        let container = UIStackView()
        container.axis = .horizontal
        container.spacing = 16
        container.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        container.isLayoutMarginsRelativeArrangement = true
        container.backgroundColor = .secondarySystemGroupedBackground
        container.layer.cornerRadius = 12

        let label = UILabel()
        label.text = "Notifications"
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)

        toggleSwitch = UISwitch()
        toggleSwitch.isOn = isToggled
        toggleSwitch.addTarget(self, action: #selector(toggleChanged), for: .valueChanged)
        // TODO #6: Add a descriptive accessibility label so Voice Control recognises this switch.
        toggleSwitch.accessibilityLabel = "Notifications"

        container.addArrangedSubview(label)
        container.addArrangedSubview(toggleSwitch)

        return container
    }

    private func createTextSection() -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 12
        container.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        container.isLayoutMarginsRelativeArrangement = true
        container.backgroundColor = .secondarySystemGroupedBackground
        container.layer.cornerRadius = 12

        let titleLabel = UILabel()
        titleLabel.text = "Text Input"
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true
        container.addArrangedSubview(titleLabel)

        textField = UITextField()
        textField.placeholder = "Say 'Tap' then dictate text"
        textField.font = .preferredFont(forTextStyle: .body)
        textField.adjustsFontForContentSizeCategory = true
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemBackground
        textField.delegate = self
        container.addArrangedSubview(textField)

        return container
    }

    private func createOptionsSection() -> UIView {
        let container = UIStackView()
        container.axis = isAccessibilitySize ? .vertical : .horizontal
        container.spacing = 12
        container.distribution = isAccessibilitySize ? .fill : .fillEqually

        option1Button = createOptionButton(title: "Option One", action: #selector(option1Tapped))
        option2Button = createOptionButton(title: "Option Two", action: #selector(option2Tapped))
        option3Button = createOptionButton(title: "Option Three", action: #selector(option3Tapped))

        container.addArrangedSubview(option1Button)
        container.addArrangedSubview(option2Button)
        container.addArrangedSubview(option3Button)

        return container
    }

    private func createOptionButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .body)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.backgroundColor = .systemGray5
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.clear.cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        button.addTarget(self, action: action, for: .touchUpInside)
        // TODO #6: Label this option clearly (e.g. "Option one button").
        button.accessibilityLabel = title
        return button
    }

    private func createControlsSection() -> UIView {
        let container = UIStackView()
        container.axis = isAccessibilitySize ? .vertical : .horizontal
        container.spacing = 16
        container.distribution = isAccessibilitySize ? .fill : .fillEqually

        let resetButton = UIButton(type: .system)
        resetButton.setTitle("Reset", for: .normal)
        resetButton.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        resetButton.titleLabel?.adjustsFontForContentSizeCategory = true
        resetButton.backgroundColor = .systemGray
        resetButton.setTitleColor(.white, for: .normal)
        resetButton.layer.cornerRadius = 12
        resetButton.contentEdgeInsets = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
        resetButton.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)
        // TODO #6: Voice Control needs a distinct label here.
        resetButton.accessibilityLabel = "Reset"

        let confirmButton = UIButton(type: .system)
        confirmButton.setTitle("Confirm", for: .normal)
        confirmButton.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        confirmButton.titleLabel?.adjustsFontForContentSizeCategory = true
        confirmButton.backgroundColor = .systemGreen
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.layer.cornerRadius = 12
        confirmButton.contentEdgeInsets = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
        confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
        // TODO #6: Add a unique confirmation label.
        confirmButton.accessibilityLabel = "Confirm"

        container.addArrangedSubview(resetButton)
        container.addArrangedSubview(confirmButton)

        return container
    }

    // MARK: - Actions
    @objc private func likeTapped() {
        likeCount += 1
        likeCountLabel.text = "\(likeCount)"
        feedback = "Liked! Total: \(likeCount)"
        feedbackLabel.text = feedback
    }

    @objc private func shareTapped() {
        feedback = "Shared!"
        feedbackLabel.text = feedback
    }

    @objc private func saveTapped() {
        feedback = "Saved!"
        feedbackLabel.text = feedback
    }

    @objc private func toggleChanged() {
        isToggled = toggleSwitch.isOn
        feedback = "Notifications \(isToggled ? "enabled" : "disabled")"
        feedbackLabel.text = feedback
    }

    @objc private func option1Tapped() {
        selectedOption = "Option One"
        updateOptionButtons()
        feedback = "Selected: Option One"
        feedbackLabel.text = feedback
    }

    @objc private func option2Tapped() {
        selectedOption = "Option Two"
        updateOptionButtons()
        feedback = "Selected: Option Two"
        feedbackLabel.text = feedback
    }

    @objc private func option3Tapped() {
        selectedOption = "Option Three"
        updateOptionButtons()
        feedback = "Selected: Option Three"
        feedbackLabel.text = feedback
    }

    private func updateOptionButtons() {
        [option1Button, option2Button, option3Button].forEach { button in
            let isSelected = button?.currentTitle == selectedOption
            button?.layer.borderColor = isSelected ? UIColor.systemBlue.cgColor : UIColor.clear.cgColor
            button?.backgroundColor = isSelected ? UIColor.systemBlue.withAlphaComponent(0.2) : .systemGray5
        }
    }

    @objc private func resetTapped() {
        likeCount = 0
        isToggled = false
        textInput = ""
        selectedOption = "None"
        feedback = "Reset!"

        likeCountLabel.text = "0"
        toggleSwitch.isOn = false
        textField.text = ""
        feedbackLabel.text = feedback
        updateOptionButtons()
    }

    @objc private func confirmTapped() {
        feedback = "Confirmed!"
        feedbackLabel.text = feedback
    }
}

// MARK: - UITextFieldDelegate
extension VoiceControlTestViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        textInput = textField.text ?? ""
        if !textInput.isEmpty {
            feedback = "Text entered: \(textInput)"
            feedbackLabel.text = feedback
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

#Preview("Voice Control") {
    let vc = VoiceControlTestViewController()
    vc.title = "Voice Control"
    let nav = UINavigationController(rootViewController: vc)
    nav.navigationBar.prefersLargeTitles = true
    return nav
}
