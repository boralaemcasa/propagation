classdef GlobalClass
   properties
      N
      M
   end
   methods
      function pop = Initialization(obj)
          for i = 1:obj.N
               for j = 1:obj.M
                   pop(i,j) = rand;
               end
          end
      end
      function flag = NotTermination(obj, Population)
          flag = (rand < 0.5);
      end
      function variation = Variation(obj, Population, x)
          s = size(Population);
          if rem(s(2), 2) == 1
              s(2) = s(2) + 1;
              Population(1, s(2)) = 0;
          end
          variation = reshape(Population, s(2)/obj.M, s(1)*obj.M);
      end
   end
end