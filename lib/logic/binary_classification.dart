import 'dart:math';

double calculateZ(double x1, double x2, List<double> weights, int threshold) {
  return x1 * weights[0] + x2 * weights[1] + threshold;
}

double sigmoid(double z) {
  return 1 / (1 + exp(-z));
}

double calculateError(double yDesired, double yActual) {
  return yDesired - yActual;
}

List<double> updateWeights(double error, double x1, double x2,
    List<double> weights, double learningRate) {
  return [
    weights[0] + learningRate * error * x1,
    weights[1] + learningRate * error * x2
  ];
}

String getDecisionBoundaryEquation(List<double> weights, int threshold) {
  if (weights.length != 2) {
    return "Invalid number of weights";
  }
  final slope = -weights[0] / weights[1];
  final yIntercept = -threshold / weights[1];

  final isNegative = yIntercept < 0;
  final sign = isNegative ? "-" : "+";

// 2.0 * X + 3.0
  return "${slope.toStringAsFixed(2)} * X $sign ${(yIntercept).abs().toStringAsFixed(2)}";
}

String testSampleData() {
  final x1 = [0.1, 0.2, 0.3, 0.4]; // input
  final x2 = [0.2, 0.3, 0.4, 0.5]; // input
  final List<double> yDesired = [0.2, 1.2, 0.1, 1.2]; // input

  final weights = [0.1, 0.2]; // radnomly initialized
  const threshold = 1; // radnomly initialized

  const maxNumberOfIterations = 3; // input
  const learningRate = 0.1; // input

  // double accuracy = 0; // output
  // double performance = 0; // output

  List<List<double>> updatedWeights =
      List.filled(x1.length, List.filled(x1.length, 0.0)); // output

  for (int i = 0; i < maxNumberOfIterations; i++) {
    print("Iteration: $i");
    print("X1: ${x1[i]} X2: ${x2[i]}");
    final yActual = sigmoid(calculateZ(x1[i], x2[i], weights, threshold));
    print("yActual: $yActual");

    final error = calculateError(yDesired[i], yActual);
    print("Error: $error");

    if (error != 0) {
      updatedWeights[i] =
          updateWeights(error, x1[i], x2[i], weights, learningRate);
      print("Updated weights: ");
      print(updatedWeights[i]);
    }

    final equation = getDecisionBoundaryEquation(weights, threshold);
    print("Decision Boundary Equation: $equation");
  }
  return getDecisionBoundaryEquation(weights, threshold);
}
