model Sink_Simple
  extends HeatingCircle_Simple;
  parameter Real heat = 1000;
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow preHeat annotation(Placement(visible = true, transformation(origin = {-32, 68}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = heat) annotation(Placement(visible = true, transformation(origin = {-68, 68}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.MixingVolumes.MixingVolume vol(redeclare package Medium = Buildings.Media.Water, V = 10, m_flow_nominal = 1, nPorts = 2) annotation(Placement(visible = true, transformation(origin = {4, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Buildings.Media.Water) annotation(Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Buildings.Media.Water) annotation(Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-98, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.Movers.FlowControlled_m_flow fan(redeclare package Medium = Buildings.Media.Water, m_flow_nominal = 1) annotation(Placement(visible = true, transformation(origin = {-48, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = 10)  annotation(Placement(visible = true, transformation(origin = {-66, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(const1.y, fan.m_flow_in) annotation(Line(points = {{-54, 32}, {-48, 32}, {-48, 12}, {-48, 12}}, color = {0, 0, 127}));
  connect(fan.port_b, vol.ports[1]) annotation(Line(points = {{-38, 0}, {4, 0}, {4, 46}}, color = {0, 127, 255}));
  connect(preHeat.port, vol.heatPort) annotation(Line(points = {{-22, 68}, {-14, 68}, {-14, 56}, {-6, 56}}, color = {191, 0, 0}));
  connect(port_b, vol.ports[2]) annotation(Line(points = {{100, 0}, {4, 0}, {4, 46}}));
  connect(const.y, preHeat.Q_flow) annotation(Line(points = {{-57, 68}, {-42, 68}}, color = {0, 0, 127}));
  connect(port_a, fan.port_a) annotation(Line(points = {{-100, 0}, {-58, 0}, {-58, 0}, {-58, 0}}));
  annotation(uses(Buildings(version = "2.1.0"), Modelica(version = "3.2.1")));
end Sink_Simple;