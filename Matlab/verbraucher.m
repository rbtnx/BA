clear;
load('/home/kathrin/Uni/BA/Fette Daten/input_rawdata_fixed.mat');
load('/home/kathrin/Uni/BA/Fette Daten/output_rawdata_fixed.mat');

V1 = output.c0044(1:309480) - output.c0062(1:309480);    % (4) - (5)
V2 = output.c0070(1:309480) - output.c0044(1:309480);    % (13) - (4)
V3 = output.c0178(1:309480) - output.c0070(1:309480);    % (12) - (13)
V4 = output.c0196(1:309480) - output.c0178(1:309480);    % (10) - (12)
V5 = output.c0062(1:309480) - output.c0196(1:309480);    % (5) - (10)

