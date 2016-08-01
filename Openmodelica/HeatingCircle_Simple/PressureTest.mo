within HeatingCircle_Simple;

model PressureTest
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow1 annotation(Placement(visible = true, transformation(origin = {-28, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 100) annotation(Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Vessels.ClosedVolume volume(redeclare package Medium = Buildings.Media.Water, V = 1, nPorts = 1) annotation(Placement(visible = true, transformation(origin = {16, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.Sources.FixedBoundary bou(redeclare package Medium = Buildings.Media.Water, nPorts = 1)  annotation(Placement(visible = true, transformation(origin = {16, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
equation
  connect(bou.ports[1], volume.ports[1]) annotation(Line(points = {{16, -16}, {16, -16}, {16, -2}, {16, -2}}, color = {0, 127, 255}));
  connect(volume.heatPort, prescribedHeatFlow1.port) annotation(Line(points = {{6, 8}, {-6, 8}, {-6, -2}, {-18, -2}, {-18, -2}}, color = {191, 0, 0}));
  connect(const.y, prescribedHeatFlow1.Q_flow) annotation(Line(points = {{-58, 0}, {-38, 0}, {-38, -2}, {-38, -2}}, color = {0, 0, 127}));
  annotation(uses(Buildings(version = "2.1.0"), Modelica(version = "3.2.1")));
end PressureTest;