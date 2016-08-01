model ConnectionTest
  extends HeatingCircle_Simple;
  Buildings.Fluid.Sources.FixedBoundary bou(redeclare package Medium = Buildings.Media.Water, nPorts = 1) annotation(Placement(visible = true, transformation(origin = {-90, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Sink_Simple sink_Simple1 annotation(Placement(visible = true, transformation(origin = {-52, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.Sources.FixedBoundary bou1(redeclare package Medium = Buildings.Media.Water, nPorts = 1) annotation(Placement(visible = true, transformation(origin = {60, 12}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Sink_Simple sink_Simple2 annotation(Placement(visible = true, transformation(origin = {16, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM res(redeclare package Medium = Buildings.Media.Water, allowFlowReversal = false, dp_nominal = 20, m_flow_nominal = 10)  annotation(Placement(visible = true, transformation(origin = {-20, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(res.port_b, sink_Simple2.port_a) annotation(Line(points = {{-10, 12}, {6, 12}, {6, 12}, {6, 12}}, color = {0, 127, 255}));
  connect(sink_Simple1.port_b, res.port_a) annotation(Line(points = {{-42, 12}, {-30, 12}, {-30, 12}, {-30, 12}}, color = {0, 127, 255}));
  connect(bou.ports[1], sink_Simple1.port_a) annotation(Line(points = {{-80, 12}, {-62, 12}}, color = {0, 127, 255}));
  connect(sink_Simple2.port_b, bou1.ports[1]) annotation(Line(points = {{26, 12}, {50, 12}, {50, 12}, {50, 12}}, color = {0, 127, 255}));
  annotation(uses(Buildings(version = "2.1.0")));
end ConnectionTest;