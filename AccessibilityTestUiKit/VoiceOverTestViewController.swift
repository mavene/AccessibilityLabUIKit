//
//  VoiceOverTestViewController.swift
//  AccessibilityTestUiKit
//
//  Migrated from SwiftUI Nutrition Label app
//

import UIKit
import SwiftUI

class VoiceOverTestViewController: UIViewController {

    // MARK: - EXERCISE TODO #1: VoiceOver Essentials (UIKit)
    // TODO #1: Follow the instructions throughout this file and uncomment the marked accessibility code.
    // LEARNING GOAL: Learn how to describe UIKit controls for VoiceOver users using labels, hints, values, and announcements.

    // MARK: - Properties
    private var counter: Int = 0
    private var isLiked: Bool = false
    private var sliderValue: Double = 50.0

    private var scrollView: UIScrollView!
    private var contentStackView: UIStackView!
    private var counterButton: UIButton!
    private var counterLabel: UILabel!
    private var likeButton: UIButton!
    private var weatherContainer: UIView!
    private var volumeSlider: UISlider!
    private var volumeLabel: UILabel!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupScrollView()
        setupContentStackView()
        setupContent()
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
        contentStackView.spacing = 32
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
        // Instructions
        let instructionsLabel = UILabel()
        instructionsLabel.text = "Enable VoiceOver (Settings > Accessibility > VoiceOver) and try interacting with these elements:"
        instructionsLabel.font = .preferredFont(forTextStyle: .body)
        instructionsLabel.adjustsFontForContentSizeCategory = true
        instructionsLabel.textColor = .secondaryLabel
        instructionsLabel.numberOfLines = 0
        contentStackView.addArrangedSubview(instructionsLabel)

        // Counter Button Section
        let counterSection = createCounterSection()
        contentStackView.addArrangedSubview(counterSection)

        // Like Button Section
        let likeSection = createLikeSection()
        contentStackView.addArrangedSubview(likeSection)

        // Weather Group Section
        let weatherSection = createWeatherSection()
        contentStackView.addArrangedSubview(weatherSection)

        // Volume Slider Section
        let volumeSection = createVolumeSection()
        contentStackView.addArrangedSubview(volumeSection)
    }

    // MARK: - Section Creators
    private func createCounterSection() -> UIView {
        let container = createSectionContainer(title: "Counter with Accessibility Value")

        counterButton = UIButton(type: .system)
        counterButton.setTitle("Tap to Count", for: .normal)
        counterButton.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        counterButton.backgroundColor = .systemBlue
        counterButton.setTitleColor(.white, for: .normal)
        counterButton.layer.cornerRadius = 12
        counterButton.contentEdgeInsets = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
        counterButton.addTarget(self, action: #selector(incrementCounter), for: .touchUpInside)

        // TODO #1: Uncomment the lines below so VoiceOver reads a helpful label, hint, and value.
        counterButton.accessibilityLabel = "Counter button"
        counterButton.accessibilityHint = "Double tap to increment the counter"
        counterButton.accessibilityValue = String(counter)

        counterLabel = UILabel()
        counterLabel.text = "Count: \(counter)"
        counterLabel.font = .preferredFont(forTextStyle: .title2)
        counterLabel.adjustsFontForContentSizeCategory = true
        counterLabel.textAlignment = .center
        // TODO #1: Give the visual counter a VoiceOver description that mirrors the number shown.
        counterLabel.isAccessibilityElement = true
        counterLabel.accessibilityLabel = "Item count"
        counterLabel.accessibilityValue = "\(counter)"

        container.addArrangedSubview(counterButton)
        container.addArrangedSubview(counterLabel)

        return container
    }

    private func createLikeSection() -> UIView {
        let container = createSectionContainer(title: "Like Button with State")

        likeButton = UIButton(type: .system)
        likeButton.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        likeButton.layer.cornerRadius = 12
        likeButton.contentEdgeInsets = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
        likeButton.addTarget(self, action: #selector(toggleLike), for: .touchUpInside)
        updateLikeButton()

        container.addArrangedSubview(likeButton)

        return container
    }

    private func createWeatherSection() -> UIView {
        let container = createSectionContainer(title: "Grouped Weather Information")

        weatherContainer = UIView()
        weatherContainer.backgroundColor = .secondarySystemBackground
        weatherContainer.layer.cornerRadius = 12
        weatherContainer.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        weatherContainer.addSubview(stackView)

        let iconView = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 40, weight: .medium)
        iconView.image = UIImage(systemName: "sun.max.fill", withConfiguration: config)
        iconView.tintColor = .systemYellow
        iconView.contentMode = .scaleAspectFit
        stackView.addArrangedSubview(iconView)
        // TODO #1: Add a descriptive label so the weather icon isn't read as a generic image.
        iconView.isAccessibilityElement = true
        iconView.accessibilityLabel = "Sunny weather icon"

        let infoStack = UIStackView()
        infoStack.axis = .vertical
        infoStack.spacing = 4

        let tempLabel = UILabel()
        tempLabel.text = "22°C"
        tempLabel.font = .preferredFont(forTextStyle: .title1)
        tempLabel.adjustsFontForContentSizeCategory = true
        infoStack.addArrangedSubview(tempLabel)

        let conditionLabel = UILabel()
        conditionLabel.text = "Sunny"
        conditionLabel.font = .preferredFont(forTextStyle: .body)
        conditionLabel.adjustsFontForContentSizeCategory = true
        conditionLabel.textColor = .secondaryLabel
        infoStack.addArrangedSubview(conditionLabel)

        stackView.addArrangedSubview(infoStack)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: weatherContainer.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: weatherContainer.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: weatherContainer.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: weatherContainer.bottomAnchor, constant: -16)
        ])

        // TODO #1: Group the entire card into one announcement for smoother narration.
        weatherContainer.isAccessibilityElement = true
        weatherContainer.accessibilityLabel = "Weather display"
        weatherContainer.accessibilityValue = "22 degrees Celsius and sunny"

        container.addArrangedSubview(weatherContainer)

        return container
    }

    private func createVolumeSection() -> UIView {
        let container = createSectionContainer(title: "Volume Slider")

        let sliderContainer = UIView()

        volumeSlider = UISlider()
        volumeSlider.minimumValue = 0
        volumeSlider.maximumValue = 100
        volumeSlider.value = Float(sliderValue)
        volumeSlider.addTarget(self, action: #selector(volumeChanged), for: .valueChanged)
        volumeSlider.translatesAutoresizingMaskIntoConstraints = false
        sliderContainer.addSubview(volumeSlider)

        // TODO #1: Describe the slider in VoiceOver and announce its value.
        volumeSlider.accessibilityLabel = "Volume"
        volumeSlider.accessibilityHint = "Swipe up or down to adjust volume"
        volumeSlider.accessibilityValue = "\(Int(sliderValue)) percent"

        volumeLabel = UILabel()
        volumeLabel.text = "Volume: \(Int(sliderValue))%"
        volumeLabel.font = .preferredFont(forTextStyle: .body)
        volumeLabel.adjustsFontForContentSizeCategory = true
        volumeLabel.textAlignment = .center
        volumeLabel.translatesAutoresizingMaskIntoConstraints = false
        // TODO #1: Hide this label from VoiceOver once the slider announces the same value.
        volumeLabel.isAccessibilityElement = false
        sliderContainer.addSubview(volumeLabel)

        NSLayoutConstraint.activate([
            volumeSlider.topAnchor.constraint(equalTo: sliderContainer.topAnchor),
            volumeSlider.leadingAnchor.constraint(equalTo: sliderContainer.leadingAnchor),
            volumeSlider.trailingAnchor.constraint(equalTo: sliderContainer.trailingAnchor),

            volumeLabel.topAnchor.constraint(equalTo: volumeSlider.bottomAnchor, constant: 12),
            volumeLabel.leadingAnchor.constraint(equalTo: sliderContainer.leadingAnchor),
            volumeLabel.trailingAnchor.constraint(equalTo: sliderContainer.trailingAnchor),
            volumeLabel.bottomAnchor.constraint(equalTo: sliderContainer.bottomAnchor)
        ])

        container.addArrangedSubview(sliderContainer)

        return container
    }

    private func createSectionContainer(title: String) -> UIStackView {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 16
        container.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        container.isLayoutMarginsRelativeArrangement = true
        container.backgroundColor = .secondarySystemGroupedBackground
        container.layer.cornerRadius = 12

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true
        container.addArrangedSubview(titleLabel)

        return container
    }

    // MARK: - Actions
    @objc private func incrementCounter() {
        counter += 1
        counterLabel.text = "Count: \(counter)"
        // TODO #1: Keep the accessibility value in sync with the visual count.
        counterLabel.accessibilityValue = "\(counter)"
        counterButton.accessibilityValue = String(counter)

        // TODO #1: Announce the new value so users hear the update immediately.
        announce("Count is now \(counter)")
    }

    /// Posts a VoiceOver announcement after a short delay so it isn't cut off
    /// by VoiceOver re-reading the element that was just activated.
    private func announce(_ message: String, delay: TimeInterval = 0.5) {
        let announcement = NSAttributedString(
            string: message,
            attributes: [.accessibilitySpeechQueueAnnouncement: true]
        )
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            UIAccessibility.post(notification: .announcement, argument: announcement)
        }
    }

    @objc private func toggleLike() {
        isLiked.toggle()
        updateLikeButton()

        // TODO #1: Announce the new like state for VoiceOver users.
        let message = isLiked ? "Liked" : "Unliked"
        announce(message)
    }

    private func updateLikeButton() {
        let title = isLiked ? "Unlike" : "Like"
        let color: UIColor = isLiked ? .systemPink : .systemGray
        likeButton.setTitle(title, for: .normal)
        likeButton.backgroundColor = color
        likeButton.setTitleColor(.white, for: .normal)

        // TODO #1: Give the button a dynamic label, hint, and value that match its state.
        likeButton.accessibilityLabel = isLiked ? "Unlike" : "Like"
        likeButton.accessibilityHint = isLiked ? "Double tap to unlike" : "Double tap to like"
        likeButton.accessibilityValue = isLiked ? "Liked" : "Not liked"
    }

    @objc private func volumeChanged() {
        sliderValue = Double(volumeSlider.value)
        volumeLabel.text = "Volume: \(Int(sliderValue))%"
        // TODO #1: Keep the slider's accessibility value in sync with the on-screen text.
        volumeSlider.accessibilityValue = "\(Int(sliderValue)) percent"
    }
}

#Preview("VoiceOver") {
    let vc = VoiceOverTestViewController()
    vc.title = "VoiceOver"
    let nav = UINavigationController(rootViewController: vc)
    nav.navigationBar.prefersLargeTitles = true
    return nav
}
