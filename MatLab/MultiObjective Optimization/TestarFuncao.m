function [RETORNO] = TestarFuncao(f)
    disp(f);
    Global = GlobalClass;
    Global.D = 2;
    input = 9;
    v = feval(f, 'init',Global,input);
    v
    Global = GlobalClass;
    Global.D = 45;
    Global.M = 2;
    Global.upper = 10;
    Global.lower = 0;
    if f == "MaF8"
        input = ones(45,2);
    else
        input = ones(45,45);
    end
    [i, obj, con] = feval(f, 'value',Global,input);
    i
    obj
    con
    Global = GlobalClass;
    Global.M = 6;
    %input = ones(6,6);
    input = 10;
    v = feval(f, 'PF',Global,input);
    v
    Global = GlobalClass;
    input = ones(6,6);
    feval(f, 'draw',Global,input);
end