//
//  ModulationWithCoreGraphicsViewController.swift
//  VirusPropagationSimulatorApp
//
//  Created by Илья Дубенский on 08.05.2023.
//

import UIKit

class ModulationWithCoreGraphicsViewController: UIViewController, UIGestureRecognizerDelegate, MatrixViewDelegate {

    var groupSize = 0
    var infectionFactor = 0
    var recalculationPeriod = 0.0
    var matrix: [[Bool]] = [[]]


    // MARK: - Private Properties
    private var timer: Timer?
    private var seconds = 0
    private var cellScaleFactor = 1.0
    private var scale: CGFloat = 1.0


    // MARK: - Computed Properties
    private var matrixElements: Int {
        let rowCount = matrix.count
        let columnCount = matrix.first?.count ?? 0

        let totalCount = rowCount * columnCount
        return totalCount
    }

    private var greenElements: Int {
        var count = 0
            for row in matrix {
                for element in row {
                    if !element {
                        count += 1
                    }
                }
            }
            return count
    }

    private var redElements: Int {
        var count = 0
            for row in matrix {
                for element in row {
                    if element {
                        count += 1
                    }
                }
            }
            return count
    }

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        scrollView.backgroundColor = .brown
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var matrixView: MatrixView = {
        let matrixView = MatrixView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: UIScreen.main.bounds.width * 3,
                                                  height: UIScreen.main.bounds.height * 2))
        matrixView.translatesAutoresizingMaskIntoConstraints = false
        matrixView.matrix = matrix
        matrixView.delegate = self
        return matrixView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.contentSize = matrixView.frame.size
        scrollView.addSubview(matrixView)
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        pinchGesture.delegate = self
        matrixView.addGestureRecognizer(pinchGesture)
        setConstraints()
    }

    @objc func handlePinchGesture(_ gestureRecognizer: UIPinchGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            // Изменяем масштаб
            scale *= gestureRecognizer.scale
            gestureRecognizer.scale = 1.0

            // Применяем масштаб к UICollectionView
            matrixView.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // Разрешаем одновременное распознавание жестов
        return true
    }

    func matrixView(_ matrixView: MatrixView, didSelectCellAt indexPath: IndexPath) {
        print(indexPath)
    }


    private func setConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

