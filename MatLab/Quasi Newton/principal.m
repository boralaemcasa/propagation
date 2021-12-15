clc
clear

%exp6

RUN6(-0.0263, 1)
RUN6(0, 0)
RUN6(0, 1)
RUN6(0.0263, 0)

%exp1
disp('Experimento 1')
RUN1(1, 0, 0, [9;9])
RUN1(1, 0, 1, [-3;2])
RUN1(1, 0, 0, [-8;-6])
RUN1(1, 0, 1, [5;-7])

RUN1(2, 0, 1, 0)
RUN1(2, 0, 0, 0)

RUN1(3, sqrt(2), 0, 0)
RUN1(3, sqrt(2), 1, 0)

%exp2
disp('Experimento 2')
RUN1(2, -0.0263, 0, 0)
RUN1(2, -0.0263, 1, 0)

RUN1(2, 0.0263, 0, 0)
RUN1(2, 0.0263, 1, 0)

RUN1(2, 1, 0, 0)
RUN1(2, 1, 1, 0)

%exp3
disp('Experimento 3')
RUN3(5)
RUN3(10)
RUN3(15)
RUN3(20)
RUN3(25)

%exp4
disp('Experimento 4')
RUN1(4, 0, 1, [-6;-5])
RUN1(4, 0, 0, [-6;-5])

RUN1(1, 0.0263, 1, 0)
RUN1(1, 0.0263, 0, 0)

%exp5
disp('Experimento 5')
RUN1(5, 0, 1, [9;9])
RUN1(5, 0, 0, [9;9])
