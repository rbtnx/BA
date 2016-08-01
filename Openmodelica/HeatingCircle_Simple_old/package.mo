package HeatingCircle_Simple


  model Heizkreis2
  Buildings.Fluid.Movers.SpeedControlled_y ErzeugerPumpe(redeclare package Medium = Buildings.Media.Water, per.pressure(V_flow = {0.0003, 0.0006, 0.0008}, dp = {45, 35, 15} * 1000)) annotation(Placement(visible = true, transformation(origin = {0, 82}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM WidPrimVor(redeclare package Medium = Buildings.Media.Water, dp_nominal = 1500, m_flow_nominal = 0.2) annotation(Placement(visible = true, transformation(origin = {172, -22}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM WidPrimRueck(redeclare package Medium = Buildings.Media.Water, dp_nominal = 1000, m_flow_nominal = 0.2) annotation(Placement(visible = true, transformation(origin = {138, -22}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM spl(redeclare package Medium = Buildings.Media.Water, dp_nominal = {200, -200, 200}, m_flow_nominal = {0.2, -0.2, -0.2}) annotation(Placement(visible = true, transformation(origin = {10, 26}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM spl1(redeclare package Medium = Buildings.Media.Water, dp_nominal = {1, -1, -1} * 200, m_flow_nominal = {0.2, -0.2, -0.2}) annotation(Placement(visible = true, transformation(origin = {-10, 6}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
    Buildings.Fluid.Movers.SpeedControlled_y fan(redeclare package Medium = Buildings.Media.Water, per.pressure(V_flow = {0.0003, 0.0006, 0.0008}, dp = {45, 35, 15} * 1000)) annotation(Placement(visible = true, transformation(origin = {-60, -38}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Buildings.Fluid.Movers.SpeedControlled_y fan1(redeclare package Medium = Buildings.Media.Water, per.pressure(V_flow = {0.0003, 0.0006, 0.0008}, dp = {45, 35, 15} * 1000)) annotation(Placement(visible = true, transformation(origin = {-118, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
    Modelica.Blocks.Sources.Constant const(k = 0.3) annotation(Placement(visible = true, transformation(origin = {-158, -38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Buildings.Fluid.Sources.Boundary_pT bou(redeclare package Medium = Buildings.Media.Water, nPorts = 2, p = 200000) annotation(Placement(visible = true, transformation(origin = {182, -98}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
    Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM spl2(redeclare package Medium = Buildings.Media.Water, dp_nominal = {1, -1, 1} * 200, m_flow_nominal = {0.2, -0.2, 0.2}) annotation(Placement(visible = true, transformation(origin = {90, -76}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
    Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM spl3(redeclare package Medium = Buildings.Media.Water, dp_nominal = {1, -1, -1} * 200, m_flow_nominal = {0.2, -0.2, -0.2}) annotation(Placement(visible = true, transformation(origin = {120, -98}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Buildings.Fluid.Sources.Boundary_pT bou1(redeclare package Medium = Buildings.Media.Water, nPorts = 2) annotation(Placement(visible = true, transformation(origin = {-70, -68}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Buildings.Fluid.Movers.SpeedControlled_y VerbraucherPumpe1(redeclare package Medium = Buildings.Media.Water, per.pressure(V_flow = {0.0003, 0.0006, 0.0008}, dp = {45, 35, 15} * 1000)) annotation(Placement(visible = true, transformation(origin = {106, -146}, extent = {{10, 10}, {-10, -10}}, rotation = 0)));
  Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM spl4(redeclare package Medium = Buildings.Media.Water, dp_nominal = {1, -1, 1} * 200, m_flow_nominal = {0.2, -0.2, 0.2}) annotation(Placement(visible = true, transformation(origin = {-22, -76}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM spl5(redeclare package Medium = Buildings.Media.Water, dp_nominal = {1, -1, -1} * 200, m_flow_nominal = {0.2, -0.2, -0.2}) annotation(Placement(visible = true, transformation(origin = {4, -98}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM res1Rueck(redeclare package Medium = Buildings.Media.Water, dp_nominal = 750, m_flow_nominal = 0.2)  annotation(Placement(visible = true, transformation(origin = {40, -76}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM res1Vor(redeclare package Medium = Buildings.Media.Water, dp_nominal = 500, m_flow_nominal = 0.2)  annotation(Placement(visible = true, transformation(origin = {40, -98}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Buildings.Fluid.Movers.SpeedControlled_y VerbraucherPumpe2(redeclare package Medium = Buildings.Media.Water, per.pressure(V_flow = {0.0003, 0.0006, 0.0008}, dp = {45, 35, 15} * 1000)) annotation(Placement(visible = true, transformation(origin = {-10, -144}, extent = {{10, 10}, {-10, -10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step1(startTime = 60000)  annotation(Placement(visible = true, transformation(origin = {-66, -170}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM res2Vor(redeclare package Medium = Buildings.Media.Water, dp_nominal = 500, m_flow_nominal = 0.2)  annotation(Placement(visible = true, transformation(origin = {-98, -98}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step2(startTime = 0)  annotation(Placement(visible = true, transformation(origin = {-44, 104}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step3(startTime = 40000)  annotation(Placement(visible = true, transformation(origin = {80, -178}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(step3.y, VerbraucherPumpe1.y) annotation(Line(points = {{92, -178}, {106, -178}, {106, -158}, {106, -158}}, color = {0, 0, 127}));
    connect(step2.y, ErzeugerPumpe.y) annotation(Line(points = {{-32, 104}, {0, 104}, {0, 94}, {0, 94}}, color = {0, 0, 127}));
    connect(res2Vor.port_b, fan1.port_a) annotation(Line(points = {{-108, -98}, {-118, -98}, {-118, -20}, {-118, -20}}, color = {0, 127, 255}));
    connect(res2Vor.port_a, spl5.port_2) annotation(Line(points = {{-88, -98}, {-6, -98}, {-6, -98}, {-6, -98}}, color = {0, 127, 255}));
    connect(step1.y, VerbraucherPumpe2.y) annotation(Line(points = {{-54, -170}, {-10, -170}, {-10, -156}, {-10, -156}}, color = {0, 0, 127}));
    connect(spl4.port_3, VerbraucherPumpe2.port_b) annotation(Line(points = {{-22, -86}, {-20, -86}, {-20, -144}}, color = {0, 127, 255}));
    connect(spl5.port_3, VerbraucherPumpe2.port_a) annotation(Line(points = {{4, -108}, {4, -144}, {0, -144}}, color = {0, 127, 255}));
    connect(spl4.port_2, bou1.ports[2]) annotation(Line(points = {{-32, -76}, {-60, -76}, {-60, -68}, {-60, -68}}, color = {0, 127, 255}));
    connect(spl4.port_1, res1Rueck.port_b) annotation(Line(points = {{-12, -76}, {30, -76}, {30, -76}, {30, -76}}, color = {0, 127, 255}));
    connect(res1Rueck.port_a, spl2.port_2) annotation(Line(points = {{50, -76}, {80, -76}, {80, -76}, {80, -76}}, color = {0, 127, 255}));
    connect(spl5.port_1, res1Vor.port_b) annotation(Line(points = {{14, -98}, {30, -98}, {30, -98}, {30, -98}}, color = {0, 127, 255}));
    connect(res1Vor.port_a, spl3.port_2) annotation(Line(points = {{50, -98}, {110, -98}, {110, -98}, {110, -98}}, color = {0, 127, 255}));
    connect(fan.port_a, bou1.ports[1]) annotation(Line(points = {{-60, -48}, {-60, -68}}, color = {0, 127, 255}));
    connect(spl1.port_3, ErzeugerPumpe.port_a) annotation(Line(points = {{-10, 16}, {-10, 16}, {-10, 82}, {-10, 82}}, color = {0, 127, 255}));
    connect(spl.port_3, ErzeugerPumpe.port_b) annotation(Line(points = {{10, 36}, {10, 36}, {10, 82}, {10, 82}}, color = {0, 127, 255}));
    connect(spl.port_2, WidPrimVor.port_a) annotation(Line(points = {{20, 26}, {172, 26}, {172, -12}, {172, -12}}, color = {0, 127, 255}));
    connect(spl1.port_2, WidPrimRueck.port_a) annotation(Line(points = {{0, 6}, {138, 6}, {138, -12}}, color = {0, 127, 255}));
    connect(fan.port_b, spl1.port_1) annotation(Line(points = {{-60, -28}, {-60, 6}, {-20, 6}}, color = {0, 127, 255}));
    connect(WidPrimVor.port_b, bou.ports[1]) annotation(Line(points = {{172, -32}, {172, -98}}, color = {0, 127, 255}));
    connect(WidPrimRueck.port_b, spl2.port_1) annotation(Line(points = {{138, -32}, {138, -76}, {100, -76}}, color = {0, 127, 255}));
    connect(fan1.port_b, spl.port_1) annotation(Line(points = {{-118, 0}, {-118, 26}, {0, 26}}, color = {0, 127, 255}));
    connect(fan1.y, const.y) annotation(Line(points = {{-130, -10}, {-136, -10}, {-136, -38}, {-147, -38}}, color = {0, 0, 127}));
    connect(spl3.port_3, VerbraucherPumpe1.port_a) annotation(Line(points = {{120, -108}, {120, -108}, {120, -108}, {120, -108}, {120, -146}, {118, -146}, {118, -146}, {116, -146}, {116, -146}}, color = {0, 127, 255}));
    connect(VerbraucherPumpe1.port_b, spl2.port_3) annotation(Line(points = {{96, -146}, {90, -146}, {90, -86}, {90, -86}}, color = {0, 127, 255}));
    connect(spl3.port_1, bou.ports[2]) annotation(Line(points = {{130, -98}, {172, -98}}, color = {0, 127, 255}));
    connect(const.y, fan.y) annotation(Line(points = {{-147, -38}, {-72, -38}}, color = {0, 0, 127}));
    annotation(uses(Buildings(version = "3.0.0"), Modelica(version = "3.2.1")), Diagram(coordinateSystem(extent = {{-200, -200}, {200, 200}})), version = "", experiment(StartTime = 0, StopTime = 86400, Tolerance = 1e-06, Interval = 60));
  end Heizkreis2;
end HeatingCircle_Simple;