//
//  SettingsViewController.swift
//  VirusPropagationSimulatorApp
//
//  Created by Илья Дубенский on 04.05.2023.
//

import UIKit

class SettingsViewController: UIViewController {
    private lazy var GroupSizeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Input Group Size"
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()

    private lazy var GroupSizeTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "100"
        textField.keyboardType = .numberPad
        textField.layer.masksToBounds = true
        textField.font = .systemFont(ofSize: 16, weight: .regular)
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 8
        textField.layer.borderColor = UIColor.systemGray3.cgColor
        textField.layer.borderWidth = 1
        textField.leftView = UIView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: 10,
                                                  height: textField.frame.height))
        textField.leftViewMode = .always
        return textField
    }()

    private lazy var InfectionFactorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Input Infection Factor"
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()

    private lazy var InfectionFactorTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "3"
        textField.keyboardType = .numberPad
        textField.layer.masksToBounds = true
        textField.font = .systemFont(ofSize: 16, weight: .regular)
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 8
        textField.layer.borderColor = UIColor.systemGray3.cgColor
        textField.layer.borderWidth = 1
        textField.leftView = UIView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: 10,
                                                  height: textField.frame.height))
        textField.leftViewMode = .always
        return textField
    }()

    private lazy var TimerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Input Timer"
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()

    private lazy var TimerTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "3"
        textField.keyboardType = .numberPad
        textField.layer.masksToBounds = true
        textField.font = .systemFont(ofSize: 16, weight: .regular)
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 8
        textField.layer.borderColor = UIColor.systemGray3.cgColor
        textField.layer.borderWidth = 1
        textField.leftView = UIView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: 10,
                                                  height: textField.frame.height))
        textField.leftViewMode = .always
        return textField
    }()

    private lazy var StartModulationButton: UIButton = {
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.baseBackgroundColor = .systemBlue
        buttonConfiguration.title = "Start Modulation"
        let button = UIButton(configuration: buttonConfiguration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.shadowOffset = CGSize(width: 3, height: 3)
        button.layer.shadowRadius = 2
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.5
        button.addTarget(self,
                         action: #selector(startModulationButtonDidTupped),
                         for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainView()
    }

    @objc func startModulationButtonDidTupped() {
        if let groupSize = Int(GroupSizeTextField.text ?? "0"),
           let infectionFactor = Int(InfectionFactorTextField.text ?? "0"),
           let timer = Double(TimerTextField.text ?? "0"),
           groupSize > 0,
           infectionFactor > 0,
           timer > 0 {
            let modulationVC = ModulationViewController()

            modulationVC.groupSize = groupSize
            modulationVC.infectionFactor = infectionFactor
            modulationVC.timer = timer

            modulationVC.matrix = makeMatrix(groupSize)

            self.GroupSizeTextField.text = nil
            self.InfectionFactorTextField.text = nil
            self.TimerTextField.text = nil

            navigationController?.pushViewController(modulationVC, animated: true)
        } else {

        }
    }

    func makeMatrix(_ number: Int) -> [[Bool]] {

        let rows = sqrt(Double(number))
        let  columns = sqrt(Double(number))

        return Array(repeating: Array(repeating: false, count: Int(columns)), count: Int(rows))
    }
}

extension SettingsViewController {
    private func setupMainView() {
        view.backgroundColor = .systemGray6
        setupNavigationBar()
        view.addSubviews(GroupSizeLabel,
                         GroupSizeTextField,
                         InfectionFactorLabel,
                         InfectionFactorTextField,
                         TimerLabel,
                         TimerTextField,
                         StartModulationButton)
        setupConstraints()
    }

    private func setupNavigationBar() {
        let navBarAppearance = UINavigationBarAppearance()
        title = "Settings"
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            GroupSizeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            GroupSizeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            GroupSizeLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            GroupSizeTextField.topAnchor.constraint(equalTo: GroupSizeLabel.bottomAnchor, constant: 10),
            GroupSizeTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            GroupSizeTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            GroupSizeTextField.heightAnchor.constraint(equalToConstant: 40),

            InfectionFactorLabel.topAnchor.constraint(equalTo: GroupSizeTextField.bottomAnchor, constant: 20),
            InfectionFactorLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            InfectionFactorLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            InfectionFactorTextField.topAnchor.constraint(equalTo: InfectionFactorLabel.bottomAnchor, constant: 10),
            InfectionFactorTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            InfectionFactorTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            InfectionFactorTextField.heightAnchor.constraint(equalToConstant: 40),

            TimerLabel.topAnchor.constraint(equalTo: InfectionFactorTextField.bottomAnchor, constant: 20),
            TimerLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            TimerLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            TimerTextField.topAnchor.constraint(equalTo: TimerLabel.bottomAnchor, constant: 10),
            TimerTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            TimerTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            TimerTextField.heightAnchor.constraint(equalToConstant: 40),

            StartModulationButton.topAnchor.constraint(equalTo: TimerTextField.bottomAnchor, constant: 30),
            StartModulationButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            StartModulationButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            StartModulationButton.heightAnchor.constraint(equalToConstant: 40),

        ])
    }
}
