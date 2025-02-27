// Copyright 2019 The TensorFlow Authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import XCTest
@testable import TensorFlow

final class LossTests: XCTestCase {
    func testL1Loss() {
        let predicted = Tensor<Float>([1, 2, 3, 4])
        let expected = Tensor<Float>([0.1, 0.2, 0.3, 0.4])
        let loss = l1Loss(predicted: predicted, expected: expected)
        let expectedLoss: Float = 9.0
        assertElementsEqual(expected: Tensor(expectedLoss), actual: loss)
    }

    func testL2Loss() {
        let predicted = Tensor<Float>([1, 2, 3, 4])
        let expected = Tensor<Float>([0.5, 1.5, 2.5, 3.5])
        let loss = l2Loss(predicted: predicted, expected: expected)
        let expectedLoss: Float = 1.0
        assertElementsEqual(expected: Tensor(expectedLoss), actual: loss)
    }

    func testMeanSquaredErrorLoss() {
        let predicted = Tensor<Float>(shape: [2, 4], scalars: [1, 2, 3, 4, 5, 6, 7, 8])
        let expected = Tensor<Float>(
            shape: [2, 4],
            scalars: [0.1, 0.2, 0.3, 0.4, 0.4, 0.3, 0.2, 0.1])

        let loss = meanSquaredError(predicted: predicted, expected: expected)
        let expectedLoss: Float = 23.324999
        assertElementsEqual(expected: Tensor(expectedLoss), actual: loss)
    }

    func testMeanSquaredLogarithmicError() {
        let predicted = Tensor<Float>(shape: [2, 4], scalars: [1, 2, 3, 4, 5, 6, 7, 8])
        let expected = Tensor<Float>(
            shape: [2, 4],
            scalars: [0.1, 0.2, 0.3, 0.4, 0.4, 0.3, 0.2, 0.1])

        let loss = meanSquaredLogarithmicError(predicted: predicted, expected: expected)
        let expectedLoss: Float = 2.1312442
        assertElementsEqual(expected: Tensor(expectedLoss), actual: loss)
    }

    func testMeanAbsoluteError() {
        let predicted = Tensor<Float>(shape: [2, 4], scalars: [1, 2, 3, 4, 5, 6, 7, 8])
        let expected = Tensor<Float>(
            shape: [2, 4],
            scalars: [0.1, 0.2, 0.3, 0.4, 0.4, 0.3, 0.2, 0.1])

        let loss = meanAbsoluteError(predicted: predicted, expected: expected)
        let expectedLoss: Float = 4.25
        assertElementsEqual(expected: Tensor(expectedLoss), actual: loss)
    }

    func testMeanAbsolutePercentageError() {
        let predicted = Tensor<Float>([1, 2, 3, 4, 5, 6, 7, 8])
        let expected = Tensor<Float>([0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8])

        let loss = meanAbsolutePercentageError(predicted: predicted, expected: expected)
        let expectedLoss: Float = 900.0
        assertElementsEqual(expected: Tensor(expectedLoss), actual: loss)
    }

    func testMeanSquaredErrorGrad() {
        let predicted = Tensor<Float>(shape: [2, 4], scalars: [1, 2, 3, 4, 5, 6, 7, 8])
        let expected = Tensor<Float>(
            shape: [2, 4],
            scalars: [0.1, 0.2, 0.3, 0.4, 0.4, 0.3, 0.2, 0.1])

        let expectedGradientsBeforeMean = Tensor<Float>(
            shape: [2, 4],
            scalars: [1.8, 3.6, 5.4, 7.2, 9.2, 11.4, 13.6, 15.8])
        // As the loss is mean loss, we should scale the golden gradient numbers.
        let expectedGradients = expectedGradientsBeforeMean / Float(predicted.scalars.count)

        let gradients = gradient(
            at: predicted,
            in: { meanSquaredError(predicted: $0, expected: expected) })

        assertElementsEqual(expected: expectedGradients, actual: gradients)
    }

    func testHingeLoss() {
        let predicted = Tensor<Float>(shape: [2, 4], scalars: [1, 2, 3, 4, 5, 6, 7, 8])
        let expected = Tensor<Float>(
            shape: [2, 4],
            scalars: [0.1, 0.2, 0.3, 0.4, 0.4, 0.3, 0.2, 0.1])

        let loss = hingeLoss(predicted: predicted, expected: expected)
        let expectedLoss: Float = 0.225
        assertElementsEqual(expected: Tensor(expectedLoss), actual: loss)
    }
    
    func testCosineSimilarityLoss() {
        let predicted = Tensor<Float>([1, 2, 3, 4, 5, 6, 7, 8])
        let expected = Tensor<Float>([0.5, 1, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0])
        let loss = cosineSimilarity(predicted: predicted, expected: expected)
        let expectedLoss: Float = -1.0
        assertElementsEqual(expected: Tensor(expectedLoss), actual: loss)
    }

    func testSquaredHingeLoss() {
        let predicted = Tensor<Float>([1, 2, 3, 4, 5, 6, 7, 8])
        let expected = Tensor<Float>([0.5, 1, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0])
        let loss = squaredHingeLoss(predicted: predicted, expected: expected)
        let expectedLoss: Float = 0.03125
        assertElementsEqual(expected: Tensor(expectedLoss), actual: loss)
    }

    func testCategoricalHingeLoss() {
        let predicted = Tensor<Float>([3, 4 ,5])
        let expected = Tensor<Float>([0.3, 0.4, 0.3])

        let loss = categoricalHingeLoss(predicted: predicted, expected: expected)
        let expectedLoss: Float = 0.5
        assertElementsEqual(expected: Tensor(expectedLoss), actual: loss)
    }

    func testPoissonLoss() {
        let predicted = Tensor<Float>([0.1, 0.2, 0.3])
        let expected = Tensor<Float>([1, 2, 3])
        let loss = poissonLoss(predicted: predicted, expected: expected)
        let expectedLoss: Float = 3.2444599
        assertElementsEqual(expected: Tensor(expectedLoss), actual: loss)
    }

    func testKullbackLeiblerDivergence() {
        let predicted = Tensor<Float>([0.2, 0.3, 0.4])
        let expected = Tensor<Float>([1.0, 4.0, 3.0])
        let loss = kullbackLeiblerDivergence(predicted: predicted, expected: expected)
        let expectedLoss: Float = 18.015217
        assertElementsEqual(expected: Tensor(expectedLoss), actual: loss)
    }

    func testSoftmaxCrossEntropyWithProbabilitiesLoss() {
        let logits = Tensor<Float>(shape: [2, 4], scalars: [1, 2, 3, 4, 5, 6, 7, 8])
        let labels = Tensor<Float>(
            shape: [2, 4],
            scalars: [0.1, 0.2, 0.3, 0.4, 0.4, 0.3, 0.2, 0.1])

        let loss = softmaxCrossEntropy(logits: logits, probabilities: labels)
        // Loss for two rows are 1.44019 and 2.44019 respectively.
        let expectedLoss: Float = (1.44019 + 2.44019) / 2.0
        assertElementsEqual(expected: Tensor(expectedLoss), actual: loss)
    }

    func testSoftmaxCrossEntropyWithProbabilitiesGrad() {
        let logits = Tensor<Float>(shape: [2, 4], scalars: [1, 2, 3, 4, 5, 6, 7, 8])
        let labels = Tensor<Float>(
            shape: [2, 4],
            scalars: [0.1, 0.2, 0.3, 0.4, 0.4, 0.3, 0.2, 0.1])

        // For the logits and labels above, the gradients below are the golden values. To calcuate
        // them by hand, you can do
        //
        //  D Loss / D logits_i = p_i - labels_i
        //
        //  where p_i is softmax(logits_i).
        let expectedGradientsBeforeMean = Tensor<Float>(
            shape: [2, 4],
            scalars: [-0.067941, -0.112856, -0.063117, 0.243914,
                      -0.367941, -0.212856, 0.036883, 0.543914])

        // As the loss is mean loss, we should scale the golden gradient numbers.
        let expectedGradients = expectedGradientsBeforeMean / Float(logits.shape[0])
        let gradients = gradient(
            at: logits,
            in: { softmaxCrossEntropy(logits: $0, probabilities: labels) })
        assertElementsEqual(expected: expectedGradients, actual: gradients)
    }

    func testSigmoidCrossEntropyLoss() {
        let logits = Tensor<Float>(
            shape: [2, 4],
            scalars: [-100, -2, -2, 0, 2, 2, 2, 100])

        let labels = Tensor<Float>(
            shape: [2, 4],
            scalars: [0, 0, 1, 0, 0, 1, 0.5, 1])

        let loss = sigmoidCrossEntropy(logits: logits, labels: labels)
        let expectedLoss: Float = 0.7909734
        assertElementsEqual(expected: Tensor(expectedLoss), actual: loss)
    }

    func testSigmoidCrossEntropyGrad() {
        let logits = Tensor<Float>(
            shape: [2, 4],
            scalars: [-100, -2, -2, 0, 2, 2, 2, 100])

        let labels = Tensor<Float>(
            shape: [2, 4],
            scalars: [0, 0, 1, 0, 0, 1, 0.5, 1])

        // For each element x in logits and y in labels, the gradient is sigmoid(x) - y.
        let expectedGradientsBeforeMean = Tensor<Float>(
            shape: [2, 4],
            scalars: [0.00,  0.11920291, -0.8807971,  0.5,
                      0.8807971, -0.11920291,  0.3807971 , 0.0])

        // As the loss is mean loss, we should scale the golden gradient numbers.
        let expectedGradients = expectedGradientsBeforeMean / Float(logits.scalars.count)
        let gradients = gradient(
            at: logits,
            in: { sigmoidCrossEntropy(logits: $0, labels: labels) })
        assertElementsEqual(expected: expectedGradients, actual: gradients)
    }

    func assertElementsEqual(
        expected: Tensor<Float>,
        actual: Tensor<Float>,
        accuracy: Float = 1e-6
    ) {
        XCTAssertEqual(expected.shape, actual.shape, "Shape mismatch.")
        for (index, expectedElement) in expected.scalars.enumerated() {
            let actualElement = actual.scalars[index]
            XCTAssertEqual(
                expectedElement, actualElement, accuracy: accuracy,
                "Found difference at \(index), " +
                "expected: \(expectedElement), actual: \(actualElement).")
        }
    }

    static var allTests = [
        ("testL1Loss", testL1Loss),
        ("testL2Loss", testL2Loss),
        ("testMeanSquaredErrorLoss", testMeanSquaredErrorLoss),
        ("testMeanSquaredErrorGrad", testMeanSquaredErrorGrad),
        ("testMeanSquaredLogarithmicError", testMeanSquaredLogarithmicError),
        ("testMeanAbsoluteError", testMeanAbsoluteError),
        ("testMeanAbsolutePercentageError", testMeanAbsolutePercentageError),
        ("testHingeLoss", testHingeLoss),
        ("testKullbackLeiblerDivergence", testKullbackLeiblerDivergence),
        ("testCategoricalHingeLoss", testCategoricalHingeLoss),
        ("testCosineSimilarityLoss", testCosineSimilarityLoss),
        ("testSquaredHingeLoss", testSquaredHingeLoss),
        ("testPoissonLoss", testPoissonLoss),
        ("testSoftmaxCrossEntropyWithProbabilitiesLoss",
         testSoftmaxCrossEntropyWithProbabilitiesLoss),
        ("testSoftmaxCrossEntropyWithProbabilitiesGrad",
         testSoftmaxCrossEntropyWithProbabilitiesGrad),
        ("testSigmoidCrossEntropyLoss", testSigmoidCrossEntropyLoss),
        ("testSigmoidCrossEntropyGrad", testSigmoidCrossEntropyGrad),
    ]
}
