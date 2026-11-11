//
//  ReducedMotionTestViewController.swift
//  AccessibilityTestUiKit
//
//  Migrated from SwiftUI Nutrition Label app
//

import UIKit
import SwiftUI

class ReducedMotionTestViewController: UIViewController {

    // MARK: - EXERCISE TODO #5: Reduce Motion (UIKit)
    // TODO #5: Respect the Reduce Motion preference by detecting it and swapping intense animations with calmer alternatives.
    // LEARNING GOAL: Use `UIAccessibility.isReduceMotionEnabled` and design fallbacks that avoid dizziness or distraction.

    private var scrollView: UIScrollView!
    private var contentStackView: UIStackView!
    private var isAnimating = false
    private var animationTimer: Timer?
    private var remainingTime = 30

    private var movingCircle: UIView!
    private var pulsingHeart: UIImageView!
    private var rotatingArrow: UIImageView!
    private var card1: UIView!
    private var card2: UIView!
    private var timerLabel: UILabel!
    private var animationButton: UIButton!

    // TODO #5: Replace this placeholder with `UIAccessibility.isReduceMotionEnabled`.
    private var isReduceMotionEnabled: Bool {
        //return false
        return UIAccessibility.isReduceMotionEnabled
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupScrollView()
        setupContentStackView()
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
        contentStackView.addArrangedSubview(createStatusIndicator())
        contentStackView.addArrangedSubview(createAnimationControlSection())
        contentStackView.addArrangedSubview(createMovementSection())
        contentStackView.addArrangedSubview(createScalePulseSection())
        contentStackView.addArrangedSubview(createRotationSection())
        contentStackView.addArrangedSubview(createTransitionSection())
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
        statusLabel.text = isReduceMotionEnabled ? "Reduce Motion: ON" : "Reduce Motion: OFF"
        statusLabel.font = .preferredFont(forTextStyle: .title3)
        statusLabel.adjustsFontForContentSizeCategory = true
        statusLabel.textAlignment = .center
        container.addArrangedSubview(statusLabel)

        return container
    }

    private func createAnimationControlSection() -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 12
        container.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        container.isLayoutMarginsRelativeArrangement = true
        container.backgroundColor = .systemBlue.withAlphaComponent(0.1)
        container.layer.cornerRadius = 12

        let titleLabel = UILabel()
        titleLabel.text = "Animation Control"
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true
        container.addArrangedSubview(titleLabel)

        animationButton = UIButton(type: .system)
        animationButton.setTitle("Start 30s Animation Demo", for: .normal)
        animationButton.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        animationButton.backgroundColor = .systemBlue
        animationButton.setTitleColor(.white, for: .normal)
        animationButton.layer.cornerRadius = 12
        animationButton.contentEdgeInsets = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
        animationButton.addTarget(self, action: #selector(toggleAnimation), for: .touchUpInside)
        container.addArrangedSubview(animationButton)

        timerLabel = UILabel()
        timerLabel.text = "Not running"
        timerLabel.font = .preferredFont(forTextStyle: .body)
        timerLabel.adjustsFontForContentSizeCategory = true
        timerLabel.textAlignment = .center
        timerLabel.textColor = .secondaryLabel
        container.addArrangedSubview(timerLabel)

        return container
    }

    private func createMovementSection() -> UIView {
        let container = UIView()
        container.backgroundColor = .secondarySystemGroupedBackground
        container.layer.cornerRadius = 12
        container.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = "Movement & Spring"
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(titleLabel)

        movingCircle = UIView()
        movingCircle.backgroundColor = .systemBlue
        movingCircle.layer.cornerRadius = 20
        movingCircle.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(movingCircle)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),

            movingCircle.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            movingCircle.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            movingCircle.widthAnchor.constraint(equalToConstant: 40),
            movingCircle.heightAnchor.constraint(equalToConstant: 40),
            movingCircle.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20)
        ])

        return container
    }

    private func createScalePulseSection() -> UIView {
        let container = UIView()
        container.backgroundColor = .secondarySystemGroupedBackground
        container.layer.cornerRadius = 12
        container.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = "Scale & Pulse"
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(titleLabel)

        pulsingHeart = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 40, weight: .medium)
        pulsingHeart.image = UIImage(systemName: "heart.fill", withConfiguration: config)
        pulsingHeart.tintColor = .systemPink
        pulsingHeart.contentMode = .scaleAspectFit
        pulsingHeart.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(pulsingHeart)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),

            pulsingHeart.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            pulsingHeart.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            pulsingHeart.widthAnchor.constraint(equalToConstant: 40),
            pulsingHeart.heightAnchor.constraint(equalToConstant: 40),
            pulsingHeart.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20)
        ])

        return container
    }

    private func createRotationSection() -> UIView {
        let container = UIView()
        container.backgroundColor = .secondarySystemGroupedBackground
        container.layer.cornerRadius = 12
        container.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = "Rotation"
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(titleLabel)

        rotatingArrow = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 40, weight: .medium)
        rotatingArrow.image = UIImage(systemName: "arrow.clockwise", withConfiguration: config)
        rotatingArrow.tintColor = .systemGreen
        rotatingArrow.contentMode = .scaleAspectFit
        rotatingArrow.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(rotatingArrow)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),

            rotatingArrow.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            rotatingArrow.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            rotatingArrow.widthAnchor.constraint(equalToConstant: 40),
            rotatingArrow.heightAnchor.constraint(equalToConstant: 40),
            rotatingArrow.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20)
        ])

        return container
    }

    private func createTransitionSection() -> UIView {
        let container = UIView()
        container.backgroundColor = .secondarySystemGroupedBackground
        container.layer.cornerRadius = 12
        container.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = "Opacity Transition"
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(titleLabel)

        card1 = createCard(icon: "sun.max.fill", text: "Day", color: .systemYellow)
        container.addSubview(card1)

        card2 = createCard(icon: "moon.fill", text: "Night", color: .systemIndigo)
        card2.alpha = 0
        container.addSubview(card2)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),

            card1.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            card1.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            card1.widthAnchor.constraint(equalToConstant: 120),
            card1.heightAnchor.constraint(equalToConstant: 120),
            card1.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20),

            card2.topAnchor.constraint(equalTo: card1.topAnchor),
            card2.centerXAnchor.constraint(equalTo: card1.centerXAnchor),
            card2.widthAnchor.constraint(equalTo: card1.widthAnchor),
            card2.heightAnchor.constraint(equalTo: card1.heightAnchor)
        ])

        return container
    }

    private func createCard(icon: String, text: String, color: UIColor) -> UIView {
        let card = UIView()
        card.backgroundColor = color.withAlphaComponent(0.2)
        card.layer.cornerRadius = 12
        card.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(stackView)

        let iconView = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 40, weight: .medium)
        iconView.image = UIImage(systemName: icon, withConfiguration: config)
        iconView.tintColor = color
        stackView.addArrangedSubview(iconView)

        let label = UILabel()
        label.text = text
        label.font = .preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = color
        stackView.addArrangedSubview(label)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: card.centerYAnchor)
        ])

        return card
    }

    @objc private func toggleAnimation() {
        if isAnimating {
            stopAnimation()
        } else {
            startAnimation()
        }
    }

    private func startAnimation() {
        isAnimating = true
        remainingTime = 30
        animationButton.setTitle("Stop Animation", for: .normal)
        animationButton.backgroundColor = .systemRed

        animationTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.remainingTime -= 1
            self.timerLabel.text = "Time remaining: \(self.remainingTime)s"

            if self.remainingTime <= 0 {
                self.stopAnimation()
            }
        }

        runAnimationLoop()
    }

    private func stopAnimation() {
        isAnimating = false
        animationTimer?.invalidate()
        animationTimer = nil
        animationButton.setTitle("Start 30s Animation Demo", for: .normal)
        animationButton.backgroundColor = .systemBlue
        timerLabel.text = "Not running"
        removeRepeatingAnimations()
    }

    /// Starts the pulse and rotation if Reduce Motion is off and they aren't already running;
    /// removes them (leaving static views) if Reduce Motion is on.
    private func updateRepeatingAnimations() {
        guard !isReduceMotionEnabled else {
            removeRepeatingAnimations()
            return
        }

        if pulsingHeart.layer.animation(forKey: "pulse") == nil {
            let pulse = CABasicAnimation(keyPath: "transform.scale")
            pulse.fromValue = 1.0
            pulse.toValue = 1.3
            pulse.duration = 1.0
            pulse.autoreverses = true
            pulse.repeatCount = .infinity
            pulsingHeart.layer.add(pulse, forKey: "pulse")
        }

        if rotatingArrow.layer.animation(forKey: "rotate") == nil {
            // A UIView animation to rotationAngle(2π) never moves: 2π is the identity
            // transform, so UIKit has nothing to interpolate. Animate the layer instead.
            let rotate = CABasicAnimation(keyPath: "transform.rotation.z")
            rotate.fromValue = 0
            rotate.toValue = CGFloat.pi * 2
            rotate.duration = 2.0
            rotate.timingFunction = CAMediaTimingFunction(name: .linear)
            rotate.repeatCount = .infinity
            rotatingArrow.layer.add(rotate, forKey: "rotate")
        }
    }

    private func removeRepeatingAnimations() {
        pulsingHeart.layer.removeAnimation(forKey: "pulse")
        rotatingArrow.layer.removeAnimation(forKey: "rotate")
        pulsingHeart.transform = .identity
        rotatingArrow.transform = .identity
    }

    private func runAnimationLoop() {
        guard isAnimating else { return }

        let duration = isReduceMotionEnabled ? 0 : 1.0

        // Movement animation
        // TODO #5: Skip this springy movement entirely when Reduce Motion is on.
        if !isReduceMotionEnabled {
            UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseInOut], animations: {
                let maxX = self.view.bounds.width - 80
                let newX = CGFloat.random(in: 20...maxX)
                self.movingCircle.frame.origin.x = newX
            })
        }

        // Pulse + rotation: repeating animations are started once (not every loop pass)
        // and removed when Reduce Motion is on.
        updateRepeatingAnimations()

        // Card transition
        // TODO #5: Provide a static alternative (e.g. instant swap) when animations are disabled.
        if !isReduceMotionEnabled {
            UIView.animate(withDuration: duration, delay: 0, options: [], animations: {
                self.card1.alpha = self.card1.alpha == 1 ? 0 : 1
                self.card2.alpha = self.card2.alpha == 1 ? 0 : 1
            })
        } else {
            // Static alternative - swap instantly, no fade
            card1.alpha = card1.alpha == 1 ? 0 : 1
            card2.alpha = card2.alpha == 1 ? 0 : 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.runAnimationLoop()
        }
    }
}

#Preview("Reduce Motion") {
    let vc = ReducedMotionTestViewController()
    vc.title = "Reduce Motion"
    let nav = UINavigationController(rootViewController: vc)
    nav.navigationBar.prefersLargeTitles = true
    return nav
}
