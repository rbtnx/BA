within HeatingCircle_Simple;

model HeatSink_Simple

  parameter Real heat = 1000 "Heat input/output";
  
  Buildings.Fluid.MixingVolumes.MixingVolume vol(redeclare package Medium = Buildings.Media.Water, V = 1, nPorts = 2) annotation(Placement(visible = true, transformation(origin = {20, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Buildings.Media.Water) annotation(Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Buildings.Media.Water) annotation(Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow preHeat annotation(Placement(visible = true, transformation(origin = {-30, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sensors.MassFlowRate massFlowRate1(redeclare package Medium = Buildings.Media.Water) annotation(Placement(visible = true, transformation(origin = {-38, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Sine sine1(amplitude = heat, freqHz = 2 / 86400)  annotation(Placement(visible = true, transformation(origin = {-74, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(sine1.y, preHeat.Q_flow) annotation(Line(points = {{-62, 44}, {-40, 44}, {-40, 44}, {-40, 44}}, color = {0, 0, 127}));
  connect(massFlowRate1.port_b, vol.ports[1]) annotation(Line(points = {{-28, 0}, {20, 0}, {20, 0}, {20, 0}}, color = {0, 127, 255}));
  connect(port_a, massFlowRate1.port_a) annotation(Line(points = {{-100, 0}, {-48, 0}, {-48, 0}, {-48, 0}}));
  connect(preHeat.port, vol.heatPort) annotation(Line(points = {{-20, 44}, {-6, 44}, {-6, 10}, {10, 10}, {10, 10}}, color = {191, 0, 0}));
  connect(port_b, vol.ports[2]) annotation(Line(points = {{100, 0}, {20, 0}}));
  annotation(uses(Buildings(version = "2.1.0"), Modelica(version = "3.2.1")));
end HeatSink_Simple;