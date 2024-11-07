import 'dart:math';

double calculateZ(double x1, double x2, List<double> weights, int threshold) {
  return x1 * weights[0] + x2 * weights[1] + threshold;
}

int stepFunction(double z) {
  // tanh
  // return (1 / (1 + exp(-z))) > 0.5 ? 1 : 0;
  // sigmoid
  // return (1 / (1 + exp(-z))) > 0.5 ? 1 : 0;
  // ReLU
  // return z >= 0 ? 1 : 0;
  // softmax
  // return z >= 0 ? 1 : 0;
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
    return "y = ${slope.toStringAsFixed(2)} * x $sign ${yIntercept.toStringAsFixed(2)}";
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

List<Map<String, dynamic>> testMultiClassification(
    List<double> x1,
    List<double> x2,
    List<int> yDesired,
    int maxIterations,
    double learningRate) {
  int threshold = 1;

  List<Map<String, dynamic>> results =
      List.generate(yDesired.toSet().length + 1, (index) => {});
  List<int> tempYDesired = [];

  List<int> finalYPred = List<int>.filled(x1.length, -1);
  final length = yDesired.toSet().length;

  for (int c = 0; c < length; c++) {
    // 3 or 4 num of classes more is fine as well.
    if (c != 0) {
      tempYDesired = yDesired.map((e) => e == c ? 1 : 0).toList();
    } else {
      tempYDesired = yDesired.map((e) => e == c ? 0 : 1).toList();
    }

    // Train
    final weights = logisticRegression(
        x1, x2, tempYDesired, learningRate, maxIterations, threshold);

    List<int> binaryYPed = List<int>.filled(x1.length, -1);
    for (int i = 0; i < x1.length; i++) {
      final z = calculateZ(x1[i], x2[i], weights, threshold);

      final localYPred = stepFunction(z);

      binaryYPed[i] = localYPred;

      if (i == 0 && c == 0) {
        finalYPred = binaryYPed;
      } else if (c != 0) {
        finalYPred[i] = localYPred == 1 ? c : finalYPred[i];
      }
    }

    final equation = getEquation(weights, threshold);

    // Calculate confusion matrix and SSE
    final confusion = confusionMatrix(tempYDesired, binaryYPed);

    // SSE
    final sse = calculateSSE(tempYDesired, binaryYPed);

    // accuracy
    final accuracy =
        (confusion["True Positive"]! + confusion["True Negative"]!) /
            tempYDesired.length;

    results[c]["equation"] = equation;
    results[c]["confusionMatrix"] = confusion;
    results[c]["sse"] = sse;
    results[c]["accuracy"] = accuracy;
    results[c]["yPred"] = binaryYPed;
  }
  results[length]["yPred"] = finalYPred;
  results[length]["yDesired"] = yDesired;
  results[length]["equation"] = results
      .map((e) => e["equation"])
      .where((e) => e != null)
      .toList()
      .join("\n");
  results[length]["sse"] = calculateSSE(yDesired, finalYPred);
  results[length]["confusionMatrix"] = confusionMatrix(yDesired, finalYPred);
  results[length]["accuracy"] = (results[length]["confusionMatrix"]
              ["True Positive"]! +
          results[length]["confusionMatrix"]["True Negative"]!) /
      yDesired.length;

  return results;
}

// allow user to add test data
// check what is wrong with the 4th class