import UIKit

func indexOfLine(at point: CGPoint) -> Int? {
    for (index, line) in finishedLines.enumerated() {
        let begin = line.points.first
        let end = line.points.last
        for t in stride(from: CGFloat(0), to: 1.0, by: 0.05) {
            let x = (begin?.x)! + ((end!.x - begin!.x) * t)
            let y = (begin?.y)! + ((end!.y - begin!.y) * t)
            if hypot(x - point.x, y - point.y) < 20.0 {
                print(index)
                return index
            }
        }
    }
    return nil
}
