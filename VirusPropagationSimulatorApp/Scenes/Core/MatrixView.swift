//
//  MatrixView.swift
//  VirusPropagationSimulatorApp
//
//  Created by Илья Дубенский on 08.05.2023.
//

import UIKit

protocol MatrixViewDelegate: AnyObject {
    func matrixView(_ matrixView: MatrixView, didSelectCellAt indexPath: IndexPath)
}

class MatrixView: UIView {
    var matrix: [[Bool]] = []

    weak var delegate: MatrixViewDelegate?

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        let cellSize: CGFloat = 30
        let margin: CGFloat = 5

        // Определение начальных координат для отрисовки матрицы
        var x = margin
        var y = margin

        for row in matrix {
            for value in row {
                let rect = CGRect(x: x, y: y, width: cellSize, height: cellSize)

                // Отрисовка прямоугольника с соответствующим цветом в зависимости от значения в матрице
                if value {
                    context.setFillColor(UIColor.red.cgColor)
                } else {
                    context.setFillColor(UIColor.green.cgColor)
                }

                context.fill(rect)
                context.setStrokeColor(UIColor.gray.cgColor)
                context.stroke(rect)

                x += cellSize + margin
            }

            x = margin
            y += cellSize + margin
        }
    }

    @objc private func handleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
            let location = gestureRecognizer.location(in: self)


            // Определите индекс ячейки на основе расположения нажатия
            // ...

            // Создайте IndexPath для ячейки
            let indexPath = IndexPath(row: 0, section: 0)
        print(location)

            // Уведомите делегата о выборе ячейки
            delegate?.matrixView(self, didSelectCellAt: indexPath)
        }
}
