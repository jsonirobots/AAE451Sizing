% Function that computes climb fuel weight fraction

function output = ClimbFunction(inputs)
% Historical climb fuel weight fraction (Raymer Ch.6, Equation 6.8)
  M         = inputs.PerformanceInputs.M;

  output.f_cl = 1.0065-0.0325*M;
end
