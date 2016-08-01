within HeatingCircle_Simple;

model Heizkreis3_Widerstand

  parameter Integer varRes = 9999999;

  Buildings.Fluid.Movers.SpeedControlled_y ErzeugerPumpe(redeclare package Medium = Buildings.Media.Water, per.pressure(V_flow = {0.0003, 0.0006, 0.0008}, dp = {45, 35, 15} * 1000)) annotation(Placement(visible = true, transformation(origin = {0, 162}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM WidPrimVor(redeclare package Medium = Buildings.Media.Water, dp_nominal = 1500, m_flow_nominal = 0.2) annotation(Placement(visible = true, transformation(origin = {172, -22}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM WidPrimRueck(redeclare package Medium = Buildings.Media.Water, dp_nominal = 1500, m_flow_nominal = 0.2) annotation(Placement(visible = true, transformation(origin = {138, -22}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM spl(redeclare package Medium = Buildings.Media.Water, dp_nominal = {200, -200, 200}, m_flow_nominal = {0.2, -0.2, -0.2}) annotation(Placement(visible = true, transformation(origin = {10, 106}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM spl1(redeclare package Medium = Buildings.Media.Water, dp_nominal = {1, -1, -1} * 200, m_flow_nominal = {0.2, -0.2, -0.2}) annotation(Placement(visible = true, transformation(origin = {-10, 86}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Buildings.Fluid.Movers.SpeedControlled_y fan1(redeclare package Medium = Buildings.Media.Water, per.pressure(V_flow = {0.0003, 0.0006, 0.0008}, dp = {45, 35, 15} * 1000)) annotation(Placement(visible = true, transformation(origin = {-118, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
Modelica.Blocks.Sources.Constant const(k = 0.3) annotation(Placement(visible = true, transformation(origin = {-164, 96}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
Buildings.Fluid.Sources.Boundary_pT bou(redeclare package Medium = Buildings.Media.Water, nPorts = 2, p = 200000) annotation(Placement(visible = true, transformation(origin = {-42, 116}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM spl2(redeclare package Medium = Buildings.Media.Water, dp_nominal = {1, -1, 1} * 200, m_flow_nominal = {0.2, -0.2, 0.2}) annotation(Placement(visible = true, transformation(origin = {90, -76}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM spl3(redeclare package Medium = Buildings.Media.Water, dp_nominal = {1, -1, -1} * 200, m_flow_nominal = {0.2, -0.2, -0.2}) annotation(Placement(visible = true, transformation(origin = {120, -98}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
Buildings.Fluid.Movers.SpeedControlled_y VerbraucherPumpe1(redeclare package Medium = Buildings.Media.Water, per.pressure(V_flow = {0.0003, 0.0006, 0.0008}, dp = {45, 35, 15} * 1000)) annotation(Placement(visible = true, transformation(origin = {100, -196}, extent = {{10, 10}, {-10, -10}}, rotation = 0)));
  Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM spl4(redeclare package Medium = Buildings.Media.Water, dp_nominal = {1, -1, 1} * 200, m_flow_nominal = {0.2, -0.2, 0.2}) annotation(Placement(visible = true, transformation(origin = {-22, -76}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM spl5(redeclare package Medium = Buildings.Media.Water, dp_nominal = {1, -1, -1} * 200, m_flow_nominal = {0.2, -0.2, -0.2}) annotation(Placement(visible = true, transformation(origin = {4, -98}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM res1Rueck(redeclare package Medium = Buildings.Media.Water, dp_nominal = 750, m_flow_nominal = 0.2) annotation(Placement(visible = true, transformation(origin = {40, -76}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM res1Vor(redeclare package Medium = Buildings.Media.Water, dp_nominal = 750, m_flow_nominal = 0.2) annotation(Placement(visible = true, transformation(origin = {40, -98}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
Buildings.Fluid.Movers.SpeedControlled_y VerbraucherPumpe2(redeclare package Medium = Buildings.Media.Water, per.pressure(V_flow = {0.0003, 0.0006, 0.0008}, dp = {45, 35, 15} * 1000)) annotation(Placement(visible = true, transformation(origin = {-10, -198}, extent = {{10, 10}, {-10, -10}}, rotation = 0)));
Modelica.Blocks.Sources.Step step1(startTime = 60000) annotation(Placement(visible = true, transformation(origin = {-66, -224}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM res2Vor(redeclare package Medium = Buildings.Media.Water, dp_nominal = 500, m_flow_nominal = 0.2) annotation(Placement(visible = true, transformation(origin = {-98, -98}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step2(startTime = 1000) annotation(Placement(visible = true, transformation(origin = {-44, 182}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
Modelica.Blocks.Sources.Step step3(startTime = 40000) annotation(Placement(visible = true, transformation(origin = {74, -228}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.Sources.Boundary_pT bou1(redeclare package Medium = Buildings.Media.Water, nPorts = 2, p = 200000) annotation(Placement(visible = true, transformation(origin = {-40, 76}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
Buildings.Fluid.Movers.SpeedControlled_y fan(redeclare package Medium = Buildings.Media.Water, per.pressure(V_flow = {0.0003, 0.0006, 0.0008}, dp = {45, 35, 15} * 1000)) annotation(Placement(visible = true, transformation(origin = {-82, 70}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM res(redeclare package Medium = Buildings.Media.Water, dp_nominal = varRes, m_flow_nominal = 0.2)  annotation(Placement(visible = true, transformation(origin = {-10, 124}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM res1(redeclare package Medium = Buildings.Media.Water, dp_nominal = varRes, m_flow_nominal = 0.2) annotation(Placement(visible = true, transformation(origin = {10, 134}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

algorithm

equation
  
  connect(VerbraucherPumpe1.port_a, spl3.port_3) annotation(Line(points = {{110, -196}, {120, -196}, {120, -108}, {120, -108}}, color = {0, 127, 255}));
  connect(VerbraucherPumpe1.port_b, spl2.port_3) annotation(Line(points = {{90, -196}, {90, -196}, {90, -86}, {90, -86}}, color = {0, 127, 255}));
  connect(VerbraucherPumpe2.port_b, spl4.port_3) annotation(Line(points = {{-20, -198}, {-22, -198}, {-22, -86}, {-22, -86}}, color = {0, 127, 255}));
  connect(VerbraucherPumpe2.port_a, spl5.port_3) annotation(Line(points = {{0, -198}, {4, -198}, {4, -108}, {4, -108}}, color = {0, 127, 255}));
  connect(res1.port_a, ErzeugerPumpe.port_b) annotation(Line(points = {{10, 144}, {10, 144}, {10, 162}, {10, 162}}, color = {0, 127, 255}));
  connect(spl.port_3, res1.port_b) annotation(Line(points = {{10, 116}, {10, 116}, {10, 124}, {10, 124}}, color = {0, 127, 255}));
  connect(res.port_b, ErzeugerPumpe.port_a) annotation(Line(points = {{-10, 134}, {-10, 134}, {-10, 162}, {-10, 162}}, color = {0, 127, 255}));
  connect(spl1.port_3, res.port_a) annotation(Line(points = {{-10, 96}, {-10, 96}, {-10, 114}, {-10, 114}}, color = {0, 127, 255}));
  connect(WidPrimVor.port_b, spl3.port_1) annotation(Line(points = {{172, -32}, {172, -32}, {172, -98}, {130, -98}, {130, -98}}, color = {0, 127, 255}));
  connect(WidPrimRueck.port_b, spl2.port_1) annotation(Line(points = {{138, -32}, {138, -32}, {138, -76}, {100, -76}, {100, -76}}, color = {0, 127, 255}));
  connect(fan.port_a, bou1.ports[2]) annotation(Line(points = {{-82, 80}, {-82, 80}, {-82, 86}, {-40, 86}, {-40, 86}}, color = {0, 127, 255}));
  connect(spl1.port_1, bou1.ports[1]) annotation(Line(points = {{-20, 86}, {-40, 86}, {-40, 86}, {-40, 86}}, color = {0, 127, 255}));
  connect(spl.port_1, bou.ports[2]) annotation(Line(points = {{0, 106}, {-42, 106}}, color = {0, 127, 255}));
  connect(fan1.port_b, bou.ports[1]) annotation(Line(points = {{-118, 80}, {-118, 106}, {-42, 106}}, color = {0, 127, 255}));
  connect(step3.y, VerbraucherPumpe1.y) annotation(Line(points = {{85, -228}, {92, -228}, {92, -228}, {101, -228}, {101, -208}, {99, -208}}, color = {0, 0, 127}));
  connect(step1.y, VerbraucherPumpe2.y) annotation(Line(points = {{-55, -224}, {-9, -224}, {-9, -210}, {-11, -210}}, color = {0, 0, 127}));
  connect(spl4.port_2, fan.port_b) annotation(Line(points = {{-32, -76}, {-82, -76}, {-82, 60}, {-82, 60}}, color = {0, 127, 255}));
  connect(const.y, fan.y) annotation(Line(points = {{-153, 96}, {-125.5, 96}, {-125.5, 70}, {-94, 70}}, color = {0, 0, 127}));
  connect(fan1.y, const.y) annotation(Line(points = {{-130, 70}, {-143.5, 70}, {-143.5, 96}, {-153, 96}}, color = {0, 0, 127}));
  connect(step2.y, ErzeugerPumpe.y) annotation(Line(points = {{-33, 182}, {1, 182}, {1, 172}, {-1, 172}, {-1, 174}}, color = {0, 0, 127}));
  connect(res2Vor.port_b, fan1.port_a) annotation(Line(points = {{-108, -98}, {-118, -98}, {-118, 60}}, color = {0, 127, 255}));
  connect(spl1.port_2, WidPrimRueck.port_a) annotation(Line(points = {{0, 86}, {138, 86}, {138, -12}}, color = {0, 127, 255}));
  connect(spl.port_2, WidPrimVor.port_a) annotation(Line(points = {{20, 106}, {172, 106}, {172, -12}}, color = {0, 127, 255}));
  connect(res2Vor.port_a, spl5.port_2) annotation(Line(points = {{-88, -98}, {-6, -98}, {-6, -98}, {-6, -98}}, color = {0, 127, 255}));
  connect(spl4.port_1, res1Rueck.port_b) annotation(Line(points = {{-12, -76}, {30, -76}, {30, -76}, {30, -76}}, color = {0, 127, 255}));
  connect(res1Rueck.port_a, spl2.port_2) annotation(Line(points = {{50, -76}, {80, -76}, {80, -76}, {80, -76}}, color = {0, 127, 255}));
  connect(spl5.port_1, res1Vor.port_b) annotation(Line(points = {{14, -98}, {30, -98}, {30, -98}, {30, -98}}, color = {0, 127, 255}));
  connect(res1Vor.port_a, spl3.port_2) annotation(Line(points = {{50, -98}, {110, -98}, {110, -98}, {110, -98}}, color = {0, 127, 255}));
  annotation(uses(Buildings(version = "3.0.0"), Modelica(version = "3.2.1")), Diagram(coordinateSystem(extent = {{-300, -250}, {300, 250}})), version = "", experiment(StartTime = 0, StopTime = 86400, Tolerance = 1e-06, Interval = 60));
end Heizkreis3_Widerstand;