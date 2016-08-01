within HeatingCircle_Simple;

model Hydraulic
  Buildings.Fluid.Movers.FlowControlled_dp fan(redeclare package Medium = Buildings.Media.Water, m_flow_nominal = 0.2) annotation(Placement(visible = true, transformation(origin = {-8, 46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM res(redeclare package Medium = Buildings.Media.Water, dp_nominal = 200, from_dp = true, m_flow_nominal = 0.2) annotation(Placement(visible = true, transformation(origin = {142, -28}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant const(k = 10000) annotation(Placement(visible = true, transformation(origin = {-40, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM res1(redeclare package Medium = Buildings.Media.Water, dp_nominal = 500, from_dp = true, m_flow_nominal = 0.2, show_T = true) annotation(Placement(visible = true, transformation(origin = {2, -74}, extent = {{10, 10}, {-10, -10}}, rotation = 0)));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM res2(redeclare package Medium = Buildings.Media.Water, dp_nominal = 300, from_dp = true, m_flow_nominal = 0.2) annotation(Placement(visible = true, transformation(origin = {-164, -28}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Buildings.Fluid.Storage.ExpansionVessel exp(redeclare package Medium = Buildings.Media.Water, V_start = 10) annotation(Placement(visible = true, transformation(origin = {30, 68}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  HeatSink_Simple heatSink_Simple1(heat = 20000) annotation(Placement(visible = true, transformation(origin = {92, -74}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Sensors.Temperature temperature(redeclare package Medium = Buildings.Media.Water) annotation(Placement(visible = true, transformation(origin = {120, 74}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sensors.Pressure pressure(redeclare package Medium = Buildings.Media.Water) annotation(Placement(visible = true, transformation(origin = {-116, 68}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(temperature.port, res.port_a) annotation(Line(points = {{120, 64}, {120, 64}, {120, 46}, {142, 46}, {142, -18}, {142, -18}}, color = {0, 127, 255}));
  connect(pressure.port, res2.port_b) annotation(Line(points = {{-116, 58}, {-116, 58}, {-116, 46}, {-164, 46}, {-164, -18}, {-164, -18}, {-164, -18}}, color = {0, 127, 255}));
  connect(heatSink_Simple1.port_b, res1.port_a) annotation(Line(points = {{82, -74}, {12, -74}, {12, -74}, {12, -74}}, color = {0, 127, 255}));
  connect(res.port_b, heatSink_Simple1.port_a) annotation(Line(points = {{142, -38}, {142, -38}, {142, -74}, {102, -74}, {102, -74}}, color = {0, 127, 255}));
  connect(res.port_a, exp.port_a) annotation(Line(points = {{142, -18}, {142, -18}, {142, 46}, {30, 46}, {30, 58}, {30, 58}}, color = {0, 127, 255}));
  connect(res2.port_b, fan.port_a) annotation(Line(points = {{-164, -18}, {-164, -18}, {-164, 46}, {-18, 46}, {-18, 46}}, color = {0, 127, 255}));
  connect(res1.port_b, res2.port_a) annotation(Line(points = {{-8, -74}, {-164, -74}, {-164, -38}}, color = {0, 127, 255}));
  connect(fan.port_b, exp.port_a) annotation(Line(points = {{2, 46}, {30, 46}, {30, 58}, {30, 58}}, color = {0, 127, 255}));
  connect(const.y, fan.dp_in) annotation(Line(points = {{-28, 80}, {-8, 80}, {-8, 58}, {-8, 58}}, color = {0, 0, 127}));
  annotation(uses(Buildings(version = "2.1.0"), Modelica(version = "3.2.1")), Diagram(coordinateSystem(extent = {{-200, -200}, {200, 200}})), version = "", experiment(StartTime = 0, StopTime = 86400, Tolerance = 1e-06, Interval = 60));
end Hydraulic;