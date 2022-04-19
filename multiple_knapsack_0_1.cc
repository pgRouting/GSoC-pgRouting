// Solve a multiple knapsack problem using a MIP solver.
#include <iostream>
#include <numeric>
#include <vector>

#include "absl/strings/str_format.h"
#include "ortools/linear_solver/linear_expr.h"
#include "ortools/linear_solver/linear_solver.h"

namespace operations_research {

void MultipleKnapsackMip() {
  const std::vector<int> weights = {
      {48, 30, 42, 36, 36, 48, 42}};
  const std::vector<int> values = {
      {10, 30, 25, 50, 35, 30, 15}};
  const int num_items = weights.size();
  std::vector<int> all_items(num_items);
  std::iota(all_items.begin(), all_items.end(), 0);

  const std::vector<int> bin_capacities = {{100, 35, 65}};
  const int num_bins = bin_capacities.size();
  std::vector<int> all_bins(num_bins);
  std::iota(all_bins.begin(), all_bins.end(), 0);

  // Create the mip solver with the SCIP backend.
  std::unique_ptr<MPSolver> solver(MPSolver::CreateSolver("SCIP"));
  if (!solver) {
    LOG(WARNING) << "SCIP solver unavailable.";
    return;
  }

  // Variables.
  // x[i][b] = 1 if item i is packed in bin b.
  std::vector<std::vector<const MPVariable*>> x(
      num_items, std::vector<const MPVariable*>(num_bins));
  for (int i : all_items) {
    for (int b : all_bins) {
      x[i][b] = solver->MakeBoolVar(absl::StrFormat("x_%d_%d", i, b));
    }
  }

  // Constraints.
  // Each item is assigned to at most one bin.
  for (int i : all_items) {
    LinearExpr sum;
    for (int b : all_bins) {
      sum += x[i][b];
    }
    solver->MakeRowConstraint(sum <= 1.0);
  }
  // The amount packed in each bin cannot exceed its capacity.
  for (int b : all_bins) {
    LinearExpr bin_weight;
    for (int i : all_items) {
      bin_weight += LinearExpr(x[i][b]) * weights[i];
    }
    solver->MakeRowConstraint(bin_weight <= bin_capacities[b]);
  }

  // Objective.
  // Maximize total value of packed items.
  MPObjective* const objective = solver->MutableObjective();
  LinearExpr objective_value;
  for (int i : all_items) {
    for (int b : all_bins) {
      objective_value += LinearExpr(x[i][b]) * values[i];
    }
  }
  objective->MaximizeLinearExpr(objective_value);

  const MPSolver::ResultStatus result_status = solver->Solve();

  if (result_status == MPSolver::OPTIMAL) {
    LOG(INFO) << "Total packed value: " << objective->Value();
    double total_weight = 0.0;
    for (int b : all_bins) {
      LOG(INFO) << "Bin " << b;
      double bin_weight = 0.0;
      double bin_value = 0.0;
      for (int i : all_items) {
        if (x[i][b]->solution_value() > 0) {
          LOG(INFO) << "Item " << i << " weight: " << weights[i]
                    << " value: " << values[i];
          bin_weight += weights[i];
          bin_value += values[i];
        }
      }
      LOG(INFO) << "Packed bin weight: " << bin_weight;
      LOG(INFO) << "Packed bin value: " << bin_value;
      total_weight += bin_weight;
    }
    LOG(INFO) << "Total packed weight: " << total_weight;
  } else {
    LOG(INFO) << "The problem does not have an optimal solution.";
  }
}
}  // namespace operations_research

int main(int argc, char** argv) {
  operations_research::MultipleKnapsackMip();
  return EXIT_SUCCESS;
}