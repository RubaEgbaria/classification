import 'dart:math';

double calculateZ(double x1, double x2, List<double> weights, int threshold) {
  return x1 * weights[0] + x2 * weights[1] + threshold;
}

int stepFunction(double z) {
  return z >= 0 ? 1 : 0;
}

// equation
String getEquation(List<double> weights, int threshold) {
  if (weights[1] == 0) {
    return "Vertical line at x = ${-threshold / weights[0]}";
  } else {
    final slope = -weights[0] / weights[1];
    final yIntercept = -threshold / weights[1];
    final sign = yIntercept < 0 ? "-" : "+";
    return "y = ${slope.toStringAsFixed(2)} * x $sign ${yIntercept.abs().toStringAsFixed(2)}";
  }
}

// Confusion matrix
Map<String, int> confusionMatrix(List<int> yDesired, List<int> yPredicted) {
  int truePositive = 0, trueNegative = 0, falsePositive = 0, falseNegative = 0;

  for (int i = 0; i < yDesired.length; i++) {
    if (yDesired[i] == 1) {
      if (yPredicted[i] == 1) {
        truePositive++;
      } else {
        falseNegative++;
      }
    } else {
      if (yPredicted[i] == 0) {
        trueNegative++;
      } else {
        falsePositive++;
      }
    }
  }

  return {
    "True Positive": truePositive,
    "True Negative": trueNegative,
    "False Positive": falsePositive,
    "False Negative": falseNegative,
  };
}

double calculateSSE(List<int> yDesired, List<int> yActual) {
  return yDesired
      .asMap()
      .map((i, val) => MapEntry(i, pow(val - yActual[i], 2)))
      .values
      .reduce((a, b) => a + b)
      .toDouble();
}

List<double> logisticRegression(List<double> x1, List<double> x2,
    List<int> yDesired, double learningRate, int maxIterations, int threshold) {
  List<double> weights = [0.1, 0.1];

  for (int j = 0; j < maxIterations; j++) {
    for (int i = 0; i < x1.length; i++) {
      final z = calculateZ(x1[i], x2[i], weights, threshold);
      final yPred = stepFunction(z);

      final error = yDesired[i] - yPred;

      if (error != 0) {
        weights[0] += learningRate * error * x1[i];
        weights[1] += learningRate * error * x2[i];
      }
    }
  }

  return weights;
}

int predictClass(double x1, double x2, List<double> weights, int threshold) {
  final z = calculateZ(x1, x2, weights, threshold);
  return stepFunction(z);
}

Map<String, dynamic> testBinaryClassification(List<double> x1, List<double> x2,
    List<int> yDesired, int maxIterations, double learningRate) {
  int threshold = 1;

  Map<String, dynamic> results = {};

  // Train
  final weights = logisticRegression(
      x1, x2, yDesired, learningRate, maxIterations, threshold);

  List<int> yPred = [];
  for (int i = 0; i < x1.length; i++) {
    final z = calculateZ(x1[i], x2[i], weights, threshold);
    yPred.add(stepFunction(z));
  }

  final equation = getEquation(weights, threshold);

  // Calculate confusion matrix and SSE
  final confusion = confusionMatrix(yDesired, yPred);

  // SSE
  final sse = calculateSSE(yDesired, yPred);

  // accuracy
  final accuracy = (confusion["True Positive"]! + confusion["True Negative"]!) /
      yDesired.length;

  results["equation"] = equation;
  results["confusionMatrix"] = confusion;
  results["sse"] = sse;
  results["accuracy"] = accuracy;

  return results;
}
