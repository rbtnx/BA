within HeatingCircle_Simple;

model Hydraulic_Pump_fix
  Buildings.Fluid.FixedResistances.FixedResistanceDpM res(redeclare package Medium = Buildings.Media.Water, dp_nominal = 200, from_dp = true, m_flow_nominal = 0.2) annotation(Placement(visible = true, transformation(origin = {142, -28}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM res1(redeclare package Medium = Buildings.Media.Water, dp_nominal = 500, from_dp = true, m_flow_nominal = 0.2, show_T = true) annotation(Placement(visible = true, transformation(origin = {2, -74}, extent = {{10, 10}, {-10, -10}}, rotation = 0)));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM res2(redeclare package Medium = Buildings.Media.Water, dp_nominal = 300, from_dp = true, m_flow_nominal = 0.2) annotation(Placement(visible = true, transformation(origin = {-164, -28}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Buildings.Fluid.Storage.ExpansionVessel exp(redeclare package Medium = Buildings.Media.Water, V_start = 10) annotation(Placement(visible = true, transformation(origin = {30, 68}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  HeatingCircle_Simple.HeatSink_Simple heatSink_Simple1(heat = 20000) annotation(Placement(visible = true, transformation(origin = {46, -74}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Sensors.Temperature temperature(redeclare package Medium = Buildings.Media.Water) annotation(Placement(visible = true, transformation(origin = {120, 74}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sensors.Pressure pressure(redeclare package Medium = Buildings.Media.Water) annotation(Placement(visible = true, transformation(origin = {-116, 68}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.Movers.SpeedControlled_y fan1(redeclare package Medium = Buildings.Media.Water, per.pressure(V_flow={0.0003,0.0006,0.0008},dp={45,35,15}*1000)) annotation(Placement(visible = true, transformation(origin = {-32, 46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Sine sine1(amplitude = 0.5, freqHz = 5 / 86400, offset = 0.5)  annotation(Placement(visible = true, transformation(origin = {-60, 82}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Sine sine2(amplitude = 0.5, freqHz = 10 / 86400, offset = 0.5)  annotation(Placement(visible = true, transformation(origin = {-128, -104}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Sine sine3(amplitude = 0.5, freqHz = 2 / 86400, offset = 0.5)  annotation(Placement(visible = true, transformation(origin = {78, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.Movers.SpeedControlled_y fan(redeclare package Medium = Buildings.Media.Water, per.pressure(V_flow={0.0003,0.0006,0.0008},dp={45,35,15}*1000)) annotation(Placement(visible = true, transformation(origin = {-72, -74}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Buildings.Fluid.Movers.SpeedControlled_y fan2(redeclare package Medium = Buildings.Media.Water, per.pressure(V_flow={0.0003,0.0006,0.0008},dp={45,35,15}*1000)) annotation(Placement(visible = true, transformation(origin = {102, -74}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(sine3.y, fan2.y) annotation(Line(points = {{90, -40}, {102, -40}, {102, -62}, {102, -62}}, color = {0, 0, 127}));
  connect(sine2.y, fan.y) annotation(Line(points = {{-116, -104}, {-72, -104}, {-72, -86}, {-72, -86}}, color = {0, 0, 127}));
  connect(fan2.port_b, res.port_b) annotation(Line(points = {{112, -74}, {142, -74}, {142, -38}, {142, -38}}, color = {0, 127, 255}));
  connect(heatSink_Simple1.port_a, fan2.port_a) annotation(Line(points = {{56, -74}, {92, -74}, {92, -74}, {92, -74}}, color = {0, 127, 255}));
  connect(heatSink_Simple1.port_b, res1.port_a) annotation(Line(points = {{36, -74}, {12, -74}}, color = {0, 127, 255}));
  connect(fan.port_b, res2.port_a) annotation(Line(points = {{-82, -74}, {-164, -74}, {-164, -38}, {-164, -38}}, color = {0, 127, 255}));
  connect(fan.port_a, res1.port_b) annotation(Line(points = {{-62, -74}, {-8, -74}, {-8, -74}, {-8, -74}}, color = {0, 127, 255}));
  connect(sine1.y, fan1.y) annotation(Line(points = {{-48, 82}, {-32, 82}, {-32, 58}, {-32, 58}}, color = {0, 0, 127}));
  connect(fan1.port_a, res2.port_b) annotation(Line(points = {{-42, 46}, {-164, 46}, {-164, -18}, {-164, -18}, {-164, -18}}, color = {0, 127, 255}));
  connect(fan1.port_b, exp.port_a) annotation(Line(points = {{-22, 46}, {30, 46}, {30, 58}, {30, 58}, {30, 58}}, color = {0, 127, 255}));
  connect(temperature.port, res.port_a) annotation(Line(points = {{120, 64}, {120, 64}, {120, 46}, {142, 46}, {142, -18}, {142, -18}}, color = {0, 127, 255}));
  connect(pressure.port, res2.port_b) annotation(Line(points = {{-116, 58}, {-116, 58}, {-116, 46}, {-164, 46}, {-164, -18}, {-164, -18}, {-164, -18}}, color = {0, 127, 255}));
  connect(res.port_a, exp.port_a) annotation(Line(points = {{142, -18}, {142, -18}, {142, 46}, {30, 46}, {30, 58}, {30, 58}}, color = {0, 127, 255}));
  annotation(uses(Buildings(version = "2.1.0"), Modelica(version = "3.2.1")), Diagram(coordinateSystem(extent = {{-200, -200}, {200, 200}})), version = "", experiment(StartTime = 0, StopTime = 86400, Tolerance = 1e-06, Interval = 60));
end Hydraulic_Pump_fix;