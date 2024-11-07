import 'dart:math';

List<double> weights = [0.1, 0.1];
List<List<double>> classWeights = [];
const threshold = 1;

double calculateZ(double x1, double x2, {List<double>? w}) {
  if (w != null) {
    return x1 * w[0] + x2 * w[1] + threshold;
  }
  return x1 * weights[0] + x2 * weights[1] + threshold;
}

int stepFunction(double z) {
  return z >= 0 ? 1 : 0;
}

// equation
String getEquation() {
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
  // Sum of Squared Errors = Σ(yDesired - yActual)^2
  return yDesired
      .asMap()
      .map((i, val) => MapEntry(i, pow(val - yActual[i], 2)))
      .values
      .reduce((a, b) => a + b)
      .toDouble();
}

List<double> logisticRegression(List<double> x1, List<double> x2,
    List<int>? yDesired, double learningRate, int maxIterations) {
  for (int j = 0; j < maxIterations; j++) {
    for (int i = 0; i < x1.length; i++) {
      final z = calculateZ(x1[i], x2[i], w: weights);
      final yPred = stepFunction(z);

      final error = yDesired == null ? 0 : yDesired[i] - yPred;

      if (error != 0) {
        weights[0] += learningRate * error * x1[i];
        weights[1] += learningRate * error * x2[i];
      }
    }
  }

  return weights;
}

Map<String, dynamic> trainBinaryClassification(List<double> x1, List<double> x2,
    List<int> yDesired, int maxIterations, double learningRate) {
  Map<String, dynamic> results = {};

  // Train
  weights = logisticRegression(x1, x2, yDesired, learningRate, maxIterations);

  List<int> yPred = [];
  for (int i = 0; i < x1.length; i++) {
    final z = calculateZ(x1[i], x2[i], w: weights);
    yPred.add(stepFunction(z));
  }

  final equation = getEquation();

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

List<Map<String, dynamic>> trainMultiClassification(
    List<double> x1,
    List<double> x2,
    List<int> yDesired,
    int maxIterations,
    double learningRate) {
  List<Map<String, dynamic>> results =
      List.generate(yDesired.toSet().length + 1, (index) => {});
  List<int> tempYDesired = [];

  List<int> finalYPred = List<int>.filled(x1.length, -1);
  final length = yDesired.toSet().length;
  classWeights = List.generate(yDesired.toSet().length, (_) => [0.0, 0.0]);

  for (int c = 0; c < length; c++) {
    // 3 or 4 num of classes more is fine as well.
    if (c != 0) {
      tempYDesired = yDesired.map((e) => e == c ? 1 : 0).toList();
    } else {
      tempYDesired = yDesired.map((e) => e == c ? 0 : 1).toList();
    }

    // Train
    final currentWeight =
        logisticRegression(x1, x2, tempYDesired, learningRate, maxIterations);

    weights = currentWeight;

    classWeights[c][0] = currentWeight[0];
    classWeights[c][1] = currentWeight[1];

    List<int> binaryYPed = List<int>.filled(x1.length, -1);
    for (int i = 0; i < x1.length; i++) {
      final z = calculateZ(x1[i], x2[i]);

      final localYPred = stepFunction(z);

      binaryYPed[i] = localYPred;

      if (i == 0 && c == 0) {
        // save the zero
        // as zero is the first class
        finalYPred = binaryYPed.map((e) => e == 1 ? c : e).toList();
      } else if (c != 0) {
        finalYPred[i] = localYPred == 1 ? c : finalYPred[i];
      }
    }

    final equation = getEquation();

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

// Prediction
int predictClass(double x1, double x2, {List<double>? w}) {
  final z = calculateZ(x1, x2, w: w);
  return stepFunction(z);
}

List<int> predictClassBinary(List<double> x1, List<double> x2, List<double> w) {
  List<int> resultClass = List.filled(x1.length, -1);

  for (int i = 0; i < x1.length; i++) {
    resultClass[i] = predictClass(x1[i], x2[i], w: w);
  }

  return resultClass;
}

List<int> predictMultiClassData(List<double> x1, List<double> x2) {
  final classNum = classWeights.length;
  List<int> resultClass = List.filled(x1.length, -1);
  List<int> tempResult = List.filled(x1.length, -1);
  for (int c = 0; c < classNum; c++) {
    tempResult = predictClassBinary(x1, x2, classWeights[c]);

    if (c == 0) {
      resultClass = tempResult;
    }

    for (int i = 0; i < x1.length; i++) {
      if (tempResult[i] == 1) {
        resultClass[i] = c;
      }
    }
  }

  return resultClass;
}
