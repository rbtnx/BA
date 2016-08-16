clear;
load('/home/kathrin/Uni/BA/Fette Daten/input_fixed.mat');
load('/home/kathrin/Uni/BA/Fette Daten/output_fixed.mat');

V1 = output_fixed.c0044(1:309480) - output_fixed.c0062(1:309480);    % (4) - (5)
V2 = output_fixed.c0070(1:309480) - output_fixed.c0044(1:309480);    % (13) - (4)
V3 = output_fixed.c0178(1:309480) - output_fixed.c0070(1:309480);    % (12) - (13)
V4 = output_fixed.c0196(1:309480) - output_fixed.c0178(1:309480);    % (10) - (12)
V5 = output_fixed.c0062(1:309480) - output_fixed.c0196(1:309480);    % (5) - (10)