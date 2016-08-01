within HeatingCircle_Simple;

model SplitterTest
  Buildings.Fluid.Sources.FixedBoundary bou(redeclare package Medium = Buildings.Media.Water, nPorts = 1)  annotation(Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.Sources.FixedBoundary bou1(redeclare package Medium = Buildings.Media.Water, nPorts = 1)  annotation(Placement(visible = true, transformation(origin = {58, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Buildings.Fluid.Sources.FixedBoundary bou2(redeclare package Medium = Buildings.Media.Water, nPorts = 1)  annotation(Placement(visible = true, transformation(origin = {0, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Buildings.Fluid.Movers.SpeedControlled_y fan(redeclare package Medium = Buildings.Media.Water, per.pressure(V_flow = {0.0003, 0.0006, 0.0008}, dp = {45, 35, 15} * 1000)) annotation(Placement(visible = true, transformation(origin = {-38, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Sine sine1(amplitude = 0.5, freqHz = 10, offset = 0.5)  annotation(Placement(visible = true, transformation(origin = {-82, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM spl(redeclare package Medium = Buildings.Media.Water, dp_nominal = {500, 200, -200}, m_flow_nominal = {0.2, 0.2, -0.2})  annotation(Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(spl.port_2, bou1.ports[1]) annotation(Line(points = {{10, 0}, {48, 0}, {48, 0}, {48, 0}}, color = {0, 127, 255}));
  connect(spl.port_3, bou2.ports[1]) annotation(Line(points = {{0, -10}, {0, -10}, {0, -40}, {0, -40}}, color = {0, 127, 255}));
  connect(fan.port_b, spl.port_1) annotation(Line(points = {{-28, 0}, {-8, 0}, {-8, 0}, {-10, 0}, {-10, 0}}, color = {0, 127, 255}));
  connect(sine1.y, fan.y) annotation(Line(points = {{-70, 42}, {-38, 42}, {-38, 12}, {-38, 12}}, color = {0, 0, 127}));
  connect(fan.port_b, bou.ports[1]) annotation(Line(points = {{-28, 0}, {-60, 0}, {-60, 0}, {-60, 0}}, color = {0, 127, 255}));
  annotation(uses(Buildings(version = "2.1.0"), Modelica(version = "3.2.1")));
end SplitterTest;