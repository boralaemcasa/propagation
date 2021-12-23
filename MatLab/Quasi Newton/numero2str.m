function [y] = numero2str(x)
  y = x(1);
  for i = 2:length(x)
      y = y + " & " + string(x(i));
  end
  y = y + " \\";
end